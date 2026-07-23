---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Adelic.span_pow_p1BaseChangeY
docstring: The `y`-chart mirror of `span_pow_p1BaseChangeX`.
file: AlgebraicJacobian/Picard/RigidPushforwardP1Engine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.span_pow_p1BaseChangeY
type: lean
updated: '2026-07-24T03:02:11'
---
theorem span_pow_p1BaseChangeY :
    letI := (((pullback.snd (p1Over k).hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A)))).appLE
        ⊤ (pullback.fst (p1Over k).hom (Spec.map (CommRingCat.ofHom (algebraMap k A))) ⁻¹ᵁ
          (p1LaurentChartData k).V₁)
        le_top).hom).toAlgebra
    ⊤ ≤ Submodule.span Γ(Spec (CommRingCat.of A), ⊤)
      (Set.range fun n : ℕ =>
        ((pullback.fst (p1Over k).hom
          (Spec.map (CommRingCat.ofHom (algebraMap k A)))).app
            (p1LaurentChartData k).V₁).hom (p1LaurentChartData k).y ^ n) :=
  span_pow_section_of_isPullback
    (IsPullback.of_hasPullback (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A))))
    (isAffineOpen_top _) (isAffineOpen_top _)
    (p1LaurentChartData k).isAffineOpen_V₁ (p1LaurentChartData k).y
    (span_section_base_of_span_k _ (p1LaurentChartData k).span_pow_y)

set_option maxHeartbeats 800000 in
-- `maxHeartbeats`: the field checks cross the `p1BaseChangeCoverSquare` /
-- `preimage` / `p1LaurentChartData` presentation diamonds (fleet recipe).