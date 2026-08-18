---
author: sync
content_type: theorem
created: '2026-08-03T15:24:41'
decl: AlgebraicGeometry.Adelic.isLocallyConstant_fiberEulerIndex_finiteMapToP1BaseChange
docstring: 'The intrinsic fibre Euler index of the finite pushforward on `P^1_A` is

  locally constant on the affine base.


  One finite replacement works over all of `Spec A`.  Its finite-projective

  degree-zero term has locally constant fibre rank, and

  `Scheme.Hom.fiberEulerIndex_eq_virtualRank` transports that statement to the

  scheme-theoretic fibre Euler index.  This still does not compare the result

  with the Euler characteristic or degree of `L` on `C_A`.'
file: AlgebraicJacobian/Picard/CurveFiniteReplacement.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.isLocallyConstant_fiberEulerIndex_finiteMapToP1BaseChange
type: lean
updated: '2026-08-18T20:52:03'
---
theorem isLocallyConstant_fiberEulerIndex_finiteMapToP1BaseChange
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom]
    (A : Type u) [CommRing A] [Algebra k A] [Algebra.FiniteType k A]
    (L : (Limits.pullback C.hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules)
    (hL : LineBundle.IsLocallyTrivial L) :
    let M := (Modules.pushforward (finiteMapToP1BaseChange A C)).obj L
    let p := pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A)))
    IsLocallyConstant (fun t : Spec (CommRingCat.of A) =>
      p.fiberEulerIndex t M) := by
  haveI : HasFiniteMapToP1 C := inferInstance
  haveI := hL.isFinitePresentation
  let M := (Modules.pushforward (finiteMapToP1BaseChange A C)).obj L
  haveI : IsFinite (finiteMapToP1BaseChange A C) :=
    isFinite_finiteMapToP1BaseChange A C
  haveI : M.IsQuasicoherent :=
    Modules.pushforward_isQuasicoherent (finiteMapToP1BaseChange A C) L
  let p := pullback.snd (p1Over k).hom
    (Spec.map (CommRingCat.ofHom (algebraMap k A)))
  let U := p1BaseChangeCoverSquare (k := k) A
  letI := p.baseSectionsModule M U.U₁
  letI := p.baseSectionsModule M U.U₂
  letI := p.baseSectionsModule M (U.U₁ ⊓ U.U₂)
  obtain ⟨F⟩ :=
    exists_twoTermFiniteReplacement_finiteMapToP1BaseChange C A L hL
  let B := Γ(Spec (CommRingCat.of A), ⊤)
  let ε : B ≃+* CommRingCat.of A :=
    (Scheme.ΓSpecIso (CommRingCat.of A)).commRingCatIsoToRingEquiv
  let H : PrimeSpectrum B ≃ₜ PrimeSpectrum (CommRingCat.of A) :=
    PrimeSpectrum.homeomorphOfRingEquiv ε
  letI : Module.Flat B F.K0 := Module.Flat.of_projective
  letI : Module.FinitePresentation B F.K0 :=
    Module.finitePresentation_of_projective B F.K0
  have hRank : IsLocallyConstant (fun s : PrimeSpectrum B =>
      (s.asIdeal.fiberRank F.K0 : ℤ) - (F.n : ℤ)) := by
    exact (Ideal.isLocallyConstant_fiberRank (A := B) (K := F.K0)).comp
      fun r => (r : ℤ) - (F.n : ℤ)
  have hVirtual : IsLocallyConstant (fun t : Spec (CommRingCat.of A) =>
      ((H.symm t).asIdeal.fiberRank F.K0 : ℤ) - (F.n : ℤ)) := by
    exact hRank.comp_continuous H.symm.continuous
  convert hVirtual using 1
  funext t
  exact p.fiberEulerIndex_eq_virtualRank U M t F