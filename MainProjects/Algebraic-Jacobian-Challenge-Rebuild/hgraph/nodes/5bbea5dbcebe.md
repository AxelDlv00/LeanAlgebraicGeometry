---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: CategoryTheory.Sheaf.constModuleSheafHomEquiv_naturality
file: AlgebraicJacobian/Cohomology/ModuleKSheaf.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Sheaf.constModuleSheafHomEquiv_naturality
type: lean
updated: '2026-07-30T15:46:00'
---
lemma constModuleSheafHomEquiv_naturality {F G : Sheaf J (ModuleCat.{u} R)}
    (φ : constModuleSheaf J R ⟶ F) (f : F ⟶ G) :
    constModuleSheafHomEquiv J hT G (φ ≫ f) =
      f.hom.app (op T) (constModuleSheafHomEquiv J hT F φ) := by
  simp only [constModuleSheafHomEquiv]
  rfl

variable (J) in