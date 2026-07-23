---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: PresheafOfModules.restrictScalarsMonoidalOfBijective
file: AlgebraicJacobian/Picard/TensorObjSubstrate/PresheafInternalHom.lean
generated: lean
lean_status: lean_ok
title: PresheafOfModules.restrictScalarsMonoidalOfBijective
type: lean
updated: '2026-07-24T03:02:12'
---
noncomputable def restrictScalarsMonoidalOfBijective
    (α : R ⋙ forget₂ CommRingCat RingCat ⟶ S ⋙ forget₂ CommRingCat RingCat)
    (hα : ∀ U, Function.Bijective (α.app U).hom) :
    (PresheafOfModules.restrictScalars α).Monoidal := by
  haveI hε : IsIso (Functor.LaxMonoidal.ε (PresheafOfModules.restrictScalars α)) :=
    isIso_of_isIso_app _ (fun U => restrictScalars_isIso_ε_of_bijective (α.app U).hom (hα U))
  haveI hμ : ∀ M₁ M₂, IsIso (Functor.LaxMonoidal.μ (PresheafOfModules.restrictScalars α) M₁ M₂) :=
    fun M₁ M₂ => isIso_of_isIso_app _
      (fun U => restrictScalars_isIso_μ_of_bijective (α.app U).hom (hα U) (M₁.obj U) (M₂.obj U))
  exact Functor.Monoidal.ofLaxMonoidal _

end StrongMonoidalRestrictScalars

/-! ## Project-local Mathlib supplement — the internal hom of presheaves of modules
(slice formula): the `R(T)`-module structure on `Hom(M, N)`

This section builds the FIRST primitive of the sheaf internal-hom / dual block
(blueprint `sec:tensorobj_dual_infra`, the `⊗`-inverse's missing ingredient): the
`R(T)`-module structure on the morphism abelian group `M ⟶ N` of presheaves of
modules over a base category `C` with a **terminal object** `T`, where the scalar
ring is the global ring `R(T)`.

This is exactly the module attached to each value of the slice internal hom
`ℋom(M, N)(U) := ModuleCat.of (R(U)) (M|_U ⟶ N|_U)` of
blueprint `def:presheaf_internal_hom`: over the restricted site (terminal `U`),
the section module over `U` is `Hom(M|_U, N|_U)` with its `R(U)`-action. The slice
formula is forced by contravariance of the naive pointwise rule
`U ↦ Hom_{R(U)}(M(U), N(U))`; the module of morphisms of *restricted* objects is
the covariant remedy, and its `R(U)`-module structure is the content here.

The action is `f • φ := φ ≫ globalSMul f`, where `globalSMul f : N ⟶ N` is the
"multiply by the global scalar `f ∈ R(T)`" endomorphism: at an object `Y`, with
`R(T) → R(Y)` the canonical map `termRingMap` induced by the unique `Y → T`, it is
scalar multiplication by the image of `f`. Mathlib has the fixed-ring internal hom
`ihom M N = (M ⟶ N)` (`Mathlib/Algebra/Category/ModuleCat/Monoidal/Closed.lean`) but
nothing for the varying structure sheaf at the `PresheafOfModules` level; this is the
project-local supplement. -/

namespace InternalHom

open CategoryTheory Limits

universe vC uC

variable {C : Type uC} [Category.{vC} C] {R : Cᵒᵖ ⥤ CommRingCat.{u}}
  {T : C} (hT : IsTerminal T)