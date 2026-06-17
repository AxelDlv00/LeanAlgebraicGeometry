# mathlib-analogist dual252 — directive

## Mode: api-alignment

## Question
In `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`, the def `dual_restrict_iso`
(`(dual M).restrict f ≅ dual (M.restrict f)` for an open immersion `f : Y → X`, ~L228) has Steps 1–3 +
H1 closed axiom-clean and bottoms out in ONE residual presheaf-of-modules iso (sorry at ~L254):

```
(pushforward β).obj (PresheafOfModules.dual M.val)  ≅  PresheafOfModules.dual ((pushforward β).obj M.val)
```

where `β` is, sectionwise, the open-immersion ring iso `𝒪_X(fV) ≅ 𝒪_Y(V)`, and `PresheafOfModules.dual`
is the internal-hom dual `ℋom(–, 𝟙_)`. The intended tool is the CLOSED
`InternalHom.restrictScalarsRingIsoDualEquiv` (dual analogue of the `restrictScalarsMonoidalOfBijective`
tensorator that closed the H2 step of the parallel `tensorObj_restrict_iso`).

**Known NON-applicable route (do NOT re-suggest):** `Vestigial.overSliceSheafEquiv` — it is a Sheaf-category
equivalence with a FIXED value category, whereas this Step-4 residual is at the PRESHEAF level with a
VARYING per-section ring `𝒪_Y(V)` and finer slicing. The prover deliberately did not thrash this.

**Tell me:**
1. Does Mathlib have an idiom for "pushforward (along a sectionwise ring iso / restrictScalars of a ring
   equivalence) commutes with the internal-hom dual `ℋom(–,𝟙_)`" for `PresheafOfModules`? Search the
   `PresheafOfModules`, `ModuleCat.restrictScalars`, internal-hom / `linearYonedaObj` APIs.
2. What is the precise shape of the sectionwise `PresheafOfModules.isoMk` over the slice that the prover
   should build — how to reconcile the `𝒪_X(fV)`- vs `𝒪_Y(V)`-module structures on the two sides via
   `restrictScalarsRingIsoDualEquiv`, and which naturality field is load-bearing? Mirror the structure of
   the closed H2 step of `tensorObj_restrict_iso` (the tensorator `restrictScalarsMonoidalOfBijective`),
   swapping `⊗` for `dual`.
3. Is `restrictScalarsRingIsoDualEquiv` actually the right ingredient, or is there a more direct
   `restrictScalars`-vs-`dual` commutation already in Mathlib (e.g. a `LinearEquiv` between
   `restrictScalars (M →ₗ N)` and `restrictScalars M →ₗ restrictScalars N` under a ring iso)?

Project-side build (NOT an upstream PR). Write the persistent rationale + concrete `isoMk` skeleton +
verified Mathlib lemma names to `analogies/dual252.md`.
