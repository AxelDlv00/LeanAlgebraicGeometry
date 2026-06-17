# Mathlib-analogist directive — Stub 1 scheme coproduct/fibre-product distribution

## Mode: api-alignment

## Question
The Sub-brick A chain in `CechSectionIdentification.lean` is blocked at its foundation, **Stub 1**
(`cechBackbone_left_sigma`). We need the cheapest Mathlib-aligned route — and to know whether Mathlib
already provides the structural ingredient, or whether this is a genuine from-scratch build (and if so,
how to scope it).

### Precise statement to identify
In the category `Over X` (`X` a scheme), for a finite open cover `𝒰` with cover map
`q := Sigma.desc 𝒰.f : ∐ᵢ Uᵢ → X` (the `coverArrow`), the degree-`p` object of the Čech nerve of the
arrow `q` — i.e. `(coverCechNerve 𝒰).left.obj (op [p])`, the `(p+1)`-fold fibre power
`(∐ᵢ Uᵢ) ×_X (∐ᵢ Uᵢ) ×_X ⋯ ×_X (∐ᵢ Uᵢ)` — is isomorphic, in `Over X`, to the coproduct
`∐_{σ : Fin (p+1) → ι} coverInterOpen 𝒰 σ`, where `coverInterOpen 𝒰 σ := ⨅ₖ Uᵢ(σ k)` is the
(open) intersection `U_{σ 0} ∩ ⋯ ∩ U_{σ p}`, with the structure maps (cofaces/codegeneracies) matching.

Mathematically this is: **coproducts distribute over (iterated) fibre products**, i.e. the cover map's
Čech nerve splits as a coproduct indexed by tuples of cover indices, with the σ-component the
intersection of the chosen members. (`(∐Uᵢ)×_X(∐Uⱼ) = ∐_{i,j} Uᵢ×_X Uⱼ = ∐_{i,j} Uᵢ∩Uⱼ` since the Uᵢ
are open subschemes of X.)

### Idiom questions (cite real Mathlib decl names + file paths; mark each verified/expected/absent)
- **A. Coproduct × pullback distributivity for schemes.** Does Mathlib have that the canonical map
  `∐ₐ (Xₐ ×_S Y) → (∐ₐ Xₐ) ×_S Y` is an isomorphism for schemes (or in any category Scheme embeds in
  with the needed (co)limits)? Look at: extensive/lextensive category API
  (`CategoryTheory.Extensive`, `FinitaryExtensive`, `MorphismProperty`-stable-under-coproduct),
  `AlgebraicGeometry`'s disjoint-coproduct lemmas (`disjoint_opensRange_sigmaι`, `sigmaMk`,
  `AlgebraicGeometry/Limits.lean`, `AlgebraicGeometry/Pullbacks.lean`), and whether
  `Scheme` is known to be `FinitaryExtensive` in Mathlib.
- **B. Pullback of open immersions = intersection.** `Uᵢ ×_X Uⱼ ≅ Uᵢ ∩ Uⱼ` (as opens / open
  subschemes). Mathlib: `AlgebraicGeometry.Scheme.Opens`, `IsOpenImmersion` pullback lemmas,
  `Scheme.Hom.opensRange`, `pullback`-of-open-immersions. Name the exact iso.
- **C. Iterated fibre power of a coproduct.** Is the `(p+1)`-fold version reachable by iterating A+B,
  or does Mathlib have a direct `WidePullback`/`Arrow.cechNerve`-of-a-coproduct decomposition? Is
  `Arrow.cechNerve` / `Arrow.augmentedCechNerve` connected to extensivity anywhere?
- **D. Scope/cost.** If Scheme's extensivity (A) is in Mathlib, the build is "assemble the iso from
  the extensive structure + iterate" — estimate LOC. If A is ABSENT, is the cheapest route (i) prove
  the specific finite distributivity iso directly via universal properties of `∐`/`×_X` on the
  open-subscheme presentation, or (ii) build the general extensive instance? Estimate LOC and bridge
  lemma count for the cheaper option, and whether it is one-session or genuinely multi-iter.

## Failed/blocked context (read these)
- `task_results/CechSectionIdentification.md` — the iter-056 prover report. Stub 1 blocker quote:
  "Mathlib has no coproduct-distributes-over-(iterated)-fibre-product for Scheme … a genuine
  from-scratch extensive-category / pullback-stability build (≫150 LOC). NOT a one-session item."
- `analogies/subbrickA.md` — the prior analogist decomposition of Sub-brick A (Stubs 1–4 + the
  product-of-module-sheaves leaf Stub 2).
- `CechSectionIdentification.lean` — read Stub 1 (`cechBackbone_left_sigma`, ~line 76) + its planner
  strategy comment; and `coverCechNerve`/`coverInterOpen` in `CechHigherDirectImage.lean`.

## Output
Write `analogies/stub1-scheme-coproduct.md` + report. I need: verified Mathlib decl names for A/B/C, a
PROCEED/ALIGN/GAP verdict, the cheapest concrete decomposition with LOC estimate, and an explicit
one-session-vs-multi-iter judgment so I can decide whether to dispatch a prover this iter or
effort-break it into the blueprint first.
