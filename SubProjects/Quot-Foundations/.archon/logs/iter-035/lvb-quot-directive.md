# Lean ↔ blueprint check — QuotScheme (iter-035)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

Report:
(a) Lean → blueprint: fake/placeholder/vacuous decls; broken `\lean{...}` pins; signature
    mismatches.
(b) Blueprint → Lean: blocks too thin to guide formalization.

Key facts to check against:
- The new keystone landed under the name
  `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent_of_cover`
  (cover-hypothesis form, axiom-clean, ~L1630). The blueprint block
  `lem:section_localization_descent` (L3545) still pins
  `\lean{...isLocalizedModule_basicOpen_descent}` — the NAMED form, which does NOT yet
  exist in Lean (gated on the `Hfr` slice→Spec R_r section transport). There is an
  existing `% NOTE (iter-035)` at L3551 documenting this. Confirm the NOTE is accurate and
  the pin/coverage situation is honestly flagged; report whether the planner needs to add
  a dedicated block for the cover form and/or repoint the `\lean{}`.
- 5 new private helpers (`iSup_basicOpen_subtype_eq_top`, `res_comp`, `descent_smul_eq_zero`,
  `descent_overlap_agree`, `descent_surj`) owe no blueprint block by the private-helper
  convention — confirm.
- 4 pre-existing protected stub `sorry`s at ~L126/165/201/228 — confirm untouched and that
  their blueprint blocks honestly mark them unproved.

Mark each finding must-fix-this-iter / major / minor. Write to your task_results file.
