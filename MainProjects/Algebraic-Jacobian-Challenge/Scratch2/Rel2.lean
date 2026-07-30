import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme

universe u

namespace Probe

variable {k : Type u} [Field k] (k' : Type u) [Field k'] [Algebra k k']

/-- The underlying scheme of the slice self-pullback of `coverMap` is the
self-pullback of `pullback.fst` on schemes — because `Over.forget` preserves
pullbacks. -/
noncomputable example (T : Over (Spec (CommRingCat.of k))) :
    (pullback (coverMap (k := k) (k' := k') T)
      (coverMap (k := k) (k' := k') T)).left ≅
    pullback (pullback.fst T.hom (specMapAlgebra k k'))
      (pullback.fst T.hom (specMapAlgebra k k')) := by
  exact PreservesPullback.iso (Over.forget (Spec (CommRingCat.of k)))
    (coverMap (k := k) (k' := k') T) (coverMap (k := k) (k' := k') T)

end Probe
