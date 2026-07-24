---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.restrictScalars_
docstring: '**Pure-tensor value of the presheaf `restrictScalars` *oplax* tensorator
  `δ` (strong case).**

  For a sectionwise-bijective `α`, `restrictScalars α` is strong monoidal, so its
  oplax `δ` is the

  two-sided inverse of the lax `μ` (`Functor.Monoidal.μ_δ`).  On a pure tensor `μ`
  is the identity

  (`restrictScalars_μ_app_tmul`, the base-change tensorator `m ⊗ₜ n ↦ m ⊗ₜ n` modulo
  the ring relabel),

  hence so is `δ`: it sends `m ⊗ₜ[S] n ↦ m ⊗ₜ[R] n`.  This is the δ-twin of `restrictScalars_μ_app_tmul`

  and discharges the `δ Gβ` leg of the K1 `lhs_tmul` telescope (step (3)).'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.Modules.restrictScalars_
type: lean
updated: '2026-07-24T17:03:00'
---
private lemma restrictScalars_δ_app_tmul
    {C : Type u} [Category.{u} C] {R S : Cᵒᵖ ⥤ CommRingCat.{u}}
    (α : (R ⋙ forget₂ CommRingCat RingCat) ⟶ (S ⋙ forget₂ CommRingCat RingCat))
    (hα : ∀ U, Function.Bijective (α.app U).hom)
    (M₁ M₂ : _root_.PresheafOfModules (S ⋙ forget₂ CommRingCat RingCat)) (W : Cᵒᵖ)
    (m : (M₁.obj W)) (n : (M₂.obj W)) :
    letI := PresheafOfModules.restrictScalarsMonoidalOfBijective α hα
    ModuleCat.Hom.hom ((Functor.OplaxMonoidal.δ (PresheafOfModules.restrictScalars α) M₁ M₂).app W)
        (m ⊗ₜ[(S ⋙ forget₂ CommRingCat RingCat).obj W] n)
      = (m ⊗ₜ n : ↑(((PresheafOfModules.restrictScalars α).obj M₁ ⊗
          (PresheafOfModules.restrictScalars α).obj M₂).obj W)) := by
  letI := PresheafOfModules.restrictScalarsMonoidalOfBijective α hα
  have hμ : ModuleCat.Hom.hom
      ((Functor.LaxMonoidal.μ (PresheafOfModules.restrictScalars α) M₁ M₂).app W)
        (m ⊗ₜ[(R ⋙ forget₂ CommRingCat RingCat).obj W] n) = m ⊗ₜ n :=
    restrictScalars_μ_app_tmul α M₁ M₂ W m n
  rw [← hμ, ← LinearMap.comp_apply, ← ModuleCat.hom_comp, ← PresheafOfModules.comp_app,
    Functor.Monoidal.μ_δ]
  rfl