---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: CategoryTheory.Sheaf.constModuleSheafHomEquiv
docstring: 'Morphisms out of the constant sheaf `R` compute global sections, `R`-linearly:

  `Hom(R_X, F) ≃ₗ[R] F(⊤)`.'
file: AlgebraicJacobian/Cohomology/ModuleKSheaf.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Sheaf.constModuleSheafHomEquiv
type: lean
updated: '2026-07-30T15:46:00'
---
noncomputable def constModuleSheafHomEquiv (F : Sheaf J (ModuleCat.{u} R)) :
    (constModuleSheaf J R ⟶ F) ≃ₗ[R] F.obj.obj (op T) :=
  (constantSheafAdjHomLinearEquiv hT (ModuleCat.of R R) F).trans
    (ModuleCat.homLinearEquiv.trans (LinearMap.ringLmapEquivSelf R R _))