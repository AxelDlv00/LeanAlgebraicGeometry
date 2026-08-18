---
author: sync
content_type: theorem
created: '2026-08-03T14:01:21'
decl: AlgebraicGeometry.Scheme.Hom.fiberEulerIndex_eq_baseChangedCechIndex_spec
docstring: 'Over `Spec R`, the intrinsic fibre Euler index is the two-term family

  index at the corresponding point of `Spec Gamma(Spec R, top)`.


  Besides the geometric Cech comparison, this transports both the kernel and

  the quotient by the range across the residue-field algebra equivalence.'
file: AlgebraicJacobian/Picard/SchemeEulerIndex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Hom.fiberEulerIndex_eq_baseChangedCechIndex_spec
type: lean
updated: '2026-08-18T20:52:08'
---
theorem Hom.fiberEulerIndex_eq_baseChangedCechIndex_spec
    {R : CommRingCat.{u}} (p : X ⟶ Spec R)
    (V : X.AffineCoverMVSquare) (M : X.Modules) [M.IsQuasicoherent]
    (t : Spec R) [IsAffineHom (p.fiberι t)] :
    let B := Γ(Spec R, ⊤)
    let ε : B ≃+* R :=
      (Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv
    let H : PrimeSpectrum B ≃ₜ PrimeSpectrum R :=
      PrimeSpectrum.homeomorphOfRingEquiv ε
    let s := H.symm t
    letI := p.baseSectionsModule M V.U₁
    letI := p.baseSectionsModule M V.U₂
    letI := p.baseSectionsModule M (V.U₁ ⊓ V.U₂)
    p.fiberEulerIndex t M =
      (Module.finrank s.asIdeal.ResidueField
        (LinearMap.ker ((V.moduleSectionDiffBase p M).baseChange
          s.asIdeal.ResidueField)) : ℤ) -
      (Module.finrank s.asIdeal.ResidueField
        (TensorProduct B s.asIdeal.ResidueField Γ(M, V.U₁ ⊓ V.U₂) ⧸
          LinearMap.range ((V.moduleSectionDiffBase p M).baseChange
            s.asIdeal.ResidueField)) : ℤ) := by
  let B := Γ(Spec R, ⊤)
  let ε : B ≃+* R :=
    (Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv
  let H : PrimeSpectrum B ≃ₜ PrimeSpectrum R :=
    PrimeSpectrum.homeomorphOfRingEquiv ε
  let s := H.symm t
  let Kt := Γ(Spec ((Spec R).residueField t), ⊤)
  letI : Field Kt :=
    (MulEquiv.isField (Field.toIsField t.asIdeal.ResidueField)
      (specResidueFieldRingEquiv R t).symm.toMulEquiv).toField
  letI aBK : Algebra B Kt :=
    (((Spec R).fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom.toAlgebra
  letI m1 := p.baseSectionsModule M V.U₁
  letI m2 := p.baseSectionsModule M V.U₂
  letI m0 := p.baseSectionsModule M (V.U₁ ⊓ V.U₂)
  let hs : s.asIdeal = Ideal.comap ε.toRingHom t.asIdeal := rfl
  let kappaMap := Ideal.ResidueField.map s.asIdeal t.asIdeal ε.toRingHom hs
  have hkappaMap : Function.Bijective kappaMap :=
    (RingEquiv.surjectiveOnStalks ε).residueFieldMap_bijective
      s.asIdeal t.asIdeal hs
  let kappaEquiv := RingEquiv.ofBijective kappaMap hkappaMap
  let tau := kappaEquiv.trans (specResidueFieldRingEquiv R t)
  let tauAlg : s.asIdeal.ResidueField ≃ₐ[B] Kt :=
    AlgEquiv.ofRingEquiv fun b => by
      change tau ((algebraMap B s.asIdeal.ResidueField) b) = _
      change specResidueFieldRingEquiv R t
        (kappaMap ((algebraMap B s.asIdeal.ResidueField) b)) = _
      rw [Ideal.ResidueField.map_algebraMap]
      exact (appLE_fromSpecResidueField_apply R t b).symm
  let d := V.moduleSectionDiffBase p M
  have hindex := p.fiberEulerIndex_eq_baseChangedCechIndex V M t
  have h0 := finrank_ker_baseChange_of_algEquiv d tauAlg
  have h1 := finrank_quotient_range_baseChange_of_algEquiv d tauAlg
  exact hindex.trans (congrArg₂ (fun a b : ℕ => (a : ℤ) - (b : ℤ))
    h0.symm h1.symm)