---
author: sync
content_type: theorem
created: '2026-07-28T14:03:57'
decl: AlgebraicGeometry.Modules.mono_of_injective_app
docstring: '**Sectionwise criterion for a monomorphism of `𝒪_X`-modules.**  If `φ`
  is injective on

  sections over *every* open then `φ` is a monomorphism: injectivity on all opens
  makes the

  underlying `Ab`-presheaf morphism sectionwise mono, hence mono in the functor category,
  and

  the faithful `Scheme.Modules.toPresheaf` reflects monomorphisms.  Converse of

  `Modules.injective_app_of_mono`; sharpened to a basis just below.  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Modules.mono_of_injective_app
type: lean
updated: '2026-07-28T14:03:57'
---
theorem Modules.mono_of_injective_app {X : Scheme.{u}} {M N : X.Modules} {φ : M ⟶ N}
    (h : ∀ U : X.Opens, Function.Injective (φ.app U)) : Mono φ := by
  have hpre : Mono ((Scheme.Modules.toPresheaf X).map φ) := by
    haveI : ∀ U, Mono (((Scheme.Modules.toPresheaf X).map φ).app U) := fun U =>
      (AddCommGrpCat.mono_iff_injective _).mpr (h U.unop)
    exact NatTrans.mono_of_mono_app _
  haveI := hpre
  exact (Scheme.Modules.toPresheaf X).mono_of_mono_map hpre

set_option backward.isDefEq.respectTransparency false in