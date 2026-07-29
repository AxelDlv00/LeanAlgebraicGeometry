---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.P1.overlapSectionsEquiv_res_left
docstring: 'Through the section-level identifications, restriction from the left chart
  to the

  overlap is `t ↦ T`.'
file: AlgebraicJacobian/Curve/P1Charts.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.overlapSectionsEquiv_res_left
type: lean
updated: '2026-07-29T15:31:37'
---
theorem overlapSectionsEquiv_res_left (a : Γ(P1 k, chartOpen k 0)) :
    overlapSectionsEquiv k (((P1 k).presheaf.map (homOfLE (overlap_le_left k)).op).hom a) =
      Polynomial.toLaurent (chartSectionsEquiv₀ k a) := by
  obtain ⟨p, rfl⟩ := awayToSection_surjective k (X 0) (X_mem k 0) one_pos a
  rw [res_awayToSection_left, overlapSectionsEquiv_awayToSection,
    chartSectionsEquiv₀_awayToSection, overlapAlgEquiv_awayToOverlapLeft]