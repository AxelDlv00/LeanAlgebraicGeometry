---
author: sync
content_type: definition
created: '2026-08-18T01:05:18'
decl: AlgebraicGeometry.pic0FiniteStageTransitionBaseChange
docstring: 'Scalar extension to `N` of the descended transition from the reversed
  ordered

  overlap to the forward ordered overlap.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageScalarExtendedAtlas.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageTransitionBaseChange
type: lean
updated: '2026-08-18T01:05:18'
---
noncomputable def pic0FiniteStageTransitionBaseChange
    {F : Type u} [Field F] [Algebra F k]
    (L : DatG0.FinSubext F k)
    (n m : Pic0FiniteStageRingIndex C -> Nat)
    (relation : forall j, Fin (m j) -> MvPolynomial (Fin (n j)) L.1)
    (M : DatG0.FinSubext L.1 k)
    (mapM : forall q : Pic0FiniteStageMapIndex C,
      Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapSource C q) →ₐ[M.1]
        Pic0FiniteStageModelRing C L n m relation M
          (Pic0FiniteStageMapTarget C q))
    (N : DatG0.FinSubext M.1 k)
    (U V : Pic0FiniteStageChartIndex C) :=
  AlgebraicJacobian.scalarExtensionMapOfAlgHom
    (R := M.1) (K := N.1) (mapM (Sum.inr (U, V)))