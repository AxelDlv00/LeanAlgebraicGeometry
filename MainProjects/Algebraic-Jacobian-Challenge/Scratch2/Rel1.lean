import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme

universe u

namespace Probe

variable {k : Type u} [Field k] (k' : Type u) [Field k'] [Algebra k k']

/-- The self-pullback of `coverMap` in the slice: is its underlying scheme the
self-pullback of `pullback.fst` on schemes? The slice forgetful functor creates
pullbacks (Over.forget preserves them), so this should be free. -/
example (T : Over (Spec (CommRingCat.of k))) :
    True := by trivial

-- Does Over.forget preserve pullbacks / create limits?
#check @CategoryTheory.Over.forget
example : Limits.PreservesLimitsOfShape WalkingCospan
    (Over.forget (Spec (CommRingCat.of k))) := by infer_instance

end Probe
