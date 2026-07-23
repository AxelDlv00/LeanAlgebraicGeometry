---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: PresheafOfModules.stalkLinearEquivOfIsIso
docstring: '**The `R.stalk x`-linear stalk equivalence of a stalkwise-iso morphism.**
  When the

  underlying Ab-stalk map of `g` at `x` is an isomorphism, `stalkLinearMap g x` upgrades

  to an `R.stalk x`-linear equivalence `M_x ≃ₗ N_x`. This is the exact object the
  route-(e)

  `id_{F_x} ⊗ g_x` step consumes: tensoring it by `id_{F_x}` (`LinearEquiv.lTensor`)
  yields

  an equivalence with no flatness hypothesis.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/Vestigial.lean
generated: lean
lean_status: lean_ok
title: PresheafOfModules.stalkLinearEquivOfIsIso
type: lean
updated: '2026-07-16T21:14:28'
---
noncomputable def stalkLinearEquivOfIsIso
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N) (x : X)
    (h : IsIso ((TopCat.Presheaf.stalkFunctor AddCommGrpCat.{u} x).map ((toPresheaf _).map g))) :
    (↑(TopCat.Presheaf.stalk M.presheaf x) : Type u) ≃ₗ[↑(R.stalk x)]
      (↑(TopCat.Presheaf.stalk N.presheaf x) : Type u) :=
  LinearEquiv.ofBijective (stalkLinearMap g x) (stalkLinearMap_bijective_of_isIso g x h)

end StalkLinearMap

/-! ## Project-local Mathlib supplement — stalk bridges for the topological site

For the topological site `Opens X`, a morphism of presheaves valued in a concrete
category is locally injective iff it is injective on all stalks. Mathlib supplies the
*surjective* analogue for presheaves (`locally_surjective_iff_surjective_on_stalks`) and
the *injective* one only at the sheaf level (`app_injective_iff_stalkFunctor_map_injective`);
the presheaf-level local-injectivity bridge is project-local. Combined, they characterise
the sheafification localizer `J.W` stalkwise (`isIso_stalkFunctor_map_of_W`), the (d.1)
ingredient of the route-(d) whiskering closure. -/

section StalkBridge

open TopologicalSpace TopCat.Presheaf Opposite

universe w

variable {A : Type w} [Category.{u} A] [Limits.HasColimits A]
  {FA : A → A → Type*} {CA : A → Type u} [(P Q : A) → FunLike (FA P Q) (CA P) (CA Q)]
  [ConcreteCategory A FA] [Limits.PreservesFilteredColimits (forget A)]
  {Z : TopCat.{u}}