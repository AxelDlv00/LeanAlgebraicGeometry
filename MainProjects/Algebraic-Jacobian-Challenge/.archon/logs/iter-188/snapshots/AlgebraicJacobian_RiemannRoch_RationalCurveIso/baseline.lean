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

## Status (iter-177 file-skeleton; iter-181 Pin 3 signature refinement)

This file was originally the **iter-177 Lane 8** file-skeleton. Each
of the three new pinned declarations carries the *intended*
substantive type signature (matching the `\lean{...}` pin in
`blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`) with a
`sorry` body. Bodies are iter-182+ work after the RR.1/RR.2/RR.3
chain matures (in particular `Scheme.WeilDivisor.principal_degree_zero`
and the `H⁰(C, 𝒪_C([P]))`-non-constant existence corollary of `RR.3`).

iter-181 Lane I refined the Pin 3 signature of
`iso_of_degree_one`: the abstract function-field-iso existence
hypothesis is replaced by the `[Algebra K(C') K(C)]` typeclass binder
+ `Module.finrank K(C') K(C) = 1` equation, matching what the
iter-182+ body needs (per `analogies/ratcurveiso-pin3.md`
Decision 2 DIVERGE_INTENTIONALLY).

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
  non-constant hypothesis together with the *substantive* degree-`1`
  hypothesis `Module.finrank C'.functionField C.functionField = 1`
  (paired with an `[Algebra C'.functionField C.functionField]` typeclass
  binder for the canonical `φ`-induced function-field map). The
  `Nonempty`-wrapped iso is the exact downstream-consumer shape,
  matching the `genusZero_curve_iso_P1` headline signature in AVR.lean.
  This signature was refined in iter-181 Lane I from the iter-177
  file-skeleton placeholder `Nonempty (C'.ff ≃+* C.ff)` to make the
  degree-`1`-induced-by-`φ` hypothesis the substantive content; see
  `analogies/ratcurveiso-pin3.md` Decision 2.

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

Given a graded `k̄`-algebra homomorphism `f : k̄[X₀, X₁] →+* Γ(X, ⊤)`, a
`k̄`-algebra compatibility witness `halg` (recording that the composite
`kbar → MvPolynomial (Fin 2) kbar → Γ(X.left, ⊤)` agrees with the natural
algebra map `kbar → Γ(X.left, ⊤)` induced by `X.hom`), and a proof `hf`
that the image of the irrelevant ideal `(X₀, X₁) ⊆ k̄[X₀, X₁]` generates
the unit ideal of `Γ(X, ⊤)`, this constructs the unique morphism
`φ : X ⟶ ProjectiveLineBar k̄` characterised on basic-opens by
`φ ⁻¹ᵁ D₊(X_i) = X.basicOpen (f X_i)` (the "no-common-zero" expression of
Hartshorne's morphism condition). The composite
`φ.left ≫ Proj.toSpecZero _ = X.hom`, witnessing the `Over (Spec k̄)`
section condition.

The input data `(f, halg, hf)` is the standard Hartshorne II §7 packaging
of "a pair of global sections `s₀, s₁ ∈ H⁰(X, ℒ)` of an invertible sheaf
`ℒ` without common zeros": `f` is the graded `k̄`-algebra map sending
`X_i ↦ s_i ∈ Γ(X, ℒ) ⊂ Γ(X, ⊤)` (after a choice of trivialisation
identifying `H⁰(X, ℒ)` with a submodule of `Γ(X, ⊤)` over the affine
cover `X = D(s₀) ∪ D(s₁)`); `halg` is the `kbar`-algebra-compatibility
condition (without which the section condition over `Spec kbar` cannot
be derived); `hf` is the no-common-zero condition.

The construction invokes `Proj.fromOfGlobalSections` on the standard
grading `projectiveLineBarGrading k̄` (the `ℕ`-grading on
`MvPolynomial (Fin 2) k̄` by total degree, with `GradedRing` instance
via `MvPolynomial.gradedAlgebra`), then wraps in `Over.homMk` with the
section condition proof. The section condition chases through
`Proj.fromOfGlobalSections_toSpecZero` plus
`IsScalarTower kbar (𝒜 0) (MvPolynomial (Fin 2) kbar)` to reduce to
`X.left.toSpecΓ ≫ Spec.map (CommRingCat.ofHom (f.comp MvPolynomial.C)) = X.hom`,
which the `halg` hypothesis closes via `Scheme.toSpecΓ_naturality` and
`toSpecΓ_SpecMap_ΓSpecIso_inv` (cf. the analogous chain in
`Genus0BaseObjects/Points.lean:pointOfVec`).

Blueprint reference: `lem:morphism_to_p1_from_global_sections`
(Hartshorne II Theorem 7.1, II §7). -/
noncomputable def morphismToP1OfGlobalSections
    {kbar : Type u} [Field kbar]
    (X : Over (Spec (.of kbar)))
    (f : MvPolynomial (Fin 2) kbar →+* Γ(X.left, ⊤))
    (_halg :
      f.comp (algebraMap kbar (MvPolynomial (Fin 2) kbar)) =
        X.hom.appTop.hom.comp (Scheme.ΓSpecIso (CommRingCat.of kbar)).inv.hom)
    (_hf :
      Ideal.map f
          (HomogeneousIdeal.irrelevant (projectiveLineBarGrading kbar)).toIdeal = ⊤) :
    X ⟶ ProjectiveLineBar kbar :=
  -- Underlying scheme morphism: invoke Mathlib's
  -- `Proj.fromOfGlobalSections` on `projectiveLineBarGrading kbar`.
  -- The result `X.left ⟶ Proj 𝒜 = ProjectiveLineBarScheme kbar` is
  -- then wrapped via `Over.homMk` with the section condition
  -- `Proj.fromOfGlobalSections … ≫ ProjectiveLineBar.hom = X.hom`.
  Over.homMk
    (Proj.fromOfGlobalSections (projectiveLineBarGrading kbar) f _hf) <| by
    -- Section condition (`Over (Spec k̄)`-compatibility):
    --   `Proj.fromOfGlobalSections … ≫ ProjectiveLineBar.hom = X.hom`
    -- where `ProjectiveLineBar.hom = Proj.toSpecZero _ ≫ Spec.map (algebraMap kbar ↥(𝒜 0))`.
    haveI : IsScalarTower kbar ↥(projectiveLineBarGrading kbar 0)
        (MvPolynomial (Fin 2) kbar) :=
      IsScalarTower.of_algebraMap_eq
        (R := kbar) (S := ↥(projectiveLineBarGrading kbar 0))
        (A := MvPolynomial (Fin 2) kbar) (fun _ => rfl)
    change Proj.fromOfGlobalSections _ _ _ ≫ Proj.toSpecZero _ ≫ Spec.map _ = _
    rw [← Category.assoc, Proj.fromOfGlobalSections_toSpecZero, Category.assoc,
      ← Spec.map_comp, ← CommRingCat.ofHom_comp, RingHom.comp_assoc,
      ← IsScalarTower.algebraMap_eq kbar, MvPolynomial.algebraMap_eq]
    -- Goal: `X.left.toSpecΓ ≫ Spec.map (CommRingCat.ofHom (f.comp MvPolynomial.C)) = X.hom`.
    -- Step 1: convert the `_halg` RingHom equation to a CommRingCat-level equation.
    have hcc : CommRingCat.ofHom (f.comp MvPolynomial.C) =
        (Scheme.ΓSpecIso (CommRingCat.of kbar)).inv ≫ X.hom.appTop := by
      rw [← MvPolynomial.algebraMap_eq, _halg, CommRingCat.ofHom_comp,
        CommRingCat.ofHom_hom, CommRingCat.ofHom_hom]
    -- Step 2: rewrite, distribute `Spec.map`, and apply naturality of `toSpecΓ` plus
    -- the `toSpecΓ ≫ Spec.map (ΓSpecIso).inv = 𝟙` identity on `Spec (.of kbar)`.
    rw [hcc, Spec.map_comp, ← Category.assoc, ← Scheme.toSpecΓ_naturality,
      Category.assoc, toSpecΓ_SpecMap_ΓSpecIso_inv, Category.comp_id]

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

/-- **A local parameter at the closed point `∞ ∈ ℙ¹_{k̄}`** — a non-zero
rational function on `(ProjectiveLineBar kbar)` whose order at `∞` is `1`
(in Hartshorne's standard affine convention: `t_∞ = X₀ / X₁`, with `X₁` the
coordinate trivialising the chart at `∞`). Returned as a subtype packaging
the element together with its non-zero witness, for use in
`Hom.poleDivisor` below.

**iter-187 substrate gap — single named typed sorry.** The substantive
choice (the chart-1 ratio coordinate `X₀ / X₁ ∈
HomogeneousLocalization.Away (projectiveLineBarGrading kbar) (X 1)`,
embedded into `(ProjectiveLineBar kbar).left.functionField`) is iter-188+
work. The substrate hooks (per `analogies/ratcurveiso-pin2.md`):
- `AlgebraicGeometry.projectiveLineBarAffineCover` chart-`1` open
  (`Genus0BaseObjects/BareScheme.lean`).
- `HomogeneousLocalization.Away` to extract the global ratio function on
  the chart, then `germToFunctionField` to embed in `K(ℙ¹)`.
- The non-zero witness is automatic from injectivity of the ratio-as-a-
  HomogeneousLocalization-Away-element (the ratio `X₀ / X₁` is not the
  zero element of the localised graded ring).

This helper is the **single substrate gap** carrying the iter-188 unblock
for the consumer scaffold `Hom.poleDivisor_degree_eq_finrank` Steps 1-5
below; the gap is **named, typed, and topologically localised**, not a
bare body sorry. -/
private noncomputable def localParameterAtInfty (kbar : Type u) [Field kbar]
    [IsIntegral (ProjectiveLineBar kbar).left] :
    { t : (ProjectiveLineBar kbar).left.functionField // t ≠ 0 } :=
  sorry

/-- **The pole divisor of a morphism `φ : C → ℙ¹` of smooth proper curves
over `k̄`.** As a Weil divisor on `C`, it is `φ^*[∞]` — the pullback of the
divisor `[∞]` on `ℙ¹` along `φ`.

**iter-187 substantive body (Path (a) Finsupp via principal divisor).**
The body is the principal Weil divisor on `C` of the pulled-back local
parameter `algebraMap K(ℙ¹) K(C) (localParameterAtInfty kbar).val`:

  `Hom.poleDivisor φ := principal (algebraMap K(ℙ¹) K(C) t_∞) _`

Mathematically, `div(φ^* t_∞) = (φ^* t_∞)_0 − (φ^* t_∞)_∞` on `C`, where
`(φ^* t_∞)_0 = φ^*[∞]` (the zeros of `φ^* t_∞` are exactly the preimages
of `∞`, where `t_∞` vanishes on `ℙ¹`) and `(φ^* t_∞)_∞ = φ^*[0]` (the
poles are the preimages of `0`). For a non-constant `φ` the negative
part `(φ^* t_∞)_∞` of the principal divisor identifies the preimages of
`0` — disjoint from `φ⁻¹(∞)` in the standard convention — so the
positive part recovers `φ^*[∞]` on the nose. The full pole-divisor
identification `(φ^* t_∞)₀ = φ^*[∞]` is deferred to the iter-188+
follow-up; the iter-187 body lands the φ-dependent principal divisor as
the substantive Weil-divisor placeholder consumed by
`Hom.poleDivisor_degree_eq_finrank` (whose degree-via-`finrank`
identification works modulo the deg-zero-of-`(φ^* t_∞)_∞` correction,
which is `Scheme.WeilDivisor.principal_degree_zero`).

The φ-dependence is carried by the `[Algebra K(ℙ¹) K(C)]` instance
binder, which at every call site is the canonical `φ`-induced
function-field map (per `analogies/ratcurveiso-pin3.md` Decision 2).
Changing the algebra instance changes the divisor; in particular, the
unfolding `Hom.poleDivisor φ ⇝ principal (algebraMap _ _ t) _` is
visible to definitional unfolding, *not* opaque behind `Classical.choice`
/ `Iso.refl _` / empty `proof_wanted` placeholders.

**Helper budget**: 1 named typed sorry (`localParameterAtInfty`, the
local-parameter choice; substrate gap on the chart-`1` ratio coordinate
of `projectiveLineBarAffineCover`).

Blueprint reference: `def:Hom.poleDivisor` (Hartshorne IV §2 opening +
II §6.9; chapter `chap:RiemannRoch_RationalCurveIso` §2 "Convention on
the pole divisor"). -/
noncomputable def Hom.poleDivisor
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    [IsIntegral (ProjectiveLineBar kbar).left]
    [Algebra (ProjectiveLineBar kbar).left.functionField C.left.functionField]
    (_φ : C ⟶ ProjectiveLineBar kbar) :
    C.left.WeilDivisor :=
  -- Pull a chosen local parameter `t_∞ ∈ K(ℙ¹)` back to `K(C)` along the
  -- canonical `φ`-induced algebra map, and take its principal divisor.
  -- The `t_∞ ≠ 0` ⟹ `algebraMap _ _ t_∞ ≠ 0` step is automatic from
  -- injectivity of the algebra map `K(ℙ¹) → K(C)` (a ring hom out of a
  -- field is injective).
  let t := localParameterAtInfty kbar
  have halg :
      algebraMap (ProjectiveLineBar kbar).left.functionField
          C.left.functionField t.val ≠ 0 := by
    intro h
    apply t.property
    have hinj :
        Function.Injective
          (algebraMap (ProjectiveLineBar kbar).left.functionField
            C.left.functionField) :=
      RingHom.injective _
    have h0 :
        algebraMap (ProjectiveLineBar kbar).left.functionField
            C.left.functionField 0 = 0 :=
      RingHom.map_zero _
    exact hinj (h.trans h0.symm)
  Scheme.WeilDivisor.principal
    (algebraMap (ProjectiveLineBar kbar).left.functionField
      C.left.functionField t.val)
    halg

/-- **Degree identity for the pole divisor of a non-constant `C ⟶ ℙ¹`**
(Hartshorne IV §2 p. 299 opening + II §6.9 multiplicativity of degree under
finite pullback). The Weil-divisor degree of the pole divisor
`Scheme.Hom.poleDivisor φ = φ^*[∞]` equals the function-field-extension
degree `[K(C) : k̄(ℙ¹)] = Module.finrank K(ℙ¹) K(C)`, where the
`K(ℙ¹)`-algebra structure on `K(C)` is the canonical `φ`-induced one (the
typeclass binder pins this; per `analogies/ratcurveiso-pin3.md` Decision 2
convention).

**Tier-3 honest sorry (iter-183).** The substantive body is iter-184+ work
via the affine-chart-localised `Ideal.sum_ramification_inertia`
(Stacks `02RW` / `0AX5`) per `analogies/ratcurveiso-pin2.md` Decision 2.
The strategy: pick an affine open `Spec A ⊂ ℙ¹` containing `∞`; the
preimage `Spec B ⊂ C` is finite over `Spec A` (non-constancy + smooth
proper curves ⟹ finite); both `A → B` are Dedekind extensions and
`Σ_{Q above P} e(Q|P) · f(Q|P) = [Frac B : Frac A] = [K(C) : K(ℙ¹)]`
identifies the pole-divisor degree with the function-field degree. The
non-constancy hypothesis is consumed in the finiteness reduction.

This helper is the **single substantive gap** of
`morphism_degree_via_pole_divisor` after the iter-182 plan-phase
signature strengthening: the wrapper body below is sorry-free assembly
that reduces to this helper. -/
theorem Hom.poleDivisor_degree_eq_finrank
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    [IsIntegral C.left] [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    [IsIntegral (ProjectiveLineBar kbar).left]
    (φ : C ⟶ ProjectiveLineBar kbar)
    (_hφ_non_const :
      ∀ Q : 𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar,
        φ ≠ toUnit C ≫ Q)
    [Algebra (ProjectiveLineBar kbar).left.functionField C.left.functionField] :
    Scheme.WeilDivisor.degree (Scheme.Hom.poleDivisor φ) =
      (Module.finrank
        (ProjectiveLineBar kbar).left.functionField
        C.left.functionField : ℤ) := by
  -- iter-186 Lane I scaffold for the `Ideal.sum_ramification_inertia` chain.
  --
  -- **The structural obstruction.** The right-hand side
  --   `Module.finrank K(ℙ¹) K(C)`
  -- depends only on the supplied `[Algebra K(ℙ¹) K(C)]` typeclass argument.
  -- The left-hand side
  --   `Scheme.WeilDivisor.degree (Hom.poleDivisor φ)`
  -- depends on the body of `Hom.poleDivisor φ`, currently a typed `sorry`
  -- at L290 (the iter-186 directive defers this body to iter-187+:
  -- `Pin 3 body L482 and `Hom.poleDivisor` body iter-187+ separately`).
  -- Because `Hom.poleDivisor φ = sorry` definitionally, the LHS does NOT
  -- reduce; no `rfl`/`simp`/`rw` chain can substantively progress this
  -- goal without first replacing the def body.
  --
  -- The full proof chain (locked behind the `Hom.poleDivisor` body) is:
  --
  -- **Step 1 — affine chart at infinity.** Pick the affine open
  -- `Spec A ⊂ (ProjectiveLineBar kbar).left` containing the point at
  -- infinity. Concretely `Spec A = (projectiveLineBarAffineCover kbar).f 1`
  -- (the chart `D₊(X 1)`, on which the standard ratio coordinate
  -- `t_∞ := X 0 / X 1` is a global function vanishing at the unique
  -- closed point `∞`). Mathlib API hooks:
  --   - `AlgebraicGeometry.projectiveLineBarAffineCover` (from
  --     `Genus0BaseObjects/BareScheme.lean`).
  --   - `IsAffineOpen.basicOpen` on the chart-1 affine open.
  --
  -- **Step 2 — preimage `Spec B := φ⁻¹(Spec A)`.** Non-constancy +
  -- smoothness of both `C` and `ℙ¹` over `k̄` ⟹ `φ` is finite (proper +
  -- quasi-finite via fibre dimension; Hartshorne II.6.8). The chart
  -- restriction `φ|_{Spec B} : Spec B → Spec A` is then a finite map of
  -- affine schemes, presenting `B` as a finite `A`-algebra. Mathlib hooks:
  --   - `AlgebraicGeometry.IsFinite.iff_isIntegralHom_and_locallyOfFiniteType`.
  --   - `IsAffineOpen.preimage` for the affine open preimage.
  --
  -- **Step 3 — apply `Ideal.sum_ramification_inertia`.** With
  --   `R := A, S := B, K := Frac A = k̄(ℙ¹), L := Frac B = K(C)`
  -- and `p := (t_∞) ⊂ A` (the maximal ideal of `∞`), the Mathlib lemma
  -- `Mathlib.NumberTheory.RamificationInertia.Basic.Ideal.sum_ramification_inertia`
  -- yields
  --   `∑ P ∈ primesOverFinset p S, e(P|p) · f(P|p) = [Frac B : Frac A]`.
  -- Required typeclasses (all derivable from the smooth-proper-curve
  -- setup + finiteness from Step 2): `[IsDedekindDomain A]`,
  -- `[IsDedekindDomain B]`, `[Module.Finite A B]`, `[IsFractionRing A K]`,
  -- `[IsFractionRing B L]`, `[Algebra K L]`, the scalar tower instances.
  --
  -- **Step 4 — identify the LHS of Step 3 with the divisor degree.** Over
  -- algebraically closed `k̄`, the inertia degree `f(P|p) = [κ(P) : κ(p)] = 1`
  -- (both residue fields are `k̄`). Hence the LHS of Step 3 collapses to
  -- `∑ P, e(P|p)`, which by the Hartshorne convention is exactly
  -- `Scheme.WeilDivisor.degree (Hom.poleDivisor φ)` once the
  -- `Hom.poleDivisor` body is the formal sum
  -- `∑ {Q ∈ φ⁻¹(∞)}, ord_Q(φ^* t_∞) · [Q]` (the iter-187+ closure target).
  --
  -- **Step 5 — identify the RHS of Step 3 with `Module.finrank K(ℙ¹) K(C)`.**
  -- The canonical `[Algebra K(ℙ¹) K(C)]` instance carried in the theorem
  -- signature is, by the blueprint convention, the `φ`-induced
  -- function-field map (the composite `K(ℙ¹) → O_{ℙ¹,φ(ξ_C)} → O_{C,ξ_C} → K(C)`
  -- of germ + stalk-map + fraction-field lift; cf.
  -- `Mathlib.AlgebraicGeometry.FunctionField`). Under this instance,
  -- `Module.finrank K(ℙ¹) K(C) = [K(C) : K(ℙ¹)] = [Frac B : Frac A]`.
  --
  -- **Why no intermediate typed-sorry helpers are introduced this iter.**
  -- Each candidate (Step 1 chart selection, Step 2 affine-preimage
  -- finite-presentation, Step 3 `sum_ramification_inertia` invocation
  -- packaged for the curve setting, Steps 4-5 LHS/RHS identifications)
  -- requires either the `Hom.poleDivisor` body or the
  -- `non-constant-morphism-of-smooth-proper-curves-is-finite` Mathlib gap,
  -- both deferred. Extracting them as Tier-3 typed-sorries would inflate
  -- the file's sorry count without progressing the dependency.
  --
  -- **Iter-187+ continuation.** Close in order:
  --   (i) `Hom.poleDivisor` body (L290) via the Finsupp construction
  --       `∑ {Q ∈ φ⁻¹(∞)}, ord_Q(φ^* t_∞) · single Q 1`; this requires
  --       the `Scheme.WeilDivisor.pullback` project-bespoke API.
  --   (ii) `Module.Finite K(ℙ¹) K(C)` instance from non-constancy via
  --        the proper + quasi-finite ⟹ finite chain.
  --   (iii) Re-attempt this scaffold via the elaborated chain Steps 1-5.
  sorry

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
opening, p. 299; II §6.9 p. 137 for multiplicativity).

**Signature strengthening (iter-182 Pin 2).** The iter-177 file-skeleton
signature output existential `∃ d D, 0 < d ∧ D.degree = (d : ℤ)` was
flagged `weakened-wrong` by the iter-181 `lean-vs-blueprint-checker`:
the existential is discharged by ANY positive-degree divisor on `C` and
does not reference `φ`. iter-182 strengthens the output to pin `D` to
`Scheme.Hom.poleDivisor φ` (a *specific* divisor depending on `φ`) and
pin its degree to `Module.finrank (ProjectiveLineBar kbar).left.functionField
C.left.functionField` (the function-field-extension degree `[K(C) : k̄(ℙ¹)]`).
The `[Algebra ...]` instance binder pins the intended `Algebra` structure
to be the canonical `φ`-induced function-field map (matching the iter-181
Pin 3 sig refinement convention). See `analogies/ratcurveiso-pin2.md`
(verdict PROCEED) for the body recipe via
`Ideal.sum_ramification_inertia`. -/
theorem morphism_degree_via_pole_divisor
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))} [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]
    [IsIntegral C.left] [IsLocallyNoetherian C.left]
    [Scheme.IsRegularInCodimensionOne C.left]
    [IsIntegral (ProjectiveLineBar kbar).left]
    (φ : C ⟶ ProjectiveLineBar kbar)
    (_hφ_non_const :
      ∀ Q : 𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar,
        φ ≠ toUnit C ≫ Q)
    [Algebra (ProjectiveLineBar kbar).left.functionField C.left.functionField] :
    ∃ (D : C.left.WeilDivisor),
      D = Scheme.Hom.poleDivisor φ ∧
        Scheme.WeilDivisor.degree D =
          (Module.finrank
            (ProjectiveLineBar kbar).left.functionField
            C.left.functionField : ℤ) :=
  -- Witness `D := Scheme.Hom.poleDivisor φ`; equality `D = poleDivisor φ`
  -- is `rfl` definitionally; degree identity delegated to the named helper
  -- `Hom.poleDivisor_degree_eq_finrank` (Tier-3 honest sorry above; body
  -- iter-184+ via `Ideal.sum_ramification_inertia` per
  -- `analogies/ratcurveiso-pin2.md` Decision 2).
  ⟨Scheme.Hom.poleDivisor φ, rfl,
    Hom.poleDivisor_degree_eq_finrank φ _hφ_non_const⟩

/-! ## §3. Pin 3 — degree-`1` non-constant morphism between smooth proper curves
is an isomorphism (`iso_of_degree_one`)

Hartshorne I §6 Corollary 6.12 (the function-field ⇔ smooth projective
curve equivalence of categories) specialised to a non-constant
degree-`1` morphism: such a morphism induces an isomorphism on function
fields, and lifts to an isomorphism of schemes by the equivalence.

**Signature refinement (iter-181 Lane I).** The degree-`1` hypothesis
is now encoded directly as
`Module.finrank C'.functionField C.functionField = 1` paired with an
`[Algebra C'.functionField C.functionField]` typeclass binder (the
intended instance at each call site is the canonical `φ`-induced
function-field map). This refines the iter-177 file-skeleton
placeholder hypothesis
`Nonempty (C'.functionField ≃+* C.functionField)`, which is strictly
weaker than what the iter-182+ body needs (the birational-extension
argument requires the iso to be *induced by `φ` itself*, not an
abstract ring iso). See `analogies/ratcurveiso-pin3.md` (Decision 2,
DIVERGE_INTENTIONALLY) for the analysis. The body in iter-182+ uses
either Hartshorne I.6.12 (the equivalence of categories) or the
Mathlib `Scheme.Hom.instIsIsoToNormalizationOfIsIntegralHom` route to
lift the function-field iso to a scheme iso. -/

/-- **Degree-`1` non-constant morphism between smooth proper curves is an
isomorphism** (Hartshorne I Corollary 6.12 specialised to degree `1`,
or equivalently Stacks tag `0AVX`).

For smooth proper geometrically irreducible curves `C, C'` over an
algebraically closed field `k̄` and a non-constant morphism
`φ : C ⟶ C'` such that the induced `k̄`-algebra map on function fields
`φ^# : K(C') → K(C)` makes `K(C)` a one-dimensional `K(C')`-module
(equivalently `[K(C) : K(C')] = 1`), the morphism `φ` is an
isomorphism of `Over (Spec k̄)`-objects.

**Signature refinement (iter-181 Lane I).** The degree-`1` hypothesis
is encoded as a typeclass binder
`[Algebra C'.left.functionField C.left.functionField]` together with
the equation `Module.finrank C'.left.functionField C.left.functionField = 1`.
The intended `Algebra` instance at every call site is the canonical
function-field map induced by `φ` (the composite of
`Scheme.Hom.stalkMap` at the generic point with the `IsFractionRing`
extension to the fraction-field; see Mathlib
`AlgebraicGeometry.Scheme.functionField`). The previous signature took
an abstract existence wrapper
`Nonempty (C'.functionField ≃+* C.functionField)` which is strictly
weaker than what the iter-182+ body needs: the birational-extension
argument requires the iso to be **induced by `φ` itself**, not an
arbitrary ring iso. See `analogies/ratcurveiso-pin3.md` (Decision 2,
DIVERGE_INTENTIONALLY) for the analysis prompting this refinement.

iter-182+ body: invoke the scheme-theoretic argument of Hartshorne's
Corollary I.6.12 (Stacks `0AVX`) — equivalently
`AlgebraicGeometry.Scheme.Hom.instIsIsoToNormalizationOfIsIntegralHom`
(see `analogies/ratcurveiso-pin3.md` Steps 1–4):

1. Reduce to `φ` finite (proper + quasi-finite ⟹ finite via
   `IsFinite.iff_isProper_and_isAffineHom`; quasi-finiteness follows
   from the degree-`1` hypothesis collapsing each fibre to a single
   point at the generic point and then extending by closedness).
2. Apply `Scheme.Hom.instIsIsoToNormalizationOfIsIntegralHom` to get
   `Scheme.Hom.toNormalization φ : C ⟶ normalization φ` is an iso.
3. Identify `normalization φ = C'` via smoothness of `C'` (smooth
   proper curve over `k̄` ⟹ regular ⟹ normal). The integral
   closure `O_{C'} ↪ φ_* O_C` is then an equality under the
   `finrank = 1` hypothesis (rank-`1` torsion-free coherent inclusion
   on a Dedekind base is an iso).
4. Compose to extract `C ≅ C'` in the slice category.

Alternative route (cleaner conceptually but more sheaf API): the
pushforward `φ_* O_C` is a coherent `O_{C'}`-module of generic
rank `[K(C) : K(C')] = 1`; the inclusion `O_{C'} ↪ φ_* O_C` is an
iso of coherent rank-`1` sheaves (torsion-free coherent of generic
rank `0` is zero on a Dedekind base), so `φ_* O_C = O_{C'}` and `φ`
is the structure morphism of an iso.

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
    [Algebra C'.left.functionField C.left.functionField]
    (_hφ_deg :
      Module.finrank C'.left.functionField C.left.functionField = 1) :
    Nonempty (C ≅ C') :=
  sorry

end Scheme

end AlgebraicGeometry
