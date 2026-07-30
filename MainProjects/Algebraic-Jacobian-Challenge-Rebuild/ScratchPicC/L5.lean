import AlgebraicJacobian.RiemannRoch.GenusZeroDegreeTrivial
import AlgebraicJacobian.Cohomology.H1BaseFieldInvariance

set_option autoImplicit false
set_option maxHeartbeats 1600000
universe u
open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))

/-- chi at the base-changed bundle, from chi_moduleKSheaf + genus_baseField. -/
example [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
    (K : Type u) [Field K] [Algebra k K] (hg : genus C = 0) :
    Sheaf.chi ((baseChangeBundle C K).left.moduleKSheaf K) = 1 := by
  haveI : IsProper (baseChangeBundle C K).hom := instIsProperSndLeft C K
  haveI : SmoothOfRelativeDimension 1 (baseChangeBundle C K).hom :=
    instSmoothOfRelativeDimensionSndLeft C K
  haveI : GeometricallyIrreducible (baseChangeBundle C K).hom :=
    instGeometricallyIrreducibleSndLeft C K
  rw [chi_moduleKSheaf (baseChangeBundle C K), genus_baseField C K, hg]
  norm_num

end AlgebraicGeometry
