/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.StructureSheafModuleK
import AlgebraicJacobian.RiemannRoch.WeilDivisor

/-!
# Vanishing of `H¹` for skyscraper sheaves on a curve (RR.2.H¹)

This file is the **RR.2.H¹** project-side build of the closed-point
skyscraper `H¹`-vanishing identity

  `dim_{k̄} H¹(C, skyscraperSheaf P (ModuleCat.of k̄ k̄)) = 0`

on a smooth proper geometrically irreducible curve `C / k̄`. The file is
the iter-191 Lane H **file-skeleton**: each of the eight pinned
declarations carries the *intended* substantive type signature (matching
the blueprint `\lean{...}` pin in `chapters/RiemannRoch_H1Vanishing.tex`),
with `sorry` bodies; the iter-192+ closure follows the classical
Hartshorne III.2.5 flasque-vanishing argument.

The chapter strategy (Hartshorne III §2): an injective resolution of a
flasque sheaf yields a flasque quotient at each stage; the
global-sections functor is exact on a flasque-to-flasque-to-flasque
short exact sequence; hence the right-derived global-sections functor
vanishes on a flasque input in positive degree. We specialise the
abstract flasque-vanishing to the closed-point skyscraper sheaf, which
is flasque because it is the pushforward, along the closed embedding of
a one-point subspace, of the constant sheaf on an irreducible base.

## Eight pinned declarations

1. `AlgebraicGeometry.Scheme.IsFlasque` — predicate on
   `Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)`.
2. `AlgebraicGeometry.Scheme.IsFlasque.pushforward` — pushforward of a
   flasque sheaf is flasque (Hartshorne II.1, Ex. 1.16(d)).
3. `AlgebraicGeometry.Scheme.IsFlasque.constant_of_irreducible` —
   constant sheaf on an irreducible space is flasque (Hartshorne
   II.1, Ex. 1.16(a)).
4. `AlgebraicGeometry.Scheme.HModule_flasque_eq_zero` — flasque sheaves
   have zero `HModule` in positive degree (Hartshorne III.2.5).
5. `AlgebraicGeometry.Scheme.skyscraperSheaf_eq_pushforward_const` —
   skyscraper sheaf is the pushforward of a constant sheaf along the
   closed embedding of the closure of the support point.
6. `AlgebraicGeometry.Scheme.PrimeDivisor.closure_isIrreducible` — the
   closure of the support point of a `PrimeDivisor` is irreducible.
7. `AlgebraicGeometry.Scheme.skyscraperSheaf_isFlasque` —
   closed-point skyscraper sheaf is flasque.
8. `AlgebraicGeometry.Scheme.H1_skyscraperSheaf_finrank_eq_zero` — the
   `RR.2.H¹` headline (`dim_{k̄} H¹(C, k(P)) = 0`), obtained by composing
   declarations 4 and 7.

The eighth declaration also lives as a `private` typed-`sorry` helper at
`AlgebraicJacobian/RiemannRoch/RRFormula.lean`. The `private` modifier
mangles the internal name of the RRFormula copy, so the public
declaration in this file is the one resolved by the blueprint's
`\lean{...}` pin and by downstream consumers (`sync_leanok` keys on the
fully-qualified public name).

## References

Blueprint: `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`.
Source: Hartshorne, *Algebraic Geometry*, II.1, Exercise 1.16
(flasque sheaves), Exercise 1.17 (skyscraper sheaves);
III.2, Proposition 2.5 (flasque sheaves are acyclic).
-/

set_option autoImplicit false

universe u v

open CategoryTheory Limits TopologicalSpace TopCat
open scoped AlgebraicGeometry

namespace AlgebraicGeometry

/-! ## §1. Flasque sheaves of `kbar`-modules -/

/-- **Flasque sheaf of `kbar`-modules on a topological space**
(Hartshorne II.1, Exercise 1.16; III.2, paragraph preceding Lemma 2.4).

A sheaf `F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)`
is **flasque** when, for every inclusion of opens `V ≤ U` in `X`, the
restriction map
`F.val.obj (op U) → F.val.obj (op V)` is surjective as a map of
`kbar`-modules.

The predicate is read off the underlying presheaf of `kbar`-modules and
applies uniformly to the project's `ModuleCat kbar`-flavoured cohomology
pipeline (it does not depend on any topological-space hypothesis on `X`,
so the curve specialisation is by instance synthesis on
`C.left.toTopCat`).

Blueprint reference: `def:isFlasque_sheaf`. -/
def Scheme.IsFlasque
    {kbar : Type u} [Field kbar] {X : TopCat.{u}}
    (F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)) : Prop :=
  ∀ ⦃U V : TopologicalSpace.Opens X⦄ (h : V ≤ U),
    Function.Surjective ((F.val.map (homOfLE h).op).hom)

/-- **Pushforward of a flasque sheaf is flasque** (Hartshorne II.1,
Exercise 1.16(d)).

For a continuous map of topological spaces `f : X ⟶ Y` and a flasque
sheaf `F` of `kbar`-modules on `X`, the pushforward sheaf `f _* F` is
flasque on `Y`. The reason is purely formal: the restriction map of
`f _* F` along `V ≤ U` in `Y` is, by definition of pushforward, the
restriction map of `F` along `f ⁻¹ V ≤ f ⁻¹ U` in `X`, which is
surjective by hypothesis on `F`.

**iter-191 Lane H prover dispatch** — closed via the unfolding
`pushforward.map (homOfLE h).op = F.val.map ((Opens.map f).map (homOfLE h)).op`
(by `rfl`), so flasqueness of `F` along `(Opens.map f).map (homOfLE h)` gives
the conclusion. Blueprint reference: `lem:isFlasque_pushforward`. -/
theorem Scheme.IsFlasque.pushforward
    {kbar : Type u} [Field kbar] {X Y : TopCat.{u}} (f : X ⟶ Y)
    {F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)}
    (hF : Scheme.IsFlasque F) :
    Scheme.IsFlasque
      ((TopCat.Sheaf.pushforward (ModuleCat.{u} kbar) f).obj F) := by
  intro U V h
  exact hF ((Opens.map f).map (homOfLE h)).le

/-- **Constant sheaf on an irreducible topological space is flasque**
(Hartshorne II.1, Exercise 1.16(a)).

For an irreducible topological space `X`, every nonempty open is
connected and dense; the constant presheaf `U ↦ A` already satisfies the
sheaf condition, and its restriction maps are the identity on `A` (for
the nonempty branches) and factor through `0` (for the empty branch).

**iter-191 Lane H file-skeleton** — Tier-3 honest typed sorry; closure
is iter-192+. Blueprint reference:
`lem:isFlasque_constant_irreducible`. -/
theorem Scheme.IsFlasque.constant_of_irreducible
    (kbar : Type u) [Field kbar] {X : TopCat.{u}}
    [IrreducibleSpace X] (A : ModuleCat.{u} kbar) :
    Scheme.IsFlasque
      ((constantSheaf (Opens.grothendieckTopology X)
        (ModuleCat.{u} kbar)).obj A) := by
  sorry

/-- **Injective sheaves have vanishing higher cohomology** (axiom-clean
helper, Hartshorne III §1).

For a topological space `X` and an injective object `I` of the
`kbar`-module sheaf category, the `kbar`-flavoured derived
global-sections cohomology `HModule kbar I i` is the zero `kbar`-module
for every `i ≥ 1`. This is immediate from Mathlib's
`HasInjectiveDimensionLT` framework: `Injective I` gives
`HasInjectiveDimensionLT I 1` (Mathlib
`instHasInjectiveDimensionLTOfNatNatOfInjective`), and
`HasInjectiveDimensionLT.subsingleton` yields
`Subsingleton (Abelian.Ext Y I i)` for `i ≥ 1` and any `Y`; specialising
`Y` to the constant sheaf at `kbar` and applying
`Module.finrank_zero_of_subsingleton` closes the goal.

**iter-192 Lane H prover dispatch** — closed axiom-clean. Used as the
`Ext^i(_, I) = 0` input inside the Hartshorne III.2.5 long-exact-sequence
chase for `HModule_flasque_eq_zero` below. -/
theorem Scheme.HModule_injective_finrank_eq_zero
    {kbar : Type u} [Field kbar] {X : TopCat.{u}}
    [HasSheafify (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)]
    [HasExt (Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar))]
    {I : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)}
    [Injective I] (i : ℕ) (hi : 1 ≤ i) :
    Module.finrank kbar (Scheme.HModule kbar I i) = 0 := by
  have hsub : Subsingleton (Scheme.HModule kbar I i) :=
    HasInjectiveDimensionLT.subsingleton I 1 i hi _
  exact Module.finrank_zero_of_subsingleton

/-- **The canonical injective-embedding short exact sequence**
`0 → F → Injective.under F → cokernel(Injective.ι F) → 0` of sheaves of
`kbar`-modules (axiom-clean helper). The embedding `Injective.ι F` is
mono by `Injective.ι_mono`, the cokernel projection is epi by
construction, and the middle row is exact at `Injective.under F` by
`ShortComplex.exact_cokernel`. -/
noncomputable def Scheme.injectiveSES
    {kbar : Type u} [Field kbar] {X : TopCat.{u}}
    [HasSheafify (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)]
    [HasExt (Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar))]
    (F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)) :
    CategoryTheory.ShortComplex
      (Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)) :=
  ShortComplex.mk (Injective.ι F) (Limits.cokernel.π (Injective.ι F))
    (Limits.cokernel.condition (Injective.ι F))

/-- The injective-embedding short complex is short exact. -/
theorem Scheme.injectiveSES_shortExact
    {kbar : Type u} [Field kbar] {X : TopCat.{u}}
    [HasSheafify (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)]
    [HasExt (Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar))]
    (F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)) :
    (Scheme.injectiveSES F).ShortExact :=
  { exact := ShortComplex.exact_cokernel (Injective.ι F)
    mono_f := Injective.ι_mono F
    epi_g := Limits.coequalizer.π_epi }

/-- **Generic LES vanishing lemma**: in an abelian category with enough Ext,
if `0 → S.X₁ → S.X₂ → S.X₃ → 0` is short exact with `S.X₂` injective and the
post-composition `Hom(X, S.X₂) → Hom(X, S.X₃)` is surjective, then
`Ext X S.X₁ 1` is the zero `Subsingleton`.

This is the structural skeleton of the Hartshorne III.2.5 argument
specialised at degree 1: the long exact sequence
`Ext X S.X₂ 0 → Ext X S.X₃ 0 → Ext X S.X₁ 1 → Ext X S.X₂ 1`
collapses because the rightmost term vanishes (injectivity of `S.X₂`)
and the leftmost map is surjective by the `Hom`-level hypothesis. The
proof composes:
- `HasInjectiveDimensionLT.subsingleton` (injective ⇒ `Ext X S.X₂ 1 = 0`).
- `Abelian.Ext.covariant_sequence_exact₁` (any `x₁ ∈ Ext X S.X₁ 1` lifts
  to some `x₃ ∈ Ext X S.X₃ 0` via the connecting morphism).
- `Abelian.Ext.addEquiv₀` (identifies `Ext X S.X₃ 0` with `Hom(X, S.X₃)`).
- `comp_extClass_assoc` (the LES "complex" identity used to discharge
  `(Ext.mk₀ S.g).comp extClass = 0`).

**iter-192 Lane H prover dispatch** — closed axiom-clean. Used to peel
off the `i = 1` case of `HModule_flasque_eq_zero` once the
`Hom(X, I) → Hom(X, G)`-surjectivity input (Hartshorne II Ex. 1.16(b))
is supplied for an injective resolution. -/
theorem ext_one_eq_zero_of_hom_surjective_of_injective
    {C : Type v} [Category.{u} C] [Abelian C] [HasExt C]
    (X : C) {S : ShortComplex C} (hS : S.ShortExact) [Injective S.X₂]
    (hsurj : Function.Surjective (fun (f : X ⟶ S.X₂) => f ≫ S.g))
    (x₁ : Abelian.Ext X S.X₁ 1) : x₁ = 0 := by
  have hinj_subs : Subsingleton (Abelian.Ext X S.X₂ 1) :=
    HasInjectiveDimensionLT.subsingleton S.X₂ 1 1 le_rfl _
  have hker : x₁.comp (Abelian.Ext.mk₀ S.f) (show (1 : ℕ) + 0 = 1 by omega) = 0 :=
    Subsingleton.elim _ _
  obtain ⟨x₃, hx₃⟩ :=
    Abelian.Ext.covariant_sequence_exact₁ X hS x₁ hker
      (n₀ := 0) (show 0 + 1 = 1 by omega)
  obtain ⟨y, hy⟩ := hsurj (Abelian.Ext.addEquiv₀ x₃)
  simp only at hy
  have hx3eq : Abelian.Ext.mk₀ (Abelian.Ext.addEquiv₀ x₃) = x₃ := by
    rw [← Abelian.Ext.addEquiv₀_symm_apply, AddEquiv.symm_apply_apply]
  have hx3_factored :
      x₃ = (Abelian.Ext.mk₀ y).comp (Abelian.Ext.mk₀ S.g)
        (show (0 : ℕ) + 0 = 0 by omega) := by
    rw [Abelian.Ext.mk₀_comp_mk₀, hy, hx3eq]
  rw [← hx₃, hx3_factored]
  rw [Abelian.Ext.comp_assoc (Abelian.Ext.mk₀ y) (Abelian.Ext.mk₀ S.g) hS.extClass
      (show (0 : ℕ) + 0 = 0 by omega) (show (0 : ℕ) + 1 = 1 by omega)
      (show (0 : ℕ) + 0 + 1 = 1 by omega)]
  have hSg_extClass_zero :
      (Abelian.Ext.mk₀ S.g).comp hS.extClass (show (0 : ℕ) + 1 = 1 by omega) = 0 := by
    have key := hS.comp_extClass_assoc (Y := S.X₁) (n := 0)
      (Abelian.Ext.mk₀ (𝟙 S.X₁)) (n' := 1) (h := show (1 : ℕ) + 0 = 1 by omega)
    rw [Abelian.Ext.comp_mk₀_id] at key
    exact key
  rw [hSg_extClass_zero, Abelian.Ext.comp_zero]

/-- **Flasque sheaves have vanishing higher cohomology** (Hartshorne
III.2, Proposition 2.5).

For a topological space `X` and a flasque sheaf `F` of `kbar`-modules on
`X`, the `kbar`-flavoured derived global-sections cohomology
`HModule kbar F i` is the zero `kbar`-module for every `i ≥ 1`. In
particular, `dim_{kbar} HModule kbar F 1 = 0`.

The proof structure mirrors Hartshorne III §2 verbatim: embed `F` into
an injective `I` of the abelian sheaf category, form the quotient short
exact sequence `0 → F → I → G → 0` (Mathlib: `Scheme.injectiveSES`,
axiom-clean), observe that `G` inherits flasqueness from `F` and `I`
(the latter by Hartshorne III Lemma 2.4), read off the short exact
sequence on global sections from the flasque input
(Hartshorne II Ex. 1.16(b)), and apply the long exact sequence
(`Abelian.Ext.covariant_sequence_exact₁`) to get `HModule kbar F 1 = 0`
and a reduction `HModule kbar F i ≅ HModule kbar G (i - 1)` for `i ≥ 2`;
iteration closes the higher-degree cases.

**iter-192 Lane H prover dispatch** — partial structural progress:
helpers `HModule_injective_finrank_eq_zero` (Ext of injective vanishes,
axiom-clean), `injectiveSES` and `injectiveSES_shortExact` (canonical
SES for `Injective.under`, axiom-clean) all landed. The full body still
requires the project-side Hartshorne II Ex. 1.16(b) and (c) inputs:
(b) `Γ(X, F) → Γ(X, I) → Γ(X, G) → 0` is exact when F is flasque,
(c) `G = cokernel(F → I)` is flasque when both `F` and `I` are flasque.
Both inputs are scheduled across iter-193+ via the `mathlib-build`
dispatch chain (~150-200 LOC each).

Blueprint reference: `thm:H1_vanishing_flasque`. -/
theorem Scheme.HModule_flasque_eq_zero
    {kbar : Type u} [Field kbar] {X : TopCat.{u}}
    [HasSheafify (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)]
    [HasExt (Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar))]
    {F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)}
    (hF : Scheme.IsFlasque F) (i : ℕ) (hi : 1 ≤ i) :
    Module.finrank kbar (Scheme.HModule kbar F i) = 0 := by
  -- Setup: the canonical SES `0 → F → Injective.under F → G → 0`
  -- with `G := cokernel(Injective.ι F)` (axiom-clean via `injectiveSES`).
  set S := Scheme.injectiveSES F with hS_def
  have hSE : S.ShortExact := Scheme.injectiveSES_shortExact F
  -- The proof splits on `i = 1` vs `i ≥ 2`.
  rcases Nat.lt_or_ge i 2 with hi1 | hi2
  · -- `i = 1` case
    interval_cases i
    -- Apply the generic conditional LES helper `ext_one_eq_zero_of_hom_surjective_of_injective`.
    -- The remaining input is the Hartshorne II Ex. 1.16(b) substrate:
    -- `Hom(constant_sheaf, S.X₂) → Hom(constant_sheaf, S.X₃)` (i.e.
    -- `Γ(X, I) → Γ(X, G)`) surjective when `F` is flasque.
    have hsubs : Subsingleton (Scheme.HModule kbar F 1) := by
      constructor
      intro x y
      have hx : x = 0 :=
        ext_one_eq_zero_of_hom_surjective_of_injective
          (S := S) (hS := hSE) _ (by
            -- 1.16(b): `Γ(X, I) → Γ(X, G)` is surjective when `F` is flasque.
            -- This is the project-side missing input (iter-193+).
            sorry) x
      have hy : y = 0 :=
        ext_one_eq_zero_of_hom_surjective_of_injective
          (S := S) (hS := hSE) _ (by sorry) y
      simp [hx, hy]
    exact Module.finrank_zero_of_subsingleton
  · -- `i ≥ 2` case: by induction, using `HModule kbar F i ≃ HModule kbar G (i - 1)`
    -- The relation requires G being flasque (Hartshorne II Ex. 1.16(c))
    -- and the LES `Ext I (i-1) → Ext G (i-1) → Ext F i → Ext I i`
    -- with both Ext I i and Ext I (i-1) vanishing (injective).
    -- For i = 2: Ext F 2 = Ext G 1 = 0 by IH on flasque G.
    -- (Structural typed-sorry; the inductive content requires 1.16(c).)
    sorry

/-! ## §2. Skyscraper sheaves are flasque -/

/-- **Skyscraper sheaf as pushforward of a constant sheaf** (Hartshorne
II.1, Exercise 1.17).

The closed-point skyscraper sheaf `skyscraperSheaf P A` on a topological
space `X` is naturally isomorphic to the pushforward, along the constant
map `PUnit → X` at `P`, of the constant sheaf with value `A` on
`PUnit`. The constant sheaf on `PUnit` is itself isomorphic to the
skyscraper sheaf at `PUnit.unit`, so this is the sheaf-level
counterpart of Mathlib's presheaf-level
`skyscraperPresheaf_eq_pushforward` (Mathlib snapshot `b80f227`
`Topology/Sheaves/Skyscraper.lean`).

For our usage on a curve, `PUnit` plays the role of `closure {P}`
(which on a Noetherian space with `P` closed is a singleton, hence
homeomorphic to `PUnit`).

**iter-191 Lane H file-skeleton** — Tier-3 honest typed sorry; closure
is iter-192+. Blueprint reference:
`lem:skyscraperSheaf_eq_pushforward`. -/
theorem Scheme.skyscraperSheaf_eq_pushforward_const
    (kbar : Type u) [Field kbar]
    {X : TopCat.{u}} (P : X)
    [∀ U : TopologicalSpace.Opens X, Decidable (P ∈ U)]
    [∀ U : TopologicalSpace.Opens (TopCat.of PUnit.{u + 1}),
      Decidable (PUnit.unit ∈ U)]
    (A : ModuleCat.{u} kbar) :
    Nonempty
      (skyscraperSheaf (C := ModuleCat.{u} kbar) P A ≅
        (TopCat.Sheaf.pushforward (ModuleCat.{u} kbar)
            (TopCat.ofHom (ContinuousMap.const (TopCat.of PUnit.{u + 1}) P))).obj
          ((constantSheaf
              (Opens.grothendieckTopology (TopCat.of PUnit.{u + 1}))
              (ModuleCat.{u} kbar)).obj A)) := by
  sorry

/-- **Closure of the support point of a `PrimeDivisor` is irreducible**.

For any scheme `X` and any `P : X.PrimeDivisor`, the topological
closure of the singleton `{P.point}` is an irreducible subset of `X`.
This is a project-bespoke ancillary that holds in full generality: the
closure of any irreducible set in a topological space is irreducible,
and a singleton `{x}` is irreducible (it is nonempty and contains no
proper non-empty closed subsets).

**iter-191 Lane H prover dispatch** — closed via
`isIrreducible_singleton.closure`. Blueprint reference:
`lem:closedPoint_closure_irreducible`. -/
theorem Scheme.PrimeDivisor.closure_isIrreducible
    {X : Scheme.{u}} (P : X.PrimeDivisor) :
    IsIrreducible (closure ({P.point} : Set X)) :=
  isIrreducible_singleton.closure

/-- **The closed-point skyscraper sheaf is flasque**.

For a smooth proper geometrically irreducible curve `C / kbar` and a
prime divisor `P : C.left.PrimeDivisor` (equivalently, a closed point
on the curve), the closed-point skyscraper sheaf
`skyscraperSheaf P.point (ModuleCat.of kbar kbar)` is flasque as a
sheaf of `kbar`-modules on the underlying topological space of `C`.

The proof originally was planned to compose the four lemma-blocks of this
chapter (`skyscraperSheaf_eq_pushforward_const`,
`PrimeDivisor.closure_isIrreducible`, `IsFlasque.constant_of_irreducible`,
`IsFlasque.pushforward`). The iter-191 prover dispatch takes a more direct
route: unfold `skyscraperSheaf.val = skyscraperPresheaf`, then on the
`p ∈ V` branch the restriction map is an `eqToHom` (hence iso, hence
surjective in `ConcreteCategory`); on the `p ∉ V` branch the codomain is
the terminal object of `ModuleCat kbar`, which is the zero object, hence
`Subsingleton` on the underlying type. Either branch closes the
`Function.Surjective` obligation. This bypasses (3) and (5).

**iter-191 Lane H prover dispatch** — closed directly via
`skyscraperPresheaf_map`. Blueprint reference:
`lem:skyscraperSheaf_isFlasque`. -/
theorem Scheme.skyscraperSheaf_isFlasque
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (P : C.left.PrimeDivisor)
    [∀ U : TopologicalSpace.Opens C.left, Decidable (P.point ∈ U)] :
    Scheme.IsFlasque
      (skyscraperSheaf (C := ModuleCat.{u} kbar) P.point
        (ModuleCat.of kbar kbar)) := by
  intro U V h
  change Function.Surjective
    (((skyscraperPresheaf P.point (ModuleCat.of kbar kbar)).map
      (homOfLE h).op).hom)
  by_cases hV : P.point ∈ V
  · -- restriction is `eqToHom`, hence an iso, hence surjective
    have heq : (skyscraperPresheaf P.point (ModuleCat.of kbar kbar)).obj
        (Opposite.op U) =
        (skyscraperPresheaf P.point (ModuleCat.of kbar kbar)).obj
        (Opposite.op V) := by
      simp [skyscraperPresheaf, h hV, hV]
    have hmap := skyscraperPresheaf_map P.point (ModuleCat.of kbar kbar)
      (i := (homOfLE h).op)
    rw [dif_pos hV] at hmap
    rw [hmap]
    have : IsIso (eqToHom heq) := inferInstance
    exact (ConcreteCategory.bijective_of_isIso (eqToHom heq)).2
  · -- codomain is zero (terminal in ModuleCat), so surjective trivially
    have hzero : Limits.IsZero
        ((skyscraperPresheaf P.point (ModuleCat.of kbar kbar)).obj
          (Opposite.op V)) := by
      simp [skyscraperPresheaf, hV]
      exact (terminalIsTerminal).isZero
    have : Subsingleton ((skyscraperPresheaf P.point
        (ModuleCat.of kbar kbar)).obj (Opposite.op V)) :=
      ModuleCat.subsingleton_of_isZero hzero
    intro y; exact ⟨0, Subsingleton.elim _ _⟩

/-! ## §3. The closed-point skyscraper sheaf has vanishing `H¹` -/

/-- **`H¹` of the closed-point skyscraper sheaf vanishes** (Hartshorne
III.2.5 applied to the flasque skyscraper).

For a smooth proper geometrically irreducible curve `C / kbar` and a
prime divisor `P : C.left.PrimeDivisor` (a closed point on the curve),
`dim_{kbar} H¹(C, skyscraperSheaf P (ModuleCat.of kbar kbar)) = 0`.

The proof composes the two substrate inputs of this chapter:
`skyscraperSheaf_isFlasque` (the skyscraper sheaf is flasque) and
`HModule_flasque_eq_zero` at `i = 1` (flasque ⇒ `H¹ = 0`); then
`Module.finrank kbar 0 = 0` closes the dimension identity.

**iter-191 Lane H prover dispatch** — closed via composition of
`HModule_flasque_eq_zero` (still typed-`sorry` pending iter-192+
Hartshorne III.2.5 closure) and `skyscraperSheaf_isFlasque` (now closed
directly in this file) at `i = 1`. The same name also occurs as a
`private` typed-`sorry` helper at
`AlgebraicJacobian/RiemannRoch/RRFormula.lean`; the `private` modifier
mangles that copy's internal name, so the public name resolved by the
blueprint's `\lean{...}` pin (and by `sync_leanok`) is the declaration
below. Blueprint reference:
`lem:H1_skyscraperSheaf_finrank_eq_zero_main`. -/
theorem Scheme.H1_skyscraperSheaf_finrank_eq_zero
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (P : C.left.PrimeDivisor)
    [∀ U : TopologicalSpace.Opens C.left, Decidable (P.point ∈ U)] :
    Module.finrank kbar
        (Scheme.HModule kbar
          (skyscraperSheaf (C := ModuleCat.{u} kbar) P.point
            (ModuleCat.of kbar kbar)) 1) = 0 :=
  Scheme.HModule_flasque_eq_zero (Scheme.skyscraperSheaf_isFlasque C P) 1 le_rfl

end AlgebraicGeometry
