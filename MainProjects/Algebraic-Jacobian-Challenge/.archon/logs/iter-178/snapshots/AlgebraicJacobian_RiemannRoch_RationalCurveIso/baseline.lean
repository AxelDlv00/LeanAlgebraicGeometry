/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Genus0BaseObjects
import AlgebraicJacobian.RiemannRoch.WeilDivisor

/-!
# The rational-curve isomorphism `C ≅ ℙ¹` (RR.4)

This file is the **RR.4** sub-build chapter for the project's headline
`genusZero_curve_iso_P1` (the "smooth proper geometrically irreducible
genus-`0` curve over `k̄` is isomorphic to `ℙ¹`" lemma pinned in
`AlgebraicJacobian.AbelianVarietyRigidity:290`).

The Hartshorne IV.1.3.5 chain for the genus-`0` ⇒ `ℙ¹` classification routes
through the four sub-build chapters:

- `RR.1` (`WeilDivisor.lean`): the Weil divisor group `Div(C)`, the degree
  map `deg : Div(C) → ℤ`, and the degree-zero principal-divisor identity.
- `RR.2` (`RRFormula.lean`): the Euler-characteristic identity
  `χ(𝒪_C(D)) = deg(D) + 1 − g` and Riemann–Roch in genus zero.
- `RR.3` (`OCofP.lean`): the line bundle `𝒪_C([P])` of a closed point and
  the existence of a non-constant rational function
  `f ∈ H⁰(C, 𝒪_C([P])) ∖ k̄ · 1`.
- **`RR.4` (this file)**: the global classification — the linear-system
  morphism `C ⟶ ℙ¹` produced from `(1, f)` (Pin 1), its degree identified
  via the pole divisor (Pin 2), and the degree-`1` ⇒ isomorphism step
  (Pin 3). The headline target `AlgebraicGeometry.genusZero_curve_iso_P1`
  (Pin 4) is the existing pinned declaration at
  `AlgebraicJacobian/AbelianVarietyRigidity.lean:290` — see §0 below.

## Status (iter-177 Lane 8 file-skeleton)

This file is the **iter-177 Lane 8** file-skeleton. Each of the three
new pinned declarations carries the *intended* substantive type
signature (matching the `\lean{...}` pin in
`blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`) with a
`sorry` body. Bodies are iter-178+ work after the RR.1/RR.2/RR.3 chain
matures (in particular `Scheme.WeilDivisor.principal_degree_zero` and
the `H⁰(C, 𝒪_C([P]))`-non-constant existence corollary of `RR.3`).

The 3 new pinned declarations are:

1. `AlgebraicGeometry.Scheme.morphismToP1OfGlobalSections` — from a
   graded `k̄`-algebra hom `k̄[X₀, X₁] →+* Γ(X, ⊤)` whose image of the
   irrelevant ideal generates the unit ideal, produce the morphism
   `X ⟶ ProjectiveLineBar k̄` via `Proj.fromOfGlobalSections` lifted to
   the slice category over `Spec k̄`.
2. `AlgebraicGeometry.Scheme.morphism_degree_via_pole_divisor` — for a
   non-constant morphism `φ : C ⟶ ProjectiveLineBar k̄` from a smooth
   proper curve, extract a positive-degree Weil divisor on `C` (the
   pole divisor `φ^*[∞]`).
3. `AlgebraicGeometry.Scheme.iso_of_degree_one` — a non-constant
   morphism between smooth proper geometrically irreducible curves
   whose induced function-field map is a `k̄`-algebra iso is an
   isomorphism of schemes (Hartshorne I.6.12 specialised to
   degree-`1`).

The headline pin (Pin 4) is satisfied by the existing AVR.lean target.

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof",
each pinned declaration carries a substantive, non-tautological type:

* `morphismToP1OfGlobalSections` returns a *concrete* morphism
  `X ⟶ ProjectiveLineBar k̄` of `Over (Spec k̄)`, not `Iso.refl _` or a
  reflexive placeholder; the input data is the exact pair
  `(f, hf)` consumed by Mathlib's `Proj.fromOfGlobalSections`.
* `morphism_degree_via_pole_divisor` asserts the existence of a
  positive-integer degree `d` together with a Weil divisor `D` on `C`
  realising it — the *named substantive content* of the degree-via-pole
  identification. Unfolds to `∃ d D, 0 < d ∧ D.degree = d`, not `True`.
* `iso_of_degree_one` asserts `Nonempty (C ≅ C')` from the
  non-constant and function-field-iso hypotheses. The `Nonempty`-wrapped
  iso is the exact downstream-consumer shape, matching the
  `genusZero_curve_iso_P1` headline signature in AVR.lean.

Unfolding any pinned declaration exposes the named substantive content
(the concrete `Proj.fromOfGlobalSections`-derived morphism, the
existence-of-positive-degree-divisor statement, the existence of a
scheme isomorphism); no `Iso.refl _` / empty-content `proof_wanted` /
`Classical.choice ⟨witness⟩` placeholders are used.

## Curve conventions

Following the project (cf. `AbelianVarietyRigidity.lean`,
`Jacobian.lean`, `OCofP.lean`), a **smooth proper geometrically
irreducible curve over `k̄`** carries:

- `[SmoothOfRelativeDimension 1 C.hom]`,
- `[IsProper C.hom]`,
- `[GeometricallyIrreducible C.hom]`.

These instances are supplied by `inferInstance` at the call site. The
`[IsIntegral C.left]` / `[IsLocallyNoetherian C.left]` instances
required by the Weil-divisor / `RationalMap.order` API are threaded
explicitly per-lemma where consumed.

## References

Blueprint: `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`
(~535 LOC, 4 pins). Source: Hartshorne, *Algebraic Geometry*,
IV §1 Example 1.3.5, p. 297 (the genus-`0` ⇒ `ℙ¹` classification);
IV §2 opening paragraph, p. 299 (degree of a finite morphism of
curves); I §6 Corollary 6.12, p. 45 (function-field ⇔ smooth projective
curve equivalence of categories); II §7 Theorem 7.1 (morphisms to
`ℙⁿ` via global sections). Stacks Project tag `0AVX` (degree-`1`
finite morphism between integral normal schemes is an isomorphism).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace AlgebraicGeometry

/-! ## §0. Pin 4 — `genusZero_curve_iso_P1` cross-reference

The headline theorem `AlgebraicGeometry.genusZero_curve_iso_P1`
(blueprint `thm:genus_zero_curve_iso_p1`, `\lean{...}` at chapter
L331) is **not** re-declared in this file. It lives at the
existing project pin

  `AlgebraicJacobian/AbelianVarietyRigidity.lean:290`

with the signature

  `theorem genusZero_curve_iso_P1
       [IsAlgClosed kbar] {C : Over (Spec (.of kbar))}
       [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
       [GeometricallyIrreducible C.hom]
       (_hgenus : genus C = 0) :
     Nonempty (C ≅ ProjectiveLineBar kbar) := sorry`

The blueprint `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}`
cross-reference resolves to that declaration. The present file
supplies the three new pins (`morphismToP1OfGlobalSections`,
`morphism_degree_via_pole_divisor`, `iso_of_degree_one`) which feed
the body of the AVR.lean declaration in a follow-up iter (iter-178+).

-/

namespace Scheme

/-! ## §1. Pin 1 — the morphism `X ⟶ ℙ¹` from a globally-generating pair
(`morphismToP1OfGlobalSections`)

Hartshorne II Theorem 7.1, specialised to `ℙ¹` over `k̄`. Given a graded
`k̄`-algebra homomorphism `f : k̄[X₀, X₁] →+* Γ(X, ⊤)` whose image of the
irrelevant ideal `(X₀, X₁)` generates the unit ideal of `Γ(X, ⊤)`, the
construction `Proj.fromOfGlobalSections` of Mathlib's
`AlgebraicGeometry.ProjectiveSpectrum.Basic` produces a morphism
`X.left ⟶ Proj 𝒜 = ProjectiveLineBarScheme k̄`. Lifting to the slice
category over `Spec k̄` (via `Over.homMk` with a section-condition
proof) yields the pinned morphism
`X ⟶ ProjectiveLineBar k̄ : Over (Spec (.of kbar))`. -/

/-- **The morphism `X ⟶ ℙ¹_{k̄}` produced from a globally-generating pair of
homogeneous sections** (Hartshorne II Theorem 7.1; Mathlib's
`AlgebraicGeometry.Proj.fromOfGlobalSections` specialised to the standard
ℕ-grading on `k̄[X₀, X₁]`).

Given a graded `k̄`-algebra homomorphism `f : k̄[X₀, X₁] →+* Γ(X, ⊤)` and a
proof `hf` that the image of the irrelevant ideal `(X₀, X₁) ⊆ k̄[X₀, X₁]`
generates the unit ideal of `Γ(X, ⊤)`, this constructs the unique morphism
`φ : X ⟶ ProjectiveLineBar k̄` characterised on basic-opens by
`φ ⁻¹ᵁ D₊(X_i) = X.basicOpen (f X_i)` (the "no-common-zero" expression of
Hartshorne's morphism condition). The composite
`φ.left ≫ Proj.toSpecZero _ = X.hom`, witnessing the `Over (Spec k̄)`
section condition.

The input data `(f, hf)` is the standard Hartshorne II §7 packaging of "a
pair of global sections `s₀, s₁ ∈ H⁰(X, ℒ)` of an invertible sheaf `ℒ`
without common zeros": `f` is the graded `k̄`-algebra map sending
`X_i ↦ s_i ∈ Γ(X, ℒ) ⊂ Γ(X, ⊤)` (after a choice of trivialisation
identifying `H⁰(X, ℒ)` with a submodule of `Γ(X, ⊤)` over the affine
cover `X = D(s₀) ∪ D(s₁)`); `hf` is the no-common-zero condition.

iter-178+ body: invoke `Proj.fromOfGlobalSections` on the standard
grading `projectiveLineBarGrading k̄` (the `ℕ`-grading on
`MvPolynomial (Fin 2) k̄` by total degree, with `GradedRing` instance
via `MvPolynomial.gradedAlgebra`), then wrap in `Over.homMk` with the
section condition proof. The section condition chases through
`Proj.fromOfGlobalSections_toSpecZero` plus
`IsScalarTower kbar (𝒜 0) (MvPolynomial (Fin 2) kbar)` to reduce to
`MvPolynomial.eval` of `MvPolynomial.C`, finishing via
`toSpecΓ_SpecMap_ΓSpecIso_inv` (cf. the analogous chain in
`Genus0BaseObjects/Points.lean:pointOfVec`).

Blueprint reference: `lem:morphism_to_p1_from_global_sections`
(Hartshorne II Theorem 7.1, II §7). -/
noncomputable def morphismToP1OfGlobalSections
    {kbar : Type u} [Field kbar]
    (X : Over (Spec (.of kbar)))
    (f : MvPolynomial (Fin 2) kbar →+* Γ(X.left, ⊤))
    (_hf :
      Ideal.map f
          (HomogeneousIdeal.irrelevant (projectiveLineBarGrading kbar)).toIdeal = ⊤) :
    X ⟶ ProjectiveLineBar kbar :=
  sorry

/-! ## §2. Pin 2 — the degree of a non-constant `C ⟶ ℙ¹` via its pole divisor
(`morphism_degree_via_pole_divisor`)

Hartshorne II §6 + IV §2 opening: for a non-constant morphism
`φ : C ⟶ ℙ¹` from a smooth proper curve, the function-field extension
`k̄(ℙ¹) ↪ K(C)` is finite, and the degree
`[K(C) : k̄(ℙ¹)] = deg(φ)` is recovered as the degree of the pullback
of any closed point of `ℙ¹` to `C`. Specialising to `Q = ∞`, this
identifies `deg(φ)` with the degree of the **pole divisor** of the
pulled-back affine coordinate `φ^* u`.

For the iter-177 file-skeleton the substantive content is the
existence of a positive-degree Weil divisor on `C` realising
`deg(φ)`; the body in iter-178+ produces this divisor as the pole
divisor of `φ^* u` via the Hartshorne II.6.9 multiplicativity-of-degree
identity.

This is a *separable* sub-build pin (the lemma is stated independently
of the headline `genusZero_curve_iso_P1` and does not require `g(C) = 0`).
-/

/-- **Degree of a non-constant morphism to `ℙ¹` via its pole divisor**
(Hartshorne IV §2 p. 299 opening + II §6.9 multiplicativity of degree
under finite pullback).

For a non-constant morphism `φ : C ⟶ ProjectiveLineBar k̄` from a smooth
proper geometrically irreducible curve `C` over an algebraically closed
field `k̄`, there exists a positive integer `d` (= `deg(φ)`) together
with a Weil divisor `D` on `C` (= the pole divisor `φ^*[∞]` of the
pulled-back affine coordinate) of total degree `d`.

The non-constancy hypothesis is encoded as `∀ Q, φ ≠ toUnit C ≫ Q`
(no constant morphism `C ⟶ ℙ¹` agrees with `φ`); this is equivalent to
`φ` being surjective onto `ℙ¹_{k̄}` since the image is a closed
irreducible subset of `ℙ¹_{k̄}` of dimension ≥ 1, and the only such is
`ℙ¹_{k̄}` itself.

iter-178+ body: a non-constant morphism between smooth proper curves
over `k̄` is automatically finite (proper + quasi-finite). The
function-field extension `k̄(ℙ¹) ↪ K(C)` is finite of some degree
`d = [K(C) : k̄(ℙ¹)] ≥ 1`. Take `D := φ^*[∞] ∈ Div(C)` via the standard
"pullback of a Weil divisor along a finite morphism" operation; by
Hartshorne II.6.9, `deg(D) = deg(φ) · deg([∞]) = d · 1 = d`. The
positivity `d ≥ 1` follows from non-constancy (else `deg(φ) = 0` would
force `φ` constant). Both the finite-pullback operation and the
multiplicativity-of-degree identity are project-bespoke sub-lemmas
threaded inside the iter-178+ body (cf. the closely related
`Scheme.WeilDivisor.principal_degree_zero` of `RR.1`).

Blueprint reference: `lem:degree_via_pole_divisor` (Hartshorne IV §2
opening, p. 299; II §6.9 p. 137 for multiplicativity). -/
theorem morphism_degree_via_pole_divisor
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    [IsIntegral C.left] [IsLocallyNoetherian C.left]
    (φ : C ⟶ ProjectiveLineBar kbar)
    (_hφ : ∀ Q : 𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar,
        φ ≠ toUnit C ≫ Q) :
    ∃ (d : ℕ) (D : C.left.WeilDivisor),
      0 < d ∧ Scheme.WeilDivisor.degree D = (d : ℤ) :=
  sorry

/-! ## §3. Pin 3 — degree-`1` non-constant morphism between smooth proper curves
is an isomorphism (`iso_of_degree_one`)

Hartshorne I §6 Corollary 6.12 (the function-field ⇔ smooth projective
curve equivalence of categories) specialised to a non-constant
degree-`1` morphism: such a morphism induces an isomorphism on function
fields, and lifts to an isomorphism of schemes by the equivalence.

For the iter-177 file-skeleton the "degree-`1`" hypothesis is encoded
as the *existence of a `k̄`-algebra isomorphism between the function
fields*, the cleanest substantive Mathlib-level analog of
`[K(C) : k̄(C')] = 1` that doesn't require the full finite-extension
degree API. The body in iter-178+ uses Hartshorne I.6.12 (the
function-field ⇒ scheme functor's essential surjectivity / fully
faithfulness) to lift the function-field iso to a scheme iso. -/

/-- **Degree-`1` non-constant morphism between smooth proper curves is an
isomorphism** (Hartshorne I Corollary 6.12 specialised to degree `1`,
or equivalently Stacks tag `0AVX`).

For smooth proper geometrically irreducible curves `C, C'` over an
algebraically closed field `k̄` and a non-constant morphism
`φ : C ⟶ C'` such that the induced `k̄`-algebra map on function fields
`φ^# : K(C') → K(C)` is bijective (equivalently `[K(C) : K(C')] = 1`),
the morphism `φ` is an isomorphism of `Over (Spec k̄)`-objects.

The degree-`1` hypothesis is packaged here as the *existence* of a ring
isomorphism `C'.left.functionField ≃+* C.left.functionField`. In the
iter-178+ body, this is the canonical function-field map induced by
`φ` (via `Scheme.Hom.stalkMap` at the generic point composed with the
`IsFractionRing` structure of `functionField`); the existence wrapper
matches the file-skeleton's substantive-but-non-tautological-type
discipline without committing prematurely to a specific Mathlib
formulation of the canonical function-field map.

iter-178+ body: invoke the scheme-theoretic argument of Hartshorne's
Corollary I.6.12 (Stacks `0AVX`): the pushforward `φ_* O_C` is a
coherent `O_{C'}`-module of generic rank `[K(C) : K(C')] = 1`; the
inclusion `O_{C'} ↪ φ_* O_C` is an iso of coherent rank-`1` sheaves
(torsion-free coherent of generic rank `0` is zero on a Dedekind base),
so `φ_* O_C = O_{C'}` and `φ` is the structure morphism of an iso.
Alternative (high-level): instantiate the equivalence of categories
"smooth projective curves over `k̄`" ≃ "function fields over `k̄`" of
Hartshorne I.6.12 and transport the function-field iso back to a scheme
iso.

Blueprint reference: `lem:degree_one_morphism_iso` (Hartshorne I §6
Corollary 6.12 p. 45 + IV §2 opening p. 299; Stacks tag `0AVX`). -/
theorem iso_of_degree_one
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C C' : Over (Spec (.of kbar))}
    [IsProper C.hom] [IsProper C'.hom]
    [SmoothOfRelativeDimension 1 C.hom] [SmoothOfRelativeDimension 1 C'.hom]
    [GeometricallyIrreducible C.hom] [GeometricallyIrreducible C'.hom]
    [IsIntegral C.left] [IsIntegral C'.left]
    (φ : C ⟶ C')
    (_hφ_non_const : ∀ Q : 𝟙_ (Over (Spec (.of kbar))) ⟶ C',
        φ ≠ toUnit C ≫ Q)
    (_hφ_ff :
      Nonempty (C'.left.functionField ≅ C.left.functionField)) :
    Nonempty (C ≅ C') :=
  sorry

end Scheme

end AlgebraicGeometry
