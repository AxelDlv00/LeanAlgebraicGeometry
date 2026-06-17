# Lean ↔ Blueprint Checker Directive

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

(The relevant block is `lem:cech_augmented_resolution` (~line 7120), whose `\lean{}` pins
`AlgebraicGeometry.cechAugmented_exact`.)

## Context
This iter the prover was assigned `cechAugmented_exact` via the sections/sheafification route.
It did NOT add `cechAugmented_exact` — it reported a HARD STRUCTURAL BLOCKER: every prescribed
ingredient (`homologyIsoSheafify`, `sectionCech_affine_vanishing`,
`sectionCech_homology_exact_of_localizationAway`, `sectionCechComplex`, `affineCoverSystem`,
`qcoh_iso_tilde_sections`) lives in a file that transitively imports
`CechHigherDirectImage.lean` (the most-upstream Cohomology file) ⇒ importing them back is an
import cycle. The prover instead landed the 3 pure-Mathlib site-theory Step-2 lemmas
(`isZero_presheafToSheaf_obj_of_W`, `…_of_W_isZero`, `…_of_isLocallyBijective`) which ARE
upstream-buildable, and recommends RELOCATING `cechAugmented_exact` to a downstream file.

## What to check
- Whether the 3 new site-theory lemmas faithfully formalize the blueprint Step-2 claim
  ("sheafification carries a locally bijective map to an iso; the sheafification of the
  locally-zero presheaf homology is the zero sheaf") of `lem:cech_augmented_resolution`.
- Whether the blueprint `lem:cech_augmented_resolution` proof sketch accounts for the file-placement
  reality (i.e. does the blueprint silently assume the theorem lives where its ingredients live?),
  or whether the blueprint is fine and only the Lean file PLACEMENT is the issue.
- Whether the `\lean{AlgebraicGeometry.cechAugmented_exact}` pin should be re-pointed to a new
  downstream location.
- The pre-existing FROZEN sorry at line 780 (`cech_computes_higherDirectImage`) is known/intentional.

## Output
Bidirectional report to task_results/.
