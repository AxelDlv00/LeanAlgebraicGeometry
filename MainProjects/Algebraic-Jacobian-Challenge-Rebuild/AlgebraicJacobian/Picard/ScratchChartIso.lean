import AlgebraicJacobian.Picard.Pic0ChartCoverageNoDrop
import AlgebraicJacobian.Picard.Pic0ChartCoverageDegreeStep2

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
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

/-- PROBE 3: the CHART-INDEX DEGREE IS FREE OF `n` in the following sense: for ANY target
degree `d ≥ 0` there is a legal chart index constraint at parameter `n := d.toNat` whose
twisted ledger reads exactly `d`.  So `b = n` does NOT force `b = g`; it forces the chart
PARAMETER to equal the threshold.  Vacuously easy as an equation — the content is that
`chartValueTrans` accepts every `n`. -/
theorem probe_chart_param_free (m : ℕ) (d : ℕ)
    (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hZ : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (d : ℤ)) :
    Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - ((d : ℕ) : ℤ) := hZ

/-- PROBE 4 — THE POINT.  Does `hb` at `b = n` really demand RR-sharp vanishing?
The reviewer says: at `b = g`, `hb` asks every divisor of degree `≥ g` to have `H¹ = 0`,
strictly stronger than any threshold theorem.  TEST: derive a contradiction from `hb`
at `b = g` together with the χ-ledger, on a curve of genus `g ≥ 1`.

If `hb` at `b = g` is refutable, coverage through `mem_chartLocus_of_vanishing_bound` is
UNSATISFIABLE at a legal index and the reviewer's repair is mandatory.
If it is not refutable, `hb` is merely UNPROVED at `b = g`, which is a different status. -/
theorem probe_hb_at_g_forces_h0
    {L : Type u} [Field L] [Algebra k L]
    [IsIntegral (relCurve C L)]
    [SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L))]
    [QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L))]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0)]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)]
    (g : ℕ) (hχ : Sheaf.chi (((C ⊗ overSpec k L).left).moduleKSheaf L) = 1 - (g : ℤ))
    (hb : ∀ D : ((C ⊗ overSpec k L).left).CurveDivisor,
      (g : ℤ) ≤ Scheme.CurveDivisor.deg L D →
        Subsingleton (Sheaf.HModule ((C ⊗ overSpec k L).left.divisorSheaf L D) 1))
    (D : ((C ⊗ overSpec k L).left).CurveDivisor)
    (hD : Scheme.CurveDivisor.deg L D = (g : ℤ)) :
    (Sheaf.h0 ((C ⊗ overSpec k L).left.divisorSheaf L D) : ℤ) = 1 := by
  have h1 := hb D (le_of_eq hD.symm)
  have hanchor := h0_eq_deg_add_chi_of_subsingleton_hModule_one (K := L) D h1
  rw [hD, hχ] at hanchor
  omega

end

end AlgebraicGeometry
