# Mathlib Analogist Report

## Mode
api-alignment

## Slug
quotscheme-isbasechange-tilde

## Iteration
187

## Question

How does Mathlib idiomatically prove `IsBaseChange` for sections of a
module-sheaf pullback over a pair of affine opens — i.e. for the
project's `pullback_app_isoTensor_baseMap_isBaseChange` — without
requiring `N` to be quasi-coherent? Is `Module.Flat.isBaseChange`
(Stacks 02KE) the cheaper route?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. `Module.Flat.isBaseChange` as `IsBaseChange` producer | divergent-and-wrong → DROP | **critical** |
| 2. Tilde-isoTop route as the conceptual approach | correct + needs `pullback_tildeIso` project gap-fill | high |
| 3. `[IsQuasicoherent F]` hypothesis threading | ALIGN_WITH_MATHLIB | **critical** |
| 4. `PresheafOfModules.pullback` as a cheaper alternative | not cheaper; PROCEED | informational |

## Must-fix-this-iter

- **Decision 1 — drop the `Module.Flat.isBaseChange` framing.** This
  lemma at `Mathlib/RingTheory/Flat/Stability.lean:90` has the signature

      Module.Flat.isBaseChange : ∀ R S M [Module.Flat R M] (N) {f : M →ₗ[R] N},
        IsBaseChange S f → Module.Flat S N

  It is a **stability** statement (Stacks 00H8, "flatness is preserved
  under base change"), taking `IsBaseChange` as a **hypothesis** and
  producing `Module.Flat S N` as a **conclusion**. It cannot produce
  the `IsBaseChange` witness on the project's `baseMap`. The directive's
  framing that "`Module.Flat.isBaseChange` … on the affine ring map
  `g.appLE V U e` is the cheaper route" is a category mistake. Affected
  files / sites that currently carry this wrong framing:
  - `AlgebraicJacobian/Picard/QuotScheme.lean:543-584` — the docstring of
    `pullback_app_isoTensor_baseMap_isBaseChange` mentions Stacks 02KE
    + flat-base-change as the substantive content of the Prop; the prose
    is conceptually right (Stacks 02KE = "tensor with flat module preserves
    exactness", which is downstream of identifying the section as a tensor
    product). It does NOT currently mention `Module.Flat.isBaseChange` —
    OK there.
  - `AlgebraicJacobian/Picard/QuotScheme.lean:632-689` — the docstring of
    `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`
    DOES say: "the *actual application* of `Module.Flat.isBaseChange`
    after the section-vs-tensor-product identification … the algebraic
    flat base change of `Module.Flat.isBaseChange` produces a linear iso
    `Γ(S', U) ⊗_{Γ(S, ⊤)} Γ(F, f⁻¹⊤) ≃ Γ((g')*F, f' ⁻¹ᵁ U)`". **This
    sentence is wrong.** `Module.Flat.isBaseChange` does not produce
    that iso — it just propagates flatness across it. Rewrite the
    docstring to remove the `Module.Flat.isBaseChange` reference; the
    iso comes from the LHS helper `pullback_app_isoTensor` alone, then
    Beck-Chevalley compatibility, then `IsBaseChange.equiv`.

- **Decision 3 — thread `[F.IsQuasicoherent]` through the consumer chain.**
  Stacks 02KH (the cohomology base-change statement at L840 of QuotScheme.lean)
  requires `F` to be quasi-coherent. The current signatures of
  `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`,
  `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen`,
  `canonicalBaseChangeMap_app_app_isIso_of_affineCover`,
  `canonicalBaseChangeMap_app_app_isIso`, `canonicalBaseChangeMap_isIso`,
  and `flatBaseChangeCohomology` all carry `(F : X.Modules)` with no
  quasi-coherence hypothesis. **At the current generality, the Stacks 02KH
  conclusion is FALSE** — there are non-quasi-coherent counterexamples.
  Add `[F.IsQuasicoherent]` (and to the inner Lane F helpers, the
  corresponding `[N.IsQuasicoherent]` where `N = (pushforward f).obj F`).
  Mathlib's `IsQuasicoherent` lives at
  `Mathlib/Algebra/Category/ModuleCat/Sheaf/Quasicoherent.lean:249`.

## Major

- **Decision 2 — the Tilde-isoTop route is correct, but the load-bearing
  connector "pullback of tilde = tilde of base change" is a Mathlib gap.**
  Mathlib has every foundational piece for the route:
  - `AlgebraicGeometry.tilde` (`Mathlib/AlgebraicGeometry/Modules/Tilde.lean:87`)
  - `tilde.isoTop` (`Tilde.lean:177`) giving `M ≅ Γ(tilde M, ⊤)`
  - `tilde.adjunction` (`Tilde.lean:279`) with unit an iso, hence tilde
    fully faithful (`Tilde.lean:312`)
  - `isIso_fromTildeΓ_iff` (`Tilde.lean:340-342`) characterizing
    essential image
  - `TensorProduct.isBaseChange` (`Mathlib/RingTheory/IsTensorProduct.lean:363`)
  - `IsBaseChange.ofEquiv` for the transport step.

  But Mathlib has **no** lemma producing
  `(Scheme.Modules.pullback (Spec.map φ)).obj (tilde M) ≅ tilde (B ⊗_A M)`
  for `φ : A → B`. Direct LSP search (`pullback.*tilde`, `tilde.*pullback`,
  `baseChange.*tilde`) returns no matches. The only pullback formula in
  Mathlib's pullback machinery is `pullbackObjFreeIso` for **free**
  sheaves (`PullbackFree.lean:122`, additionally requiring `F.Final` of
  the underlying functor — too restrictive).

  This means the iter-186 plan to discharge
  `pullback_app_isoTensor_baseMap_isBaseChange` via the Tilde route is
  conceptually sound, but the body is a genuine ~115-200 LOC project
  sub-build (matching the iter-186 estimate). The single typed sorry
  should NOT sit on `IsBaseChange (baseMap)` directly — it should sit
  on a named sub-helper `pullback_tildeIso` that captures the genuine
  Mathlib gap. Then `pullback_app_isoTensor_baseMap_isBaseChange` closes
  axiom-clean via `IsBaseChange.ofEquiv` ∘ `TensorProduct.isBaseChange`
  through the named iso.

## Informational

- **Decision 4 — `PresheafOfModules.pullback` is not cheaper.** Both
  `SheafOfModules.pullback` (`Mathlib/Algebra/Category/ModuleCat/Sheaf/PullbackContinuous.lean:53`)
  and `PresheafOfModules.pullback` (`Mathlib/Algebra/Category/ModuleCat/Presheaf/Pullback.lean:44`)
  are defined as `(pushforward φ).leftAdjoint` via partial-adjoint
  machinery. Neither has a closed-form section lemma. The
  `sheafificationCompPullback` iso (`PullbackContinuous.lean:117`)
  says pullback commutes with sheafification, which is categorical
  data but doesn't expose sections. The presheaf route doesn't avoid
  the Tilde gap — it just moves it.

- **Secondary Mathlib gap surfaced by Decision 3.** Mathlib at the
  pinned commit does NOT have `IsQuasicoherent.pushforward` (an
  instance / lemma propagating quasi-coherence through `pushforward f`
  under qcqs `f`). Stacks 01XJ. The consumer
  `_of_isAffineOpen_of_isAffineBase` needs this to derive
  `((pushforward f).obj F).IsQuasicoherent` from `[F.IsQuasicoherent]`
  + `[QuasiCompact f]` + `[QuasiSeparated f]`. Estimated ~30 LOC
  project-side helper if Mathlib doesn't pick it up first.

## Concrete recommendation (Lane F prover directive)

If the iter-187 plan assigns a Lane F prover, the directive should be:

1. **Edit `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase`
   docstring** (QuotScheme.lean:632-655) — remove the
   `Module.Flat.isBaseChange` framing. Replace with "the iso
   `Γ(S', U) ⊗_{Γ(S, ⊤)} Γ(F, f⁻¹⊤) ≃ Γ((g')*F, f' ⁻¹ᵁ U)` is the
   `.symm` of `(pullback_app_isoTensor g' …).symm`; the residual gap
   is Beck-Chevalley compatibility plus the section identification's
   substantive Tilde-isoTop content."

2. **Thread `[F.IsQuasicoherent]` / `[N.IsQuasicoherent]` through:**
   - `pullback_app_isoTensor_baseMap_isBaseChange` (L563)
   - `pullback_app_isoTensor_isBaseChange` (L588)
   - `Scheme.Modules.pullback_app_isoTensor` (L615)
   - `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase` (L656)
   - `canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen` (L717)
   - `canonicalBaseChangeMap_app_app_isIso_of_affineCover` (L758)
   - `canonicalBaseChangeMap_app_app_isIso` (L808)
   - `canonicalBaseChangeMap_isIso` (L831)
   - `flatBaseChangeCohomology` (L840)

   This is ~5-10 LOC of signature changes, no proof bodies touched.

3. **Body of `pullback_app_isoTensor_baseMap_isBaseChange`** stays as
   typed sorry this iter, but factor the sorry into a NAMED helper
   `pullback_tildeIso` (project-side; signature ~5 LOC, body sorry).
   That helper captures the genuine Mathlib gap. Then the IsBaseChange
   Prop closes axiom-clean via `IsBaseChange.ofEquiv` once the helper
   is in place. This keeps the iter-186 "one typed sorry, named and
   reusable" pattern.

If the iter-187 plan does NOT assign a Lane F prover, the work above
should at minimum be applied to the docstring (item 1) so the next
iter's planner reads accurate Mathlib citations. Items 2 and 3 require
a prover round and ~30-40 LOC of structural edits.

## Persistent file
- `analogies/quotscheme-isbasechange-tilde.md` — design rationale
  captured for future iters, with all Mathlib citations + line numbers.

Overall verdict: the Tilde-isoTop route is correct, but the directive's
`Module.Flat.isBaseChange` alternative is a category mistake (it's a
stability statement, not an IsBaseChange producer) and the consumer
chain is missing the `[IsQuasicoherent F]` hypothesis Stacks 02KH
genuinely requires.
