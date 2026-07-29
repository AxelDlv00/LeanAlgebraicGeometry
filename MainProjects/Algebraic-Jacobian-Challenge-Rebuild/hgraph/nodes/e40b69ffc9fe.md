---
author: sync
content_type: theorem
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.pieceTermBaseChangeAlg_one_tmul
docstring: '**Naturality of the piece-level term identification**: on `1 ⊗ s` the
  linchpin

  `pieceTermBaseChangeAlg` is the scheme-level piece-sections comparison

  `pieceSectionsMap` (`appLE` of `relCurveMap` between the pieces). Both sides are
  ring

  homomorphisms out of the away localization `Γ(D(h))`, so it suffices to compare
  them on

  the chart ring (`IsLocalization.ringHom_ext`), where both are

  `algebraMap ∘ relSectionsMap` (`tensorProductEquivTMulRight_tmul` + `AlgEquiv.commutes`

  on the left, `Scheme.Hom.appLE_resHom` on the right).'
file: AlgebraicJacobian/Picard/DivisorFamilyPullback.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pieceTermBaseChangeAlg_one_tmul
type: lean
updated: '2026-07-29T15:31:45'
---
theorem pieceTermBaseChangeAlg_one_tmul
    (s : Γ(relCurve C R, (relCurve C R).basicOpen h)) :
    pieceTermBaseChangeAlg R' V hV hV' hVaff hVaff' h ((1 : R') ⊗ₜ[R] s) =
      pieceSectionsMap R' V h s := by
  haveI := isScalarTower_R_chart_piece (R := R) V h
  haveI hLoc : IsLocalization.Away h Γ(relCurve C R, (relCurve C R).basicOpen h) :=
    hVaff.isLocalization_basicOpen h
  haveI hLoc' : IsLocalization.Away (relSectionsMap C R R' V h)
      Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h)) :=
    hVaff'.isLocalization_basicOpen (relSectionsMap C R R' V h)
  -- re-enter the instance context of the linchpin definition
  have heh : relTermBaseChangeAlg (C := C) (R := R) R' V hV hV' ((1 : R') ⊗ₜ[R] h)
      = relSectionsMap C R R' V h := by
    rw [relTermBaseChangeAlg_tmul, one_smul]
  letI algPK : Algebra (R' ⊗[R] Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V))
      Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h)) :=
    pieceTensorChartAlgebra R' V hV hV' h
  haveI hLocPK : IsLocalization.Away ((1 : R') ⊗ₜ[R] h)
      Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h)) := by
    refine IsLocalization.of_ringEquiv_left
      (relTermBaseChangeAlg (C := C) (R := R) R' V hV hV').toRingEquiv
      (M₂ := Submonoid.powers ((1 : R') ⊗ₜ[R] h))
      ?_ (fun x => rfl) (M₁ := Submonoid.powers (relSectionsMap C R R' V h))
    rw [Submonoid.map_powers]
    exact congrArg Submonoid.powers heh
  have key : ((pieceTermBaseChangeAlg R' V hV hV' hVaff hVaff' h).toAlgHom.toRingHom).comp
      (Algebra.TensorProduct.includeRight (R := R) (A := R')
        (B := Γ(relCurve C R, (relCurve C R).basicOpen h))).toRingHom
      = pieceSectionsMap R' V h := by
    refine IsLocalization.ringHom_ext (Submonoid.powers h) (RingHom.ext fun a => ?_)
    -- unfold the linchpin on the pure tensor `1 ⊗ (algebraMap a)`
    have h1 : pieceTermBaseChangeAlg R' V hV hV' hVaff hVaff' h
        ((1 : R') ⊗ₜ[R] (algebraMap Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V)
          Γ(relCurve C R, (relCurve C R).basicOpen h) a)) =
        (IsLocalization.algEquiv (Submonoid.powers ((1 : R') ⊗ₜ[R] h))
          (Localization.Away ((1 : R') ⊗ₜ[R] h))
          Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h)))
        (IsLocalization.Away.tensorProductEquivTMulRight R R' h
          Γ(relCurve C R, (relCurve C R).basicOpen h)
          ((1 : R') ⊗ₜ[R] (algebraMap Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V)
            Γ(relCurve C R, (relCurve C R).basicOpen h) a))) := rfl
    have h2 : (IsLocalization.Away.tensorProductEquivTMulRight R R' h
        Γ(relCurve C R, (relCurve C R).basicOpen h))
        ((1 : R') ⊗ₜ[R] (algebraMap Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V)
          Γ(relCurve C R, (relCurve C R).basicOpen h) a)) =
        algebraMap (R' ⊗[R] Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V))
          (Localization.Away ((1 : R') ⊗ₜ[R] h)) ((1 : R') ⊗ₜ[R] a) :=
      IsLocalization.Away.tensorProductEquivTMulRight_tmul (R := R) (S := R')
        Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V) h
        Γ(relCurve C R, (relCurve C R).basicOpen h) 1 a
    have h3 : (IsLocalization.algEquiv (Submonoid.powers ((1 : R') ⊗ₜ[R] h))
        (Localization.Away ((1 : R') ⊗ₜ[R] h))
        Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h)))
        (algebraMap (R' ⊗[R] Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V))
          (Localization.Away ((1 : R') ⊗ₜ[R] h)) ((1 : R') ⊗ₜ[R] a)) =
        algebraMap (R' ⊗[R] Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V))
          Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h))
          ((1 : R') ⊗ₜ[R] a) :=
      AlgEquiv.commutes _ _
    have h4 : algebraMap (R' ⊗[R] Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V))
        Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h))
        ((1 : R') ⊗ₜ[R] a) =
        algebraMap Γ(relCurve C R', (fst C (overSpec k R')).left ⁻¹ᵁ V)
          Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V h))
          (relTermBaseChangeAlg (C := C) (R := R) R' V hV hV' ((1 : R') ⊗ₜ[R] a)) := rfl
    have h5 : relTermBaseChangeAlg (C := C) (R := R) R' V hV hV' ((1 : R') ⊗ₜ[R] a)
        = relSectionsMap C R R' V a := by
      rw [relTermBaseChangeAlg_tmul, one_smul]
    change pieceTermBaseChangeAlg R' V hV hV' hVaff hVaff' h
        ((1 : R') ⊗ₜ[R] (algebraMap Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V)
          Γ(relCurve C R, (relCurve C R).basicOpen h) a)) =
      pieceSectionsMap R' V h
        (algebraMap Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V)
          Γ(relCurve C R, (relCurve C R).basicOpen h) a)
    rw [h1, h2, h3, h4, h5, pieceSectionsMap_algebraMap]
  exact RingHom.congr_fun key s

/-! ## Base change of piece quotients (the colength transport) -/