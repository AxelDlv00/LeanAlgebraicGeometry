# Mathlib Analogist Report

## Mode
api-alignment

## Slug
ts-design206

## Iteration
206

## Question
Is building the full `MonoidalCategory (Scheme.Modules X)` (whose only remaining gap is the
verified-absent `MonoidalClosed (PresheafOfModules R₀)`, needed for `whiskerLeft` stability of the
sheafification-localizing morphism property) the right Mathlib-aligned shape for obtaining only the
group law on LINE BUNDLES, or does Mathlib have a lighter idiom that yields the `AddCommGroup` on
line-bundle iso-classes WITHOUT the full monoidal (let alone monoidal-closed) structure on all modules?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| A. Full `MonoidalCategory`/`MonoidalClosed` on **all** modules as the group-law substrate | ALIGN_WITH_MATHLIB (restrict to flat/line-bundle scope) | critical |
| B. Group-law shape: hand-rolled quotient vs `Units (Skeleton C)` + invertibility predicate | ALIGN_WITH_MATHLIB / NEEDS_MATHLIB_GAP_FILL | major |

## Headline

**The project is over-building.** Mathlib's Picard group `CommRing.Pic R`
(`Mathlib.RingTheory.PicardGroup`) is `Units (Skeleton (ModuleCat R))` over a **fixed** ring — it
uses `ModuleCat.monoidalCategory`/`SymmetricCategory` (`Mathlib.Algebra.Category.ModuleCat.Monoidal.*`)
and needs **no sheafification, no localization, and no `MonoidalClosed`**. The invertibility carrier is a
Prop predicate `Module.Invertible R M` (PicardGroup.lean:78) — exactly what the project's
`IsLocallyTrivial` is described as ("the project-side stand-in for the missing Mathlib `IsInvertible`
predicate", LineBundlePullback.lean:106). The expensive `MonoidalClosed (PresheafOfModules R₀)` is only
forced because the project tries to prove `whiskerLeft : W g → W (F ◁ g)` for an **arbitrary** `F`. The
consumer only tensors **line bundles**, which are **flat** (in Mathlib `Module.Invertible ⇒ Projective`,
PicardGroup.lean:195–196), and for flat `F` the `whiskerLeft` fact is ordinary exactness —
`Module.Flat.lTensor_preserves_injective_linearMap` (used inside PicardGroup.lean:205–207; packaged as
`Module.Invertible.lTensor_bijective_iff`, PicardGroup.lean:223–229) plus right-exactness — **not**
internal-hom machinery. The directive's "elementwise exactness (needs flatness)" dead-end was a dead-end
only because the target was all modules; restricting scope to line bundles makes that flatness automatic.

## Must-fix-this-iter

- **Decision A — abandon the all-modules monoidal-closed route.** `TensorObjSubstrate.lean`:150
  (`monoidalCategory := sorry`) and the `isMonoidal_W_of_whiskerLeft`/`monoidalCategoryOfIsMonoidalW`
  transport (L399–454) that reduces the substrate to `whiskerLeft` for ARBITRARY `F` are aimed at the
  wrong target. The group law never consumes coherence (pentagon/triangle/hexagon) or closedness — the
  group axioms on iso-classes are *propositions* `Nonempty (… ≅ …)`. Do **not** commit a multi-file
  `MonoidalClosed (PresheafOfModules R₀)` sub-lane. Re-scope `whiskerLeft`/`tensorObj_restrict_iso`
  (L249) to FLAT `F` (line bundles), where it is elementary flat-exactness already in Mathlib.
  Cost of not doing so: a verified-absent, Mathlib-PR-scale internal-hom-over-varying-ring build, for
  structure the consumer discards.

## Major

- **Decision B — mirror `Units (Skeleton …)`, do not hand-roll the quotient group from scratch.**
  `addCommGroup_via_tensorObj` (`TensorObjSubstrate.lean`:339) and the RelPicFunctor L245–264 plan rebuild
  the quotient `AddCommGroup` via a global monoidal category + dual + `QuotientAddGroup` transport — a
  parallel API to Mathlib's `instCommGroupPic` = `Units` of the skeleton `CommMonoid`
  (`CategoryTheory.Skeleton.instCommMonoid`). Scheme-level Pic is genuinely absent from Mathlib
  (PicardGroup.lean TODO:59 lists "connect to invertible sheaves" as unbuilt), so a project construction
  is unavoidable — but it should mirror the *shape*: keep `IsLocallyTrivial` as the
  `Module.Invertible`-style Prop, and obtain the group as iso-classes/units of the **line-bundle
  subcategory**, assembled from existence-of-iso lemmas. Two concrete realizations, both bypassing the
  blocker:
    1. **Minimal (recommended first):** prove four existence-of-iso lemmas on `OnProduct` — assoc
       `(L⊗M)⊗N ≅ L⊗(M⊗N)`, unit `O⊗L ≅ L`, comm `L⊗M ≅ M⊗L`, inverse `exists_tensorObj_inverse`
       (L300, have it as scaffold) — each via the flat-restricted `tensorObj_restrict_iso`, then build
       `AddCommGroup` on the quotient directly. No `MonoidalCategory` instance, no coherence, no closed
       structure.
    2. **Packaged (cleaner long-term):** give the full subcategory of line bundles a symmetric monoidal
       structure (flat ⇒ `whiskerLeft` holds elementwise) and set `Pic := Units (Skeleton (LineBundles))`
       — Mathlib's `CommRing.Pic` idiom transported to schemes.

## Informational

- The one ingredient that is genuinely required even for line bundles is a **global** associator/unit
  iso (`tensorObj_restrict_iso`): local triviality alone does NOT give it — two sheaves both locally `≅ O`
  need not be globally iso (e.g. `O(1)` vs `O`). But for line bundles that global iso comes from the flat
  `whiskerLeft` fact, which is in Mathlib; it does not come from `MonoidalClosed`. So the substrate does
  not collapse to nothing — it collapses to flat-exactness.
- `Module.Invertible` instances confirm the rigidity that makes this work: invertible/line-bundle objects
  are dualizable (the dual `Mᵛ` is the inverse, `Pic.mk_dual`), so the relevant internal hom *of the
  object* exists even though the ambient category is not monoidal-closed — another way to see the
  closed-structure requirement is spurious for this lane.

## Persistent file
- `analogies/ts-design206.md` — design rationale (two decisions, citations, the flat-scope pivot) for future iters.

Overall verdict: the full `MonoidalCategory`/`MonoidalClosed`-on-all-modules path is over-building — the
line-bundle group law is Mathlib's `Units (Skeleton …)`/`Module.Invertible` idiom, and its one hard
ingredient reduces to elementary flat-exactness once scoped to line bundles, so the verified-absent
`MonoidalClosed (PresheafOfModules R₀)` sub-lane should not be opened.
