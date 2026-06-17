# Lean ↔ blueprint check — DualInverse (iter-265)

Lean file: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
Blueprint chapter: /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex
(the relevant block is `lem:slice_dual_transport`, around L5780.)

This iter the prover added 4 axiom-clean leg-B swap helpers
(`dualUnitRingSwapInv`, two `@[simp]` cancellation lemmas,
`isIso_ε_restrictScalars_appIso_hom`, `dualUnitRingSwapHom`) and recorded a
CORRECTNESS FINDING: the blueprint inverse paragraph's gloss "ε itself (not
inv ε)" is imprecise — `invFun` actually needs `inv ε` of the `.hom`-direction
restrictScalars functor (`dualUnitRingSwapHom`). The 4 `sliceDualTransport`
proof fields (naturality, invFun, left_inv, right_inv) remain sorry.
Check bidirectionally:
- Does the `lem:slice_dual_transport` inverse paragraph correctly describe the
  ε-codomain swap direction? Flag the "ε itself" gloss if it contradicts the
  Lean `dualUnitRingSwapHom` = `inv ε` finding (candidate must-fix for the
  plan agent to route to a blueprint-writer).
- Does the chapter name a helper `restrictScalarsLaxε` (for naturality) that
  does NOT exist in the codebase? If so, flag it.
- Any signature mismatch / fake statement / over-marking.
Report Lean→blueprint AND blueprint→Lean, with any must-fix-this-iter findings.
