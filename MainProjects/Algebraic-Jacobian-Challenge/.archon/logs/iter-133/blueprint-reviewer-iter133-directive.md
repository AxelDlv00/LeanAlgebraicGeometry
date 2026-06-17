# Blueprint Reviewer Directive

## Slug
iter133

## Iter
133

## Scope

Read the WHOLE blueprint at `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/`. Do not scope-limit — the per-chapter completeness/correctness checklist plus cross-chapter `\uses{}` integrity is the deliverable.

## Iter-132 status going in

- **`RigidityKbar.tex`** was edited iter-132 by two blueprint-writers in parallel:
  - `blueprint-writer-rigiditykbar-piecei-realign-iter132` (substantive — re-aligned § Piece (i) rank-lemma proof to Steps 1+2 live closure path under Replacement (B); demoted bridge to Step 3 deferred alternative; added new mini-section "Iter-131 `Classical.choose`-chain body shape" with the `cotangentSpaceAtIdentity_eq_extendScalars` companion-lemma rewrite handle).
  - `blueprint-writer-rigiditykbar-uses-cleanup-iter132` (narrow — 3 `\uses{}` cleanups + line-88 sentence "deferred to iter-130+" → "iter-132+ prover-lane target" + `rem:piece_i_first_target` rewrite).
  Iter-132 blueprint-reviewer's must-fix list included 3 narrow items + 1 chapter `correct: partial` (`RigidityKbar.tex`) + 1 chapter `correct: partial` (`Jacobian.tex` soft drift C.2.a–C.2.e, informational not blocker). The 3 narrow items + the substantive realign landed iter-132. The `Jacobian.tex` soft drift is **deferred to iter-133+** (iter-132 plan agent's explicit deferral).

- **`Cotangent/GrpObj.lean`** had `cotangentSpaceAtIdentity_finrank_eq` added at line 244 by the iter-132 prover lane (verified: 0 sorries, kernel-only axioms). The blueprint chapter for piece (i.a) lives inside `RigidityKbar.tex` § `subsec:RigidityKbar_piece_i_decomposition`; there is **intentionally** no `AlgebraicJacobian_Cotangent_GrpObj.tex` chapter (per `lean-vs-blueprint-checker-cotangent-grpobj-review132` line 14: this naming asymmetry is by design — piece (i.a) lives inside `RigidityKbar.tex` alongside (i.b)/(i.c)).

- **`Jacobian.tex`** was flagged iter-132 reviewer with `correct: partial` on soft drift in C.2.a–C.2.e (still over-`k̄` historical scaffolding after the iter-127 over-k commitment). Re-check this iter and confirm whether the drift should:
  - (a) Still defer iter-133+ as informational (no prover route consumes the sub-step prose);
  - (b) Be dispatched to a blueprint-writer THIS iter (iter-133 plan agent's bandwidth allows it; the chapter is internally consistent because C.2.f explicitly DROPs the descent step, but the sub-step prose is misleading on quick read).

- **`cotangentSpaceAtIdentity_eq_extendScalars`** (companion structural-shape lemma at line 198 of `Cotangent/GrpObj.lean`) is referenced by name three times in `RigidityKbar.tex` (lines 121, 206, 307) but lacks its own `\lean{...}` block. The iter-132 `lean-vs-blueprint-checker` flagged this as MED-B (minor; non-blocking). Iter-133 plan agent is considering bundling this with the docstring-refresh refactor lane.

## Specific questions (HARD GATE for iter-133)

The iter-133 plan agent is considering dispatching:

- A **prover lane on piece (i.b)** (`AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent`) — but ONLY after a mathlib-analogist consult returns this iter. Per the HARD GATE protocol: is `blueprint/src/chapters/RigidityKbar.tex` § `lem:GrpObj_mulRight_globalises` (lines 243–268) `complete: true` AND `correct: true`? Specifically:
  - Does the lemma statement adequately specify the shear iso `σ = ⟨pr₁, μ⟩` as a `GrpObj`-categorical map?
  - Does the proof sketch (lines 261–267) adequately describe the inverse `τ` construction and the verification chain via `GrpObj` axioms?
  - Is the iter-127 over-k risk register (line 258) still accurate (functorial shear, not pointwise)?
  - Are the `\uses{...}` blocks correct given the iter-132 piece (i.a) close?

- A **refactor lane on `Cotangent/GrpObj.lean`** (docstring-only edits for 5 stale-framing sites + optional bundling of the MED-B `\lean{...}` block + MED-C blueprint vs Lean proof-skeleton drift). This is a non-prover task; HARD GATE check is on the blueprint side for the bundle: should `RigidityKbar.tex` get a new `\lean{cotangentSpaceAtIdentity_eq_extendScalars}` block (MED-B), and should the recommended downstream rewrite pattern at line 307 be updated to describe the direct `change`-based route (MED-C)?

- **No prover lane on piece (i.a)** — the META-PATTERN TRIPWIRE non-promise commitment from iter-132 binds; no 4th body reshape under any branch.

## Format expected

Per `.archon/subagents/blueprint-reviewer.md`: per-chapter `complete: ` + `correct: ` checklist with notes; cross-chapter `\uses{}` integrity flag; must-fix-this-iter list; HARD GATE green-light or DEFER per file the planner is considering. Write to `task_results/blueprint-reviewer-iter133.md`.
