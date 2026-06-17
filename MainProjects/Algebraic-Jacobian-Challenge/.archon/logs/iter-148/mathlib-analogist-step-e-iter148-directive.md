# Directive — mathlib-analogist @ iter-148 (step (e) recon)

## Mode

api-alignment

## Context

The iter-148 prover lane is preparing to close `constants_integral_over_base_field`
substep 3 in `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`. The
iter-147 prover reduced the goal to surjectivity and documented a
7-step (a)–(g) closure chain, identifying step (e) as the
substantive Mathlib gap.

## The substantive gap (step (e))

**Statement.** For `X` a proper geometrically irreducible reduced
smooth scheme over a field `k` and `\bar k = AlgebraicClosure k`,
flat base change gives:

```
Γ(X, ⊤) ⊗_k \bar k ≃ Γ(X_{\bar k}, ⊤)
```

where `X_{\bar k} := pullback (X ↘ Spec k) (Spec.map (algebraMap k \bar k))`.

This is one specific instance of cohomology and base change
(Stacks Tag 02KH; cohomology along proper morphisms commutes with
flat base change), specialised to `Hⁱ = H⁰ = Γ`. Hartshorne III.11
(and EGA IV) prove this for proper morphisms via the projection
formula + flat-base-change spectral sequence.

## Question 1 (api-alignment, primary)

Does Mathlib have this base-change-of-Γ-for-proper-schemes
statement, in *any* form, that could be re-exported, specialised,
or alias'd to give the project the
`Γ(X, ⊤) ⊗_k \bar k ≃ Γ(X_{\bar k}, ⊤)` isomorphism it needs?

Specifically search:

- `Mathlib.AlgebraicGeometry.IsBaseChange` and adjacent namespaces.
- `Mathlib.AlgebraicGeometry.Morphisms.*` (Proper, Flat,
  UniversallyClosed, FormallyUnramified, etc).
- `Mathlib.AlgebraicGeometry.Cohomology.*` if any.
- `Mathlib.AlgebraicGeometry.Pullback.*`.
- `Mathlib.AlgebraicGeometry.OpenImmersion`, `.Scheme`, etc.
- `Mathlib.AlgebraicGeometry.Affine` (for the affine case).
- `Mathlib.CategoryTheory.Limits.Shapes.Pullback` + the categorical
  base-change framework if Mathlib has a generic "pushforward
  commutes with flat base change" theorem at the category-theoretic
  level.

For each near-miss, report:
- The Mathlib name + import path.
- What it says (1-2 lines).
- How far it is from the proper-Γ-base-change statement
  (project's gap), in terms of:
  - Conceptual distance (same theorem? generic version? affine
    case only? different morphism class hypotheses?)
  - LOC distance to bridge (estimated).

## Question 2 (canonical idiom for the project)

If Mathlib doesn't have the proper-Γ-base-change statement
directly, what is Mathlib's *canonical* idiom for building it?
Specifically:

- Is the project expected to assemble it from
  `IsBaseChange (Spec (RingHom...))` + flatness of `algebraMap k
  \bar k` (free / Module.Free as a special case of flat) + the
  base-changed structure morphism's properness?
- Or is the canonical idiom to factor through the abstract
  cohomology-and-base-change framework (if Mathlib has one), and
  derive `Γ` as the `H⁰`-specialisation?
- Or is the canonical idiom to specialise from a higher-`Hⁱ` framework
  that Mathlib has but the project doesn't yet consume?

If the canonical idiom requires infrastructure the project doesn't
yet consume, name that infrastructure (Mathlib namespace + key
theorems) so the project can decide whether to import it or build
the gap from lower-level pieces.

## Question 3 (LOC estimate)

Given Mathlib's current state (do NOT assume Mathlib has fixed
something that's not currently there), what is the realistic LOC
estimate for landing a project-local thin wrapper that delivers
`Γ(X, ⊤) ⊗_k \bar k ≃ Γ(X_{\bar k}, ⊤)` for the project's
hypotheses (proper, geometrically irreducible, reduced, smooth
`X / Spec k`)?

The project's own estimate is ambiguous: the lemma's name
"constants_integral_over_base_field" + initial budget
~50–100 LOC point at a thin wrapper. The current Lean signature
(`RingHom.range (appTop.hom) = ⊤`, i.e. surjectivity / `Γ ≃ k`)
+ the 7-step closure chain + the Stacks 02KH/0BUG citation point
at the deeper proper-flat-base-change-of-Γ machinery
(~250–500 LOC budget).

Give your honest estimate with reasoning. The project planner uses
your number to commit to either (a) building the machinery in-tree,
or (b) routing around via the over-`\bar k` alternative for M2.a.

## Question 4 (downstream M3 utility)

The project's M3 Route A (Picard scheme via FGA, off-critical-path,
iter-170+) also needs cohomology base change for proper morphisms.
Is the flat-base-change-of-Γ wrapper this iter-148 prover lane
would build a *prerequisite* of the M3 Route A infrastructure
(cross-utility), or would M3 need a separate higher-`Hⁱ` base-change
framework anyway (in which case the iter-148 effort would be
duplicated)?

This bears on the strategic decision between (a) build it now / (b)
route around.

## What you read

- Mathlib via `lean_local_search`, `lean_leansearch`, `lean_loogle`,
  `lean_leanfinder` (whatever fits each question).
- `references/challenge.lean` only if you need the project's
  end-state target signature.
- The project's Lean target signature:
  `AlgebraicJacobian/Cotangent/ChartAlgebra.lean:220–294`.

## What you DO NOT read

`STRATEGY.md`, `PROGRESS.md`, iter sidecars, task_pending /
task_done, blueprint chapters beyond the chart-algebra section.

## Output

Standard api-alignment mode output per descriptor. Write to
`task_results/mathlib-analogist-step-e-iter148.md`. If the gap is
genuinely thin and Mathlib already has a 1–2-line idiom that
suffices, your verdict is **PROCEED** with the named lemmas. If the
project's path is parallel to Mathlib's idiom but mis-aligned, your
verdict is **ALIGN WITH MATHLIB** with the named refactor target.
If Mathlib doesn't have the infrastructure and the gap is genuinely
~250–500 LOC, your verdict is **BUILD IT** with the LOC estimate
and the canonical idiom to follow.

Persist your findings to `analogies/<slug>.md` per the descriptor's
"persistent file" rule.

## Write-domain

`task_results/**`, `analogies/**`.
