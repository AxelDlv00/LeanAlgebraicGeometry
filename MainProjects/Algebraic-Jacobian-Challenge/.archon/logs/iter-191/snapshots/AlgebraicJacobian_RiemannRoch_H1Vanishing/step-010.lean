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

universe u

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

/-- **Flasque sheaves have vanishing higher cohomology** (Hartshorne
III.2, Proposition 2.5).

For a topological space `X` and a flasque sheaf `F` of `kbar`-modules on
`X`, the `kbar`-flavoured derived global-sections cohomology
`HModule kbar F i` is the zero `kbar`-module for every `i ≥ 1`. In
particular, `dim_{kbar} HModule kbar F 1 = 0`.

The proof structure mirrors Hartshorne III §2 verbatim: embed `F` into
an injective `I` of the abelian sheaf category, form the quotient short
exact sequence `0 → F → I → G → 0`, observe that `G` inherits
flasqueness from `F` and `I` (the latter by Hartshorne III Lemma 2.4),
read off the short exact sequence on global sections from the flasque
input (Hartshorne II Ex. 1.16(b)), and apply the long exact sequence to
get `HModule kbar F 1 = 0` and a reduction
`HModule kbar F i ≅ HModule kbar G (i - 1)` for `i ≥ 2`; iteration
closes the higher-degree cases.

**iter-191 Lane H file-skeleton** — Tier-3 honest typed sorry; the
substrate inputs (project-side Hartshorne II Ex. 1.16(b)/(c) helpers,
plus the LES carrier for `Abelian.Ext.covariantSequence` at the
`HModule kbar` level) are scheduled across iter-192+ (~150-300 LOC over
~8-12 iters per STRATEGY.md `RR.2.H¹`). Blueprint reference:
`thm:H1_vanishing_flasque`. -/
theorem Scheme.HModule_flasque_eq_zero
    {kbar : Type u} [Field kbar] {X : TopCat.{u}}
    [HasSheafify (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)]
    [HasExt (Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar))]
    {F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} kbar)}
    (hF : Scheme.IsFlasque F) (i : ℕ) (hi : 1 ≤ i) :
    Module.finrank kbar (Scheme.HModule kbar F i) = 0 := by
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
