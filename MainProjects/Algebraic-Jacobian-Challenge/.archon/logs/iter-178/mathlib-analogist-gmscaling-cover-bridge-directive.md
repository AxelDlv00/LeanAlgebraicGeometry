# mathlib-analogist — iter-178 directive (cover-vs-Proj.awayι API)

## Mode: api-alignment

## Background

The genus-0 chart-bridge in `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
has been blocked for 6 iterations on a Lean syntactic / defeq mismatch that 5
helper-bridge attempts could not penetrate. Iter-177 fired the HARD STOP
corrective and admitted 2 named TEMPORARY project axioms
(`gmScalingP1_chart_data_temp`, `gmScalingP1_collapse_at_zero_temp`) to
unblock downstream genus-0 work, with a documented replacement plan:
"resolve the cover-vs-`Proj.awayι` syntactic mismatch via
`Scheme.AffineOpenCover.openCover_f` + `Matrix.cons_val` (≈10 LOC) OR a
structural `Fin.cases` refactor of `gmScalingP1_cover_X_iso` (≈30 LOC)".

The blueprint chapter is `blueprint/src/chapters/AbelianVarietyRigidity.tex`
(consolidated chapter covering `RigidityKbar.lean`, `GmScaling.lean`,
`Cotangent/ChartAlgebra.lean`).

## The exact mismatch

The Step-C chart bridge inside `gmScalingP1_chart_PLB_eq` (was L218 pre-iter-177,
now retired via temp axiom L196) needs to discharge an equation between a
morphism produced via the cover machinery (`(gmScalingP1_cover kbar).f i`,
i.e. `Scheme.AffineOpenCover.openCover.f`) and a morphism produced via
`Proj.awayι _ (X i) _ Nat.one_pos` (the standard chart inclusion of
`ℙ¹ = Proj(k̄[X₀, X₁])` away from a variable). On paper they ARE the same
morphism (the standard Proj cover gives, on each chart, exactly the
`Proj.awayι` inclusion). In Lean, they are not definitionally equal:
the cover constructor wraps the chart embedding through the
`Scheme.AffineOpenCover` builder + `openCover` projection, and the
intermediate `pullbackSpecIso_hom_base` simp lemma can't fire because
its LHS has `(cover).f i` form while the bridge needs `Proj.awayι` form.

Five iters of helpers (iter-172 → iter-176, +3 helpers cumulatively) failed
to close the gap. Iter-176 applied the analogist-recommended option (a)
`simp only [Fin.isValue, Fin.zero_eta]` recipe AS WRITTEN at L309 and L341
of the iter-176 snapshot, but this only normalized the Fin indexing —
the underlying cover-vs-`Proj.awayι` syntactic mismatch remained.

## Question for you

In API alignment mode, please report:

1. **The Mathlib idiom**: When `Scheme.AffineOpenCover` (or
   `Scheme.OpenCover`) is built from a list/finset of chart embeddings
   of the form `Proj.awayι 𝒜 f h`, what is the canonical Mathlib lemma
   that lets you rewrite `cover.openCover.f i` (a `Scheme.OpenCover.f`
   call) back to the original `Proj.awayι` form? Examples to look at:
   - `Mathlib.AlgebraicGeometry.Cover.Basic`
   - `Mathlib.AlgebraicGeometry.Cover.Open`
   - `Mathlib.AlgebraicGeometry.AffineCover` / `AffineOpenCover`
   - `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Proj.Basic`
   - `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Proj.HomogeneousLocalization`
2. **The expected API**: Does Mathlib ship a `Proj.openCover` /
   `Proj.affineCover` / `Proj.coverByCharts` / similar that has
   exactly the right `.f i = Proj.awayι _ (Xᵢ) ...` definitional or
   `@[simp]` equation? If yes, the project should use IT and not roll
   its own `gmScalingP1_cover` glue.
3. **The pivot estimate**: If a refactor from project-side
   `gmScalingP1_cover` to a Mathlib-shipped `Proj.coverByCharts`
   (or similar) eliminates the mismatch, estimate the LOC delta
   (the docstring of the project's iter-177 replacement plan named
   ~10-30 LOC; verify this against actual Mathlib).
4. **Alternative — separated-locus universal extension**: STRATEGY.md
   Open Q lists a pre-committed replacement candidate: prove `ℙ¹ → A const`
   directly by extending `𝔸¹ → A` from the affine chart to `ℙ¹` via the
   valuative criterion of properness on `A`, then collapsing on a closed
   fibre. Does Mathlib have the valuative criterion of properness in the
   right shape (extending a `𝔸¹`-morphism to `ℙ¹`)? Look at
   `Mathlib.AlgebraicGeometry.Morphisms.Proper` and adjacent files. If
   yes, this route bypasses the chart-bridge entirely.

## Output

Standard api-alignment output: `## Verdict` (PROCEED / ALIGN-WITH-MATHLIB),
`## Recommendation` (named Mathlib lemmas with citations), `## Replacement
plan` (concrete LOC-scoped steps to retire `gmScalingP1_chart_data_temp`
and `gmScalingP1_collapse_at_zero_temp`).

Persist the findings to `analogies/gmscaling-cover-bridge.md` so iter-179+
planners can build on it.
