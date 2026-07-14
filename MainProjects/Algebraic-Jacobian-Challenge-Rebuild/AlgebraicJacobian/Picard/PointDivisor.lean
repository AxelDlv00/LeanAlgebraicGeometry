/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorClass
import AlgebraicJacobian.RiemannRoch.ChiFiniteness

/-!
# The point-divisor local equations and the Picard class of a Weil divisor

For the curve bundle `X` (integral, smooth of relative dimension one and quasi-compact over
a field `K`) this file turns a Weil divisor into a Čech Picard class, building on the
local-equation constructor of `AlgebraicJacobian.Picard.DivisorClass`.

* `AlgebraicGeometry.Scheme.pointDivisor`: the local equations of the effective divisor
  `1 · x` at a closed point `x` — a uniformizer of the discrete valuation ring `𝒪_{X,x}`
  spread to a section on an open neighbourhood on which it vanishes only at `x`, and the
  constant `1` on the complement of `{x}`.
* `AlgebraicGeometry.Scheme.divisorClass`: the Picard class `𝒪(D)` of a Weil divisor `D`,
  the finitely-supported product of the point-divisor classes to their multiplicities
  (a `ℤ`-power in the commutative group `X.CechPic`). This is total on `X.CurveDivisor`.
* `AlgebraicGeometry.Scheme.divisorClass_add`: additivity of the divisor `↦` class map.
* `AlgebraicGeometry.Scheme.divisorClass_single_eq_pointDivisor`: the normalization anchor,
  identifying the class of a one-point divisor with the point-divisor class.

## Construction of `pointDivisor`

A uniformizer at `x` is a rational function `t` with `ord_x t = ofAdd (−1)`; it is integral
at `x` (`exists_stalk_of_ord_le_one`) so it is the germ at `η` of a section `s₀` over a
neighbourhood `W₀` of `x`. The section `s₀` vanishes at `x` (its germ there is a non-unit)
and at finitely many other closed points (those where the rational function `t` has a zero
or a pole, `ordZ_support_finite`); removing that finite closed set of other zeros gives an
open `V ∋ x` on which `s₀` is a unit away from `x`. The pointed cover `{V, {x}ᶜ}` with the
equations `s₀` on `V` and `1` elsewhere is then a `LocalEquations` system whose overlap
ratio is the unit `s₀` on `V \ {x}`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite Limits

namespace AlgebraicGeometry

namespace Scheme

variable {K : Type u} [instFld : Field K] {X : Scheme.{u}}
  [instOver : X.Over (Spec (CommRingCat.of K))]
  [instSmooth : SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))]
  [instInt : IsIntegral X]
  [instQC : QuasiCompact (X ↘ Spec (CommRingCat.of K))]

/-! ## The point section: a uniformizer vanishing only at `x` -/

omit instQC in
/-- **Order `≠ 1` at a zero of a section.** If a section `s` over an open containing `η` and a
closed point `z` is *not* a unit at `z` (i.e. `z ∉ 𝒟(s)`), then its germ at `η`, viewed as a
rational function, does not have trivial order at `z`: `z` is a zero (or pole). Contrapositive
of `Scheme.ord_eq_one_of_mem_basicOpen`. -/
private lemma ord_ne_one_of_notMem_basicOpen {z : X} (hz : z ≠ genericPoint X) {U : X.Opens}
    (s : Γ(X, U)) (hη : genericPoint X ∈ U) (hzU : z ∈ U) (hzs : z ∉ X.basicOpen s) :
    Scheme.ord (X ↘ Spec (CommRingCat.of K)) hz
        ((X.presheaf.germ U (genericPoint X) hη).hom s) ≠ 1 := by
  letI := isDiscreteValuationRing_stalk (X ↘ Spec (CommRingCat.of K)) hz
  letI := isDedekindDomain_stalk (X ↘ Spec (CommRingCat.of K)) hz
  have hnu : ¬ IsUnit ((X.presheaf.germ U z hzU).hom s) :=
    fun h => hzs ((X.mem_basicOpen s z hzU).mpr h)
  have hgs : (X.presheaf.germ U (genericPoint X) hη).hom s
      = algebraMap (X.presheaf.stalk z) X.functionField ((X.presheaf.germ U z hzU).hom s) :=
    germ_generic_eq_algebraMap_germ hη hzU s
  have hord : Scheme.ord (X ↘ Spec (CommRingCat.of K)) hz
      = (stalkHeightOne X z).valuation X.functionField := rfl
  rw [hgs, ne_eq, hord, IsDedekindDomain.HeightOneSpectrum.valuation_eq_one_iff_notMem]
  intro h
  exact hnu (IsLocalRing.notMem_maximalIdeal.mp h)

/-- **Existence of a point local equation.** For a closed point `x`, there is an open
neighbourhood `V ∋ x` and a section `s` over `V` whose germ is a nonzerodivisor at every point
of `V` (regularity) and a unit at every point of `V` other than `x` (a uniformizer of
`𝒪_{X,x}` whose only zero on `V` is `x`). -/
private lemma exists_pointLocalEquation (K : Type u) [Field K] {X : Scheme.{u}}
    [X.Over (Spec (CommRingCat.of K))]
    [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
    [QuasiCompact (X ↘ Spec (CommRingCat.of K))] {x : X} (hx : x ≠ genericPoint X) :
    ∃ (V : X.Opens), x ∈ V ∧ ∃ (s : Γ(X, V)), ∀ (y : X) (hy : y ∈ V),
      (X.presheaf.germ V y hy).hom s ∈ nonZeroDivisors (X.presheaf.stalk y) ∧
        (y ≠ x → IsUnit ((X.presheaf.germ V y hy).hom s)) := by
  set f := X ↘ Spec (CommRingCat.of K) with hf
  -- a uniformizer at `x`, as a nonzero rational function
  have ht0 : uniformizer K hx ≠ 0 := uniformizer_ne_zero K hx
  set tu : X.functionFieldˣ := Units.mk0 (uniformizer K hx) ht0 with htu
  have htuv : (tu : X.functionField) = uniformizer K hx := rfl
  -- `t` is integral at `x`
  have hord_le : Scheme.ord f hx (uniformizer K hx) ≤ 1 := by
    rw [ord_uniformizer K hx]
    rw [← WithZero.coe_one, WithZero.coe_le_coe, ← ofAdd_zero, Multiplicative.ofAdd_le]
    norm_num
  obtain ⟨y_st, hy_st⟩ := exists_stalk_of_ord_le_one K hx hord_le
  obtain ⟨W₀, hxW₀, s₀, hs₀⟩ := X.presheaf.exists_germ_eq (x := x) y_st
  have hηW₀ : genericPoint X ∈ W₀ := genericPoint_mem_of_nonempty ⟨x, hxW₀⟩
  -- the germ of `s₀` at `η` is the uniformizer
  have hgη : (X.presheaf.germ W₀ (genericPoint X) hηW₀).hom s₀ = uniformizer K hx := by
    rw [germ_generic_eq_algebraMap_germ hηW₀ hxW₀ s₀, hs₀, hy_st]
  -- the finite set of closed points where `t` has a zero or pole, other than `x`
  have hSfin : {p : {q : X // q ≠ genericPoint X} | Scheme.ordZ f p.2 tu ≠ 1}.Finite :=
    Scheme.ordZ_support_finite f tu
  set bad : Set X :=
    (Subtype.val '' {p : {q : X // q ≠ genericPoint X} | Scheme.ordZ f p.2 tu ≠ 1}) \ {x}
    with hbad
  have hbad_fin : bad.Finite := (hSfin.image Subtype.val).sdiff
  have hbad_ne : ∀ p ∈ bad, p ≠ genericPoint X := by
    rintro p ⟨⟨q, _, rfl⟩, _⟩
    exact q.2
  have hbad_closed : IsClosed bad := by
    rw [← Set.biUnion_of_singleton bad]
    exact hbad_fin.isClosed_biUnion
      (fun p hp => isClosed_singleton_of_ne_genericPoint f (hbad_ne p hp))
  -- the neighbourhood with the other zeros removed
  set V : X.Opens := ⟨(W₀ : Set X) \ bad, W₀.2.sdiff hbad_closed⟩ with hV
  have hVW₀ : V ≤ W₀ := Set.sdiff_subset
  have hxV : x ∈ V := ⟨hxW₀, fun h => h.2 rfl⟩
  refine ⟨V, hxV, (X.presheaf.map (homOfLE hVW₀).op).hom s₀, fun y hy => ?_⟩
  -- the germ of the restricted section at `y`
  have hgy : (X.presheaf.germ V y hy).hom ((X.presheaf.map (homOfLE hVW₀).op).hom s₀)
      = (X.presheaf.germ W₀ y (hVW₀ hy)).hom s₀ :=
    X.presheaf.germ_res_apply (homOfLE hVW₀) y hy s₀
  -- the germ, as a rational function via the structure map to the function field
  have hgalg : algebraMap (X.presheaf.stalk y) X.functionField
      ((X.presheaf.germ W₀ y (hVW₀ hy)).hom s₀) = uniformizer K hx :=
    (germ_generic_eq_algebraMap_germ hηW₀ (hVW₀ hy) s₀).symm.trans hgη
  refine ⟨?_, fun hyx => ?_⟩
  · -- regularity: the germ is a nonzerodivisor (it is nonzero in the domain stalk)
    rw [hgy, mem_nonZeroDivisors_iff_ne_zero]
    intro hzero
    rw [hzero, map_zero] at hgalg
    exact ht0 hgalg.symm
  · -- unit away from `x`
    rw [hgy]
    by_cases hyη : y = genericPoint X
    · subst hyη
      rw [show (X.presheaf.germ W₀ (genericPoint X) (hVW₀ hy)).hom s₀ = uniformizer K hx
        from hgη]
      exact isUnit_iff_ne_zero.mpr ht0
    · by_contra hnu
      have hybad : y ∈ bad := by
        refine ⟨⟨⟨y, hyη⟩, ?_, rfl⟩, ?_⟩
        · change Scheme.ordZ f hyη tu ≠ 1
          rw [ne_eq, Scheme.ordZ_eq_one_iff f hyη tu, htuv]
          intro hord1
          have hne := ord_ne_one_of_notMem_basicOpen (K := K) (z := y) hyη s₀ hηW₀ (hVW₀ hy)
            (fun h => hnu ((X.mem_basicOpen s₀ y (hVW₀ hy)).mp h))
          rw [hgη] at hne
          exact hne hord1
        · exact hyx
      exact hy.2 hybad

/-! ## The point divisor and the Picard class of a Weil divisor -/

/-- **The point divisor `1 · x`.** The local equations of the effective divisor `1 · x` at a
closed point `x`: on the neighbourhood `V` of `exists_pointLocalEquation` the section is the
uniformizer, and on the complement `{x}ᶜ` it is `1`. The overlap ratio on `V \ {x}` is the
uniformizer, a unit there. The uniformizer is chosen inside the construction; its Picard class
is independent of the choice up to `LocalEquations.picClass_rescale`, but this brick fixes a
choice. -/
noncomputable def pointDivisor (K : Type u) [Field K] {X : Scheme.{u}}
    [X.Over (Spec (CommRingCat.of K))]
    [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
    [QuasiCompact (X ↘ Spec (CommRingCat.of K))] {x : X} (hx : x ≠ genericPoint X) :
    X.LocalEquations := by
  classical
  let V : X.Opens := (exists_pointLocalEquation K hx).choose
  have hVspec : x ∈ V ∧ ∃ s : Γ(X, V), ∀ (y : X) (hy : y ∈ V),
      (X.presheaf.germ V y hy).hom s ∈ nonZeroDivisors (X.presheaf.stalk y) ∧
        (y ≠ x → IsUnit ((X.presheaf.germ V y hy).hom s)) :=
    (exists_pointLocalEquation K hx).choose_spec
  have hxV : x ∈ V := hVspec.1
  let s : Γ(X, V) := hVspec.2.choose
  have hs : ∀ (y : X) (hy : y ∈ V),
      (X.presheaf.germ V y hy).hom s ∈ nonZeroDivisors (X.presheaf.stalk y) ∧
        (y ≠ x → IsUnit ((X.presheaf.germ V y hy).hom s)) := hVspec.2.choose_spec
  set U : X.Opens :=
    ⟨({x} : Set X)ᶜ, (isClosed_singleton_of_ne_genericPoint
      (X ↘ Spec (CommRingCat.of K)) hx).isOpen_compl⟩ with hU
  set opN : X → X.Opens := fun y => if y = x then V else U with hopN
  have hopN_self : opN x = V := if_pos rfl
  have hopN_ne : ∀ {y : X}, y ≠ x → opN y = U := fun {y} h => if_neg h
  have hmem : ∀ y, y ∈ opN y := by
    intro y
    by_cases h : y = x
    · subst h; rw [hopN_self]; exact hxV
    · rw [hopN_ne h]; exact h
  set eqN : (∀ y, Γ(X, opN y)) := fun y =>
    if h : y = x then
      (X.presheaf.map (homOfLE (le_of_eq ((congrArg opN h).trans hopN_self))).op).hom s
    else (1 : Γ(X, opN y)) with heqN
  -- `eqN x` is a restriction of the section `s`
  have heqN_x : eqN x = (X.presheaf.map (homOfLE (le_of_eq hopN_self)).op).hom s := by
    rw [heqN]; exact dif_pos rfl
  -- restriction behaviour of `eqN` at `x` and away from `x`
  have res_eqN_self : ∀ {W : X.Opens} (hW : W ≤ opN x) (hWV : W ≤ V),
      (X.presheaf.map (homOfLE hW).op).hom (eqN x)
        = (X.presheaf.map (homOfLE hWV).op).hom s := by
    intro W hW hWV
    rw [heqN_x, ← CommRingCat.comp_apply, ← Functor.map_comp, ← op_comp, homOfLE_comp]
  have res_eqN_ne : ∀ {y : X} (hy : y ≠ x) {W : X.Opens} (hW : W ≤ opN y),
      (X.presheaf.map (homOfLE hW).op).hom (eqN y) = 1 := by
    intro y hy W hW
    have : eqN y = (1 : Γ(X, opN y)) := by rw [heqN]; exact dif_neg hy
    rw [this, map_one]
  -- germ behaviour of `eqN` at `x`
  have germ_eqN_self : ∀ (z : X) (hz : z ∈ opN x) (hzV : z ∈ V),
      (X.presheaf.germ (opN x) z hz).hom (eqN x) = (X.presheaf.germ V z hzV).hom s := by
    intro z hz hzV
    rw [heqN_x]
    exact X.presheaf.germ_res_apply (homOfLE (le_of_eq hopN_self)) z hz s
  -- a restriction of `s` to a subset of `V` avoiding `x` is a unit
  have unit_res_s : ∀ (W : X.Opens) (hWV : W ≤ V), (∀ z ∈ W, z ≠ x) →
      IsUnit ((X.presheaf.map (homOfLE hWV).op).hom s) := by
    intro W hWV hWx
    apply X.toRingedSpace.isUnit_of_isUnit_germ W
    intro z hz
    rw [X.presheaf.germ_res_apply (homOfLE hWV) z hz s]
    exact (hs z (hWV hz)).2 (hWx z hz)
  -- a point of the overlap `opN x ⊓ opN y'` (with `y' ≠ x`) is not `x`
  have overlap_ne : ∀ {a b : X} (hb : b ≠ x) (z : X),
      z ∈ opN a ⊓ opN b → z ≠ x := by
    intro a b hb z hz
    have hzb : z ∈ opN b := hz.2
    rw [hopN_ne hb] at hzb
    exact hzb
  have overlap_ne' : ∀ {a b : X} (ha : a ≠ x) (z : X),
      z ∈ opN a ⊓ opN b → z ≠ x := by
    intro a b ha z hz
    have hza : z ∈ opN a := hz.1
    rw [hopN_ne ha] at hza
    exact hza
  refine { cover := ⟨opN, hmem⟩, eqn := eqN, regular := ?_, ratio_isUnit := ?_ }
  · -- regularity
    intro x' y' hy'
    by_cases hx' : x' = x
    · subst x'
      have hy'V : y' ∈ V := hopN_self ▸ hy'
      rw [germ_eqN_self y' hy' hy'V]
      exact (hs y' hy'V).1
    · have hval : eqN x' = (1 : Γ(X, opN x')) := by rw [heqN]; exact dif_neg hx'
      rw [hval, map_one]
      exact one_mem _
  · -- ratio_isUnit
    intro x' y'
    by_cases hx' : x' = x <;> by_cases hy' : y' = x
    · -- both at `x`
      subst x'; subst y'
      refine ⟨1, ?_⟩
      rw [Units.val_one, one_mul,
        res_eqN_self inf_le_left (le_trans inf_le_left (le_of_eq hopN_self))]
    · -- `x' = x`, `y' ≠ x`
      subst x'
      have hWV : opN x ⊓ opN y' ≤ V := le_trans inf_le_left (le_of_eq hopN_self)
      have hunit := unit_res_s _ hWV (overlap_ne hy')
      refine ⟨hunit.unit, ?_⟩
      rw [res_eqN_ne hy' inf_le_right, mul_one, res_eqN_self inf_le_left hWV,
        hunit.unit_spec]
    · -- `x' ≠ x`, `y' = x`
      subst y'
      have hWV : opN x' ⊓ opN x ≤ V := le_trans inf_le_right (le_of_eq hopN_self)
      have hunit := unit_res_s _ hWV (overlap_ne' hx')
      refine ⟨hunit.unit⁻¹, ?_⟩
      rw [res_eqN_ne hx' inf_le_left, res_eqN_self inf_le_right hWV]
      exact (Units.inv_mul_of_eq hunit.unit_spec).symm
    · -- neither at `x`
      refine ⟨1, ?_⟩
      rw [res_eqN_ne hx' inf_le_left, res_eqN_ne hy' inf_le_right, Units.val_one, mul_one]

/-- **The Picard class of a Weil divisor.** The finitely supported product of the point-divisor
classes to their multiplicities (an integer power in the commutative group `X.CechPic`). This
is total on `X.CurveDivisor`: negative multiplicities contribute inverse classes. -/
noncomputable def divisorClass (K : Type u) [Field K] {X : Scheme.{u}}
    [X.Over (Spec (CommRingCat.of K))]
    [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
    [QuasiCompact (X ↘ Spec (CommRingCat.of K))] (D : X.CurveDivisor) : X.CechPic :=
  (toFinsupp D).prod fun p n => (pointDivisor K p.2).picClass ^ n

/-- **Additivity of the divisor class.** `𝒪(D + D') = 𝒪(D) · 𝒪(D')`. -/
theorem divisorClass_add (D D' : X.CurveDivisor) :
    divisorClass K (D + D') = divisorClass K D * divisorClass K D' := by
  simp only [divisorClass]
  exact Finsupp.prod_add_index' (fun p => zpow_zero _) (fun p m n => zpow_add _ m n)

/-- **Normalization anchor.** The class of the one-point divisor `1 · x` is the point-divisor
class. -/
theorem divisorClass_single_eq_pointDivisor {x : X} (hx : x ≠ genericPoint X) :
    divisorClass K (CurveDivisor.single hx 1) = (pointDivisor K hx).picClass := by
  rw [divisorClass, CurveDivisor.toFinsupp_single,
    Finsupp.prod_single_index (zpow_zero _), zpow_one]

end Scheme

end AlgebraicGeometry
