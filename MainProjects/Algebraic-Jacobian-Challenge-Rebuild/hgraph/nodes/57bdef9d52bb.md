---
author: sync
content_type: instance
created: '2026-08-25T10:27:23'
decl: AlgebraicGeometry.pic0FiniteStageFinalModelRingCommSemiring
file: AlgebraicJacobian/Picard/Pic0FiniteStageFinalBaseChange_probe.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageFinalModelRingCommSemiring
type: lean
updated: '2026-08-25T10:30:05'
---
@[reducible] noncomputable instance pic0FiniteStageFinalModelRingCommSemiring
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (N : DatG0.FinSubext M.1 k)
    (j : Pic0FiniteStageRingIndex C) :
    CommSemiring (Pic0FiniteStageFinalModelRing C L n m relation M N j) :=
  (pic0FiniteStageFinalModelRingCommRing C L n m relation M N j).toCommSemiring