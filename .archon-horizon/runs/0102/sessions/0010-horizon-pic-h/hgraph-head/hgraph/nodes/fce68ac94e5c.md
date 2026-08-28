---
author: sync
content_type: lemma
created: '2026-07-30T22:26:25'
decl: AlgebraicGeometry.AffAdaptation.eqn_mul_eqnDiv
docstring: Multiplying the cofactor by the restricted widened equation returns the
  section.
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaKernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.eqn_mul_eqnDiv
type: lean
updated: '2026-08-01T09:44:13'
---
lemma eqn_mul_eqnDiv (A : AffAdaptation D d) (j : D.index)
    {W : (relCurve C R).Opens} (hW : W ≤ D.pieces j) (s : Γ(relCurve C R, W))
    (hs : ∀ (z : relCurve C R) (hz : z ∈ W),
      ((relCurve C R).presheaf.germ W z hz).hom s ∈ d.stalkIdeal z) :
    (relCurve C R).resHom hW (A.eqn j) * A.eqnDiv j hW s hs = s :=
  (A.existsUnique_eqn_mul_eq j hW hs).choose_spec.1

/-! ## Stalkwise membership in the theta vanishing submodule -/