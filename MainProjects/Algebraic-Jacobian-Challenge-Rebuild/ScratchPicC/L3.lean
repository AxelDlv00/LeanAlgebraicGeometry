import AlgebraicJacobian.RiemannRoch.SectionBound
import AlgebraicJacobian.RiemannRoch.ChiLedger
import AlgebraicJacobian.RiemannRoch.SectionSpaces
import AlgebraicJacobian.Picard.DivisorClassMeromorphic

set_option autoImplicit false
universe u
open CategoryTheory

namespace AlgebraicGeometry

variable (K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
  [QuasiCompact (X ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (X ↘ Spec (CommRingCat.of K))]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)]

/-- CLAIM: chi = 1 and classDeg = 0 forces the class to be trivial. -/
example (hchi : Sheaf.chi (X.moduleKSheaf K) = 1)
    (L : X.CechPic) (hL : classDeg K L = 0) : L = 1 := by
  obtain ⟨D, hD⟩ := Scheme.CurveDivisor.exists_picClass_eq K L
  have hdegD : Scheme.CurveDivisor.deg K D = 0 := by
    rw [← classDeg_picClass K D, hD, hL]
  have hchiD : Sheaf.chi (X.divisorSheaf K D) = 1 := by
    rw [chi_divisorSheaf, hchi, hdegD, add_zero]
  have hh0 : 0 < Sheaf.h0 (X.divisorSheaf K D) := by
    have h := hchiD
    rw [Sheaf.chi] at h
    omega
  obtain ⟨E, hEeff, hEcl⟩ := exists_effective_of_h0_pos K D hh0
  have hdegE : Scheme.CurveDivisor.deg K E = 0 := by
    rw [deg_eq_deg_of_picClass_eq K hEcl, hdegD]
  have hE0 : E = 0 := Scheme.CurveDivisor.eq_zero_of_deg_le_zero K hEeff (le_of_eq hdegE)
  rw [← hD, ← hEcl, hE0]
  exact Scheme.CurveDivisor.picClass_zero K

end AlgebraicGeometry
