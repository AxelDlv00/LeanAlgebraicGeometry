import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme

universe u

namespace Probe

-- QUESTION: my statements bind [Algebra.IsSeparable k k'] + [Module.Finite k k'].
-- p1's splitting needs [IsGalois k k'] (and it is IFF, so at a merely separable
-- level the splitting is FALSE, not just unavailable).
-- Is my Galois binder therefore FORCED, or are my statements strictly more general
-- (i.e. do they still say something at a non-Galois separable level)?

-- CONTROL: does isSheafFor_picEt_singleton_coverMap hold at a NON-Galois k'?
-- It only binds IsSeparable + Finite, so YES it does -- the cover is etale
-- regardless of normality.  Confirm by checking the binder list.
#check @AlgebraicGeometry.Scheme.PicScheme.isSheafFor_picEt_singleton_coverMap
#check @AlgebraicGeometry.Scheme.PicScheme.exists_unique_descend_picEt_of_projections
#check @AlgebraicGeometry.Scheme.PicScheme.selfPullback_coverMap_left_iso

end Probe
