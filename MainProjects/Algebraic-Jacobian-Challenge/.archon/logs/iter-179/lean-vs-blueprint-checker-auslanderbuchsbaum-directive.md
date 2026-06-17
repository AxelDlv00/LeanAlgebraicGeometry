# Lean ↔ Blueprint Checker Directive

## Slug
auslanderbuchsbaum-iter179

## Lean file
AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean

## Blueprint chapter
blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex

## Known issues
- This iter (Lane F) only edited the module-level Status block (L28-35) +
  the `projectiveDimension` docstring (around L180-182) to retire iter-178
  auditor 178C must-fix on stale docstrings; the declaration body was NOT
  changed (it was already kernel-clean post-iter-178). Verify the docstring
  edits faithfully reflect the actual code.
- STRETCH Target 2 (re-export `Module.depth` from Mathlib) was PARTIAL —
  the audit found no numeric `Module.depth` in Mathlib at the pinned commit
  (only `IsSMulRegular`-based depth-zero characterisations); the body
  remains a typed `sorry`. A new docstring paragraph was added documenting
  the Mathlib gap.
- Other declarations (`depth_eq_smallest_ext_index`, `depth_of_short_exact`,
  `auslander_buchsbaum_formula`, `CohenMacaulay.of_regular`) are not iter-179
  targets; flag blueprint adequacy only.
