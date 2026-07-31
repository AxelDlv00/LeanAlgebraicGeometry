---
author: sync
content_type: definition
created: '2026-08-01T04:12:00'
decl: AlgebraicGeometry.Scheme.Modules.moduleSpecStalkModule
docstring: 'A sheaf-module stalk on `Spec R`, regarded as an `R`-module through the

  canonical map from `R` to the structure-sheaf stalk.'
file: AlgebraicJacobian/Picard/AffineStalkLocalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.moduleSpecStalkModule
type: lean
updated: '2026-08-01T04:12:00'
---
noncomputable abbrev moduleSpecStalkModule
    (F : (Spec R).Modules) (x : PrimeSpectrum.Top R) :
    Module R (↑(TopCat.Presheaf.stalk F.val.presheaf x) : Type u) := by
  letI : Module ((Spec R).presheaf.stalk x)
      (↑(TopCat.Presheaf.stalk F.val.presheaf x) : Type u) :=
    presheafStalkModule F.val x
  exact Module.compHom _
    (((Scheme.ΓSpecIso R).inv ≫ (Spec R).presheaf.germ ⊤ x trivial).hom)