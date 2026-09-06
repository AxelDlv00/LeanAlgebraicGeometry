/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import Mathlib.AlgebraicGeometry.FunctionField

/-!
# Surjectivity at the generic stalk

For a morphism with integral source, surjectivity on any one stalk implies
surjectivity at the generic point. A function-field element is a quotient of
elements of the chosen stalk. Lift the numerator and denominator there and
specialize their lifts; the local-hom property makes the denominator invertible.
-/

set_option autoImplicit false

universe u

open CategoryTheory TopologicalSpace AlgebraicGeometry

namespace Hartshorne

noncomputable section

/-- A surjective stalk map at any point of an integral source gives a
surjective stalk map at its generic point. -/
theorem stalkMap_genericPoint_surjective_of_surjective
    {X Y : Scheme.{u}} [IsIntegral X] (f : X ⟶ Y) (x : X)
    (h : Function.Surjective (f.stalkMap x).hom) :
    Function.Surjective (f.stalkMap (genericPoint X)).hom := by
  intro z
  obtain ⟨a, b, hb, rfl⟩ := IsFractionRing.div_surjective (X.presheaf.stalk x) z
  obtain ⟨a', ha⟩ := h a
  obtain ⟨b', hb'⟩ := h b
  let hη : genericPoint X ⤳ x := (genericPoint_spec X).specializes trivial
  let s := Y.presheaf.stalkSpecializes (f.base.hom.map_specializes hη)
  have hcomm (t : Y.presheaf.stalk (f x)) :
      (f.stalkMap (genericPoint X)).hom (s.hom t) =
        algebraMap (X.presheaf.stalk x) X.functionField ((f.stalkMap x).hom t) := by
    exact f.stalkSpecializes_stalkMap_apply (genericPoint X) x hη t
  have hbunit : IsUnit (s.hom b') := by
    apply (isUnit_map_iff (f.stalkMap (genericPoint X)).hom _).mp
    rw [hcomm, hb']
    exact IsUnit.mk0 _ (IsFractionRing.to_map_ne_zero_of_mem_nonZeroDivisors hb)
  obtain ⟨v, hv⟩ := hbunit
  refine ⟨s.hom a' * (↑v⁻¹ : Y.presheaf.stalk (f (genericPoint X))), ?_⟩
  rw [map_mul, map_units_inv, hv, hcomm, hcomm, ha, hb']
  rfl

end
end Hartshorne
