# Iter 078 — Objectives

Three independent prover lanes (disjoint files, no edit race). All three gate-cleared (iter-077
blueprint review + fastpath). First iter the opus prover actually runs.

| Lane | File | Sorries | Mode | Gate |
|---|---|---|---|---|
| 1 | `AlgebraicJacobian/Picard/GlueDescent.lean` | 2 (L1170 β_ij, L1207 keystone) | prove | CLEAR (fastpath) |
| 2 | `AlgebraicJacobian/Picard/GrassmannianQuot.lean` | 6 (Nitsure §5 inverse + represents) | prove | CLEAR (fastpath) |
| 3 | `AlgebraicJacobian/Picard/SectionGradedRing.lean` | 2 (L1605 assoc, L1678 powAdd) | prove | CLEAR (correct+sketches) |

Dependency notes:
- Lane 2 `tautologicalQuotient_epi` (L2066) needs lane 1's `glue_unique`; keystone-INDEPENDENT
  sorries (chartLocus cover L2147, grPointOfRankQuotient L2249) come first.
- Lane 3 `tensorObjAssoc` before `tensorPowAdd` (latter calls former).

Reference anchors (per REFERENCE-DRIVEN standing directive):
- Lane 1: Mathlib `restrictFunctorAdjCounitIso`/`restrictFunctorComp`; effective descent.
- Lane 2: Nitsure "Construction of Hilbert and Quot Schemes" §5 (Grassmannian + Quot construction).
- Lane 3: SNAP tensor ladder — `cor:sheafTensorObjAssoc`, `lem:sheafTensorPow_add`
  (`analogies/snap-assoc.md`), built on the closed crux `isIso_sheafification_whiskerRight_unit`.
