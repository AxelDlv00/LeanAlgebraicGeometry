---
author: sync
content_type: theorem
created: '2026-07-31T22:54:04'
decl: CategoryTheory.Functor.RepresentableBy.uniqueUpToIsoOfIso_ofLeftAdjoint_conjugate
docstring: 'Transporting a representation across conjugate adjunctions produces the
  conjugate

  right-adjoint isomorphism on the representing object.'
file: AlgebraicJacobian/Picard/RepresentableByCocycle.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Functor.RepresentableBy.uniqueUpToIsoOfIso_ofLeftAdjoint_conjugate
type: lean
updated: '2026-08-01T09:44:17'
---
theorem uniqueUpToIsoOfIso_ofLeftAdjoint_conjugate
    {C : Type u} {D : Type u'} [Category.{v, u} C] [Category.{v, u'} D]
    {L₁ L₂ : C ⥤ D} {R₁ R₂ : D ⥤ C}
    (adj₁ : L₁ ⊣ R₁) (adj₂ : L₂ ⊣ R₂) (α : L₂ ≅ L₁)
    {F : Dᵒᵖ ⥤ Type v} {Y : D} (e : F.RepresentableBy Y) :
    uniqueUpToIsoOfIso
      (ofLeftAdjoint adj₁ e)
      (ofLeftAdjoint adj₂ e)
      (Functor.isoWhiskerRight (NatIso.op α) F) =
      (conjugateIsoEquiv adj₁ adj₂ α).app Y := by
  let e₁ := ofLeftAdjoint adj₁ e
  let e₂ := ofLeftAdjoint adj₂ e
  apply Iso.ext
  apply e₂.homEquiv.injective
  have h : (adj₂.homEquiv (R₁.obj Y) Y).symm
      ((conjugateIsoEquiv adj₁ adj₂ α).app Y).hom =
      α.hom.app (R₁.obj Y) ≫ adj₁.counit.app Y := by
    apply (adj₂.homEquiv (R₁.obj Y) Y).injective
    rw [Equiv.apply_symm_apply]
    have hc := conjugateEquiv_counit adj₁ adj₂ α.hom Y
    have hn := adj₂.homEquiv_naturality_left
      (X' := R₁.obj Y) (X := R₂.obj Y) (Y := Y)
      ((conjugateEquiv adj₁ adj₂ α.hom).app Y) (adj₂.counit.app Y)
    have hunit : (adj₂.homEquiv (R₂.obj Y) Y) (adj₂.counit.app Y) =
        𝟙 (R₂.obj Y) := by
      have hh := adj₂.homEquiv_counit (R₂.obj Y) Y (𝟙 (R₂.obj Y))
      have hh' := congrArg (adj₂.homEquiv (R₂.obj Y) Y) hh
      simpa using hh'.symm
    change (conjugateEquiv adj₁ adj₂ α.hom).app Y = _
    calc
      (conjugateEquiv adj₁ adj₂ α.hom).app Y =
          (conjugateEquiv adj₁ adj₂ α.hom).app Y ≫ 𝟙 _ := by simp
      _ = (conjugateEquiv adj₁ adj₂ α.hom).app Y ≫
          (adj₂.homEquiv (R₂.obj Y) Y) (adj₂.counit.app Y) := by
        rw [hunit, Category.comp_id]
      _ = (adj₂.homEquiv (R₁.obj Y) Y)
          (L₂.map ((conjugateEquiv adj₁ adj₂ α.hom).app Y) ≫ adj₂.counit.app Y) :=
        hn.symm
      _ = (adj₂.homEquiv (R₁.obj Y) Y)
          (α.hom.app (R₁.obj Y) ≫ adj₁.counit.app Y) := by
        exact congrArg (adj₂.homEquiv (R₁.obj Y) Y) hc
  calc
    e₂.homEquiv
        (uniqueUpToIsoOfIso e₁ e₂
          (Functor.isoWhiskerRight (NatIso.op α) F)).hom =
      (Functor.isoWhiskerRight (NatIso.op α) F).hom.app
          (Opposite.op (R₁.obj Y)) (e₁.homEquiv (𝟙 _)) := by
      simpa using homEquiv_uniqueUpToIsoOfIso_hom
        e₁ e₂ (Functor.isoWhiskerRight (NatIso.op α) F) (𝟙 _)
    _ = e.homEquiv (α.hom.app (R₁.obj Y) ≫ adj₁.counit.app Y) := by
      simp only [Functor.isoWhiskerRight_hom, Functor.whiskerRight_app]
      dsimp [e₁]
      rw [ofLeftAdjoint_homEquiv]
      have hunit : (adj₁.homEquiv (R₁.obj Y) Y).symm (𝟙 (R₁.obj Y)) =
          adj₁.counit.app Y := by
        have hh := adj₁.homEquiv_counit (R₁.obj Y) Y (𝟙 (R₁.obj Y))
        simpa using hh
      rw [hunit]
      change (ConcreteCategory.hom (F.map (α.hom.app (R₁.obj Y)).op))
          (e.homEquiv (adj₁.counit.app Y)) =
        e.homEquiv (α.hom.app (R₁.obj Y) ≫ adj₁.counit.app Y)
      exact (e.homEquiv_comp
        (α.hom.app (R₁.obj Y)) (adj₁.counit.app Y)).symm
    _ = e₂.homEquiv ((conjugateIsoEquiv adj₁ adj₂ α).app Y).hom := by
      rw [ofLeftAdjoint_homEquiv, h]
      rfl