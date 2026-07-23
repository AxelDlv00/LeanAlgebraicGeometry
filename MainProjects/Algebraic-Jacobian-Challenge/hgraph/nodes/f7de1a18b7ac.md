---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.pullback_tildeIso
docstring: '**Spec-level pullback-of-tilde formula** (iter-187 Lane F NAMED HELPER,

  PROVED axiom-clean this session).


  For a ring map `φ : A ⟶ B` of commutative rings, the module-sheaf pullback

  along `Spec.map φ : Spec B ⟶ Spec A` sends `tilde M` to (the `tilde` of)

  the base-change module `M ⊗_A B` on `Spec B`. This is the substantive

  Mathlib gap (Stacks tag 01HQ / 0BJ8): the "pullback of tilde = tilde of

  base change" identification.


  Direct LSP searches (iter-187 analogist, `quotscheme-isbasechange-tilde.md`)

  confirm Mathlib (pinned commit `b80f227`) has no such lemma; the only

  pullback formula at all is `pullbackObjFreeIso` on *free* sheaves

  (`PullbackFree.lean:122`), too restrictive for general modules.


  PROVED (T12 session, 2026-07-03), axiom-clean, by uniqueness of left adjoints:

  `tilde.functor A ⋙ pullback (Spec.map φ)` and `extendScalars φ.hom ⋙ tilde.functor
  B`

  are both left adjoint to `pushforward (Spec.map φ) ⋙ moduleSpecΓFunctor ≅

  moduleSpecΓFunctor ⋙ restrictScalars φ.hom` (`pullbackTilde_gammaBridge`), so

  `Adjunction.leftAdjointUniq` produces the iso, whose evaluation at `M` is the

  required `(Spec.map φ)^* (tilde M) ≅ tilde (B ⊗_A M)`. The Σ-pair section identity

  is `Adjunction.unit_leftAdjointUniq_hom_app` applied at `m`: the unit of the first

  composed adjunction traced through the bridge is definitionally

  `pullback_app_isoTensor_baseMap ∘ tilde.toOpen`, while the unit of the second is

  definitionally `tilde.toOpen ∘ (1 ⊗ₜ ·)`.'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pullback_tildeIso
type: lean
updated: '2026-07-16T21:14:27'
---
private theorem pullback_tildeIso
    {A B : CommRingCat.{u}} (φ : A ⟶ B) (M : ModuleCat.{u} A) :
    letI : Algebra A B := φ.hom.toAlgebra
    letI : Algebra Γ(Spec A, ⊤) Γ(Spec B, ⊤) :=
      ((Spec.map φ).appLE ⊤ ⊤ le_top).hom.toAlgebra
    letI : Module Γ(Spec A, ⊤)
        Γ((Scheme.Modules.pullback (Spec.map φ)).obj (tilde M), ⊤) :=
      Module.compHom _ ((Spec.map φ).appLE ⊤ ⊤ le_top).hom
    Nonempty {iso : (Scheme.Modules.pullback (Spec.map φ)).obj (tilde M) ≅
        tilde (ModuleCat.of B (TensorProduct A B M)) //
      -- Canonical Spec base-change iso identity (Stacks 01HQ / 0BJ8): the
      -- iso, evaluated at ⊤-sections, sends the canonical pullback-section
      -- image of `tilde.toOpen M ⊤ m` (built via the adjunction-unit base map
      -- `pullback_app_isoTensor_baseMap` on `tilde M`) to `tilde.toOpen … ⊤`
      -- applied to `1 ⊗ₜ m`. This characterizes the iso as the canonical
      -- "pullback of tilde = tilde of base change" identification.
      ∀ (m : M),
        (Scheme.Modules.Hom.app iso.hom ⊤).hom
            (pullback_app_isoTensor_baseMap (Spec.map φ) (tilde M) le_top
              ((tilde.toOpen M ⊤).hom m)) =
          (tilde.toOpen (ModuleCat.of B (TensorProduct A B M)) ⊤).hom
            (1 ⊗ₜ[A] m)} := by
  letI : Algebra A B := φ.hom.toAlgebra
  letI : Algebra Γ(Spec A, ⊤) Γ(Spec B, ⊤) :=
    ((Spec.map φ).appLE ⊤ ⊤ le_top).hom.toAlgebra
  letI : Module Γ(Spec A, ⊤)
      Γ((Scheme.Modules.pullback (Spec.map φ)).obj (tilde M), ⊤) :=
    Module.compHom _ ((Spec.map φ).appLE ⊤ ⊤ le_top).hom
  -- The two composed adjunctions with the SAME right adjoint
  -- `moduleSpecΓFunctor (R := ↑B) ⋙ restrictScalars φ.hom` (via the bridge).
  let adj1 : (tilde.functor ↑A ⋙ Scheme.Modules.pullback (Spec.map φ)) ⊣
      (moduleSpecΓFunctor (R := ↑B) ⋙ ModuleCat.restrictScalars φ.hom) :=
    ((tilde.adjunction (R := ↑A)).comp
      (Scheme.Modules.pullbackPushforwardAdjunction (Spec.map φ))).ofNatIsoRight
      (pullbackTilde_gammaBridge φ)
  let adj2 : (ModuleCat.extendScalars φ.hom ⋙ tilde.functor ↑B) ⊣
      (moduleSpecΓFunctor (R := ↑B) ⋙ ModuleCat.restrictScalars φ.hom) :=
    (ModuleCat.extendRestrictScalarsAdj φ.hom).comp (tilde.adjunction (R := ↑B))
  -- Uniqueness of left adjoints.
  let mainIso : (tilde.functor ↑A ⋙ Scheme.Modules.pullback (Spec.map φ)) ≅
      (ModuleCat.extendScalars φ.hom ⋙ tilde.functor ↑B) :=
    Adjunction.leftAdjointUniq adj1 adj2
  refine ⟨⟨mainIso.app M, fun m => ?_⟩⟩
  -- The unit-compatibility of `leftAdjointUniq`, applied at `m`; both sides
  -- reduce definitionally to the stated Σ-pair identity (the first unit is
  -- `baseMap ∘ toOpen` through the bridge; the second is `toOpen ∘ (1 ⊗ₜ ·)`).
  have key := Adjunction.unit_leftAdjointUniq_hom_app adj1 adj2 M
  exact congrArg (fun (f : M ⟶ (moduleSpecΓFunctor (R := ↑B) ⋙
    ModuleCat.restrictScalars φ.hom).obj ((ModuleCat.extendScalars φ.hom ⋙
      tilde.functor ↑B).obj M)) => f.hom m) key