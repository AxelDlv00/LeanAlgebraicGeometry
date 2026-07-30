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

noncomputable def specSelfPullbackIso :
    pullback (specMapAlgebra k k') (specMapAlgebra k k') ≅
      Spec (CommRingCat.of ((k' ≃ₐ[k] k') → k')) :=
  AlgebraicGeometry.pullbackSpecIso k k' k' ≪≫
    Scheme.Spec.mapIso
      (RingEquiv.toCommRingCatIso
        (AlgebraicJacobian.GaloisDescent.galoisSelfTensorEquiv k k').toRingEquiv.symm).op

/-- And Spec of the product IS the coproduct of Specs (finite index). -/
noncomputable def specPiIso :
    (∐ fun _ : (k' ≃ₐ[k] k') => Spec (CommRingCat.of k')) ≅
      Spec (CommRingCat.of ((k' ≃ₐ[k] k') → k')) := by
  haveI : Fintype (k' ≃ₐ[k] k') := AlgEquiv.fintype k k'
  exact asIso (sigmaSpec (fun _ : (k' ≃ₐ[k] k') => CommRingCat.of k'))

/-- THE COHERENCE: the γ-component of the coproduct, followed by the two
projections of the self-pullback, gives `id` and `γ`. This is what I named as
the residue. Test whether it is stateable and provable. -/
example (γ : k' ≃ₐ[k] k') :
    (Sigma.ι (fun _ : (k' ≃ₐ[k] k') => Spec (CommRingCat.of k')) γ) ≫
      (specPiIso k k').hom ≫ (specSelfPullbackIso k k').inv ≫
        pullback.fst (specMapAlgebra k k') (specMapAlgebra k k')
      = 𝟙 _ := by
  simp only [specPiIso, specSelfPullbackIso, Iso.trans_hom, Iso.trans_inv, asIso_hom,
    Functor.mapIso_inv, Iso.op_inv, Category.assoc, ι_sigmaSpec, pullbackSpecIso_inv_fst]
  rw [← Spec.map_comp, ← Spec.map_comp, ← Spec.map_id]
  congr 1
  ext x
  simp [AlgebraicJacobian.GaloisDescent.galoisSelfTensorEquiv_apply_tmul]

end Probe
