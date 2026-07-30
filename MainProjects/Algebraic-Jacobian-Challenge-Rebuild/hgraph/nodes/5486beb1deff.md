---
author: sync
content_type: theorem
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.fiberPolyHom₀_X
docstring: The chart-0 polynomial algebra sends `t` to the pulled-back chart coordinate.
file: AlgebraicJacobian/Cohomology/RigidEngine4Relative.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.fiberPolyHom₀_X
type: lean
updated: '2026-07-30T15:46:00'
---
theorem fiberPolyHom₀_X : fiberPolyHom₀ π Polynomial.X = fiberCoord π := by
  have h : (P1.chartSectionsEquiv₀ k).symm Polynomial.X
      = (Proj.awayToSection 𝒜 (X 0)).hom (P1.chartCoord k 0 1) := by
    apply (P1.chartSectionsEquiv₀ k).injective
    rw [RingEquiv.apply_symm_apply, P1.chartSectionsEquiv₀_awayToSection,
      P1.awayAlgEquiv_chartCoord]
  change (π.app (P1.chartOpen k 0)).hom ((P1.chartSectionsEquiv₀ k).symm Polynomial.X)
    = fiberCoord π
  rw [h]
  rfl