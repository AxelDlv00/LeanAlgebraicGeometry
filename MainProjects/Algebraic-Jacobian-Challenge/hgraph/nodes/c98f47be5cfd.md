---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.PicSharp.relFunctorial_id
docstring: '`relFunctorial` at the identity is the identity (`pullback.map_id` +

  `Modules.pullbackId` descended through the `H_T`-quotient).'
file: AlgebraicJacobian/Picard/RelPicFunctor.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.PicSharp.relFunctorial_id
type: lean
updated: '2026-07-28T13:22:17'
---
private lemma relFunctorial_id {S C T : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) (hg : πT = 𝟙 T ≫ πT)
    (a : Quotient (relPicSetoid πC πT)) :
    relFunctorial πC πT πT (𝟙 T) hg a = a := by
  induction a using Quotient.ind with | _ L => ?_
  refine Quotient.sound (relPicRel_of_iso
    ⟨(Scheme.Modules.pullbackCongr ?_).app L.carrier ≪≫
      (Scheme.Modules.pullbackId _).app L.carrier⟩)
  apply Limits.pullback.hom_ext <;> simp [baseChangeOverC]