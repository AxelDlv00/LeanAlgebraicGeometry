---
author: sync
content_type: theorem
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivFam.mapAlgHom_comp
docstring: '`mapAlgHom` along a composite is the composite of the base changes

  (`DivFam.mapAlg_comp`).'
file: AlgebraicJacobian/Picard/DivisorFamilyVehicle.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivFam.mapAlgHom_comp
type: lean
updated: '2026-07-31T20:14:51'
---
theorem mapAlgHom_comp (φ : A →ₐ[k] A') (ψ : A' →ₐ[k] A'') (F : DivFam C A π n) :
    mapAlgHom (ψ.comp φ) F = mapAlgHom ψ (mapAlgHom φ F) :=
  letI : Algebra A A' := φ.toRingHom.toAlgebra
  haveI : IsScalarTower k A A' := .of_algebraMap_eq fun x => (φ.commutes x).symm
  letI : Algebra A' A'' := ψ.toRingHom.toAlgebra
  haveI : IsScalarTower k A' A'' := .of_algebraMap_eq fun x => (ψ.commutes x).symm
  letI : Algebra A A'' := (ψ.comp φ).toRingHom.toAlgebra
  haveI : IsScalarTower k A A'' := .of_algebraMap_eq fun x => ((ψ.comp φ).commutes x).symm
  haveI : IsScalarTower A A' A'' := .of_algebraMap_eq fun _ => rfl
  (DivFam.mapAlg_comp A' n A'' F).symm