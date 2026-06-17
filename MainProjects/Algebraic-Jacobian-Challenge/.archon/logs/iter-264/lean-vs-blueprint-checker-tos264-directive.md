# Lean-vs-blueprint check — iter-264 — D3′ substrate

Verify ONE Lean file against ONE blueprint chapter, bidirectionally.

Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
(This chapter is consolidated; it `% archon:covers` TensorObjSubstrate.lean among others.)

This iter the prover landed the `leftAdjointUniqUnitEta_app` recovery brick (D3′ Sq1 tail, step 1)
and tail structural setup, but `sheafificationCompPullback_comp_tail` / the Sq1 reassembly remains
open (4th consecutive PARTIAL on D3′ Sq1). Report:
- whether the chapter's blueprint prose for the Sq1 `sheafificationCompPullback` composition law and
  `pullbackTensorMap_restrict` gives the level of detail the Lean code now needs (the mate-calculus
  tail), or whether the chapter is too thin to guide the close;
- any signature mismatch / placeholder.
Flag must-fix vs major vs minor.
