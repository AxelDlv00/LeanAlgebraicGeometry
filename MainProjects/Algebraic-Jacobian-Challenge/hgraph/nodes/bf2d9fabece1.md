---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.HModule'_zero_sectionsLinearEquiv_naturality
docstring: 'Naturality of the H⁰-sections bridge in the object `U` (raw `Ext` form):

  for `g : V ⟶ U`, precomposition with `mk₀` of the sheafified free-Yoneda image

  of `g` corresponds, under `HModule''_zero_sectionsLinearEquiv`, to the presheaf

  restriction `(F.obj.map g.op).hom`.


  Blueprint: the square `H⁰(U, F) → H⁰(V, F)` versus `Γ(U, F) → Γ(V, F)`

  commutes.  Proof: chain the degree-zero `Ext` compatibility

  (`linearEquiv₀_mk₀_comp`), the left-naturality of the sheafification

  adjunction (`homEquiv_naturality_left`), and the `U`-naturality of the

  free-Yoneda sections equivalence.


  Consumers should usually use the functorial form

  `HModule''_zero_sectionsLinearEquiv_naturality_map`.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/SectionsBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.HModule'_zero_sectionsLinearEquiv_naturality
type: lean
updated: '2026-07-16T21:14:26'
---
lemma HModule'_zero_sectionsLinearEquiv_naturality
    (F : Sheaf J (ModuleCat.{u} k)) {U V : C} (g : V ⟶ U) (x : HModule' k F 0 U) :
    HModule'_zero_sectionsLinearEquiv k F V
        ((Abelian.Ext.mk₀ ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k) ⋙
          presheafToSheaf J (ModuleCat.{u} k)).map g)).comp x (zero_add 0)) =
      (F.obj.map g.op).hom (HModule'_zero_sectionsLinearEquiv k F U x) := by
  simp only [HModule'_zero_sectionsLinearEquiv, LinearEquiv.trans_apply,
    HModule'_zero_linearEquiv]
  rw [Abelian.Ext.linearEquiv₀_mk₀_comp]
  simp only [Adjunction.homLinearEquiv_apply]
  have e : (yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k) ⋙
      presheafToSheaf J (ModuleCat.{u} k)).map g =
      (presheafToSheaf J (ModuleCat.{u} k)).map
        ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).map g) :=
    rfl
  rw [e, Adjunction.homEquiv_naturality_left]
  exact freeYonedaSectionsLinearEquiv_naturality k F.obj g _

set_option backward.isDefEq.respectTransparency false in