## File to check

- Lean file: `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
- Blueprint chapter: `blueprint/src/chapters/Genus0BaseObjects_GmScaling.tex` (if it exists; otherwise note the absence)

## iter-184 change

Lane B was the iter-184 CHURNING corrective — `mathlib-analogist gmscaling-projection-idiom` returned BUILD_PROJECT_HELPER with a 3-recipe plan. The prover landed ONLY Recipe 1 (two `@[reassoc (attr := simp)]` helpers `pullback_map_fst_proj` / `pullback_map_snd_proj` at the top of the file, ~30 LOC) and then the session hit the weekly API limit before attempting Recipe 2 (two named projection lemmas) or Recipe 3 (cocycle body closure for `gmScalingP1_chart_agreement_cross01` L382).

File sorry count: 4 → 4 (no net change). The 5-iter CHURNING decrement gate (4 → 3) was NOT met because the lane was forcibly truncated, not because the recipe failed.

## What I expect

- Does the chapter prose for `gmScalingP1_chart_agreement_cross01` exist with enough detail to support Recipe 2 + 3 closure next iter? If not, flag for blueprint expansion.
- Are the two new simp helpers `pullback_map_fst_proj` / `_snd_proj` blueprint-documented anywhere, or are they purely Lean-level infrastructure (in which case no chapter change is needed)?
- Lean → blueprint: any `\lean{...}` pins that have drifted post-iter-184?

## Out of scope

- Other files / chapters.
- The Recipe 2/3 substance itself (the analogist's report `analogies/gmscaling-projection-idiom.md` covers it).

## Report length

Under ~150 lines.
