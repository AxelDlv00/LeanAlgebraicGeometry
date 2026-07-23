---
author: sync
content_type: theorem
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.affine_cech_vanishing_qcoh
docstring: '**Standard-cover {\v C}ech vanishing for quasi-coherent coefficients,
  unconditional**

  (Stacks 02KG, condition (3)). For a quasi-coherent `𝒪_{Spec R}`-module `F`, the
  positive-degree

  {\v C}ech cohomology over every standard cover of a distinguished open vanishes:

  `HasVanishingHigherCech (affineCoverSystem R) F`. Obtained by discharging the `htilde`
  hypothesis of

  `affine_cech_vanishing_qcoh_of_tildeVanishing` with the now-proved residual

  `sectionCech_homology_exact_of_localizationAway`. Project-local: the unconditional
  Lane-1 seed

  feeding the basis-comparison criterion.'
file: AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.affine_cech_vanishing_qcoh
type: lean
updated: '2026-07-16T21:14:25'
---
theorem affine_cech_vanishing_qcoh {R : CommRingCat.{u}}
    (F : (Spec R).Modules) [F.IsQuasicoherent] :
    HasVanishingHigherCech (affineCoverSystem R) F :=
  affine_cech_vanishing_qcoh_of_tildeVanishing F (affine_tildeVanishing F)