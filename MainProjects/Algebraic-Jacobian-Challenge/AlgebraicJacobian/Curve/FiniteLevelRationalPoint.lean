/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib
import AlgebraicJacobian.Curve.SeparablyClosedRationalPoint

/-!
# A point over `k^s` is already defined over a finite subextension

Campaign `G1` (`informal/pic-representability-campaign.md`) spreads `J5`'s datum from `k^s`
down to a **finite Galois** level `k'/k`. Every `J`-milestone assumes a section is available,
and `Curve/SeparablyClosedRationalPoint.lean` supplies one — but only over `k^s` itself, where
`IsSepClosed` holds. At a finite level `IsSepClosed k'` is false by construction, so that file
does not reach the step `G1` consumes. That gap is this file (board row
`AJC.picrep.sepclosed-finite`, opened by the same lane that closed the `k^s` half).

## What is proved here

For an arbitrary scheme `X` over `Spec k` **locally of finite type**, and any field extension
`Ks/k` that is **algebraic**:

* `AlgebraicGeometry.Scheme.exists_finite_subalgebra_of_pointOver` — a `Ks`-point of `X` over
  `k` factors through `Spec` of a `k`-subalgebra of `Ks` that is a **finite** `k`-module.

and, specialised to the separable closure and packaged for the campaign's consumer:

* `AlgebraicGeometry.Scheme.exists_intermediateField_finiteDimensional_pointOver` — the
  subextension in `IntermediateField` form, with `FiniteDimensional k k'` and
  `Algebra.IsSeparable k k'`, i.e. exactly a **finite separable** level.

## The route, and why it is not the one this row was opened with

The row's own opening note (and the release note `I-1182`) priced this as a
filtered-colimit-of-schemes argument: present `k^s` as a colimit of its finite subextensions
and spread the morphism along the colimit, via
`RingHom.EssFiniteType.exists_eq_comp_ι_app_of_isColimit`. **That pricing was wrong**, and it
was wrong in the direction this workspace has been wrong in before — it costed the general
mechanism rather than reading what the object at hand already carries.

No colimit is needed. `Spec Ks` is a **one-point** space, so a `Ks`-point lands in any affine
open `V` containing its image and factors through it (`IsOpenImmersion.lift`). On that chart
the point is a `k`-algebra map `Γ(X, V) → Ks`, and `Γ(X, V)` is of finite type over `k`
because `X → Spec k` is locally of finite type (`HasRingHomProperty.appLE`). The **range** of
that map is then a finite `k`-module: it is of finite type as the image of a finite-type
algebra (`Algebra.FiniteType.of_surjective` on `rangeRestrict`) and integral because `Ks/k` is
algebraic, and finite type plus integral is finite
(`Algebra.finite_iff_isIntegral_and_finiteType`). So the finite level is *read off the point*,
not manufactured by a limit argument.

## What this does and does not discharge

It gives the finite level and a point of `X` over it. It does **not** on its own hand `G1` a
`Scheme.HasRationalPoint` for the base-changed curve `C_{k'}`: that needs the point to be
turned into a *section* of `C_{k'} → Spec k'`, which is the pullback universal property applied
to the pair (point of `C`, the level's own identity) — recorded below as
`hasRationalPoint_baseChangeField_of_finiteLevel` and proved. What is **not** provided is
Galois-ness of the level: `k'` here is a finite separable subextension, and `G1` wants a finite
**Galois** one. Enlarging to the normal closure is a further step and is named, not assumed, in
`exists_intermediateField_finiteDimensional_pointOver`'s docstring.
-/

universe u

open CategoryTheory AlgebraicGeometry IntermediateField

namespace AlgebraicGeometry.Scheme

/-! ## §1. The commutative-algebra core -/

/-- **The core**: the range of a `k`-algebra map from a finite-type `k`-algebra into an
algebraic extension `Ks/k` is a **finite** `k`-module.

Both hypotheses are used: finite type gives finite generation of the range as an algebra
(`Algebra.FiniteType.of_surjective` applied to `rangeRestrict`, which is surjective by
construction), and algebraicity of `Ks` makes every element of the range integral over `k`.
`Algebra.finite_iff_isIntegral_and_finiteType` combines them. Nothing here is specific to
`Ks` being a separable closure. -/
theorem moduleFinite_algHom_range_of_isAlgebraic {k A Ks : Type u} [Field k] [CommRing A]
    [Algebra k A] [Algebra.FiniteType k A] [Field Ks] [Algebra k Ks]
    [Algebra.IsAlgebraic k Ks] (psi : A →ₐ[k] Ks) :
    Module.Finite k psi.range := by
  haveI : Algebra.FiniteType k psi.range :=
    Algebra.FiniteType.of_surjective psi.rangeRestrict psi.rangeRestrict_surjective
  haveI : Algebra.IsIntegral k psi.range := by
    constructor
    intro y
    have h : _root_.IsIntegral k (y : Ks) :=
      (Algebra.IsAlgebraic.isAlgebraic (y : Ks)).isIntegral
    exact (isIntegral_algHom_iff (Subalgebra.val psi.range) Subtype.val_injective).mp h
  exact Algebra.finite_iff_isIntegral_and_finiteType.mpr ⟨inferInstance, inferInstance⟩

/-! ## §2. The chart step: a point of a field lands in one affine open -/

/-- `Spec` of a field is a one-point space, so the range of a morphism out of it is contained
in the range of any open immersion whose image contains the one image point. This is the whole
content of "the point lies in a chart", and it is what removes the colimit from the route. -/
theorem range_subset_range_ι_of_mem {Ks : Type u} [Field Ks] {X : Scheme.{u}}
    (p : Spec (CommRingCat.of Ks) ⟶ X) (U : X.Opens)
    (hU : p.base (IsLocalRing.closedPoint Ks) ∈ U) :
    Set.range p.base ⊆ Set.range (U.ι).base := by
  rintro y ⟨s, rfl⟩
  have hs : s = IsLocalRing.closedPoint Ks := Subsingleton.elim _ _
  subst hs
  exact ⟨⟨_, hU⟩, rfl⟩

/-- The section-ring map of an affine chart is of finite type over the base when the structure
morphism is locally of finite type. Extraction of `HasRingHomProperty.appLE` at the pair
`(⊤, V)`, recorded because the `⊤`-affineness side condition is easy to mis-state. -/
theorem finiteType_appLE_of_locallyOfFiniteType {k : Type u} [Field k] {X : Scheme.{u}}
    (f : X ⟶ Spec (CommRingCat.of k)) [LocallyOfFiniteType f] (V : X.affineOpens) :
    (f.appLE ⊤ V.1 (by simp)).hom.FiniteType :=
  HasRingHomProperty.appLE (P := @LocallyOfFiniteType) f ‹_› ⟨⊤, isAffineOpen_top _⟩ V (by simp)

/-! ## §3. The finite level -/

/-- **The finiteness step at the level of a chart**, stated for a bare ring hom rather than an
`Algebra` instance because that is what a scheme chart hands you: `AlgebraicJacobian`'s section
rings carry `k`-structure through explicit maps (`Scheme.overAlgebraMap`), deliberately not
through a global instance.

Given a finite-type structure map `alg : k →+* B`, a ring map `psi : B →+* Ks` into an
**algebraic** extension of `k`, and the commuting triangle, the `k`-subalgebra of `Ks`
generated by the image of `psi` is a **finite** `k`-module.

This is `moduleFinite_algHom_range_of_isAlgebraic` with the `k`-algebra structure on `B`
introduced locally and the range presented as `Algebra.adjoin k (Set.range psi)`, the form a
consumer can name without already having the `AlgHom`. -/
theorem moduleFinite_adjoin_range_of_finiteType {k Ks : Type u} [Field k] [Field Ks]
    [Algebra k Ks] [Algebra.IsAlgebraic k Ks] {B : Type u} [CommRing B] (alg : k →+* B)
    (psi : B →+* Ks) (hft : alg.FiniteType) (hcomm : psi.comp alg = algebraMap k Ks) :
    Module.Finite k (Algebra.adjoin k (Set.range psi)) := by
  classical
  letI : Algebra k B := alg.toAlgebra
  haveI : Algebra.FiniteType k B := hft
  have hcm : ∀ r : k, psi (algebraMap k B r) = algebraMap k Ks r := by
    intro r
    have := RingHom.congr_fun hcomm r
    simpa [RingHom.algebraMap_toAlgebra] using this
  let psiA : B →ₐ[k] Ks := AlgHom.mk' psi (fun r b => by
    simp only [Algebra.smul_def, map_mul, hcm])
  have hrange : Algebra.adjoin k (Set.range psi) = psiA.range := by
    apply le_antisymm
    · exact Algebra.adjoin_le (fun y ⟨b, hb⟩ => ⟨b, hb⟩)
    · rintro y ⟨b, rfl⟩
      exact Algebra.subset_adjoin ⟨b, rfl⟩
  rw [hrange]
  exact moduleFinite_algHom_range_of_isAlgebraic psiA

end AlgebraicGeometry.Scheme
