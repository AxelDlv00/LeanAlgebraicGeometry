/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Genus
import AlgebraicJacobian.RiemannRoch.WeilDivisor

/-!
# The Riemann–Roch formula in genus zero (RR.2)

This file is the **RR.2** file-skeleton sub-build chapter for the project's
headline `genusZero_curve_iso_P1` (the "smooth proper geometrically
irreducible genus-`0` curve over `k̄` is isomorphic to `ℙ¹`" lemma in
`AlgebraicJacobian.AbelianVarietyRigidity`).

The Hartshorne IV.1.3.5 chain for the genus-`0` ↦ `ℙ¹` classification routes
through:

- `RR.1` (`RiemannRoch_WeilDivisor.tex` / `WeilDivisor.lean`): the Weil
  divisor group `Div(C)` and the degree map `deg : Div(C) → ℤ`.
- **`RR.2` (this file, `RiemannRoch_RRFormula.tex`)**: the Riemann–Roch
  dimension formula `ℓ(D) = deg(D) + 1` in genus `0` (with `deg D ≥ 0`),
  via the auxiliary Euler-characteristic identity
  `χ(𝒪_C(D)) = deg(D) + 1 − g`.
- `RR.3` (`RiemannRoch_OcOfD.tex`, future): the invertible sheaf
  `𝒪_C(D)`, the linear-equivalence isomorphism `𝒪_C(D) ≅ 𝒪_C(D')` for
  `D ∼ D'`, and the `H¹`-vanishing input
  `H¹(C, 𝒪_C(D)) = 0` for `deg D ≥ 0` on a genus-`0` curve.
- `RR.4` (`RiemannRoch_RationalIsoP1.tex`, future): the "two-section
  ⇒ `Proj.fromOfGlobalSections` ⇒ `≅ ℙ¹`" classification.

## Status (iter-174 Lane F file-skeleton)

This file is the **iter-174 Lane F** file-skeleton: each of the four pinned
declarations carries the *intended* substantive type signature (matching the
blueprint `\lean{...}` pin in `chapters/RiemannRoch_RRFormula.tex`). The
Euler-characteristic carrier definition is concrete (a one-line subtraction
of `H⁰` and `H¹` `Module.finrank`s, mirroring the `genus` definition of
`AlgebraicJacobian.Genus`); the remaining pins carry `sorry` bodies whose
closure is iter-175+ work after the sibling chapters `RR.3`
(`RiemannRoch_OcOfD.tex`) and `RR.4` (`RiemannRoch_RationalIsoP1.tex`) land.

The 4 pinned declarations are:

1. `AlgebraicGeometry.Scheme.eulerCharacteristic` — Euler characteristic
   `χ(𝓕) = dim_{k̄} H⁰(C, 𝓕) − dim_{k̄} H¹(C, 𝓕)` of a `ModuleCat k̄`-valued
   sheaf on `C` (the curve specialisation of the alternating sum, since
   `H^i = 0` for `i ≥ 2` on a one-dimensional scheme by Grothendieck
   vanishing).
2. `AlgebraicGeometry.Scheme.WeilDivisor.l` — the `ℓ`-invariant
   `ℓ(D) = dim_{k̄} H⁰(C, 𝒪_C(D))` of a Weil divisor `D`.
3. `AlgebraicGeometry.Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus`
   — the Euler-characteristic identity `χ(𝒪_C(D)) = deg(D) + 1 − g` for
   every `D ∈ Div(C)` on a smooth proper geometrically irreducible curve
   `C / k̄` of genus `g = g(C)`.
4. `AlgebraicGeometry.Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero`
   — the Riemann–Roch formula in genus `0`: `ℓ(D) = deg(D) + 1` for any
   Weil divisor `D ∈ Div(C)` with `deg D ≥ 0` on a smooth proper
   geometrically irreducible curve `C / k̄` with `g(C) = 0` (threading
   the `H¹`-vanishing of `𝒪_C(D)` explicitly as a named premise until
   `RR.3` lands).

## Note on `𝒪_C(D)` (the invertible sheaf of a divisor)

The chapter's proof of `eulerCharacteristic_eq_degree_plus_one_minus_genus`
and the statement of `l_eq_degree_plus_one_of_genus_zero` both reference
the line bundle `𝒪_C(D)` of a Weil divisor `D`. Mathlib `b80f227` ships no
`Scheme.lineBundleOfDivisor` (the closest is `WeierstrassCurve.lineBundle`
in the elliptic-curve formalisation), and the project-side construction of
`𝒪_C(D)` is queued for `RR.3` (`RiemannRoch_OcOfD.tex`). To keep the type
signatures of pins 2–4 substantive in the iter-174 skeleton, we expose a
**typed-`sorry` placeholder**
`AlgebraicGeometry.Scheme.WeilDivisor.sheafOf` that pairs each divisor with
the `ModuleCat k̄`-valued sheaf carrier `𝒪_C(D)` is intended to occupy. The
iter-175+ closure of `RR.3` replaces this placeholder's body with the
honest invertible-sheaf construction; the present pins consume it only
through its `H⁰` and `H¹` cohomology, so the consumer signatures are
substantive in the type sense (each asserts an arithmetic identity on the
finiteness-of-`H^*` outputs).

## References

Blueprint: `blueprint/src/chapters/RiemannRoch_RRFormula.tex` (Hartshorne
IV.1 verbatim quotes; 4 pins).
Source: Hartshorne, *Algebraic Geometry*, IV §1 (pp. 294–297), Theorem 1.3
(Riemann–Roch) and Example 1.3.5 (genus-`0` specialisation). Stacks Project
tags 0BSC (Euler characteristic on a curve), 0AYO (Riemann–Roch).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-! ## §1. The Euler characteristic of a coherent sheaf on a curve -/

/-- **Euler characteristic of a `ModuleCat k`-valued sheaf on a smooth proper
curve `C / k̄`.**

On a curve (one-dimensional scheme), Grothendieck vanishing
(Hartshorne III.2.7) gives `H^i(C, 𝓕) = 0` for `i ≥ 2`, so the classical
alternating sum
`χ(𝓕) = Σ_{i ≥ 0} (-1)^i dim_{k̄} H^i(C, 𝓕)` collapses to the two-term
expression
`χ(𝓕) = dim_{k̄} H⁰(C, 𝓕) − dim_{k̄} H¹(C, 𝓕)`.

This is the definition we ship. Coherence of `𝓕` on the proper `k̄`-scheme
`C` guarantees that both `H⁰` and `H¹` are finite-dimensional `k̄`-vector
spaces (Serre's coherent-cohomology finiteness theorem, the same
finiteness backing `AlgebraicGeometry.genus`), so the two `Module.finrank`s
are honest natural numbers and the difference is a well-defined integer.

The `Module k̄`-valued cohomology pipeline is the project's
`Scheme.HModule` (iter-009), the same wrapper used by
`AlgebraicGeometry.genus`.

Blueprint reference: `def:eulerChar_curve`
(Hartshorne IV.1 p. 295, displayed inside the proof of Theorem 1.3). -/
noncomputable def Scheme.eulerCharacteristic
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom]
    (F : Sheaf (Opens.grothendieckTopology C.left.toTopCat)
      (ModuleCat.{u} kbar)) : ℤ :=
  (Module.finrank kbar (Scheme.HModule kbar F 0) : ℤ)
    - (Module.finrank kbar (Scheme.HModule kbar F 1) : ℤ)

/-! ## §2. The invertible sheaf `𝒪_C(D)` of a Weil divisor (placeholder)

The honest construction of `𝒪_C(D)` lives in the sibling chapter `RR.3`
(`RiemannRoch_OcOfD.tex`), where the locally-principal ideal sheaves of
closed points are glued into an invertible `𝒪_C`-module. To keep the
iter-174 skeleton's pin signatures substantive, we expose `𝒪_C(D)` as a
typed-`sorry` `ModuleCat k̄`-valued sheaf-on-`C`. The iter-175+ closure of
`RR.3` will replace the body with the construction; downstream pins (the
`ℓ`-invariant, the χ-identity, the genus-`0` Riemann–Roch formula) consume
this placeholder only through its `H⁰` and `H¹`, so their signatures
encode arithmetic identities on finiteness-of-cohomology outputs and are
not vacuous. -/

namespace Scheme.WeilDivisor

variable {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
  {C : Over (Spec (.of kbar))} [IsProper C.hom]
  [SmoothOfRelativeDimension 1 C.hom]
  [GeometricallyIrreducible C.hom] [IsIntegral C.left]

/-- **The invertible sheaf `𝒪_C(D)` of a Weil divisor `D` on a smooth proper
curve `C / k̄`** (placeholder for `RR.3`).

For a Weil divisor `D = Σᵢ nᵢ · [Pᵢ]` on a smooth proper geometrically
irreducible curve `C / k̄`, the associated invertible sheaf `𝒪_C(D)` is the
locally-free `𝒪_C`-module of rank one cut out (locally near each `Pᵢ`) by
the `(−nᵢ)`-th power of the local uniformiser at `Pᵢ`. Hartshorne II §6
Proposition 6.13 packages this construction; the project-side `RR.3`
chapter (`RiemannRoch_OcOfD.tex`, to be added) will produce the carrier as
a `Sheaf` of `ModuleCat k̄`-modules on `C.left`.

In the iter-174 skeleton this is a typed-`sorry`. The body in `RR.3` will
be the invertible-sheaf glue of the locally principal ideals of the
support of `D`. -/
noncomputable def sheafOf (_D : C.left.WeilDivisor) :
    Sheaf (Opens.grothendieckTopology C.left.toTopCat)
      (ModuleCat.{u} kbar) :=
  sorry

/-! ## §3. The `ℓ`-invariant of a Weil divisor -/

/-- **The `ℓ`-invariant of a Weil divisor `D` on a smooth proper curve
`C / k̄`.**

By definition,
`ℓ(D) := dim_{k̄} H⁰(C, 𝒪_C(D)) ∈ ℕ`,
the `k̄`-dimension of the space of global sections of the invertible sheaf
`𝒪_C(D)` associated to `D`. Finiteness of `ℓ(D)` is a consequence of the
coherent-cohomology finiteness theorem on a proper `k̄`-scheme
(Hartshorne II.5.19 / III.5.2), the same input that backs the finiteness
of `genus C`.

The classical *complete linear system* `|D|` has `k̄`-projective dimension
`ℓ(D) − 1`; the chapter never uses this projective interpretation —
`ℓ(D)` is the only quantity consumed by the Hartshorne IV.1.3.5 chain.

Blueprint reference: `def:l_invariant` (Hartshorne IV.1 p. 295,
"We denote `dim_k H⁰(X, 𝒪(D))` by `l(D)`"). -/
noncomputable def l (D : C.left.WeilDivisor) : ℕ :=
  Module.finrank kbar (Scheme.HModule kbar (sheafOf (C := C) D) 0)

end Scheme.WeilDivisor

/-! ## §4. The χ-identity: `χ(𝒪_C(D)) = deg(D) + 1 − g`

The bridge from the structural Euler characteristic to the arithmetic
degree of a divisor. Hartshorne IV.1 Theorem 1.3 reduces Riemann–Roch to
this identity; the proof is the inductive `D ↔ D + [P]` step (additivity
of χ on the closed-point short exact sequence, with base case `D = 0`
giving `χ(𝒪_C) = 1 − g` from `dim H⁰(C, 𝒪_C) = 1` and the definition of
the genus). The closure of the body is iter-175+ work after the
`Euler-characteristic additivity on a short exact sequence`-style
project-side helper is supplied and the `RR.3` sheaf `𝒪_C(D)` has a
body. -/

/-- **Euler-characteristic identity for `𝒪_C(D)` on a smooth proper curve
of genus `g`.**

For every Weil divisor `D ∈ Div(C)`,
`χ(𝒪_C(D)) = deg(D) + 1 − g(C)`.

The proof is Hartshorne IV.1 Theorem 1.3's reduction: induction on the
free-abelian-group structure of `Div(C)` on closed points, base case `D =
0` giving `χ(𝒪_C) = 1 − g` (the `dim H⁰(C, 𝒪_C) = 1` is the Hartshorne
I.3.4 input via the project's `H⁰`-bridge), and inductive step via
additivity of χ on the closed-point short exact sequence
`0 → 𝒪_C(D) → 𝒪_C(D + [P]) → k(P) → 0`.

Blueprint reference: `thm:euler_char_eq_deg_plus_one_minus_genus`
(Hartshorne IV.1 Theorem 1.3, p. 295). -/
theorem Scheme.eulerCharacteristic_eq_degree_plus_one_minus_genus
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (D : C.left.WeilDivisor) :
    Scheme.eulerCharacteristic C (Scheme.WeilDivisor.sheafOf (C := C) D)
      = (Scheme.WeilDivisor.degree D) + 1 - (AlgebraicGeometry.genus C : ℤ) :=
  sorry

/-! ## §5. The Riemann–Roch formula in genus zero -/

/-- **Riemann–Roch in genus zero (Hartshorne IV.1 Example 1.3.5).**

Let `C` be a smooth proper geometrically irreducible curve over the
algebraically closed field `k̄` with `g(C) = 0`, and let `D ∈ Div(C)` with
`deg D ≥ 0`. Then
`ℓ(D) = deg(D) + 1`.

The proof specialises the χ-identity
`eulerCharacteristic_eq_degree_plus_one_minus_genus` to `g = 0`,
unfolds `χ` via `def:eulerChar_curve`, and absorbs the `H¹`-vanishing
hypothesis (named premise `_hH1`: `H¹(C, 𝒪_C(D)) = 0`, which is the
`H¹`-vanishing of a non-negative-degree invertible sheaf on a
genus-`0` curve, to be discharged by `RR.3` once `𝒪_C(D)` has a body and
the cohomology of `𝒪_{ℙ¹}(d)` is computed).

Blueprint reference: `thm:riemannRoch_genus_zero` (Hartshorne IV.1
Example 1.3.5, p. 297). -/
theorem Scheme.WeilDivisor.l_eq_degree_plus_one_of_genus_zero
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (D : C.left.WeilDivisor) (_hg : AlgebraicGeometry.genus C = 0)
    (_hdeg : (0 : ℤ) ≤ Scheme.WeilDivisor.degree D)
    (_hH1 : Module.finrank kbar
      (Scheme.HModule kbar (Scheme.WeilDivisor.sheafOf (C := C) D) 1) = 0) :
    (Scheme.WeilDivisor.l (C := C) D : ℤ)
      = Scheme.WeilDivisor.degree D + 1 :=
  sorry

end AlgebraicGeometry
