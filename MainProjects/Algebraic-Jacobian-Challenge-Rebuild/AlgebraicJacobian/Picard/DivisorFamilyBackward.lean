/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyFieldDegree
import AlgebraicJacobian.Picard.DivisorFamilyExtraction

/-!
# The backward realization of the field dictionary (`informal/spec-dd-1.md` §3 (f), `hsurj`)

Over a field `K` the forward map `divFamDivisor` sends a certified divisor family to its Weil
divisor. This file builds the **backward** ingredients: from an effective divisor `D` of degree
`n`, an explicit local-equation system realizing it, on the way to a certified support-separated
family presenting `D` (the `hsurj` slot of `divFamFieldEquivOfDegOfSurj`).

## Stage 1 — additivity of the presentation divisor along products

`Scheme.LocalEquations.mul` (`AlgebraicJacobian.Picard.DivisorClass`) multiplies two
local-equation systems pointwise on the common refinement; its Weil divisor is the *sum* of the
two divisors. This is the `LocalEquations`-level companion of the
`MeromorphicPresentation`-level `presentationDivisor_mul`: the trivializing element of the
product presentation is the product of the trivializing elements
(`Scheme.LocalEquations.mul_presentation_elem`), and `ordZ` is a group homomorphism, so orders —
hence divisor coefficients — add.

* `Scheme.LocalEquations.mul_presentation_elem` — `(d.mul d').presentation.elem x
  = d.presentation.elem x * d'.presentation.elem x`.
* `Scheme.LocalEquations.presentationDivisor_mul` — `presentationDivisor K (d.mul d').presentation
  = presentationDivisor K d.presentation + presentationDivisor K d'.presentation`.
-/

set_option autoImplicit false

universe u

open CategoryTheory TopologicalSpace Opposite

namespace AlgebraicGeometry

namespace Scheme

namespace LocalEquations

variable {X : Scheme.{u}} [IsIntegral X]

/-- **The trivializing element of a product presentation is the product of the trivializing
elements.** The equation of `d.mul d'` at `x` is, by definition, the product of the restrictions
of `d`'s and `d'`'s equations to the common refinement, so its germ at `η` — the trivializing
element of the presentation — is the product of the two germs at `η`. -/
lemma mul_presentation_elem (d d' : X.LocalEquations) (x : X) :
    (d.mul d').presentation.elem x = d.presentation.elem x * d'.presentation.elem x := by
  refine Units.ext ?_
  have hη : genericPoint X ∈ d.cover.opens x ⊓ d'.cover.opens x :=
    ⟨d.cover.genericPoint_mem_opens x, d'.cover.genericPoint_mem_opens x⟩
  rw [Units.val_mul, presentation_elem_val, presentation_elem_val, presentation_elem_val,
    ← X.presheaf.germ_res_apply (homOfLE (inf_le_left :
        d.cover.opens x ⊓ d'.cover.opens x ≤ d.cover.opens x)) (genericPoint X) hη (d.eqn x),
    ← X.presheaf.germ_res_apply (homOfLE (inf_le_right :
        d.cover.opens x ⊓ d'.cover.opens x ≤ d'.cover.opens x)) (genericPoint X) hη (d'.eqn x),
    ← map_mul]
  rfl

variable (K : Type u) [Field K] [X.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (X ↘ Spec (CommRingCat.of K))]

/-- **Additivity of the presentation divisor along products** (`informal/spec-dd-1.md` §3 (f),
DD-1c backward stage 1): the Weil divisor of the product local-equation system `d.mul d'` is the
sum of the two Weil divisors. The trivializing element multiplies
(`mul_presentation_elem`) and `ordZ` is a group homomorphism, so the coefficients — orders of
vanishing — add. The `LocalEquations`-level companion of
`Scheme.MeromorphicPresentation.presentationDivisor_mul`. -/
theorem presentationDivisor_mul (d d' : X.LocalEquations) :
    presentationDivisor K (d.mul d').presentation
      = presentationDivisor K d.presentation + presentationDivisor K d'.presentation := by
  refine CurveDivisor.ext_coeffAt fun x hx => ?_
  rw [coeffAt_presentationDivisor, mul_presentation_elem, map_mul, toAdd_mul,
    CurveDivisor.coeffAt_add, coeffAt_presentationDivisor, coeffAt_presentationDivisor]

end LocalEquations

end Scheme

end AlgebraicGeometry
