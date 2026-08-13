/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0RankOneUniquenessDischarge
import AlgebraicJacobian.Picard.Pic0RankOneDatumGluedDivisor
import AlgebraicJacobian.Picard.DivisorDatumRankOne
import AlgebraicJacobian.Cohomology.DatumDescent
import AlgebraicJacobian.Cohomology.RankOneFamilyCertificatesFiniteStage
import Mathlib.RingTheory.Spectrum.Prime.FreeLocus
import Mathlib.RingTheory.Spectrum.Prime.Topology
import Mathlib.RingTheory.LocalRing.ResidueField.Ideal
import Mathlib.Algebra.Module.FinitePresentation

/-!
# The canonical rank-one divisor, Noetherian-free

`existsUnique_abel_divFamZarAff_of_mem` removes the Noetherian hypothesis from the canonical
rank-one divisor: over any affine test `A` whose plus class lies in the rank-one locus there
is a unique widened locally certified divisor class of degree `genus C` with Abel value the
input class — with no Noetherian hypothesis on any presentation carrier.  The price is the
structural hypothesis `hpi : pi ≫ P1.structureMap k = C.hom` tying the finite chart to the
curve, which feeds the finite-stage rigid engine.

Membership tested at the identity yields a presentation `P` of the input class on an étale
carrier `B := P.cover.Carrier`, arbitrary and in general not Noetherian.  The Noetherian
input of the glued-divisor keystone is manufactured by descent:

* the presented datum descends to a finitely generated — hence Noetherian — stage `A₀` with
  pair-`H¹` vanishing at the stage itself (`exists_fg_subalgebra_baseChange_eq` +
  `exists_fg_pairH1_vanishing_stage`);
* stage `H⁰` is finite projective (`datumRigidEngine`), so its `rankAtStalk` is locally
  constant; the rank-one level set of the stage is clopen, contains the image of
  `Spec B → Spec A₀` (rank one over `B` by the presentation), and that image is dense
  because `A₀ ⊆ B` is injective — hence the stage rank is one at every prime;
* rank one at a stage prime gives `h⁰ = 1` on the residue fibre, and the χ-formula
  `h⁰ = deg + (1 − genus)` (`h0_gluedSheaf_eq_classDeg_add_chi`), solved backwards, pins
  the fibre degree of the stage class at `genus C`; the degree law extends to every field
  point of the stage through the kernel-prime residue embedding
  (`Ideal.ResidueField.liftₐ` + `classDeg_cechPicMap_baseFieldTransition`);
* the keystone `exists_glued_divFamZarAff_of_admissible_fibre` now fires at the Noetherian
  stage; the resulting family pushes up to `B`, its Abel value is the restricted input
  class, and `existsUnique_abel_divFamZarAff_of_etale_witness` with the discharged
  uniqueness interface descends it uniquely to `A`.

The unique class is extracted as `canonicalRankOneDivisorOfMem`, with its Abel equation
and uniqueness accessors.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161), so the pinned synthesis
depth must be set in-file for the faithful per-file check. -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
  Opposite TopologicalSpace
open scoped TensorProduct

namespace AlgebraicGeometry

open AlgebraicJacobian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable (pi : C.left ⟶ P1 k) [IsFinite pi]

noncomputable local instance freeCanonicalOverCleft :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

/- Re-key the canonical field base-change package for the degree computations (the standing
pattern of the degree-stack files). -/
noncomputable local instance (priority := 20000) freeCanonicalDegreeOver
    (L : Type u) [Field L] [Algebra k L] :
    (relCurve C L).Over (Spec (.of L)) :=
  instOverBaseChange C L

noncomputable local instance freeCanonicalDegreeSmooth
    (L : Type u) [Field L] [Algebra k L] :
    SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (.of L)) :=
  instSmoothOfRelativeDimensionBaseChange C L

noncomputable local instance freeCanonicalDegreeIntegral
    (L : Type u) [Field L] [Algebra k L] :
    IsIntegral (relCurve C L) :=
  instIsIntegralBaseChange C L

noncomputable local instance freeCanonicalDegreeQuasiCompact
    (L : Type u) [Field L] [Algebra k L] :
    QuasiCompact (relCurve C L ↘ Spec (.of L)) :=
  instQuasiCompactBaseChange C L

noncomputable local instance freeCanonicalDegreeFiniteH0
    (L : Type u) [Field L] [Algebra k L] :
    Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0) :=
  instModuleFiniteHModuleZeroBaseChange C L

noncomputable local instance freeCanonicalDegreeFiniteH1
    (L : Type u) [Field L] [Algebra k L] :
    Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1) :=
  instModuleFiniteHModuleOneBaseChange C L

/-! ## Reverse Riemann–Roch at a stage prime -/

set_option maxHeartbeats 2000000 in
-- The presentation bridge and the fibre H⁰ equivalences elaborate large sheaf terms.
set_option synthInstance.maxHeartbeats 800000 in
/-- **Reverse Riemann–Roch at a residue fibre**: for a datum over a Noetherian stage with
vanishing pair-`H¹` and finite projective `H⁰`, stalk rank one at a prime forces the fibre
degree of the datum class at that prime's residue field to be `genus C`.  This inverts the
Σ-RANK1 computation `rankAtStalk_hModule_zero_eq_one`: there the degree pins the rank; here
`h⁰ = 1` is read off the rank, and the χ-formula `h⁰ = deg + (1 − genus)`
(`h0_gluedSheaf_eq_classDeg_add_chi` through the presentation bridge) is solved for the
degree. -/
private theorem stage_classDeg_residueField
    {R : Type u} [CommRing R] [Algebra k R] [IsNoetherianRing R]
    (D : BasicOpenCocycleDatum C R pi)
    (hH1 : Subsingleton (datumPair D).H1)
    [Module.Finite R (Sheaf.HModule D.sheaf 0)]
    [Module.Projective R (Sheaf.HModule D.sheaf 0)]
    (p : PrimeSpectrum R)
    (hrank : Module.rankAtStalk (Sheaf.HModule D.sheaf 0) p = 1) :
    classDeg p.asIdeal.ResidueField
      (Scheme.CechPic.map (relCurveMap C R p.asIdeal.ResidueField) D.cechPicClass)
      = (genus C : ℤ) := by
  rw [← D.cechPicClass_baseChange p.asIdeal.ResidueField]
  -- the fibre global-section count is one, inverting the Σ-RANK1 calc
  have hfibre : Sheaf.h0 (D.baseChange p.asIdeal.ResidueField).sheaf = 1 := by
    have hcalc : Module.rankAtStalk (Sheaf.HModule D.sheaf 0) p
        = Sheaf.h0 (D.baseChange p.asIdeal.ResidueField).sheaf := by
      calc Module.rankAtStalk (Sheaf.HModule D.sheaf 0) p
          = Module.finrank p.asIdeal.ResidueField
              (p.asIdeal.ResidueField ⊗[R] (Sheaf.HModule D.sheaf 0)) :=
            Module.rankAtStalk_eq p
        _ = Module.finrank p.asIdeal.ResidueField
              (Sheaf.HModule (D.baseChange p.asIdeal.ResidueField).sheaf 0) :=
            (D.datumH0BaseChange p.asIdeal.ResidueField hH1).finrank_eq
        _ = Sheaf.h0 (D.baseChange p.asIdeal.ResidueField).sheaf := rfl
    rw [← hcalc, hrank]
  -- the χ-formula through the presentation bridge, solved backwards for the degree
  have hsub : Subsingleton
      (Sheaf.HModule (D.baseChange p.asIdeal.ResidueField).sheaf 1) :=
    D.datum_subsingleton_h1_baseChange p.asIdeal.ResidueField hH1
  set P : (relCurve C p.asIdeal.ResidueField).MeromorphicPresentation :=
    Scheme.MeromorphicPresentation.ofCocycle
      (D.baseChange p.asIdeal.ResidueField).pointedCover
      (gluedSubordCocycle (D.baseChange p.asIdeal.ResidueField).isGluingCocycle
        (D.baseChange p.asIdeal.ResidueField).pointedCover
        (D.baseChange p.asIdeal.ResidueField).pieceIndex
        fun _ => le_rfl) with hP
  have hsubP : Subsingleton (Sheaf.HModule (P.gluedSheaf p.asIdeal.ResidueField) 1) :=
    (Sheaf.HModule.mapEquiv
      (BasicOpenCocycleDatum.presentationSheafIso
        (D.baseChange p.asIdeal.ResidueField))
      1).toEquiv.subsingleton_congr.mp hsub
  have h0eq : Sheaf.h0 (D.baseChange p.asIdeal.ResidueField).sheaf
      = Sheaf.h0 (P.gluedSheaf p.asIdeal.ResidueField) :=
    Sheaf.h0_congr (BasicOpenCocycleDatum.presentationSheafIso
      (D.baseChange p.asIdeal.ResidueField))
  have hformula := h0_gluedSheaf_eq_classDeg_add_chi p.asIdeal.ResidueField P hsubP
  have hPclass : P.picClass = (D.baseChange p.asIdeal.ResidueField).cechPicClass := rfl
  have hchi : Sheaf.chi ((relCurve C p.asIdeal.ResidueField).moduleKSheaf
      p.asIdeal.ResidueField) = 1 - (genus C : ℤ) :=
    chi_relCurve (chi_moduleKSheaf C) p.asIdeal.ResidueField
  have h1 : ((Sheaf.h0 (D.baseChange p.asIdeal.ResidueField).sheaf : ℕ) : ℤ)
      = classDeg p.asIdeal.ResidueField
          (D.baseChange p.asIdeal.ResidueField).cechPicClass
        + (1 - (genus C : ℤ)) := by
    rw [h0eq, hformula, hPclass, hchi]
  rw [hfibre] at h1
  push_cast at h1
  linarith

set_option maxHeartbeats 1000000 in
-- The residue-field tower and the base-field transition elaborate large curve terms.
set_option synthInstance.maxHeartbeats 400000 in
/-- **The stage degree law at every field point.**  A fibre degree law verified at every
residue field of the stage extends to every field `K` under the stage: the kernel of
`A₀ → K` is a prime `p`, the residue field `κ(p)` embeds in `K` by the universal property
of the residue field (`Ideal.ResidueField.liftₐ`), and the degree is invariant under the
base-field transition (`classDeg_cechPicMap_baseFieldTransition`). -/
private theorem stage_classDeg_field
    {R : Type u} [CommRing R] [Algebra k R]
    (D : BasicOpenCocycleDatum C R pi)
    (hres : ∀ p : PrimeSpectrum R,
      classDeg p.asIdeal.ResidueField
        (Scheme.CechPic.map (relCurveMap C R p.asIdeal.ResidueField) D.cechPicClass)
        = (genus C : ℤ))
    (K : Type u) [Field K] [Algebra k K] [Algebra R K] [IsScalarTower k R K] :
    classDeg K (Scheme.CechPic.map (relCurveMap C R K) D.cechPicClass)
      = (genus C : ℤ) := by
  classical
  haveI hker : (RingHom.ker (algebraMap R K)).IsPrime := RingHom.ker_isPrime _
  set p : PrimeSpectrum R := ⟨RingHom.ker (algebraMap R K), hker⟩ with hpdef
  -- the residue field of the kernel prime embeds into `K` over `k`
  have hcompl : p.asIdeal.primeCompl ≤
      (IsUnit.submonoid K).comap (IsScalarTower.toAlgHom k R K) := by
    intro x hx
    rw [Submonoid.mem_comap]
    exact isUnit_iff_ne_zero.mpr fun h0 => hx (RingHom.mem_ker.mpr h0)
  let rho : p.asIdeal.ResidueField →ₐ[k] K :=
    Ideal.ResidueField.liftₐ p.asIdeal (IsScalarTower.toAlgHom k R K) le_rfl hcompl
  letI : Algebra p.asIdeal.ResidueField K := rho.toRingHom.toAlgebra
  haveI : IsScalarTower k p.asIdeal.ResidueField K :=
    .of_algebraMap_eq fun x => (rho.commutes x).symm
  haveI : IsScalarTower R p.asIdeal.ResidueField K :=
    .of_algebraMap_eq fun x =>
      (Ideal.ResidueField.liftₐ_algebraMap p.asIdeal
        (IsScalarTower.toAlgHom k R K) le_rfl hcompl x).symm
  have hcurve : (C ◁ Over.overSpecMap rho).left
      = relCurveMap C p.asIdeal.ResidueField K := by
    refine congrArg
      (fun t : overSpec k K ⟶ overSpec k p.asIdeal.ResidueField =>
        (C ◁ t).left) ?_
    exact Over.OverMorphism.ext rfl
  have hinv := classDeg_cechPicMap_baseFieldTransition C rho
    (Scheme.CechPic.map (relCurveMap C R p.asIdeal.ResidueField) D.cechPicClass)
  rw [hcurve] at hinv
  calc classDeg K (Scheme.CechPic.map (relCurveMap C R K) D.cechPicClass)
      = classDeg K (Scheme.CechPic.map (relCurveMap C p.asIdeal.ResidueField K)
          (Scheme.CechPic.map (relCurveMap C R p.asIdeal.ResidueField)
            D.cechPicClass)) := by
        rw [← MonoidHom.comp_apply, ← Scheme.CechPic.map_comp, relCurveMap_comp]
    _ = classDeg p.asIdeal.ResidueField
          (Scheme.CechPic.map (relCurveMap C R p.asIdeal.ResidueField)
            D.cechPicClass) := hinv
    _ = (genus C : ℤ) := hres p

/-! ## The Noetherian-free canonical divisor -/

set_option maxHeartbeats 4000000 in
-- The stage descent, the clopen-dense rank argument and the keystone application
-- elaborate two localization/subalgebra towers of sheaf terms.
set_option synthInstance.maxHeartbeats 800000 in
/-- **The unique Abel-correct divisor of a rank-one class, Noetherian-free**: over any
affine test whose plus class lies in the rank-one locus there is a unique widened locally
certified divisor class of degree `genus C` whose Abel value is the input class.  No
Noetherian hypothesis is imposed on any carrier; the finite-chart normalization `hpi`
replaces it, feeding the finite-stage descent of the presented datum. -/
theorem existsUnique_abel_divFamZarAff_of_mem
    (hpi : pi ≫ P1.structureMap k = C.hom)
    {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    (hlam : lam ∈ (PicRankOneOpen pi).obj (op (overSpec k A))) :
    ∃! F : DivFamZarAff C A (genus C),
      abelDivAffPlus C A F = picEtAffineEquiv C A lam.1 := by
  classical
  -- membership tested at the identity yields a presentation of the input class
  obtain ⟨P⟩ := (mem_picRankOneOpen_iff pi lam).mp hlam A (𝟙 (overSpec k A))
  have e : ((picDegLayerFunctor C (genus C : ℤ)).map
      (𝟙 (overSpec k A)).op lam).1 = lam.1 :=
    picEtMap_id C lam.1
  -- Step 1: descend the presented datum to a finitely generated Noetherian stage with
  -- pair-H¹ vanishing at the stage itself
  have hpair : Subsingleton (datumPair P.datum).H1 :=
    (subsingleton_datumPair_h1_iff P.datum).mpr P.h1_vanishing
  obtain ⟨B0, hB0fg, D0, hD0⟩ := P.datum.exists_fg_subalgebra_baseChange_eq
  have hpairBase : Subsingleton
      (datumPair (D0.baseChange (B' := P.cover.Carrier))).H1 := by
    rw [hD0]
    exact hpair
  have htensor : Subsingleton ((datumPair D0).H1 ⊗[B0] P.cover.Carrier) :=
    D0.subsingleton_h1_tensor_of_baseChange P.cover.Carrier hpairBase
  obtain ⟨A0, -, -, hAnoeth, hpairA0, hAA⟩ :=
    BasicOpenCocycleDatum.exists_fg_pairH1_vanishing_stage
      (C := C) (pi := pi) B0 hB0fg D0 hpi htensor
  letI : IsNoetherianRing A0 := hAnoeth
  letI : Subsingleton (datumPair (D0.baseChange A0)).H1 := hpairA0
  have hbase : (D0.baseChange A0).baseChange P.cover.Carrier = P.datum :=
    hAA.trans hD0
  -- Step 2: fibrewise H¹ witnesses at the stage
  have hfibA : ∀ p : PrimeSpectrum A0,
      Subsingleton ((datumPair (D0.baseChange A0)).H1 ⊗[A0]
        p.asIdeal.ResidueField) :=
    fun _ => inferInstance
  have hwit : ∀ p : PrimeSpectrum A0,
      (D0.baseChange A0).HasWitnessH1Vanishing p.asIdeal.ResidueField :=
    fun p => ((D0.baseChange A0).hasWitnessH1Vanishing_iff_subsingleton
      p.asIdeal.ResidueField).mpr (hfibA p)
  -- stage H⁰ is finite projective over the Noetherian stage
  obtain ⟨-, hfinA, hprojA⟩ := datumRigidEngine (D0.baseChange A0) hpi hfibA
  letI := hfinA
  letI := hprojA
  -- Step 3: the stage rank is one at every prime — the rank-one level set of the locally
  -- constant `rankAtStalk` is clopen and contains the dense image of `Spec B → Spec A₀`
  letI : Module.FinitePresentation A0 (Sheaf.HModule (D0.baseChange A0).sheaf 0) :=
    Module.finitePresentation_of_projective _ _
  have hlc : IsLocallyConstant
      (Module.rankAtStalk (R := A0) (Sheaf.HModule (D0.baseChange A0).sheaf 0)) :=
    Module.isLocallyConstant_rankAtStalk
  have hinj : Function.Injective (algebraMap A0 P.cover.Carrier) :=
    fun x y hxy => Subtype.ext hxy
  have hdense : DenseRange (PrimeSpectrum.comap (algebraMap A0 P.cover.Carrier)) :=
    PrimeSpectrum.denseRange_comap_iff_ker_le_nilRadical.mpr
      (by rw [(RingHom.injective_iff_ker_eq_bot _).mp hinj]; exact bot_le)
  -- on the image of the comparison the rank is one, transported from the presentation
  set eH0 : P.cover.Carrier ⊗[A0] (Sheaf.HModule (D0.baseChange A0).sheaf 0) ≃ₗ[P.cover.Carrier]
      Sheaf.HModule P.datum.sheaf 0 :=
    ((D0.baseChange A0).datumH0BaseChange P.cover.Carrier hpairA0).trans
      (Sheaf.HModule.mapEquiv
        (eqToIso (congrArg
          (fun E : BasicOpenCocycleDatum C P.cover.Carrier pi => E.sheaf) hbase)) 0)
    with heH0
  have himg : ∀ q : PrimeSpectrum P.cover.Carrier,
      Module.rankAtStalk (R := A0) (Sheaf.HModule (D0.baseChange A0).sheaf 0)
        (q.comap (algebraMap A0 P.cover.Carrier)) = 1 := by
    intro q
    rw [← Module.rankAtStalk_baseChange, Module.rankAtStalk_eq_of_equiv eH0]
    exact P.h0_rank_one q
  have hrankstage : ∀ p : PrimeSpectrum A0,
      Module.rankAtStalk (R := A0) (Sheaf.HModule (D0.baseChange A0).sheaf 0) p = 1 := by
    intro p
    by_contra hp
    obtain ⟨q, hq⟩ := hdense.exists_mem_open (hlc ({1}ᶜ : Set ℕ)) ⟨p, hp⟩
    exact hq (himg q)
  -- Step 4: the stage degree law at every field point, by reverse Riemann–Roch
  have hres : ∀ p : PrimeSpectrum A0,
      classDeg p.asIdeal.ResidueField
        (Scheme.CechPic.map (relCurveMap C A0 p.asIdeal.ResidueField)
          (D0.baseChange A0).cechPicClass) = (genus C : ℤ) :=
    fun p => stage_classDeg_residueField pi (D0.baseChange A0) hpairA0 p (hrankstage p)
  have hdeg : ∀ (K : Type u) [Field K] [Algebra k K] [Algebra A0 K]
      [IsScalarTower k A0 K],
      classDeg K (Scheme.CechPic.map (relCurveMap C A0 K)
        (D0.baseChange A0).cechPicClass) = (genus C : ℤ) := by
    intro K _ _ _ _
    exact stage_classDeg_field pi (D0.baseChange A0) hres K
  -- Step 5: the keystone glued divisor at the stage, pushed to the presentation carrier
  obtain ⟨F, hFrel⟩ :=
    (D0.baseChange A0).exists_glued_divFamZarAff_of_admissible_fibre hpi hwit hdeg
  set F' : DivFamZarAff C P.cover.Carrier (genus C) :=
    DivFamZarAff.mapAlgHom (IsScalarTower.toAlgHom k A0 P.cover.Carrier) F with hF'def
  have hF'pic : F'.picClass
      = Scheme.CechPic.map (relCurveMap C A0 P.cover.Carrier) F.picClass := by
    rw [hF'def, DivFamZarAff.mapAlgHom_eq_mapAlg
      (IsScalarTower.toAlgHom k A0 P.cover.Carrier) (fun _ => rfl),
      DivFamZarAff.picClass_mapAlg]
  have hcurveB : (C ◁ Over.overSpecMap (IsScalarTower.toAlgHom k A0 P.cover.Carrier)).left
      = relCurveMap C A0 P.cover.Carrier := by
    refine congrArg
      (fun t : overSpec k P.cover.Carrier ⟶ overSpec k A0 =>
        (C ◁ t).left) ?_
    exact Over.OverMorphism.ext rfl
  have hclassB : P.datum.cechPicClass
      = Scheme.CechPic.map (relCurveMap C A0 P.cover.Carrier)
          (D0.baseChange A0).cechPicClass := by
    rw [← hbase]
    exact (D0.baseChange A0).cechPicClass_baseChange P.cover.Carrier
  have hrelB : relPicMk C (overSpec k P.cover.Carrier) F'.picClass
      = relPicMk C (overSpec k P.cover.Carrier) P.datum.cechPicClass := by
    have h := congrArg (relPicAlgMap C (IsScalarTower.toAlgHom k A0 P.cover.Carrier)) hFrel
    rw [relPicAlgMap_mk, relPicAlgMap_mk, hcurveB] at h
    rw [hF'pic, hclassB]
    exact h
  -- the Abel value of the pushed family is the restricted input class
  have hrep : PicEtAff.mk C P.cover P.representative = picEtAffineEquiv C A lam.1 := by
    rw [← e]
    exact P.represents
  have htarget : PicEtAff.mapAlg C ((Algebra.ofId A P.cover.Carrier).restrictScalars k)
      (picEtAffineEquiv C A lam.1)
      = PicEtAff.unit C P.cover.Carrier
          (P.representative : relPic C (overSpec k P.cover.Carrier)) := by
    rw [← hrep, PicEtAff.mapAlg_mk_eq_unit_self]
  have habel : abelDivAffPlus C P.cover.Carrier F'
      = PicEtAff.mapAlg C ((Algebra.ofId A P.cover.Carrier).restrictScalars k)
          (picEtAffineEquiv C A lam.1) := by
    calc abelDivAffPlus C P.cover.Carrier F'
        = PicEtAff.unit C P.cover.Carrier
            (relPicMk C (overSpec k P.cover.Carrier) F'.picClass) := rfl
      _ = PicEtAff.unit C P.cover.Carrier
            (relPicMk C (overSpec k P.cover.Carrier) P.datum.cechPicClass) := by
          rw [hrelB]
      _ = PicEtAff.unit C P.cover.Carrier
            (P.representative : relPic C (overSpec k P.cover.Carrier)) := by
          rw [← P.datum_class]
      _ = PicEtAff.mapAlg C ((Algebra.ofId A P.cover.Carrier).restrictScalars k)
            (picEtAffineEquiv C A lam.1) := htarget.symm
  -- Step 6: descend along the étale carrier via the discharged uniqueness interface
  exact existsUnique_abel_divFamZarAff_of_etale_witness pi
    (rankOneDivisorUniqueness pi) lam hlam P.cover F' habel

/-! ## Extraction: the canonical divisor and its accessors -/

/-- **The canonical rank-one divisor of a membership certificate**: the unique widened
divisor class over the test algebra whose Abel value is the rank-one plus class, chosen
from `existsUnique_abel_divFamZarAff_of_mem`.  No Noetherian hypothesis. -/
noncomputable def canonicalRankOneDivisorOfMem
    (hpi : pi ≫ P1.structureMap k = C.hom)
    {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    (hlam : lam ∈ (PicRankOneOpen pi).obj (op (overSpec k A))) :
    DivFamZarAff C A (genus C) :=
  (existsUnique_abel_divFamZarAff_of_mem pi hpi hlam).choose

/-- The canonical rank-one divisor satisfies the Abel equation: its widened Abel value is
the input rank-one plus class. -/
theorem canonicalRankOneDivisorOfMem_abel
    (hpi : pi ≫ P1.structureMap k = C.hom)
    {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    (hlam : lam ∈ (PicRankOneOpen pi).obj (op (overSpec k A))) :
    abelDivAffPlus C A (canonicalRankOneDivisorOfMem pi hpi hlam)
      = picEtAffineEquiv C A lam.1 :=
  (existsUnique_abel_divFamZarAff_of_mem pi hpi hlam).choose_spec.1

/-- Any Abel-correct widened divisor class equals the canonical rank-one divisor. -/
theorem canonicalRankOneDivisorOfMem_unique
    (hpi : pi ≫ P1.structureMap k = C.hom)
    {A : Type u} [CommRing A] [Algebra k A]
    {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}
    (hlam : lam ∈ (PicRankOneOpen pi).obj (op (overSpec k A)))
    (F : DivFamZarAff C A (genus C))
    (hF : abelDivAffPlus C A F = picEtAffineEquiv C A lam.1) :
    F = canonicalRankOneDivisorOfMem pi hpi hlam :=
  (existsUnique_abel_divFamZarAff_of_mem pi hpi hlam).choose_spec.2 F hF

end AlgebraicGeometry
