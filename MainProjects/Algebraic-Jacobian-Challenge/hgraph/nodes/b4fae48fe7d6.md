---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: CategoryTheory.freeYonedaSections_app_freeMk
docstring: 'Generator-level naturality: a natural transformation `ψ : P_U ⟶ M` out
  of

  the objectwise-free presheaf `P_U = (V ↦ k[(V ⟶ U)])` is determined on the

  basis vector `freeMk f`, `f : V.unop ⟶ U`, by the restriction along `f` of its

  value on the universal generator `freeMk (𝟙 U)`.  Blueprint: `ψ_V([f]) =

  M(f)(ψ_U([𝟙_U]))` — the free-presheaf incarnation of the Yoneda-lemma

  computation.  Proof: apply the naturality square of `ψ` at `f.op` to

  `freeMk (𝟙 U)` and simplify `f ≫ 𝟙 U = f`.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/SectionsBridge.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.freeYonedaSections_app_freeMk
type: lean
updated: '2026-07-24T03:02:10'
---
lemma freeYonedaSections_app_freeMk {M : Cᵒᵖ ⥤ ModuleCat.{u} k} {U : C}
    (ψ : (yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj U ⟶ M)
    {V : Cᵒᵖ} (f : V.unop ⟶ U) :
    (ψ.app V).hom (ModuleCat.freeMk f) =
      (M.map f.op).hom ((ψ.app (Opposite.op U)).hom (ModuleCat.freeMk (𝟙 U))) := by
  have h := ConcreteCategory.congr_hom (ψ.naturality f.op) (ModuleCat.freeMk (𝟙 U))
  simp only [CategoryTheory.comp_apply] at h
  have h2 : (((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj
        (ModuleCat.free k)).obj U).map f.op) (ModuleCat.freeMk (𝟙 U)) =
      ModuleCat.freeMk f := by
    change ((ModuleCat.free k).map ((yoneda.obj U).map f.op)) (ModuleCat.freeMk (𝟙 U)) =
      ModuleCat.freeMk f
    rw [ModuleCat.free_map_apply]
    simp
  rw [h2] at h
  exact h

set_option backward.isDefEq.respectTransparency false in