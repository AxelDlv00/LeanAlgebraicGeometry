/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Genus
import AlgebraicJacobian.RiemannRoch.WeilDivisor

/-!
# The line bundle `𝒪_C(P)` of a closed point and its global sections (RR.3)

This file is the **RR.3** sub-build chapter for the project's headline
`genusZero_curve_iso_P1` (the "smooth proper geometrically irreducible
genus-`0` curve over `k̄` is isomorphic to `ℙ¹`" lemma in
`AlgebraicJacobian.AbelianVarietyRigidity`).

The Hartshorne IV.1.3.5 chain for the genus-`0` ↦ `ℙ¹` classification routes
through:

- `RR.1` (`WeilDivisor.lean`): the Weil divisor group `Div(C)` and the
  degree map `deg : Div(C) → ℤ`.
- `RR.2` (`RRFormula.lean`): the Euler-characteristic identity
  `χ(𝒪_C(D)) = deg(D) + 1 − g` and the Riemann–Roch dimension formula
  `ℓ(D) = deg(D) + 1` in genus `0`.
- **`RR.3` (this file)**: the invertible sheaf `𝒪_C(P)` of a closed point
  `P ∈ C`, its `k̄`-vector space of global sections as the
  Riemann–Roch space `L([P])`, the `H¹`-vanishing
  `H¹(C, 𝒪_C(P)) = 0` on a genus-`0` curve, the dimension formula
  `dim_{k̄} H⁰(C, 𝒪_C(P)) = 2`, and the existence of a non-constant
  rational function `f ∈ K(C)` with at most a simple pole at `P`.
- `RR.4` (`RationalCurveIso.lean`, future): the "two-section
  ⇒ `Proj.fromOfGlobalSections` ⇒ `≅ ℙ¹`" classification.

## Status (iter-183 Lane A — sig amend + carrierSet scaffold)

Iter-183 Lane A (re-dispatch from iter-182 deferral) landed:

1. **Sig amend** `lineBundleAtClosedPoint` and `toFunctionField` now take
   the codimension-one witness `(hPcoh : Order.coheight P = 1)` explicitly,
   so the subsheaf-of-`K_C` carrier can read off the order at `P` via the
   prime divisor `⟨P, hPcoh⟩`. The amend matches the blueprint chapter prose
   for the Hartshorne subsheaf-of-`K_C` direct construction (per analogist
   `ocofp-sheaf-internalhom.md`, Decision 3 + Decision 4 verdict
   `ALIGN_WITH_MATHLIB`).
2. **Scaffold** `lineBundleAtClosedPoint.carrierSet` (concrete `Set`-valued
   substantive carrier — the set of rational functions with the order
   conditions on a given open). This is iter-183's substantive
   contribution beyond the sig amend; no new `sorry` introduced.
3. The bodies of `lineBundleAtClosedPoint` (L140) and `toFunctionField`
   (L154) remain typed `sorry` for iter-184+ (the full chain
   `carrierSet → carrierSubmodule (Submodule) → presheaf (Functor) →
   isSheaf (typed sorry) → Sheaf` is ~230-360 LOC; iter-183's helper
   budget = 5 and `sorry` ceiling = 7 forced PARTIAL).

The 5 pinned declarations are:

1. `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint` — the invertible
   sheaf `𝒪_C(P)` associated to a closed point `P` on a smooth proper
   curve `C / k̄`.
2. `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.globalSections_iff`
   — the identification of global sections of `𝒪_C(P)` with the
   Riemann–Roch space
   `L([P]) = {f ∈ K(C)^× | div(f) + [P] ≥ 0} ∪ {0}`,
   expressed as an `Iff`-style characterisation of the order conditions
   `ord_Q(f) ≥ 0` for `Q ≠ P` and `ord_P(f) ≥ −1`.
3. `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.h1_vanishing_genusZero`
   — the cohomological vanishing `H¹(C, 𝒪_C(P)) = 0` on a smooth proper
   geometrically irreducible curve `C / k̄` with `g(C) = 0`, via the long
   exact sequence of the closed-point short exact sequence
   `0 → 𝒪_C → 𝒪_C(P) → k(P) → 0`.
4. `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.dim_eq_two_of_genusZero`
   — the dimension formula `dim_{k̄} H⁰(C, 𝒪_C(P)) = 2` in genus `0`,
   specialising the χ-identity `RR.2` to `D = [P]` and consuming the
   `H¹`-vanishing of pin 3.
5. `AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.exists_nonconstant_genusZero`
   — the corollary: a non-constant rational function `f ∈ K(C)` regular
   on `C \ {P}` with at most a simple pole at `P`, obtained as a lift of
   any non-zero element of the quotient
   `H⁰(C, 𝒪_C(P)) / 𝓀̄ · 1`.

## Notation reminders

The line bundle `𝒪_C(P)` is realised as a
`Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar)`,
the same `ModuleCat k̄`-flavoured sheaf category used by the project's
`Scheme.HModule` cohomology pipeline (cf. `AlgebraicJacobian.Genus`).
Its `H⁰` and `H¹` are computed via `Scheme.HModule kbar (·) 0` and
`Scheme.HModule kbar (·) 1`, both of which carry a canonical `Module k̄`
instance.

## References

Blueprint: `blueprint/src/chapters/RiemannRoch_OCofP.tex` (Hartshorne
II.6 / II.7 / IV.1 verbatim quotes; 5 pins). Source: Hartshorne,
*Algebraic Geometry*, II §6 p. 144 (definition of `ℒ(D)`), II §7
Proposition 7.7 p. 157 (global sections of `ℒ(D)` as rational functions
with controlled pole), IV §1 pp. 294–297 (Riemann–Roch and the genus-`0`
specialisation, Example 1.3.5 and Exercise 1.1). Stacks Project tags
01X0 (line bundle of a Cartier divisor), 0BE5 (the global sections
exact sequence), 0AYO (Riemann–Roch).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-! ## §1. The line bundle of a closed point on a smooth proper curve

For a smooth proper geometrically irreducible curve `C / k̄` and a closed
point `P ∈ C`, the local ring `𝒪_{C,P}` is a DVR with maximal ideal
generated by a uniformiser `f_P`. Hartshorne's construction `ℒ(D)`
(II §6 p. 144) applied to the Cartier divisor `[P]` (locally cut out by
`f_P` near `P`, by `1` elsewhere) produces the invertible sheaf `𝒪_C(P)`:
the sub-`𝒪_C`-module of the function-field constant sheaf `𝒦_C ≅ K(C)`
generated locally by `f_P^{-1}` near `P` and by `1` on `C \ {P}`. -/

namespace Scheme

/-- **The line bundle `𝒪_C(P)` of a closed point `P` on a smooth proper
curve `C / k̄`** (Hartshorne II §6, p. 144, Proposition 6.13(a)).

The invertible sheaf cut out (in the dual / `𝒦_C`-subsheaf packaging of
Hartshorne `ℒ(D)`) by `f_P^{-1}` near `P` and by `1` on the complement,
where `f_P ∈ 𝔪_P ∖ 𝔪_P²` is any uniformiser of the DVR `𝒪_{C,P}`. The
result is independent of the choice of uniformiser (two uniformisers
differ by a unit) and is an invertible `𝒪_C`-module of rank one.

The signature returns a `Sheaf (Opens.grothendieckTopology C.left.toTopCat)
(ModuleCat.{u} kbar)`: the same `ModuleCat k̄`-flavoured sheaf
carrier used by the project's `Scheme.HModule` cohomology pipeline (so
that `H⁰` and `H¹` of `𝒪_C(P)` are accessible via
`Scheme.HModule kbar (lineBundleAtClosedPoint P hP) 0/1`).

iter-183+ body recipe (per analogist `ocofp-sheaf-internalhom.md` Decision 3
`ALIGN_WITH_MATHLIB`): use the Hartshorne subsheaf-of-`K_C` direct
construction. Concretely, define the per-open submodule
`carrierSet U ⊆ K(C)` of rational functions `f` satisfying the order
conditions `ord_Q(f) ≥ 0` for every prime divisor `Q ≠ P` with
`Q.point ∈ U.unop` and `ord_P(f) ≥ −1` when `P ∈ U.unop`; bundle as a
`Submodule kbar K(C)` (the closure proofs reduce to the
`Ring.ordFrac`-multiplicativity + non-archimedean inequality of the DVR
valuation at each prime divisor); upgrade to a presheaf functor via the
identity-on-`K(C)` restriction; close the sheaf property via the
gluing-by-stalks principle (stalk-locality of the order conditions at
each prime divisor).

Blueprint reference: `def:lineBundleAtClosedPoint`
(Hartshorne II §6 p. 144 + Proposition 6.13(a); Stacks tag 01X0). -/
noncomputable def lineBundleAtClosedPoint
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (_P : C.left) (_hP : IsClosed ({_P} : Set C.left))
    (_hPcoh : Order.coheight _P = 1) :
    Sheaf (Opens.grothendieckTopology C.left.toTopCat)
      (ModuleCat.{u} kbar) :=
  sorry

/-- The inclusion `H⁰(C, 𝒪_C(P)) ↪ 𝒦_C ≅ K(C)` of global sections of
`𝒪_C(P)` into the function field, viewing each section as a rational
function via the canonical embedding `𝒪_C(P) ↪ 𝒦_C` (Hartshorne II §6 p.
144).  The body lands together with the body of `lineBundleAtClosedPoint`.

iter-183: `hPcoh` threaded through together with the sig amend on
`lineBundleAtClosedPoint`, since the body of `toFunctionField` will
unfold the `carrierSet`-based body of `lineBundleAtClosedPoint` (the
`carrierSet` references `⟨P, hPcoh⟩` as a prime divisor). -/
noncomputable def lineBundleAtClosedPoint.toFunctionField
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (P : C.left) (hP : IsClosed ({P} : Set C.left))
    (hPcoh : Order.coheight P = 1)
    (s : Scheme.HModule kbar
      (lineBundleAtClosedPoint (C := C) P hP hPcoh) 0) :
    C.left.functionField :=
  sorry

namespace lineBundleAtClosedPoint

variable {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
  {C : Over (Spec (.of kbar))} [IsProper C.hom]
  [SmoothOfRelativeDimension 1 C.hom]
  [GeometricallyIrreducible C.hom] [IsIntegral C.left]
  [IsLocallyNoetherian C.left]
  [Scheme.IsRegularInCodimensionOne C.left]

/-! ## §2. Global sections as the Riemann–Roch space `L([P])`

Hartshorne II §7 Proposition 7.7 identifies the global sections of
`ℒ(D_0)` with the rational functions `f ∈ K(X)^×` satisfying
`div(f) ≥ −D_0` (plus the zero section). Specialised to `D_0 = [P]` on a
curve, the condition `div(f) + [P] ≥ 0` rewrites coordinate-wise as
`ord_Q(f) ≥ 0` for every prime divisor `Q ≠ P` and `ord_P(f) ≥ −1`. -/

/-- **Forward direction of `globalSections_iff` (Hartshorne II.7.7(b)).**

Given `f ∈ K(C)^×` with `ord_Q(f) ≥ 0` for every prime divisor `Q ≠ P`
and `ord_P(f) ≥ −1`, the rational function `f` lifts to a global section
`s ∈ H⁰(C, 𝒪_C(P))` whose image under the canonical inclusion
`𝒪_C(P) ↪ 𝒦_C ≅ K(C)` equals `f`. Hartshorne's construction inside the
proof of Proposition 7.7(b) (p. 157) defines this section locally on the
affine cover witnessing the Cartier-divisor structure of `[P]`: on a
neighbourhood `U_i` of `P` the section is `f · f_P` (in
`𝒪_C(P)(U_i) = f_P⁻¹ · 𝒪_C(U_i)`, this is `(f · f_P) · f_P⁻¹ = f`);
on the complement `C ∖ {P}` the section is `f` directly (the order
conditions `ord_Q(f) ≥ 0` for `Q ≠ P` guarantee `f ∈ 𝒪_C(U) = 𝒪_C(P)(U)`
on any affine open `U ⊆ C ∖ {P}`).

**iter-181 PARTIAL — Mathlib-gap blocker** (per iter-181 Lane A
directive): the body of `lineBundleAtClosedPoint` (line ~140) is still
a typed `sorry` (gated on Sheaf-internal-Hom + ModuleCat-forget Mathlib
gaps analysed in iter-180 Lane D task_result), and the body of
`lineBundleAtClosedPoint.toFunctionField` (line ~154) is similarly a
typed `sorry` (gated on the body of `lineBundleAtClosedPoint`). Until
those bodies land, the section `s` cannot be constructed concretely and
no proof of `toFunctionField P hP s = f` can be exhibited. This helper
is therefore an honest typed `sorry`, replacing the iter-180 Lane D
internal sub-sorry with a named declaration so iter-182+ provers can
attack each direction independently. -/
private lemma globalSections_iff_mp
    [∀ Q : C.left.PrimeDivisor,
        Ring.KrullDimLE 1 (C.left.presheaf.stalk Q.point)]
    (P : C.left) (hP : IsClosed ({P} : Set C.left))
    (f : C.left.functionField) (_hf : f ≠ 0)
    (hPcoh : Order.coheight P = 1)
    (_hord : (∀ Q : C.left.PrimeDivisor, Q.point ≠ P →
        0 ≤ Scheme.RationalMap.order Q f) ∧
      (-1 : ℤ) ≤ Scheme.RationalMap.order ⟨P, hPcoh⟩ f) :
    ∃ s : Scheme.HModule kbar (lineBundleAtClosedPoint (C := C) P hP) 0,
      lineBundleAtClosedPoint.toFunctionField (C := C) P hP s = f := by
  -- Mathlib gap: `lineBundleAtClosedPoint` body + `toFunctionField` body
  -- are both typed `sorry` (lines 140, 154). The forward construction of
  -- Hartshorne II.7.7(b) requires unfolding the Cartier-divisor sheaf
  -- structure of `𝒪_C(P)`, which is unavailable until the upstream bodies
  -- land. iter-181 Lane A PARTIAL: directional helper sorry.
  sorry

/-- **Backward direction of `globalSections_iff` (Hartshorne II.7.7(a)).**

Given a global section `s ∈ H⁰(C, 𝒪_C(P))` whose image under
`𝒪_C(P) ↪ 𝒦_C ≅ K(C)` equals `f`, the order conditions on `f` follow by
reading off the stalk-by-stalk DVR identification. Concretely:

* At a prime divisor `Q ≠ P`, the stalk `𝒪_C(P)_Q = 𝒪_{C, Q}` agrees with
  the structure sheaf (since `𝒪_C(P)` equals `𝒪_C` on the open
  complement `C ∖ {P}`); the germ of `s` at `Q` lies in `𝒪_{C, Q}`, so
  the image `f = ι(s) ∈ K(C)` has valuation `ord_Q(f) ≥ 0`.
* At `P`, the stalk `𝒪_C(P)_P = f_P⁻¹ · 𝒪_{C, P}` (where `f_P` is a
  uniformiser of the DVR `𝒪_{C, P}`); the germ of `s` at `P` lies in
  this stalk, so `f = ι(s)` satisfies `f_P · f ∈ 𝒪_{C, P}`, i.e.
  `ord_P(f) ≥ −1`.

**iter-181 PARTIAL — Mathlib-gap blocker** (per iter-181 Lane A
directive): same blocker as the forward direction —
`lineBundleAtClosedPoint` body (L140) and `toFunctionField` body (L154)
are both typed `sorry`. Without unfolding the sheaf as a sub-`𝒦_C`-module
locally, the stalk identifications `𝒪_C(P)_Q = 𝒪_{C, Q}` (for `Q ≠ P`)
and `𝒪_C(P)_P = f_P⁻¹ · 𝒪_{C, P}` are not available, so the
valuation-reading argument cannot be exhibited. This helper is therefore
an honest typed `sorry`, replacing the iter-180 Lane D internal
sub-sorry with a named declaration so iter-182+ provers can attack each
direction independently. -/
private lemma globalSections_iff_mpr
    [∀ Q : C.left.PrimeDivisor,
        Ring.KrullDimLE 1 (C.left.presheaf.stalk Q.point)]
    (P : C.left) (hP : IsClosed ({P} : Set C.left))
    (f : C.left.functionField) (_hf : f ≠ 0)
    (hPcoh : Order.coheight P = 1)
    (_h : ∃ s : Scheme.HModule kbar (lineBundleAtClosedPoint (C := C) P hP) 0,
        lineBundleAtClosedPoint.toFunctionField (C := C) P hP s = f) :
    (∀ Q : C.left.PrimeDivisor, Q.point ≠ P →
        0 ≤ Scheme.RationalMap.order Q f) ∧
      (-1 : ℤ) ≤ Scheme.RationalMap.order ⟨P, hPcoh⟩ f := by
  -- Mathlib gap: same blocker as `globalSections_iff_mp`. The DVR
  -- stalk identification `𝒪_C(P)_Q = 𝒪_{C, Q}` (for `Q ≠ P`) /
  -- `𝒪_C(P)_P = f_P⁻¹ · 𝒪_{C, P}` consumes the body of
  -- `lineBundleAtClosedPoint` (line 140), still typed `sorry` (gated on
  -- Sheaf-internal-Hom + ModuleCat-forget Mathlib gaps, see iter-180
  -- Lane D task_result). iter-181 Lane A PARTIAL: directional helper sorry.
  sorry

/-- **Global sections of `𝒪_C(P)` as rational functions with controlled
pole at `P`** (Hartshorne II §7 Proposition 7.7, p. 157).

For a nonzero rational function `f ∈ K(C)^×`, the following are
equivalent:

* there exists a global section `s ∈ H⁰(C, 𝒪_C(P))` whose image under
  the canonical inclusion `𝒪_C(P) ↪ 𝒦_C ≅ K(C)` equals `f` (formally,
  `lineBundleAtClosedPoint.toFunctionField P hP s = f`);
* the order conditions hold: `ord_Q(f) ≥ 0` for every prime divisor
  `Q ∈ C.PrimeDivisor` whose generic point is not `P`, and
  `ord_P(f) ≥ −1` (where the latter is read off the prime divisor
  `⟨P, h⟩` with `h : Order.coheight P = 1` the codimension-one witness
  automatic for a closed point on a one-dimensional integral scheme).

The iff is the substantive content of Hartshorne's Proposition 7.7(b) /
its proof, specialised to `D_0 = [P]`.

**iter-181 Lane A PARTIAL — directional split landed**: the iff is now
proved by combining the two directional helpers
`globalSections_iff_mp` (Hartshorne II.7.7(b), forward) and
`globalSections_iff_mpr` (Hartshorne II.7.7(a), backward), both of
which carry a single honest typed `sorry` blocked on the body of
`lineBundleAtClosedPoint` (line ~140) and
`lineBundleAtClosedPoint.toFunctionField` (line ~154). The combinator
proof (`⟨mp, mpr⟩`-style) below is kernel-clean modulo those two
upstream sorries; iter-182+ provers can attack each directional helper
independently. The directive's helper budget = 2 is consumed by these
two named helpers.

iter-177+ body intent: unfold `lineBundleAtClosedPoint` as the subsheaf
of `𝒦_C` generated locally by `f_P⁻¹` near `P` and by `1` elsewhere,
then read off the order conditions at each stalk via the DVR valuation
identification.

Blueprint reference: `lem:lineBundleAtClosedPoint_globalSections_iff`
(Hartshorne II.7 Proposition 7.7(b), p. 157). -/
lemma globalSections_iff
    [∀ Q : C.left.PrimeDivisor,
        Ring.KrullDimLE 1 (C.left.presheaf.stalk Q.point)]
    (P : C.left) (hP : IsClosed ({P} : Set C.left))
    (f : C.left.functionField) (hf : f ≠ 0)
    (hPcoh : Order.coheight P = 1) :
    (∀ Q : C.left.PrimeDivisor, Q.point ≠ P →
        0 ≤ Scheme.RationalMap.order Q f) ∧
      (-1 : ℤ) ≤ Scheme.RationalMap.order ⟨P, hPcoh⟩ f
    ↔
    ∃ s : Scheme.HModule kbar (lineBundleAtClosedPoint (C := C) P hP) 0,
      lineBundleAtClosedPoint.toFunctionField (C := C) P hP s = f :=
  ⟨globalSections_iff_mp P hP f hf hPcoh,
   globalSections_iff_mpr P hP f hf hPcoh⟩

/-! ## §3. Cohomological vanishing in genus zero

Specialise Hartshorne IV.1 Theorem 1.3's inductive step at `D = 0`. The
standard short exact sequence
`0 → 𝒪_C(−[P]) → 𝒪_C → k(P) → 0` (Hartshorne II.6.18: the ideal sheaf
of the locally principal closed subscheme `P` is `𝒪_C(−[P])`; the
quotient is the skyscraper `k(P) ≅ k̄` at `P`) tensored by the locally
free rank-`1` sheaf `𝒪_C([P])` (left rigid, so preserves exactness and
leaves the skyscraper invariant) becomes
`0 → 𝒪_C → 𝒪_C(P) → k(P) → 0` in `Coh(C)`. The associated long exact
sequence of sheaf cohomology, combined with `H¹(C, 𝒪_C) = 0`
(genus-`0` hypothesis: `g(C) = dim_{k̄} H¹(C, 𝒪_C)`) and
`H¹(C, k(P)) = 0` (skyscraper / flasque), kills `H¹(C, 𝒪_C(P))`. -/

/-- **Vanishing of `H¹(C, 𝒪_C(P))` on a smooth proper geometrically
irreducible curve of genus `0`** (Hartshorne IV §1 p. 296, the
inductive step of Theorem 1.3 specialised to `D = 0`).

Concretely, the finite-dimensional `k̄`-vector space
`Scheme.HModule kbar (lineBundleAtClosedPoint P hP) 1` has dimension
`0`, i.e. is the trivial vector space.

iter-177+ body: assemble the closed-point short exact sequence
`0 → 𝒪_C → 𝒪_C(P) → k(P) → 0`, feed it to the long exact sequence of
`Module k̄`-flavoured cohomology (the project's
`Scheme.HModule k̄`-bridge inherits the LES by forget-functor
naturality from
`CategoryTheory.Abelian.Ext.covariantSequence_exact`), substitute
`H¹(C, 𝒪_C) = 0` (the genus-`0` hypothesis, unfolding
`AlgebraicGeometry.genus`) and `H¹(C, k(P)) = 0` (skyscraper sheaf /
flasque cohomology, Hartshorne III.2.5), and collapse the segment to
`0 → H¹(C, 𝒪_C(P)) → 0`.

Blueprint reference: `lem:H1_vanishing_lineBundleAtClosedPoint_genusZero`
(Hartshorne IV.1 p. 296). -/
lemma h1_vanishing_genusZero
    (P : C.left) (hP : IsClosed ({P} : Set C.left))
    (_hg : AlgebraicGeometry.genus C = 0) :
    Module.finrank kbar
        (Scheme.HModule kbar (lineBundleAtClosedPoint (C := C) P hP) 1) = 0 := by
  sorry

/-! ## §4. The dimension formula `dim H⁰(C, 𝒪_C(P)) = 2` in genus zero

Specialise the Euler-characteristic identity
`χ(𝒪_C(D)) = deg(D) + 1 − g` of `RR.2`
(`Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus`) to
`D = [P]`. Since `deg([P]) = 1` (every closed point contributes degree
`1` over `k̄`) and `g(C) = 0`, this gives `χ(𝒪_C(P)) = 2`. Unfolding
`χ` as `dim H⁰ − dim H¹` and substituting the `H¹`-vanishing of §3
yields `dim H⁰(C, 𝒪_C(P)) = 2`. -/

/-- **The dimension formula `dim_{k̄} H⁰(C, 𝒪_C(P)) = 2` on a smooth
proper geometrically irreducible genus-`0` curve over `k̄`**
(Hartshorne IV §1 Example 1.3.5, p. 297).

iter-177+ body: invoke
`Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus` on the
`ModuleCat k̄`-valued sheaf `lineBundleAtClosedPoint P hP` (matching the
χ-identity through a bridge identifying
`lineBundleAtClosedPoint P hP` with
`WeilDivisor.sheafOf (ofClosedPoint P hP)`), evaluate the right-hand
side `deg([P]) + 1 − g(C) = 1 + 1 − 0 = 2`, unfold
`Scheme.eulerCharacteristic` as
`(Module.finrank kbar H⁰) − (Module.finrank kbar H¹)`, substitute
`Module.finrank kbar H¹ = 0` from `h1_vanishing_genusZero`, and read
off `Module.finrank kbar H⁰ = 2`.

Blueprint reference: `thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero`
(Hartshorne IV.1 Example 1.3.5, p. 297). -/
theorem dim_eq_two_of_genusZero
    (P : C.left) (hP : IsClosed ({P} : Set C.left))
    (_hg : AlgebraicGeometry.genus C = 0) :
    Module.finrank kbar
        (Scheme.HModule kbar (lineBundleAtClosedPoint (C := C) P hP) 0) = 2 := by
  sorry

/-! ## §5. A non-constant rational function with at most a simple pole at `P`

The two-dimensionality of `H⁰(C, 𝒪_C(P))` and the one-dimensional
constant subspace `k̄ · 1` give a non-zero quotient `H⁰/k̄`. Any lift
of a non-zero element of the quotient is, under the identification of
`globalSections_iff`, a non-constant rational function `f ∈ K(C)` with
the order conditions `ord_Q(f) ≥ 0` for `Q ≠ P` and `ord_P(f) ≥ −1`.
This is the seed of `RR.4` (the morphism `C → ℙ¹` produced by
`Proj.fromOfGlobalSections` from the basis `(1, f)`). -/

/-- **Existence of a non-constant rational function regular on `C ∖ {P}`
with at most a simple pole at `P`** (Hartshorne IV §1 Exercise 1.1,
p. 297, the genus-`0` specialisation).

Concretely, there exists `f ∈ K(C)` such that:

* `f ≠ 0`;
* `f ∉ k̄` (i.e. `f` is non-constant — for instance, it does not lie
  in the image of the structural inclusion of constants);
* `ord_Q(f) ≥ 0` for every prime divisor `Q ∈ C.PrimeDivisor` whose
  generic point is not `P`;
* `ord_P(f) ≥ −1` (at most a simple pole at `P`).

iter-177+ body: use `dim_eq_two_of_genusZero` to get
`dim_{k̄} H⁰(C, 𝒪_C(P)) = 2`. The image of `1 ∈ H⁰(C, 𝒪_C) ≅ k̄`
under the structural inclusion `𝒪_C ↪ 𝒪_C(P)` spans a one-dimensional
subspace of `H⁰(C, 𝒪_C(P))`; choose any section `s ∈ H⁰(C, 𝒪_C(P))`
not in this constant subspace (non-empty because `dim H⁰ = 2 > 1`),
then take `f := lineBundleAtClosedPoint.toFunctionField P hP s` and
verify the four bullets via `globalSections_iff` applied to `f`
(the forward direction supplies the order conditions from the existence
witness `⟨s, rfl⟩`). The chosen `f` is non-constant because `s` is not
in the constant subspace and `toFunctionField` is `k̄`-linear and
injective on global sections.

The principal-divisor-non-zero formulation `Scheme.WeilDivisor.principal
f hf ≠ 0` follows from non-constancy plus the fact that constant
functions have principal divisor zero (the converse — `div(f) = 0`
⇒ `f` constant — uses the integrality of `C` and is the Stacks 02P0
"functions with no zeros and poles are constant" type statement).

Blueprint reference:
`cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero` (alias
`cor:nonconstant_function_genus_zero` consumed by `RR.4`)
(Hartshorne IV.1 Exercise 1.1, p. 297). -/
theorem exists_nonconstant_genusZero
    [∀ Q : C.left.PrimeDivisor,
        Ring.KrullDimLE 1 (C.left.presheaf.stalk Q.point)]
    (P : C.left) (_hP : IsClosed ({P} : Set C.left))
    (hPcoh : Order.coheight P = 1)
    (_hg : AlgebraicGeometry.genus C = 0) :
    ∃ (f : C.left.functionField) (hf : f ≠ 0),
      (∀ Q : C.left.PrimeDivisor, Q.point ≠ P →
          0 ≤ Scheme.RationalMap.order Q f) ∧
      (-1 : ℤ) ≤ Scheme.RationalMap.order ⟨P, hPcoh⟩ f ∧
      Scheme.WeilDivisor.principal (X := C.left) f hf ≠ 0 := by
  sorry

end lineBundleAtClosedPoint

end Scheme

end AlgebraicGeometry
