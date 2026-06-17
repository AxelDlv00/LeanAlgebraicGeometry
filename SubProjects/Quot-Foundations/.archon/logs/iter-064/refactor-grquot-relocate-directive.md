# Refactor directive — relocate the pullback-comparison cluster before C2

Target: `AlgebraicJacobian/Picard/GrassmannianQuot.lean` (1681 lines).

Action: MOVE the contiguous generic pullback-comparison cluster — currently the span containing
`pullbackObjUnitToUnit_id` (L1228), `pullbackFreeIso_id` (L1255), `homEquiv_conjugateEquiv_app`
(L1282), `pullbackObjUnitToUnit_comp` (L1323), `pullbackFreeIso_comp` (L1400),
`pullbackBaseChangeTransport_matrixToFreeIso` (L1543), with each decl's doc comments and any
section comments belonging to the span, ending just before `noncomputable def functor` (L1598) —
to immediately BEFORE `theorem bundleTransition_cocycle` (L1045, include its preceding doc comment
in the insertion point).

Rationale: C2 (`bundleTransition_cocycle`, sorry body) must be able to reference
`pullbackBaseChangeTransport_matrixToFreeIso` and `pullbackFreeIso_comp`, which currently sit
after it. Nothing between L1045 and L1597 references `bundleTransition_cocycle` (the riders are
sorries), and the moved cluster is generic `Scheme.{u}` material that must not reference
C2/universalQuotient/tautologicalQuotient/RankQuotient — verify this before moving; if any moved
decl DOES reference a decl in L1045–L1227, narrow the span and report.

Constraints:
- Pure relocation. NO renames, NO signature changes, NO proof-body edits, NO sorry filling.
- No decl in this file is protected.
- Verify with a real `lake build AlgebraicJacobian.Picard.GrassmannianQuot` (green, no new
  warnings/errors) before finishing. Report final line numbers of `bundleTransition_cocycle`,
  `pullbackBaseChangeTransport_matrixToFreeIso`, `pullbackFreeIso_comp`, `universalQuotient`,
  `tautologicalQuotient`, `represents`.
