---
author: sync
content_type: theorem
created: '2026-07-31T18:11:09'
decl: CategoryTheory.Functor.RepresentableBy.uniqueUpToIso_trans
docstring: 'The canonical isomorphisms between three representations satisfy the cocycle
  law.  The

  `1,3` comparison is the independently defined `uniqueUpToIso e₁ e₃`, not a composite
  alias.'
file: AlgebraicJacobian/Picard/RepresentableByCocycle.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Functor.RepresentableBy.uniqueUpToIso_trans
type: lean
updated: '2026-07-31T20:15:28'
---
theorem uniqueUpToIso_trans {C : Type u} [Category.{v, u} C]
    {F : Cᵒᵖ ⥤ Type v} {Y₁ Y₂ Y₃ : C}
    (e₁ : F.RepresentableBy Y₁) (e₂ : F.RepresentableBy Y₂)
    (e₃ : F.RepresentableBy Y₃) :
    e₁.uniqueUpToIso e₃ = e₁.uniqueUpToIso e₂ ≪≫ e₂.uniqueUpToIso e₃ := by
  apply Iso.ext
  apply e₃.homEquiv.injective
  calc
    e₃.homEquiv (e₁.uniqueUpToIso e₃).hom = e₁.homEquiv (𝟙 Y₁) := by
      simpa using homEquiv_uniqueUpToIso_hom e₁ e₃ (𝟙 Y₁)
    _ = e₂.homEquiv (e₁.uniqueUpToIso e₂).hom := by
      symm
      simpa using homEquiv_uniqueUpToIso_hom e₁ e₂ (𝟙 Y₁)
    _ = e₃.homEquiv
        ((e₁.uniqueUpToIso e₂).hom ≫ (e₂.uniqueUpToIso e₃).hom) := by
      symm
      exact homEquiv_uniqueUpToIso_hom e₂ e₃ (e₁.uniqueUpToIso e₂).hom