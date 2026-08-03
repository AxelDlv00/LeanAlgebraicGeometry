---
author: sync
content_type: theorem
created: '2026-08-03T08:02:47'
decl: AlgebraicGeometry.AffAdaptation.IsCertified.divisorWindow_pulledEquations_eq_at
docstring: 'The pulled intrinsic divisor window commutes with base change when the
  curve parameter is

  independent of the certified divisor degree.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaWindowBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.IsCertified.divisorWindow_pulledEquations_eq_at
type: lean
updated: '2026-08-03T08:02:47'
---
theorem IsCertified.divisorWindow_pulledEquations_eq_at
    {A : AffAdaptation D d} {g gamma a : ℕ} (hc : A.IsCertified g)
    (hπ : π ≫ P1.structureMap k = C.hom)
    (hgamma : gamma ≤ g)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ))
    (ha1 : Subsingleton (relTwistPair C k π
      (relThetaCocycle C k π a)).H1)
    (hMa : windowM_choice π hπ g ≤ a) :
    divisorWindow (A.pulledEquations R' hc.projective_colength) ha1 =
      windowBaseChange R' (divisorWindow d ha1) := by
  haveI hfinR : Module.Finite R ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸
        divisorWindow d ha1) :=
    hc.finite_intrinsicWindowQuotient_at hπ hgamma hχ ha1 hMa
  haveI hprojR : Module.Projective R ((R ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸
        divisorWindow d ha1) :=
    hc.projective_intrinsicWindowQuotient_at
      (π := π) A a hπ hgamma hχ ha1 hMa
  have hrankR : ∀ p : PrimeSpectrum R,
      Module.rankAtStalk ((R ⊗[k]
        ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸
          divisorWindow d ha1) p = g :=
    fun p => hc.rankAtStalk_intrinsicWindowQuotient_at
      (π := π) A a hπ hgamma hχ ha1 hMa p
  let A' := A.pullback R' hc.projective_colength
  have hinf : ∀ i j : D.index, IsAffineOpen (D.pieces i ⊓ D.pieces j) :=
    fun i j => Over.isAffineOpen_inf (A := R) C
      (D.isAffineOpen i) (D.isAffineOpen j)
  have hc' : A'.IsCertified g := A.isCertified_pullback R' hinf hc
  haveI hprojR' : Module.Projective R' ((R' ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸
        divisorWindow (A.pulledEquations R' hc.projective_colength) ha1) :=
    hc'.projective_intrinsicWindowQuotient_at
      (π := π) A' a hπ hgamma hχ ha1 hMa
  have hrankR' : ∀ p : PrimeSpectrum R',
      Module.rankAtStalk ((R' ⊗[k]
        ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸
          divisorWindow (A.pulledEquations R' hc.projective_colength) ha1) p = g :=
    fun p => hc'.rankAtStalk_intrinsicWindowQuotient_at
      (π := π) A' a hπ hgamma hχ ha1 hMa p
  let x := windowBaseChangeGr R' (divisorWindow d ha1) g hrankR
  letI : Module.Projective R' ((R' ⊗[k]
      ↥(Scheme.divisorSections k (a • fiberWeilDivisor π) ⊤)) ⧸
        windowBaseChange R' (divisorWindow d ha1)) :=
    x.projective_quotient
  have hle : windowBaseChange R' (divisorWindow d ha1) ≤
      divisorWindow (A.pulledEquations R' hc.projective_colength) ha1 :=
    windowBaseChange_divisorWindow_le C R' π a
      (A.germ_pullbackEqn_mem_nonZeroDivisors R' hc.projective_colength) ha1
  refine (Submodule.eq_of_le_of_rankAtStalk_quotient_eq
    hle (fun p => ?_)).symm
  exact (x.rankAtStalk_eq p).trans (hrankR' p).symm