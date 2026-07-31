/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffFibreData
import AlgebraicJacobian.Picard.DivisorFamilyAffThetaKernelGlobal
import AlgebraicJacobian.Picard.DivisorThetaSheafSequence
import AlgebraicJacobian.Picard.DivSchemeCertificateEngine

/-!
# The global theta cokernel and the widened intrinsic range

A widened certificate supplies fibrewise vanishing for `O(a Theta - d)`.  After choosing
an auxiliary chart presentation of the same local equations, the existing rigid engine
turns those witnesses into vanishing of the first cohomology of its theta-ideal sheaf.
The canonical sheaf inclusion from `DivisorThetaSheafSequence` therefore has a surjective
cokernel projection on global sections.

The range of that inclusion on global sections is exactly the cover-independent vanishing
submodule.  Hence the cokernel is canonically the same quotient already identified with
the range of intrinsic widened theta evaluation.  No chart typing of the widened cover and
no additional hypothesis occur.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Limits Opposite TopologicalSpace

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable (R : Type u) [CommRing R] [Algebra k R]
variable (π : C.left ⟶ P1 k) [IsFinite π]

attribute [local instance] instOverCleftWFT

namespace DivisorAdaptation

variable {d : (relCurve C R).LocalEquations}

/-- On global sections, the sheaf inclusion is the established junction from the
theta-ideal datum to the cover-independent vanishing submodule. -/
theorem thetaIdealInclApp_top_eq_gluedToVanishing (B : DivisorAdaptation C R π d)
    (a : ℕ) (s : B.ThetaIdealSections a ⊤) :
    B.thetaIdealInclApp (a := a) ⊤ s =
      ((B.gluedToVanishingₗ a s :
        d.vanishingSubmodule R (relCover C R (fiberTwoCover π)).V₀
          (relCover C R (fiberTwoCover π)).V₁ (relThetaCocycle C R π a)) :
        relThetaSections C R π a) := by
  rfl

/-- The pointwise range of the theta-ideal sheaf inclusion on global sections is exactly
the intrinsic, cover-independent divisor-family vanishing submodule. -/
theorem range_thetaIdealInclApp_top (B : DivisorAdaptation C R π d) (a : ℕ) :
    LinearMap.range (B.thetaIdealInclApp (a := a) ⊤) =
      d.vanishingSubmodule R (relCover C R (fiberTwoCover π)).V₀
        (relCover C R (fiberTwoCover π)).V₁ (relThetaCocycle C R π a) := by
  ext x
  constructor
  · rintro ⟨s, rfl⟩
    rw [thetaIdealInclApp_top_eq_gluedToVanishing C R π B a s]
    exact (B.gluedToVanishingₗ a s).property
  · intro hx
    let y : ↥(d.vanishingSubmodule R (relCover C R (fiberTwoCover π)).V₀
        (relCover C R (fiberTwoCover π)).V₁ (relThetaCocycle C R π a)) := ⟨x, hx⟩
    refine ⟨(B.gluedEquivVanishing a).symm y, ?_⟩
    rw [thetaIdealInclApp_top_eq_gluedToVanishing C R π B]
    exact congrArg Subtype.val ((B.gluedEquivVanishing a).apply_symm_apply y)

/-! ## The local cokernel kernel

The arbitrary-open range producer immediately gives the corresponding kernel fact for
the sheaf cokernel.  Keeping this at an arbitrary open is useful when the intrinsic
descent proof compares restrictions before specializing to `⊤`.
-/

theorem cokernelπ_app_eq_zero_of_germ_mem (B : DivisorAdaptation C R π d)
    {a : ℕ} {W : (relCurve C R).Opens}
    (x : (relThetaTwistSheaf C R π a).obj.obj (op W))
    (hx0 : ∀ (z : relCurve C R) (hz : z ∈ W ⊓
      (relCover C R (fiberTwoCover π)).V₀),
      ((relCurve C R).presheaf.germ (W ⊓
        (relCover C R (fiberTwoCover π)).V₀) z hz).hom x.val.1 ∈ d.stalkIdeal z)
    (hx1 : ∀ (z : relCurve C R) (hz : z ∈ W ⊓
      (relCover C R (fiberTwoCover π)).V₁),
      ((relCurve C R).presheaf.germ (W ⊓
        (relCover C R (fiberTwoCover π)).V₁) z hz).hom x.val.2 ∈ d.stalkIdeal z) :
    ((cokernel.π (B.thetaIdealIncl (a := a))).hom.app (op W)).hom x = 0 := by
  obtain ⟨s, hs⟩ := B.exists_thetaIdealInclApp_of_germ_mem (a := a) x hx0 hx1
  rw [← hs]
  have hnat := congrArg
    (fun f : (B.thetaIdealDatum a).sheaf ⟶ cokernel (B.thetaIdealIncl (a := a)) =>
      f.hom.app (op W)) (cokernel.condition (B.thetaIdealIncl (a := a)))
  have hlin := congrArg ModuleCat.Hom.hom hnat
  exact LinearMap.congr_fun hlin s

end DivisorAdaptation

section CokernelGlobal

variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable [IsDominant π] [IsIntegral C.left]

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))]
  [QuasiCompact (C.left ↘ Spec (.of k))]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]

namespace AffAdaptation

/-- A widened high-window certificate produces an auxiliary chart presentation of the
same equations whose theta-ideal sheaf has vanishing first cohomology. -/
theorem IsCertified.exists_chartAdaptation_subsingleton_thetaIdealH1
    {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}
    {A : AffAdaptation D d} {g : ℕ} (hc : A.IsCertified g)
    (hπ : π ≫ P1.structureMap k = C.hom)
    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    {a : ℕ} (ha1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1)
    (hMa : windowM_choice π hπ g ≤ a) :
    ∃ B : DivisorAdaptation C R π d,
      Subsingleton (Sheaf.HModule (B.thetaIdealDatum a).sheaf 1) := by
  obtain ⟨B⟩ := exists_divisorAdaptation C R π d
  refine ⟨B, (subsingleton_datumPair_h1_iff (B.thetaIdealDatum a)).mp
    (datum_subsingleton_pairH1 (B.thetaIdealDatum a) hπ ?_)⟩
  apply B.thetaIdealDatum_hfib_of_witness a
  intro p
  obtain ⟨W, hWclass, hWH1⟩ :=
    hc.fibrewise_thetaSub_h1_witness C R π hπ hO hχ ha1 hMa p
  refine ⟨W, ?_, hWH1⟩
  rw [BasicOpenCocycleDatum.cechPicClass_baseChange,
    B.cechPicClass_thetaIdealDatum]
  exact hWclass

/-- The same producer in the form consumed by the global cokernel projection. -/
theorem IsCertified.exists_chartAdaptation_thetaIdealCokernel_app_top_surjective
    {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}
    {A : AffAdaptation D d} {g : ℕ} (hc : A.IsCertified g)
    (hπ : π ≫ P1.structureMap k = C.hom)
    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    {a : ℕ} (ha1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1)
    (hMa : windowM_choice π hπ g ≤ a) :
    ∃ B : DivisorAdaptation C R π d,
      Function.Surjective
        ((cokernel.π (DivisorAdaptation.thetaIdealIncl (A := B) (a := a))).hom.app
          (op (⊤ : (relCurve C R).Opens))).hom := by
  obtain ⟨B, hB⟩ := hc.exists_chartAdaptation_subsingleton_thetaIdealH1
    C R π hπ hO hχ ha1 hMa
  letI : Subsingleton (Sheaf.HModule (B.thetaIdealDatum a).sheaf 1) := hB
  exact ⟨B, B.thetaIdealCokernel_app_top_surjective⟩

end AffAdaptation

namespace AffAdaptation

/-! ## Overlap vanishing in the theta cokernel

The intrinsic overlap ideal is detected germwise by the widened kernel theorem.  After
the glued--twist conversion, its two pinned components therefore lie in the kernel of
the auxiliary theta-ideal cokernel on the overlap.
-/

theorem thetaOverlapVanishing_gluedTwist_cokernel_eq_zero
    {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}
    {A : AffAdaptation D d} (B : DivisorAdaptation C R π d) (a : ℕ)
    (i j : D.index)
    (v : A.ThetaOverlapSections (π := π) a i j)
    (hv : v ∈ A.thetaOverlapVanishing (π := π) a i j) :
    ((cokernel.π (B.thetaIdealIncl (a := a))).hom.app
      (op (D.pieces i ⊓ D.pieces j))).hom
      (gluedTwistEquiv C R π a (D.pieces i ⊓ D.pieces j) v) = 0 := by
  let W := D.pieces i ⊓ D.pieces j
  have h := (A.mem_thetaOverlapVanishing_iff_forall_germ (π := π) a i j v).mp hv
  have hx :
      (∀ (z : relCurve C R) (hz : z ∈ W ⊓
        (relCover C R (fiberTwoCover π)).V₀),
        ((relCurve C R).presheaf.germ (W ⊓
          (relCover C R (fiberTwoCover π)).V₀) z hz).hom
            (gluedTwistEquiv C R π a W v).val.1 ∈ d.stalkIdeal z) ∧
      (∀ (z : relCurve C R) (hz : z ∈ W ⊓
        (relCover C R (fiberTwoCover π)).V₁),
        ((relCurve C R).presheaf.germ (W ⊓
          (relCover C R (fiberTwoCover π)).V₁) z hz).hom
            (gluedTwistEquiv C R π a W v).val.2 ∈ d.stalkIdeal z) := by
    constructor
    · intro z hz
      have hswap :
          ((relCurve C R).presheaf.germ
            (W ⊓ (relCover C R (fiberTwoCover π)).V₀) z hz).hom
              ((relCurve C R).resHom
                (inf_le_inf_left W
                  (thetaChartCover_pieces_inl C R π PUnit.unit).ge)
                (v.val (Sum.inl PUnit.unit))) =
            ((relCurve C R).presheaf.germ
              (W ⊓ (thetaChartDatum C R π a).pieces (Sum.inl PUnit.unit)) z
              ⟨hz.1, (thetaChartCover_pieces_inl C R π PUnit.unit).ge hz.2⟩).hom
                (v.val (Sum.inl PUnit.unit)) :=
        TopCat.Presheaf.germ_res_apply _ _ _ _ _
      change ((relCurve C R).presheaf.germ
        (W ⊓ (relCover C R (fiberTwoCover π)).V₀) z hz).hom
          ((relCurve C R).resHom
            (inf_le_inf_left W (thetaChartCover_pieces_inl C R π PUnit.unit).ge)
            (v.val (Sum.inl PUnit.unit))) ∈ d.stalkIdeal z
      rw [hswap]
      exact h (Sum.inl PUnit.unit) z
        ⟨hz.1, (thetaChartCover_pieces_inl C R π PUnit.unit).ge hz.2⟩
    · intro z hz
      have hswap :
          ((relCurve C R).presheaf.germ
            (W ⊓ (relCover C R (fiberTwoCover π)).V₁) z hz).hom
              ((relCurve C R).resHom
                (inf_le_inf_left W
                  (thetaChartCover_pieces_inr C R π PUnit.unit).ge)
                (v.val (Sum.inr PUnit.unit))) =
            ((relCurve C R).presheaf.germ
              (W ⊓ (thetaChartDatum C R π a).pieces (Sum.inr PUnit.unit)) z
              ⟨hz.1, (thetaChartCover_pieces_inr C R π PUnit.unit).ge hz.2⟩).hom
                (v.val (Sum.inr PUnit.unit)) :=
        TopCat.Presheaf.germ_res_apply _ _ _ _ _
      change ((relCurve C R).presheaf.germ
        (W ⊓ (relCover C R (fiberTwoCover π)).V₁) z hz).hom
          ((relCurve C R).resHom
            (inf_le_inf_left W (thetaChartCover_pieces_inr C R π PUnit.unit).ge)
            (v.val (Sum.inr PUnit.unit))) ∈ d.stalkIdeal z
      rw [hswap]
      exact h (Sum.inr PUnit.unit) z
        ⟨hz.1, (thetaChartCover_pieces_inr C R π PUnit.unit).ge hz.2⟩
  exact DivisorAdaptation.cokernelπ_app_eq_zero_of_germ_mem C R π B
    (gluedTwistEquiv C R π a W v) hx.1 hx.2

/-- Once the widened certificate supplies the auxiliary theta-ideal `H¹` vanishing,
global sections of the quotient sheaf for the chosen auxiliary chart are linearly equivalent
to the actual range of the intrinsic widened theta evaluation. -/
noncomputable def IsCertified.thetaIdealCokernelEquivIntrinsicRange
    {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}
    {A : AffAdaptation D d} {g : ℕ} (hc : A.IsCertified g)
    (hπ : π ≫ P1.structureMap k = C.hom)
    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    {a : ℕ} (ha1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1)
    (hMa : windowM_choice π hπ g ≤ a) :
    let B := Classical.choose
      (hc.exists_chartAdaptation_subsingleton_thetaIdealH1 C R π hπ hO hχ ha1 hMa)
    (cokernel (DivisorAdaptation.thetaIdealIncl (A := B) (a := a))).obj.obj
        (op (⊤ : (relCurve C R).Opens)) ≃ₗ[R]
      ↥(LinearMap.range (A.intrinsicThetaEvalRel (π := π) a)) := by
  let hB := Classical.choose_spec
    (hc.exists_chartAdaptation_subsingleton_thetaIdealH1 C R π hπ hO hχ ha1 hMa)
  let B := Classical.choose
    (hc.exists_chartAdaptation_subsingleton_thetaIdealH1 C R π hπ hO hχ ha1 hMa)
  letI : Subsingleton (Sheaf.HModule (B.thetaIdealDatum a).sheaf 1) := hB
  have hrange :
      LinearMap.range
          ((DivisorAdaptation.thetaIdealIncl (A := B) (a := a)).hom.app
            (op (⊤ : (relCurve C R).Opens))).hom =
        d.vanishingSubmodule R (relCover C R (fiberTwoCover π)).V₀
          (relCover C R (fiberTwoCover π)).V₁ (relThetaCocycle C R π a) := by
    rw [DivisorAdaptation.thetaIdealIncl_app]
    change LinearMap.range (B.thetaIdealInclApp (a := a) ⊤) = _
    exact DivisorAdaptation.range_thetaIdealInclApp_top C R π B a
  exact (Sheaf.cokernelAppEquivQuotientRange
      (DivisorAdaptation.thetaIdealIncl (A := B) (a := a))
      (op (⊤ : (relCurve C R).Opens)) B.thetaIdealCokernel_app_top_surjective).trans
    ((Submodule.quotEquivOfEq _ _ hrange).trans
      (A.intrinsicThetaQuotEquivRange (π := π) a))

/-- The global theta quotient maps injectively into the widened intrinsic descent module.
The remaining representability seam is exactly the assertion that this map is surjective. -/
noncomputable def IsCertified.thetaIdealCokernelToIntrinsic
    {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}
    {A : AffAdaptation D d} {g : ℕ} (hc : A.IsCertified g)
    (hπ : π ≫ P1.structureMap k = C.hom)
    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    {a : ℕ} (ha1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1)
    (hMa : windowM_choice π hπ g ≤ a) :
    let B := Classical.choose
      (hc.exists_chartAdaptation_subsingleton_thetaIdealH1 C R π hπ hO hχ ha1 hMa)
    (cokernel (DivisorAdaptation.thetaIdealIncl (A := B) (a := a))).obj.obj
        (op (⊤ : (relCurve C R).Opens)) →ₗ[R]
      A.IntrinsicThetaGlued (π := π) a :=
  (Submodule.subtype (LinearMap.range (A.intrinsicThetaEvalRel (π := π) a))).comp
    (hc.thetaIdealCokernelEquivIntrinsicRange C R π hπ hO hχ ha1 hMa).toLinearMap

/-- The cokernel embedding carries the quotient projection of a theta section to its
intrinsic evaluation. -/
theorem IsCertified.thetaIdealCokernelToIntrinsic_apply_cokernelπ
    {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}
    {A : AffAdaptation D d} {g : ℕ} (hc : A.IsCertified g)
    (hπ : π ≫ P1.structureMap k = C.hom)
    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    {a : ℕ} (ha1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1)
    (hMa : windowM_choice π hπ g ≤ a) (x : relThetaSections C R π a) :
    let B := Classical.choose
      (hc.exists_chartAdaptation_subsingleton_thetaIdealH1 C R π hπ hO hχ ha1 hMa)
    hc.thetaIdealCokernelToIntrinsic C R π hπ hO hχ ha1 hMa
        (((cokernel.π (DivisorAdaptation.thetaIdealIncl (A := B) (a := a))).hom.app
          (op (⊤ : (relCurve C R).Opens))).hom x) =
      A.intrinsicThetaEvalRel (π := π) a x := by
  let B := Classical.choose
    (hc.exists_chartAdaptation_subsingleton_thetaIdealH1 C R π hπ hO hχ ha1 hMa)
  change ((hc.thetaIdealCokernelEquivIntrinsicRange C R π hπ hO hχ ha1 hMa)
    (((cokernel.π (DivisorAdaptation.thetaIdealIncl (A := B) (a := a))).hom.app
      (op (⊤ : (relCurve C R).Opens))).hom x) :
        A.IntrinsicThetaGlued (π := π) a) = _
  apply Subtype.ext
  simp only [IsCertified.thetaIdealCokernelEquivIntrinsicRange,
    Sheaf.cokernelAppEquivQuotientRange,
    LinearEquiv.trans_apply, LinearMap.quotKerEquivOfSurjective_symm_apply,
    Submodule.quotEquivOfEq_mk]
  -- One coercion layer more than the source lemma states: the goal sits under the
  -- `IntrinsicThetaGlued` subtype as well as the range subtype, so `congrArg` supplies the
  -- outer `↑`.  (Repaired by pic-g to unbreak the root build; `exact` alone was left by an
  -- edit whose targeted module check could not see this file — the mismatch only appears
  -- when the root imports it.  Author: see `Archon-Task: pic-d` on the introducing commit.)
  exact congrArg _ (A.intrinsicThetaQuotEquivRange_mk (π := π) a x)

/-- The global theta-quotient embedding has precisely the image of intrinsic theta
evaluation as its range. -/
theorem IsCertified.range_thetaIdealCokernelToIntrinsic
    {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}
    {A : AffAdaptation D d} {g : ℕ} (hc : A.IsCertified g)
    (hπ : π ≫ P1.structureMap k = C.hom)
    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    {a : ℕ} (ha1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1)
    (hMa : windowM_choice π hπ g ≤ a) :
    LinearMap.range
        (hc.thetaIdealCokernelToIntrinsic C R π hπ hO hχ ha1 hMa) =
      LinearMap.range (A.intrinsicThetaEvalRel (π := π) a) := by
  let e := hc.thetaIdealCokernelEquivIntrinsicRange C R π hπ hO hχ ha1 hMa
  change LinearMap.range ((Submodule.subtype _).comp e.toLinearMap) = _
  ext y
  constructor
  · rintro ⟨q, rfl⟩
    exact (e q).property
  · intro hy
    refine ⟨e.symm ⟨y, hy⟩, ?_⟩
    exact congrArg Subtype.val (e.apply_symm_apply ⟨y, hy⟩)

/-- The global theta-quotient map is an embedding. -/
theorem IsCertified.thetaIdealCokernelToIntrinsic_injective
    {D : AffCoverData C R} {d : (relCurve C R).LocalEquations}
    {A : AffAdaptation D d} {g : ℕ} (hc : A.IsCertified g)
    (hπ : π ≫ P1.structureMap k = C.hom)
    (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    {a : ℕ} (ha1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1)
    (hMa : windowM_choice π hπ g ≤ a) :
    Function.Injective
      (hc.thetaIdealCokernelToIntrinsic C R π hπ hO hχ ha1 hMa) := by
  let e := hc.thetaIdealCokernelEquivIntrinsicRange C R π hπ hO hχ ha1 hMa
  change Function.Injective ((Submodule.subtype _).comp e.toLinearMap)
  exact (LinearMap.range (A.intrinsicThetaEvalRel (π := π) a)).injective_subtype.comp
    e.injective

end AffAdaptation

end CokernelGlobal

end AlgebraicGeometry
