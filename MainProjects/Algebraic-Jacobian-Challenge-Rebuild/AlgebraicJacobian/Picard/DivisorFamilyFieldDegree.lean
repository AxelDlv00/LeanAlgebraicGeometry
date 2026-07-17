/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyField

/-!
# The colength↔degree identity for divisor families over a field (`informal/spec-dd-1.md` §3 (f))

Over a field `K` the forward map `divFamDivisor` (`AlgebraicJacobian.Picard.DivisorFamilyField`)
sends a certified divisor family to its Weil divisor. This file lands the **degree identity**

`deg K (divFamDivisor F) = finrank K W(d)`

(so, with the field half `DivisorAdaptation.IsCertified.finrank_glued`, `deg = n`), the
colength↔degree bridge across the glued equalizer `W(d) = ker (δ⁻ − δ⁺)`.

## The support-separated assembly

The equalizer does not decompose over the cover naively — a supported closed point may lie in
two pieces. This file proves the **support-separated** case, which is the one the DD-1c backward
map consumes (its adaptations isolate the support points by construction): when the overlap
colength modules vanish (`ovlColength i j` is subsingleton for `i ≠ j`), the equalizer is the
*whole* product of the chart-local colengths, so

`finrank K W(d) = ∑ⱼ finrank K (Γ(D(hⱼ)) ⧸ (fⱼ))`  (`finrank_glued_eq_sum_of_separated`),

pure module algebra (`Module.finrank_pi_fintype` over the field, where every factor is free).
-/

set_option autoImplicit false

universe u

open CategoryTheory TopologicalSpace Opposite
open Module (finrank)

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {K : Type u} [Field K] [Algebra k K]
variable {π : C.left ⟶ P1 k} [IsAffineHom π]

namespace DivisorAdaptation

variable {d : (relCurve C K).LocalEquations} (A : DivisorAdaptation C K π d)

/-- On the diagonal `i = i` the two overlap-restriction maps of the equalizer coincide: the two
`≤`-witnesses `pieces i ⊓ pieces i ≤ pieces i` are definitionally equal (proof irrelevance), so
`toOvlLeft i i` and `toOvlRight i i` are the same map. -/
lemma toOvlLeft_self_eq_toOvlRight_self (i : A.index) :
    A.toOvlLeft i i = A.toOvlRight i i :=
  rfl

/-- **Support separation collapses the equalizer to the whole product.** If the overlap colength
modules vanish off the diagonal (`ovlColength i j` subsingleton for `i ≠ j`), then every element
of the product of chart-local colengths satisfies the equalizer condition, so the glued
submodule is all of `∏ⱼ colength j`. -/
lemma gluedSubmodule_eq_top_of_separated
    (hsep : ∀ i j : A.index, i ≠ j → Subsingleton (A.ovlColength i j)) :
    A.gluedSubmodule = ⊤ := by
  refine eq_top_iff.mpr fun s _ => ?_
  rw [mem_gluedSubmodule_iff]
  rintro ⟨i, j⟩
  by_cases hij : i = j
  · subst hij
    exact congrFun (congrArg (fun f : A.colength i →ₐ[K] A.ovlColength i i => (f : _ → _))
      (A.toOvlLeft_self_eq_toOvlRight_self i)) (s i)
  · haveI := hsep i j hij
    exact Subsingleton.elim _ _

/-- The equalizer as the whole product, when the glued submodule is `⊤`. -/
noncomputable def gluedTopEquiv (h : A.gluedSubmodule = ⊤) : A.Glued ≃ₗ[K] A.chartProd :=
  (LinearEquiv.ofEq _ _ h).trans Submodule.topEquiv

/-- **The support-separated colength↔degree bridge, algebraic half** (worksheet's
Mayer–Vietoris finrank additivity, no overlap correction): when the overlaps vanish, the
`K`-dimension of the glued equalizer is the sum of the chart-local colength dimensions. Pure
module algebra over the field — every colength is free, and the equalizer is the whole product
(`Module.finrank_pi_fintype`). -/
theorem finrank_glued_eq_sum_of_separated
    (hfin : ∀ j : A.index, Module.Finite K (A.colength j))
    (hsep : ∀ i j : A.index, i ≠ j → Subsingleton (A.ovlColength i j)) :
    finrank K A.Glued = ∑ j : A.index, finrank K (A.colength j) := by
  haveI : ∀ j : A.index, Module.Free K (A.colength j) := fun j => Module.Free.of_divisionRing _ _
  haveI := hfin
  rw [LinearEquiv.finrank_eq (A.gluedTopEquiv (A.gluedSubmodule_eq_top_of_separated hsep))]
  exact Module.finrank_pi_fintype K

end DivisorAdaptation

end AlgebraicGeometry
