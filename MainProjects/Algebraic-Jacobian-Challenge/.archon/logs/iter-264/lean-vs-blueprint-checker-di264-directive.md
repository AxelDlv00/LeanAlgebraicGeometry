# Lean-vs-blueprint check — iter-264 — dual inverse

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
(This chapter is consolidated; it `% archon:covers` TensorObjSubstrate/DualInverse.lean among others.)

This iter the prover CLOSED the `sliceDualTransport.map_smul'` field (internal holes 5→4); the four
remaining `sliceDualTransport` holes are naturality, `invFun`, `left_inv`, `right_inv`, plus the
`dual_restrict_iso` Step-4 `isoMk` naturality `sorry`. Report:
- whether the chapter adequately specifies `sliceDualTransport` (the route-2 leg-A/leg-B reindex) and
  the `dual_restrict_iso` Step-4 chart-chase, so the prover can close `invFun`/round-trips next;
- any `\lean{...}` name drift or placeholder statement.
Flag must-fix vs major vs minor.
