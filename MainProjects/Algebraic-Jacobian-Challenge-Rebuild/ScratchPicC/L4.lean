import AlgebraicJacobian.RiemannRoch.GenusZeroDegreeTrivial
import AlgebraicJacobian.RiemannRoch.RelPicDegree

set_option autoImplicit false
universe u
open CategoryTheory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))

/-- Lift to relPic: degree zero + chi one forces triviality of the relative class. -/
example (K : Type u) [Field K] [Algebra k K]
    [SmoothOfRelativeDimension 1 ((C ⊗ overSpec k K).left ↘ Spec (CommRingCat.of K))]
    [IsIntegral (C ⊗ overSpec k K).left]
    [QuasiCompact ((C ⊗ overSpec k K).left ↘ Spec (CommRingCat.of K))]
    [LocallyOfFiniteType ((C ⊗ overSpec k K).left ↘ Spec (CommRingCat.of K))]
    [Module.Finite K (Sheaf.HModule ((C ⊗ overSpec k K).left.moduleKSheaf K) 0)]
    [Module.Finite K (Sheaf.HModule ((C ⊗ overSpec k K).left.moduleKSheaf K) 1)]
    (hchi : Sheaf.chi ((C ⊗ overSpec k K).left.moduleKSheaf K) = 1)
    (y : relPic C (overSpec k K)) (hy : relPicDeg C K y = 0) : y = 1 := by
  induction y using relPic.ind with
  | mk L =>
    have hcl : classDeg K L = 0 := hy
    have : L = 1 := eq_one_of_classDeg_eq_zero_of_chi_one K hchi L hcl
    rw [this, map_one]

end AlgebraicGeometry
