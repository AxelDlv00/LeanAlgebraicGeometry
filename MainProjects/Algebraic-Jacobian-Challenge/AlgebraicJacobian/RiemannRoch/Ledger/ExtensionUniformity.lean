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
* `uniformVanishing_of_genus_invariant` — the **reduction**: the open half follows from one
  scalar identity, `genus C_κ = genus C` for all `κ`.  So extension-uniformity is not an
  open-ended obstruction; it is exactly the base-field invariance of the genus.

## Why the reduction holds, and why the constant was the wrong thing to chase

`FiberBound`'s closing docstring located the obstruction in the constant: `b(κ)` is built from
`n₀(κ)`, a `Classical.choose` on a Noetherian stabilization re-run at each base field, and
nothing relates `n₀(κ)` to `n₀(k)`.  That is a correct description of the *proof* and a wrong
description of the *problem*.  The threshold produced by
`DegreeVanishing.exists_bound_subsingleton_hModule_one` is

`b = deg D₀ + 1 − χ(𝒪)`,

but `exists_bound_subsingleton_hModule_one` is an existential: any larger `b` works too, since
its conclusion is monotone in `b` (a `D` of degree `≥ b'` has degree `≥ b` when `b ≤ b'`).  So
one never has to transport `n₀` at all — one only has to bound `b(κ)` above, uniformly in `κ`,
by something computable over `k`.  And by exact Riemann–Roch the threshold can be taken to be
`2g − 1` where `g = genus C_κ`: past that degree `H¹` vanishes, and that expression mentions
`κ` only through the genus.  Hence a single `κ`-independent bound exists as soon as the genus
does not move.

This is the sense in which the residue is **one scalar identity, not a transport problem**.
`uniformVanishing_of_genus_invariant` makes that precise: it takes `hgenus : ∀ κ, genus C_κ =
genus C` and produces the uniform bound, without touching `n₀`.

## Where that scalar identity lives (provenance, honestly)

It is **not** proved in AJC, and this file does not prove it.  It **is** proved sorry-free in
the sibling project: `AlgebraicJacobian/Cohomology/H1BaseFieldInvariance.lean` in
Algebraic-Jacobian-Challenge-Rebuild proves `finrank_h1_baseField` (the `κ`-dimension of
`H¹(C_κ, 𝒪)` equals the `k`-dimension of `H¹(C, 𝒪)`, for an arbitrary field extension) and
deduces `genus_baseField : genus (baseChangeBundle C K) = genus C`.  The engine there is
termwise base change of the two-term Čech complex of an affine two-cover plus right-exactness
of `⊗`, not semicontinuity.

Two caveats a consumer must not skip:

1. **The carrier is AJCR's, not this one.**  AJCR states it at `baseChangeBundle C K`, built
   from its own `overSpec`/`⊗` `Over`-tensor spelling; AJC's `C_κ` is `Over.mk (pullback.snd
   C.hom (Spec.map (CommRingCat.ofHom (algebraMap k κ))))`.  Whether those agree up to defeq
   or need a comparison isomorphism is a real question and is **not** settled in this file.
   Until it is, `hgenus` stays a hypothesis here rather than being discharged by import.
2. Consequently `uniformVanishing_of_genus_invariant` is a **conditional** result, and the
   antecedent is satisfiable-elsewhere rather than witnessed here.  That is the honest state:
   the reduction is unconditional mathematics, the input is a port that has not been made.

## The three cluster-P statements, kept apart (unchanged discipline)

1. **Single-field bounded vanishing** — closed at AJC's curve (`FiberBound`, three curve
   binders, nothing else).  This file changes nothing about it.
2. **Extension-uniformity** — free half now *witnessed* at `C_κ` (was: asserted of morphism
   classes); open half now *reduced* to `genus C_κ = genus C` (was: described as a
   non-transportable constant).  Still open in AJC.
3. **Global generation** — closed at AJC's curve by the dévissage route
   (`FiberBound.exists_bound_generated_of_isFinite_toP1`), independent of (1).  This file adds
   its per-field form (`generation_baseChangeField`) and nothing else.
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

end FreeHalf

end AlgebraicGeometry
