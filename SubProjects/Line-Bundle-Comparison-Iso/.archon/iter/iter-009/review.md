# Iter 009 — Review

## Overall progress
- **Zero math progress — infrastructure failure, 2nd consecutive iter.** Both prover lanes
  (model `fable`) died at session start: `num_turns 1`, `$0`, ~972/1089ms, empty `text`
  (`provers-combined.jsonl`). `attempts_raw.jsonl`: 0 events / 0 edits / 0 builds. No new
  `task_results/`. `git diff HEAD~1 --stat -- '*.lean'` empty. Model-capacity / API failure, not a
  regression.
- Sorry counts UNCHANGED from iter-007/008: SliceTransport 3 (L444 ROOT, L724, L726),
  TensorObjSubstrate 2 (L712, L3144), DualInverse 0. State carried intact and GREEN. sync_leanok
  iter-9 = 0/0; blueprint-doctor clean.

## What this means
- The iter-009 directives (DUAL ROOT mirror; D3′ bricks) were **never executed** → carry forward
  verbatim, neither validated nor invalidated. iter-007's CONVERGING ×2 verdicts remain live.
- **`fable` has now capacity-failed TWICE running (iter-008 + iter-009).** This is no longer a
  transient self-healing event — it is a recurring block. The iter-009 plan pre-authorized the
  trigger ("if `fable` fails a SECOND consecutive iter, escalate a model-switch to TO_USER");
  condition met. `config.json` is user-only → loop cannot self-heal. Escalated in TO_USER.md as a
  live block. Project capacity-event history: iter-005, iter-008, iter-009.

## Subagent skips
- lean-auditor: no `.lean` file modified this iter (0 prover edits; `git diff HEAD~1 -- '*.lean'`
  empty) AND iter-007 auditor was PASS / 0 must-fix. Re-auditing identical bytes is hollow.
- lean-vs-blueprint-checker: no `.lean` file received prover work this iter (0 prover edits) — no
  Lean delta to verify.

## Markers
- None changed (no prover work, no renames, no new Mathlib-backed decls). blueprint-doctor clean;
  sync_leanok iter-9 = 0/0.

## Carry-forward
- **User must switch the prover model off `fable` before the next prover round** — otherwise the
  next iter is another guaranteed 0-event no-op.
- Once switched: re-dispatch BOTH lanes verbatim. DUAL ROOT L444 first (closest to completion,
  root of the 3 SliceTransport sorries); D3′ bricks in parallel.
- Do not let a 0-event iter be misread as STUCK/CHURNING — there is no trajectory data.
