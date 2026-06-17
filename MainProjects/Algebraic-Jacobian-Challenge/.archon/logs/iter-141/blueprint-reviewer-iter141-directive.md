# Blueprint reviewer directive — iter-141

## Project context (minimal)

The project formalizes the existence of a Jacobian variety for a smooth proper
geometrically irreducible curve over a base field `k`, per the 9 protected
declarations of `references/challenge.lean`. The autonomous loop is in the
**prover** stage. The blueprint lives at `blueprint/src/chapters/*.tex`, one
chapter per Lean file (the `Foo/Bar.lean → Foo_Bar.tex` slug mapping).

## Your task

Read the WHOLE blueprint (all `blueprint/src/chapters/*.tex`). For each
chapter, render a `complete: true | partial | false` and
`correct: true | partial | false` verdict, list any must-fix-this-iter
items, and flag broken `\uses{}` references or `\lean{...}` mismatches.

Apply the HARD GATE rule on a per-file basis: identify any chapter that
would prevent its corresponding Lean file from being a valid prover target
this iter.

## Files the planner is considering for prover dispatch this iter

The planner is weighing **whether to dispatch a prover on
`AlgebraicJacobian/Cotangent/GrpObj.lean` again** for the third consecutive
iteration on piece (i.b) Step 2 (sub-sorries `d_app` L624, `d_map` L643,
`IsIso` L689). Per iter-140 acceptance criteria, the iter-140 lane returned
PARTIAL (0 of 3 sub-sorries closed by strict count; new private helper
`isIso_of_app_iso_module` shipped + IsIso narrowed from "whole iso" to
"per-open iso" structural refactor). This is a CHURNING-trigger per the
iter-140 pre-committed rule.

In light of CHURNING, the planner needs to know:

1. Does the blueprint chapter `RigidityKbar.tex` (corresponds to both
   `RigidityKbar.lean` and `Cotangent/GrpObj.lean` — the latter via the
   pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex`) still
   `complete: true` and `correct: true` after the iter-140 lane?
2. Are the d_app / d_map / IsIso closure recipes in `RigidityKbar.tex`
   detailed enough to support another prover attempt? Or is the prover
   re-discovering ambiguity at each iter?
3. The iter-140 prover identified an explicit factoring-lemma recipe for
   `d_app` (validated standalone via `lean_run_code`): see
   `task_results/Cotangent_GrpObj.lean.md` §"d_app: detailed gap" L68–L108.
   Does this expanded mathematical content need to be **lifted into the
   blueprint** before the next prover attempt? (e.g., adding the
   "factoring h : Source ⟶ ((pullback fst.left.base).obj G.left.presheaf).obj (snd⁻¹X)"
   step.)
4. The iter-140 prover also documented a `whnf`-opacity-on-`pushforward.obj.map`
   blocker for d_map (the `change`-based approach times out). Is the d_map
   recipe in the blueprint aware of this `whnf` opacity, or does it need
   to be reformulated?
5. Are the four "stale marker" observations from
   `task_results/lean-vs-blueprint-checker-cotangent-grpobj-review140.md`
   §"Stale blueprint markers (sync_leanok territory — informational only)"
   resolvable this iter, or are they intentional drift?

Also confirm there are no chapters where stale `\notready` markers on
formalized statement blocks should be cleared (review-agent territory,
not yours to fix, but observe and report).

## Output

Per chapter, render:

```
### <ChapterName>.tex
- complete: true|partial|false
- correct: true|partial|false
- must-fix-this-iter: [list]
- soon: [list]
- notes: [list]
```

Plus a HARD GATE verdict: does `AlgebraicJacobian/Cotangent/GrpObj.lean`
remain a valid prover target this iter, or should the planner DEFER the
prover lane this iter and dispatch a blueprint-writer instead?

## What you may NOT read

Do not read `PROGRESS.md`, `STRATEGY.md`, `iter/iter-NNN/plan.md` (any iter),
`task_pending.md`, `task_done.md`, or `proof-journal/`. Your value is the
fresh whole-blueprint view. The files listed at the top of this directive
(the blueprint chapter `.tex` files and the relevant `task_results/`) plus
any Lean files you need to spot-check signatures against are your only
inputs.
