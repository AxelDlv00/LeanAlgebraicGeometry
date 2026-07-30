import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme

universe u

namespace Probe

variable {k : Type u} [Field k] (k' : Type u) [Field k'] [Algebra k k']

/-- The full chain: slice self-pullback of `coverMap` is the base change of
`Spec k' ×_{Spec k} Spec k'` along `T`, hence (given the Galois splitting) a
`Gal`-indexed thing. Steps A and B chained. -/
noncomputable def chain (T : Over (Spec (CommRingCat.of k))) :
    (pullback (coverMap (k := k) (k' := k') T)
      (coverMap (k := k) (k' := k') T)).left ≅
    pullback (pullback.fst T.hom (specMapAlgebra k k') ≫ T.hom)
      (specMapAlgebra k k') :=
  (PreservesPullback.iso (Over.forget (Spec (CommRingCat.of k)))
    (coverMap (k := k) (k' := k') T) (coverMap (k := k) (k' := k') T)) ≪≫
  pullbackRightPullbackFstIso T.hom (specMapAlgebra k k')
    (pullback.fst T.hom (specMapAlgebra k k'))

end Probe
