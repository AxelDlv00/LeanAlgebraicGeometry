import Mathlib
import AlgebraicJacobian.Picard.EtaleFieldCover
import AlgebraicJacobian.Picard.PicEtDescentAssembly

open CategoryTheory AlgebraicGeometry Limits

universe u

namespace Probe

open AlgebraicGeometry.Scheme.PicScheme

variable {k : Type u} [Field k] (k' : Type u) [Field k'] [Algebra k k']
  [Algebra.IsSeparable k k'] [Module.Finite k k']

-- Is the SLICE-level generated sieve a covering sieve?  (overEquiv image contains fst)
example (T : Over (Spec (CommRingCat.of k))) :
    Sieve.generate (Presieve.singleton (coverMap (k := k) (k' := k') T)) ∈
      etaleTopologyOver k T := by
  sorry

end Probe
