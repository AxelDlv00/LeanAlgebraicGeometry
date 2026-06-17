/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Genus

/-!
# Weil divisors on a smooth proper curve (RR.1)

This file is the **RR.1** sub-build chapter for the project's headline
`genusZero_curve_iso_P1` (the "smooth proper geom-irred genus-`0` curve over `k̄` is
isomorphic to `ℙ¹`" lemma in `AlgebraicJacobian.AbelianVarietyRigidity`).

Mathlib `b80f227` ships no `WeilDivisor` on a scheme; adjacent pieces
(`MeromorphicOn.divisor`, `CommRing.Pic`, `Scheme.RationalMap`) cover different
ground. This file is therefore **project-bespoke**, scaffolding the formal-sum data
type `Div(X) = ⨁_{Y ⊂ X codim 1} ℤ` on a Noetherian integral scheme `X` satisfying
Hartshorne's condition `(*)`, the principal-divisor homomorphism
`div : K(X)^× → Div(X)` on a curve, the degree map `deg : Div(C) → ℤ` on a smooth
proper curve over an algebraically closed field, the degree-zero of principal divisors
on a complete nonsingular curve (Hartshorne Cor. II.6.10), and the linear-equivalence
relation `D ~ D'`.

## Status (iter-172 file-skeleton)

This file is the **iter-172 Lane C** file-skeleton: each declaration carries the
intended signature (matching the blueprint `\lean{...}` pin) with a `sorry` body.
The bodies are iter-173+ work after the sibling chapters `RR.2`
(`RiemannRoch_RRFormula.tex`), `RR.3` (`RiemannRoch_OcOfD.tex`), and `RR.4`
(`RiemannRoch_RationalIsoP1.tex`) land.

The 9 pinned declarations are:

1. `Scheme.WeilDivisor` — free abelian group on prime divisors (Definition).
2. `Scheme.RationalMap.order` — order of a rational function along a prime divisor.
3. `Scheme.WeilDivisor.ofClosedPoint` — Weil divisor associated to a closed point.
4. `Scheme.WeilDivisor.degree` — degree map over an algebraically closed base.
5. `Scheme.WeilDivisor.degree_hom` — degree is a group homomorphism (Theorem).
6. `Scheme.WeilDivisor.principal` — principal divisor of a rational function.
7. `Scheme.WeilDivisor.principal_hom` — `div` is a group homomorphism (Theorem).
8. `Scheme.WeilDivisor.principal_degree_zero` — `deg ∘ div = 0` on a complete curve.
9. `Scheme.WeilDivisor.LinearEquivalence` — linear equivalence of Weil divisors.

## References

Blueprint: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` (445 LOC, 9 pins).
Hartshorne, *Algebraic Geometry*, II §6 (pp. 130–137 + IV.1 pp. 294–296).
Stacks Project, tags 02RW (divisors), 02ME (order at a point), 0BE0 (degree),
0BE3 (principal divisors have degree zero on a complete nonsingular curve).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-! ## §1. Codim-1 cycle group / Weil divisor group

Hartshorne's condition `(*)` (II §6, p. 130) is: `X` is a Noetherian integral
separated scheme that is regular in codimension one. Under `(*)`, prime divisors
are closed integral subschemes of codimension one, and the local ring at the
generic point of a prime divisor is a DVR with quotient field the function field
`K(X)`.

A prime divisor is encoded by its **generic point** together with the
codimension-one witness `Order.coheight point = 1`: the data field `point : X`
selects the generic point of the closed integral subscheme, and the predicate
field `coheight` enforces codimension one in the specialisation preorder
(Hartshorne II §6 p. 130; blueprint pin `def:prime_divisor`). Integrality of the
closure is automatic, so no separate integrality witness is needed.
-/

/-- A **prime divisor** on a scheme `X`: a closed integral subscheme of codimension
one, encoded (for a scheme satisfying Hartshorne's condition `(*)`) by its generic
point. On a curve, prime divisors correspond bijectively to closed points.

The codimension-one witness is the predicate `Order.coheight point = 1` on the
specialisation preorder of `X.carrier` (Mathlib's convention is
`x ≤ y ↔ y ⤳ x`, so the generic point is the unique maximal element and a
generic point of a codim-1 closed integral subscheme has a length-one chain
above it). The closure `{point}̄` is automatically irreducible (so the reduced
induced subscheme structure is automatically integral); hence no separate
integrality field is needed.

Blueprint reference: `def:prime_divisor` / `def:codim1_cycles` (Hartshorne II §6
p. 130; Stacks 02RW). -/
structure Scheme.PrimeDivisor (X : Scheme.{u}) where
  /-- The generic point of the closed integral subscheme. -/
  point : X
  /-- Codimension-1 witness: `point` has coheight `1` in the specialisation
  preorder on `X.carrier`. Per iter-173 `wd-spec-refine` (`def:prime_divisor`). -/
  coheight : Order.coheight point = 1

/-- The **Weil divisor group** of a scheme `X` satisfying Hartshorne's condition
`(*)`: the free abelian group on the set of prime divisors of `X`,
`Div(X) = ⨁_{Y prime divisor of X} ℤ · Y`. An element `D = Σ nᵢ · Yᵢ` with finitely
many nonzero coefficients is a **Weil divisor**; if all `nᵢ ≥ 0` it is **effective**.

Blueprint reference: `def:codim1_cycles` (Hartshorne II §6 p. 130). -/
def Scheme.WeilDivisor (X : Scheme.{u}) : Type u := X.PrimeDivisor →₀ ℤ

namespace Scheme.WeilDivisor

noncomputable instance (X : Scheme.{u}) : AddCommGroup X.WeilDivisor :=
  inferInstanceAs (AddCommGroup (X.PrimeDivisor →₀ ℤ))

instance (X : Scheme.{u}) : Inhabited X.WeilDivisor :=
  inferInstanceAs (Inhabited (X.PrimeDivisor →₀ ℤ))

end Scheme.WeilDivisor

/-! ## §2. Order of a rational function at a prime divisor

For a scheme `X` satisfying `(*)`, every prime divisor `Y` carries a discrete
valuation `v_Y` on the function field `K(X)`. The order of a nonzero rational
function `f ∈ K(X)^×` along `Y` is the integer `ord_Y(f) := v_Y(f)`. -/

namespace Scheme.RationalMap

/-- **Order of a nonzero rational function `f ∈ K(X)^×` along a prime divisor `Y`.**

For `X` satisfying Hartshorne's `(*)`, the local ring `O_{X,η}` at the generic
point `η` of `Y` is a discrete valuation ring with quotient field the function
field `K(X)`, and `ord_Y(f) = v_Y(f) ∈ ℤ` is the value of the associated normalised
discrete valuation on `f`.

On a smooth proper curve `C` over `k̄`, every closed point `P ∈ C` is a prime
divisor and `ord_P(f) = v_P(f)` is the standard DVR valuation at `P`.

Blueprint reference: `def:order_at_point` (Hartshorne II §6 pp. 130–131; Stacks 02ME).

iter-176 body (per analogist `dvr-rationalmap-order`): the body uses Mathlib's
`Ring.ordFrac` (the canonical `K →*₀ ℤᵐ⁰` monoid-with-zero hom from
`Mathlib.RingTheory.OrderOfVanishing.Basic`, Stacks `02MD`) on the stalk
`X.presheaf.stalk Y.point`, then projects through `WithZero.log : ℤᵐ⁰ → ℤ`
(the canonical projection with junk-on-zero, `Mathlib.Algebra.GroupWithZero.WithZero`).
On `f = 0` this gives `order Y 0 = 0` (junk convention from `WithZero.log_zero`).

The required Mathlib typeclasses on the stalk are:
- `IsNoetherianRing` — from `[IsLocallyNoetherian X]`.
- `IsDomain` ⟹ `Nontrivial` — from `[IsIntegral X]`.
- `IsFractionRing (X.presheaf.stalk Y.point) X.functionField` — from `[IsIntegral X]`.
- `Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)` — threaded explicitly (the
  topological-coheight-to-Krull-dim bridge `Order.coheight Y.point = 1 ⟹
  Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)` is a Mathlib-upstream-pending
  gap; see Stacks `02IZ` / `005X`). -/
noncomputable def order {X : Scheme.{u}} [IsIntegral X]
    [IsLocallyNoetherian X] (Y : X.PrimeDivisor)
    [Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]
    (f : X.functionField) : ℤ :=
  WithZero.log (Ring.ordFrac (X.presheaf.stalk Y.point) f)

end Scheme.RationalMap

/-! ### Regular-in-codimension-one bridge class

Hartshorne's condition `(*)` includes "regular in codimension one", i.e.\ every
prime divisor `Y` of `X` has a DVR stalk `O_{X,Y.point}`. Mathlib has no direct
typeclass for this; we package it as the project-bespoke class
`Scheme.IsRegularInCodimensionOne`, with an instance synthesising the per-`Y`
Krull-dim-≤-1 condition required by `Scheme.RationalMap.order`. Blueprint pin
("Iter-173+ may introduce a `Scheme.IsRegularInCodimensionOne` predicate to
abbreviate this"; chapter `RiemannRoch_WeilDivisor.tex` §2 "Standing hypothesis
`(*)` in the Lean encoding"). -/

/-- Project-bespoke class encoding Hartshorne's "regular in codimension one"
clause of `(*)`: every prime divisor `Y` of `X` has a DVR stalk
`O_{X,Y.point}`. The `[IsIntegral X]` precondition makes
`IsDomain (X.presheaf.stalk Y.point)` available so that the
`IsDiscreteValuationRing` predicate is well-formed
(`AlgebraicGeometry.instIsDomainCarrierStalkCommRingCatPresheafOfIsIntegral`). -/
class Scheme.IsRegularInCodimensionOne (X : Scheme.{u}) [IsIntegral X] : Prop where
  /-- The defining content: every prime divisor's stalk is a discrete valuation
  ring. (This is the precise content of Hartshorne's `(*)`; the weaker
  `Ring.KrullDimLE 1` derives via the `IsDiscreteValuationRing` ⟹
  `IsPrincipalIdealRing` ⟹ `Ring.KrullDimLE 1` chain via the bridge
  instance below.) -/
  out : ∀ Y : Scheme.PrimeDivisor X, IsDiscreteValuationRing (X.presheaf.stalk Y.point)

/-- Bridge instance: from `[Scheme.IsRegularInCodimensionOne X]`, typeclass
synthesis can derive `IsDiscreteValuationRing (X.presheaf.stalk Y.point)` for
every prime divisor `Y`. -/
instance Scheme.IsRegularInCodimensionOne.instIsDiscreteValuationRingStalk
    {X : Scheme.{u}} [IsIntegral X] [Scheme.IsRegularInCodimensionOne X]
    (Y : Scheme.PrimeDivisor X) :
    IsDiscreteValuationRing (X.presheaf.stalk Y.point) :=
  Scheme.IsRegularInCodimensionOne.out Y

/-- Bridge instance: from `[Scheme.IsRegularInCodimensionOne X]`, typeclass
synthesis can derive `Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)` for every
prime divisor `Y`, via the `IsDiscreteValuationRing` ⟹ `IsPrincipalIdealRing`
⟹ `Ring.KrullDimLE 1` chain (Mathlib's `IsDiscreteValuationRing.toIsPrincipalIdealRing`
+ `IsPrincipalIdealRing.krullDimLE_one`). -/
instance Scheme.IsRegularInCodimensionOne.instKrullDimLEStalk
    {X : Scheme.{u}} [IsIntegral X] [Scheme.IsRegularInCodimensionOne X]
    (Y : Scheme.PrimeDivisor X) :
    Ring.KrullDimLE 1 (X.presheaf.stalk Y.point) :=
  haveI : IsDiscreteValuationRing (X.presheaf.stalk Y.point) :=
    Scheme.IsRegularInCodimensionOne.out Y
  haveI : IsPrincipalIdealRing (X.presheaf.stalk Y.point) :=
    IsDiscreteValuationRing.toIsPrincipalIdealRing
  IsPrincipalIdealRing.krullDimLE_one _

/-- **Hartshorne II.6.1**: for a nonzero rational function `f` on a Noetherian
integral scheme `X` satisfying `(*)`, the order function `Y ↦ ord_Y(f)` is
nonzero at only finitely many prime divisors `Y`. This is the well-definedness
side condition for `Scheme.WeilDivisor.principal`.

iter-177 status: this packages Hartshorne's Lemma 6.1, which Mathlib does not
ship. The body is a Mathlib-upstream-pending gap (Stacks tag `02RV` — for a
nonzero element `f ∈ K(X)^×` of a Noetherian integral scheme, only finitely
many height-one primes can divide either numerator or denominator); the proof
factors through `IsLocallyNoetherian X` + the principal-ideal generation of
height-1 primes + the finite irreducible-component decomposition of
`V(f₀) ∪ V(f∞)`. The chapter pins this as a separate sub-build deferral
(`RiemannRoch_WeilDivisor.tex` §5).

The statement is generic in `f` (no `f ≠ 0` hypothesis is threaded): on
`f = 0` the function `Y ↦ ord_Y(0) = WithZero.log 0 = 0` has empty support,
which is finite, so the conclusion holds vacuously. -/
private theorem rationalMap_order_finite_support {X : Scheme.{u}} [IsIntegral X]
    [IsLocallyNoetherian X] [Scheme.IsRegularInCodimensionOne X]
    (f : X.functionField) :
    (Function.support (fun Y : X.PrimeDivisor =>
      Scheme.RationalMap.order Y f)).Finite := by
  -- **iter-192 case split + f = 0 branch closed axiom-clean.**
  --
  -- Case 1 (f = 0): the order function evaluates to
  -- `WithZero.log (Ring.ordFrac _ 0) = WithZero.log 0 = 0` at every
  -- prime divisor, so the support is empty (finite vacuously).
  by_cases hf : f = 0
  · subst hf
    convert Set.finite_empty
    ext Y
    simp only [Function.mem_support, ne_eq, Set.mem_empty_iff_false, iff_false,
      Decidable.not_not, Scheme.RationalMap.order, map_zero, WithZero.log_zero]
  -- Case 2 (f ≠ 0): genuinely needs Hartshorne II.6.1 (Stacks 02RV).
  -- The proof for nonzero `f` requires the substrate
  -- "for a Noetherian integral scheme, only finitely many height-1
  -- primes can divide the numerator or denominator of a nonzero rational
  -- function" — a Mathlib-pending gap noted in the chapter docstring.
  -- Body owed iter-193+; iter-192 closes only the f = 0 vacuous case.
  · sorry

namespace Scheme.WeilDivisor

variable {X : Scheme.{u}}

/-! ## §3. Divisor of a closed point on a curve

On a smooth proper curve `C` over a field, every closed point `P ∈ C` is a prime
divisor (it is closed, integral, of codimension one in the one-dimensional integral
scheme `C`). The associated Weil divisor is `[P] = 1 · P ∈ Div(C)`. -/

/-- **The Weil divisor associated to a closed point `P` on a curve.** The element
`[P] := 1 · P ∈ Div(C)`, i.e. the prime divisor `P` with multiplicity one.

For a smooth proper curve every closed point is automatically a prime divisor (it
is a codimension-one integral closed subscheme of the one-dimensional integral
scheme `C`); conversely every prime divisor on a curve is of this form, so an
arbitrary divisor on `C` is a finite formal `ℤ`-linear combination
`Σ nᵢ · [Pᵢ]` of closed points.

Blueprint reference: `def:divisor_closed_point` (Hartshorne II §6 p. 137).

iter-174 body: the function is junk-defined outside its intended scope. We
case-split on `Order.coheight P = 1` (the codimension-one witness of
`PrimeDivisor`). On the branch where the equality holds — automatic for a
closed point on a one-dimensional integral scheme — we promote `P` to a
`PrimeDivisor` via the witness and return `Finsupp.single ⟨P, h⟩ 1`, i.e.
the prime divisor `P` with multiplicity one. On the off-branch (junk regime)
we return the zero divisor. The blueprint pins the well-definedness argument
"`IsClosed {P}` on a one-dimensional integral scheme ⟹ `coheight P = 1`" as a
separate threadable hypothesis at the call site (chapter L330–L340 "Lean
signature scope"); see `ofClosedPoint_eq_single` for the equation in the
hypothesised regime. -/
noncomputable def ofClosedPoint {C : Scheme.{u}} (P : C)
    (_hP : IsClosed ({P} : Set C)) : C.WeilDivisor :=
  if h : Order.coheight P = 1 then Finsupp.single ⟨P, h⟩ 1 else 0

/-- In the hypothesised regime where the closed point `P` has coheight one
(the codim-1 condition automatic for a closed point of a one-dimensional
integral scheme), `ofClosedPoint P hP` is the prime divisor `P` with
multiplicity one. -/
lemma ofClosedPoint_eq_single {C : Scheme.{u}} (P : C)
    (hP : IsClosed ({P} : Set C)) (h : Order.coheight P = 1) :
    ofClosedPoint P hP = Finsupp.single ⟨P, h⟩ 1 := by
  simp [ofClosedPoint, h]

/-- Off-branch: outside the codim-1 regime, `ofClosedPoint` is junk-defined as
the zero divisor. (Only relevant when the user supplies a "closed point" that
does not have coheight one in the ambient scheme — e.g. a generic point or a
codim-≥2 point on a higher-dimensional scheme.) -/
lemma ofClosedPoint_eq_zero {C : Scheme.{u}} (P : C)
    (hP : IsClosed ({P} : Set C)) (h : Order.coheight P ≠ 1) :
    ofClosedPoint P hP = 0 := by
  simp [ofClosedPoint, h]

/-! ## §4. Degree of a divisor over an algebraically closed base -/

/-- **Degree of a Weil divisor on a smooth proper curve over `k̄`.**

Over an algebraically closed field `k̄`, every closed point of a smooth proper
curve `C` has residue field `k̄`, so each prime divisor `[P]` contributes degree
one to the sum, and `deg(D) := Σᵢ nᵢ` is the sum of the integer coefficients of
the formal sum `D = Σ nᵢ · [Pᵢ]`.

(Over a general field `k` one weights by the residue-field degrees
`Σᵢ nᵢ · [κ(Pᵢ) : k]` to recover the geometric degree; the project's RR bridge
needs only the `k̄` specialisation.)

Blueprint reference: `def:divisor_degree` (Hartshorne II §6 p. 137; Stacks 0BE0).

Implementation: `Finsupp.sum D (fun _ n => n)` is the sum of all coefficients of
the finitely supported function representing `D`. -/
noncomputable def degree (D : X.WeilDivisor) : ℤ :=
  (D : X.PrimeDivisor →₀ ℤ).sum (fun _ n => n)

/-- **The degree map is a group homomorphism `Div(C) → ℤ`.**

`deg(D₁ + D₂) = deg(D₁) + deg(D₂)`, `deg(-D) = -deg(D)`, `deg(0) = 0`. Bundled
as an `AddMonoidHom` for downstream use (the linear-equivalence quotient
`Cl(C) := Div(C) / im(div)` will inherit a `deg : Cl(C) → ℤ` from this).

Blueprint reference: `thm:divisor_degree_hom` (immediate from `def:divisor_degree`).

Implementation: built from `Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)`, the
generic Mathlib packaging that lifts a family of `AddMonoidHom`s indexed by the
support into a single `AddMonoidHom` on the finsupp. Unfolds to
`D.sum (fun _ z ↦ z) = degree D` (see `degree_hom_apply` below). -/
noncomputable def degree_hom : X.WeilDivisor →+ ℤ :=
  Finsupp.liftAddHom (fun _ ↦ AddMonoidHom.id ℤ)

@[simp]
lemma degree_hom_apply (D : X.WeilDivisor) : degree_hom D = degree D :=
  Finsupp.liftAddHom_apply (α := X.PrimeDivisor) (M := ℤ) (N := ℤ)
    (fun _ ↦ AddMonoidHom.id ℤ) D

/-! ## §5. Principal divisors -/

/-- **The principal divisor of a nonzero rational function `f ∈ K(X)^×`.**

By Hartshorne's Lemma 6.1, `ord_Y(f) = 0` for all but finitely many prime
divisors `Y`, so the formal sum
`div(f) := Σ_{Y prime divisor} ord_Y(f) · Y ∈ Div(X)`
has finite support and is a well-defined Weil divisor.

On a smooth proper curve `C` over `k̄`, this specialises to
`div(f) = Σ_{P closed point} ord_P(f) · [P]`.

Blueprint reference: `def:principal_divisor` (Hartshorne II §6 Lemma 6.1 +
following definition, p. 131).

iter-177 body: the construction uses `Finsupp.ofSupportFinite` with the
finite-support witness `rationalMap_order_finite_support`. The latter is a
private theorem packaging Hartshorne 6.1; its body is a Mathlib-pending gap
(see chapter `RiemannRoch_WeilDivisor.tex` §5 sub-build note) and is left as
a `sorry` for an iter-178+ Mathlib-upstream PR. -/
noncomputable def principal [IsIntegral X] [IsLocallyNoetherian X]
    [Scheme.IsRegularInCodimensionOne X] (f : X.functionField)
    (_hf : f ≠ 0) : X.WeilDivisor :=
  Finsupp.ofSupportFinite
    (fun Y : X.PrimeDivisor => Scheme.RationalMap.order Y f)
    (rationalMap_order_finite_support f)

/-- **The coefficient of `principal f hf` at a prime divisor `Y` is the order of
`f` along `Y`.** This is the basic structural unfolding of the
`Finsupp.ofSupportFinite` packaging in `principal`; one-line via
`Finsupp.ofSupportFinite_coe` from `Mathlib.Data.Finsupp.Defs`.

iter-193 substrate helper for the Lane I body close
(`degree_positivePart_principal_eq_finrank`). -/
lemma principal_apply [IsIntegral X] [IsLocallyNoetherian X]
    [Scheme.IsRegularInCodimensionOne X] (f : X.functionField) (hf : f ≠ 0)
    (Y : X.PrimeDivisor) :
    (show (X.PrimeDivisor →₀ ℤ) from principal f hf) Y =
      Scheme.RationalMap.order Y f := by
  change (Finsupp.ofSupportFinite
      (fun Y : X.PrimeDivisor => Scheme.RationalMap.order Y f)
      (rationalMap_order_finite_support f)) Y = _
  rw [Finsupp.ofSupportFinite_coe]

/-- **The principal-divisor map is a group homomorphism `K(X)^× → Div(X)`.**

Concretely `div(fg) = div(f) + div(g)`, `div(f⁻¹) = -div(f)`, `div(1) = 0`. Bundled
as a `MonoidHom` from the multiplicative units of `K(X)` to `Multiplicative (Div(X))`
(equivalently: an additive map `(K(X)^×, ·) → (Div(X), +)`).

Blueprint reference: `thm:principal_hom` (Hartshorne II §6 p. 131).

iter-177 body: closes coordinate-wise from the DVR identities
`v_Y(fg) = v_Y(f) + v_Y(g)`, `v_Y(1) = 0`. The per-`Y` identities live in
`Scheme.RationalMap.order` via `Ring.ordFrac` (a `K →*₀ ℤᵐ⁰` monoid-with-zero
hom) and `WithZero.log_mul` / `WithZero.log_one`. -/
noncomputable def principal_hom [IsIntegral X] [IsLocallyNoetherian X]
    [Scheme.IsRegularInCodimensionOne X] :
    (X.functionField)ˣ →* Multiplicative X.WeilDivisor where
  toFun u :=
    Multiplicative.ofAdd (principal (↑u : X.functionField) (Units.ne_zero u))
  map_one' := by
    -- Goal: Multiplicative.ofAdd (principal ↑1 _) = 1.
    -- Use `← ofAdd_zero` to rewrite RHS as `Multiplicative.ofAdd 0`,
    -- then `congr 1` reduces to `principal ↑1 _ = 0` (Finsupp equality),
    -- and `Finsupp.ext` peels to the per-`Y` coordinate identity, which
    -- closes by unfolding `order` to `WithZero.log (Ring.ordFrac _ 1) = 0`
    -- via `map_one` and `WithZero.log_one`.
    rw [← ofAdd_zero]
    congr 1
    apply Finsupp.ext
    intro Y
    change Scheme.RationalMap.order Y
        (((1 : (X.functionField)ˣ) : X.functionField)) = 0
    rw [Units.val_one]
    unfold Scheme.RationalMap.order
    rw [map_one, WithZero.log_one]
  map_mul' u v := by
    -- Goal: Multiplicative.ofAdd (principal ↑(u*v) _) =
    --       Multiplicative.ofAdd (principal ↑u _) * Multiplicative.ofAdd (principal ↑v _).
    -- Use `← ofAdd_add` to rewrite RHS, then `congr 1` reduces to
    -- `principal ↑(u*v) _ = principal ↑u _ + principal ↑v _` (Finsupp
    -- equality), and `Finsupp.ext` peels to the per-`Y` coordinate
    -- identity `order Y (uv) = order Y u + order Y v`, which closes by
    -- `Ring.ordFrac (uv) = Ring.ordFrac u * Ring.ordFrac v` (`map_mul`)
    -- and `WithZero.log_mul` (the nonzero hypotheses come from
    -- `Units.ne_zero` and `map_ne_zero`).
    rw [← ofAdd_add]
    congr 1
    apply Finsupp.ext
    intro Y
    change Scheme.RationalMap.order Y ((↑(u * v) : X.functionField))
      = Scheme.RationalMap.order Y (↑u : X.functionField)
      + Scheme.RationalMap.order Y (↑v : X.functionField)
    rw [Units.val_mul]
    unfold Scheme.RationalMap.order
    rw [map_mul]
    exact WithZero.log_mul
      ((map_ne_zero _).mpr (Units.ne_zero u))
      ((map_ne_zero _).mpr (Units.ne_zero v))

/-- **Principal divisors on a complete nonsingular curve have degree zero**
(Hartshorne Corollary II.6.10, Stacks 0BE3).

For every nonzero rational function `f ∈ K(C)^×` on a smooth proper curve `C`
over an algebraically closed field `k̄`,
`deg(div(f)) = 0 ∈ ℤ`.

Blueprint reference: `thm:principal_deg_zero` (Hartshorne II.6 Cor. 6.10 p. 138).

The proof (Hartshorne 6.10): if `f ∈ k̄` is constant then `div(f) = 0` and the
claim is trivial. Otherwise the inclusion `k̄(f) ⊂ K(C)` exhibits `K(C)` as a
finite extension of `k̄(f) ≅ k̄(t)`, so the corresponding morphism
`φ : C → ℙ¹_{k̄}` is finite, `div(f) = φ^*([0] - [∞])`, and pullback along a
finite morphism multiplies degree by `deg(φ)`. Two auxiliary sub-lemmas
(finite morphism induced by a non-constant rational function; multiplicativity
of degree under finite pullback, Hartshorne II.6.9) are deferred to follow-up
iters of `RR.1`. -/
theorem principal_degree_zero {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    [IsIntegral C.left] [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    (f : C.left.functionField) (hf : f ≠ 0) :
    degree (principal f hf) = 0 := by
  -- Hartshorne II.6.10 (iter-178 partial). Case-split on whether every
  -- prime-divisor order of `f` vanishes. On a complete nonsingular curve,
  -- this case split exactly recovers Hartshorne's constant-vs-non-constant
  -- split: `(∀ Y, ord_Y f = 0)` ⟺ `f ∈ k̄ \ {0}` (a nowhere-vanishing
  -- rational function on a complete curve is constant; that direction is
  -- Hartshorne II.6.10's "if `f ∈ k̄` then `(f) = 0`").
  by_cases hconst : ∀ Y : C.left.PrimeDivisor, Scheme.RationalMap.order Y f = 0
  · -- Constant branch: every order vanishes ⟹ `principal f hf = 0` ⟹
    -- `degree (principal f hf) = degree 0 = 0`.
    have hprincipal_zero : principal f hf = 0 := by
      apply Finsupp.ext
      intro Y
      change Scheme.RationalMap.order Y f = 0
      exact hconst Y
    rw [hprincipal_zero]
    unfold degree
    exact Finsupp.sum_zero_index
  · -- Non-constant branch (Hartshorne II.6.10 `f ∉ k̄`): the inclusion
    -- `k̄(f) ⊂ K(C)` defines a finite morphism `φ : C → ℙ¹_{k̄}` via the
    -- function-field-determines-curve correspondence (Hartshorne I.6.12),
    -- and `principal f hf = φ^*([0] - [∞])`. Pullback along a finite
    -- morphism of curves multiplies degrees by `deg(φ)` (Hartshorne
    -- II.6.9), so `deg(principal f hf) = deg(φ) · deg([0] - [∞]) =
    -- deg(φ) · 0 = 0`.
    -- This branch is gated on (i) the `φ : C → ℙ¹` construction (Lane 5
    -- `RationalCurveIso.lean:morphismToP1OfGlobalSections`, iter-178+),
    -- and (ii) the degree-multiplicativity-under-finite-pullback bridge
    -- (Hartshorne II.6.9, Mathlib gap).
    sorry

/-! ## §6. Positive part of a Weil divisor

Iter-190 plan-phase Lane I Pin 2 corrective substrate. The carrier
`X.WeilDivisor = X.PrimeDivisor →₀ ℤ` is a finitely supported integer-valued
function on prime divisors; the *positive part* `(D)_0` is obtained by
replacing each coefficient `n_Y` with `max(n_Y, 0)`. Equivalently this is
the lattice join `D ⊔ 0` in the pointwise lattice structure (the
`semilatticeSup` instance on `Finsupp` is noncomputable). The complementary
*negative part* `(D)_∞ := (-D)_0` then gives the canonical decomposition
`D = (D)_0 - (D)_∞` into a difference of effective divisors.

Blueprint reference: `def:WeilDivisor_positivePart` /
`lem:degree_positivePart_principal_eq_finrank` of
`RiemannRoch_WeilDivisor.tex` §6 (iter-190 plan-phase additions).
-/

/-- **Positive part of a Weil divisor**.

`positivePart D` is the divisor obtained from `D` by replacing each
coefficient `n_Y` with `max(n_Y, 0)` (equivalently `D ⊔ 0` in the
pointwise lattice structure on `Finsupp`). For `D = div(f)` on a smooth
proper curve `C`, this recovers the divisor-of-zeros `(f)_0` — the
formal sum of the zeros of `f` with their multiplicities.

The complementary `negativePart D := positivePart (-D)` then gives
`D = positivePart D - negativePart D` as a difference of effective
divisors.

Implementation: `Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp)`, the
generic Mathlib packaging that maps a finsupp's coefficients through a
zero-preserving function. (The `D ⊔ 0` lattice form is equivalent but
requires the noncomputable `Finsupp.semilatticeSup` synthesis on
`PrimeDivisor →₀ ℤ`; the explicit `mapRange` form is more transparent
to typeclass synthesis.)

Blueprint reference: `def:WeilDivisor_positivePart` (project-bespoke;
chapter `RiemannRoch_WeilDivisor.tex` §6, Hartshorne II.6.10 phrasing). -/
noncomputable def positivePart (D : X.WeilDivisor) : X.WeilDivisor :=
  Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp) D

/-- The positive part of the zero divisor is zero. -/
@[simp]
lemma positivePart_zero : positivePart (0 : X.WeilDivisor) = 0 := by
  change Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp)
    (0 : X.PrimeDivisor →₀ ℤ) = (0 : X.PrimeDivisor →₀ ℤ)
  exact Finsupp.mapRange_zero

/-- **Degree of positive part as a sum of capped coefficients.** A purely
symbolic Mathlib manipulation: unfolding `positivePart`
(= `Finsupp.mapRange (max · 0)`) and `degree` (= `Finsupp.sum (fun _ n => n)`)
identifies `degree (positivePart D)` with the sum of `max (D Y) 0` over
the support of `D`.

This is the iter-192 structural-reduction helper consumed by
`degree_positivePart_principal_eq_finrank` below. The proof is one line
via `Finsupp.sum_mapRange_index` from
`Mathlib.Algebra.BigOperators.Finsupp.Basic`. -/
lemma degree_positivePart_eq_sum_max (D : X.WeilDivisor) :
    degree (positivePart D) = D.sum (fun _ n => max n 0) := by
  unfold positivePart degree
  exact Finsupp.sum_mapRange_index (h := fun _ b => b) (by intro _; rfl)

/-- **Positive part of a `Finsupp.single`.** Pointwise extraction of the
mapRange definition of `positivePart`: for a one-point-supported Weil divisor
`Finsupp.single Y n`, the positive part is `Finsupp.single Y (max n 0)`.
A direct consequence of `Finsupp.mapRange_single` (with `max 0 0 = 0` as
the zero-preservation witness).

iter-193 substrate helper paving the way for the Lane I body close. -/
@[simp]
lemma positivePart_single (Y : X.PrimeDivisor) (n : ℤ) :
    positivePart (Finsupp.single Y n : X.WeilDivisor) =
      Finsupp.single Y (max n 0) := by
  change Finsupp.mapRange (fun n : ℤ => n ⊔ 0) (by simp)
      (Finsupp.single Y n) = _
  rw [Finsupp.mapRange_single]
  rfl

/-- **Degree of a `Finsupp.single` Weil divisor.** The degree of the
one-point-supported Weil divisor `Finsupp.single Y n` is `n`. A direct
consequence of `Finsupp.sum_single_index`.

iter-193 substrate helper for `degree_positivePart_principal_eq_finrank`. -/
@[simp]
lemma degree_single (Y : X.PrimeDivisor) (n : ℤ) :
    degree (Finsupp.single Y n : X.WeilDivisor) = n := by
  unfold degree
  change (Finsupp.single Y n : X.PrimeDivisor →₀ ℤ).sum (fun _ n => n) = n
  rw [Finsupp.sum_single_index]

/-- **Sum-over-prime-divisors lower bound via a single contributing point.**
If `f` has order `1` at some prime divisor `Y₀`, then the degree of the positive
part of `principal f hf` is at least `1`.

iter-193 substrate helper consumed by `degree_positivePart_principal_eq_finrank`:
it formalises Step 2 of the Hartshorne II.6.9 recipe (`hlp` produces
the local-parameter prime divisor `Y₀` with coefficient `1`). -/
lemma one_le_degree_positivePart_principal_of_order_one
    [IsIntegral X] [IsLocallyNoetherian X]
    [Scheme.IsRegularInCodimensionOne X]
    (f : X.functionField) (hf : f ≠ 0) (Y₀ : X.PrimeDivisor)
    (h₀ : Scheme.RationalMap.order Y₀ f = 1) :
    1 ≤ degree (positivePart (principal f hf)) := by
  classical
  rw [degree_positivePart_eq_sum_max]
  -- The sum is over a finset; isolate the Y₀ contribution.
  have hY₀_supp :
      Y₀ ∈ (show (X.PrimeDivisor →₀ ℤ) from principal f hf).support := by
    rw [Finsupp.mem_support_iff]
    rw [principal_apply]
    rw [h₀]
    exact one_ne_zero
  -- For the sum to be ≥ 1, isolate the Y₀ term (= 1) and the rest (≥ 0).
  have h_split :
      (show (X.PrimeDivisor →₀ ℤ) from principal f hf).sum
          (fun _ n => max n 0) =
        max ((show (X.PrimeDivisor →₀ ℤ) from principal f hf) Y₀) 0 +
          ((show (X.PrimeDivisor →₀ ℤ) from principal f hf).support.erase Y₀).sum
            (fun Y => max
              ((show (X.PrimeDivisor →₀ ℤ) from principal f hf) Y) 0) := by
    rw [show (show (X.PrimeDivisor →₀ ℤ) from principal f hf).sum
            (fun _ n => max n 0) =
          (show (X.PrimeDivisor →₀ ℤ) from principal f hf).support.sum
            (fun Y => max
              ((show (X.PrimeDivisor →₀ ℤ) from principal f hf) Y) 0)
        from rfl]
    rw [Finset.sum_erase_eq_sub hY₀_supp]
    ring
  rw [h_split]
  -- The Y₀ term equals max 1 0 = 1.
  have hY₀_val :
      (show (X.PrimeDivisor →₀ ℤ) from principal f hf) Y₀ = 1 := by
    rw [principal_apply]; exact h₀
  rw [hY₀_val]
  -- The remainder is a sum of non-negative integers, hence ≥ 0.
  have h_nonneg :
      0 ≤ ((show (X.PrimeDivisor →₀ ℤ) from principal f hf).support.erase Y₀).sum
        (fun Y => max
          ((show (X.PrimeDivisor →₀ ℤ) from principal f hf) Y) 0) :=
    Finset.sum_nonneg (fun Y _ => le_max_right _ _)
  -- Conclude: 1 = max 1 0 ≤ max 1 0 + 0 ≤ LHS + remainder.
  have : (max (1 : ℤ) 0) = 1 := by norm_num
  rw [this]
  linarith

/-- **Hartshorne II.6.9 specialised to `D = [∞]`** — typed-sorry pin (body
iter-191+).

For a smooth proper geometrically irreducible curve `C` over an algebraically
closed field `kbar`, and a finite extension `K → K(C)` of function fields
(arising as the pullback along a non-constant morphism `C → ℙ¹` of the
function field `K(ℙ¹)`), given any non-zero element `t ∈ K` that serves as
a local parameter at `∞ ∈ ℙ¹` (the project's canonical witness being
`(localParameterAtInfty kbar).val`), the degree of the positive part of
the principal divisor of `algebraMap K K(C) t` equals the function-field
extension degree:
\[
  \deg\bigl((\mathrm{div}\,(\varphi^{\#}\,t))_0\bigr)
  \;=\; [K(C) : K] \;=\; \mathrm{Module.finrank}_{K} K(C).
\]
Equivalently, `(div (φ^# t))_0 = φ^*[∞]` and `deg(φ^*[∞]) = deg(φ)`
(Hartshorne II.6.9 specialised at `D = [∞]`).

iter-191 reshape: this theorem is now in **equation form** with `t` and
`halg` taken as explicit parameters, matching the shape required by the
consumer `AlgebraicGeometry.Scheme.Hom.poleDivisor_degree_eq_finrank` in
`RationalCurveIso.lean` (which evaluates at the specific witness
`(localParameterAtInfty kbar).val` rather than at an existentially chosen
one). The previous existential form (`∃ t halg, …`) is now obtained as
the projection of this equation form onto the existence-of-witness
fragment.

Iter-193 fix: added the explicit `hlp` hypothesis encoding the
local-parameter constraint via "order equals `1` at some prime divisor".
Without it the equation is mathematically false (take `K = K(C)` with
`t = 1`: LHS `= 0`, RHS `= 1`). The hypothesis pins `t` to be a
uniformiser at some closed point of `C`, which is precisely what the
chapter prose's affine-chart `Ideal.sum_ramification_inertia` chain
requires to identify `(div(φ^# t))_0 = φ^*[∞]`.

The body (~50-80 LOC owed iter-191+) chains
`Ideal.sum_ramification_inertia` + `Ideal.finrank_quotient_map` on the
Dedekind extension `A → B` at the maximal ideal `m_∞ = (t) ⊂ A`, per
`analogies/ratcurveiso-pin2.md` Decision 2.

Blueprint reference: `lem:degree_positivePart_principal_eq_finrank`
(Hartshorne II.6.9, p. 137; chapter `RiemannRoch_WeilDivisor.tex` §6). -/
theorem degree_positivePart_principal_eq_finrank
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    [IsIntegral C.left] [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    {K : Type u} [Field K] [Algebra K C.left.functionField]
    [Module.Finite K C.left.functionField]
    (t : K)
    (halg : algebraMap K C.left.functionField t ≠ 0)
    (hlp : ∃ Y : C.left.PrimeDivisor,
      Scheme.RationalMap.order Y (algebraMap K C.left.functionField t) = 1) :
    degree (positivePart
      (principal (algebraMap K C.left.functionField t) halg)) =
      (Module.finrank K C.left.functionField : ℤ) := by
  -- **iter-192 structural reduction + body gap documentation.**
  --
  -- Step 1 (DONE, axiom-clean): the helper `degree_positivePart_eq_sum_max`
  -- reduces the LHS to the explicit sum form
  --   `(principal (algebraMap K K(C) t) halg).sum (fun _ n => max n 0)`
  -- which makes the geometric content visible: it is the sum over prime
  -- divisors `Y` of `max (ord_Y (algebraMap K K(C) t)) 0`, i.e. the sum
  -- of orders of vanishing at the zeros of the pulled-back function
  -- (the "zero divisor" `(φ^# t)_0` in classical notation).
  rw [degree_positivePart_eq_sum_max]
  -- Goal:
  --   `(principal (algebraMap K K(C) t) halg).sum (fun _ n => max n 0)
  --     = Module.finrank K K(C)`
  --
  -- Step 2 (GENUINE GAP, body owed iter-193+). This is the Hartshorne
  -- II.6.9 multiplicativity-of-degree-under-finite-pullback identity,
  -- specialised at the divisor `D = [∞]` on `ℙ¹`. The mathematical
  -- proof requires the assumption that `t` is a **local parameter at
  -- the closed point `∞ ∈ ℙ¹_{k̄}`** — equivalently, in `K = K(ℙ¹)`,
  -- the order of `t` at `∞` is `1`. The iter-191 plan-phase signature
  -- reshape (`lane-i-positivepart-clash-fix`) made `t` and `halg`
  -- explicit but did NOT thread an explicit local-parameter hypothesis
  -- through the signature; the soundness condition on `t` is therefore
  -- treated as an implicit obligation discharged at the unique consumer
  -- call site `Hom.poleDivisor_degree_eq_finrank` of
  -- `RiemannRoch/RationalCurveIso.lean`, where the concrete witness
  -- `t = (localParameterAtInfty kbar).val` satisfies the requirement.
  --
  -- The body would chain (per `analogies/ratcurveiso-pin2.md` Decision 2):
  --   (a) Pick an affine open `Spec A ⊂ ℙ¹` containing `∞` with
  --       `A = k̄[t]` and `m_∞ = (t) ⊂ A` the maximal ideal at `∞`.
  --   (b) The preimage `Spec B := φ⁻¹(Spec A) ⊂ C` is affine and
  --       finite over `Spec A` (smooth proper non-constant curve maps);
  --       both `A → B` are Dedekind, `K(B) = K(C)`, `K(A) = K(ℙ¹) = K`.
  --   (c) Apply `Ideal.sum_ramification_inertia` (Mathlib
  --       `NumberTheory.RamificationInertia.Basic`):
  --         `Σ_{Q | m_∞} e(Q | m_∞) · f(Q | m_∞) = [K(C) : K(ℙ¹)]`.
  --   (d) Identify the residue-field degrees `f(Q | m_∞) = 1` (every
  --       closed point of `C` over `k̄` has residue field `k̄`,
  --       Hilbert's Nullstellensatz + smooth proper curve).
  --   (e) Identify each ramification index `e(Q | m_∞)` with the
  --       prime-divisor-order `ord_{Y_Q} (algebraMap K K(C) t)`, where
  --       `Y_Q : C.PrimeDivisor` is the prime divisor corresponding
  --       to `Q ∈ Spec B`. (This requires the scheme-level bridge
  --       `IsDiscreteValuationRing.order_eq_ramificationIdx`, currently
  --       a Mathlib gap — see `analogies/ratcurveiso-pin2.md`.)
  --   (f) The orders at closed points NOT above `∞` are `≥ 0` (because
  --       `t` is regular at those points), and the positive ones are
  --       exactly the points above `∞` (because `t` vanishes ONLY at
  --       `∞`, by the local-parameter hypothesis). Hence
  --         `Σ_Y max(ord_Y(φ^# t), 0) = Σ_{Q | m_∞} e(Q | m_∞) = [K(C):K]`.
  --
  -- The substrate is genuinely missing: (i) the scheme-level "preimage
  -- of an affine open is affine for a finite morphism" lemma in the
  -- φ-induced shape is project-bespoke; (ii) the
  -- `order_eq_ramificationIdx` bridge for scheme-level DVR stalks is
  -- not in Mathlib `b80f227`; (iii) the local-parameter hypothesis
  -- on `t` itself is not in the signature.
  --
  -- **Iter-193 follow-up directive**: dispatch `mathlib-analogist
  -- weildivisor-pin1-ramification-bridge` (the order-vs-ramification
  -- bridge) and refactor this signature to add an explicit
  -- `(hlp : Ring.ordFrac (X.presheaf.stalk infty.point) (algebraMap _ _ t)
  --       = WithZero.coe (Multiplicative.ofAdd (-1 : ℤ)))` (or similar
  -- local-parameter witness), then close axiom-clean.
  sorry

/-! ## §7. Linear equivalence and the divisor class group -/

/-- **Linear equivalence of Weil divisors.**

Two Weil divisors `D, D' ∈ Div(X)` are linearly equivalent, written `D ~ D'`, if
and only if there exists a nonzero rational function `f ∈ K(X)^×` with
`D - D' = div(f) ∈ Div(X)`.

`~` is an equivalence relation (reflexivity from `div(1) = 0`, symmetry from
`div(f⁻¹) = -div(f)`, transitivity from `div(fg) = div(f) + div(g)`, all via
`thm:principal_hom`). The quotient `Cl(X) := Div(X) / im(div)` is the
**divisor class group** of `X`.

On a smooth proper curve `C` over `k̄`, `thm:principal_deg_zero` shows the
degree map descends to `deg : Cl(C) → ℤ`.

Blueprint reference: `def:linear_equivalence` (Hartshorne II §6 p. 131). -/
def LinearEquivalence [IsIntegral X] [IsLocallyNoetherian X]
    [Scheme.IsRegularInCodimensionOne X] (D D' : X.WeilDivisor) : Prop :=
  ∃ (f : X.functionField) (hf : f ≠ 0), D - D' = principal f hf

end Scheme.WeilDivisor

end AlgebraicGeometry
