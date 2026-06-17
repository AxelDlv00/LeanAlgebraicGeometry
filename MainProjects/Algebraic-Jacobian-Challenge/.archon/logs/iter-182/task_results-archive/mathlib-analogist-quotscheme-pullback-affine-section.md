# Mathlib Analogist Report

## Mode
api-alignment

## Slug
quotscheme-pullback-affine-section

## Iteration
182

## Question

For a morphism `g : S' ⟶ S` of schemes, `N : S.Modules`, and an
affine open `U : S'.Opens`, is there a Mathlib lemma identifying
`Γ((Scheme.Modules.pullback g).obj N, U)` with
`Γ(S', U) ⊗_{Γ(S, V)} Γ(N, V)` for any compatible affine `V ⊆ S`?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Pullback affine-open section formula | NEEDS_MATHLIB_GAP_FILL → BUILD_PROJECT_HELPER | critical |
| 2. `IsBaseChange.equiv` consumer-side packaging | PROCEED | informational |
| 3. Base-side Mayer-Vietoris reduction (general `S`) | NEEDS_MATHLIB_GAP_FILL → BUILD_PROJECT_HELPER | high |

## Informational

**Decision 1 (load-bearing).** Mathlib's `Scheme.Modules.pullback g`
(`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:167`) is defined abstractly
as `SheafOfModules.pullback f.toRingCatSheafHom`, which is itself
`(pushforward φ).leftAdjoint` built via partial-adjoint machinery
(`Mathlib/Algebra/Category/ModuleCat/Sheaf/PullbackContinuous.lean:53`).
There is no `pullback_obj_obj` simp lemma analogous to
`pushforward_obj_obj`. The only closed-form section lemma is
`SheafOfModules.pullbackObjFreeIso`
(`Mathlib/Algebra/Category/ModuleCat/Sheaf/PullbackFree.lean:122`),
which only handles FREE sheaves — too restrictive for a general
`N : S.Modules`. The `pullbackIso` and `sheafificationCompPullback`
isos factor the pullback through sheafification, which destroys
per-affine-open identification. The presheaf-level pullback
(`PresheafOfModules.pullback`,
`Mathlib/Algebra/Category/ModuleCat/Presheaf/Pullback.lean:44`) is
ALSO abstract — also a partial-adjoint, also no closed-form sections —
so collapsing the proof through the presheaf level does NOT help.
The blueprint already identifies this as a project-side bridge
(`blueprint/src/chapters/Picard_QuotScheme.tex:851–856`). LSP searches
for Stacks 02KH / 02KE / 00H8 in Mathlib return only one unrelated hit
(`Mathlib/RingTheory/IntegralClosure/GoingDown.lean:47:@[stacks 00H8]`).

**Decision 2.** `IsBaseChange.equiv` (`Mathlib/RingTheory/IsTensorProduct.lean:375`)
is the canonical consumer for the iso once the LHS bridge of Decision 1
lands. `Module.Flat.isBaseChange` (`Mathlib/RingTheory/Flat/Stability.lean:90`)
preserves flatness but does not supply the iso. The chain
`Flat.flat_appLE → Module.Flat.isBaseChange → IsBaseChange.equiv.symm`
gives the affine-base iso in ~3–5 LOC once Decision 1's helper exists.

**Decision 3.** Mathlib has `Scheme.Modules.Hom.isIso_iff_isIso_app`
(`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:131-135`) which reduces
to "iso on every open" but not "iso on affine basis". The project's
own `_of_affineCover` (a sorry in `QuotScheme.lean`) is the *target-side*
dual of the missing *base-side* helper — both are project-side gaps.
The cleanest route is a general-purpose
`Scheme.Modules.Hom.isIso_iff_isIso_app_isAffineOpen` (~40–70 LOC) that
subsumes both directions.

## Recommendation: DO NOT dispatch a prover lane on `_of_isAffineOpen_of_isAffineBase` this iter

The lane has produced 4 helpers / 2 iters / +1 sorry net — a textbook
"structural decomposition without a discharge tool" pattern. The body
of `_of_isAffineOpen_of_isAffineBase` cannot close until the load-bearing
project-side declaration exists. **Pivot the lane**: dispatch a prover
lane this iter to CREATE the named project-side helper

```lean
noncomputable def Scheme.Modules.pullback_app_isoTensor
    {X Y : Scheme.{u}} (g : Y ⟶ X) (N : X.Modules)
    {U : Y.Opens} {V : X.Opens}
    (hU : IsAffineOpen U) (hV : IsAffineOpen V)
    (e : U ≤ (Opens.map g.base).obj V) :
    Γ((Scheme.Modules.pullback g).obj N, U) ≃ₗ[Γ(Y, U)]
      TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V) := sorry
```

(or the corresponding `IsBaseChange` packaging) with a typed `sorry` body
in `AlgebraicJacobian/Picard/QuotScheme.lean` or a new helper file
`AlgebraicJacobian/Picard/PullbackAffineSections.lean`.

Once the declaration *exists* (sorry-bodied), `_of_isAffineOpen_of_isAffineBase`
collapses to ~15–25 LOC of book-keeping (compose with
`pushforward_pullback_section_eq_pullback_section` + `IsBaseChange.equiv`
+ Beck-Chevalley comparison). The lane stops accumulating peripheral
helpers; the substantive sorry is **named and reusable**.

The actual body of `pullback_app_isoTensor` (~120–200 LOC) is iter-183+
work — it requires the Tilde route (`Mathlib/AlgebraicGeometry/Modules/Tilde.lean`)
or direct exhibition via the universal property of the adjunction. This
is the genuine substantive build; it is plausibly Mathlib PR material
(structurally analogous to
`analogies/kaehler-tensorequiv-presheafpullback.md`, which faced the same
"pullback of presheaves of modules has no section-formula" gap in the
differentials setting).

## Persistent file
- `analogies/quotscheme-pullback-affine-section.md` — full design
  rationale captured for future iters: precedents table, cost estimates,
  comparison with Mathlib `pullbackObjFreeIso`/`pullbackIso`/Tilde/
  `IsBaseChange.equiv`, and the explicit recommendation to pivot to a
  helper-creation lane rather than another decomposition lane.

Overall verdict: the lane is genuinely blocked on a Mathlib gap; the
right iter-182 move is to introduce the load-bearing project-side
declaration as a named sorry, not to dispatch another decomposition
helper around `_of_isAffineOpen_of_isAffineBase`.
