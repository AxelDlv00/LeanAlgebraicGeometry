## Mode: api-alignment

## Context (minimal)
The project must prove, over an algebraically closed field `k` of ARBITRARY characteristic:
"every morphism `f : ℙ¹ → A` from the projective line to an abelian variety (a proper
group scheme) `A` is constant" (equivalently, factors through `Spec k`). A `rigidity_lemma`
(Mumford Form I: `X` proper, `X × Y` geom. irreducible, both axes collapse ⟹ map is constant)
is ALREADY PROVEN in the project, axiom-clean. We are choosing between two completion routes
and need to know which has better Mathlib infrastructure support (or less missing).

## Question
For EACH of the two routes below, report what Mathlib ALREADY provides and what is a genuine
GAP (must be built from scratch). Be concrete: name the actual Mathlib declarations/namespaces
that exist (with module paths), and flag missing pieces as `[gap]`. Do not assess mathematical
correctness — only Mathlib API availability.

### Route R (rigidity / Milne §I.3 — rational-map extension)
Pieces needed:
1. Valuative criterion of properness for a morphism of schemes (to extend a rational map
   `S ⇢ A` defined on a dense open of a NORMAL/smooth variety into a PROPER target `A`),
   i.e. something like `AlgebraicGeometry.ValuativeCriterion` / a lemma that a rational map
   from a normal variety to a proper scheme extends over codimension-1 points.
2. Weil-divisor / codimension-1 / "pure codimension 1 locus" theory on a smooth SURFACE
   (e.g. `ℙ¹ × ℙ¹`): is there any Mathlib API for prime divisors, `div(f)`, indeterminacy
   locus of a rational map being pure codim 1?
3. `𝔾_a` (additive group `𝔸¹`) and `𝔾_m` (`𝔸¹∖0`) as group schemes/varieties, and the fact
   that a homomorphism `𝔾_a → A` to an abelian variety is trivial.

### Route H (differential / hybrid — cotangent + Frobenius)
Pieces needed:
1. The sheaf of (Kähler) differentials `Ω` of a scheme / morphism, as a quasi-coherent sheaf;
   pullback of differentials along a morphism; `Ω` of a product/group scheme being trivial
   (`Ω_A ≅ O_A^g`). Name the Mathlib modules (`AlgebraicGeometry/...Differentials`, `Cotangent`).
2. Cohomology `H⁰(ℙ¹, O(n))` of line bundles on `ℙ¹` (Serre's computation), in particular
   `H⁰(ℙ¹, Ω_{ℙ¹}) = H⁰(ℙ¹, O(-2)) = 0`. Does Mathlib have ProjectiveSpace / Proj line-bundle
   cohomology at all?
3. RELATIVE FROBENIUS morphism of a scheme over a field of characteristic `p`, and the
   factorization theorem "a morphism with zero differential factors through the relative
   Frobenius". Name any `Frobenius`/`FrobeniusModule`/`pthRoot` scheme-level API.

## Search radius
Search Mathlib broadly (`AlgebraicGeometry`, `RingTheory`, `Geometry`). For each piece return:
EXISTS (with decl name + module) | PARTIAL (what's there, what's missing) | [gap] (absent).

## Output
A per-piece table for Route R and Route H, then a one-paragraph bottom-line: which route is
LESS blocked by missing Mathlib infrastructure. Persist rationale to `analogies/<slug>.md`.
