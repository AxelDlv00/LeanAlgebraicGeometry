# Iter-040 plan — iter-039 was a NOOP-DROP (0 provers ran); B3 object iso re-dispatched with fixed phrasing

## Entering state (verified)
- **iter-039 dispatched 0 provers — `failed_all_noop`** (`logs/iter-039/meta.json`:
  `objectivesProposed:1, objectivesDispatched:0, objectivesNoop:[QcohRestrictBasicOpen.lean]`). No prover
  attempted the B3 object iso. `QcohRestrictBasicOpen.lean` is unchanged since iter-038 (still 0-sorry, the
  in-file TODO at lines 242–265 persists, `overBasicOpenIsoRestrict` is NOT defined).
- Project state otherwise unchanged from iter-039: B3 engine `modulesOverBasicOpenEquivalence` + 7 B3a helpers
  axiom-clean (iter-038); coverage debt cleared (iter-039 plan). B3/B4 blueprint blocks
  (`lem:restrict_over_compat`, `lem:presentation_modulesRestrictBasicOpen`) HARD-GATE-CLEARED iter-038,
  statements unchanged. `lem:restrict_over_compat` sits on the leandag ready-to-prove frontier.

## Root cause (the headline finding)
plan-validate's noop filter (`archon/commands/loop/sorry_count.py:_SCAFFOLD_RE`) drops any `## Current
Objectives` line that names an **existing 0-sorry** `.lean` file UNLESS the *same line* carries one of the
literal tokens: `scaffold` · `skeleton` · `leave bodies as` · `declarations for` · `does not yet exist` ·
`stub out` · `add the import`. The iter-039 objective line said "**do not yet exist**" — "do" ≠ "does", so
`does\s+not\s+(yet\s+)?exist` did NOT match; and "scaffold" appeared only on a *different* line (the intro
paragraph), not the path line. Result: the objective was silently dropped, the prover phase had nothing to
run, and iter-039 produced zero work. This is a **dispatch-phrasing bug**, not a mathematical or term-mode
regression.

## Decision made

### D1 — Re-dispatch the SAME B3 object iso + B4 objective with corrected phrasing; do NOT pivot, do NOT
consult speculatively.
The objective, recipe, and blueprint are all sound and unchanged — the only defect was the noop-exempt
keyword. Fix: the objective line now carries the literal `scaffold` AND a correctly-spelled `does not yet
exist` on the `.lean`-path line. This is the first genuine prover attempt on the object iso. The recipe is
complete and detailed (in-file TODO lines 242–265 written by the iter-038 prover who built the engine and
verified `(pushforwardCongr ?_).app M` typechecks against the target; blueprint B3a/b/c; `analogies/bridge.md`).
Mode stays `mathlib-build` (no-sorry build of NEW decls into a 0-sorry file).

### D2 — REBUTTAL of the iter-039 litmus / would-be CHURNING verdict.
progress-critic `iter039` (CONVERGING) set a litmus: "if `overBasicOpenIsoRestrict` slips AGAIN despite a
real attempt → CHURNING at iter-040 + dispatch a Mathlib-idiom consult on `pushforwardCongr`/`ι_appIso`
term-mode assembly before another prover round." **The precondition is NOT met.** The litmus presumed a
*real prover attempt* would fail; instead the objective was never dispatched (noop-drop, 0 provers). There
was no second slip from a prover hitting a term-mode wall — there was no prover at all. The corrective the
critic named (a term-mode-assembly consult) presupposes "a Lean term-mode assembly gap," but no prover has
reached that gap. Therefore the CHURNING verdict does NOT apply this iter, and a speculative analogist
consult would be premature: the in-file TODO already diagnoses the metavariable trap and states its fix
(supply φ/ψ/F explicitly; close `h` with explicit `NatTrans.ext`/`Subsingleton.elim`, never bare `ext`).
The cheapest high-value signal is a real prover attempt, not another read-only consult on a wall no prover
has actually struck.

**Litmus re-armed (correctly this time):** if THIS — the first genuine prover attempt — stalls on the
`pushforwardCongr` metavariable, iter-041 dispatches the mathlib-analogist (api-alignment) with the prover's
*actual error state* attached. That is materially more useful than a speculative consult now.

### D3 — ONE prover lane (QcohRestrictBasicOpen only).
QcohTildeSections's keystone assembly `qcoh_section_isLocalizedModule` requires `import QcohRestrictBasicOpen`
for B3/B4 — which do not exist yet — so it is genuinely import-blocked, not throttled. No honest second lane.
The dependency graph is linear here.

## Subagent skips
- progress-critic: iter-039 ran NO prover phase (0 dispatched, `failed_all_noop`) → no new trajectory data to
  assess. The prior verdict (CONVERGING) stands; its litmus is rebutted above (D2) on the dispatch-bug ground,
  not silently overridden. Skip condition "the prior iter ran no prover phase" is met verbatim.
- blueprint-reviewer: B3/B4 (`lem:restrict_over_compat`, `lem:presentation_modulesRestrictBasicOpen`) were
  HARD-GATE-CLEARED at iter-038; their *statements/proofs are unchanged* since. The only chapter edit since
  was iter-039's additive `\uses` edge to the now-done engine + the `def:modules_over_basicOpen_equivalence`
  coverage block for an ALREADY-DONE decl — neither touches the live prover targets. `lem:restrict_over_compat`
  is on the ready-to-prove frontier (all `\uses` deps done). Re-reading the B3/B4 blocks myself this phase
  confirmed they are well-formed and match the `\lean{}` pins. The gate's intent (don't send a prover at a
  broken blueprint) is satisfied.
- strategy-critic: STRATEGY.md route/decomposition unchanged; the iter-039 edit was a remaining-iters estimate
  refresh per the progress-critic recommendation, no route/goal change; prior verdict SOUND with no live
  CHALLENGE. The 01I8 Route B arc is unchanged.

## Next-iter plan (unchanged from iter-039, gated on B3/B4 landing)
1. Keystone assembly `qcoh_section_isLocalizedModule` once B3+B4 land (add `import QcohRestrictBasicOpen`).
2. Route B assembly `isIso_fromTildeΓ_of_quasicoherent` → unconditional `qcoh_iso_tilde_sections`.
3. Unblock 02KG tops (`affine_cech_vanishing_qcoh`, `affine_serre_vanishing`).
4. P5a inputs; 5. EnoughInjectives connector + P5b assembly.
- If THIS B3 attempt stalls on the metavariable: iter-041 analogist consult with the prover's error state.
