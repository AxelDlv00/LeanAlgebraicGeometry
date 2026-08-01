---
author: sync
content_type: definition
created: '2026-07-31T22:54:03'
decl: AlgebraicGeometry.AffAdaptation.thetaPieceProdEquivSwallowingPiece
docstring: Evaluation at the swallowing piece identifies the theta product with that
  piece.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaSwallowed.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.thetaPieceProdEquivSwallowingPiece
type: lean
updated: '2026-08-01T09:44:13'
---
noncomputable def thetaPieceProdEquivSwallowingPiece
    (A : AffAdaptation D d) (a : Nat) {j0 : D.index}
    (hmiss : ∀ j : D.index, j ≠ j0 →
      Disjoint d.supportLocus (D.pieces j : Set (relCurve C R))) :
    A.ThetaPieceProd (π := pi) a ≃ₗ[R]
      A.ThetaPieceQuotient (π := pi) a j0 := by
  let ev : A.ThetaPieceProd (π := pi) a →ₗ[R]
      A.ThetaPieceQuotient (π := pi) a j0 := LinearMap.proj j0
  apply LinearEquiv.ofBijective ev
  constructor
  · intro x y hxy
    funext j
    by_cases hj : j = j0
    · subst j
      exact hxy
    · haveI : Subsingleton (A.colength j) :=
        A.subsingleton_colength_of_ne_swallowing hmiss j hj
      haveI : Subsingleton (A.ThetaPieceQuotient (π := pi) a j) :=
        Module.subsingleton (A.colength j)
          (A.ThetaPieceQuotient (π := pi) a j)
      exact Subsingleton.elim _ _
  · intro x
    refine ⟨Pi.single j0 x, ?_⟩
    simp [ev]