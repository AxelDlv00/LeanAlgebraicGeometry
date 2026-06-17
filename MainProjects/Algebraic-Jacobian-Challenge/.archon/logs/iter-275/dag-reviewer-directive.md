# Blueprint Reviewer Directive

## Slug
review275

## Scope
Whole-blueprint audit (all 38 chapters) — you always read the entire blueprint;
this directive does not scope you down. Render your standard per-chapter
completeness + correctness checklist plus the `### Dependency & isolation
findings` section.

## Context for this iteration
This DAG iteration added **23 additive 1-to-1 "coverage" blocks** for previously-
uncovered internal Lean helper declarations across **6 chapters**:

- `RiemannRoch_RationalCurveIso.tex` — 9 blocks (poleDivisor, poleDivisor_degree_eq_finrank,
  localParameterAtInfty(+uniformiser_witness), phi_left_* ×4, algebraMap_bijective_of_finrank_one).
  Three of these (`localParameterAtInfty_uniformiser_witness`,
  `phi_left_locallyQuasiFinite_of_finrank_one`,
  `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one`) are `sorry`-bodied
  in Lean and were given short informal proof sketches (NOT "proved directly in Lean").
- `RiemannRoch_RRFormula.tex` — 5 blocks (eulerCharacteristic_sheafOf_{zero,succ,single_add},
  eulerCharacteristic_of_shortExact_skyscraper, finrank_H0_toModuleKSheaf_eq_one).
- `Picard_RelPicFunctor.tex` — 5 blocks (PicSharp.{isLocallyTrivial_unit, pInverseUnique,
  relTensorObj, relAdd, relNeg}).
- `RiemannRoch_WeilDivisor.tex` — 1 block (PrimeDivisor.ext).
- `Picard_LineBundlePullback.tex` — 2 blocks (OnProduct.carrier, OnProduct.isLocallyTrivial).
- `Picard_RelativeSpec.tex` — 1 block (QcohAlgebra.pullback).

## What to validate (focus, in addition to the whole-blueprint pass)
1. Each new coverage block is **statement-level `\uses{}`-wired** (not isolated) —
   leandag builds edges only from statement-level `\uses{}`.
2. Each new block's statement is **faithful** to the Lean declaration it pins.
3. **No duplicate `\lean{}` pins** introduced by the new blocks.
4. **No new isolated nodes** (the only acceptable isolated set is the 3
   reviewer-certified exempt nodes: `lem:S3_sep_2_*`, `lem:S3_pi_2_*`,
   `lem:isiso_sheafification_map_of_W`).
5. The three `sorry`-bodied RCI helpers carry an honest informal proof sketch
   (finite effort), not a false "proved directly in Lean" note.

## Known state (do not re-flag as new defects)
- 123 lean-aux remain uncovered — these are the **actively-churning
  TensorObjSubstrate prover lane** (TensorObjSubstrate.lean + PresheafInternalHom +
  StalkTensor + DualInverse + Vestigial), deliberately deferred until the lane
  stabilises. Not in scope for coverage this iter.
- The `\mathlibok` anchor `thm:finite_appTop_of_universallyClosed` is a real Mathlib
  declaration (`AlgebraicGeometry/Morphisms/Proper.lean:154`) — a genuine external
  anchor always shows "unmatched" vs the project tree by design; do NOT report it as
  a fabricated citation (recorded false positive).
- 6 pre-existing duplicate `\lean{}` pins (3× RigidityKbar, 2× Picard_TensorObjSubstrate,
  1× RRFormula/H1Vanishing cross-chapter) are known and not introduced this iter.

## Report destination
.archon/task_results/blueprint-reviewer-review275.md
