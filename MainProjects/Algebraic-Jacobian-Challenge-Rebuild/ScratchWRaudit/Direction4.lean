import AlgebraicJacobian.Cohomology.Finiteness
import AlgebraicJacobian.Curve.P1H1Vanishing

open AlgebraicGeometry CategoryTheory
universe u

set_option synthInstance.maxHeartbeats 800000 in
-- Take genus (asOver k) = 0 as a BLACK BOX hypothesis and recover the Subsingleton
-- at the exact carrier `P1.subsingleton_hModule_one` states.
theorem wr_p1_back {k : Type u} [Field k] (h : genus (P1.asOver k) = 0) :
    Subsingleton (Sheaf.HModule ((P1 k).moduleKSheaf k) 1) := by
  rw [genus] at h
  exact (Module.finrank_zero_iff (R := k)).mp h

#print axioms wr_p1_back
