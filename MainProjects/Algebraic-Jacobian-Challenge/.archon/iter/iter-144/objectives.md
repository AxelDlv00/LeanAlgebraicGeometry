# Iter-144 objectives

## Prover objectives

**None.** Iter-144 is a plan-only iter per the convergent verdicts:

1. **HARD GATE FIRES** on `RigidityKbar.tex` + `Jacobian.tex` +
   `AlgebraicJacobian_Cotangent_GrpObj.tex` per
   `blueprint-reviewer-iter144`. `Cotangent/GrpObj.lean` is dropped
   from `## Current Objectives`. Defer prover one iter for Wave 2
   blueprint-writers to land.

2. **CHART-ALGEBRA PIVOT COMMITTED iter-144** per
   `mathlib-analogist-chart-algebra-iter144`. The iter-145+ prover
   lane targets chart-algebra route piece (ii) PIN-path-(b) (~600–1050
   LOC envelope), NOT bundled piece (i.b) Step 2 d_app. Piece (i.b)
   Step 2 + (i.c) + (iii) are DESCOPED iter-145+.

## Plan-phase activity

7 subagent dispatches total this iter (Wave 1 returned + Wave 2
in-flight at plan-phase close):

### Wave 1 (4 dispatches, all returned + absorbed)

- `blueprint-reviewer-iter144` — HARD GATE FIRES; 5 must-fix items.
- `progress-critic-iter144` — CHURNING Route 1 (corrective superseded
  by chart-algebra pivot); UNCLEAR Route 2; CONVERGING-SCAFFOLD
  Route 3.
- `strategy-critic-iter144` — CHALLENGE (4 routes; 5 must-fix items
  absorbed via STRATEGY.md edits).
- `mathlib-analogist-chart-algebra-iter144` — PIVOT TO CHART-ALGEBRA
  (5 decisions; persistent file
  `analogies/chart-algebra-vs-bundled-iter144.md`).

### Wave 2 (3 blueprint-writer dispatches, in-flight)

- `blueprint-writer-rigiditykbar-iter144` — 5 edits to `RigidityKbar.tex`.
- `blueprint-writer-jacobian-iter144` — 4 edits to `Jacobian.tex`.
- `blueprint-writer-pointer-iter144` — 5 edits to pointer chapter.

## STRATEGY.md edits (5 substantive)

1. Iter-144 user-hint M3 disposition (binding).
2. Route A header + Route B header reframing.
3. Route-pick decision RESOLVED iter-144.
4. Iter-144 chart-algebra pivot COMMITTED (major restructure).
5. M2.a `df = 0` derivation chain articulated (Soundness rule
   addition).

## Iter-145 watch criteria

See `iter/iter-144/plan.md § "Iter-145 watch criteria"` + PROGRESS.md
§ "Watch criteria committed for iter-145" for the full enumerated list
(10 items). Key items:

- Iter-145 mandatory blueprint-reviewer re-confirms three chapters.
- Iter-145 mandatory strategy-critic re-verifies chart-algebra pivot.
- Iter-145 mandatory `mathlib-analogist-m3-route-a-refresh-iter145`
  refresh audit.
- Iter-146+ piece (ii) PIN-path-(b) prover lane begins under
  chart-algebra envelope.
- Iter-150 over-k vs over-`k̄` sunk-cost guardrail (fresh-context
  strategy-critic re-baseline).
