# Mathlib analogist directive — iter-200 slug wd-stacks02iz

## Mode: api-alignment

## The decl / situation we want aligned

The iter-200 Lane WD-A4a-Sub-build-1 prover is asked to build, axiom-clean, the **open-immersion stalk-bridge for prime divisors**: given an integral locally Noetherian scheme `X`, an open `U ⊆ X` with open immersion `i : U ↪ X`, and a prime divisor `Y ⊆ X` (i.e. a point of coheight 1 in the closed-points order on the underlying space), if `Y ∩ U ≠ ∅` then there exists a prime divisor `Y_U ⊆ U` with `i_*(Y_U) = Y` (as the corresponding height-1 prime / generic point).

The corresponding Stacks-Project tags are **02IZ** (open-immersion stalks) and **005X** (topological coheight ↔ algebraic height for Noetherian schemes / Hartshorne II.6.1).

The directive's iter-200 recipe takes ~150-250 LOC as a project-side build, but the iter-199 prover lane discovered that the Mathlib substrate is partially absent. **The progress-critic `route200` returned this lane CHURNING and recommended a Mathlib analogy consult before any further helper round.**

## What we need from you

1. **Locate existing Mathlib infrastructure** for:
   - `Order.coheight` on the underlying space of a scheme (does this exist as a generalised notion? `AlgebraicGeometry.Scheme` has a topological space; does Mathlib define `coheight` on a `TopologicalSpace`?).
   - Open-immersion stalk restriction: `AlgebraicGeometry.IsOpenImmersion.stalkMap_isIso` (does this exist?) — for an open immersion `i : U ↪ X` and a point `x ∈ U`, the canonical map `X.presheaf.stalk (i x) ⟶ U.presheaf.stalk x` is an iso.
   - Prime-divisor pushforward `i_*` on the cycle level (as in `Scheme.PrimeDivisor`): does Mathlib have a cycle-pushforward operation for open immersions? Or does this need a project-side construction?

2. **Identify the cleanest Mathlib idiom** for the "open subset is dense in its closure" / "generic point lifts uniquely under open immersion" lemmas — these are the core of the prime-divisor pushforward.

3. **Stacks 02IZ ↔ Mathlib bridge**: does Mathlib have a single lemma packaging the open-immersion stalk iso? If yes, name it (with file path). If no, propose the bridge as a project-side helper of ~10-20 LOC.

4. **Stacks 005X ↔ Mathlib bridge**: does Mathlib have `Order.coheight ↔ Ring.KrullDim` for locally Noetherian schemes? This is the algebraic-vs-topological equivalence that the lane consumes internally.

5. **Bottom line**: is the iter-200 lane's ~150-250 LOC budget realistic given current Mathlib? If yes, propose a 3-step recipe with named Mathlib helpers. If no (i.e., the actual project-side budget is significantly larger), say so and propose a re-scoping.

## Search radius

`narrow` — the project sits in algebraic geometry; the relevant Mathlib sub-area is `Mathlib.AlgebraicGeometry.Scheme` + `Mathlib.AlgebraicGeometry.OpenImmersion` + `Mathlib.RingTheory.Spectrum.Prime.Basic`.

## What to produce

A ranked list of Mathlib infrastructure pieces relevant to Lane WD-A4a-Sub-build-1, with named declarations and file paths. Plus:

- A verdict: PROCEED (the Mathlib substrate is sufficient for the ~150-250 LOC budget) or ALIGN-WITH-MATHLIB (rename / restructure the substrate to match Mathlib idioms before dispatching) or RE-SCOPE (the lane budget is significantly under-estimated).
- A concrete iter-200 prover recipe with named Mathlib helpers + per-step LOC estimates.

## Out-of-scope

- Do NOT propose proofs for the prover; api-alignment mode produces alignment recommendations, not directive replacements.
- Do NOT touch `STRATEGY.md`, `PROGRESS.md`, blueprint chapters, or any `.lean` file.

## Write domain

- `analogies/**` (persistent rationale: `analogies/wd-stacks02iz.md`)
- `task_results/**`

## Report

`task_results/mathlib-analogist-wd-stacks02iz.md` + persistent `analogies/wd-stacks02iz.md`.
