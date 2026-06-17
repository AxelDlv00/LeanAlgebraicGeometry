# Iter-015 plan — re-dispatch the two critical-path lanes the weekly limit killed

## Context entering the iter

PROGRESS.md was stale at iter-011. Reconstructing 012–015 from logs/sidecars:
- **iter-011 (plan)**: realigned the P3b blueprint (bypass the two expensive Mathlib-absent
  bricks), executed the file-split (`CechAcyclic.lean` P3 + `PresheafCech.lean` P3b skeleton),
  gate-cleared both, and dispatched **two parallel `mathlib-build` lanes** (P3 + P3b).
- **The iter-011 prover phase was aborted externally.** The prover jsonls
  (`logs/iter-011/provers/*.jsonl`) end with `"You've hit your weekly limit · resets 10pm (UTC)"`
  followed immediately by `session_end` — the CechAcyclic lane died at turn 12 / 151 s mid-search,
  the PresheafCech lane never produced a declaration. **This is an external interruption, not a
  feasibility or churning block.**
- **iter-012 (dag)**: status `running` — interrupted, no output.
- **iter-013 (dag)**: COMPLETE. Pure structural wiring (mirrored proof-block `\uses` into
  statements; bundled 28 helpers; de-isolated the P3b cone). blueprint-reviewer (`iter013-postwire`,
  fresh context, whole-blueprint) → **HARD GATE CLEARS, all 3 chapters complete+correct, 0 must-fix,
  0 unstarted-phase proposals.**
- **iter-014 (plan)**: status `running` — interrupted, no objectives written, no provers dispatched.

So the net effect of 012–014 is **zero prover progress** since iter-011, entirely due to the
weekly-limit abort + two interrupted dag/plan iters. The plan from iter-011 (gate-clear,
recipe-ready, files split) was never given a chance to execute.

## Ground-truth state (verified this iter)

`lake build` GREEN (8320 jobs); only expected `sorry` warnings.
- `CechAcyclic.lean` — P3 `CechAcyclic.affine`, **1 open sorry** (line 74). Statement-`\leanok`.
  Blueprint complete+correct. Recipe: `.archon/analogies/p3-localisation.md`.
- `PresheafCech.lean` — P3b, **empty skeleton** (197 lines: namespace + roadmap comment, 0 decls).
  Blueprint complete+correct. Recipe: `.archon/analogies/p3b-presheafcech.md`.
- `AcyclicResolution.lean` — P4, 0 sorries, DONE.
- `HigherDirectImage.lean` — just the `higherDirectImage` def (RHS of the goal), 0 sorries.
- `CechHigherDirectImage.lean` — P5b protected assembly `cech_computes_higherDirectImage`,
  1 sorry (line 771, FROZEN). P5a decls are blueprinted in this chapter but not yet in Lean.

Leandag frontier (5 ready): `def:section_cech_complex`, `def:cech_free_presheaf_complex`,
`lem:ses_cech_h1` (all P3b → PresheafCech.lean, scaffold+build), `lem:higher_direct_image_presheaf`,
`lem:cech_augmented_resolution` (P5a). `lem:cech_acyclic_affine` is `[leanok, sorry]` (off-frontier
because statement-leanok, but a real fill-the-sorry target with deps done).

## Decision made

### D1 — Re-dispatch exactly the two critical-path lanes (P3 + P3b); do NOT open P5a this iter.
- **Why re-dispatch unchanged**: the iter-011 plan was sound — both lanes are blueprint-gated
  complete+correct (iter-013 fresh-context reviewer), both have precise Mathlib-aligned recipes,
  both files compile. They failed only because the weekly API limit killed the session. The correct
  response to an external interruption is to run the work, not to re-plan it. No churning signal
  exists (there is no completed prover trajectory to churn).
- **Why NOT open a 3rd P5a lane** (despite the standing parallelism directive):
  1. **No shortest-path value yet.** The goal cone is P3 → `affine_serre_vanishing` →
     `cech_term_pushforward_acyclic` → P5b. The only *independent* P5a leaf,
     `higher_direct_image_presheaf` (01XJ), feeds `open_immersion_pushforward_comp` /
     `cech_term_pushforward_acyclic`, **both blocked on `affine_serre_vanishing`** (= P3+P3b).
     Building it now unblocks nothing until P3+P3b land. `cech_augmented_resolution`'s proof itself
     `\uses` `cech_acyclic_affine` (still a sorry), so it isn't cleanly independent either.
  2. **Setup overhead for no payoff.** P5a decls are blueprinted in the consolidated
     `CechHigherDirectImage.tex` (which covers CechHigherDirectImage/CechAcyclic/PresheafCech), so a
     P5a lane needs either a new file + `% archon:covers` update + scaffolder dispatch, or to inject
     decls into the frozen-decl file — friction that buys an off-critical-path leaf.
  3. **P3b is the true bottleneck** (effort 3000+, the entire presheaf-Čech chain). Concentrating
     budget on it + P3 is higher-value than splitting attention.
  The standing parallelism directive is honored — we run two parallel lanes on the already-split
  files; the directive targets *not serializing splittable work*, not maximizing lane count past
  where lanes have value. **Reversal signal**: once P3+P3b land (affine_serre_vanishing available),
  open P5a as 2–3 parallel lanes immediately (it then funnels into the P4 engine).

### D2 — Emphasize the recipe's L3 anti-pattern to the P3 prover.
The killed CechAcyclic prover was, at the moment of the abort, searching
`SimplicialObject.Augmented.ExtraDegeneracy` — exactly the route the recipe says **NOT** to take
(wrong variance, no cosimplicial dual). I'll restate this prominently so the re-dispatched lane uses
the L3 explicit module homotopy `h(σ)_{i₀…iₚ} = σ_{r i₀…iₚ}` in `A_{s_r}` instead.

## Subagent skips

- **blueprint-reviewer**: iter-013 `iter013-postwire` (fresh context, whole blueprint) cleared all 3
  chapters `complete: true` + `correct: true`, 0 must-fix, 0 unstarted-phase proposals. No chapter
  math-content edits since (012/014 interrupted before any write; 013's edits were the *subject* of
  that clearing review). All files under this iter's prover work (P3, P3b — covered by the cleared
  consolidated chapter) are gate-clear. HARD GATE satisfied by the standing verdict.
- **strategy-critic**: STRATEGY.md unchanged since iter-011 (last edit iter-011); iter-011 verdict
  was SOUND with no live CHALLENGE; no strategy change this iter (re-dispatching an existing,
  already-sound plan). Skip conditions all met.
- **progress-critic**: the only prover phase since the last assessment (iter-011→prover) was aborted
  by the weekly API limit before producing any trajectory; iters 012–014 ran no (completed) prover
  phase. There is no new trajectory data to extrapolate, and the stall is provably external (jsonl
  weekly-limit marker), not churning. Re-running it would assess noise. Will re-dispatch once P3/P3b
  produce a real prover trajectory.
