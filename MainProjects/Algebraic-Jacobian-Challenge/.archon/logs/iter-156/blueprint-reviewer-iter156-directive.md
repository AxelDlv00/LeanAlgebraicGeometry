# Blueprint Reviewer Directive

## Slug
iter156

## Context for this audit

Whole-blueprint audit (read every chapter under `blueprint/src/chapters/`). Two
specific things this iter beyond the standard per-chapter checklist:

1. **Confirm the iter-155 `rigidity-regate` re-scope of `RigidityKbar.tex`.** The
   prior verdict (iter-155) had `RigidityKbar.tex` `complete: partial / correct:
   partial` because it asserted a false "chart-algebra avoids Serre duality" route.
   A blueprint-writer rewrote it to disclose the `df=0` gating honestly (named gap +
   two candidate routes). Verify it is now `complete + correct` AS A DISCLOSED GATED
   GAP (it is acceptable for `rigidity_over_kbar` to be an honestly-disclosed open
   gap; the question is whether the chapter's MATH and framing are now correct, not
   whether the proof is closed).

2. **Assess Route A blueprint readiness.** The project has just committed (iter-156)
   to "route (b)": the genus-0 rigidity will be re-proved through Route A's
   Pic⁰/Albanese engine (`Alb(genus-0)=0`) rather than the differential `df=0`
   route, because Route A is mandatory anyway for the positive-genus object. This
   makes Route A (the FGA Picard-scheme engine, decomposition A.1–A.4 in
   `Jacobian.tex`) the CRITICAL PATH for the whole project. I need your read on
   whether the Route A blueprint coverage (A.1 relative Picard functor; A.2
   representability; A.3 identity component; A.4 Abel–Jacobi UP) is at
   prover-ready detail or is still a sketch. If it is a sketch, say so plainly and
   flag which sub-step is the smallest prover-ready entry point (the strategy names
   the `RelativeSpec` functor, ~700–1100 LOC). Also assess whether `Jacobian.tex`'s
   genus-0 framing still says genus-0 routes through the differential
   `rigidity_over_kbar` (it should be re-pointed to the Pic⁰/Albanese argument under
   route (b)) — flag any chapter prose that contradicts the route-(b) decision.

No prover lane fires this iter (mechanical gate — no prover-ready critical-path
target post-pivot). Your verdict drives next iter's blueprint-writer dispatch and
the eventual Route A scaffolding gate.

## Files to read
All chapters under `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/`.

## Output
Per the blueprint-reviewer report format: per-chapter complete/correct checklist,
must-fix findings, broken-cross-reference sweep, and the route-coverage assessment
for Route A specifically.
