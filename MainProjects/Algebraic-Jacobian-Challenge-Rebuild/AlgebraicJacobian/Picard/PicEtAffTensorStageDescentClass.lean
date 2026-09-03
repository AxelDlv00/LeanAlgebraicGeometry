/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicEtPushoutCarrierOverlap
import AlgebraicJacobian.Picard.PicEtAffDescentReflection
import AlgebraicJacobian.Picard.RelPicFaithfullyFlatInjective
import AlgebraicJacobian.Picard.RelPicTensorStageFiniteStage

/-!
# Descent classes at finite tensor stages

A relative Picard class descended to a finite tensor stage inherits any equality between
two scalar-extended restriction maps.  Applied to the two faces of an etale cover, the
resulting equality can be transported through the pushout carrier and overlap comparisons
to produce an actual descent class on the lower base-changed cover.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

/-- Reflect a pair of restriction maps from a compatible ambient relative Picard class.

All rings and maps are explicit here so tensor-stage consumers can elaborate this
reflection boundary before installing their dependent scalar-extension instances. -/
theorem relPic_pair_eq_of_compatible
    {k A A' Q Q' : Type u} [Field k]
    [CommRing A] [CommRing A'] [CommRing Q] [CommRing Q']
    [Algebra k A] [Algebra k A'] [Algebra k Q] [Algebra k Q']
    (C : Over (Spec (.of k)))
    (qA : relPic C (overSpec k A)) (qA' : relPic C (overSpec k A'))
    (jA : A →ₐ[k] A') (jQ : Q →ₐ[k] Q')
    (f g : A →ₐ[k] Q) (f' g' : A' →ₐ[k] Q')
    (hjQ : Function.Injective (relPicAlgMap C jQ))
    (hq : relPicAlgMap C jA qA = qA')
    (hf : jQ.comp f = f'.comp jA) (hg : jQ.comp g = g'.comp jA)
    (hQ' : relPicAlgMap C f' qA' = relPicAlgMap C g' qA') :
    relPicAlgMap C f qA = relPicAlgMap C g qA := by
  apply relPicAlgMap_pair_eq_of_injective C jA jQ f g f' g' hjQ hf hg
  rw [hq]
  exact hQ'

end

end AlgebraicGeometry
