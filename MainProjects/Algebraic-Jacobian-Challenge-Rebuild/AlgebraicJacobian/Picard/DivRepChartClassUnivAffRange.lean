/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivRepChartClassUnivAffCertified
import AlgebraicJacobian.Picard.DivRepChartClassUnivQuot
import AlgebraicJacobian.Picard.DivRepClassifyZarAffSurj
import AlgebraicJacobian.Picard.DivisorFamilyAffThetaEffective

/-!
# The widened universal classes hit every divisor chart

The universal seed class is only locally certified on the chart ring, but the characterizing
clause tests it against a globally certified widened representative after arbitrary base change.
The universal window inclusions survive that base change.  Projectivity and constant rank of the
test representative's intrinsic window quotients then upgrade both inclusions to equalities, so
its pair-chart frame presents the same morphism as the canonical divisor chart.
-/

set_option autoImplicit false
set_option quotPrecheck false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 8
set_option maxRecDepth 16000

universe u

open CategoryTheory TopologicalSpace Opposite

namespace AlgebraicGeometry

open Grassmannian Scheme ThetaGeneratorSeed

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
  Scheme.functionFieldOverModule
attribute [local instance 10000] relCurve.instOver

namespace PointwiseAchiever

section UniversalAffRange

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {pi : C.left ⟶ P1 k} [IsFinite pi] [IsDominant pi]

noncomputable local instance instOverCleftDivRepChartClassUnivAffRange :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))]
  [QuasiCompact (C.left ↘ Spec (.of k))]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hpi : pi ≫ P1.structureMap k = C.left ↘ Spec (.of k))
variable (g r1 r2 : Nat)
variable (b1 : Module.Basis (Fin r1) k
  ↥(divisorSections k (windowM_choice pi hpi g • fiberWeilDivisor pi) ⊤))
variable (b2 : Module.Basis (Fin r2) k
  ↥(divisorSections k
    ((windowM_choice pi hpi g + windowS_choice pi hpi g) • fiberWeilDivisor pi) ⊤))
variable (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
  (hchi : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : Int))

local notation "b2c" => b2.map (windowShiftEquiv hpi g).symm
local notation "ChartRing" => fun i j =>
  DivCarveChartRing k (windowS_choice pi hpi g • fiberWeilDivisor pi)
    (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1 b2c i j
local notation "ChartMap" => fun i j =>
  divCarveChartToDivScheme k (windowS_choice pi hpi g • fiberWeilDivisor pi)
    (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1 b2c i j

/-- The local-certification proof packaged by the universal widened chart class. -/
theorem isLocallyCertifiedAff_univSeed (i : (glueData k g r1).J)
    (j : (glueData k g r2).J) (hb : 0 < windowBound pi hpi) :
    IsLocallyCertifiedAff g
      (univSystemAff C hpi g r1 r2 b1 b2c i j hO hchi hb) :=
  ThetaGeneratorSeed.isLocallyCertifiedAff_of_forall_prime_certified_adaptation
    (isGenerator_univSeed C hpi g r1 r2 b1 b2c i j hO hchi hb)
    (exists_away_isCertified_univSeedAff
      C hpi g r1 r2 b1 b2c i j hO hchi hb)

@[simp]
theorem divFamZarAffUniv_eq_mk (i : (glueData k g r1).J)
    (j : (glueData k g r2).J) (hb : 0 < windowBound pi hpi) :
    divFamZarAffUniv C hpi g r1 r2 b1 b2c i j hO hchi hb =
      DivFamZarAff.mk
        (univSystemAff C hpi g r1 r2 b1 b2c i j hO hchi hb)
        (isLocallyCertifiedAff_univSeed
          C hpi g r1 r2 b1 b2 hO hchi i j hb) :=
      rfl

set_option maxHeartbeats 4000000 in
set_option synthInstance.maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency true in
/-- The certificate/rank half of a universal window comparison, isolated from the chart-class
classifier so Lean can compile the dependent quotient witnesses once and reuse the result at
both pinned windows. -/
abbrev pullbackRegularity
    {R : Type u} [CommRing R] [Algebra k R]
    (d : (relCurve C R).LocalEquations)
    (T : Type u) [CommRing T] [Algebra k T] [Algebra R T]
    [IsScalarTower k R T] : Prop :=
  ∀ (y z : relCurve C T)
    (hz : z ∈ (d.cover.pullback (relCurveMap C R T)).opens y),
    ((relCurve C T).presheaf.germ
      ((d.cover.pullback (relCurveMap C R T)).opens y) z hz).hom
        (Scheme.LocalEquations.pullbackEqn (relCurveMap C R T) d y)
      ∈ nonZeroDivisors ((relCurve C T).presheaf.stalk z)

theorem divisorWindow_eq_map_of_divEq
    (i0 : (glueData k g r1).J) (j0 : (glueData k g r2).J)
    (T : Type u) [CommRing T] [Algebra k T]
    (alpha : ChartRing i0 j0 →ₐ[k] T)
    (a : Nat)
    (ha1 : Subsingleton (relTwistPair C k pi
      (relThetaCocycle C k pi a)).H1)
    (hMa : windowM_choice pi hpi g ≤ a)
    (x : Grassmannian.grFunctorAff k
      (↥(divisorSections k (a • fiberWeilDivisor pi) ⊤)) g (ChartRing i0 j0))
    (d : (relCurve C (ChartRing i0 j0)).LocalEquations)
    (e : (relCurve C T).LocalEquations)
    (G : CertifiedDivisorFamilyAff C T g)
    (hx : x.toSubmodule ≤ divisorWindow d ha1) :
    letI : Algebra (ChartRing i0 j0) T := alpha.toAlgebra
    letI : IsScalarTower k (ChartRing i0 j0) T :=
      .of_algebraMap_eq fun r => (alpha.commutes r).symm
    (∀ (hreg : pullbackRegularity C d T),
      e.DivEq (d.pullback (relCurveMap C (ChartRing i0 j0) T) hreg) →
      divisorWindow e ha1 =
        (Module.Grassmannian.map alpha x).toSubmodule) := by
  letI : Algebra (ChartRing i0 j0) T := alpha.toAlgebra
  letI : IsScalarTower k (ChartRing i0 j0) T :=
    .of_algebraMap_eq fun r => (alpha.commutes r).symm
  intro hreg hdiv
  have hpull : windowBaseChange T (divisorWindow d ha1) ≤
      divisorWindow e ha1 := by
    rw [divisorWindow_eq_of_divEq hdiv ha1]
    exact windowBaseChange_divisorWindow_le C T pi a hreg ha1
  have hproj : Module.Projective T
      ((TensorProduct k T
        ↑(divisorSections k (a • fiberWeilDivisor pi) ⊤)) ⧸
          divisorWindow e ha1) :=
    G.certified.projective_intrinsicWindowQuotient
      (pi := pi) G.adaptation a hpi hO hchi ha1 hMa
  have hrank : ∀ p : PrimeSpectrum T,
      Module.rankAtStalk
        ((TensorProduct k T
          ↑(divisorSections k (a • fiberWeilDivisor pi) ⊤)) ⧸
            divisorWindow e ha1) p = g :=
    fun p => G.certified.rankAtStalk_intrinsicWindowQuotient
      (pi := pi) G.adaptation a hpi hO hchi ha1 hMa p
  exact Grassmannian.eq_map_toSubmodule_of_baseChange_le alpha x
    (divisorWindow d ha1) (divisorWindow e ha1) hx hpull hproj hrank

set_option maxHeartbeats 4000000 in
set_option synthInstance.maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency true in
/-- First pinned window comparison, compiled independently from the second window. -/
theorem universalFstWindow_eq_map
    (i0 : (glueData k g r1).J) (j0 : (glueData k g r2).J)
    (T : Type u) [CommRing T] [Algebra k T]
    (alpha : ChartRing i0 j0 →ₐ[k] T)
    (G : CertifiedDivisorFamilyAff C T g)
    (d : (relCurve C (ChartRing i0 j0)).LocalEquations)
    (hfst : (divUniversalFstWindow C pi hpi g r1 r2 b1 b2c i0 j0).toSubmodule ≤
      divisorWindow d (relThetaPairH1_windowM C pi hpi g)) :
    letI : Algebra (ChartRing i0 j0) T := alpha.toAlgebra
    letI : IsScalarTower k (ChartRing i0 j0) T :=
      .of_algebraMap_eq fun r => (alpha.commutes r).symm
    ∀ (hreg : pullbackRegularity C d T),
      G.eqns.DivEq (d.pullback (relCurveMap C (ChartRing i0 j0) T) hreg) →
      (G.eps hpi g).1 =
        (Module.Grassmannian.map alpha
          (divUniversalFstWindow C pi hpi g r1 r2 b1 b2c i0 j0)).toSubmodule := by
  letI : Algebra (ChartRing i0 j0) T := alpha.toAlgebra
  letI : IsScalarTower k (ChartRing i0 j0) T :=
    .of_algebraMap_eq fun r => (alpha.commutes r).symm
  intro hreg hdiv
  rw [CertifiedDivisorFamilyAff.eps_fst]
  exact (divisorWindow_eq_map_of_divEq
    (C := C) (pi := pi) (hpi := hpi) (g := g) (r1 := r1) (r2 := r2)
    (b1 := b1) (b2 := b2) (hO := hO) (hchi := hchi)
    i0 j0 T alpha (windowM_choice pi hpi g)
    (relThetaPairH1_windowM C pi hpi g) le_rfl
    (divUniversalFstWindow C pi hpi g r1 r2 b1 b2c i0 j0)
    d G hfst) hreg hdiv

set_option maxHeartbeats 4000000 in
set_option synthInstance.maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency true in
/-- Second pinned window comparison, compiled independently from the first window. -/
theorem universalSndWindow_eq_map
    (i0 : (glueData k g r1).J) (j0 : (glueData k g r2).J)
    (T : Type u) [CommRing T] [Algebra k T]
    (alpha : ChartRing i0 j0 →ₐ[k] T)
    (G : CertifiedDivisorFamilyAff C T g)
    (d : (relCurve C (ChartRing i0 j0)).LocalEquations)
    (hsnd : (divUniversalSndWindow C pi hpi g r1 r2 b1 b2c i0 j0).toSubmodule ≤
      divisorWindow d (relThetaPairH1_windowMS C pi hpi g)) :
    letI : Algebra (ChartRing i0 j0) T := alpha.toAlgebra
    letI : IsScalarTower k (ChartRing i0 j0) T :=
      .of_algebraMap_eq fun r => (alpha.commutes r).symm
    ∀ (hreg : pullbackRegularity C d T),
      G.eqns.DivEq (d.pullback (relCurveMap C (ChartRing i0 j0) T) hreg) →
      (G.eps hpi g).2 =
        (Module.Grassmannian.map alpha
          (divUniversalSndWindow C pi hpi g r1 r2 b1 b2c i0 j0)).toSubmodule := by
  letI : Algebra (ChartRing i0 j0) T := alpha.toAlgebra
  letI : IsScalarTower k (ChartRing i0 j0) T :=
    .of_algebraMap_eq fun r => (alpha.commutes r).symm
  intro hreg hdiv
  rw [CertifiedDivisorFamilyAff.eps_snd]
  exact (divisorWindow_eq_map_of_divEq
    (C := C) (pi := pi) (hpi := hpi) (g := g) (r1 := r1) (r2 := r2)
    (b1 := b1) (b2 := b2) (hO := hO) (hchi := hchi)
    i0 j0 T alpha (windowM_choice pi hpi g + windowS_choice pi hpi g)
    (relThetaPairH1_windowMS C pi hpi g) (Nat.le_add_right _ _)
    (divUniversalSndWindow C pi hpi g r1 r2 b1 b2c i0 j0)
    d G hsnd) hreg hdiv

set_option maxHeartbeats 8000000 in
-- Both universal windows and the arbitrary framed test elaborate through the pulled seed.
set_option synthInstance.maxHeartbeats 800000 in
/-- The universal widened class satisfies the classifier clause at its canonical divisor chart. -/
theorem isDivRepClassifyAff_divFamZarAffUniv
    (i0 : (glueData k g r1).J) (j0 : (glueData k g r2).J)
    (hb : 0 < windowBound pi hpi) :
    IsDivRepClassifyAff hpi g r1 r2 b1 b2
      (divFamZarAffUniv C hpi g r1 r2 b1 b2c i0 j0 hO hchi hb)
      (ChartMap i0 j0) := by
  intro T _ _ _ _ G hG i j w hw
  let alpha : ChartRing i0 j0 →ₐ[k] T :=
    IsScalarTower.toAlgHom k (ChartRing i0 j0) T
  have hGhom : G.toZarAff = DivFamZarAff.mapAlgHom alpha
      (divFamZarAffUniv C hpi g r1 r2 b1 b2c i0 j0 hO hchi hb) :=
    hG.trans (DivFamZarAff.mapAlgHom_eq_mapAlg alpha (fun _ => rfl) _).symm
  letI : Algebra (ChartRing i0 j0) T := alpha.toAlgebra
  haveI : IsScalarTower k (ChartRing i0 j0) T :=
    .of_algebraMap_eq fun a => (alpha.commutes a).symm
  let d := univSystemAff C hpi g r1 r2 b1 b2c i0 j0 hO hchi hb
  let hloc := isLocallyCertifiedAff_univSeed
    C hpi g r1 r2 b1 b2 hO hchi i0 j0 hb
  let hreg := hloc.germ_pullbackEqn_mem_nonZeroDivisors T g
  have hmk : DivFamZarAff.mk G.eqns G.isLocallyCertifiedAff =
      DivFamZarAff.mk (d.pullback (relCurveMap C (ChartRing i0 j0) T) hreg)
        (hloc.pullback T g hreg) := by
    simpa only [CertifiedDivisorFamilyAff.toZarAff, DivFamZarAff.mapAlgHom,
      divFamZarAffUniv_eq_mk, DivFamZarAff.mapAlg_mk] using hGhom
  have hdiv : G.eqns.DivEq
      (d.pullback (relCurveMap C (ChartRing i0 j0) T) hreg) :=
    DivFamZarAff.mk_eq_mk_iff.mp hmk
  let D := univSeed C hpi g r1 r2 b1 b2c i0 j0 hO hchi hb
  let hD := isGenerator_univSeed C hpi g r1 r2 b1 b2c i0 j0 hO hchi hb
  have hfst :
      (divUniversalFstWindow C pi hpi g r1 r2 b1 b2c i0 j0).toSubmodule ≤
        divisorWindow d (relThetaPairH1_windowM C pi hpi g) := by
    change _ ≤ divisorWindow (D.localEquations hD) _
    exact Submodule.map_le_iff_le_comap.mp (D.le_vanishingSubmodule hD)
  have hsnd :
      (divUniversalSndWindow C pi hpi g r1 r2 b1 b2c i0 j0).toSubmodule ≤
        divisorWindow d (relThetaPairH1_windowMS C pi hpi g) := by
    exact divUniversalSndWindow_le_highWindow_divisorWindow
      C hpi g r1 r2 b1 b2c i0 j0 hO hchi hb
  have heps1 : (G.eps hpi g).1 =
      (Module.Grassmannian.map alpha
        (divUniversalFstWindow C pi hpi g r1 r2 b1 b2c i0 j0)).toSubmodule := by
    exact universalFstWindow_eq_map
      (C := C) (pi := pi) (hpi := hpi) (g := g) (r1 := r1) (r2 := r2)
      (b1 := b1) (b2 := b2) (hO := hO) (hchi := hchi)
      i0 j0 T alpha G d hfst hreg hdiv
  have heps2 : (G.eps hpi g).2 =
      (Module.Grassmannian.map alpha
        (divUniversalSndWindow C pi hpi g r1 r2 b1 b2c i0 j0)).toSubmodule := by
    exact universalSndWindow_eq_map
      (C := C) (pi := pi) (hpi := hpi) (g := g) (r1 := r1) (r2 := r2)
      (b1 := b1) (b2 := b2) (hO := hO) (hchi := hchi)
      i0 j0 T alpha G d hsnd hreg hdiv
  let q : PairChartRing k g r1 g r2 i0 j0 →ₐ[k] ChartRing i0 j0 :=
    divCarveChartMk k (windowS_choice pi hpi g • fiberWeilDivisor pi)
      (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1 b2c i0 j0
  let w0 : PairChartRing k g r1 g r2 i0 j0 →ₐ[k] T := alpha.comp q
  have hcoord1 :
      congrAmbient b1.equivFun
          (Module.Grassmannian.map alpha
            (divUniversalFstWindow C pi hpi g r1 r2 b1 b2c i0 j0)) =
        Module.Grassmannian.map w0 (pairTautFst k g r1 r2 i0 j0) := by
    rw [divUniversalFstWindow, map_congrAmbient, congrAmbient_symm_cancel,
      divUniversalFst, ← Module.Grassmannian.map_comp]
  have hb2c :
      (b2.map (windowShiftEquiv hpi g).symm).equivFun.symm.trans
          (seedWindowShiftEquiv C pi hpi g) =
        b2.equivFun.symm := by
    rw [Module.Basis.map_equivFun, LinearEquiv.symm_symm]
    rfl
  have hcoord2 :
      congrAmbient b2.equivFun
          (Module.Grassmannian.map alpha
            (divUniversalSndWindow C pi hpi g r1 r2 b1 b2c i0 j0)) =
        Module.Grassmannian.map w0 (pairTautSnd k g r1 r2 i0 j0) := by
    rw [divUniversalSndWindow, hb2c, map_congrAmbient,
      congrAmbient_symm_cancel, divUniversalSnd, ← Module.Grassmannian.map_comp]
  have hmap1 :
      Module.Grassmannian.map w0 (pairTautFst k g r1 r2 i0 j0) =
        Module.Grassmannian.map w (pairTautFst k g r1 r2 i j) := by
    apply Module.Grassmannian.ext
    rw [hw.1, heps1, ← congrAmbient_toSubmodule]
    exact congrArg Module.Grassmannian.toSubmodule hcoord1.symm
  have hmap2 :
      Module.Grassmannian.map w0 (pairTautSnd k g r1 r2 i0 j0) =
        Module.Grassmannian.map w (pairTautSnd k g r1 r2 i j) := by
    apply Module.Grassmannian.ext
    rw [hw.2, heps2, ← congrAmbient_toSubmodule]
    exact congrArg Module.Grassmannian.toSubmodule hcoord2.symm
  have hpair := specMap_pairChartMap_eq_of_map_pairTaut_eq
    k g r1 r2 i0 i j0 j w0 w hmap1 hmap2
  rw [divCarveChartToDivScheme_divSchemeι
      (k := k)
      (A := windowS_choice pi hpi g • fiberWeilDivisor pi)
      (B := windowM_choice pi hpi g • fiberWeilDivisor pi)
      (g := g) (r₁ := r1) (r₂ := r2) (b₁ := b1) (b₂ := b2c) i0 j0,
    ← Category.assoc, ← Spec.map_comp]
  exact hpair

end UniversalAffRange

end PointwiseAchiever

end AlgebraicGeometry
