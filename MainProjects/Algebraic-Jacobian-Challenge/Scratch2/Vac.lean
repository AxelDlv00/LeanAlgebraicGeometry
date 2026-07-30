import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence
import AlgebraicJacobian.Picard.EtaleFieldCover

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme

universe u

namespace Probe

variable {k : Type u} [Field k] (k' : Type u) [Field k'] [Algebra k k']
  [Algebra.IsSeparable k k'] [Module.Finite k k']

-- CONTROL 1: does the ∃! conclusion hold WITHOUT the compatibility hypothesis?
-- If it does, the hypothesis is decoration.
example (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    (x : (picEt C).obj (Opposite.op ((restrictTest k k').obj (baseTest (k' := k') T)))) :
    ∃! y : (picEt C).obj (Opposite.op T),
      (picEt C).map (coverMap (k' := k') T).op y = x := by
  exact?

-- CONTROL 2: does the sheaf axiom hold at an ARBITRARY morphism (not this cover)?
-- If it does, the covering-sieve witness is doing nothing.
example (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    {T W : Over (Spec (CommRingCat.of k))} (f : W ⟶ T) :
    Presieve.IsSheafFor (picEt C) (Presieve.singleton f) := by
  exact?

end Probe
