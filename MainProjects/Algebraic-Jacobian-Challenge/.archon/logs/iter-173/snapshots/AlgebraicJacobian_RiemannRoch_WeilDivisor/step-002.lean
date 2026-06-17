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

For the skeleton we encode a prime divisor by its **generic point** together with
a stub witness for the codimension-one + integrality property; this is the
standard equivalence (Hartshorne II §6 p. 130: "let `η ∈ Y` be its generic point...
the local ring `O_{η,X}` is a discrete valuation ring"). The skeleton's
`isCodim1AndIntegral` field is a placeholder `True` that iter-173+ will refine to
the genuine `Order.coheight x = 1 ∧ IsIntegral (X.closedSubschemeOfPoint x)`
once those notions are extracted; the data field `point` is the substantive one.
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

iter-173+: the body extracts the DVR `O_{X,η}` (from `(*)` regularity), reads off the
`addVal` (`IsDiscreteValuationRing.addVal : R → ℕ∞`), extends it to the fraction field
`K(X)`, and produces an `ℤ`-valued valuation on `K(X)^×`. -/
noncomputable def order {X : Scheme.{u}} [IsIntegral X] (Y : X.PrimeDivisor)
    (f : X.functionField) : ℤ :=
  sorry

end Scheme.RationalMap

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

iter-173+: the body promotes the closed point `P` to a `PrimeDivisor` (using the
curve-specific closed-point ↔ prime-divisor bijection) and emits
`Finsupp.single _ 1`. -/
noncomputable def ofClosedPoint {C : Scheme.{u}} (P : C)
    (_hP : IsClosed ({P} : Set C)) : C.WeilDivisor :=
  sorry

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

iter-173+: the body invokes Hartshorne 6.1 for the finite-support side condition,
then materialises the `Finsupp` whose value at each prime divisor `Y` is
`Scheme.RationalMap.order Y f`. -/
noncomputable def principal [IsIntegral X] (f : X.functionField)
    (_hf : f ≠ 0) : X.WeilDivisor :=
  sorry

/-- **The principal-divisor map is a group homomorphism `K(X)^× → Div(X)`.**

Concretely `div(fg) = div(f) + div(g)`, `div(f⁻¹) = -div(f)`, `div(1) = 0`. Bundled
as a `MonoidHom` from the multiplicative units of `K(X)` to `Multiplicative (Div(X))`
(equivalently: an additive map `(K(X)^×, ·) → (Div(X), +)`).

Blueprint reference: `thm:principal_hom` (Hartshorne II §6 p. 131).

iter-173+: closes coordinate-wise from the DVR identities `v_Y(fg) = v_Y(f) + v_Y(g)`,
`v_Y(f⁻¹) = -v_Y(f)`, `v_Y(1) = 0` (`AddValuation.map_add`, etc.), summing over the
union of supports. -/
noncomputable def principal_hom [IsIntegral X] :
    (X.functionField)ˣ →* Multiplicative X.WeilDivisor :=
  sorry

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
    [IsIntegral C.left] (f : C.left.functionField) (hf : f ≠ 0) :
    degree (principal f hf) = 0 :=
  sorry

/-! ## §6. Linear equivalence and the divisor class group -/

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
def LinearEquivalence [IsIntegral X] (D D' : X.WeilDivisor) : Prop :=
  ∃ (f : X.functionField) (hf : f ≠ 0), D - D' = principal f hf

end Scheme.WeilDivisor

end AlgebraicGeometry
