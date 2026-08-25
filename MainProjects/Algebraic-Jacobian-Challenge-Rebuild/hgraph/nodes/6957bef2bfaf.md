---
author: sync
content_type: instance
created: '2026-08-25T10:27:23'
decl: AlgebraicGeometry.pic0FiniteStageModelRingCommRing
docstring: "A finite-presentation model ring after extension to the final finite subextension.\
  \ -/\nnoncomputable abbrev Pic0FiniteStageFinalModelRing\n    {F : Type u} [Field\
  \ F] [Algebra F k]\n    (L : DatG0.FinSubext F k)\n    (n m : Pic0FiniteStageRingIndex\
  \ C -> Nat)\n    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)\n\
  \    (M : DatG0.FinSubext L.1 k)\n    (N : DatG0.FinSubext M.1 k)\n    (j : Pic0FiniteStageRingIndex\
  \ C) : Type u :=\n  N.1 ⊗[M.1] Pic0FiniteStageModelRing C L n m relation M j\n\n\
  /-!\nThe nested tensor aliases above hide the carrier instances that `cancelBaseChange`\n\
  needs.  Keep the witnesses named and local to this module, mirroring the explicit\n\
  overlap instances in `Pic0FiniteStageGluePackage`."
file: AlgebraicJacobian/Picard/Pic0FiniteStageFinalBaseChange_probe.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageModelRingCommRing
type: lean
updated: '2026-08-25T10:30:05'
---
@[reducible] noncomputable instance pic0FiniteStageModelRingCommRing
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    CommRing (Pic0FiniteStageModelRing C L n m relation M j) := by
  dsimp only [Pic0FiniteStageModelRing]
  exact Algebra.TensorProduct.instCommRing