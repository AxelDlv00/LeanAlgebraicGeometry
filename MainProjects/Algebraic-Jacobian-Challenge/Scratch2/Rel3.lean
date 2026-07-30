import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme

universe u

namespace Probe

variable {k : Type u} [Field k] (k' : Type u) [Field k'] [Algebra k k']

-- STEP A (free): slice self-pullback = scheme self-pullback of pullback.fst
noncomputable def sliceToScheme (T : Over (Spec (CommRingCat.of k))) :
    (pullback (coverMap (k := k) (k' := k') T)
      (coverMap (k := k) (k' := k') T)).left ≅
    pullback (pullback.fst T.hom (specMapAlgebra k k'))
      (pullback.fst T.hom (specMapAlgebra k k')) :=
  PreservesPullback.iso (Over.forget (Spec (CommRingCat.of k)))
    (coverMap (k := k) (k' := k') T) (coverMap (k := k) (k' := k') T)

-- STEP B: is the scheme self-pullback of pullback.fst identifiable with
-- T ×_{Spec k} (Spec k' ×_{Spec k} Spec k')?  This is the base-change step.
-- mathlib has pullbackRightPullbackFstIso / pullbackLeftPullbackSndIso families.
example (T : Over (Spec (CommRingCat.of k))) : True := by trivial

#check @CategoryTheory.Limits.pullbackRightPullbackFstIso
#check @CategoryTheory.Limits.pullbackLeftPullbackSndIso
#check @CategoryTheory.Limits.pullbackAssoc

end Probe
