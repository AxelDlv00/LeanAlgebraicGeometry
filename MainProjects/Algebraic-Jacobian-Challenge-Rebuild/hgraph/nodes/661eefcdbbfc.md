---
author: sync
content_type: theorem
created: '2026-07-17T16:57:14'
decl: AlgebraicGeometry.RelPicTransportFamily.mapAlg_picEtAffHom
docstring: 'The étale-plus transport commutes with restriction along an explicit algebra
  map of

  affine tests, stated for a `kT`-algebra map restricted to the two base fields —
  the

  `mapAlg` bilateral square.'
file: AlgebraicJacobian/Picard/PicEtAffTransport.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.RelPicTransportFamily.mapAlg_picEtAffHom
type: lean
updated: '2026-07-29T15:31:47'
---
theorem mapAlg_picEtAffHom (φ : A →ₐ[kT] A') (a : PicEtAff E A) :
    T.picEtAffHom A' (PicEtAff.mapAlg E (φ.restrictScalars kE) a)
      = PicEtAff.mapAlg D (φ.restrictScalars kD) (T.picEtAffHom A a) := by
  letI : Algebra A A' := φ.toRingHom.toAlgebra
  haveI : IsScalarTower kD A A' :=
    .of_algebraMap_eq fun r => ((φ.restrictScalars kD).commutes r).symm
  haveI : IsScalarTower kE A A' :=
    .of_algebraMap_eq fun r => ((φ.restrictScalars kE).commutes r).symm
  change T.picEtAffHom A' (PicEtAff.map E A' a) = PicEtAff.map D A' (T.picEtAffHom A a)
  exact T.map_picEtAffHom a