# lean-vs-blueprint-checker iter-165 directive

## File pair

- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex`

`AbelianVarietyRigidity.tex` is a CONSOLIDATED chapter — its
`% archon:covers` line at the top now lists BOTH
`AbelianVarietyRigidity.lean` AND `Genus0BaseObjects.lean`. The two
blueprint blocks that back the NEW file are:

- `def:genus0_base_objects` (label L912; `\lean{AlgebraicGeometry.ProjectiveLineBar}`)
- `def:gaTranslationP1` (L943; `\lean{AlgebraicGeometry.gmScalingP1}`)

## What landed in the Lean file this iter

A new file with the 4 main objects + their primary instances:

- `ProjectiveLineBar` (`Proj` of the standard ℕ-graded `k̄[X₀, X₁]`)
  with `IsProper` proven axiom-clean.
- `Ga` (`AffineSpace (Fin 1) (Spec k̄)`) with `IsAffineHom`,
  `LocallyOfFinitePresentation`, `IsReduced` proven; `GrpObj`,
  `Smooth` scaffold sorries.
- `Gm` (`Spec (Localization.Away (MvPolynomial.X () : MvPolynomial Unit k̄))`)
  with `IsAffine`, `LocallyOfFinitePresentation`, `IsReduced`
  proven; `GrpObj`, `Smooth` scaffold sorries.
- `gmScalingP1` (the bare `ProjectiveLineBar ⊗ Gm ⟶ ProjectiveLineBar`
  morphism) with statement `gmScalingP1_collapse_at_zero` for the
  rigidity consumer's `_hf` hypothesis. Both bodies are scaffold
  sorries.
- `Gm.onePt` (the multiplicative identity).
- Scaffold `ProjectiveLineBar.{zeroPt, onePt, inftyPt}` definitions.

The 9 scaffold sorries are explicitly plan-allowed (see plan.md L107–
115 for the PARTIAL gate scorecard).

## What to verify

### Lean → blueprint

- Does `\lean{AlgebraicGeometry.ProjectiveLineBar}` on `def:genus0_base_objects`
  point to the actual decl in the new file? (yes — confirm)
- Does `\lean{AlgebraicGeometry.gmScalingP1}` on `def:gaTranslationP1`
  point to the actual decl? (yes — confirm)
- The blueprint also names `Gm`, `Ga`, `Gm.onePt`,
  `ProjectiveLineBar.{zeroPt, onePt, inftyPt}` — are these expected to
  have their own `\lean{...}` hints in `def:genus0_base_objects`, or
  is the single primary hint sufficient? The current chapter prose
  has `[expected]` annotations naming `Ga` and `Gm`. Decide whether
  this is a `\lean{...}`-coverage minor.

### Blueprint → Lean

- Does the chapter say anything that the Lean file fails to instantiate
  faithfully? E.g., does the blueprint claim a property of these
  objects that the Lean file does not provide?
- Does the chapter say something like "the GrpObj structures are
  proven", and is that consistent with `ga_grpObj` / `gm_grpObj` being
  scaffold sorries?
- Are the chapter's `\uses{...}` from `def:gaTranslationP1` consistent
  with the file's structure (e.g., `\uses{def:genus0_base_objects}` —
  fine, since `gmScalingP1` references `ProjectiveLineBar` and `Gm`).

### Forward-acyclicity / laundering check

- The `morphism_P1_to_grpScheme_const` proof in
  `AbelianVarietyRigidity.lean` (L982 region) is STILL a `sorry`. The
  blueprint chapter's downstream theorems
  (`prop:morphism_P1_to_AV_constant`, etc.) `\uses{def:gaTranslationP1}`.
  Confirm the chain is forward-acyclic.
- Confirm there is no false `\leanok` on a `sorry`-bodied target
  (`def:gaTranslationP1` should NOT have `\leanok` on the proof since
  `gmScalingP1` is `sorry`; this is `sync_leanok`'s domain — flag if
  you see a `\leanok` on a sorry-bodied target).

## Out of scope

- The 9 plan-allowed scaffold sorries themselves — don't mark
  "scaffold sorries should be filled" as a finding. Treat them as
  the iter-166 lane's intended work.

## Format

Bidirectional report (Lean→blueprint, blueprint→Lean) per the standard
checker template. Severity-tagged must-fix / major / minor. Write to
`task_results/lean-vs-blueprint-checker-g0bo-iter165.md`.
