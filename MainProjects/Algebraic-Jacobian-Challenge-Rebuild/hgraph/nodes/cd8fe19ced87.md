---
author: sync
content_type: theorem
created: '2026-08-03T20:05:08'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.exists_away_away_divFamZarAff_of_admissible_fibre
docstring: 'An admissible H1-vanishing fibre spreads across two away localizations
  to a

  widened divisor family whose class is the pullback of the original datum class.

  The returned prime of the final base lies over the chosen input prime.'
file: AlgebraicJacobian/Picard/Pic0AdmissibleAbelEtaleSurjectiveSpread.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.exists_away_away_divFamZarAff_of_admissible_fibre
type: lean
updated: '2026-08-18T20:51:04'
---
theorem exists_away_away_divFamZarAff_of_admissible_fibre
    (D : BasicOpenCocycleDatum C B pi) [IsNoetherianRing B]
    (hpi : pi ≫ P1.structureMap k = C.hom) (n g : ℕ)
    (hchi : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (hgn : g ≤ n)
    (p : PrimeSpectrum B) (hp : D.HasWitnessH1Vanishing p.asIdeal.ResidueField)
    (hdegp : classDeg p.asIdeal.ResidueField
      (Scheme.CechPic.map (relCurveMap C B p.asIdeal.ResidueField)
        D.cechPicClass) = (n : ℤ)) :
    ∃ h : B, h ∉ p.asIdeal ∧
      ∃ q₁ : PrimeSpectrum (Localization.Away h),
        PrimeSpectrum.comap (algebraMap B (Localization.Away h)) q₁ = p ∧
        ∃ f : Localization.Away h, f ∉ q₁.asIdeal ∧
          ∃ q₂ : PrimeSpectrum (Localization.Away f),
            PrimeSpectrum.comap (algebraMap B (Localization.Away f)) q₂ = p ∧
            ∃ F : DivFamZarAff C (Localization.Away f) n,
              F.picClass = Scheme.CechPic.map
                (relCurveMap C B (Localization.Away f)) D.cechPicClass := by
  obtain ⟨h, hh, hvan⟩ := D.exists_basicOpen_h1_vanishing hpi p hp
  obtain ⟨q₁, hq₁⟩ : p ∈ Set.range
      (PrimeSpectrum.comap (algebraMap B (Localization.Away h))) := by
    rw [PrimeSpectrum.localization_away_comap_range (Localization.Away h) h]
    exact hh
  let D₁ : BasicOpenCocycleDatum C (Localization.Away h) pi :=
    D.baseChange (Localization.Away h)
  have hfib₁ : ∀ q : PrimeSpectrum (Localization.Away h),
      Subsingleton ((datumPair D₁).H1 ⊗[Localization.Away h]
        q.asIdeal.ResidueField) := by
    intro q
    exact D.hfib_baseChange_away h hvan q
  obtain ⟨-, hfin₁, hproj₁⟩ := datumRigidEngine D₁ hpi hfib₁
  letI : Module.Finite (Localization.Away h) (Sheaf.HModule D₁.sheaf 0) := hfin₁
  letI : Module.Projective (Localization.Away h) (Sheaf.HModule D₁.sheaf 0) := hproj₁
  have hH1₁ : Subsingleton (datumPair D₁).H1 :=
    datum_subsingleton_pairH1 D₁ hpi hfib₁
  have hdeg₁ : classDeg q₁.asIdeal.ResidueField
      (D₁.baseChange q₁.asIdeal.ResidueField).cechPicClass = (n : ℤ) := by
    rw [D₁.cechPicClass_baseChange q₁.asIdeal.ResidueField]
    rw [show D₁.cechPicClass = Scheme.CechPic.map
        (relCurveMap C B (Localization.Away h)) D.cechPicClass from
          D.cechPicClass_baseChange (Localization.Away h),
      ← MonoidHom.comp_apply, ← Scheme.CechPic.map_comp, relCurveMap_comp]
    exact D.classDeg_map_residueField_of_comap p q₁ hq₁ n hdegp
  have hsub₁ : Subsingleton
      (Sheaf.HModule (D₁.baseChange q₁.asIdeal.ResidueField).sheaf 1) :=
    D₁.datum_subsingleton_h1_baseChange q₁.asIdeal.ResidueField hH1₁
  have hnonzero₁ : Nontrivial
      (Sheaf.HModule (D₁.baseChange q₁.asIdeal.ResidueField).sheaf 0) :=
    D₁.nontrivial_hModule_zero_of_degree_of_h1 q₁.asIdeal.ResidueField
      n g hchi hdeg₁ hgn hsub₁
  have hnontrivialFibre : Nontrivial
      (q₁.asIdeal.ResidueField ⊗[Localization.Away h]
        Sheaf.HModule D₁.sheaf 0) :=
    (D₁.datumH0BaseChange q₁.asIdeal.ResidueField hH1₁).toEquiv.nontrivial_congr.mpr
      hnonzero₁
  obtain ⟨f, hf, hfree⟩ := Grassmannian.exists_away_free
    (Q := Sheaf.HModule D₁.sheaf 0) q₁
  obtain ⟨q₂, hq₂'⟩ : q₁ ∈ Set.range
      (PrimeSpectrum.comap
        (algebraMap (Localization.Away h) (Localization.Away f))) := by
    rw [PrimeSpectrum.localization_away_comap_range (Localization.Away f) f]
    exact hf
  have hq₂ : PrimeSpectrum.comap (algebraMap B (Localization.Away f)) q₂ = p := by
    rw [IsScalarTower.algebraMap_eq B (Localization.Away h) (Localization.Away f),
      PrimeSpectrum.comap_comp]
    change PrimeSpectrum.comap (algebraMap B (Localization.Away h))
      (PrimeSpectrum.comap
        (algebraMap (Localization.Away h) (Localization.Away f)) q₂) = p
    rw [hq₂', hq₁]
  let D₂ : BasicOpenCocycleDatum C (Localization.Away f) pi :=
    D₁.baseChange (Localization.Away f)
  have hH1sheaf₂ : Subsingleton (Sheaf.HModule D₂.sheaf 1) :=
    D₁.datum_subsingleton_h1_baseChange (Localization.Away f) hH1₁
  have hH1₂ : Subsingleton (datumPair D₂).H1 :=
    (subsingleton_datumPair_h1_iff D₂).mpr hH1sheaf₂
  let Q₂ := Localization.Away f ⊗[Localization.Away h]
    Sheaf.HModule D₁.sheaf 0
  letI : Module.Free (Localization.Away f) Q₂ := hfree
  letI : Nontrivial Q₂ :=
    nontrivial_away_tensor_of_nontrivial_fibre q₁ f hf hnontrivialFibre
  let b := Module.Free.chooseBasis (Localization.Away f) Q₂
  let i₀ := b.index_nonempty.some
  let t : Q₂ := b i₀
  let e₂ : Q₂ ≃ₗ[Localization.Away f] Sheaf.HModule D₂.sheaf 0 :=
    D₁.datumH0BaseChange (Localization.Away f) hH1₁
  let y₂ : Sheaf.HModule D₂.sheaf 0 := e₂ t
  have hy₂ : ∀ (L : Type u) [Field L] [Algebra k L]
      [Algebra (Localization.Away f) L]
      [IsScalarTower k (Localization.Away f) L],
      (1 : L) ⊗ₜ[Localization.Away f] y₂ ≠ 0 := by
    intro L _ _ _ _
    have ht : ((1 : L) ⊗ₜ[Localization.Away f] t : L ⊗[Localization.Away f] Q₂)
        ≠ 0 := by
      rw [← Module.Basis.baseChange_apply L b i₀]
      exact (b.baseChange L).ne_zero i₀
    let eL := LinearEquiv.baseChange (Localization.Away f) L Q₂
      (Sheaf.HModule D₂.sheaf 0) e₂
    intro hy
    apply ht
    apply eL.injective
    rw [LinearEquiv.baseChange_tmul, map_zero, hy]
  let s₂ : ↥(gluedSubmodule (Localization.Away f) D₂.pieces D₂.unit ⊤) :=
    Sheaf.HModule.linearEquiv₀
      (Opens.grothendieckTopology ((relCurve C (Localization.Away f) : Scheme.{u}) : TopCat))
      isTerminalTop D₂.sheaf y₂
  have hs₂ : ∀ (L : Type u) [Field L] [Algebra k L]
      [Algebra (Localization.Away f) L]
      [IsScalarTower k (Localization.Away f) L],
      D₂.sectionsMapTop L s₂ ≠ 0 := by
    intro L _ _ _ _
    have hbc : D₂.datumH0BaseChange L hH1₂
        ((1 : L) ⊗ₜ[Localization.Away f] y₂) ≠ 0 :=
      fun hzero => (hy₂ L) ((D₂.datumH0BaseChange L hH1₂).injective (by
        rw [hzero, map_zero]))
    have htop : Sheaf.HModule.linearEquiv₀
        (Opens.grothendieckTopology ((relCurve C L : Scheme.{u}) : TopCat))
        isTerminalTop (D₂.baseChange L).sheaf
        (D₂.datumH0BaseChange L hH1₂
          ((1 : L) ⊗ₜ[Localization.Away f] y₂)) ≠ 0 :=
      fun hzero => hbc ((Sheaf.HModule.linearEquiv₀
        (Opens.grothendieckTopology ((relCurve C L : Scheme.{u}) : TopCat))
        isTerminalTop (D₂.baseChange L).sheaf).injective (by
          rw [hzero, map_zero]))
    rw [D₂.linearEquiv₀_datumH0BaseChange_one_tmul L hH1₂ y₂] at htop
    exact htop
  have hcomponent : ∀ (j : D₂.index) (q : PrimeSpectrum (Localization.Away f)),
      Function.Injective
        ((Scheme.mulSectionEnd (Localization.Away f) (D₂.component s₂ j)).rTensor
          q.asIdeal.ResidueField) := by
    intro j q
    exact D₂.injective_rTensor_component_of_sectionsMapTop_ne_zero
      s₂ q (hs₂ q.asIdeal.ResidueField) j
  let d : (relCurve C (Localization.Away f)).LocalEquations :=
    D₂.sectionLocalEquationsOfFibrewiseRegular s₂ hcomponent
  have hreg : ∀ (L : Type u) [Field L] [Algebra k L]
      [Algebra (Localization.Away f) L]
      [IsScalarTower k (Localization.Away f) L], ∀ z : relCurve C L,
      ((relCurve C L).presheaf.germ
        ((d.cover.pullback (relCurveMap C (Localization.Away f) L)).opens z) z
        ((d.cover.pullback
          (relCurveMap C (Localization.Away f) L)).mem_opens z)).hom
        (Scheme.LocalEquations.pullbackEqn
          (relCurveMap C (Localization.Away f) L) d z) ∈
          nonZeroDivisors ((relCurve C L).presheaf.stalk z) := by
    intro L _ _ _ _ z
    exact D₂.germ_self_pullbackEqn_sectionLocalEquationsOfFibrewiseRegular
      s₂ hcomponent L z
  have hclassD₂ : D₂.cechPicClass = Scheme.CechPic.map
      (relCurveMap C B (Localization.Away f)) D.cechPicClass := by
    rw [show D₂.cechPicClass = Scheme.CechPic.map
        (relCurveMap C (Localization.Away h) (Localization.Away f))
        D₁.cechPicClass from D₁.cechPicClass_baseChange (Localization.Away f),
      show D₁.cechPicClass = Scheme.CechPic.map
        (relCurveMap C B (Localization.Away h)) D.cechPicClass from
          D.cechPicClass_baseChange (Localization.Away h),
      ← MonoidHom.comp_apply, ← Scheme.CechPic.map_comp,
      relCurveMap_comp]
  have hdegq₂ : classDeg q₂.asIdeal.ResidueField
      (D₂.baseChange q₂.asIdeal.ResidueField).cechPicClass = (n : ℤ) := by
    rw [D₂.cechPicClass_baseChange q₂.asIdeal.ResidueField, hclassD₂,
      ← MonoidHom.comp_apply, ← Scheme.CechPic.map_comp, relCurveMap_comp]
    exact D.classDeg_map_residueField_of_comap p q₂ hq₂ n hdegp
  letI : Module.Free (Localization.Away f) (Sheaf.HModule D₂.sheaf 0) :=
    Module.Free.of_equiv e₂
  have hdeg₂ : ∀ (L : Type u) [Field L] [Algebra k L]
      [Algebra (Localization.Away f) L]
      [IsScalarTower k (Localization.Away f) L],
      classDeg L
        (Scheme.CechPic.map (relCurveMap C (Localization.Away f) L) d.picClass) =
          (n : ℤ) := by
    intro L _ _ _ _
    rw [show d.picClass = D₂.cechPicClass from
        D₂.sectionLocalEquationsOfFibrewiseRegular_picClass s₂ hcomponent,
      ← D₂.cechPicClass_baseChange L]
    exact D₂.classDeg_baseChange_eq_of_freeH0_of_one
      g n hchi hH1₂ q₂.asIdeal.ResidueField hdegq₂ L
  let F : DivFamZarAff C (Localization.Away f) n :=
    divFamZarAffOfFibrewiseRegularLocalEquations C n d pi hreg hdeg₂
  refine ⟨h, hh, q₁, hq₁, f, hf, q₂, hq₂, F, ?_⟩
  rw [show F.picClass = d.picClass from
      picClass_divFamZarAffOfFibrewiseRegularLocalEquations C n d pi hreg hdeg₂,
    show d.picClass = D₂.cechPicClass from
      D₂.sectionLocalEquationsOfFibrewiseRegular_picClass s₂ hcomponent,
    hclassD₂]