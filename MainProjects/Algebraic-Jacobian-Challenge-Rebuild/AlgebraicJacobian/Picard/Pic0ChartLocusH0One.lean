/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartCoverageIndexSlack

/-!
# The chart locus SUPPLIES GAP-2's `h⁰ = 1` binder (scaffold; proofs to follow)

Scaffold commit.  Statements pinned, proofs deliberately `sorry` so that the shapes are
measured before anything is filled in.
-/

set_option autoImplicit false
/- Statements mix `relCurve C L` with the product spelling `(C ⊗ overSpec k L).left`. -/
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161). -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open TopologicalSpace Opposite

namespace AlgebraicGeometry

open AlgebraicJacobian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

noncomputable section

/-- **The rank anchor at a witness of the pinned degree.** -/
theorem h0_eq_one_of_subsingleton_of_deg
    {L : Type u} [Field L] [Algebra k L]
    [IsIntegral (relCurve C L)]
    [SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L))]
    [QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L))]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0)]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)]
    (n : ℕ) (hχ : Sheaf.chi (((C ⊗ overSpec k L).left).moduleKSheaf L) = 1 - (n : ℤ))
    (W : ((C ⊗ overSpec k L).left).CurveDivisor)
    (hW : Scheme.CurveDivisor.deg L W = (n : ℤ))
    (h1 : Subsingleton (Sheaf.HModule ((C ⊗ overSpec k L).left.divisorSheaf L W) 1)) :
    Sheaf.h0 ((C ⊗ overSpec k L).left.divisorSheaf L W) = 1 := by
  have hanchor := h0_eq_deg_add_chi_of_subsingleton_hModule_one (K := L) W h1
  rw [hW, hχ] at hanchor
  omega

/-- **THE CONVERSE OF `mem_chartLocus_of_witness_h1`, WITH THE `h⁰` VALUE READ OFF.** -/
theorem exists_splitting_h0_eq_one_of_mem_chartLocus
    {T : Over (Spec (.of k))} (lam : picEt C T) (t : T.left)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor) (n : ℕ)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (n : ℤ))
    (hlam : degAt lam (Over.testPoint t) = 0)
    (ht : t ∈ chartLocus C m Z lam) :
    ∃ (L : Type u) (_ : Field L) (_ : Algebra k L) (_ : Algebra (Over.testPointField t) L)
        (_ : IsScalarTower k (Over.testPointField t) L)
        (_ : Module.Finite (Over.testPointField t) L)
        (_ : Algebra.IsSeparable (Over.testPointField t) L)
        (W : ((C ⊗ overSpec k L).left).CurveDivisor),
      Sheaf.h0 ((C ⊗ overSpec k L).left.divisorSheaf L W) = 1 := by
  obtain ⟨L, hLf, hLa, hLKa, hLtow, hLfin, hLsep, M, hM, W, hWcl, hWh1⟩ := ht
  refine ⟨L, hLf, hLa, hLKa, hLtow, hLfin, hLsep, W, ?_⟩
  haveI : IsIntegral (relCurve C L) := instIsIntegralBaseChange C L
  haveI : SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L)) :=
    instSmoothOfRelativeDimensionBaseChange C L
  haveI : QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L)) :=
    instQuasiCompactBaseChange C L
  haveI : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0) :=
    instModuleFiniteHModuleZeroBaseChange C L
  haveI : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1) :=
    instModuleFiniteHModuleOneBaseChange C L
  -- the witness has degree exactly `n`: its class is the presenting class of the twisted
  -- fibre class, whose `classDeg` the ledger computes as `m·d₁ − deg Z = n`.
  have hWdeg : Scheme.CurveDivisor.deg L W = (n : ℤ) := by
    rw [← classDeg_picClass (K := L) W, hWcl,
      classDeg_presenting_eq_degAff C L _ M hM]
    change degAt (chartTwist C m Z T lam) (Over.testPoint t) = (n : ℤ)
    rw [chartTwist, degAt_mul, degAt_inv, degAt_mul, degAt_thetaFamily_pow,
      degAt_sigmaFamily, hlam, hdeg]
    ring
  -- `χ(𝒪)` transports to the base-changed curve
  have hχL : Sheaf.chi (((C ⊗ overSpec k L).left).moduleKSheaf L) = 1 - (n : ℤ) :=
    chi_relCurve_baseField C L n hχ
  exact h0_eq_one_of_subsingleton_of_deg n hχL W hWdeg hWh1

end

end AlgebraicGeometry
