---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.toModuleKSheaf.kToSection_naturality
docstring: 'Phase A step 5 main, helper (4): the structure-morphism algebra map is

  natural in `U`.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.toModuleKSheaf.kToSection_naturality
type: lean
updated: '2026-07-16T21:14:26'
---
lemma kToSection_naturality (C : Over (Spec (CommRingCat.of k)))
    {U V : (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ} (f : U ⟶ V) :
    kToSection C U ≫ C.left.presheaf.map f = kToSection C V := by
  simp only [kToSection, Category.assoc, ← C.left.presheaf.map_comp]
  rfl