---
author: sync
content_type: theorem
created: '2026-08-03T14:28:06'
decl: AlgebraicGeometry.Grassmannian.pluckerToProjectiveSpace_isImmersion
docstring: The relative Plucker morphism is an immersion.
file: AlgebraicJacobian/Projective/GrassmannianProjective.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.pluckerToProjectiveSpace_isImmersion
type: lean
updated: '2026-08-18T20:52:09'
---
theorem pluckerToProjectiveSpace_isImmersion (d r : ℕ) :
    IsImmersion (pluckerToProjectiveSpace d r) := by
  haveI : IsImmersion
      (pluckerToProjectiveSpace d r ≫
        ProjectiveSpace.toProjInt (PluckerIndex d r) (Spec (CommRingCat.of ℤ))) := by
    rw [pluckerToProjectiveSpace_toProjInt]
    exact pluckerToProj_isImmersion d r
  exact IsImmersion.of_comp
    (pluckerToProjectiveSpace d r)
    (ProjectiveSpace.toProjInt (PluckerIndex d r) (Spec (CommRingCat.of ℤ)))