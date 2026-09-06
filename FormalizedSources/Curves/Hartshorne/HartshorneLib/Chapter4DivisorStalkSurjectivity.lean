/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DivisorFiberBridge
import HartshorneLib.Chapter4JumpDimension

/-!
# The divisor-module stalk and its ordinary fiber jump

Every element of the intrinsic point lattice is represented by a bounded
divisor section on a neighborhood of the point.  Consequently the divisor
module stalk maps onto the local jump quotient, and the additive jump map
descends onto the ordinary fiber.

The reverse kernel inclusion is proved using the chosen uniformizer from
`Chapter4JumpDimension`.  The exported kernel and bijectivity statements are
invariant: they do not expose a uniformizer coordinate.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

attribute [local instance] functionFieldOverModule Scheme.overModule
attribute [local instance] Scheme.Modules.stalkModule

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

/-! ## Stalk image -/

lemma stalkValPointLattice_surjective {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) :
    Function.Surjective (stalkValPointLattice (X := X) hx D) := by
  intro g
  by_cases hg0 : (g : X.left.functionField) = 0
  · refine ⟨0, ?_⟩
    apply Subtype.ext
    change stalkVal D x (0 : Scheme.Modules.Stalk (divisorModule D) x) =
      (g : X.left.functionField)
    rw [map_zero, hg0]
  · let r : X.left.functionField := (g : X.left.functionField)
    let gu : X.left.functionFieldˣ := Units.mk0 r hg0
    have hgu : (gu : X.left.functionField) = r := rfl
    let Bad : Set X.left := {z | ∃ (hz : z ≠ genericPoint X.left),
      ¬ (orderAt X.hom hz r ≤ divisorBound D hz)}
    have hBadFinite : Bad.Finite := by
      apply Set.Finite.subset
        ((orderZAt_support_finite X.hom gu).image Subtype.val |>.union
          ((show PointDivisor X.left from D).support.finite_toSet.image Subtype.val))
      intro z hz
      obtain ⟨hzne, hzbad⟩ := hz
      by_contra houtside
      simp only [Set.mem_union, not_or] at houtside
      obtain ⟨horderSupport, hdivisorSupport⟩ := houtside
      have horderZ : orderZAt X.hom hzne gu = 1 := by
        by_contra hne
        exact horderSupport ⟨⟨z, hzne⟩, hne, rfl⟩
      have hcoeff : (show PointDivisor X.left from D).toFun ⟨z, hzne⟩ = 0 := by
        by_contra hne
        exact hdivisorSupport
          ⟨⟨z, hzne⟩, Finsupp.mem_support_iff.mpr hne, rfl⟩
      have hcoeffAt : CurveDivisor.coeffAt hzne D = 0 := by
        change (show PointDivisor X.left from D).toFun ⟨z, hzne⟩ = 0
        exact hcoeff
      apply hzbad
      have horder : orderAt X.hom hzne r = 1 := by
        rw [← hgu, ← orderZAt_eq_one_iff]
        exact horderZ
      rw [divisorBound_eq_coeffAt, horder, hcoeffAt]
      simp
    have hBadClosed : IsClosed Bad := by
      rw [← Set.biUnion_of_singleton Bad]
      exact hBadFinite.isClosed_biUnion
        (fun z hz => smoothCurve_isClosed_singleton_of_ne_genericPoint X.hom hz.choose)
    let W : X.left.Opens := ⟨Badᶜ, hBadClosed.isOpen_compl⟩
    have hgBound : orderAt X.hom hx r ≤ divisorBound D hx := by
      rw [divisorBound_eq_coeffAt]
      exact (mem_pointLattice (X := X) hx).mp g.property
    have hxBad : x ∉ Bad := by
      rintro ⟨_, hbad⟩
      exact hbad hgBound
    have hxW : x ∈ W := hxBad
    have hWne : (W : Set X.left).Nonempty := ⟨x, hxW⟩
    have hrmem : r ∈ divisorSections D W := by
      rw [mem_divisorSections_of_nonempty hWne]
      intro z hz hzW
      by_contra h
      exact hzW ⟨hz, h⟩
    let s : (divisorModule D).val.presheaf.obj (op W) := ⟨r, hrmem⟩
    refine ⟨ConcreteCategory.hom
      (TopCat.Presheaf.germ (divisorModule D).val.presheaf W x hxW) s, ?_⟩
    apply Subtype.ext
    change stalkVal D x
      (ConcreteCategory.hom
        (TopCat.Presheaf.germ (divisorModule D).val.presheaf W x hxW) s) = r
    rw [stalkVal_germ D x W hxW s]

/-! ## The intrinsic jump -/

lemma stalkJump_surjective {x : X.left} (hx : x ≠ genericPoint X.left)
    (D : CurveDivisor k X) :
    Function.Surjective (stalkJump (X := X) hx D) := by
  intro q
  let P := (pointLattice (X := X) hx (CurveDivisor.coeffAt hx D - 1)).submoduleOf
    (pointLattice (X := X) hx (CurveDivisor.coeffAt hx D))
  obtain ⟨g, hg⟩ := Submodule.Quotient.mk_surjective P q
  obtain ⟨m, hm⟩ := stalkValPointLattice_surjective (X := X) hx D g
  refine ⟨m, ?_⟩
  change Submodule.Quotient.mk (stalkValPointLattice hx D m) = q
  rw [hm, hg]

/-! ## The exact stalk kernel -/

private lemma mem_divisorStalkMaximalAction_of_stalkVal_mem_lower_lattice
    {x : X.left} (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (m : Scheme.Modules.Stalk (divisorModule D) x)
    (hm : stalkVal D x m ∈
      pointLattice (X := X) hx (CurveDivisor.coeffAt hx D - 1)) :
    m ∈ divisorStalkMaximalAction (X := X) D := by
  have hpiLattice :
      uniformizer (X := X) hx ∈ pointLattice (X := X) hx 0 := by
    rw [mem_pointLattice, orderAt_uniformizer, WithZero.coe_le_coe,
      Multiplicative.ofAdd_le]
    omega
  let piLattice : pointLattice (X := X) hx 0 :=
    ⟨uniformizer (X := X) hx, hpiLattice⟩
  let pi : X.left.presheaf.stalk x := preimageStalk (X := X) hx piLattice
  have hpiMap :
      algebraMap (X.left.presheaf.stalk x) X.left.functionField pi =
        uniformizer (X := X) hx :=
    algebraMap_preimageStalk (X := X) hx piLattice
  have hpiMax :
      pi ∈ IsLocalRing.maximalIdeal (X.left.presheaf.stalk x) := by
    letI := smoothCurve_stalk_isDiscreteValuationRing X.hom hx
    letI := smoothCurve_stalk_isDedekindDomain X.hom hx
    let v0 : IsDedekindDomain.HeightOneSpectrum (X.left.presheaf.stalk x) :=
      stalkHeightOne X.left x
    have hord : orderAt X.hom hx = v0.valuation X.left.functionField := rfl
    exact (IsDedekindDomain.HeightOneSpectrum.valuation_lt_one_iff_mem v0 pi).mp (by
      rw [← hord]
      change orderAt X.hom hx
        (algebraMap (X.left.presheaf.stalk x) X.left.functionField pi) < 1
      rw [hpiMap, orderAt_uniformizer, ← WithZero.coe_one,
        WithZero.coe_lt_coe, ← ofAdd_zero, Multiplicative.ofAdd_lt]
      omega)
  let g : pointLattice (X := X) hx (CurveDivisor.coeffAt hx D) :=
    ⟨uniformizer (X := X) hx ^ (-1 : ℤ) * stalkVal D x m, by
      rw [mem_pointLattice_uniformizer_zpow_mul]
      simpa [sub_eq_add_neg] using hm⟩
  obtain ⟨m0, hm0⟩ := stalkValPointLattice_surjective (X := X) hx D g
  have hm0val : stalkVal D x m0 = (g : X.left.functionField) :=
    congrArg Subtype.val hm0
  have hval : stalkVal D x (pi • m0) = stalkVal D x m := by
    have hlin := (stalkValLinearMap (X := X) D x).map_smul pi m0
    change stalkVal D x (pi • m0) = pi • stalkVal D x m0 at hlin
    rw [hlin]
    change algebraMap (X.left.presheaf.stalk x) X.left.functionField pi *
      stalkVal D x m0 = stalkVal D x m
    rw [hpiMap, hm0val]
    change uniformizer (X := X) hx *
      (uniformizer (X := X) hx ^ (-1 : ℤ) * stalkVal D x m) =
        stalkVal D x m
    rw [zpow_neg_one, ← mul_assoc, mul_inv_cancel₀ (uniformizer_ne_zero hx), one_mul]
  have hmmul : m = pi • m0 :=
    stalkVal_injective D x hval.symm
  rw [hmmul]
  exact Submodule.smul_mem_smul hpiMax (by simp)

/-- A divisor-stalk germ belongs to the maximal-ideal action exactly when its
rational value belongs to the lower point lattice.  Although the reverse
implication is proved using a chosen uniformizer, this membership criterion is
choice-independent. -/
lemma mem_divisorStalkMaximalAction_iff_stalkVal_mem_lower_lattice
    {x : X.left} (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (m : Scheme.Modules.Stalk (divisorModule D) x) :
    m ∈ divisorStalkMaximalAction (X := X) D ↔
      stalkVal D x m ∈
        pointLattice (X := X) hx (CurveDivisor.coeffAt hx D - 1) := by
  constructor
  · intro hm
    exact (stalkJump_eq_zero_iff_mem_lower_lattice hx D m).mp
      (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D m hm)
  · exact mem_divisorStalkMaximalAction_of_stalkVal_mem_lower_lattice hx D m

/-- The kernel of the stalk jump is exactly the maximal-ideal action. -/
lemma stalkJump_ker_eq_divisorStalkMaximalAction
    {x : X.left} (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X) :
    (stalkJump hx D).ker =
      (divisorStalkMaximalAction (X := X) (x := x) D).toAddSubgroup := by
  ext m
  rw [AddMonoidHom.mem_ker]
  exact (stalkJump_eq_zero_iff_mem_lower_lattice hx D m).trans
    (mem_divisorStalkMaximalAction_iff_stalkVal_mem_lower_lattice hx D m).symm

/-! ## The ordinary fiber -/

noncomputable def stalkJumpFiberAddHom_of_divisorModule {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X) :
    Scheme.Modules.stalkFiber (divisorModule D) x →+ jumpModule hx D :=
  stalkJumpFiberAddHom hx D (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D)

@[simp]
lemma stalkJumpFiberAddHom_of_divisorModule_one_tmul {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (m : Scheme.Modules.Stalk (divisorModule D) x) :
    stalkJumpFiberAddHom_of_divisorModule (X := X) hx D
        (1 ⊗ₜ[X.left.presheaf.stalk x] m) = stalkJump hx D m := by
  exact stalkJumpFiberAddHom_one_tmul hx D
    (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D) m

lemma stalkJumpFiberAddHom_of_divisorModule_fiberEvaluation {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (s : Γ(divisorModule D, (⊤ : X.left.Opens))) :
    stalkJumpFiberAddHom_of_divisorModule (X := X) hx D
        (Scheme.Modules.fiberEvaluation (divisorModule D) x s) =
      stalkJump hx D
        (ConcreteCategory.hom
          (TopCat.Presheaf.germ (divisorModule D).val.presheaf
            (⊤ : X.left.Opens) x trivial) s) := by
  exact stalkJumpFiberAddHom_fiberEvaluation hx D
    (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D) s

lemma stalkJumpFiberAddHom_of_divisorModule_surjective {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X) :
    Function.Surjective (stalkJumpFiberAddHom_of_divisorModule (X := X) hx D) := by
  intro q
  obtain ⟨m, hm⟩ := stalkJump_surjective (X := X) hx D q
  refine ⟨divisorStalkFiberClass (X := X) D m, ?_⟩
  change stalkJumpFiberAddHom hx D
      (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D)
      (divisorStalkFiberClass (X := X) D m) = q
  calc
    stalkJumpFiberAddHom hx D
        (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D)
        (divisorStalkFiberClass (X := X) D m) = stalkJump hx D m := by
      exact congrArg (fun f => f m)
        (stalkJumpFiberAddHom_comp_divisorStalkFiberClass (X := X) hx D
          (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D))
    _ = q := hm

/-- The intrinsic additive map from the ordinary divisor-module fiber to the
local jump quotient is injective. -/
lemma stalkJumpFiberAddHom_of_divisorModule_injective {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X) :
    Function.Injective (stalkJumpFiberAddHom_of_divisorModule (X := X) hx D) := by
  let e := Scheme.Modules.stalkFiberEquivQuotient (divisorModule D) x
  let P := divisorStalkMaximalAction (X := X) (x := x) D
  intro a b hab
  apply sub_eq_zero.mp
  have hz :
      stalkJumpFiberAddHom_of_divisorModule (X := X) hx D (a - b) = 0 := by
    rw [map_sub, hab, sub_self]
  obtain ⟨m, hm⟩ := Submodule.Quotient.mk_surjective P (e (a - b))
  have hclass : divisorStalkFiberClass (X := X) D m = a - b := by
    apply e.injective
    change e (e.symm (P.mkQ m)) = e (a - b)
    rw [e.apply_symm_apply]
    exact hm
  have hfac :
      stalkJumpFiberAddHom_of_divisorModule (X := X) hx D
          (divisorStalkFiberClass (X := X) D m) =
        stalkJump hx D m := by
    exact congrArg (fun q => q m)
      (stalkJumpFiberAddHom_comp_divisorStalkFiberClass (X := X) hx D
        (stalkJump_zero_of_mem_divisorStalkMaximalAction hx D))
  have hjump : stalkJump hx D m = 0 := by
    rw [← hfac, hclass]
    exact hz
  have hmLower :
      stalkVal D x m ∈
        pointLattice (X := X) hx (CurveDivisor.coeffAt hx D - 1) :=
    (stalkJump_eq_zero_iff_mem_lower_lattice hx D m).mp hjump
  have hmP : m ∈ P :=
    (mem_divisorStalkMaximalAction_iff_stalkVal_mem_lower_lattice hx D m).mpr hmLower
  have hmk : P.mkQ m = 0 :=
    (Submodule.Quotient.mk_eq_zero P).mpr hmP
  have heq : e (a - b) = 0 := by
    rw [← hm]
    exact hmk
  exact e.injective (heq.trans (map_zero e).symm)

/-- The intrinsic additive map from the ordinary divisor-module fiber to the
local jump quotient is bijective. -/
lemma stalkJumpFiberAddHom_of_divisorModule_bijective {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X) :
    Function.Bijective (stalkJumpFiberAddHom_of_divisorModule (X := X) hx D) :=
  ⟨stalkJumpFiberAddHom_of_divisorModule_injective hx D,
    stalkJumpFiberAddHom_of_divisorModule_surjective hx D⟩

/-- Package the intrinsic, bijective forward map as an additive equivalence
between the ordinary divisor-module fiber and the local jump quotient.  The
inverse is choice-selected by `AddEquiv.ofBijective`; no canonical inverse
formula or coordinate is claimed.  The bijectivity proof also uses a chosen
uniformizer only to establish the invariant kernel equality. -/
noncomputable def stalkFiberAddEquivJump {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X) :
    Scheme.Modules.stalkFiber (divisorModule D) x ≃+ jumpModule hx D :=
  AddEquiv.ofBijective (stalkJumpFiberAddHom_of_divisorModule (X := X) hx D)
    (stalkJumpFiberAddHom_of_divisorModule_bijective hx D)

@[simp]
lemma stalkFiberAddEquivJump_apply {x : X.left}
    (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (z : Scheme.Modules.stalkFiber (divisorModule D) x) :
    stalkFiberAddEquivJump hx D z =
      stalkJumpFiberAddHom_of_divisorModule (X := X) hx D z :=
  rfl

end
end Hartshorne
