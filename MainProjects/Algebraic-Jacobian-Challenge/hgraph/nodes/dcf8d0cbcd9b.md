---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.sectionCechCosimplicialMap
docstring: 'The cosimplicial morphism of section Čech objects induced by a morphism
  `φ` of

  presheaves of modules, acting coordinatewise by the underlying presheaf morphism
  on each

  basic-open section group. Project-local: `sectionCechCosimplicial` has no functoriality
  in

  Mathlib.'
file: AlgebraicJacobian/Cohomology/CechToCohomology.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.sectionCechCosimplicialMap
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def sectionCechCosimplicialMap {ι : Type u} (U : ι → TopologicalSpace.Opens X)
    {F G : X.PresheafOfModules} (φ : F ⟶ G) :
    sectionCechCosimplicial U F ⟶ sectionCechCosimplicial U G where
  app n := Limits.Pi.map (fun σ : Fin (n.len + 1) → ι =>
    ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map φ).app (Opposite.op (⨅ k, U (σ k))))
  naturality {m n} f := by
    apply Limits.Pi.hom_ext
    intro σ
    simp only [sectionCechCosimplicial, Category.assoc, Limits.Pi.map_π, Limits.Pi.lift_π,
      Limits.Pi.map_π_assoc, Limits.Pi.lift_π_assoc]
    congr 1
    exact ((PresheafOfModules.toPresheaf X.ringCatSheaf.obj).map φ).naturality _