# Analogy: `ψ*(M̃) ≅ (extendScalars ψ M)~` and its base-change cocycle — does Mathlib have it?

## Mode
api-alignment

## Slug
fbc-tilde-pullback-naturality

## Iteration
031

## Question
(1) Does Mathlib's `AlgebraicGeometry/Modules/Tilde.lean` (or `Spec`/`pullback`/`extendScalars`
API) expose the comparison `ψ*(M̃) ≅ (extendScalars ψ M)~` AND its composition/naturality coherence
as `tilde.map` of an explicit algebra-module map — making the geometric `pullbackComp` route
`tilde`-FUNCTORIAL by construction (no `Γ(pullbackComp)` element eval)?
(2) Is there a Mathlib base-change-cocycle idiom (`extendScalars`/`restrictScalars` adjunction,
`Algebra.TensorProduct` assoc, `IsBaseChange`, comm-ring `pushout`) the project should align
`pullback_spec_tilde_iso` to, instead of hand-deriving sheaf-level naturality? Parallel API?
(3) If neither: `[gap]`.

## Project artifact(s)
- `FlatBaseChange.lean:879` — `pullback_spec_tilde_iso φ M` = `((conjugateIsoEquiv adjL adjR).symm
  (gammaPushforwardNatIso φ)).symm.app M`. NOT `tilde.map` of an algebra map.
- `FlatBaseChange.lean:1937` — `pullbackSpecTildeNatIso φ : tilde.functor R ⋙ pullback (Spec.map φ)
  ≅ extendScalars φ.hom ⋙ tilde.functor R'` (the single-map dictionary, functor level).
- `FlatBaseChange.lean:1349/1373` — geometric `chartBaseChangeGeometricComparison` (built from
  `Scheme.Modules.pullbackComp` of `Spec.map`s) vs algebraic `chartBaseChangeModuleReassoc` (built
  from `ModuleCat.extendScalarsComp` ×2 + `eqToIso`).
- `FlatBaseChange.lean:2452` — `..._ring_square_natural_concrete`; lone open `sorry` @2508 =
  `tilde.preimage(geometric leg) = chartBaseChangeModuleReassoc` in `ModuleCat (R'⊗[A]B)`.
- `FlatBaseChange.lean:2339` — `pullbackSpecTilde_ringSquare_vcomp_glue` (Route A, `CatCommSq.vComp`
  cocycle, typed sorry).

## Decisions identified

### Decision 1: does Mathlib expose `ψ*(M̃) ≅ (extendScalars ψ M)~` (+ its coherence)?

- **Mathlib idiom**: NONE EXISTS. `[verified]` by exhaustive grep of the pinned Mathlib (`b80f227`,
  lean v4.30.0-rc2):
  - `AlgebraicGeometry/Modules/Tilde.lean` (421 lines, the WHOLE file) contains: `tilde` (L87),
    `tilde.map` (L136), `tilde.functor` (L167), `tilde.adjunction` (L279),
    `tilde.fullyFaithfulFunctor` (L312), `moduleSpecΓFunctor` (L50), and basic isos `tildeSelf`,
    `tildeFinsupp`, `presentationTilde`, quasicoherence. **The strings `pullback`, `extendScalars`,
    `restrictScalars`, `Spec.map` DO NOT APPEAR in the file.**
  - Across all of `Mathlib/AlgebraicGeometry/`, `tilde` and `pullback` **never co-occur in any
    file**. Across all of Mathlib, `tilde` and `extendScalars` **never co-occur**. The only Modules
    file mentioning `Spec` is Tilde.lean itself.
  - There is no Stacks-`01I9` (M̃-and-pullback) content anywhere in Mathlib.
- **Project's path**: `pullback_spec_tilde_iso` is wholly project-built, via the adjoint mate
  (`conjugateIsoEquiv`) of `gammaPushforwardNatIso` — NOT `tilde.map` of an algebra-module map, and
  there is no Mathlib coherence to reuse for its composition.
- **Gap**: divergent — but UNAVOIDABLY, because Mathlib has the gap. Not a parallel API.
- **Cost of divergence**: none vs Mathlib (nothing to align to). The cost is internal: the geometric
  leg is `tilde.preimage` of a `pullbackComp`-built morphism, so identifying it with `extendScalars`
  reassociation forces `Γ(pullbackComp)` evaluation — the documented per-decl kernel timeout
  (`gammaPushforwardIso_comp` wall). Mathlib gives NO `Γ(pullback (Spec.map f))(tilde M) ≅
  extendScalars f M` lemma to short-circuit it.
- **Verdict**: NEEDS_MATHLIB_GAP_FILL.

### Decision 2: is there a Mathlib base-change-cocycle idiom to align the naturality to?

- **Mathlib idiom — present on BOTH the algebraic and geometric sides SEPARATELY, but NOT bridged:**
  - Algebraic cocycle `[verified]`: `ModuleCat.extendScalarsComp` (ChangeOfRings.lean:996),
    `extendScalarsId` (:967), and a FULL pseudofunctor
    `CommRingCat.moduleCatExtendScalarsPseudofunctor` (Pseudofunctor.lean:61) with proved
    associativity `extendScalars_assoc'` (ChangeOfRings.lean:1045). Underlying tensor base-change:
    `Algebra.IsPushout.cancelBaseChange` (IsTensorProduct.lean:764, native `≃ₗ[S]`), `IsBaseChange`
    (:300), `TensorProduct.isPushout'`.
  - Geometric cocycle `[verified]`: `Scheme.Modules.pullbackComp` (Sheaf.lean:219), `pullbackId`
    (:200), `conjugateEquiv_pullbackComp_inv` (:238, `@[simp]`), and pullback-pseudofunctor
    associativity `pseudofunctor_associativity` (Sheaf.lean:246).
  - **The BRIDGE is the gap**: there is no Mathlib decl tying `Scheme.Modules.pullback (Spec.map f)`
    (geometric) to `ModuleCat.extendScalars f` (algebraic) through `tilde`. That bridge is exactly
    the project's `pullbackSpecTildeNatIso` (single map), and its composition coherence is the
    project's `pullbackSpecTilde_ringSquare_vcomp_glue` — neither exists upstream.
- **Project's path**: ALREADY aligned on the algebraic side (uses `extendScalarsComp`; could
  additionally consume the extendScalars pseudofunctor's `mapComp`). The naturality is hand-derived
  ONLY for the bridge, which has no Mathlib analogue — so it is not a redundant parallel API.
- **Gap**: identical on each side; the cross-side bridge is genuinely missing.
- **Verdict**: PROCEED (algebraic side aligned; bridge is a real gap-fill, re-scope per below).

## Recommendation

Both Q1 and Q2 resolve to **`[gap]`**: Mathlib has neither `ψ*(M̃) ≅ (extendScalars ψ M)~` nor any
coherence connecting the geometric `Spec`-pullback pseudofunctor to the algebraic `extendScalars`
pseudofunctor through `tilde`. The project is NOT duplicating a Mathlib API — it is filling a real
upstream hole (Stacks 01I9 part 1, "functorially").

Decisive consequence for the open `sorry` (`_concrete` @2508): **any route that evaluates
`tilde.preimage` of the geometric `pullbackComp`-built leg is structurally dead**, because Mathlib
offers no `Γ(pullback (Spec.map))(tilde) ≅ extendScalars` reduction to discharge it — confirming the
element/section wall is intrinsic, not a missing-lemma accident. Do not re-attempt it.

The Mathlib-aligned shape for the gap-fill is a **composition-cocycle on the project's own
single-map dictionary `pullbackSpecTildeNatIso`** — i.e. mirror the EXISTING two-sided coherence
(`extendScalars_assoc'` on the algebra side, `pseudofunctor_associativity`/`pullbackComp` on the geom
side) by gluing them through the proven single-map iso, NEVER expanding `Γ(pullbackComp)`. This is
exactly Route A's `pullbackSpecTilde_ringSquare_vcomp_glue` (via `CatCommSq.vComp`) and the
`gammaPushforwardNatIso` composition coherence (fbc-pst-pseudofunctor.md, Decision 2: pointwise
`rfl`, transported through `conjugateEquiv`). Rewrite the geometric leg via the single-map
dictionaries FIRST so each `Γ(pullback (Spec.map fᵢ))` becomes `extendScalars fᵢ` by the PROVEN
`pullback_spec_tilde_iso`, leaving the `pullbackComp` coherence to fold against `extendScalarsComp`
as a cocycle — no `tilde.preimage` of a composite is ever taken. If the heavy-carrier whnf budget on
that cocycle (the iter-024/030 wall) cannot be met, the FBC seed should be re-scoped to that single
cocycle lemma rather than re-attacking `_concrete`'s element identity.

Links: [[fbc-pst-pseudofunctor]] (the mate-composition API: `iterated_mateEquiv_conjugateEquiv`,
`conjugateEquiv_mateEquiv_vcomp`, `mateEquiv_conjugateEquiv_vcomp` — all verified present), [[fbc-fold-adjacency]]
(`CatCommSq` paste mechanism), [[fbc-base-change-square-transparent-module]] (`IsPushout.cancelBaseChange`
for the algebraic carrier), [[fbc-glue-carrier-whnf]] (the carrier-whnf budget wall).
