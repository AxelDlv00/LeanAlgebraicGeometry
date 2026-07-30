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

-- The two bridge ingredients both EXIST. Record what they are.
noncomputable example : pullback (specMapAlgebra k k') (specMapAlgebra k k') ≅
    Spec (CommRingCat.of (k' ⊗[k] k')) :=
  AlgebraicGeometry.pullbackSpecIso k k' k'

example : IsIso (sigmaSpec (fun _ : (k' ≃ₐ[k] k') => CommRingCat.of k')) := by
  haveI : Fintype (k' ≃ₐ[k] k') := AlgEquiv.fintype k k'
  infer_instance

-- WHAT IS NOT FREE: the T-relative version.  The cover's self-pullback is
-- T_{k'} ×_T T_{k'}, not Spec k' ×_{Spec k} Spec k'.  Is there a lemma?
example (T : Over (Spec (CommRingCat.of k))) :
    pullback (coverMap (k := k) (k' := k') T) (coverMap (k := k) (k' := k') T) ≅
      Over.mk (pullback.snd T.hom (specMapAlgebra k k') ≫ specMapAlgebra k k') := by
  exact?

end Probe
