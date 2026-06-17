# lean-vs-blueprint-checker directive — iter-260 — TensorObjSubstrate

Verify ONE Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
(consolidated chapter; declares `% archon:covers` for this file.)

## What changed this iter
`pushforwardComp_lax_μ` was CLOSED axiom-clean (the D3′ Sq2b residual). The
Sq2b proof in the chapter (~lines 4003–4035) previously described this residual
as a "genuine ModuleCat change-of-rings calculation assembled from
ModuleCat.restrictScalarsComp / extendScalarsComp / homEquiv_extendScalarsComp".
The ACTUAL committed proof is a short sectionwise pure-tensor collapse via
`ModuleCat.restrictScalars_μ_tmul` plus two `rfl`-foundations
(`pushforward_μ_eq`, `restrictScalars_μ_app`) — it does NOT use extendScalarsComp.

## Report
- Lean → blueprint: does the chapter prose for Sq2b / `pushforwardComp_lax_μ`
  now accurately describe the committed proof? Flag any prose that overstates
  difficulty or names primitives the proof does not use.
- blueprint → Lean: is the chapter still adequate to guide the REMAINING open
  obligations in this file (`exists_tensorObj_inverse`, the outer
  `pullbackTensorMap_restrict` Sq1/Sq4 assembly)?
- Flag any `\lean{...}` name mismatches.
Tag any finding that must be fixed this iter as MUST-FIX.
