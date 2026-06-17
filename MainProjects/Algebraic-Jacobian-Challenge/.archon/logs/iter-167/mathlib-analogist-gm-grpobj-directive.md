# Directive: mathlib-analogist — slug `gm-grpobj`

## Mode: api-alignment

## Mission

Find the right Mathlib idiom for installing the multiplicative `GrpObj` structure on
`Spec (Localization.Away t)` (Archon's `Gm`) over `Spec k̄`. This is the iter-166 Lane 2
PARTIAL — the prover landed the encoding but reported the `GrpObj.ofRepresentableBy`
representable-by witness as "non-trivial, out of scope this iter". iter-167 will close it;
we want your Mathlib-idiom guidance BEFORE the prover lane attempts the build.

## Context (the project's current shape)

In `AlgebraicJacobian/Genus0BaseObjects.lean`:

```lean
abbrev GmRing (kbar : Type u) [Field kbar] : Type u :=
  Localization.Away (MvPolynomial.X () : MvPolynomial Unit kbar)

def GmScheme (kbar : Type u) [Field kbar] : Scheme :=
  Spec (CommRingCat.of (GmRing kbar))

instance gmScheme_canOver (kbar : Type u) [Field kbar] :
    (GmScheme kbar).Over (Spec (.of kbar)) where
  hom := Spec.map (CommRingCat.ofHom (algebraMap kbar (GmRing kbar)))

abbrev Gm (kbar : Type u) [Field kbar] : Over (Spec (.of kbar)) :=
  (GmScheme kbar).asOver (Spec (.of kbar))

-- iter-167 target:
instance gm_grpObj (kbar : Type u) [Field kbar] : GrpObj (Gm kbar) := sorry
```

The iter-165 analogist `gm-scaling-p1` D2.b verdict committed to the AFFINE encoding
`Spec (Localization.Away t)` (not the basic-open of `𝔸¹`, which loses `IsAffine`).

The iter-166 task report (Lane 2) characterised the `gm_grpObj` blocker as:

> The plan's "install `GrpObj.ofRepresentableBy` with units functor `T ↦ GrpCat.of Γ(T.left,
> ⊤)ˣ`" requires building a `(F.comp (forget GrpCat)).RepresentableBy (Gm kbar)` witness that
> exploits `IsLocalization.Away (X : MvPolynomial Unit kbar)`-Spec bijection "morphism into
> `Spec (Localization.Away t)` ↔ unit in global sections". Mathlib has the algebraic
> machinery (`IsLocalization.away_of_isUnit_of_bijective`, `AffineSpace.homOverEquiv`) but
> does not ship the units-functor → `Spec(k̄[t,t⁻¹])` representable-by witness; this
> sub-build is non-trivial.

## Specific questions

### Q1 — Is `GrpObj.ofRepresentableBy` actually the right idiom?

Mathlib's `Mathlib.AlgebraicGeometry.Group.Smooth` recently landed
`smooth_of_grpObj_of_isAlgClosed`, which is the lemma the project already consumes (via the
analogist `gm-scaling-p1` report's "FREE from smoothness" path). What does Mathlib do
for `𝔾ₘ` itself, if anything? Search:

- `Mathlib.AlgebraicGeometry.Spec` (the `Spec` functor)
- `Mathlib.AlgebraicGeometry.Group.*` (the new `GrpObj`-on-schemes infrastructure)
- `Mathlib.AlgebraicGeometry.AffineScheme` (affine schemes, equivalence with CommRingCatᵒᵖ)
- `Mathlib.GroupTheory.GroupAction.*` (group object infrastructure)
- `Mathlib.CategoryTheory.Yoneda` (representable functors, the `RepresentableBy` API)
- `Mathlib.RingTheory.Localization.Away.*`
- Any place Mathlib defines `𝔾ₘ` or its multiplicative group structure on schemes

Specifically: does Mathlib already define a `GrpObj (Spec (Localization.Away t))` or
similar (maybe under a different name like `Units.spec`, `multiplicativeGroup`, `Gm`,
`GroupSchemes.gm`, etc.)? If yes, the project should USE that, not parallel-API it.

### Q2 — The representable-by witness idiom

If Q1 says the project DOES need to build the `RepresentableBy` witness, what's Mathlib's
cleanest idiom? Specifically:

(a) The functor `F : (Over (Spec k̄))ᵒᵖ ⥤ GrpCat` is `T ↦ GrpCat.of Γ(T.left, ⊤)ˣ`. Does
    Mathlib have a precedent for this functor anywhere (maybe under
    `AlgebraicGeometry.Scheme.OverClass`, `AlgebraicGeometry.Γ`, or in
    `Mathlib.AlgebraicGeometry.AffineScheme`)?

(b) The representable-by witness is the natural iso
    `F.comp (forget GrpCat) ≅ yoneda.obj (Gm kbar)`. The "morphism into `Spec
    (Localization.Away t)` ↔ unit in global sections" half is `IsLocalization.Away.*`:
    `IsLocalization.algEquiv` / `IsLocalization.Away.lift_of_isUnit` /
    `IsLocalization.away_of_isUnit_of_bijective` / `Localization.awayIsoSelf` / etc. Which
    Mathlib helper(s) constitute the cleanest path to this bijection?

(c) Is there a precedent for Mathlib code building a `GrpObj.ofRepresentableBy` witness via
    a similar functor + bijection pattern? e.g., the additive `Ga` (`AffineSpace 𝔸(1; ·)`),
    or some Lie-group-style affine group scheme? `AffineSpace.homOverEquiv` is mentioned in
    the project's `ga_grpObj` docstring; what is it, and does it give the cleanest analog
    for `gm`?

### Q3 — The chartwise `gmScalingP1` body

ALSO touch this in your search even though it's the smaller question: the `gmScalingP1`
body in Genus0BaseObjects.lean L437 is `:= sorry`. The plan is to glue via
`AlgebraicGeometry.Scheme.Cover.glueMorphisms` over the 2-chart cover
`{D₊(X₀) × Gm, D₊(X₁) × Gm}` of `ℙ¹ × Gm`. The two chart morphisms:

- On `𝔸¹ × Gm`: `Spec.map` of `t ↦ λ·t` on `k̄[t, λ, λ⁻¹]`.
- Near `∞` (chart `u = X₁`): `Spec.map` of `u ↦ u/λ`.

Find Mathlib precedents for:
- The 2-chart cover of `Proj k̄[X₀, X₁]` (`ProjectiveLineBar`). Is there a named `Cover`
  structure for `Proj`'s standard affines, or do we manually build a `Scheme.Cover` from
  the two `Proj.basicOpen X_i`-style affine opens?
- `Scheme.Cover.glueMorphisms` usage examples — what does the agreement hypothesis look
  like, and what's the cleanest way to discharge it for a polynomial-ring-level chart map?
- `AlgebraicGeometry.Pullback`-style ring constructions: is `D₊(X_i) × Gm` the `Spec` of
  a tensor product (`k̄[t]⊗_{k̄} k̄[λ,λ⁻¹]` = `k̄[t,λ,λ⁻¹]`), and what's the cleanest way
  to bridge `Spec.map (RingHom)` to a `Scheme` morphism out of a product?

A pointer is enough; we don't need a recipe.

### Q4 — Product-stability instances for `(ℙ¹ ⊗ Gm)`

The AVR helper `morphism_P1_to_grpScheme_const_aux` (L931) carries 5 internal sorries —
4 are product-stability instances:

```lean
[GeometricallyIrreducible ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom]       -- L944
[LocallyOfFiniteType ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom]            -- L949
[IsReduced ((ProjectiveLineBar kbar) ⊗ Gm kbar).left]                     -- L953
[IsReduced (ProjectiveLineBar kbar).left]                                 -- L1029
```

For each, what's the Mathlib idiom?

- (a) `GeometricallyIrreducible` of `X ⊗ Y` from `GeometricallyIrreducible X` and
  `GeometricallyIrreducible Y` over an alg-closed base — does Mathlib's
  `Mathlib.AlgebraicGeometry.GeometricallyIrreducible.*` (or similar) ship a product-stability
  lemma?
- (b) `LocallyOfFiniteType (X ⊗ Y).hom` from `LocallyOfFiniteType X.hom` and `Y.hom` — is
  there a `MorphismProperty.IsStableUnderBaseChange` / `IsStableUnderProductsOfShape` for
  LOFT?
- (c) `IsReduced (X ⊗ Y).left` from `IsReduced X.left`, `IsReduced Y.left`, perfect base —
  does Mathlib ship a `Scheme.IsReduced.product_of_perfect` or similar?
- (d) `IsReduced (ProjectiveLineBar).left` — `ℙ¹` over k̄ is integral, hence reduced. Does
  Mathlib's `Mathlib.AlgebraicGeometry.Proj.*` ship an integrality/reducedness lemma for
  `Proj` of a polynomial ring? If not, what's the cleanest path (transport through one of
  the affine charts? `IsIntegral` typeclass?).

## Out of scope

- The full RR bridge `genusZero_curve_iso_P1` (L1131) — that's a separate deep build for
  iter-168+.
- The OPT-IN items `projectiveLineBar_geomIrred` (L177), `projectiveLineBar_smoothOfRelDim`
  (L184), `ga_grpObj` (L335) — same shape, but lower priority; if your `gm_grpObj`
  recommendation also unlocks `ga_grpObj` mention it as a bonus, otherwise skip.

## Expected output

Per-question verdict (PROCEED / ALIGN-WITH-MATHLIB / GAP-EXISTS), with concrete Mathlib
citations (file:line where possible), a one-paragraph implementation hint per question.
Write the persistent rationale to `analogies/gm-grpobj-and-friends.md`.
