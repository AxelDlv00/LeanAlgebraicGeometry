# Mathlib-analogist directive — slug `chart-bridge173`

## Mode: api-alignment

This is the iter-173 mandatory consult triggered by the iter-172 progress-critic `route172` PARTIAL-low reversal: Lane A on `Genus0BaseObjects.lean` could not close PRIMARY 3 (`gmScalingP1_chart kbar i`) because the source type of the chart is an abstract pullback over `Proj 𝒜 = PLB.left`, while `pullbackSpecIso` operates on pullbacks of `Spec.map (algebraMap kbar _)` morphisms. The iter-172 prover identified the missing piece as a structural lemma:

```
(gmScalingP1_cover kbar).X i ≅ Spec ((HomogeneousLocalization.Away 𝒜 (X i)) ⊗[kbar] (GmRing kbar))
```

in `Over (Spec (.of kbar))`, where `gmScalingP1_cover kbar` is defined at `AlgebraicJacobian/Genus0BaseObjects.lean:679` as `(projectiveLineBarAffineCover kbar).openCover.pullback₁ (pullback.fst PLB.hom Gm.hom)`. We need this iso so the chart morphism `gmScalingP1_chart kbar i` can be written as

```
Spec ((Away 𝒜 X_i) ⊗[kbar] (GmRing kbar)) ⟶ Spec (Away 𝒜 X_i) ⟶ Proj 𝒜
```

composing `Spec.map gmScalingP1_chart_i_ringMap` (axiom-clean, lives at L803/L812) with `Spec.map homogeneousLocalizationAwayIso.symm` (axiom-clean as of iter-172) and `Proj.awayι` (Mathlib).

## Question

What is the **right Mathlib idiom** for the structural lemma above? Specifically:

1. Does Mathlib ship a canonical iso `pullback (Spec.map f) (Spec.map g) ≅ Spec (A ⊗[R] B)` for the relevant pullback diagram (`f : R → A`, `g : R → B`)? Likely candidate: `AlgebraicGeometry.pullbackSpecIso` at `Mathlib/AlgebraicGeometry/Pullbacks/Spec.lean`. Please **verify** its exact signature, the orientation of the iso (`pullback ... ≅ Spec ...` vs `Spec ... ≅ pullback ...`), and what RingHom / Algebra typeclass shape it requires on `f, g`.
2. The project's `gmScalingP1_cover.X i` is `pullback (pullback.fst PLB.hom Gm.hom) (Proj.awayι _ (X i) _)` — the second leg is `Proj.awayι` (an open immersion into `Proj 𝒜`), not a `Spec.map`. How does one bridge from this open-immersion-into-Proj setting to a tensor-product-on-the-affine-chart setting? Likely route: `Proj.awayι ≅ Spec.map (algebraMap (𝒜 0) (Away 𝒜 (X i)))` composed with the affine open embedding `Spec (Away 𝒜 (X i)) ↪ Proj 𝒜`. Locate the Mathlib API.
3. The first leg `pullback.fst PLB.hom Gm.hom` is a pullback of the structure morphisms `PLB.hom : ProjectiveLineBar kbar ⟶ Spec kbar` and `Gm.hom : Gm kbar ⟶ Spec kbar`. After pulling back over `Proj.awayι`, what is the canonical iso to `Spec((Away 𝒜 X_i) ⊗[kbar] (GmRing kbar))`?
4. **Counter-design check:** if Mathlib has a cleaner idiom for "chart-side reduction of a `Scheme.OpenCover.pullback₁`-cover", prefer that. The project's encoding may be parallel API to a Mathlib pattern.

## Boundary

- Read-only consult. You will write `analogies/<slug>.md` documenting the verdict + a concrete recipe the iter-173 prover can apply.
- Strict severity: if Mathlib has a canonical idiom and the project uses a parallel API, flag the project's path as needing alignment, even if the alignment is a refactor — do not soften.
- If no Mathlib idiom exists, propose a minimal in-project bridge lemma (signature only — the prover writes the proof) the prover can build in ≤30 LOC.

## Specific paths to scan

- `Mathlib/AlgebraicGeometry/Pullbacks/Spec.lean` (`pullbackSpecIso`)
- `Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean` (`Proj.awayι`, `Proj.affineOpenCoverOfIrrelevantLESpan`)
- `Mathlib/AlgebraicGeometry/Cover/Directed.lean` / `.../Open.lean` (`Scheme.OpenCover.pullback₁`)
- `Mathlib/CategoryTheory/Limits/Shapes/Pullback/*.lean` (pullback rotation / symmetry / congr API)

## Output

`analogies/chart-bridge.md` with:
- Exact `pullbackSpecIso` signature and orientation.
- The bridge recipe (lemma signature + ≤10-line proof sketch in informal pseudocode) for `(gmScalingP1_cover kbar).X i ≅ Spec ((Away 𝒜 X_i) ⊗[kbar] (GmRing kbar))`.
- The iter-173 prover's concrete next step: how to write `gmScalingP1_chart kbar i := ...` using this bridge.

If the bridge lemma itself is non-trivial (>50 LOC), report that explicitly and propose splitting it into 2 sub-lemmas the prover should attack sequentially.
