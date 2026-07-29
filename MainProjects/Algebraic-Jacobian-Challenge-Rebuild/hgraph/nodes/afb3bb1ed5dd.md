---
author: sync
content_type: definition
created: '2026-07-29T09:42:53'
decl: AlgebraicGeometry.AffAdaptation.thetaDeltaRight
docstring: '**The Θ-twisted right overlap arrow** over a widened cover: restrict the
  `p.2`

  component to each overlap and multiply by the twisting unit of the pair.  Verbatim

  `DivisorAdaptation.thetaDeltaRight` (`Picard/DivisorFamilyTheta.lean:203`) with

  `thetaOvlUnit` read off `τ`.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffTheta.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.thetaDeltaRight
type: lean
updated: '2026-07-29T15:26:31'
---
noncomputable def thetaDeltaRight : A.chartProd →ₗ[R] A.ovlProd :=
  LinearMap.pi (fun p : D.index × D.index =>
    LinearMap.mulLeft R (Ideal.Quotient.mk (A.ovlIdeal p.1 p.2)
        ((thetaOvlUnit τ a p.1 p.2 :
          Γ(relCurve C R, D.pieces p.1 ⊓ D.pieces p.2)ˣ) :
          Γ(relCurve C R, D.pieces p.1 ⊓ D.pieces p.2))) ∘ₗ
      (A.toOvlRight p.1 p.2).toLinearMap ∘ₗ LinearMap.proj p.2)