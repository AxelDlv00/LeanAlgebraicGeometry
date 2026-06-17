# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
gm-scaling-p1

## Design question

The project is about to scaffold three new infrastructure declarations in
`AlgebraicJacobian/AbelianVarietyRigidity.lean` that together encode the
"𝔾_m-scaling shortcut" base case `ℙ¹ → A` constant (Route C). We need to know,
BEFORE we write the Lean, what the Mathlib-aligned shape of each is — including
which existing Mathlib API to extend rather than re-build.

The three target declarations (currently only `[expected]` Lean names in the
blueprint, no Lean bodies yet) are:

1. **`ProjectiveLineBar`** — `ℙ¹` over `Spec k̄` as an object of
   `Scheme.Over (Spec k̄)` (or a `GrpObj`-style bundled object — that is also one
   of the open decisions). It must:
   - be a smooth proper geometrically irreducible curve of genus `0` (instances
     should land where they will be picked up by `[IsProper _.hom]`,
     `[Smooth _.hom]`, `[GeometricallyIrreducible _.hom]`);
   - have at least the distinguished `k̄`-points `0`, `1`, `∞` (Mathlib idiom?
     `Proj`-coordinate `[X : Y]`? a function `pointOfClosedPoint`-style `(Spec k̄) ⟶ ProjectiveLineBar`?);
   - have the two standard affine charts `𝔸¹ = ℙ¹ ∖ {∞}` and `ℙ¹ ∖ {0}`.

2. **`Gm`** — the multiplicative group `𝔾_m = 𝔸¹ ∖ {0}` over `Spec k̄`, as
   `GrpObj (Over (Spec k̄))` (group law `(x,y) ↦ x·y`, identity `1`).
   Additionally `Ga` (the additive `𝔸¹`, group law `(x,y) ↦ x+y`, identity `0`)
   as a `GrpObj` for the demoted alternative route.

3. **`gmScalingP1`** — the total scheme morphism
   `σ_× : ℙ¹ × 𝔾_m ⟶ ℙ¹`, `(x, λ) ↦ λ·x`, defined over `Spec k̄` (i.e. as a
   morphism in `Over (Spec k̄)`). Must have the property
   `σ_×(0, λ) = 0` (the scaling fixed point at `0` that makes the
   `_hf`-collapse of `hom_additive_decomp_of_rigidity` fire).

**Open decisions (one question per — the analogist should report a verdict on each):**

(D1) **`ℙ¹` realization.** Is the Mathlib idiom (a) `Proj` of a graded polynomial
ring, (b) `ProjectiveSpace` (the projectivization construction in
`Mathlib.AlgebraicGeometry.ProjectiveSpectrum.*` or
`Mathlib.LinearAlgebra.Projectivization.*`?), (c) a direct definition via the
universal property + chart cover, or (d) something else? Which gives the cheapest
`[IsProper]`, `[Smooth]`, `[GeometricallyIrreducible]` instances, AND a
workable handle on the `0` / `1` / `∞` `k̄`-points and the two affine charts the
proof needs?

(D2) **Group-object realization of `𝔾_m` and `𝔾_a`.** The blueprint suggests
`AffineSpace 𝔸(1; Spec k̄)` (Mathlib's `AffineSpace`) plus `GrpObj`.
Does Mathlib already package `𝔾_m`/`𝔾_a` as group schemes (e.g.
`AlgebraicGeometry.GroupScheme.Gm` / `Ga`, `Mathlib.AlgebraicGeometry.*`
file we missed)? If yes, what's the canonical name, and does it ship its
`GrpObj` instance? If no, what is the most idiomatic from-scratch construction
(e.g. `Spec` of `MvPolynomial`, register a `GrpObj` instance by `Pi.lift` of
the obvious multiplication map)?

(D3) **The scaling action `σ_×`.** Is there a Mathlib-precedent shape for a
scheme-level group action / left-multiplication morphism with a fixed point at
the origin? Concretely: is the right idiom (a) a bare morphism
`ℙ¹ × 𝔾_m ⟶ ℙ¹` in `Over (Spec k̄)`, (b) an `IsAction` / `MulAction`-style
typeclass packaged on top, (c) glued from the two affine-chart restrictions via
some `Scheme.glueMorphisms` / `Scheme.Hom.fromOpenCover`-style API, or (d) some
other Mathlib pattern? The chartwise definition is:
- on `𝔸¹ × 𝔾_m`: `(x, λ) ↦ λ·x` (polynomial — regular everywhere);
- near `∞` (chart `u = 1/x`): the target coordinate `1/(λ·x) = u/λ` is regular
  because `λ ∈ 𝔾_m` is invertible.
What's the Mathlib-aligned way to write that — is there a
`Scheme.Hom.glueOnTwoCharts` / `IsLocallyDescribed`-style helper, or do we
write `Scheme.Hom.mk` plus a `glueData`/cover argument by hand?

(D4) **Where do these live?** Option A: drop the definitions inline in
`AbelianVarietyRigidity.lean` (the file is already 992 lines but they're tightly
coupled to the `morphism_P1_to_grpScheme_const` proof). Option B: split into a
new `AlgebraicJacobian/Genus0BaseObjects.lean` (or similar) that AVR imports.
Which does Mathlib's own organization suggest — does it tend to put genuinely
new schemes in their own file (`Mathlib.AlgebraicGeometry.<X>.lean`), or as
neighbors of their first consumer?

## Project artifact(s) under question

- `AlgebraicJacobian/AbelianVarietyRigidity.lean:909-989` — the three scaffold
  declarations (`morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`,
  `rigidity_genus0_curve_to_grpScheme`) whose bodies depend on the
  to-be-scaffolded `ProjectiveLineBar`/`Gm`/`gmScalingP1`. Currently these
  scaffolds use an *abstract* `P1` proxy `(P1 : Over (Spec kbar)) [IsProper P1.hom] …`.
- `blueprint/src/chapters/AbelianVarietyRigidity.tex:908-989` — the
  blueprint chapter's `def:genus0_base_objects` + `def:gaTranslationP1` already
  describe the math; we need the Mathlib-aligned shape for the Lean.

## Why now

We are about to dispatch a prover lane this iter to *scaffold* (file-skeleton
shape: definitions + signatures + `sorry` bodies) `ProjectiveLineBar`, `Gm`,
`Ga`, `gmScalingP1`. We do NOT want the prover to land a parallel API that we
then have to refactor — the project has already eaten a multi-iter cost on the
`Scheme.HModule` parallel-API pattern (iter-009→046), and the relevant
infrastructure here is much cheaper to align proactively than to retrofit.

The progress-critic in iter-164 explicitly warned that iter-165 "MUST convert to
depth — infra scaffold/proof, not a 2nd cosmetic round". This consult is the
gate before depth: align the scaffold to Mathlib, then ship.

## Hints (optional)

Mathlib namespaces the dispatcher suspects are relevant:
- `Mathlib.AlgebraicGeometry.Scheme`,
  `Mathlib.AlgebraicGeometry.AffineScheme`,
  `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Scheme`,
  `Mathlib.AlgebraicGeometry.Pullbacks` (for `pr₁`/`pr₂`-style products);
- `Mathlib.AlgebraicGeometry.AffineSpace` (`AffineSpace 𝔸(n; S)`);
- `Mathlib.AlgebraicGeometry.GroupScheme.*` if it exists;
- `Mathlib.CategoryTheory.GrpObj` (used by Cor 1.5 / Cor 1.2 on the target side);
- `Mathlib.AlgebraicGeometry.Morphisms.IsAffine`,
  `Mathlib.AlgebraicGeometry.Morphisms.Smooth`,
  `Mathlib.AlgebraicGeometry.Morphisms.UniversallyClosed` (instance shape on
  whatever `ProjectiveLineBar.hom` ends up being).

The project's `[IsProper _.hom]`/`[Smooth _.hom]`/`[GeometricallyIrreducible _.hom]`
instance pattern (on `Scheme.Over (Spec k̄)`) is already in use by `Cor 1.5`
(`hom_additive_decomp_of_rigidity` at AVR.lean L813) — whatever the
`ProjectiveLineBar` realization is, it must produce these as instances cheaply.

The project's `Cotangent/GrpObj.lean` shows the `GrpObj` API on
`Scheme.Over _`, which the analogist may want to skim for the shape we already
use.

## Severity expectation

high-stakes

This is a load-bearing scaffold: at least 3 downstream Lean proofs (the
scaffold-sorry bodies at AVR L936/960/989) and the `genusZeroWitness.key`
consumer in `Jacobian.lean` (currently `sorry` at L265) will use these objects.
If the shape is wrong, we eat a refactor across multiple files and possibly a
multi-iter delay. Be strict about idiom alignment.
