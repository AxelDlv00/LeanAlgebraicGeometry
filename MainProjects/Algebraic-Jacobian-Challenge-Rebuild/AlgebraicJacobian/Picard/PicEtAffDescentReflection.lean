/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicEtAff

/-!
# Reflection of relative Picard descent conditions

This module reflects a relative Picard equality through an injective restriction map.
-/

set_option autoImplicit false

universe u

open CategoryTheory

open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

/-- Reflect equality of two relative Picard restrictions through a commuting pair of
carrier maps when restriction along the target map is injective. -/
theorem relPicAlgMap_pair_eq_of_injective
    {k A A' B B' : Type u} [Field k]
    [CommRing A] [CommRing A'] [CommRing B] [CommRing B']
    [Algebra k A] [Algebra k A'] [Algebra k B] [Algebra k B']
    (C : Over (Spec (.of k)))
    (n : A →ₐ[k] A') (d : B →ₐ[k] B')
    (f g : A →ₐ[k] B) (f' g' : A' →ₐ[k] B')
    (hd : Function.Injective (relPicAlgMap C d))
    (hf : d.comp f = f'.comp n) (hg : d.comp g = g'.comp n)
    {x : relPic C (overSpec k A)}
    (hx : relPicAlgMap C f' (relPicAlgMap C n x) =
      relPicAlgMap C g' (relPicAlgMap C n x)) :
    relPicAlgMap C f x = relPicAlgMap C g x := by
  apply hd
  rw [← relPicAlgMap_comp, ← relPicAlgMap_comp, hf, hg,
    relPicAlgMap_comp, relPicAlgMap_comp]
  exact hx

end

end AlgebraicGeometry
