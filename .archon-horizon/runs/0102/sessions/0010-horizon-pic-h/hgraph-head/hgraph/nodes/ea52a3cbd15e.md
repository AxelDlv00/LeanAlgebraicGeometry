---
author: sync
content_type: theorem
created: '2026-07-31T22:54:03'
decl: AlgebraicGeometry.AffAdaptation.IsCertified.projective_intrinsicThetaGlued_of_swallowedBy
docstring: Projective intrinsic theta descent on a swallowed cover.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaSwallowed.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.IsCertified.projective_intrinsicThetaGlued_of_swallowedBy
type: lean
updated: '2026-08-01T09:44:13'
---
theorem IsCertified.projective_intrinsicThetaGlued_of_swallowedBy
    (hc : A.IsCertified g) (a : Nat) (h : D.SwallowedBy d) :
    Module.Projective R (A.IntrinsicThetaGlued (π := pi) a) := by
  letI : ∀ j : D.index, Module R (A.ThetaPieceQuotient (π := pi) a j) :=
    fun j => A.thetaPieceQuotientBaseModule (π := pi) a j
  letI : ∀ j : D.index, Module.Projective R
      (A.ThetaPieceQuotient (π := pi) a j) :=
    fun j => by
      letI : Module.Projective R (A.colength j) := hc.projective_colength j
      letI : IsScalarTower R (A.colength j)
          (A.ThetaPieceQuotient (π := pi) a j) :=
        IsScalarTower.of_algebraMap_smul fun _ _ => rfl
      letI : Module.Invertible (A.colength j)
          (A.ThetaPieceQuotient (π := pi) a j) :=
        A.invertible_thetaPieceQuotient (π := pi) a j
      exact Module.Invertible.projective_trans (A := A.colength j)
  letI : Module.Projective R (A.ThetaPieceProd (π := pi) a) := by
    exact Module.Projective.of_equiv
      (DirectSum.linearEquivFunOnFintype R D.index
        (fun j => A.ThetaPieceQuotient (π := pi) a j))
  exact Module.Projective.of_equiv
    (A.intrinsicThetaGluedEquivPieceProdOfSwallowedBy (pi := pi) a h).symm