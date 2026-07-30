---
author: sync
content_type: lemma
created: '2026-07-24T17:02:48'
decl: AlgebraicGeometry.Over.tripleAwayEquiv_faceA₂₃
docstring: 'The `f₂₃`-pullback of the two-base identification is the index-wise face

  `faceA₂₃`.'
file: AlgebraicJacobian/Picard/WitnessTransport.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.tripleAwayEquiv_faceA₂₃
type: lean
updated: '2026-07-30T15:28:02'
---
lemma tripleAwayEquiv_faceA₂₃ (i j l : P.ι)
    (t : Γ(XB, (XB).basicOpen (P.r j)) ⊗[A] Γ(XB, (XB).basicOpen (P.r l))) :
    tripleAwayEquiv P i j l
        (Algebra.TensorProduct.faceA₂₃ A (fun i' => Γ(XB, (XB).basicOpen (P.r i'))) i j l t)
      = ((f₂₃).appLE ((Sq).basicOpen (pairSection P j l))
          ((Scb).basicOpen (tripleSection P i j l))
          (basicOpen_tripleSection_le_f₂₃ P i j l)).hom (pairAwayEquiv P j l t) := by
  letI := IsLocalization.Away.tensorAwayAlgebra A B B Γ(XB, (XB).basicOpen (P.r j))
    Γ(XB, (XB).basicOpen (P.r l))
  haveI := isLocalization_awayElt P j
  haveI := isLocalization_awayElt P l
  haveI := IsLocalization.Away.isLocalization_away_tensor A B B (awayElt P j) (awayElt P l)
    Γ(XB, (XB).basicOpen (P.r j)) Γ(XB, (XB).basicOpen (P.r l))
  letI := IsLocalization.Away.tensorAwayAlgebra A B B Γ(XB, (XB).basicOpen (P.r j))
    Γ(XB, (XB).basicOpen (P.r l))
  haveI := IsLocalization.Away.tensorAwayScalarTower A B B Γ(XB, (XB).basicOpen (P.r j))
    Γ(XB, (XB).basicOpen (P.r l))
  letI := IsLocalization.Away.tensorAwayAlgebra A B (B ⊗[A] B)
    Γ(XB, (XB).basicOpen (P.r i))
    (Γ(XB, (XB).basicOpen (P.r j)) ⊗[A] Γ(XB, (XB).basicOpen (P.r l)))
  have key : ((tripleAwayEquiv (A := A) P i j l).toAlgHom.toRingHom).comp
        (Algebra.TensorProduct.faceA₂₃ A
          (fun i' => Γ(XB, (XB).basicOpen (P.r i'))) i j l).toRingHom
      = (((f₂₃).appLE ((Sq).basicOpen (pairSection P j l))
          ((Scb).basicOpen (tripleSection P i j l))
          (basicOpen_tripleSection_le_f₂₃ P i j l)).hom).comp
        (pairAwayEquiv P j l).toAlgHom.toRingHom := by
    apply IsLocalization.ringHom_ext
      (Submonoid.powers ((awayElt P j ⊗ₜ[A] (1 : B)) * ((1 : B) ⊗ₜ[A] awayElt P l)))
    refine RingHom.ext fun w => ?_
    change tripleAwayEquiv P i j l
        (Algebra.TensorProduct.faceA₂₃ A (fun i' => Γ(XB, (XB).basicOpen (P.r i'))) i j l
          (algebraMap (B ⊗[A] B) _ w))
      = ((f₂₃).appLE _ _ _).hom (pairAwayEquiv P j l (algebraMap (B ⊗[A] B) _ w))
    rw [(pairAwayEquiv P j l).commutes w, appLE_algebraMap_face₂₃ P i j l w,
      faceA₂₃_algebraMap P i j l w, (tripleAwayEquiv (A := A) P i j l).commutes]
  exact DFunLike.congr_fun key t