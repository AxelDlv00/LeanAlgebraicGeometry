---
author: sync
content_type: theorem
created: '2026-07-18T21:01:13'
decl: AlgebraicGeometry.divFam_stalkIdeal_eq_of_eps_eq
docstring: '**The discharged `hbridge` shape**: two certified families with equal
  `ε`-pairs and

  window generation have equal stalk ideals at every point — both stalk ideals are
  the

  span of the SAME window germ set (`heps` transports the germ sets).'
file: AlgebraicJacobian/Picard/DivSchemeMonoBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFam_stalkIdeal_eq_of_eps_eq
type: lean
updated: '2026-07-30T15:46:02'
---
theorem divFam_stalkIdeal_eq_of_eps_eq (g : ℕ)
    (G G' : CertifiedDivisorFamily C R π g)
    (heps : divFamEps hπ g (DivFam.mk G) = divFamEps hπ g (DivFam.mk G'))
    (hwin : ∀ z : relCurve C R, ∃ s : Ideal R,
      (∀ r ∈ s, algebraMap R ((relCurve C R).presheaf.stalk z) r
        ∈ IsLocalRing.maximalIdeal ((relCurve C R).presheaf.stalk z)) ∧
      G.eqns.stalkIdeal z
        ≤ Ideal.span (divFamEpsWindowGermSet hπ g (DivFam.mk G) z)
          ⊔ Ideal.map (algebraMap R ((relCurve C R).presheaf.stalk z)) s)
    (hwin' : ∀ z : relCurve C R, ∃ s : Ideal R,
      (∀ r ∈ s, algebraMap R ((relCurve C R).presheaf.stalk z) r
        ∈ IsLocalRing.maximalIdeal ((relCurve C R).presheaf.stalk z)) ∧
      G'.eqns.stalkIdeal z
        ≤ Ideal.span (divFamEpsWindowGermSet hπ g (DivFam.mk G') z)
          ⊔ Ideal.map (algebraMap R ((relCurve C R).presheaf.stalk z)) s)
    (z : relCurve C R) :
    G.eqns.stalkIdeal z = G'.eqns.stalkIdeal z := by
  have hset : divFamEpsWindowGermSet hπ g (DivFam.mk G) z
      = divFamEpsWindowGermSet hπ g (DivFam.mk G') z := by
    unfold divFamEpsWindowGermSet
    rw [heps]
  rw [CertifiedDivisorFamily.stalkIdeal_eq_span_windowGerm hπ g G hwin z,
    CertifiedDivisorFamily.stalkIdeal_eq_span_windowGerm hπ g G' hwin' z, hset]