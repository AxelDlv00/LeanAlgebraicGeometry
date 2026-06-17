# lean-vs-blueprint — TensorObjSubstrate.lean (iter-256)

Lean file:
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

Blueprint chapter:
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex

PRIORITY CHECK: the prover scaffolded a NEW decl `pullbackTensorMap_restrict`
(blueprint label `lem:pullback_tensor_map_basechange`, blueprint ~L3876) and reported
that the blueprint's proof SKETCH is Lean-INADEQUATE: the sketch says to "MIRROR
`pullbackObjUnitToUnit_comp`" via an adjunction-transpose argument, but
`pullbackTensorMap` is NOT an adjunction transpose (it is a hand-built 4-fold
composite), so the mirror recipe cannot even start. The genuine route is a 4-square
composition-coherence build (Sq1 sheafificationCompPullback-comp, Sq2 comp_δ +
PresheafOfModules.pullbackComp ring-map reconcile, Sq3 sheafifyTensorUnitIso, Sq4
pullbackValIso-comp).

Verify bidirectionally:
(a) does the Lean signature of `pullbackTensorMap_restrict` match the blueprint
    statement of `lem:pullback_tensor_map_basechange`?
(b) is the blueprint proof sketch for this lemma actually Lean-adequate, or does it
    prescribe the disproven mirror route? If inadequate, say so explicitly and name
    what the chapter must say instead (this is a must-fix-this-iter for the blueprint).
Also confirm D1'/D2' (`pullbackTensorMap_natural`, `pullbackTensorMap_unit_isIso`,
closed in iters 255/250) are still correctly reflected as closed in the chapter.
