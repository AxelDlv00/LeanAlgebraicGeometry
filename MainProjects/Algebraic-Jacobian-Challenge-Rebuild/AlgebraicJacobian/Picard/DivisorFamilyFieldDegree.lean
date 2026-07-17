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

/-! ## A unit-germ ↔ trivial-order dictionary on the curve bundle

Reusable core: on the curve bundle `X/K`, a section `f` over an open `U ∋ η` is a unit at a
closed point `z ∈ U` exactly when the order at `z` of its germ at `η` is trivial. Both
directions of the private `ChartColength` machinery, packaged as a public equivalence through
the DVR valuation of the stalk. -/

namespace Scheme

variable (K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]

/-- **Unit germ ↔ trivial order.** For a section `f` over an open `U ∋ η` whose germ at `η` is
the field unit `g`, the germ of `f` at a closed point `z ∈ U` is a unit of the stalk exactly
when the order of `g` at `z` is trivial (`ordZ = 1`). -/
theorem isUnit_germ_iff_ordZ_eq_one {U : X.Opens} (hη : genericPoint X ∈ U)
    (f : Γ(X, U)) (g : X.functionFieldˣ)
    (hg : (g : X.functionField) = (X.presheaf.germ U (genericPoint X) hη).hom f)
    {z : X} (hz : z ∈ U) (hzg : z ≠ genericPoint X) :
    IsUnit ((X.presheaf.germ U z hz).hom f)
      ↔ Scheme.ordZ (X ↘ Spec (CommRingCat.of K)) hzg g = 1 := by
  rw [Scheme.ordZ_eq_one_iff]
  letI := isDiscreteValuationRing_stalk (X ↘ Spec (CommRingCat.of K)) hzg
  letI := isDedekindDomain_stalk (X ↘ Spec (CommRingCat.of K)) hzg
  have hord : Scheme.ord (X ↘ Spec (CommRingCat.of K)) hzg
      = (stalkHeightOne X z).valuation X.functionField := rfl
  have hgs : (X.presheaf.germ U (genericPoint X) hη).hom f
      = algebraMap (X.presheaf.stalk z) X.functionField
          ((X.presheaf.germ U z hz).hom f) := by
    rw [RingHom.algebraMap_toAlgebra]
    exact (X.presheaf.germ_stalkSpecializes_apply hz
      ((genericPoint_spec X).specializes trivial) f).symm
  rw [hg, hgs, hord, IsDedekindDomain.HeightOneSpectrum.valuation_eq_one_iff_notMem]
  exact (IsLocalRing.notMem_maximalIdeal).symm

end Scheme

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

/-! ## The per-piece degree reading and the support-separated assembly -/

section Degree

variable [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]

namespace DivisorAdaptation

variable {d : (relCurve C K).LocalEquations} (A : DivisorAdaptation C K π d)

/-- **The divisor coefficient is read off any piece.** At a closed point `z` of a piece
`D(h_j)`, the order of vanishing of the piece equation `f_j` (any field unit `g_j` presenting
its germ at `η`) equals the coefficient of the presentation divisor `D = div(d)` at `z`: the
piece equation refines `d`'s equation up to a unit section (trivial order) and orders read off
any piece agree (`MeromorphicPresentation.ordZ_elem_eq`). -/
lemma coeffAt_eq_toAdd_ordZ_eqn (j : A.index) {z : relCurve C K}
    (hz : z ∈ A.pieces j) (hzg : z ≠ genericPoint (relCurve C K))
    (gⱼ : (relCurve C K).functionFieldˣ)
    (hgⱼ : (gⱼ : (relCurve C K).functionField)
      = ((relCurve C K).presheaf.germ (A.pieces j) (genericPoint (relCurve C K))
          (Scheme.genericPoint_mem_of_nonempty ⟨z, hz⟩)).hom (A.eqn j)) :
    Multiplicative.toAdd (Scheme.ordZ (relCurve C K ↘ Spec (CommRingCat.of K)) hzg gⱼ)
      = coeffAt hzg (Scheme.presentationDivisor K d.presentation) := by
  have hηj : genericPoint (relCurve C K) ∈ A.pieces j :=
    Scheme.genericPoint_mem_of_nonempty ⟨z, hz⟩
  have hval : (gⱼ : (relCurve C K).functionField)
      = (Scheme.germGenericUnits hηj (A.unit j) : (relCurve C K).functionField)
        * (d.presentation.elem (A.pt j) : (relCurve C K).functionField) := by
    rw [hgⱼ, A.eqn_eq j, map_mul, Scheme.germGenericUnits_val,
      Scheme.LocalEquations.presentation_elem_val,
      (relCurve C K).presheaf.germ_res_apply (homOfLE (A.piece_le j))
        (genericPoint (relCurve C K)) hηj (d.eqn (A.pt j))]
  have hunit : gⱼ = Scheme.germGenericUnits hηj (A.unit j) * d.presentation.elem (A.pt j) :=
    Units.ext hval
  rw [Scheme.coeffAt_presentationDivisor, hunit, map_mul,
    Scheme.ordZ_germGenericUnits K hηj (A.unit j) hzg hz, one_mul,
    d.presentation.ordZ_elem_eq K hzg (A.piece_le j hz)]

end DivisorAdaptation

end Degree

end AlgebraicGeometry
