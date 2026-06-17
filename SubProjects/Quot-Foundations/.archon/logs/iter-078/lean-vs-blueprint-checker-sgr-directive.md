# lean-vs-blueprint-checker — SectionGradedRing

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/SectionGradedRing.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_SectionGradedRing.tex

## Check
Bidirectional. This iter closed both remaining sorries: `tensorObjAssoc`
(`cor:sheafTensorObjAssoc`) and `tensorPowAdd` (`lem:sheafTensorPow_add`); file is now
sorry-free. Two new private helpers added: tensorObjWhiskerRightIso, tensorObjWhiskerLeftIso
(proof-level steps of tensorPowAdd). `unitModule` made public (no signature change).
Verify: (a) the two closed Lean proofs follow the chapter's informal proof (chapter L1064–1121
for assoc, L1182–1218 for pow_add); (b) whether the 2 private whisker helpers need blueprint
blocks or are exempt as proof-internal; (c) chapter adequacy.
