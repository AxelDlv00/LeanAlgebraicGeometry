/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0Et
import AlgebraicJacobian.Picard.GroupSchemeHomogeneity
import AlgebraicJacobian.Curve.GeometricallyReduced

/-!
# Leaf B in the étale formulation: relative dimension `genus C` for `Pic⁰_{C/k}`

The Jacobian headline (`AlgebraicJacobian/Jacobian.lean`) rests on five named open
obligations. This file is about the fourth,
`smoothOfRelativeDimension_genus_pic0Et`, and it establishes two things about it that
the headline's own list gets wrong.

## 1. The five obligations are not independent: obligation 4 implies obligation 2

`Jacobian.lean` lists `Scheme.Pic0Et.geometricallyReduced` (obligation 2) and
`smoothOfRelativeDimension_genus_pic0Et` (obligation 4) as peers, and
`Picard/Pic0Et.lean` describes the former as the sole remaining input to smoothness,
"and nothing else". Both readings are right about the *direction they were written
for* — smoothness is assembled out of reducedness — and both miss that the arrow also
runs the other way, through mathlib's own class hierarchy:

`SmoothOfRelativeDimension n f` gives `Smooth f`
(`SmoothOfRelativeDimension.smooth`), and this project's
`Smooth.geometricallyReduced` (`Curve/GeometricallyReduced.lean`) gives the class. The
composite is `SmoothOfRelativeDimension.geometricallyReduced`, already in the tree.

`geometricallyReduced_of_leafB` and `smooth_of_leafB` below are that observation at
`Pic0SchemeEt`. The consequence is arithmetic, not mathematical: **closing leaf B
closes two of the five**, so a reader who adds the two distances double-counts.

What this does *not* claim, and the distinction is the whole point of stating it:
obligation 2 is not thereby made *cheaper*. Leaf B is the harder statement, and the
reducedness half is still best attacked at its own level, by the `k̄` reduction
recorded on `AJC.pic0av.structure`. What is refuted is only the independence.

## 2. What leaf B's *own* residue is, read off mathlib's definition

`Jacobian.lean` prices the leaf as owing "a translation between two invariants of
smoothness — the tangent-space dimension and the rank of `Ω`". That is the right
shape, and this file pins the second half of it to a named mathlib `iff`:

* `SmoothOfRelativeDimension n` is `HasRingHomProperty … (Locally
  (IsStandardSmoothOfRelativeDimension n))`, so by `HasRingHomProperty.iff_appLE` the
  class *is* an affine-chart-pair condition — `leafB_iff_appLE` below. It is not a
  statement about a tangent space at a point, which is what the landed
  `Picard/Pic0EtTangentSpace.lean` chain computes.
* the base `Spec k` is affine, so `HasRingHomProperty.iff_of_iSup_eq_top` reduces the
  chart pairs to a single family of affine opens *covering `Pic⁰`* —
  `leafB_iff_affineCover` below.
* on each such chart, `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`
  turns the numeral into `Module.rank S Ω[S⁄k] = n`, given `IsStandardSmooth` and
  `Nontrivial`.

**What these two statements are, stated plainly, because an earlier revision of this
section overclaimed them (`I-1094`, fresh-context audit).** Both are `iff`s obtained from
mathlib by instantiation, i.e. **the class definition unfolded**, and `leafB_of_chartwise`
below is literally `leafB_iff_appLE.mpr`. They do not reduce leaf B to anything; they say
what leaf B already is, in chart language. The one thing they do buy is *locus*: the
number the leaf needs is measured on chart algebras, not at the identity, and
`finrank_cotangentSpace_eq_genus` (`Picard/Pic0EtTangentSpace.lean`) computes the latter.
That much survives the audit and is the useful content of §2.

**And the `∀`-over-chart-pairs form is HARDER than the class, not easier.** The class field
is *pointwise-existential* — `∀ x : X, ∃ U V affine …` — so it asks for **one** chart pair
per point, while `leafB_iff_appLE`'s right-hand side asks for the condition at **every**
chart pair. The `iff` is mathlib's and is sound, but a prover who attacks the right-hand
side is proving more than `SmoothOfRelativeDimension` needs. `leafB_of_pointwise` below is
the form to attack, and it is the anonymous constructor.

## 3. Two facts about translations, and a retracted claim about homogeneity

Translations of a group scheme over `S` are automorphisms **over** `S`
(`CategoryTheory.GrpObj.pointTranslationIso_hom_comp`, which is `Over.w`), so the
composite of a translation with the structure morphism is the structure morphism *on the
nose*, and the two `SmoothOfRelativeDimension` propositions are literally **equal**.
`GrpObj.smoothOfRelativeDimension_pointTranslation_eq` records that.

**RETRACTED, 2026-07-29 r2, by a fresh-context audit of this file (`I-1096`).** An
earlier revision of this section concluded from that equality that homogeneity
"contributes **nothing** to the numeral". That does not follow, and the audit gave the
counter-argument: the class field is *pointwise-existential* (`∀ x : X, ∃ U V, …`), so
turning one chart at the identity into a statement at every point is exactly the work
homogeneity does, and `SmoothOfRelativeDimension n` really is `IsLocalAtSource` for
`Scheme.zariskiPrecoverage` (`inferInstance` succeeds). The equality here says the
*structure morphism* is unchanged by translating; it says nothing against translating a
*chart*, which is a different composite (`incl ≫ translation`, left-composition — see
`GrpObj.chart_comp_pointTranslation_eq`). Homogeneity is a live route to this leaf, not
a dead end, and the sibling project's `AbelianVariety/RelativeDimensionLocal.lean` had
it right.

That same revision called the sibling's `smoothOfRelativeDimension_pointTranslationIso`
"circular". **That was wrong and unfair**: its consumer
`smoothOfRelativeDimension_of_translation_cover` takes
`∀ i, SmoothOfRelativeDimension n (𝒰.f i ≫ d.J.hom)` — a chart inclusion composed on the
left — which is not the composite its own hypothesis is about. The accurate description
is that their lemma is trivial by `rw` under its instance binder, which their docstring
already says.

Both declarations below are generic in the property (the audit checked: the same one-line
`rw` proves the equality for an arbitrary `MorphismProperty`), and
`chart_comp_pointTranslation_eq` duplicates the `@[reassoc]`-generated
`pointTranslationIso_hom_comp_assoc`. They are kept only because §3's prose refers to
them; neither carries content.

## What is open

Everything in this file is an implication or an equivalence; **no obligation is
discharged**. In particular `smoothOfRelativeDimension_genus_pic0Et` (Jacobian.lean)
and `Scheme.Pic0Et.geometricallyReduced` (Pic0Et.lean) are still `sorry` at HEAD, and
every declaration here binds `[HasPicSchemeEt C]`, whose global instance
`instHasPicSchemeEt` projects the central `sorry`
`Scheme.fgaPicardRepresentability`. So these statements are `sorry`-free *as
implications* and `sorryAx`-reachable at the use site — the distinction recorded in
`Picard/Pic0EtTangentSpace.lean` and, since 2026-07-29, at the seam itself.

References: Kleiman, "The Picard scheme" (arXiv:math/0504020), §5 Cor. `cor:sm`,
Thm. `thm:tgtsp`. Board row `AJC.pic0av.reldim`.
-/

set_option autoImplicit false

universe u

open CategoryTheory MorphismProperty MonoidalCategory

namespace AlgebraicGeometry

/-! ## §1. Obligation 4 implies obligation 2 -/

namespace Scheme.Pic0Et

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIntegral C.hom] [HasPicSchemeEt C]

/-- **Leaf B gives bare smoothness of `Pic⁰_{C/k}`** — one mathlib projection.

`Pic0Et.smooth` is currently assembled *from* `geometricallyReduced`; this is the other
direction, and it is what makes the five-obligation list non-independent. -/
theorem smooth_of_leafB
    (hB : SmoothOfRelativeDimension (genus C) (Pic0SchemeEt C).hom) :
    Smooth (Pic0SchemeEt C).hom :=
  haveI := hB
  SmoothOfRelativeDimension.smooth (n := genus C) (Pic0SchemeEt C).hom

/-- **Leaf B implies headline obligation 2**, `Pic0Et.geometricallyReduced`.

Via `smooth_of_leafB` and this project's `Smooth.geometricallyReduced`
(`Curve/GeometricallyReduced.lean`) — packaged upstream as
`SmoothOfRelativeDimension.geometricallyReduced`.

The import matters and is the reason this lives in a new file rather than in
`Pic0Et.lean`: that module's cone does not contain `Curve/GeometricallyReduced`, so the
bridge is invisible from inside it and a synthesis probe there reads as absence
(the measure-at-the-root lesson recorded at `Pic0AbelianVariety.lean:1208-1211`).

Consequently `Pic0Et.geometricallyReduced` is a *sub-problem* of leaf B, not a peer of
it, and the two distances must not be added. It does **not** follow that obligation 2
is cheaper than it was: it is the weaker statement, so proving it directly remains the
right attack, and this implication is useless in that direction. -/
theorem geometricallyReduced_of_leafB
    (hB : SmoothOfRelativeDimension (genus C) (Pic0SchemeEt C).hom) :
    GeometricallyReduced (Pic0SchemeEt C).hom :=
  haveI := hB
  SmoothOfRelativeDimension.geometricallyReduced (genus C) _

/-! ## §2. What leaf B actually asks: an affine-chart-pair condition

Both statements here are mathlib's, instantiated. They are recorded because the
headline docstring describes leaf B's residue in terms of "the rank of `Ω`" without
saying where that rank is measured, and the answer — on affine charts of `Pic⁰`, not at
the identity — is what separates it from the landed tangent-space chain. -/

/-- **Leaf B *is* the affine-chart-pair condition.** `SmoothOfRelativeDimension n` is
`HasRingHomProperty _ (RingHom.Locally (RingHom.IsStandardSmoothOfRelativeDimension n))`,
so `HasRingHomProperty.iff_appLE` unfolds the class into a condition on the ring maps
`Γ(U) ⟶ Γ(V)` for affine `U ⊆ Spec k`, `V ⊆ Pic⁰` with `V ⊆ f⁻¹U`.

This is an `iff` in both directions, so nothing is weakened. Its use is to fix what
"the rank of `Ω`" in the headline's pricing of this leaf refers to: the relative
dimension is asserted of chart-level algebra maps, and
`Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth` is what converts
each into `Module.rank S Ω[S⁄R] = n` once standard smoothness is in hand. The tangent
space at the identity does not occur. -/
theorem leafB_iff_appLE :
    SmoothOfRelativeDimension (genus C) (Pic0SchemeEt C).hom ↔
      ∀ (U : (Spec (CommRingCat.of k)).affineOpens)
        (V : ((Pic0SchemeEt C).left : Scheme.{u}).affineOpens)
        (e : (V : Scheme.Opens _) ≤ (Pic0SchemeEt C).hom ⁻¹ᵁ (U : Scheme.Opens _)),
        RingHom.Locally (RingHom.IsStandardSmoothOfRelativeDimension (genus C))
          ((Pic0SchemeEt C).hom.appLE (U : Scheme.Opens _) (V : Scheme.Opens _) e).hom :=
  HasRingHomProperty.iff_appLE

/-- **Leaf B on an affine cover of `Pic⁰` alone.** The base `Spec k` is affine, so
`HasRingHomProperty.iff_of_iSup_eq_top` collapses the pair quantifier of
`leafB_iff_appLE` to a single family: it is enough to test the charts of any affine open
cover of `Pic⁰_{C/k}`, each against the whole base.

This is the form the remaining work has: exhibit an affine cover of `Pic⁰` and the
`Ω`-rank count on each member. It is an `iff`, so it is neither a weakening nor a
strengthening of leaf B. -/
theorem leafB_iff_affineCover {ι : Type*}
    (V : ι → ((Pic0SchemeEt C).left : Scheme.{u}).affineOpens)
    (hV : ⨆ i, ((V i : ((Pic0SchemeEt C).left : Scheme.{u}).affineOpens) :
      Scheme.Opens ((Pic0SchemeEt C).left : Scheme.{u})) = ⊤) :
    SmoothOfRelativeDimension (genus C) (Pic0SchemeEt C).hom ↔
      ∀ i, RingHom.Locally (RingHom.IsStandardSmoothOfRelativeDimension (genus C))
        ((Pic0SchemeEt C).hom.appLE ⊤ (V i).1 le_top).hom :=
  HasRingHomProperty.iff_of_iSup_eq_top V hV

/-! ### §2b. Two forms of the chart condition, and a retracted claim about "absorption"

**RETRACTED (`I-1094`).** An earlier revision of this subsection claimed that leaf B "is
ONE obligation, not `Pic0Et.smooth` plus a rank", on the ground that the graded chart
condition implies the ungraded one so smoothness is *absorbed*. The implication is a real
mathlib lemma (`RingHom.IsStandardSmoothOfRelativeDimension.isStandardSmooth`) — but it is
invoked by **no declaration in this file**, and the reason `leafB_of_chartwise` carries no
smoothness hypothesis is simply that it is `leafB_iff_appLE.mpr`, whose right-hand side
*is* the class. Absorption was asserted, not proved, and the claim is withdrawn. Whether
supplying the numeral genuinely pays for smoothness is not settled here.

What is left standing, and it is smaller: the two forms below, and the observation that
the pointwise one is what the class actually asks for. -/

/-- **Leaf B from the condition at every chart pair** — `leafB_iff_appLE.mpr`, and nothing
more than that. Retained because the `iff`'s reverse direction is the one a consumer
reaches for, but see `leafB_of_pointwise` for the form that matches the class definition;
this hypothesis is strictly stronger. -/
theorem leafB_of_chartwise
    (hchart : ∀ (U : (Spec (CommRingCat.of k)).affineOpens)
      (V : ((Pic0SchemeEt C).left : Scheme.{u}).affineOpens)
      (e : (V : Scheme.Opens _) ≤ (Pic0SchemeEt C).hom ⁻¹ᵁ (U : Scheme.Opens _)),
      RingHom.Locally (RingHom.IsStandardSmoothOfRelativeDimension (genus C))
        ((Pic0SchemeEt C).hom.appLE (U : Scheme.Opens _) (V : Scheme.Opens _) e).hom) :
    SmoothOfRelativeDimension (genus C) (Pic0SchemeEt C).hom :=
  (leafB_iff_appLE C).mpr hchart

/-- **The form leaf B actually asks for: ONE affine chart pair per point of `Pic⁰`.**

`SmoothOfRelativeDimension n f`'s single field is pointwise-existential — for each `x : X`
there must *exist* affine `U ⊆ Y`, `V ⊆ X` with `x ∈ V`, `V ⊆ f⁻¹U` and
`IsStandardSmoothOfRelativeDimension n` on `f.appLE U V`. So this, not
`leafB_of_chartwise`, is the shape a prover should target: the chart may be chosen per
point, and `RingHom.IsStandardSmoothOfRelativeDimension` (not the `Locally` wrapper) is
what each one owes.

Identified by a fresh-context audit (`I-1094`) after an earlier revision of this file
pointed the next prover at the `∀`-over-all-chart-pairs form, which is strictly harder
than the class. That this is the anonymous constructor is the point: it shows the target
is one chart per point and no more. -/
theorem leafB_of_pointwise
    (h : ∀ x : ((Pic0SchemeEt C).left : Scheme.{u}),
      ∃ U, ∃ _ : IsAffineOpen U, ∃ V, ∃ (_ : IsAffineOpen V) (_ : x ∈ V)
        (e : V ≤ (Pic0SchemeEt C).hom ⁻¹ᵁ U),
        RingHom.IsStandardSmoothOfRelativeDimension (genus C)
          ((Pic0SchemeEt C).hom.appLE U V e).hom) :
    SmoothOfRelativeDimension (genus C) (Pic0SchemeEt C).hom :=
  ⟨h⟩

/-- **What bare smoothness supplies on a chart.** `Smooth` carries the ring-hom property
`RingHom.Smooth`, and `RingHom.Smooth.locally_isStandardSmooth` converts it, so smoothness
of `Pic⁰` yields standard smoothness on every chart pair *with no numeral*.

**One correction to how this was recorded (`I-1095`).** An earlier revision called
"`Smooth` does not carry `Locally IsStandardSmooth`" a *measured negative*. What is true is
narrower: `inferInstance` for that `HasRingHomProperty` fails, i.e. it is not the
registered instance. The *proposition* is a mathlib theorem
(`RingHom.smooth_iff_locally_isStandardSmooth`, an `iff`), so nothing is unavailable — and
consequently this lemma is one direction of an equivalence rather than a one-way loss of
information: `Smooth` is recoverable from precisely its conclusion. A synthesis result was
written up as a mathematical one.

Comparing with `leafB_of_chartwise`: what separates smoothness from leaf B is exactly
the passage from `Locally IsStandardSmooth` to
`Locally (IsStandardSmoothOfRelativeDimension (genus C))` on each chart, i.e. pinning
the number. Given `IsStandardSmooth` and `Nontrivial`,
`Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth` makes that
pinning literally `Module.rank S Ω[S⁄R] = genus C` — on the away-localisations of chart
algebras that `RingHom.Locally` quantifies over, which is where the residue lives and
is *not* where `Pic0Et.finrank_cotangentSpace_eq_genus` computes. -/
theorem locally_isStandardSmooth_appLE_of_smooth
    (hsm : Smooth (Pic0SchemeEt C).hom)
    (U : (Spec (CommRingCat.of k)).affineOpens)
    (V : ((Pic0SchemeEt C).left : Scheme.{u}).affineOpens)
    (e : (V : Scheme.Opens _) ≤ (Pic0SchemeEt C).hom ⁻¹ᵁ (U : Scheme.Opens _)) :
    RingHom.Locally RingHom.IsStandardSmooth
      ((Pic0SchemeEt C).hom.appLE (U : Scheme.Opens _) (V : Scheme.Opens _) e).hom :=
  RingHom.Smooth.locally_isStandardSmooth
    ((HasRingHomProperty.iff_appLE (P := @Smooth) (Q := RingHom.Smooth)).mp hsm U V e)

end Scheme.Pic0Et

/-! ## §3. Homogeneity gives the cover for free and the numeral not at all

The measured negative that keeps a lane from spending a round on translation
transport. -/

/-- **A translation composed with the structure morphism is the structure morphism.**

For a group object `G` over `S`, `CategoryTheory.GrpObj.pointTranslationIso G x y` is an
automorphism of `G.left` *over* `S`, so `Over.w` gives
`(pointTranslationIso G x y).hom ≫ G.hom = G.hom`.

Stated here in the form that matters for a relative-dimension argument: the two
propositions

  `SmoothOfRelativeDimension n ((pointTranslationIso G x y).hom ≫ G.hom)`
  `SmoothOfRelativeDimension n G.hom`

are **equal**, not merely interderivable. So "transport the class along a translation"
asserts nothing new, for any morphism property whatsoever.

WHY THIS IS WORTH A NAME. The sibling project
(`Algebraic-Jacobian-Challenge-Rebuild`, `AbelianVariety/RelativeDimensionLocal.lean`)
provides the transport as `smoothOfRelativeDimension_pointTranslationIso`, whose
hypothesis is `[SmoothOfRelativeDimension n d.J.hom]` — the very conclusion the
covering criterion it feeds is trying to reach. As a `RespectsIso` convenience that is
correct and useful; read as a step towards the relative-dimension leaf it is circular,
because by this equality its hypothesis and conclusion are the same proposition. The
homogeneity of a group scheme therefore contributes to the *covering* step (any
translate of a chart is a chart) and contributes nothing to the *numeral*. -/
theorem GrpObj.smoothOfRelativeDimension_pointTranslation_eq {S : Scheme.{u}}
    (G : Over S) [CategoryTheory.GrpObj G] (n : ℕ) (x y : 𝟙_ (Over S) ⟶ G) :
    SmoothOfRelativeDimension n
        ((CategoryTheory.GrpObj.pointTranslationIso G x y).hom ≫ G.hom)
      = SmoothOfRelativeDimension n G.hom := by
  rw [CategoryTheory.GrpObj.pointTranslationIso_hom_comp]

/-- The same statement one level down, for a chart inclusion: translating a chart does
not change the composite it induces to the base. This is the covering half of §3 — the
legs of a translated cover have literally the same structure map composites as the
original — and it is why homogeneity is free there and empty at the numeral. -/
theorem GrpObj.chart_comp_pointTranslation_eq {S : Scheme.{u}}
    (G : Over S) [CategoryTheory.GrpObj G] {U : Scheme.{u}} (incl : U ⟶ G.left)
    (x y : 𝟙_ (Over S) ⟶ G) :
    (incl ≫ (CategoryTheory.GrpObj.pointTranslationIso G x y).hom) ≫ G.hom
      = incl ≫ G.hom := by
  rw [Category.assoc, CategoryTheory.GrpObj.pointTranslationIso_hom_comp]

end AlgebraicGeometry
