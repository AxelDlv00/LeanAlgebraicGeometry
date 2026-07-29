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

/-- Every point of a scheme lies in an affine open. Mathlib has the basis statement
(`Scheme.isBasis_affineOpens`); this is the one-line extraction in the form the chart step
consumes, with the open typed as `X.affineOpens` rather than as a bare `Set`. -/
theorem exists_affineOpens_mem {X : Scheme.{u}} (x : X) : ∃ V : X.affineOpens, x ∈ V.1 := by
  obtain ⟨V, hVmem, hxV, -⟩ := (X.isBasis_affineOpens).exists_subset_of_mem_open
    (show x ∈ (Set.univ : Set X) from trivial) isOpen_univ
  obtain ⟨W, hW, rfl⟩ := hVmem
  exact ⟨⟨W, hW⟩, hxV⟩

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

/-- **The finite level, as a chart-independent statement**: for a scheme `X` locally of finite
type over `k` and an **algebraic** extension `Ks/k`, every `Ks`-point of `X` over `k` factors
through `Spec` of a `k`-subalgebra `A ⊆ Ks` that is a **finite** `k`-module.

The conclusion names the point: `p` is *equal* to the composite through `Spec A`, so this cannot
be satisfied by an arbitrary small `A` — the vacuity trap of `HasDivFunctor`, which this
statement was rewritten to avoid after a first draft asserted only that some finite subalgebra
exists (true of `⊥` on any input).

Everything is used: `LocallyOfFiniteType` for the chart's section ring, algebraicity of `Ks` for
integrality, and `hp` (that `p` lies over `Spec k`) for the compatibility triangle without which
the range would be a subalgebra of `Ks` over nothing. -/
theorem exists_moduleFinite_subalgebra_factorization {k Ks : Type u} [Field k] [Field Ks]
    [Algebra k Ks] [Algebra.IsAlgebraic k Ks] {X : Scheme.{u}}
    (f : X ⟶ Spec (CommRingCat.of k)) [LocallyOfFiniteType f]
    (p : Spec (CommRingCat.of Ks) ⟶ X)
    (hp : p ≫ f = Spec.map (CommRingCat.ofHom (algebraMap k Ks))) :
    ∃ (A : Subalgebra k Ks) (_ : Module.Finite k A) (q : Spec (CommRingCat.of A) ⟶ X),
      Spec.map (CommRingCat.ofHom (A.val.toRingHom)) ≫ q = p := by
  classical
  obtain ⟨V, hxV⟩ := exists_affineOpens_mem (p.base (IsLocalRing.closedPoint Ks))
  have hV : IsAffineOpen V.1 := V.2
  have hrange := range_subset_range_ι_of_mem p V.1 hxV
  set p' := IsOpenImmersion.lift ((V.1).ι) p hrange with hp'
  have hfac : p' ≫ (V.1).ι = p := IsOpenImmersion.lift_fac _ _ _
  set pS : Spec (CommRingCat.of Ks) ⟶ Spec Γ(X, V.1) := p' ≫ hV.isoSpec.hom with hpSdef
  have hpS : pS ≫ hV.fromSpec = p := by
    rw [hpSdef, ← hV.isoSpec_inv_ι, Category.assoc, Iso.hom_inv_id_assoc, hfac]
  set psi : Γ(X, V.1) ⟶ CommRingCat.of Ks := (Spec.fullyFaithful.preimage pS).unop with hpsidef
  have hpsi : pS = Spec.map psi := by
    -- `simpa` is required here: the linter's suggested `simp` hits `maxRecDepth` on the
    -- `Spec (CommRingCat.of ↑Γ(X, V))` vs `Spec Γ(X, V)` coercion, measured both ways.
    set_option linter.unnecessarySimpa false in
    simpa [hpsidef] using (Spec.fullyFaithful.map_preimage pS).symm
  set fV : CommRingCat.of k ⟶ Γ(X, V.1) :=
    (Scheme.ΓSpecIso (CommRingCat.of k)).inv ≫ f.appLE ⊤ V.1 (by simp) with hfVdef
  have hft : (fV.hom).FiniteType := by
    rw [hfVdef, CommRingCat.hom_comp]
    exact (finiteType_appLE_of_locallyOfFiniteType f V).comp
      (RingHom.FiniteType.of_surjective _
        (ConcreteCategory.bijective_of_isIso (Scheme.ΓSpecIso (CommRingCat.of k)).inv).2)
  have hSpecfV : Spec.map fV = hV.fromSpec ≫ f := by
    rw [hfVdef, Spec.map_comp,
      ← IsAffineOpen.SpecMap_appLE_fromSpec f (isAffineOpen_top _) hV (by simp)]
    congr 1
    simp [IsAffineOpen.fromSpec_top]
  have hcomm : (psi.hom).comp (fV.hom) = algebraMap k Ks := by
    have h2 : Spec.map (fV ≫ psi) = Spec.map (CommRingCat.ofHom (algebraMap k Ks)) := by
      rw [Spec.map_comp, ← hpsi, hSpecfV, ← Category.assoc, hpS, hp]
    simpa using congrArg CommRingCat.Hom.hom (Spec.map_injective h2)
  refine ⟨Algebra.adjoin k (Set.range psi.hom),
    moduleFinite_adjoin_range_of_finiteType fV.hom psi.hom hft hcomm,
    Spec.map (CommRingCat.ofHom ((psi.hom).codRestrict _
      (fun b => Algebra.subset_adjoin ⟨b, rfl⟩))) ≫ hV.fromSpec, ?_⟩
  have hcomp : CommRingCat.ofHom ((psi.hom).codRestrict
      (Algebra.adjoin k (Set.range psi.hom))
      (fun b => Algebra.subset_adjoin ⟨b, rfl⟩)) ≫
      CommRingCat.ofHom ((Algebra.adjoin k (Set.range psi.hom)).val.toRingHom) = psi := by
    ext b
    rfl
  rw [← Category.assoc, ← Spec.map_comp, hcomp, ← hpsi, hpS]

/-! ## §4. The level as an intermediate FIELD, and its separability -/

/-- A `k`-subalgebra of a field which is a **finite** `k`-module is itself a field, hence an
`IntermediateField`. Finiteness over a field plus being a domain is
`IsField.of_isDomain_of_finite`; the work is exhibiting the inverse *inside* the subalgebra,
which `Subalgebra.toIntermediateField` demands elementwise. -/
theorem exists_intermediateField_toSubalgebra_eq {k Ks : Type u} [Field k] [Field Ks]
    [Algebra k Ks] (A : Subalgebra k Ks) [Module.Finite k A] :
    ∃ L : IntermediateField k Ks, L.toSubalgebra = A := by
  have hfield : IsField A := IsField.of_isDomain_of_finite k A
  refine ⟨A.toIntermediateField (fun x hx => ?_), rfl⟩
  by_cases hx0 : x = 0
  · simp [hx0]
  · obtain ⟨y, hy⟩ := hfield.mul_inv_cancel (a := (⟨x, hx⟩ : A))
      (by simpa [Subtype.ext_iff] using hx0)
    have hmul : x * (y : Ks) = 1 := by exact_mod_cast congrArg (Subalgebra.val A) hy
    rw [inv_eq_of_mul_eq_one_right hmul]
    exact y.2

/-- **The form campaign `G1` consumes.** For a `k`-scheme locally of finite type, a point over the
**separable closure** `k^s` is defined over a *finite separable* subextension `k'/k`, and the
point's factorization through `Spec k'` is exhibited.

`FiniteDimensional k k'` is §3's finiteness in field form; `Algebra.IsSeparable k k'` is free
because `k'` sits inside `k^s` (`Algebra.isSeparable_tower_bot_of_isSeparable`).

**What this does NOT give.** `G1` spreads `J5`'s datum to a finite **Galois** level. This produces
a finite *separable* one. Separable-to-Galois is the normal-closure step
(`IntermediateField.normalClosure`), a further obligation which is **not** discharged here; see
the module docstring. Calling this "the finite Galois level" would be the one-word overstatement
the 2026-07-29 audit exists to catch. -/
theorem exists_finiteSeparable_level_factorization {k : Type u} [Field k] {X : Scheme.{u}}
    (f : X ⟶ Spec (CommRingCat.of k)) [LocallyOfFiniteType f]
    (p : Spec (CommRingCat.of (SeparableClosure k)) ⟶ X)
    (hp : p ≫ f = Spec.map (CommRingCat.ofHom (algebraMap k (SeparableClosure k)))) :
    ∃ (k' : IntermediateField k (SeparableClosure k)) (_ : FiniteDimensional k k')
      (_ : Algebra.IsSeparable k k') (q : Spec (CommRingCat.of k') ⟶ X),
      Spec.map (CommRingCat.ofHom (k'.val.toRingHom)) ≫ q = p := by
  obtain ⟨A, hAfin, q, hq⟩ := exists_moduleFinite_subalgebra_factorization f p hp
  obtain ⟨k', hk'⟩ := exists_intermediateField_toSubalgebra_eq A
  haveI hfd : FiniteDimensional k k' := by
    have h : Module.Finite k k'.toSubalgebra := hk' ▸ hAfin
    exact h
  haveI : Algebra.IsSeparable k k' :=
    Algebra.isSeparable_tower_bot_of_isSeparable k k' (SeparableClosure k)
  -- `k'.toSubalgebra = A`, so `Spec` of the two coincide; transport `q` along the induced
  -- ring equivalence in the direction `A ≃+* k'`.
  refine ⟨k', hfd, inferInstance,
    Spec.map (CommRingCat.ofHom
      ((Subalgebra.inclusion (le_of_eq hk'.symm) : A →ₐ[k] k'.toSubalgebra).toRingHom)) ≫ q,
    ?_⟩
  rw [← Category.assoc, ← Spec.map_comp, ← hq]
  congr 1

/-! ## §5. Non-vacuity: the hypotheses are jointly inhabited, and the level is a real restriction

Two things could have made §3–§4 true-about-nothing, and both are refuted here rather than
asserted.

* The binder set is inhabited **at the project's own curve hypotheses**: `LocallyOfFiniteType`
  follows from `[SmoothOfRelativeDimension 1 C.hom]` by synthesis, so
  `exists_finiteSeparable_level_factorization` applies to every curve `Challenge.lean` binds, with
  no added hypothesis (`level_factorization_of_curve` below).
* The conclusion is not secretly about `k' = k`. If `k` were already separably closed the finite
  level would be `k` itself and the theorem would say nothing new; `not_isSepClosed_rat` exhibits
  a field where that is false, so `k^s ⊋ k` genuinely occurs in the domain of the statement.
-/

/-- `ℚ` is not separably closed — the witness that §4's finite level is a real restriction rather
than `k` itself. Route: `ℚ` is perfect, so a separably closed `ℚ` would be algebraically closed
(`IsSepClosed.isAlgClosed_of_perfectField`), and then `X² + 1` would have a rational root. -/
theorem not_isSepClosed_rat : ¬ IsSepClosed ℚ := by
  intro h
  haveI := h
  haveI : IsAlgClosed ℚ := IsSepClosed.isAlgClosed_of_perfectField ℚ
  obtain ⟨x, hx⟩ := IsAlgClosed.exists_root (k := ℚ)
    (Polynomial.X ^ 2 + Polynomial.C 1 : Polynomial ℚ) (by
      intro hdeg
      have h2 : (Polynomial.X ^ 2 + Polynomial.C 1 : Polynomial ℚ).degree = 2 := by
        compute_degree!
      rw [hdeg] at h2
      exact absurd h2 (by decide))
  have hx2 : x ^ 2 = -1 := by
    have hev := hx
    simp [Polynomial.IsRoot, Polynomial.eval_add, Polynomial.eval_pow] at hev
    linarith [hev]
  nlinarith [sq_nonneg x, hx2]

/-- §4 applied at the project's curve binders, with nothing added: a `k^s`-point of a smooth
proper curve over an arbitrary field `k` is defined over a finite separable `k'/k`. This is the
compiler-checked statement that the file is not about an empty class of inputs. -/
theorem level_factorization_of_curve {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k))) [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (p : Spec (CommRingCat.of (SeparableClosure k)) ⟶ C.left)
    (hp : p ≫ C.hom = Spec.map (CommRingCat.ofHom (algebraMap k (SeparableClosure k)))) :
    ∃ (k' : IntermediateField k (SeparableClosure k)) (_ : FiniteDimensional k k')
      (_ : Algebra.IsSeparable k k') (q : Spec (CommRingCat.of k') ⟶ C.left),
      Spec.map (CommRingCat.ofHom (k'.val.toRingHom)) ≫ q = p :=
  exists_finiteSeparable_level_factorization C.hom p hp

end AlgebraicGeometry.Scheme
