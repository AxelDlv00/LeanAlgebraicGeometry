/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.RiemannRoch.Ledger.FiberBound
import AlgebraicJacobian.RiemannRoch.CurveBaseChange

/-!
# Extension-uniformity: the free half WITNESSED, and the open half reduced to one scalar

`Ledger/FiberBound.lean` closes cluster-P items 1 and 3 over a *single* field `k`, and its
closing section says extension-uniformity splits into a free half and an open half.  That
section states the free half as a property of three **morphism classes**
(`baseChange_binders_stable`: `IsProper`, `SmoothOfRelativeDimension 1` and
`GeometricallyIrreducible` are each stable under base change).  That is true, and it is not
the same statement as "the vanishing theorem re-fires at the base-changed curve": a class
being stable under base change says nothing until some object is exhibited carrying the
base-changed instances, in the spelling the consuming theorem actually elaborates against.

This file supplies the object.  `Scheme.baseChangeField C κ` (`RiemannRoch/CurveBaseChange.lean`)
is AJC's named base-changed curve `C_κ = C ×_{Spec k} Spec κ`, and it already carries
`IsProper`, `SmoothOfRelativeDimension 1` and `GeometricallyIntegral` as **named instances**.
One instance was missing from that stack — `GeometricallyIrreducible`, which is what the
`Ledger` curve statements bind — and `geometricallyIrreducible_hom_baseChangeField` below adds
it.  With it, every curve-level statement of `FiberBound` applies to `C_κ` **by instance
synthesis alone**, at base field `κ`, with no new mathematics and no hypothesis on `κ/k`: not
finiteness, not separability, not perfectness.

## What is proved here, and what is deliberately not

* `vanishing_baseChangeField` / `riemannRoch_baseChangeField` — the **free half, witnessed**:
  a threshold `b(κ)` exists at `C_κ` for every `κ`, and exact Riemann–Roch holds above it with
  the base-changed genus `genus C_κ`.  This is the honest content of "the theorem re-fires per
  field", now stated at an object rather than about a class.
* `UniformVanishing` — the **open half, named as a definition** so that consumers can quantify
  over it and so that its exact quantifier order is inspectable: `∃ b, ∀ κ, ∀ D on C_κ, …`.
  The `b` is chosen **before** `κ`.  This is *not* proved here and this file does not claim it.
* `uniformVanishing_of_uniform_base_of_genus_invariant` — the **reduction**: the open half
  follows from exactly **two** inputs, a uniform degree bound on a vanishing base divisor and
  base-field invariance of the genus.  Neither is proved here; both are named precisely.

## What the constant actually decomposes into (correcting my own earlier account)

`FiberBound`'s closing docstring located the obstruction in the constant: `b(κ)` is built from
`n₀(κ)`, a `Classical.choose` on a Noetherian stabilization re-run at each base field, and
nothing relates `n₀(κ)` to `n₀(k)`.  That describes the *proof*, not the *problem*.  The
threshold produced by `DegreeVanishing.exists_bound_subsingleton_hModule_one` is

`b = deg D₀ + 1 − χ(𝒪)`,

and that existential is **monotone in `b`** (a `D` of degree `≥ b'` has degree `≥ b` whenever
`b ≤ b'`).  So `n₀` itself never has to transport: it suffices to bound `b(κ)` above by
something independent of `κ`.  Since `χ(𝒪_{C_κ}) = 1 − genus C_κ` (`ChiCurve.chi_moduleKSheaf`
composed with `GenusBridge.ledgerGenus_eq_genus`, both at `C_κ` — this is checked, not assumed),

`b(κ) = deg_κ D₀(κ) + genus C_κ`,

which exposes **two** `κ`-dependencies, not one:

1. `genus C_κ` — a scalar, addressed by base-field invariance of the genus;
2. `deg_κ D₀(κ)` — the degree of the base divisor, where `D₀(κ) = n₀(κ) • F_κ`.  This is where
   the `Classical.choose` survives, and bounding it is *not* a corollary of (1).

**A retraction.**  An earlier version of this docstring said the threshold "can be taken to be
`2g − 1`", which would have collapsed (2) into (1) and made the genus identity the whole
residue.  That is standard curve theory but it is **not available here**: `deg D ≥ 2g − 1 ⟹
H¹ = 0` goes through Serre duality, and there is **no Serre duality, canonical divisor or
dualizing sheaf anywhere in this workspace** — searched across AJC, AJCR and mathlib, which
has no Serre duality for curves at all.  So the reduction below carries both hypotheses.  I
had published the one-input version on the team thread before checking it; this is the
corrected form.

## Where the two inputs stand (provenance, honestly)

**Input (1), genus invariance: proved sorry-free next door, on a different carrier.**
`AlgebraicJacobian/Cohomology/H1BaseFieldInvariance.lean` in
Algebraic-Jacobian-Challenge-Rebuild proves `finrank_h1_baseField` (the `κ`-dimension of
`H¹(C_κ, 𝒪)` equals the `k`-dimension of `H¹(C, 𝒪)`, arbitrary field extension) and deduces
`genus_baseField`.  Its engine is termwise base change of the two-term Čech complex of an
affine two-cover plus right-exactness of `⊗` — not semicontinuity, not Mumford II.5.

The caveat is the one that matters and it is not cosmetic: AJCR states it at
`baseChangeBundle C K`, built from its own `overSpec`/`⊗` `Over`-tensor spelling, whereas AJC's
`C_κ` is `Over.mk (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k κ))))`.
Whether those agree up to defeq or need a comparison isomorphism is **unsettled here**.  A
sorry-free sibling theorem whose carrier has no face onto the consumer's objects is unusable,
and this workspace has a measured instance of exactly that failure.  So `hgenus` stays a
hypothesis rather than being discharged by import.

**Input (2), a uniform base-divisor degree bound: open, and not located in either project.**
It asks for one `d` with a vanishing `D₀` of degree `≤ d` over *every* `κ`.  Nothing in AJC or
AJCR bounds `n₀(κ)` uniformly; AJCR's analogue is a `Nat.find` per field
(`RiemannRoch/WindowLedger.lean`), and its `WindowFieldTransport.lean` transports vanishing
*facts* one field at a time precisely because the constant does not move.

So `uniformVanishing_of_uniform_base_of_genus_invariant` is a **conditional** result with one
antecedent that is proved-elsewhere-modulo-a-carrier and one that is genuinely open.

## The three cluster-P statements, kept apart (unchanged discipline)

1. **Single-field bounded vanishing** — closed at AJC's curve (`FiberBound`, three curve
   binders, nothing else).  This file changes nothing about it.
2. **Extension-uniformity** — free half now *witnessed* at `C_κ` (was: asserted of morphism
   classes); open half now *decomposed* into a genus identity plus a uniform base-divisor
   degree bound, with the second one named rather than folded into the first.  Still open.
3. **Global generation** — closed at AJC's curve by the dévissage route
   (`FiberBound.exists_bound_generated_of_isFinite_toP1`), independent of (1).  This file does
   not touch it; in particular nothing here makes generation uniform over extensions either.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace

namespace AlgebraicGeometry

open Scheme

variable {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))

/-! ## §1. The missing instance

`RiemannRoch/CurveBaseChange.lean` gives `C_κ` the named instances `IsProper`,
`SmoothOfRelativeDimension 1` and `GeometricallyIntegral`.  The `Ledger` curve statements bind
`GeometricallyIrreducible`, which is the *irreducibility* half of geometric integrality and is
not recovered from it by synthesis.  Mathlib has the stability instance; this names it on the
`baseChangeField` spelling, exactly as its three siblings do. -/

/-- **Geometric irreducibility is stable under the field base change.**  The instance that was
missing from the `CurveBaseChange` stack: with it, every curve-level statement of
`Ledger/FiberBound.lean` applies to `C_κ` by synthesis, with no hypothesis on `κ/k`.

Companion of `Scheme.geometricallyIntegral_hom_baseChangeField`, which is the *integral*
form; the `Ledger` layer binds the irreducible one. -/
instance Scheme.geometricallyIrreducible_hom_baseChangeField (κ : Type u) [Field κ]
    [Algebra k κ] [GeometricallyIrreducible C.hom] :
    GeometricallyIrreducible (Scheme.baseChangeField C κ).hom :=
  MorphismProperty.pullback_snd _ _ ‹GeometricallyIrreducible C.hom›

/-! ## §2. The free half, witnessed at `C_κ`

Each theorem below is the corresponding `FiberBound` curve statement applied to
`Scheme.baseChangeField C κ`.  The proofs are one term each: that is the point — nothing has to
be redone at `C_κ`, and the reason nothing has to be redone is §1, not a stability claim about
morphism classes.

The `letI`/`haveI` prologue is the standing `ChiCurve` idiom (see `FiberBound.lean` §Curve): it
makes the ambient structure morphism of `C_κ` definitionally its bundle map, so the smoothness
binder that `divisorSheaf` needs transfers by `inferInstanceAs`. -/

section FreeHalf

variable [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]

/-- **Bounded `H¹` vanishing at `C_κ`, for every field extension `κ/k`** (the free half of
extension-uniformity, witnessed): a degree threshold exists over `κ`.

The quantifier order is the whole content, and it is the *weak* one: `κ` comes first, then `b`.
Read `UniformVanishing` below for the strong order, which this does **not** give. -/
theorem vanishing_baseChangeField (κ : Type u) [Field κ] [Algebra k κ] :
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    haveI : SmoothOfRelativeDimension 1
        ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
    ∃ b : ℤ, ∀ D : (Scheme.baseChangeField C κ).left.CurveDivisor,
      b ≤ CurveDivisor.deg κ D →
      Subsingleton (Sheaf.HModule ((Scheme.baseChangeField C κ).left.divisorSheaf κ D) 1) :=
  exists_bound_subsingleton_hModule_one_curve (Scheme.baseChangeField C κ)

/-- **Exact Riemann–Roch at `C_κ`, for every field extension `κ/k`**:
`h⁰(𝒪(D)) = 1 − genus C_κ + deg_κ D` above a threshold over `κ`.

Note the genus on the right is `genus C_κ`, taken over `κ`, **not** `genus C`.  Replacing it by
`genus C` is exactly the scalar identity §3 isolates, and it is not available here. -/
theorem riemannRoch_baseChangeField (κ : Type u) [Field κ] [Algebra k κ] :
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    haveI : SmoothOfRelativeDimension 1
        ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
    ∃ b : ℤ, ∀ D : (Scheme.baseChangeField C κ).left.CurveDivisor,
      b ≤ CurveDivisor.deg κ D →
      (Sheaf.h0 ((Scheme.baseChangeField C κ).left.divisorSheaf κ D) : ℤ)
        = 1 - genus (Scheme.baseChangeField C κ) + CurveDivisor.deg κ D :=
  exists_bound_h0_eq_genus_curve (Scheme.baseChangeField C κ)

/-! ### The χ of `C_κ` is `1 − genus C_κ`

The step that makes the decomposition of `b(κ)` in the module docstring a computation rather
than an estimate.  It is `ChiCurve.chi_moduleKSheaf` at `C_κ` with the genus name corrected by
`GenusBridge.ledgerGenus_eq_genus`; both fire at `C_κ` only because of §1. -/

/-- **`χ(𝒪_{C_κ}) = 1 − genus C_κ`.**  Isolated because it is what pins the `κ`-dependence of
the vanishing threshold to the genus *and nothing else on the `χ` side*: the residual
`κ`-dependence of `b(κ)` sits entirely in `deg_κ D₀(κ)`. -/
theorem chi_moduleKSheaf_baseChangeField (κ : Type u) [Field κ] [Algebra k κ] :
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    Sheaf.chi ((Scheme.baseChangeField C κ).left.moduleKSheaf κ)
      = 1 - (genus (Scheme.baseChangeField C κ) : ℤ) := by
  letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
    .ofHom (Scheme.baseChangeField C κ).hom
  rw [chi_moduleKSheaf (Scheme.baseChangeField C κ),
    ledgerGenus_eq_genus (Scheme.baseChangeField C κ)]

end FreeHalf

/-! ## §3. The open half: named, and reduced to two explicit inputs

`UniformVanishing` states the strong quantifier order — `b` before `κ` — as a definition, so
that a consumer can hypothesise it and so that the order is inspectable rather than buried in a
docstring.  It is **not proved**.

`uniformVanishing_of_uniform_base_of_genus_invariant` reduces it to the two inputs the module
docstring names.  The reduction itself is unconditional: no vanishing hypothesis, no finiteness
supplied by the caller, and no appeal to Serre duality (which this workspace does not have). -/

section OpenHalf

variable [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom]

/-- **Extension-uniform bounded vanishing**, the statement.  One threshold `b`, chosen before
any field, serving every finite or infinite extension `κ/k` simultaneously.

Contrast `vanishing_baseChangeField`, which is the same body with the quantifiers swapped:
there `κ` is fixed first and `b` may depend on it.  That one is a theorem; this one is open. -/
def UniformVanishing : Prop :=
  ∃ b : ℤ, ∀ (κ : Type u) [Field κ] [Algebra k κ],
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    haveI : SmoothOfRelativeDimension 1
        ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
    ∀ D : (Scheme.baseChangeField C κ).left.CurveDivisor,
      b ≤ CurveDivisor.deg κ D →
      Subsingleton (Sheaf.HModule ((Scheme.baseChangeField C κ).left.divisorSheaf κ D) 1)

/-- **A uniform base-divisor datum**: one degree bound `d` such that over *every* extension
`κ/k` some divisor of degree `≤ d` already has vanishing `H¹`.

This is input (2) of the reduction, and it is the genuinely open one.  Over a single `κ`,
`FiberBound.exists_base_subsingleton_of_isFinite_toP1` supplies such a `D₀` — namely `n₀ • F` —
but with no control of `deg_κ D₀` as `κ` varies, because `n₀(κ)` is chosen by a Noetherian
stabilization re-run at each base field. -/
def UniformBaseDivisor (d : ℤ) : Prop :=
  ∀ (κ : Type u) [Field κ] [Algebra k κ],
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    haveI : SmoothOfRelativeDimension 1
        ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
    ∃ D₀ : (Scheme.baseChangeField C κ).left.CurveDivisor,
      Subsingleton (Sheaf.HModule ((Scheme.baseChangeField C κ).left.divisorSheaf κ D₀) 1)
        ∧ CurveDivisor.deg κ D₀ ≤ d

/-- **The reduction** (★): extension-uniform vanishing follows from a uniform base-divisor
degree bound together with base-field invariance of the genus, and the uniform threshold is
then simply `d + g`.

Both hypotheses are needed and neither implies the other; see the module docstring for where
each stands.  The proof is the monotonicity observation and nothing more: the explicit bound of
`DegreeVanishing.subsingleton_hModule_one_of_deg_ge` at `C_κ` is
`deg_κ D₀ + 1 − χ(𝒪_{C_κ}) = deg_κ D₀ + genus C_κ ≤ d + g`, so a `D` of degree `≥ d + g`
clears it. -/
theorem uniformVanishing_of_uniform_base_of_genus_invariant {d : ℤ} {g : ℕ}
    (hbase : UniformBaseDivisor C d)
    (hgenus : ∀ (κ : Type u) [Field κ] [Algebra k κ],
      genus (Scheme.baseChangeField C κ) = g) :
    UniformVanishing C := by
  refine ⟨d + (g : ℤ), fun κ _ _ => ?_⟩
  letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
    .ofHom (Scheme.baseChangeField C κ).hom
  haveI : SmoothOfRelativeDimension 1
      ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
  intro D hD
  obtain ⟨D₀, hvan, hdeg⟩ := hbase κ
  have hchi : Sheaf.chi ((Scheme.baseChangeField C κ).left.moduleKSheaf κ) = 1 - (g : ℤ) := by
    rw [chi_moduleKSheaf_baseChangeField C κ, hgenus κ]
  refine subsingleton_hModule_one_of_deg_ge κ hvan D ?_
  rw [hchi]
  omega

omit [IsProper C.hom] in
/-- The uniform statement is **strictly stronger** than the per-field one, in the only sense
that can be stated without proving either: it implies the per-field conclusion at every `κ`.
Recorded so that a consumer cannot mistake `vanishing_baseChangeField` for it.

The `omit [IsProper C.hom]` is informative rather than cosmetic: the implication is pure
quantifier weakening — instantiate the single `b` at each `κ` — so it needs no properness, and
the linter caught that.  It confirms the two statements differ *only* in quantifier order, with
no geometry in between. -/
theorem vanishing_baseChangeField_of_uniformVanishing (h : UniformVanishing C)
    (κ : Type u) [Field κ] [Algebra k κ] :
    letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
      .ofHom (Scheme.baseChangeField C κ).hom
    haveI : SmoothOfRelativeDimension 1
        ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
      inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
    ∃ b : ℤ, ∀ D : (Scheme.baseChangeField C κ).left.CurveDivisor,
      b ≤ CurveDivisor.deg κ D →
      Subsingleton (Sheaf.HModule ((Scheme.baseChangeField C κ).left.divisorSheaf κ D) 1) := by
  obtain ⟨b, hb⟩ := h
  exact ⟨b, hb κ⟩

end OpenHalf

end AlgebraicGeometry
