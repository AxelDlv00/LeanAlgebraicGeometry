import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence
import AlgebraicJacobian.Picard.EtaleFieldCover

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme

universe u

namespace Probe

variable {k : Type u} [Field k] (k' : Type u) [Field k'] [Algebra k k']
  [Algebra.IsSeparable k k'] [Module.Finite k k']

-- the singleton presieve form of the sheaf axiom
example (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k))) :
    Presieve.IsSheafFor (picEt C)
      (Presieve.singleton (coverMap (k := k) (k' := k') T)) := by
  rw [Presieve.isSheafFor_iff_generate, generate_singleton_coverMap_eq]
  exact AlgebraicGeometry.Scheme.isSheafFor_picEt_pullback_presieve k' C T

end Probe
