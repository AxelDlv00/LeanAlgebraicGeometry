---
author: sync
content_type: theorem
created: '2026-07-17T10:19:49'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.termBaseChange_tmul
docstring: '**The chart-term base change on a pure tensor**: `b'' ⊗ s` goes to the
  `B''`-action of

  `b''` on the compared section `sectionsMap s` — the m-chart mirror of the 2-chart

  `relTwistTermBaseChange₀/₁` tmul rules (the DAT-3 (a)-step and RE-5 transport interface).'
file: AlgebraicJacobian/Cohomology/GluedSheafTermBaseChangeEquiv.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.termBaseChange_tmul
type: lean
updated: '2026-07-30T15:46:00'
---
theorem termBaseChange_tmul
    (hV : IsCompact (V : Set C.left)) (hV' : IsQuasiSeparated (V : Set C.left))
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
    (hspan : Ideal.span (Set.range h) = ⊤)
    (b' : B') (s : D.sheaf.obj.obj (op ((fst C (overSpec k B)).left ⁻¹ᵁ V))) :
    termBaseChange B' D V σ h hV hV' hVaff hVaff' hq hq' hP hspan (b' ⊗ₜ[B] s) =
      b' • D.sectionsMap B' (le_preimage_chart B' V) s := by
  letI := Scheme.QcohOn.moduleOfLE (F := D.sheaf)
    (le_refl ((fst C (overSpec k B)).left ⁻¹ᵁ V))
  letI := Scheme.QcohOn.moduleOfLE (F := (D.baseChange B').sheaf)
    (le_refl ((fst C (overSpec k B')).left ⁻¹ᵁ V))
  letI algBA : Algebra B Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V) :=
    ((relCurve C B).overAlgebraMap B ((fst C (overSpec k B)).left ⁻¹ᵁ V)).toAlgebra
  letI algB'A' : Algebra B' Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V) :=
    ((relCurve C B').overAlgebraMap B' ((fst C (overSpec k B')).left ⁻¹ᵁ V)).toAlgebra
  letI algAA' : Algebra Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
      Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V) :=
    (relSectionsMap C B B' V).toAlgebra
  letI algBA' : Algebra B Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V) :=
    ((algebraMap B' Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)).comp
      (algebraMap B B')).toAlgebra
  letI : Module Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
      ((D.baseChange B').sheaf.obj.obj (op ((fst C (overSpec k B')).left ⁻¹ᵁ V))) :=
    Module.compHom _ (relSectionsMap C B B' V)
  haveI : IsScalarTower Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
      Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
      ((D.baseChange B').sheaf.obj.obj (op ((fst C (overSpec k B')).left ⁻¹ᵁ V))) :=
    IsScalarTower.of_algebraMap_smul fun _ _ => rfl
  haveI : IsScalarTower B B'
      Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V) :=
    IsScalarTower.of_algebraMap_eq' rfl
  haveI : IsScalarTower B Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
      Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V) :=
    IsScalarTower.of_algebraMap_eq fun b =>
      (relSectionsMap_overAlgebraMap C B B' V b).symm
  haveI : IsScalarTower B Γ(relCurve C B, (fst C (overSpec k B)).left ⁻¹ᵁ V)
      (D.sheaf.obj.obj (op ((fst C (overSpec k B)).left ⁻¹ᵁ V))) :=
    isScalarTower_coeff B D.pieces D.unit hq (le_refl _)
  haveI : IsScalarTower B'
      Γ(relCurve C B', (fst C (overSpec k B')).left ⁻¹ᵁ V)
      ((D.baseChange B').sheaf.obj.obj
        (op ((fst C (overSpec k B')).left ⁻¹ᵁ V))) :=
    isScalarTower_coeff B' (D.baseChange B').pieces (D.baseChange B').unit hq'
      (le_refl _)
  simp only [termBaseChange, LinearEquiv.trans_apply, IsBaseChange.equiv_tmul,
    LinearMap.restrictScalars_apply, TensorProduct.mk_apply, map_smul,
    LinearEquiv.restrictScalars_apply, LinearEquiv.ofBijective_apply,
    LinearMap.liftBaseChange_tmul, one_smul]
  rfl