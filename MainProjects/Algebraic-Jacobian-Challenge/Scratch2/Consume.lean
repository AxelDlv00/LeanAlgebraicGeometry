import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence
import AlgebraicJacobian.Picard.GaloisDescent.GaloisSelfTensor

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme
open scoped TensorProduct

universe u

namespace Probe

variable (k : Type u) [Field k] (k' : Type u) [Field k']
  [Algebra k k'] [FiniteDimensional k k'] [IsGalois k k']

/-- FIRST REAL CONSUMER ATTEMPT: transport the splitting to schemes.
`Spec k' ×_{Spec k} Spec k' ≅ Spec (∏_{Gal} k')`. -/
noncomputable def specSelfPullbackIso :
    pullback (specMapAlgebra k k') (specMapAlgebra k k') ≅
      Spec (CommRingCat.of ((k' ≃ₐ[k] k') → k')) :=
  AlgebraicGeometry.pullbackSpecIso k k' k' ≪≫
    Scheme.Spec.mapIso
      (RingEquiv.toCommRingCatIso
        (AlgebraicJacobian.GaloisDescent.galoisSelfTensorEquiv k k').toRingEquiv.symm).op

end Probe
