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
    { t : (ProjectiveLineBar kbar).left.functionField // t ≠ 0 } := by
  classical
  -- The grading on `k̄[X₀, X₁]`.
  let 𝒜 : ℕ → Submodule kbar (MvPolynomial (Fin 2) kbar) :=
    projectiveLineBarGrading kbar
  -- The element `f = X 1` is homogeneous of degree 1.
  let f : MvPolynomial (Fin 2) kbar := MvPolynomial.X 1
  have hf : f ∈ 𝒜 1 := MvPolynomial.isHomogeneous_X kbar 1
  have hf0 : (MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar) ∈ 𝒜 (1 • 1) := by
    simpa using MvPolynomial.isHomogeneous_X kbar 0
  -- The ratio coordinate `X 0 / X 1 ∈ Away 𝒜 (X 1)` (degree 0).
  let x01 : HomogeneousLocalization.Away 𝒜 f :=
    HomogeneousLocalization.Away.mk 𝒜 hf 1 (MvPolynomial.X 0) hf0
  -- Basic facts about `X 0` and `X 1`.
  have hf_ne : f ≠ 0 := MvPolynomial.X_ne_zero 1
  have hX0_ne : (MvPolynomial.X 0 : MvPolynomial (Fin 2) kbar) ≠ 0 :=
    MvPolynomial.X_ne_zero 0
  -- Step (a): `x01 ≠ 0` in `Away 𝒜 (X 1)`.
  have hx01_ne : x01 ≠ 0 := by
    intro heq
    have hval :
        x01.val =
          (0 : HomogeneousLocalization.Away 𝒜 f).val :=
      congrArg HomogeneousLocalization.val heq
    rw [HomogeneousLocalization.val_zero,
        HomogeneousLocalization.Away.val_mk] at hval
    rw [Localization.mk_eq_mk'_apply,
        IsLocalization.mk'_eq_zero_iff] at hval
    obtain ⟨c, hc⟩ := hval
    rcases c.2 with ⟨n, hcn⟩
    have hcv_ne : (c : MvPolynomial (Fin 2) kbar) ≠ 0 := by
      simp only [← hcn]
      exact pow_ne_zero _ hf_ne
    exact hX0_ne ((mul_eq_zero.mp hc).resolve_left hcv_ne)
  -- Step (b): `Away 𝒜 (X 1)` is nontrivial (needed for `Nonempty (basicOpen f)`).
  haveI hL : Nontrivial (Localization.Away f) :=
    (IsLocalization.injective (Localization.Away f)
      (powers_le_nonZeroDivisors_of_noZeroDivisors hf_ne)).nontrivial
  haveI hAway : Nontrivial (HomogeneousLocalization.Away 𝒜 f) := by
    refine ⟨1, 0, ?_⟩
    intro heq
    have hval :
        (1 : HomogeneousLocalization.Away 𝒜 f).val =
          (0 : HomogeneousLocalization.Away 𝒜 f).val :=
      congrArg HomogeneousLocalization.val heq
    rw [HomogeneousLocalization.val_one,
        HomogeneousLocalization.val_zero] at hval
    exact one_ne_zero hval
  -- Step (c): the chart-1 affine open `U = D₊(X 1)` is nonempty (via `awayι`).
  let U : (ProjectiveLineBar kbar).left.Opens := Proj.basicOpen 𝒜 f
  haveI hU_nonempty : Nonempty U := by
    obtain ⟨p⟩ := (inferInstance :
        Nonempty (Spec (CommRingCat.of (HomogeneousLocalization.Away 𝒜 f))))
    refine ⟨⟨(Proj.awayι 𝒜 f hf Nat.one_pos).base p, ?_⟩⟩
    -- The point lies in the image of `awayι`, which equals `basicOpen 𝒜 f`.
    have hrange : (Proj.awayι 𝒜 f hf Nat.one_pos).opensRange = U :=
      Proj.opensRange_awayι 𝒜 f hf Nat.one_pos
    rw [show U = (Proj.awayι 𝒜 f hf Nat.one_pos).opensRange from hrange.symm]
    exact ⟨p, rfl⟩
  -- Step (d): build the section in `Γ(Proj 𝒜, U)`.
  let sec : Γ((ProjectiveLineBar kbar).left, U) :=
    (Proj.basicOpenIsoAway 𝒜 f hf Nat.one_pos).hom.hom x01
  -- Step (e): embed in the function field via `germToFunctionField`.
  refine ⟨((ProjectiveLineBar kbar).left.germToFunctionField U).hom sec, ?_⟩
  -- Step (f): non-zero via injectivity.
  intro ht
  -- `germToFunctionField` is injective on integral schemes.
  have hinj_germ :=
    Scheme.germToFunctionField_injective (ProjectiveLineBar kbar).left U
  have hsec_zero : sec = 0 := by
    apply hinj_germ
    rw [map_zero]
    exact ht
  -- `basicOpenIsoAway` is an iso, hence its `.hom.hom` is injective.
  have hiso_inj :
      Function.Injective
        (CategoryTheory.ConcreteCategory.hom
          (Proj.basicOpenIsoAway 𝒜 f hf Nat.one_pos).hom) :=
    (CategoryTheory.ConcreteCategory.bijective_of_isIso _).1
  apply hx01_ne
  apply hiso_inj
  change sec = (Proj.basicOpenIsoAway 𝒜 f hf Nat.one_pos).hom.hom 0
  rw [hsec_zero, map_zero]
  rfl

/-! ### Iter-190 → iter-191 Lane I Pin 2 corrective substrate
(public `Scheme.WeilDivisor.positivePart` + Hartshorne~II.6.9 public pin)

Per iter-190 plan-phase Pin 2 corrective Option (a): `Hom.poleDivisor` is
defined as `positivePart (principal (algebraMap _ _ t_∞) halg) =
(φ^* t_∞)_0 = φ^*[∞]`. The iter-191 refactor lifts the underlying
`positivePart` def and the `degree_positivePart_principal_eq_finrank`
typed-sorry pin from file-local `private` placeholders to the public
`AlgebraicGeometry.Scheme.WeilDivisor.positivePart` /
`AlgebraicGeometry.Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank`
of `WeilDivisor.lean` (resolving the fully-qualified-name clash that
arose when both files declared the same `Scheme.WeilDivisor.positivePart`
at link time). The consumer in `Hom.poleDivisor_degree_eq_finrank`
below directly applies the public pin specialised at
`t = (localParameterAtInfty kbar).val`. -/

/-- **The pole divisor of a morphism `φ : C → ℙ¹` of smooth proper curves
over `k̄`.** As a Weil divisor on `C`, it is `φ^*[∞]` — the pullback of the
divisor `[∞]` on `ℙ¹` along `φ`.

**iter-190 substantive body (Pin 2 corrective Option (a) — positive part of
principal).** The body is the *positive part* of the principal Weil divisor
on `C` of the pulled-back local parameter
`algebraMap K(ℙ¹) K(C) (localParameterAtInfty kbar).val`:

  `Hom.poleDivisor φ := positivePart (principal (algebraMap K(ℙ¹) K(C) t_∞) _)`

Mathematically, `div(φ^* t_∞) = (φ^* t_∞)_0 − (φ^* t_∞)_∞` on `C`, where
`(φ^* t_∞)_0 = φ^*[∞]` (the zeros of `φ^* t_∞` are exactly the preimages
of `∞`, where `t_∞` vanishes on `ℙ¹`) and `(φ^* t_∞)_∞ = φ^*[0]` (the
poles are the preimages of `0`). Extracting the positive part of
`div(φ^* t_∞)` exactly recovers `φ^*[∞]` on the nose.

**Why the positive-part wrap is essential (Pin 2 structural-conflict
diagnosis, iter-189 → iter-190 corrective).** The naked principal divisor
`principal (algebraMap _ _ t_∞) halg` has degree zero on a complete
nonsingular curve (Hartshorne II.6.10 / Stacks 0BE3,
`Scheme.WeilDivisor.principal_degree_zero` of `WeilDivisor.lean`),
whereas the RHS `Module.finrank K(ℙ¹) K(C)` of
`Hom.poleDivisor_degree_eq_finrank` is positive (= deg φ ≥ 1) at every
call site that uses the φ-induced algebra structure. The positive-part
wrap restores provability: `degree (positivePart (principal (φ^# t_∞)))
= degree (φ^*[∞]) = deg(φ) = [K(C):K(ℙ¹)]` (Hartshorne~II.6.9).

The φ-dependence is carried by the `[Algebra K(ℙ¹) K(C)]` instance
binder, which at every call site is the canonical `φ`-induced
function-field map (per `analogies/ratcurveiso-pin3.md` Decision 2).
Changing the algebra instance changes the divisor; in particular, the
unfolding
`Hom.poleDivisor φ ⇝ positivePart (principal (algebraMap _ _ t) _)`
is visible to definitional unfolding, *not* opaque behind
`Classical.choice` / `Iso.refl _` / empty `proof_wanted` placeholders.

**Helper budget**: 1 named typed sorry (`localParameterAtInfty`, the
local-parameter choice; substrate gap on the chart-`1` ratio coordinate
of `projectiveLineBarAffineCover`). The Pin 2 corrective additionally
introduces a file-local `WeilDivisor.positivePart` def + named typed-sorry
pin `WeilDivisor.degree_positivePart_principal_localParameterAtInfty_eq_finrank`
above; these are scheduled to migrate to the public
`Scheme.WeilDivisor.positivePart` /
`Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank` of
`WeilDivisor.lean` once the parallel iter-190 WeilDivisor prover lands
the public versions.

Blueprint reference: `def:Hom.poleDivisor` (Hartshorne IV §2 opening +
II §6.9; chapter `chap:RiemannRoch_RationalCurveIso` §2 "Convention on
the pole divisor"); iter-190 plan-phase Pin 2 corrective NOTE on
`lem:degree_via_pole_divisor`. -/
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
  -- canonical `φ`-induced algebra map, take its principal divisor, then
  -- extract the positive part (i.e. the zeros, which on a complete curve
  -- coincide with `φ^*[∞]`). The `t_∞ ≠ 0` ⟹ `algebraMap _ _ t_∞ ≠ 0`
  -- step is automatic from injectivity of the algebra map
  -- `K(ℙ¹) → K(C)` (a ring hom out of a field is injective).
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
  WeilDivisor.positivePart
    (Scheme.WeilDivisor.principal
      (algebraMap (ProjectiveLineBar kbar).left.functionField
        C.left.functionField t.val)
      halg)

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
    [Algebra (ProjectiveLineBar kbar).left.functionField C.left.functionField]
    [Module.Finite (ProjectiveLineBar kbar).left.functionField
      C.left.functionField] :
    Scheme.WeilDivisor.degree (Scheme.Hom.poleDivisor φ) =
      (Module.finrank
        (ProjectiveLineBar kbar).left.functionField
        C.left.functionField : ℤ) := by
  -- **iter-190 Pin 2 corrective Option (a) closure** + **iter-191 public-pin
  -- migration** (per iter-191 plan-phase Lane I `lane-i-positivepart-clash-fix`
  -- directive resolving the duplicate fully-qualified-name clash).
  --
  -- The iter-187/iter-189 structural conflict was: the body of `Hom.poleDivisor`
  -- was `Scheme.WeilDivisor.principal (algebraMap _ _ t_∞) halg`, whose degree
  -- is zero on a complete nonsingular curve (`principal_degree_zero` of
  -- `WeilDivisor.lean`) while the RHS `Module.finrank K(ℙ¹) K(C)` is positive
  -- (= deg φ ≥ 1) at every call site with the φ-induced algebra structure.
  -- The iter-190 corrective wraps the principal divisor in a positive-part
  -- operator, recovering `φ^*[∞]` on the nose:
  --   `Hom.poleDivisor φ
  --     = Scheme.WeilDivisor.positivePart (Scheme.WeilDivisor.principal
  --         (algebraMap _ _ (localParameterAtInfty kbar).val) halg)`.
  -- Under this corrected body the theorem reduces (by `unfold`) to the public
  -- Hartshorne~II.6.9 pin
  -- `Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank` of
  -- `WeilDivisor.lean` (iter-191+ body via the affine-chart
  -- `Ideal.sum_ramification_inertia` chain per
  -- `analogies/ratcurveiso-pin2.md` Decision 2), specialised at
  -- `t = (localParameterAtInfty kbar).val`.
  unfold Scheme.Hom.poleDivisor
  exact Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank
    C (localParameterAtInfty kbar).val _

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
    [Algebra (ProjectiveLineBar kbar).left.functionField C.left.functionField]
    [Module.Finite (ProjectiveLineBar kbar).left.functionField
      C.left.functionField] :
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
    Nonempty (C ≅ C') := by
  -- **iter-189 Lane I Pin 3 partial proof (Step 1 closes axiom-clean;
  -- Step 2 is a Mathlib gap — Hartshorne I.6.12 / Stacks 0AVX).**
  --
  -- **Step 1 — function-field iso `K(C') ≃+* K(C)` from `finrank = 1`.**
  -- The `[Algebra K(C') K(C)]` typeclass exhibits `K(C)` as a
  -- `K(C')`-algebra. Under `Module.finrank K(C') K(C) = 1`, the
  -- bottom subalgebra `⊥ ⊂ K(C)` (the image of the algebra map plus
  -- scalars) coincides with `⊤` (the whole field):
  --   `Subalgebra.bot_eq_top_of_finrank_eq_one : finrank F E = 1 → ⊥ = ⊤`
  -- (in `Mathlib.LinearAlgebra.Dimension.FreeAndStrongRankCondition`).
  -- The Mathlib bridge `Algebra.surjective_algebraMap_iff` then says
  -- `surj (algebraMap K(C') K(C)) ↔ ⊤ = ⊥`, so surjectivity follows.
  -- Injectivity is automatic for a ring hom out of a field
  -- (`RingHom.injective`). Bijective + ring hom = ring iso.
  have hbot_eq_top :
      (⊥ : Subalgebra C'.left.functionField C.left.functionField) = ⊤ :=
    Subalgebra.bot_eq_top_of_finrank_eq_one _hφ_deg
  have hsurj : Function.Surjective
      (algebraMap C'.left.functionField C.left.functionField) :=
    Algebra.surjective_algebraMap_iff.mpr hbot_eq_top.symm
  have hinj : Function.Injective
      (algebraMap C'.left.functionField C.left.functionField) :=
    RingHom.injective _
  -- The function-field ring iso. (Constructed but not yet consumed; the
  -- iter-190+ Step 2 body will route through it via the equivalence-of-
  -- categories framing or the scheme-theoretic alternative.)
  let _ψ : C'.left.functionField ≃+* C.left.functionField :=
    RingEquiv.ofBijective
      (algebraMap C'.left.functionField C.left.functionField) ⟨hinj, hsurj⟩
  -- **iter-190 Lane I Pin 3 Step 2(b) progress — `IsProper φ.left` (and
  -- hence `QuasiCompact φ.left`, `QuasiSeparated φ.left`) from the slice-
  -- category composition `C.hom = φ.left ≫ C'.hom`.** The remaining
  -- Mathlib gaps (a), (c), (d) below are unchanged.
  have hφ_w : φ.left ≫ C'.hom = C.hom := φ.w
  haveI hφ_left_isProper : IsProper φ.left := by
    haveI : IsProper (φ.left ≫ C'.hom) := hφ_w ▸ (inferInstance : IsProper C.hom)
    exact (IsProper.comp_iff (f := φ.left) (g := C'.hom)).mp inferInstance
  -- `QuasiCompact φ.left` and `QuasiSeparated φ.left` are now auto-derived
  -- from `[IsProper φ.left]` (Mathlib `instOfIsProper` chain), closing
  -- sub-step (b) of the four-step Mathlib-hammer plan.
  haveI : QuasiCompact φ.left := inferInstance
  haveI : QuasiSeparated φ.left := inferInstance
  -- **Step 2 (typed sorry, Mathlib gap) — lift the function-field iso to
  -- a slice-category iso `C ≅ C'` in `Over (Spec (.of kbar))`.**
  --
  -- Mathlib has no "birational ⟹ iso for smooth proper curves" lemma,
  -- no `IsBirational`, no Zariski's-main-theorem wrapper at the curve
  -- level (per `analogies/ratcurveiso-pin3.md` Decision 1). The closest
  -- Mathlib lemma is `Scheme.Hom.instIsIsoToNormalizationOfIsIntegralHom`
  -- (`Mathlib.AlgebraicGeometry.Normalization`):
  --   `[QuasiCompact f] [QuasiSeparated f] [IsIntegralHom f]
  --     ⟹ IsIso (Scheme.Hom.toNormalization f)`.
  -- Using it requires:
  --
  -- (a) **`[IsIntegralHom φ.left]`** — finite ⟹ integral
  --     (`IsFinite.instIsIntegralHom`). Finite follows from
  --     `IsFinite.iff_isProper_and_isAffineHom` once `[IsAffineHom φ.left]`
  --     is exhibited; the latter from non-constancy of φ +
  --     `SmoothOfRelativeDimension 1` on both C and C'
  --     (a quasi-finite proper morphism is finite; smooth-dim-1 + non-
  --     constancy ⟹ quasi-finite via fibre-dim argument).
  --
  -- (b) **`[QuasiCompact φ.left]`, `[QuasiSeparated φ.left]`** —
  --     automatic from `[IsProper C.hom]` + `[IsProper C'.hom]`
  --     (proper ⟹ qcqs over a fixed base, but here we need them for
  --     `φ.left` as a morphism of schemes; the chain via
  --     `IsProper.instOfIsFinite`-companion lemmas closes this).
  --
  -- (c) **`Scheme.Hom.normalization φ.left = C'.left`** — under
  --     smoothness of `C'.hom`, `C'.left` is regular hence normal,
  --     hence integrally closed, so the integral closure of
  --     `O_{C'.left}` inside `(φ.left)_* O_{C.left}` is `O_{C'.left}`
  --     itself. Combined with the degree-1 hypothesis of Step 1
  --     (which says `K(C') ≃ K(C)` so the integral closure
  --     extension is trivial), `fromNormalization φ.left` is iso.
  --
  -- (d) **Slice-category lift**: package `C ≅ C'` in `Over (Spec (.of kbar))`
  --     from the underlying `C.left ≅ C'.left`, using `Over.isoMk` plus
  --     the commutation with the structure morphisms `C.hom`, `C'.hom`.
  --     The commutation follows from uniqueness of morphisms to
  --     `Spec (.of kbar)` (since `Spec` is the right adjoint of `Γ`,
  --     and both `C.left` and `C'.left` carry the same `kbar`-algebra
  --     structure on global sections, induced by the iso `_ψ` between
  --     their function fields — restricted via the closed embedding
  --     `Spec.map (algebraMap kbar _)`).
  --
  -- Each of (a)-(d) is ~50-150 LOC of new infrastructure; the budget
  -- per `analogies/ratcurveiso-pin3.md` is ~80-150 LOC for the body.
  -- This work is deferred to iter-190+ with a possible
  -- `mathlib-analogist` consult on (a) (the smooth-proper-curve →
  -- IsAffineHom Mathlib gap) and (c) (the
  -- `fromNormalization = id under normal target + degree-1` chain).
  sorry

end Scheme

end AlgebraicGeometry
