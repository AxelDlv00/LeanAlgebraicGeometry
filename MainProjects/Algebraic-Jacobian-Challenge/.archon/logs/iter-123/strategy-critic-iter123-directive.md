# Directive: strategy-critic-iter123 (re-verification mode)

## Mode

**Re-verification.** STRATEGY.md has not changed structurally since the
iter-121 user-pivot rewrite. Iter-122 made light revisions (M1 reframed
"OFF the critical path" with honest opportunity-cost statement; M2 total
cost revised upward; M2.d split into RR-path + cotangent-vanishing
alternative; M3 cost honest at 100+ iter / 10000+ LOC per route; M3
route-pick audit scheduled iter-123; named-axiom alternative rebutted).

The iter-122 strategy-critic returned CHALLENGE on M1, M2, M3 + 2
alternatives; all challenges were addressed in the iter-122 STRATEGY.md
revision. Please re-verify the strategy is still sound this iter, with
particular attention to whether the iter-122 revisions adequately
addressed the prior challenges.

## Inputs

### STRATEGY.md (verbatim)

[See `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`]

### Project goal (one paragraph)

The project formalizes the nine protected declarations of Christian Merten's
Jacobian challenge (`references/challenge.lean`):
`AlgebraicGeometry.genus`, `AlgebraicGeometry.Jacobian` (+ 4 instances),
and `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`,
`Jacobian.exists_unique_ofCurve_comp`. All nine signatures are frozen
by the mathematician. The single remaining inline `sorry` in the project
is at `Jacobian.lean:179` `nonempty_jacobianWitness`, which the
strategy decomposes via a genus case-split: `genusZeroWitness` (M2)
and `positiveGenusWitness` (M3). M1 is the Mathlib-contribution-track
bridge between presheaf and algebra-Kähler forms of relative cotangent
modules; it is off the critical path but actively executed per the
iter-121 user pivot directive.

### References index

The project has a single reference: `references/challenge.lean` — the
original challenge file with the formal signatures of all 9 protected
declarations.

### Blueprint chapter summary (one-line each)

- `Differentials.tex` — relative Kähler differentials presheaf
  construction; smoothness ⇒ locally free Ω; the bridge M1 between
  the presheaf and algebra-Kähler forms.
- `Jacobian.tex` — definition of `Jacobian`, the witness existence
  hypothesis `nonempty_jacobianWitness`, instance derivations.
- `AbelJacobi.tex` — Abel-Jacobi map and its universal property.
- `Genus.tex` — genus definition via cotangent module finrank.
- `Rigidity.tex` — Mumford rigidity for pointed proper smooth
  morphisms.
- `Cohomology_*.tex` — Sheaf cohomology machinery (Čech / Mayer-
  Vietoris, sheaf composition, structure sheaves).
- `Picard_*.tex` — Picard functor and line bundle infrastructure
  (closed dead-end from earlier iters; M3 Route A would revisit).
- `Modules_Monoidal.tex` — monoidal structure on PresheafOfModules.

## What I want from you

1. Verify whether the iter-122 STRATEGY.md revisions adequately address
   the prior strategy-critic CHALLENGEs on M1/M2/M3.
2. Check whether the genus-stratified body decomposition of
   `nonempty_jacobianWitness` is mathematically correct (no phantom
   $k$-rational-point hypotheses, no Brauer-Severi blind spots).
3. Check whether M2.d's RR-path-vs-cotangent-vanishing-alternative
   choice is well-framed (in particular, whether Serre duality for
   curves over `k̄` can be invoked without going through full
   Riemann-Roch).
4. Check whether the M3 100+ iter / 10000+ LOC estimate is plausible
   per-route given Mathlib's current state. (Note: a separate
   mathlib-analogist dispatch this iter is auditing M3 routes; you
   should opine independently from your fresh-strategy perspective.)
5. Flag any sunk-cost reasoning visible in the strategy (e.g. M1
   being executed because "we've already started", which is the kind
   of reasoning your fresh perspective is meant to challenge).
6. Flag any alternative decomposition of `nonempty_jacobianWitness`
   you would consider stronger than the genus-stratified one.

Return CHALLENGE/PROCEED/ALIGN_WITH_PROJECT on each strategic question
above, with explicit rationale.
