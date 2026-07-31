---
author: sync
content_type: lemma
created: '2026-07-18T21:01:13'
decl: AlgebraicGeometry.span_divFamEpsWindowGermSet_le
docstring: '**The easy inclusion at the family level**: window germs lie in the stalk
  ideal —

  the window is the preimage of the vanishing submodule, whose membership clauses
  are the

  germ conditions.'
file: AlgebraicJacobian/Picard/DivSchemeMonoBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.span_divFamEpsWindowGermSet_le
type: lean
updated: '2026-07-31T20:15:22'
---
lemma span_divFamEpsWindowGermSet_le (g : ℕ) (G : CertifiedDivisorFamily C R π g)
    (z : relCurve C R) :
    Ideal.span (divFamEpsWindowGermSet hπ g (DivFam.mk G) z)
      ≤ G.eqns.stalkIdeal z := by
  refine span_twistGermSet_le_stalkIdeal G.eqns ?_ z
  have h0 : (divFamEps hπ g (DivFam.mk G)).1
      = divisorWindow G.eqns (relThetaPairH1_windowM C π hπ g) := rfl
  have h1 : Submodule.map (relThetaWindowEquiv C R π (windowM_choice π hπ g)
        (relThetaPairH1_windowM C π hπ g)).toLinearMap ((divFamEps hπ g (DivFam.mk G)).1)
      = G.eqns.vanishingSubmodule R (relCover C R (fiberTwoCover π)).V₀
          (relCover C R (fiberTwoCover π)).V₁
          (relThetaCocycle C R π (windowM_choice π hπ g)) := by
    rw [h0, divisorWindow]
    exact Submodule.map_comap_eq_of_surjective
      (relThetaWindowEquiv C R π (windowM_choice π hπ g)
        (relThetaPairH1_windowM C π hπ g)).surjective _
  rw [h1]