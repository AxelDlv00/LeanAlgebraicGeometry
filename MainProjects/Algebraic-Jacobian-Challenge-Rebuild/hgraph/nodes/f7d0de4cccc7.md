---
author: sync
content_type: theorem
created: '2026-08-14T02:57:56'
decl: AlgebraicGeometry.mem_picRankOneOpen_overSpecMap_iff
file: AlgebraicJacobian/Picard/Pic0RankOneIsoBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.mem_picRankOneOpen_overSpecMap_iff
type: lean
updated: '2026-08-18T20:51:05'
---
theorem mem_picRankOneOpen_overSpecMap_iff
    (pi : C.left ⟶ P1 k) [IsFinite pi]
    (hpi : pi ≫ P1.structureMap k = C.hom)
    {K K' : Type u} [Field K] [Algebra k K] [Field K'] [Algebra k K']
    (e : K ≃ₐ[k] K')
    (lam : picDegLayer C (genus C : ℤ) (overSpec k K)) :
    (picDegLayerFunctor C (genus C : ℤ)).map
        (Over.overSpecMap e.toAlgHom).op lam ∈
        (PicRankOneOpen pi).obj (op (overSpec k K')) ↔
      lam ∈ (PicRankOneOpen pi).obj (op (overSpec k K)) := by
  constructor
  · intro h
    have hs := isSplitWitness_of_mem_picRankOneOpen_field pi h
    change IsSplitWitness C (picEtMap C (Over.overSpecMap e.toAlgHom) lam.1) at hs
    have hsl : IsSplitWitness C lam.1 :=
      (isSplitWitness_map_overSpecMap_iff C e lam.1).mp hs
    exact mem_picRankOneOpen_of_isSplitWitness pi hpi lam hsl
  · intro h
    have hs0 : IsSplitWitness C lam.1 :=
      isSplitWitness_of_mem_picRankOneOpen_field pi h
    have hs : IsSplitWitness C
        (picEtMap C (Over.overSpecMap e.toAlgHom) lam.1) :=
      isSplitWitness_map_overSpecMap C e lam.1 hs0
    exact mem_picRankOneOpen_of_isSplitWitness pi hpi _ hs