---
author: sync
content_type: theorem
created: '2026-07-17T22:01:16'
decl: AlgebraicGeometry.Scheme.LocalEquations.germ_pullbackEqn_mem_nonZeroDivisors_of_immersion_cover
docstring: '**Pulled-equation germ regularity is Zariski-local on the source**

  (the S5b mapAlg-hreg engine): for a jointly surjective family of open immersions

  `w i : Z i ⟶ Y`, if the pulled equations of `E` along each composite `w i ≫ f` have

  nonzerodivisor germs at the base points of their own members, then the pulled

  equations of `E` along `f` have nonzerodivisor germs everywhere — each germ transports

  through the stalk isomorphism of an immersion covering its point.'
file: AlgebraicJacobian/Picard/DivisorFamilyZarKit.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.LocalEquations.germ_pullbackEqn_mem_nonZeroDivisors_of_immersion_cover
type: lean
updated: '2026-07-31T20:14:49'
---
theorem germ_pullbackEqn_mem_nonZeroDivisors_of_immersion_cover
    {ι : Type*} {Z : ι → Scheme.{u}} (w : ∀ i, Z i ⟶ Y) [∀ i, IsOpenImmersion (w i)]
    (hcover : ∀ y : Y, ∃ (i : ι) (z : Z i), (w i).base z = y)
    (f : Y ⟶ X) (E : X.LocalEquations)
    (hreg : ∀ (i : ι) (ζ : Z i),
      ((Z i).presheaf.germ ((E.cover.pullback (w i ≫ f)).opens ζ) ζ
          ((E.cover.pullback (w i ≫ f)).mem_opens ζ)).hom (pullbackEqn (w i ≫ f) E ζ)
        ∈ nonZeroDivisors ((Z i).presheaf.stalk ζ)) :
    ∀ (y z : Y) (hz : z ∈ (E.cover.pullback f).opens y),
      (Y.presheaf.germ ((E.cover.pullback f).opens y) z hz).hom (pullbackEqn f E y)
        ∈ nonZeroDivisors (Y.presheaf.stalk z) := by
  refine germ_pullbackEqn_mem_nonZeroDivisors_of_forall_self f E fun z => ?_
  obtain ⟨i, ζ, hζ⟩ := hcover z
  subst hζ
  -- push the germ through the stalk isomorphism of the covering immersion
  have hmem : ζ ∈ (w i) ⁻¹ᵁ (E.cover.pullback f).opens ((w i).base ζ) :=
    (E.cover.pullback f).mem_opens ((w i).base ζ)
  have hpush : ((w i).stalkMap ζ).hom
      ((Y.presheaf.germ ((E.cover.pullback f).opens ((w i).base ζ)) ((w i).base ζ)
        ((E.cover.pullback f).mem_opens ((w i).base ζ))).hom
        (pullbackEqn f E ((w i).base ζ)))
      = ((Z i).presheaf.germ ((w i) ⁻¹ᵁ (E.cover.pullback f).opens ((w i).base ζ)) ζ
          hmem).hom
        (((w i).app ((E.cover.pullback f).opens ((w i).base ζ))).hom
          (pullbackEqn f E ((w i).base ζ))) :=
    Scheme.Hom.germ_stalkMap_apply (w i) ((E.cover.pullback f).opens ((w i).base ζ))
      ζ hmem (pullbackEqn f E ((w i).base ζ))
  -- the transported germ is the composite pulled-equation germ, after restriction to
  -- the composite member
  have hle : (E.cover.pullback (w i ≫ f)).opens ζ ≤
      (w i) ⁻¹ᵁ (E.cover.pullback f).opens ((w i).base ζ) :=
    le_of_eq (by
      rw [Scheme.PointedCover.pullback_opens, Scheme.PointedCover.pullback_opens,
        Scheme.Hom.comp_preimage, Scheme.Hom.comp_apply])
  have happ : ((w i).app ((E.cover.pullback f).opens ((w i).base ζ))).hom
      (pullbackEqn f E ((w i).base ζ))
      = ((w i).appLE ((E.cover.pullback f).opens ((w i).base ζ))
          ((w i) ⁻¹ᵁ (E.cover.pullback f).opens ((w i).base ζ)) le_rfl).hom
        (pullbackEqn f E ((w i).base ζ)) := by
    rw [Scheme.Hom.appLE_eq_app]
  have hres : ((Z i).presheaf.map (homOfLE hle).op).hom
      (((w i).appLE ((E.cover.pullback f).opens ((w i).base ζ))
        ((w i) ⁻¹ᵁ (E.cover.pullback f).opens ((w i).base ζ)) le_rfl).hom
        (pullbackEqn f E ((w i).base ζ)))
      = ((w i).appLE ((E.cover.pullback f).opens ((w i).base ζ))
          ((E.cover.pullback (w i ≫ f)).opens ζ) hle).hom
        (pullbackEqn f E ((w i).base ζ)) := by
    rw [← CommRingCat.comp_apply, Scheme.Hom.appLE_map]
  -- the composite collapse: `appLE` after `appLE` is `appLE` of the composite
  have hcomp : ((w i).appLE ((E.cover.pullback f).opens ((w i).base ζ))
      ((E.cover.pullback (w i ≫ f)).opens ζ) hle).hom
      (pullbackEqn f E ((w i).base ζ))
      = pullbackEqn (w i ≫ f) E ζ := by
    have hsplit := Scheme.Hom.appLE_comp_appLE (w i) f
      (E.cover.opens (f.base ((w i).base ζ)))
      ((E.cover.pullback f).opens ((w i).base ζ))
      ((E.cover.pullback (w i ≫ f)).opens ζ) le_rfl hle
    have h0 : ((w i).appLE ((E.cover.pullback f).opens ((w i).base ζ))
        ((E.cover.pullback (w i ≫ f)).opens ζ) hle).hom
        (pullbackEqn f E ((w i).base ζ))
        = ((w i ≫ f).appLE (E.cover.opens (f.base ((w i).base ζ)))
            ((E.cover.pullback (w i ≫ f)).opens ζ)
            (hle.trans ((Opens.map (w i).base).map (homOfLE le_rfl)).le)).hom
          (E.eqn (f.base ((w i).base ζ))) := by
      rw [show pullbackEqn f E ((w i).base ζ)
          = (f.appLE (E.cover.opens (f.base ((w i).base ζ)))
              ((E.cover.pullback f).opens ((w i).base ζ)) le_rfl).hom
            (E.eqn (f.base ((w i).base ζ))) from rfl,
        ← CommRingCat.comp_apply, hsplit]
    rw [h0]
    exact appLE_eqn_congr (w i ≫ f) E (Scheme.Hom.comp_apply (w i) f ζ).symm _ le_rfl
  -- assemble: the target germ is the stalk-isomorphism preimage of the composite germ
  set e := (asIso ((w i).stalkMap ζ)).commRingCatIsoToRingEquiv with he
  have hval : (Y.presheaf.germ ((E.cover.pullback f).opens ((w i).base ζ))
      ((w i).base ζ) ((E.cover.pullback f).mem_opens ((w i).base ζ))).hom
      (pullbackEqn f E ((w i).base ζ))
      = e.symm (((Z i).presheaf.germ ((E.cover.pullback (w i ≫ f)).opens ζ) ζ
          ((E.cover.pullback (w i ≫ f)).mem_opens ζ)).hom
          (pullbackEqn (w i ≫ f) E ζ)) := by
    apply e.injective
    rw [e.apply_symm_apply]
    have hg := (Z i).presheaf.germ_res_apply (homOfLE hle) ζ
      ((E.cover.pullback (w i ≫ f)).mem_opens ζ)
      (((w i).appLE ((E.cover.pullback f).opens ((w i).base ζ))
        ((w i) ⁻¹ᵁ (E.cover.pullback f).opens ((w i).base ζ)) le_rfl).hom
        (pullbackEqn f E ((w i).base ζ)))
    calc e ((Y.presheaf.germ ((E.cover.pullback f).opens ((w i).base ζ))
          ((w i).base ζ) ((E.cover.pullback f).mem_opens ((w i).base ζ))).hom
          (pullbackEqn f E ((w i).base ζ)))
        = ((Z i).presheaf.germ
            ((w i) ⁻¹ᵁ (E.cover.pullback f).opens ((w i).base ζ)) ζ hmem).hom
            (((w i).appLE ((E.cover.pullback f).opens ((w i).base ζ))
              ((w i) ⁻¹ᵁ (E.cover.pullback f).opens ((w i).base ζ)) le_rfl).hom
              (pullbackEqn f E ((w i).base ζ))) := by
          rw [← happ]; exact hpush
      _ = ((Z i).presheaf.germ ((E.cover.pullback (w i ≫ f)).opens ζ) ζ
            ((E.cover.pullback (w i ≫ f)).mem_opens ζ)).hom
            (((Z i).presheaf.map (homOfLE hle).op).hom
              (((w i).appLE ((E.cover.pullback f).opens ((w i).base ζ))
                ((w i) ⁻¹ᵁ (E.cover.pullback f).opens ((w i).base ζ)) le_rfl).hom
                (pullbackEqn f E ((w i).base ζ)))) := hg.symm
      _ = ((Z i).presheaf.germ ((E.cover.pullback (w i ≫ f)).opens ζ) ζ
            ((E.cover.pullback (w i ≫ f)).mem_opens ζ)).hom
            (pullbackEqn (w i ≫ f) E ζ) := by rw [hres, hcomp]
  rw [hval]
  exact equiv_map_mem_nonZeroDivisors e.symm (hreg i ζ)