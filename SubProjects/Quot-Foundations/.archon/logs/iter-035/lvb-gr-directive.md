# Lean ↔ blueprint check — GrassmannianCells (iter-035)

Verify exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianCells.tex

Report:
(a) Lean → blueprint: fake/placeholder/vacuous decls; broken `\lean{...}` pins; signature
    mismatches.
(b) Blueprint → Lean: blocks too thin to guide formalization.

Key facts to check against:
- 7 new axiom-clean decls landed (~L1438–1545): `compactSpace_scheme`,
  `quasiCompact_toSpecZ`, `locallyOfFiniteType_toSpecZ`, `quasiSeparated_toSpecZ`,
  `valuativeUniqueness_toSpecZ`, `transitionPreMap_minorDet_mul`,
  `isProper_of_valuativeExistence`. NONE of these has a blueprint block yet (coverage debt
  — they appear under `archon dag-query unmatched`). Confirm and list which need blocks
  under `sec:gr_proper`.
- The keystone `Grassmannian.isProper` is NOT added; it is reduced to the single obligation
  `ValuativeCriterion.Existence (toSpecZ d r)`. The blueprint block `lem:gr_proper` (L2114)
  pins `\lean{AlgebraicGeometry.Grassmannian.isProper}` — confirm that pin honestly reflects
  a not-yet-existing decl (no false \leanok claim) and that the existence-part decomposition
  (E1 chart factorization / E2 minimal valuation / E3 / E4) is described or absent.

Mark each finding must-fix-this-iter / major / minor. Write to your task_results file.
