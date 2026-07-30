import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence
import AlgebraicJacobian.Picard.GaloisDescent.GaloisSelfTensor

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme
open scoped TensorProduct

universe u

namespace Probe

variable {k : Type u} [Field k] (k' : Type u) [Field k'] [Algebra k k']
  [FiniteDimensional k k'] [IsGalois k k']

-- STEP 1: the self-pullback of Spec k' over Spec k is Spec (k' ⊗ k'), then
-- via the splitting, a finite coproduct of copies of Spec k'.
-- Does the sigmaSpec / IsIso route apply?
example : IsIso (sigmaSpec (fun _ : (k' ≃ₐ[k] k') => CommRingCat.of k')) := by
  haveI : Fintype (k' ≃ₐ[k] k') := AlgEquiv.fintype k k'
  infer_instance

-- STEP 2: the pullback Spec k' ×_{Spec k} Spec k' as Spec of the tensor
example : pullback (specMapAlgebra k k') (specMapAlgebra k k') ≅
    Spec (CommRingCat.of (k' ⊗[k] k')) :=
  AlgebraicGeometry.pullbackSpecIso k k' k'

end Probe
