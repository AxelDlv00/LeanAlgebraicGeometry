import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme

universe u

namespace Probe

variable {k : Type u} [Field k] (k' : Type u) [Field k'] [Algebra k k']

/-- STEP B: the scheme self-pullback of `pullback.fst T.hom φ` over `T` is
`T ×_{Spec k} (Spec k' ×_{Spec k} Spec k')`.

Try: pullback (fst) (fst) over T, where fst : T ×_k k' ⟶ T.
By pullbackRightPullbackFstIso with f := T.hom, g := φ, f' := fst. -/
noncomputable example (T : Over (Spec (CommRingCat.of k))) :
    pullback (pullback.fst T.hom (specMapAlgebra k k'))
      (pullback.fst T.hom (specMapAlgebra k k')) ≅
    pullback (pullback.fst T.hom (specMapAlgebra k k') ≫ T.hom) (specMapAlgebra k k') :=
  pullbackRightPullbackFstIso T.hom (specMapAlgebra k k')
    (pullback.fst T.hom (specMapAlgebra k k'))

end Probe
