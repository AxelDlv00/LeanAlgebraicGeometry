---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: Module.IsDescentCocycle.picClass_baseChange
docstring: '**Naturality of the Picard class of a descent cocycle in the base ring**:
  the class

  of the base-changed cocycle along `A → A''` is the image of the class under

  `CommRing.Pic.mapAlgebra`.  Faithful flatness of the base-changed cover `A'' ⊗[A]
  B` over

  `A''` is a hypothesis (automatic for the covers in use, e.g. products of localizations

  along a covering family).'
file: AlgebraicJacobian/Descent/UnitDescentBaseChange.lean
generated: lean
lean_status: lean_ok
title: Module.IsDescentCocycle.picClass_baseChange
type: lean
updated: '2026-07-16T21:33:28'
---
theorem IsDescentCocycle.picClass_baseChange [Module.FaithfullyFlat A B]
    [Module.FaithfullyFlat A' (A' ⊗[A] B)] {u : (B ⊗[A] B)ˣ} (hu : IsDescentCocycle u) :
    (hu.baseChange (A' := A')).picClass = CommRing.Pic.mapAlgebra A A' hu.picClass := by
  rw [IsDescentCocycle.picClass, IsDescentCocycle.picClass,
    CommRing.Pic.mapAlgebra_apply, CommRing.Pic.mk_eq_mk_iff]
  exact ⟨(descendedBaseChangeEquiv hu).symm.trans
    (AlgebraTensorModule.congr (LinearEquiv.refl A' A')
      (CommRing.Pic.mk.linearEquiv A hu.descended).symm)⟩