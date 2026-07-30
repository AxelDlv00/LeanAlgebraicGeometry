import AlgebraicJacobian.RiemannRoch.GenusZeroDegreeTrivial
import AlgebraicJacobian.Cohomology.H1BaseFieldInvariance
import AlgebraicJacobian.RiemannRoch.RelPicDegree

set_option autoImplicit false
set_option maxHeartbeats 1600000
universe u
open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

/-- relPicDeg is injective-at-1 over any field extension, at genus 0. -/
example (K : Type u) [Field K] [Algebra k K] (hg : genus C = 0)
    (y : relPic C (overSpec k K)) (hy : relPicDeg (C := C) K y = 0) : y = 1 := by
  haveI : IsProper (baseChangeBundle C K).hom := instIsProperSndLeft C K
  haveI : SmoothOfRelativeDimension 1 (baseChangeBundle C K).hom :=
    instSmoothOfRelativeDimensionSndLeft C K
  haveI : GeometricallyIrreducible (baseChangeBundle C K).hom :=
    instGeometricallyIrreducibleSndLeft C K
  letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
  have hchi : Sheaf.chi ((C ⊗ overSpec k K).left.moduleKSheaf K) = 1 := by
    have hh1 : Sheaf.h1 ((C ⊗ overSpec k K).left.moduleKSheaf K) = genus C :=
      finrank_h1_baseField_eq_genus C K
    have hh0 : Sheaf.h0 ((C ⊗ overSpec k K).left.moduleKSheaf K)
        = Sheaf.h0 (C.left.moduleKSheaf k) := finrank_h0_baseField C K
    have hbase : Sheaf.h0 (C.left.moduleKSheaf k) = 1 := h0_moduleKSheaf C
    rw [Sheaf.chi, hh0, hbase, hh1, hg]
    norm_num
  induction y using relPic.ind with
  | mk L =>
    have hcl : classDeg K L = 0 := hy
    have hL1 : L = 1 := eq_one_of_classDeg_eq_zero_of_chi_one K hchi L hcl
    rw [hL1, map_one]

/-- Push to degAff: a plus class of degree zero over a field is trivial, at genus 0. -/
example (K : Type u) [Field K] [Algebra k K] (hg : genus C = 0)
    (hrel : ∀ (L : Type u) (_ : Field L) (_ : Algebra k L)
      (y : relPic C (overSpec k L)), relPicDeg (C := C) L y = 0 → y = 1)
    (q : PicEtAff C K) (hq : PicEtAff.degAff (C := C) K q = 0) : q = 1 := by
  induction q using PicEtAff.ind with
  | mk E x =>
    sorry

end AlgebraicGeometry
