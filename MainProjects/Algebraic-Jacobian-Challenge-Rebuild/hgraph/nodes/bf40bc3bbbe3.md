---
author: sync
content_type: theorem
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.termBaseChange_bijective
docstring: '**Bijectivity of the chart-term comparison** (stage 1d-ii): the `liftBaseChange`
  of

  the componentwise `sectionsMap` is bijective — locally on the trivializing family
  both

  sides are localizations of the source at the powers of `h i`.'
file: AlgebraicJacobian/Cohomology/GluedSheafTermBaseChangeEquiv.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.termBaseChange_bijective
type: lean
updated: '2026-07-29T15:31:35'
---
theorem termBaseChange_bijective
    (hVaff : IsAffineOpen ((fst C (overSpec k B)).left ⁻¹ᵁ V))
    (hVaff' : IsAffineOpen ((fst C (overSpec k B')).left ⁻¹ᵁ V))
    (hq : ∀ {W : (relCurve C B).Opens} (hW : W ≤ (fst C (overSpec k B)).left ⁻¹ᵁ V)
      (r : Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V))
      (s : ↥(gluedSubmodule B D.pieces D.unit W)),
      Scheme.QcohOn.qsmul (F := D.sheaf) hW r s = gluedQsmul B D.pieces D.unit hW r s)
    (hq' : ∀ {W : (relCurve C B').Opens}
      (hW : W ≤ (fst C (overSpec k B')).left ⁻¹ᵁ V)
      (r : Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V))
      (s : ↥(gluedSubmodule B' (D.baseChange B').pieces (D.baseChange B').unit W)),
      Scheme.QcohOn.qsmul (F := (D.baseChange B').sheaf) hW r s =
        gluedQsmul B' (D.baseChange B').pieces (D.baseChange B').unit hW r s)
    (hP : ∀ i : ι, (relCurve C B).basicOpen (h i) ≤ D.pieces (σ i))
    (hspan : Ideal.span (Set.range h) = ⊤) :
    letI := Scheme.QcohOn.moduleOfLE (F := D.sheaf)
      (le_refl ((fst C (overSpec k B)).left ⁻¹ᵁ V))
    letI := Scheme.QcohOn.moduleOfLE (F := (D.baseChange B').sheaf)
      (le_refl ((fst C (overSpec k B')).left ⁻¹ᵁ V))
    letI : Algebra Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
        Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V) :=
      (relSectionsMap C B B' V).toAlgebra
    letI : Module Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
        ((D.baseChange B').sheaf.obj.obj (op ((fst C (overSpec k B')).left ⁻¹ᵁ V))) :=
      Module.compHom _ (relSectionsMap C B B' V)
    letI : IsScalarTower Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
        Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
        ((D.baseChange B').sheaf.obj.obj (op ((fst C (overSpec k B')).left ⁻¹ᵁ V))) :=
      IsScalarTower.of_algebraMap_smul fun _ _ => rfl
    Function.Bijective
      (LinearMap.liftBaseChange Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
        (sectionsMapₗ B' D V hq hq')) := by
  letI := Scheme.QcohOn.moduleOfLE (F := D.sheaf)
    (le_refl ((fst C (overSpec k B)).left ⁻¹ᵁ V))
  letI := Scheme.QcohOn.moduleOfLE (F := (D.baseChange B').sheaf)
    (le_refl ((fst C (overSpec k B')).left ⁻¹ᵁ V))
  letI : Algebra Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
      Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V) :=
    (relSectionsMap C B B' V).toAlgebra
  letI : Module Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
      ((D.baseChange B').sheaf.obj.obj (op ((fst C (overSpec k B')).left ⁻¹ᵁ V))) :=
    Module.compHom _ (relSectionsMap C B B' V)
  letI : IsScalarTower Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
      Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
      ((D.baseChange B').sheaf.obj.obj (op ((fst C (overSpec k B')).left ⁻¹ᵁ V))) :=
    IsScalarTower.of_algebraMap_smul fun _ _ => rfl
  classical
  have hmem : ∀ gg : Set.range h, ∃ i : ι, h i = gg.1 := fun gg => gg.2
  -- the per-generator module skeleton
  letI iA'F' : ∀ gg : Set.range h,
      Module Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
        ((D.baseChange B').sheaf.obj.obj
          (op ((relCurve C B').basicOpen (termFamily B' V h (hmem gg).choose)))) :=
    fun gg => Scheme.QcohOn.moduleOfLE (F := (D.baseChange B').sheaf)
      ((relCurve C B').basicOpen_le (termFamily B' V h (hmem gg).choose))
  letI iAF : ∀ gg : Set.range h,
      Module Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
        (D.sheaf.obj.obj (op ((relCurve C B).basicOpen (h (hmem gg).choose)))) :=
    fun gg => Scheme.QcohOn.moduleOfLE (F := D.sheaf)
      ((relCurve C B).basicOpen_le (h (hmem gg).choose))
  letI iAΓ' : ∀ gg : Set.range h,
      Algebra Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
        Γ(relCurve C B', (relCurve C B').basicOpen
          (termFamily B' V h (hmem gg).choose)) :=
    fun gg => ((algebraMap Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
      Γ(relCurve C B', (relCurve C B').basicOpen
        (termFamily B' V h (hmem gg).choose))).comp (relSectionsMap C B B' V)).toAlgebra
  haveI iTAA'Γ' : ∀ gg : Set.range h,
      IsScalarTower Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
        Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
        Γ(relCurve C B', (relCurve C B').basicOpen
          (termFamily B' V h (hmem gg).choose)) :=
    fun gg => IsScalarTower.of_algebraMap_eq' rfl
  letI iAF' : ∀ gg : Set.range h,
      Module Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
        ((D.baseChange B').sheaf.obj.obj
          (op ((relCurve C B').basicOpen (termFamily B' V h (hmem gg).choose)))) :=
    fun gg => Module.compHom _ (relSectionsMap C B B' V)
  haveI iTAA'F' : ∀ gg : Set.range h,
      IsScalarTower Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
        Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
        ((D.baseChange B').sheaf.obj.obj
          (op ((relCurve C B').basicOpen (termFamily B' V h (hmem gg).choose)))) :=
    fun gg => IsScalarTower.of_algebraMap_smul fun _ _ => rfl
  -- the source-side localizations: tensors of localizations, per generator
  haveI hfinst : ∀ gg : Set.range h, IsLocalizedModule.Away
      (gg.1 : Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V))
      (TensorProduct.map
        ((Algebra.linearMap Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
          Γ(relCurve C B', (relCurve C B').basicOpen
            (termFamily B' V h (hmem gg).choose))).restrictScalars
              Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V))
        (Scheme.QcohOn.secResₗ (F := D.sheaf)
          ((relCurve C B).basicOpen_le (h (hmem gg).choose))
          (le_refl ((fst C (overSpec k B)).left ⁻¹ᵁ V)))) := by
    intro gg
    letI := Scheme.QcohOn.moduleOfLE (F := D.sheaf)
      ((relCurve C B).basicOpen_le (h (hmem gg).choose))
    letI aΓΓ' : Algebra Γ(relCurve C B, (relCurve C B).basicOpen (h (hmem gg).choose))
        Γ(relCurve C B', (relCurve C B').basicOpen
          (termFamily B' V h (hmem gg).choose)) :=
      (((relCurveMap C B B').appLE
        ((relCurve C B).basicOpen (h (hmem gg).choose))
        ((relCurve C B').basicOpen (termFamily B' V h (hmem gg).choose))
        (termFamily_basicOpen B' V h (hmem gg).choose).le).hom).toAlgebra
    haveI tAΓΓ' : IsScalarTower Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
        Γ(relCurve C B, (relCurve C B).basicOpen (h (hmem gg).choose))
        Γ(relCurve C B', (relCurve C B').basicOpen
          (termFamily B' V h (hmem gg).choose)) := by
      refine IsScalarTower.of_algebraMap_eq fun a => ?_
      exact (relCurveMap C B B').appLE_resHom
        ((relCurve C B).basicOpen_le (h (hmem gg).choose)) (le_preimage_chart B' V)
        (termFamily_basicOpen B' V h (hmem gg).choose).le
        ((relCurve C B').basicOpen_le (termFamily B' V h (hmem gg).choose)) a
    haveI hLocB : IsLocalization.Away (h (hmem gg).choose)
        Γ(relCurve C B, (relCurve C B).basicOpen (h (hmem gg).choose)) :=
      hVaff.isLocalization_basicOpen (h (hmem gg).choose)
    haveI hLocB' : IsLocalization.Away (termFamily B' V h (hmem gg).choose)
        Γ(relCurve C B', (relCurve C B').basicOpen
          (termFamily B' V h (hmem gg).choose)) :=
      hVaff'.isLocalization_basicOpen (termFamily B' V h (hmem gg).choose)
    haveI hρ' : IsLocalizedModule
        (Submonoid.powers (termFamily B' V h (hmem gg).choose))
        (Algebra.linearMap Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
          Γ(relCurve C B', (relCurve C B').basicOpen
            (termFamily B' V h (hmem gg).choose))) :=
      (isLocalizedModule_iff_isLocalization' _ _).mpr hLocB'
    haveI hρ'' : IsLocalizedModule (Submonoid.powers
        (algebraMap Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
          Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V) (h (hmem gg).choose)))
        (Algebra.linearMap Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
          Γ(relCurve C B', (relCurve C B').basicOpen
            (termFamily B' V h (hmem gg).choose))) := hρ'
    haveI hρ : IsLocalizedModule (Submonoid.powers (h (hmem gg).choose))
        ((Algebra.linearMap Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
          Γ(relCurve C B', (relCurve C B').basicOpen
            (termFamily B' V h (hmem gg).choose))).restrictScalars
              Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)) :=
      isLocalizedModule_restrictScalars_powers (h (hmem gg).choose) _
    haveI hsec : IsLocalizedModule (Submonoid.powers (h (hmem gg).choose))
        (Scheme.QcohOn.secResₗ (F := D.sheaf)
          ((relCurve C B).basicOpen_le (h (hmem gg).choose))
          (le_refl ((fst C (overSpec k B)).left ⁻¹ᵁ V))) :=
      isLocalizedModule_secResₗ_glued B D.pieces D.unit hVaff D.isGluingCocycle hq hP
        (hmem gg).choose
    have hpow : Submonoid.powers (gg.1 :
        Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)) =
        Submonoid.powers (h (hmem gg).choose) :=
      congrArg Submonoid.powers (hmem gg).choose_spec.symm
    change IsLocalizedModule (Submonoid.powers (gg.1 :
      Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V))) _
    rw [hpow]
    infer_instance
  -- the target-side localizations: restricted piece restrictions, per generator
  haveI hginst : ∀ gg : Set.range h, IsLocalizedModule.Away
      (gg.1 : Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V))
      ((Scheme.QcohOn.secResₗ (F := (D.baseChange B').sheaf)
        ((relCurve C B').basicOpen_le (termFamily B' V h (hmem gg).choose))
        (le_refl ((fst C (overSpec k B')).left ⁻¹ᵁ V))).restrictScalars
          Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)) := by
    intro gg
    haveI hsec' : IsLocalizedModule
        (Submonoid.powers (termFamily B' V h (hmem gg).choose))
        (Scheme.QcohOn.secResₗ (F := (D.baseChange B').sheaf)
          ((relCurve C B').basicOpen_le (termFamily B' V h (hmem gg).choose))
          (le_refl ((fst C (overSpec k B')).left ⁻¹ᵁ V))) :=
      isLocalizedModule_secResₗ_glued B' (D.baseChange B').pieces
        (D.baseChange B').unit hVaff' (D.baseChange B').isGluingCocycle hq'
        (termFamily_le B' D V σ h hP) (hmem gg).choose
    haveI hsec'' : IsLocalizedModule (Submonoid.powers
        (algebraMap Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
          Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V) (h (hmem gg).choose)))
        (Scheme.QcohOn.secResₗ (F := (D.baseChange B').sheaf)
          ((relCurve C B').basicOpen_le (termFamily B' V h (hmem gg).choose))
          (le_refl ((fst C (overSpec k B')).left ⁻¹ᵁ V))) := hsec'
    have hpow : Submonoid.powers (gg.1 :
        Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)) =
        Submonoid.powers (h (hmem gg).choose) :=
      congrArg Submonoid.powers (hmem gg).choose_spec.symm
    change IsLocalizedModule (Submonoid.powers (gg.1 :
      Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V))) _
    rw [hpow]
    exact isLocalizedModule_restrictScalars_powers (h (hmem gg).choose) _
  -- the localized comparisons are bijective
  refine bijective_of_isLocalized_span (Set.range h) hspan
    (Mₚ := fun gg =>
      Γ(relCurve C B', (relCurve C B').basicOpen (termFamily B' V h (hmem gg).choose))
        ⊗[Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)]
        (D.sheaf.obj.obj (op ((relCurve C B).basicOpen (h (hmem gg).choose)))))
    (f := fun gg => TensorProduct.map
      ((Algebra.linearMap Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
        Γ(relCurve C B', (relCurve C B').basicOpen
          (termFamily B' V h (hmem gg).choose))).restrictScalars
            Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V))
      (Scheme.QcohOn.secResₗ (F := D.sheaf)
        ((relCurve C B).basicOpen_le (h (hmem gg).choose))
        (le_refl ((fst C (overSpec k B)).left ⁻¹ᵁ V))))
    (Nₚ := fun gg =>
      ((D.baseChange B').sheaf.obj.obj
        (op ((relCurve C B').basicOpen (termFamily B' V h (hmem gg).choose)))))
    (g := fun gg =>
      (Scheme.QcohOn.secResₗ (F := (D.baseChange B').sheaf)
        ((relCurve C B').basicOpen_le (termFamily B' V h (hmem gg).choose))
        (le_refl ((fst C (overSpec k B')).left ⁻¹ᵁ V))).restrictScalars
          Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V))
    (F := (LinearMap.liftBaseChange
      Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
      (sectionsMapₗ B' D V hq hq')).restrictScalars
        Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V))
    ?_
  intro gg
  -- bijectivity of the localized comparison, from the two localization structures
  have hpow : Submonoid.powers (gg.1 :
      Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)) =
      Submonoid.powers (h (hmem gg).choose) :=
    congrArg Submonoid.powers (hmem gg).choose_spec.symm
  haveI hcomp : IsLocalizedModule (Submonoid.powers (gg.1 :
      Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)))
      (((Scheme.QcohOn.secResₗ (F := (D.baseChange B').sheaf)
        ((relCurve C B').basicOpen_le (termFamily B' V h (hmem gg).choose))
        (le_refl ((fst C (overSpec k B')).left ⁻¹ᵁ V))).restrictScalars
          Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)) ∘ₗ
        ((LinearMap.liftBaseChange
          Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
          (sectionsMapₗ B' D V hq hq')).restrictScalars
            Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V))) := by
    rw [hpow]
    exact termPieceLocalized B' D V σ h hVaff hVaff' hq hq' hP (hmem gg).choose
  refine IsLocalizedModule.bijective_of_comp_eq
    (Submonoid.powers (gg.1 :
      Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)))
    (TensorProduct.map
      ((Algebra.linearMap Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
        Γ(relCurve C B', (relCurve C B').basicOpen
          (termFamily B' V h (hmem gg).choose))).restrictScalars
            Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V))
      (Scheme.QcohOn.secResₗ (F := D.sheaf)
        ((relCurve C B).basicOpen_le (h (hmem gg).choose))
        (le_refl ((fst C (overSpec k B)).left ⁻¹ᵁ V))))
    (((Scheme.QcohOn.secResₗ (F := (D.baseChange B').sheaf)
        ((relCurve C B').basicOpen_le (termFamily B' V h (hmem gg).choose))
        (le_refl ((fst C (overSpec k B')).left ⁻¹ᵁ V))).restrictScalars
          Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)) ∘ₗ
      ((LinearMap.liftBaseChange Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
        (sectionsMapₗ B' D V hq hq')).restrictScalars
          Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)))
    _ ?_
  exact LinearMap.ext fun x => IsLocalizedModule.map_apply _ _ _ _ x

set_option maxHeartbeats 1600000 in
set_option synthInstance.maxHeartbeats 800000 in