/- SCRATCH (session 0003-horizon-T2) — fast-iteration copy of the Stage-2 mate-factorization
lemmas destined for `Cohomology/CechHigherDirectImageUnconditional.lean`.  Imports only
Mathlib (+ the light `ModulesCoverConservativity`) so it compiles without the heavy
project dependency chain.  DELETE BEFORE COMMIT. -/
import Mathlib
import AlgebraicJacobian.Cohomology.ModulesCoverConservativity

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

variable {X X' : Scheme.{u}}

/-- scratch replica of `openImmersion_bareBC` (same body). -/
noncomputable def scratch_bareBC {V V' : Scheme.{u}}
    (g' : X' ⟶ X) (p : V ⟶ X) (p' : V' ⟶ X') (gV : V' ⟶ V)
    (hsq : IsPullback gV p' p g') :
    Scheme.Modules.pushforward p ⋙ Scheme.Modules.pullback g' ⟶
      Scheme.Modules.pullback gV ⋙ Scheme.Modules.pushforward p' :=
  CategoryTheory.mateEquiv
    (pullbackPushforwardAdjunction p)
    (pullbackPushforwardAdjunction p')
    (((pullbackComp p' g') ≪≫
      pullbackCongr hsq.w.symm ≪≫
      (pullbackComp gV p).symm).hom)

set_option backward.isDefEq.respectTransparency false in
theorem scratch_counit_isIso {V : Scheme.{u}} (q : V ⟶ X)
    [IsOpenImmersion q] (c : V.Modules) :
    IsIso ((Scheme.Modules.pullbackPushforwardAdjunction q).counit.app c) := by
  haveI hnat : IsIso ((Scheme.Modules.restrictAdjunction q).counit) :=
    inferInstanceAs (IsIso (Scheme.Modules.restrictFunctorAdjCounitIso q).hom)
  haveI happ : IsIso ((Scheme.Modules.restrictAdjunction q).counit.app c) :=
    NatIso.isIso_app_of_isIso _ c
  exact IsIso.of_isIso_fac_left (Adjunction.leftAdjointUniq_hom_app_counit
    (Scheme.Modules.restrictAdjunction q) (Scheme.Modules.pullbackPushforwardAdjunction q) c)

set_option backward.isDefEq.respectTransparency false in
theorem scratch_bareBC_app_eq {V V' : Scheme.{u}}
    (g' : X' ⟶ X) (p : V ⟶ X) (p' : V' ⟶ X') (gV : V' ⟶ V)
    (hsq : IsPullback gV p' p g') (c : V.Modules) :
    (scratch_bareBC g' p p' gV hsq).app c =
      (Scheme.Modules.pullbackPushforwardAdjunction p').unit.app
          ((Scheme.Modules.pullback g').obj ((Scheme.Modules.pushforward p).obj c)) ≫
        (Scheme.Modules.pushforward p').map
          ((pullbackComp p' g').hom.app ((Scheme.Modules.pushforward p).obj c)) ≫
        (Scheme.Modules.pushforward p').map
          ((pullbackCongr hsq.w.symm).hom.app ((Scheme.Modules.pushforward p).obj c)) ≫
        (Scheme.Modules.pushforward p').map
          ((pullbackComp gV p).inv.app ((Scheme.Modules.pushforward p).obj c)) ≫
        (Scheme.Modules.pushforward p').map ((Scheme.Modules.pullback gV).map
          ((Scheme.Modules.pullbackPushforwardAdjunction p).counit.app c)) := by
  simp [scratch_bareBC, mateEquiv_apply]
  erw [Category.id_comp, Category.id_comp, Category.comp_id]
  rfl

set_option backward.isDefEq.respectTransparency false in
theorem scratch_bareBC_app_isIso_of_unit {V V' : Scheme.{u}}
    (g' : X' ⟶ X) (p : V ⟶ X) (p' : V' ⟶ X') (gV : V' ⟶ V)
    (hsq : IsPullback gV p' p g') [IsOpenImmersion p] (c : V.Modules)
    (hu : IsIso ((Scheme.Modules.pullbackPushforwardAdjunction p').unit.app
      ((Scheme.Modules.pullback g').obj ((Scheme.Modules.pushforward p).obj c)))) :
    IsIso ((scratch_bareBC g' p p' gV hsq).app c) := by
  rw [scratch_bareBC_app_eq]
  haveI := hu
  haveI := scratch_counit_isIso p c
  infer_instance

/-- unit-iso from essential-image membership, for open immersions. -/
theorem scratch_unit_isIso_of_essImage {V' : Scheme.{u}} (p' : V' ⟶ X')
    [IsOpenImmersion p'] (M : X'.Modules)
    (h : (Scheme.Modules.pushforward p').essImage M) :
    IsIso ((Scheme.Modules.pullbackPushforwardAdjunction p').unit.app M) := by
  obtain ⟨K, ⟨e⟩⟩ := h
  exact (Scheme.Modules.pullbackPushforwardAdjunction p').isIso_unit_app_of_iso e.symm

/-- component of a restricted morphism is the component at the image open (rfl). -/
theorem scratch_restrictFunctor_map_app {W : Scheme.{u}} (w : W ⟶ X') [IsOpenImmersion w]
    {M N : X'.Modules} (ψ : M ⟶ N) (O : W.Opens) :
    ((Scheme.Modules.restrictFunctor w).map ψ).app O = ψ.app (w ''ᵁ O) := rfl

/-- L2: if `N` is (isomorphic to) a pushforward from the open `O₀ ⊆ W`, then all its
restriction maps `N(O) → N(O ⊓ O₀)` are isomorphisms. -/
theorem scratch_restrictionMap_isIso_of_essImage {W : Scheme.{u}} (O₀ : W.Opens)
    (N : W.Modules) (h : (Scheme.Modules.pushforward O₀.ι).essImage N) (O : W.Opens) :
    IsIso (N.presheaf.map (homOfLE (inf_le_left : O ⊓ O₀ ≤ O)).op) := by
  obtain ⟨K, ⟨e⟩⟩ := h
  have eP : ((Scheme.Modules.pushforward O₀.ι).obj K).presheaf ≅ N.presheaf :=
    (Scheme.Modules.toPresheaf W).mapIso e
  -- the pushforward side is `K.presheaf.map` of a hom between equal opens, hence iso
  have hpre : Opposite.op (O₀.ι ⁻¹ᵁ O) = Opposite.op (O₀.ι ⁻¹ᵁ (O ⊓ O₀)) := by
    rw [Scheme.Hom.preimage_inf, Scheme.Opens.ι_preimage_self, inf_top_eq]
  haveI hK : IsIso
      ((((Scheme.Modules.pushforward O₀.ι).obj K).presheaf.map
        (homOfLE (inf_le_left : O ⊓ O₀ ≤ O)).op)) := by
    rw [Scheme.Modules.pushforward_obj_presheaf_map]
    have hcast : ((TopologicalSpace.Opens.map O₀.ι.base).map
        (homOfLE (inf_le_left : O ⊓ O₀ ≤ O))).op = eqToHom hpre := by
      apply Quiver.Hom.unop_inj
      apply Subsingleton.elim
    rw [hcast]
    infer_instance
  -- conjugate through `e` by naturality
  have nat := eP.hom.naturality (homOfLE (inf_le_left : O ⊓ O₀ ≤ O)).op
  exact IsIso.of_isIso_fac_left nat.symm

/-- L3 (assembly): membership in the essential image of `p'_*` is cover-local.  If the
restriction of `M` to every member `W_j` of an open cover of `X'` is a pushforward from
the open `W_j ∩ (g'-preimage of ran p')` — i.e. from `(𝒞.f j) ⁻¹ᵁ p'.opensRange` — then
`M` itself is a pushforward along `p'`. -/
theorem scratch_essImage_of_openCover {V' : Scheme.{u}} (p' : V' ⟶ X') [IsOpenImmersion p']
    (M : X'.Modules) (𝒞 : X'.OpenCover)
    (hloc : ∀ j, (Scheme.Modules.pushforward ((𝒞.f j) ⁻¹ᵁ p'.opensRange).ι).essImage
      ((Scheme.Modules.restrictFunctor (𝒞.f j)).obj M)) :
    (Scheme.Modules.pushforward p').essImage M := by
  -- the site-level unit is an isomorphism, checked cover-locally with plain components
  have hsite : IsIso ((Scheme.Modules.restrictAdjunction p').unit.app M) := by
    rw [Scheme.Modules.Hom.isIso_iff_isIso_restrict _ 𝒞]
    intro j
    haveI : IsOpenImmersion (𝒞.f j) := Scheme.Cover.map_prop 𝒞 j
    rw [Scheme.Modules.Hom.isIso_iff_isIso_app]
    intro O
    rw [scratch_restrictFunctor_map_app, Scheme.Modules.restrictAdjunction_unit_app_app]
    -- identify the target open: w''(O ⊓ w⁻¹(ran p')) = p'''(p'⁻¹(w''O))
    have hOO : (𝒞.f j) ''ᵁ (O ⊓ (𝒞.f j) ⁻¹ᵁ p'.opensRange)
        = p' ''ᵁ (p' ⁻¹ᵁ ((𝒞.f j) ''ᵁ O)) := by
      rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
      apply TopologicalSpace.Opens.ext
      show ((𝒞.f j) '' (O ∩ (𝒞.f j) ⁻¹' p'.opensRange) : Set X') = _
      rw [Set.image_inter_preimage, Set.inter_comm]
    -- factor the unit component through the member restriction map + a cast
    have hfac : M.presheaf.map (homOfLE (p'.image_preimage_le ((𝒞.f j) ''ᵁ O))).op
        = M.presheaf.map
            ((𝒞.f j).opensFunctor.map
              (homOfLE (inf_le_left : O ⊓ (𝒞.f j) ⁻¹ᵁ p'.opensRange ≤ O))).op ≫
          M.presheaf.map (eqToHom (congrArg Opposite.op hOO)) := by
      rw [← Functor.map_comp]
      congr 1
      apply Quiver.Hom.unop_inj
      apply Subsingleton.elim
    rw [hfac]
    haveI hkey : IsIso (M.presheaf.map
        ((𝒞.f j).opensFunctor.map
          (homOfLE (inf_le_left : O ⊓ (𝒞.f j) ⁻¹ᵁ p'.opensRange ≤ O))).op) :=
      scratch_restrictionMap_isIso_of_essImage _ _ (hloc j) O
    infer_instance
  -- transport to the geometric unit and conclude essential-image membership
  haveI hunit : IsIso ((Scheme.Modules.pullbackPushforwardAdjunction p').unit.app M) := by
    rw [← Adjunction.unit_leftAdjointUniq_hom_app (Scheme.Modules.restrictAdjunction p')
      (Scheme.Modules.pullbackPushforwardAdjunction p') M]
    haveI happ : IsIso ((Adjunction.leftAdjointUniq (Scheme.Modules.restrictAdjunction p')
        (Scheme.Modules.pullbackPushforwardAdjunction p')).hom.app M) :=
      NatIso.isIso_app_of_isIso _ M
    haveI := hsite
    infer_instance
  exact (Scheme.Modules.pullbackPushforwardAdjunction p').mem_essImage_of_unit_isIso M

end AlgebraicGeometry
