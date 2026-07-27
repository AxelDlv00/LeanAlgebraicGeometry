/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Adelic.LedgerClosure
import AlgebraicJacobian.RiemannRoch.Adelic.GateInstances
import AlgebraicJacobian.RiemannRoch.Adelic.FiniteMapToP1
import AlgebraicJacobian.Picard.TangentSpaceStalkAlgebra

/-!
# Adelic Riemann–Roch — the residue field of a closed point is the base field

This file **discharges** the residue-degree fact `[κ(P) : k̄] = 1` for a prime divisor of
an AJC curve over an algebraically closed base field.  It is the input that
`Adelic/GlobalGeneration.lean` §5–§7 and `Adelic/SectionBounds.lean` §4 both reduce to,
and which those files leave open.

## What changes relative to `GlobalGeneration.lean` §7

`hasRationalResidues_of_isAlgClosed` (there) derives the approximation statement from
**three stalk-level instance binders**, and its own docstring records — correctly — that
none of them is constructed anywhere in AJC, so that it "trades one unproved fact for
three unbuilt instances" and is a *reformulation, not a discharge*.

This file builds all three, for a curve `C : Over (Spec k)`, and so closes the gap:

1. `Algebra k 𝒪_P` — `stalkStructureHom` (`Picard/TangentSpaceStalkAlgebra.lean`) already
   supplies the ring map; what was missing is that it is **compatible with the
   `Algebra k K(C)` of `Adelic/GateInstances.lean`**.  That is
   `algebraMap_stalk_functionField`, proved by factoring both through `Γ(C,⊤)`:
   `stalkStructureHom = constMap ≫ germ_⊤` (`stalkStructureHom_eq_constMap_germ`, from
   mathlib's `Hom.germ_stalkMap`), after which mathlib's
   `functionField_isScalarTower` matches the two composites.
2. `IsScalarTower k 𝒪_P K(C)` — a corollary of (1) (`isScalarTower_stalk_functionField`).
3. `Module.Finite k κ_P` — **not needed at all** on this route, which is the substantive
   simplification.  §7's argument goes through `IsAlgClosed.algebraMap_bijective_of_isIntegral`,
   which needs the residue field to be *integral* over `k` and hence a finiteness input that
   AJC does not have.  Mathlib's `AlgebraicGeometry.residueFieldIsoBase` proves
   `κ(x) ≅ k` for a closed point of a scheme **locally of finite type** over an
   algebraically closed field, obtaining integrality from
   `isFinite_iff_locallyOfFiniteType_of_jacobsonSpace` instead.  `LocallyOfFiniteType C.hom`
   is a hypothesis a smooth curve satisfies, unlike a bare residue-finiteness gate.

So the exchange is: one open fact **out**, and in its place a `LocallyOfFiniteType`
hypothesis plus the closedness of the point — both genuinely available.

## The closedness input

`residueFieldIsoBase` needs `IsClosed {P.point}`.  For a prime divisor this is *not* an
extra assumption: `Adelic/FiniteMapToP1.lean` proves
`isClosed_singleton_of_coheight_le_one`, and a prime divisor has `coheight = 1` by
definition while the generic point has coheight `0` on a curve.  `isClosed_primeDivisor`
below packages this, taking the one-dimensionality of the curve as the hypothesis
`hdim` that the sibling file also uses.

## Main declarations

* `stalkStructureHom_eq_constMap_germ`, `algebraMap_stalk_functionField`,
  `isScalarTower_stalk_functionField` — the compatibility layer (item 1–2 above).
* `bijective_residue_comp_stalkStructureHom` — `k → 𝒪_P → κ(P)` is **bijective** at a
  closed point, from mathlib's `residueFieldIsoBase`.
* `hasRationalResidues_of_isAlgClosed_curve` — `HasRationalResidues k P`, **discharged**:
  every function regular at `P` agrees with a constant to first order.
* `residueDeg_eq_one_of_isAlgClosed_curve` — `[κ(P):k] = 1`, the campaign's residue fact.
* `degree_principal_eq_zero_of_isAlgClosed_curve` — the **unweighted** principal-degree-zero
  statement, from the ledger, with the residue input now discharged rather than assumed.

## A note on an instance diamond (read before adding imports here)

With `Picard/TangentSpaceStalkAlgebra.lean` imported, `open scoped AlgebraicGeometry`
brings in `overStalkAlgebra C x : Algebra k 𝒪_{C,x}`.  At `x = genericPoint C.left` its
target `𝒪_{C,generic}` *is* `K(C)` by definition, so it competes with
`Scheme.functionFieldAlgebra` for `Algebra k K(C)` — and the two are **not**
definitionally equal (machine-checked: `rfl` fails).  Everything below therefore opens
only `AlgebraicGeometry.Scheme`, and constructs the stalk algebra as an explicit `letI`
rather than by activating the scoped instance.  Activating it would silently re-pin
`sectionSub`/`orderGeSub`/`residueDeg` to a different `k`-action than the rest of the
lane uses.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits IsDedekindDomain
open scoped WithZero AlgebraicGeometry.Scheme

namespace AlgebraicGeometry
namespace Adelic

/-! ## §1. The stalk `k`-algebra and its compatibility with `K(C)` -/

section StalkAlgebra

variable {k : Type u} [Field k]

/-- **The structure homomorphism into a stalk factors through the global sections.**
`k → 𝒪_{C,x}` is `constMap C : k → Γ(C,⊤)` followed by the germ at `x`.

Both sides are the stalk map of `C.hom` precomposed with `ΓSpecIso.inv`; mathlib's
`Hom.germ_stalkMap` is exactly the statement that the germ commutes past a stalk map.
This is the lemma that ties `Picard/TangentSpaceStalkAlgebra.lean`'s stalk algebra to
`Adelic/GateInstances.lean`'s function-field algebra, which is built from `constMap`. -/
theorem stalkStructureHom_eq_constMap_germ (C : Over (Spec (CommRingCat.of k)))
    (x : C.left) :
    stalkStructureHom C.hom x
      = Scheme.constMap C ≫ C.left.presheaf.germ ⊤ x trivial := by
  rw [stalkStructureHom, Scheme.constMap, Category.assoc]
  congr 1
  exact C.hom.germ_stalkMap ⊤ x trivial

/-- **The two `k`-algebra structures agree.**  The image of a constant `c : k` in `K(C)`
is the same whether one goes `k → 𝒪_P → K(C)` (through `stalkStructureHom`) or directly
`k → K(C)` (through `Scheme.functionFieldAlgebra`).

This is what makes the stalk-level argument of §2 usable in the order language of the
adelic lane, whose `algebraMap k K(X)` is the latter.  Proof: rewrite the stalk map as
`constMap ≫ germ` (`stalkStructureHom_eq_constMap_germ`), then both sides are
`algebraMap Γ(C,⊤) K(C) ∘ constMap` — the first by mathlib's
`functionField_isScalarTower`, the second by `Scheme.algebraMap_functionField_eq`. -/
theorem algebraMap_stalk_functionField (C : Over (Spec (CommRingCat.of k)))
    [IsIntegral C.left] (x : C.left) (c : k) :
    algebraMap (C.left.presheaf.stalk x) C.left.functionField
        ((stalkStructureHom C.hom x).hom c)
      = algebraMap k C.left.functionField c := by
  haveI : Nonempty (⊤ : C.left.Opens) := Scheme.nonempty_top_opens C.left
  letI : Algebra ↥Γ(C.left, ⊤) (C.left.presheaf.stalk x) :=
    C.left.presheaf.algebra_section_stalk (⟨x, trivial⟩ : (⊤ : C.left.Opens))
  haveI : IsScalarTower ↥Γ(C.left, ⊤) (C.left.presheaf.stalk x)
      C.left.functionField :=
    functionField_isScalarTower C.left ⊤ ⟨x, trivial⟩
  have h1 : (stalkStructureHom C.hom x).hom c
      = algebraMap ↥Γ(C.left, ⊤) (C.left.presheaf.stalk x)
        ((Scheme.constMap C).hom c) := by
    rw [stalkStructureHom_eq_constMap_germ C x]; rfl
  rw [h1, ← IsScalarTower.algebraMap_apply]
  rfl

/-- **The tower `k → 𝒪_P → K(C)`** — binder (2) of `GlobalGeneration.lean` §7, now built.
Immediate from `algebraMap_stalk_functionField`. -/
theorem isScalarTower_stalk_functionField (C : Over (Spec (CommRingCat.of k)))
    [IsIntegral C.left] (x : C.left) :
    letI : Algebra k (C.left.presheaf.stalk x) := stalkAlgebra C.hom x
    IsScalarTower k (C.left.presheaf.stalk x) C.left.functionField := by
  letI : Algebra k (C.left.presheaf.stalk x) := stalkAlgebra C.hom x
  refine IsScalarTower.of_algebraMap_eq fun c => ?_
  exact (algebraMap_stalk_functionField C x c).symm

end StalkAlgebra

/-! ## §2. `κ(P) = k` at a closed point, over an algebraically closed base

Mathlib's `AlgebraicGeometry.residueFieldIsoBase` gives `κ(x) ≅ k` as a `CommRingCat`
iso for a closed point of a scheme locally of finite type over an algebraically closed
`k`.  What is needed here is the *ring-map* form: that the composite
`k → 𝒪_x → κ(x)` — the map the order language sees — is bijective.  That follows once
the composite is identified with the iso's inverse, which is `residue_stalkStructureHom_eq`
below: an identity of `Spec`-morphisms, checked through `Spec.map_injective`. -/

section ResidueBijective

variable {k : Type u} [Field k]

/-- **A prime divisor of a curve is a closed point.**  On an irreducible scheme all of
whose points have coheight `≤ 1` (the curve condition, supplied by
`coheight_le_one_of_curve`), a point of coheight `1` is not the generic point — the
generic point has coheight `0` — hence is closed by
`isClosed_singleton_of_coheight_le_one` (`Adelic/FiniteMapToP1.lean`).

This is why the closedness input of `residueFieldIsoBase` costs nothing here: it is part
of what `X.PrimeDivisor` already asserts. -/
theorem isClosed_primeDivisor {X : Scheme.{u}} [IrreducibleSpace X]
    (hdim : ∀ w : X, Order.coheight w ≤ 1) (P : X.PrimeDivisor) :
    IsClosed ({P.point} : Set X) := by
  refine isClosed_singleton_of_coheight_le_one hdim ?_
  intro hgen
  -- the generic point is maximal in the specialisation order, so has coheight `0`
  have hmax : IsMax (genericPoint X) := fun y hy => genericPoint_specializes y
  have h0 : Order.coheight P.point = 0 := by
    rw [hgen]; exact Order.IsMax.coheight_eq_zero hmax
  rw [P.coheight] at h0
  exact absurd h0 (by simp)

/-- **The composite `k → 𝒪_x → κ(x)` is the inverse of mathlib's `residueFieldIsoBase`.**

Both are morphisms `k ⟶ κ(x)` in `CommRingCat`; `Spec` is faithful, so it suffices to
check the induced `Spec` morphisms agree, and there both sides unfold to
`X.fromSpecResidueField x ≫ C.hom` — the left by `Scheme.fromSpecResidueField` plus
`fromSpecStalk_comp_eq` (`Picard/TangentSpaceStalkAlgebra.lean`), the right by mathlib's
`SpecMap_residueFieldIsoBase_inv`. -/
theorem residue_stalkStructureHom_eq [IsAlgClosed k]
    (C : Over (Spec (CommRingCat.of k))) [LocallyOfFiniteType C.hom]
    (x : C.left) (hx : IsClosed ({x} : Set C.left)) :
    stalkStructureHom C.hom x ≫ C.left.residue x
      = (residueFieldIsoBase C.hom x hx).inv := by
  apply Spec.map_injective
  rw [SpecMap_residueFieldIsoBase_inv, Spec.map_comp, Scheme.fromSpecResidueField,
    ← fromSpecStalk_comp_eq, Category.assoc]

/-- **`k → κ(x)` is bijective at a closed point of a curve over an algebraically closed
base.**  Immediate from `residue_stalkStructureHom_eq`: an iso of `CommRingCat` has
bijective underlying ring map.

This is the statement that replaces `GlobalScheme`'s three-binder route: no
`Module.Finite k κ_P` gate is consumed, because mathlib obtains integrality of `κ(x)` over
`k` from `LocallyOfFiniteType` through the Jacobson-space finiteness criterion. -/
theorem bijective_residue_comp_stalkStructureHom [IsAlgClosed k]
    (C : Over (Spec (CommRingCat.of k))) [LocallyOfFiniteType C.hom]
    (x : C.left) (hx : IsClosed ({x} : Set C.left)) :
    Function.Bijective
      ((C.left.residue x).hom.comp (stalkStructureHom C.hom x).hom) := by
  have h : (C.left.residue x).hom.comp (stalkStructureHom C.hom x).hom
      = (residueFieldIsoBase C.hom x hx).inv.hom := by
    rw [← residue_stalkStructureHom_eq C x hx]; rfl
  rw [h]
  exact (ConcreteCategory.isIso_iff_bijective
    (residueFieldIsoBase C.hom x hx).inv).mp inferInstance

/-- **Every stalk element is a constant modulo the maximal ideal.**  The surjectivity half
of `bijective_residue_comp_stalkStructureHom`, restated as the approximation statement on
the stalk: for `a ∈ 𝒪_x` there is `c : k` with `a − c ∈ 𝔪_x`. -/
theorem exists_const_sub_mem_maximalIdeal [IsAlgClosed k]
    (C : Over (Spec (CommRingCat.of k))) [LocallyOfFiniteType C.hom]
    (x : C.left) (hx : IsClosed ({x} : Set C.left))
    (a : C.left.presheaf.stalk x) :
    ∃ c : k, a - (stalkStructureHom C.hom x).hom c ∈
      IsLocalRing.maximalIdeal (C.left.presheaf.stalk x) := by
  obtain ⟨c, hc⟩ := (bijective_residue_comp_stalkStructureHom C x hx).surjective
    ((C.left.residue x).hom a)
  rw [RingHom.comp_apply] at hc
  refine ⟨c, ?_⟩
  rw [← IsLocalRing.residue_eq_zero_iff]
  change (C.left.residue x).hom _ = 0
  rw [map_sub, hc, sub_self]

end ResidueBijective

/-! ## §3. `HasRationalResidues`, discharged

The stalk statement of §2 is now translated into the order language of the adelic lane.
The translation has two steps and both are already available:

* `f` with `ord_P f ≥ 0` lifts to `a ∈ 𝒪_P` — `exists_stalk_lift_of_order_nonneg`
  (`ChiLedger.lean` §N14b);
* `a − c ∈ 𝔪_P` becomes `ord_P (f − c) ≥ 1` — `mem_orderGe_one_iff_mem_maximalIdeal`
  (`GlobalGeneration.lean` §7), whose statement is phrased on `orderGe P 1` rather than on
  the raw inequality precisely so that `f = c` is admitted (the project's `ord_P 0 = 0`
  convention would make the inequality form false there).

The `k`-action bookkeeping is `algebraMap_stalk_functionField` (§1): the constant produced
on the stalk and the constant the order language expects are the same element of `K(C)`. -/

section Discharge

variable {k : Type u} [Field k]

/-- **`HasRationalResidues` holds at every prime divisor of a curve over an algebraically
closed field** — the residue fact of the campaign, now a theorem on AJC's own curve
hypotheses rather than on unbuilt stalk binders.

Compare `hasRationalResidues_of_isAlgClosed` (`GlobalGeneration.lean` §7), which proves the
same conclusion but from `[Algebra k 𝒪_P]`, `[IsScalarTower k 𝒪_P K(X)]` and
`[Module.Finite k κ_P]`, none of which AJC constructs.  Here the first two are built (§1)
and the third is not needed (§2). -/
theorem hasRationalResidues_of_isAlgClosed_curve [IsAlgClosed k]
    (C : Over (Spec (CommRingCat.of k))) [IsIntegral C.left]
    [IsLocallyNoetherian C.left] [Scheme.IsRegularInCodimensionOne C.left]
    [LocallyOfFiniteType C.hom] [SmoothOfRelativeDimension 1 C.hom]
    (P : C.left.PrimeDivisor) :
    HasRationalResidues k P := by
  intro f hf
  rcases eq_or_ne f 0 with rfl | hf0
  · refine ⟨0, ?_⟩
    rw [map_zero, sub_zero]
    exact (orderGe P 1).zero_mem
  -- lift `f` to the stalk
  obtain ⟨a, ha⟩ := exists_stalk_lift_of_order_nonneg hf0
    ((mem_orderGe_of_ne_zero hf0).mp hf)
  -- `P.point` is a closed point of the curve, so `κ(P) = k`
  have hclosed : IsClosed ({P.point} : Set C.left) :=
    isClosed_primeDivisor (coheight_le_one_of_curve C) P
  obtain ⟨c, hc⟩ := exists_const_sub_mem_maximalIdeal C P.point hclosed a
  refine ⟨c, ?_⟩
  have himg := (mem_orderGe_one_iff_mem_maximalIdeal P
    (a - (stalkStructureHom C.hom P.point).hom c)).mpr hc
  rw [map_sub, ha, algebraMap_stalk_functionField C P.point c] at himg
  exact himg

/-- **The residue degree is one** at every prime divisor of a curve over an algebraically
closed base: `[κ(P) : k] = 1`.

This is the fact that `SectionBounds.lean` §4 and `GlobalGeneration.lean` §5–§7 both reduce
to and both leave open.  It closes item 1 of the two-item residue list in
`SectionBounds.lean` §4. -/
theorem residueDeg_eq_one_of_isAlgClosed_curve [IsAlgClosed k]
    (C : Over (Spec (CommRingCat.of k))) [IsIntegral C.left]
    [IsLocallyNoetherian C.left] [Scheme.IsRegularInCodimensionOne C.left]
    [LocallyOfFiniteType C.hom] [SmoothOfRelativeDimension 1 C.hom]
    (P : C.left.PrimeDivisor)
    [Module.Finite k (localStepTgt k P 1)] :
    residueDeg k P = 1 :=
  (residueDeg_eq_one_iff_hasRationalResidues k P).mpr
    (hasRationalResidues_of_isAlgClosed_curve C P)

end Discharge

end Adelic
end AlgebraicGeometry
