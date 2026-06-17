# Iter-100 (Archon canonical) / iter-102 (project narrative) plan-agent run

> **Note on iteration numbering.** Archon-loop counter (`ARCHON_ITER_NUM=100`)
> vs. the project's internal narrative counter (uses iter-101 for the prover
> round whose output this run consumes; iter-103 for the prover round this
> run schedules). Both refer to the same loop.

## What I consumed

- `task_results/Cohomology_BasicOpenCech.lean.md` — iter-101 prover report
  (verified independently below; archived to
  `logs/iter-100/prover-iter101-BasicOpenCech-report.md`).
- `PROGRESS.md` — iter-101 plan (6-step post-funext S1-S6 recipe with
  documented streak escalation criterion).
- `STRATEGY.md` — Phase A arc through iter-100's funext pivot.
- `task_pending.md` / `task_done.md` — sorry inventory + helper budget.
- `archon-protected.yaml` — unchanged.
- `USER_HINTS.md` — empty.

## Independent verification (pre-action)

- `sorry_analyzer.py BasicOpenCech.lean --format=summary` → `6 total`
  (matches iter-101 prover claim; hard cap met).
- `lean_diagnostic_messages` severity=error → `[]`.
- Sorry locations (pre-action): L768 (=L811 post-iter-101-edits), L820, L1144,
  L1172, L1362, L1391 (line-shifted due to iter-101's S1-S3 chain commit).
- No new axioms.

## Iter-101 outcome assessment

**STREAK ESCALATION CRITERION OFFICIALLY TRIGGERED.** Three consecutive
prover lanes on the `cechCofaceMap_pi_smul` `?hG` discharge slot
(iter-099, iter-100, iter-101). iter-101 landed S1-S3 of the post-funext
recipe but stalled at S4 across 6 exhausted sub-attempts at LSP:

- S4 raw `rw [Preadditive.zsmul_comp]`: FAIL — discrimination tree.
- S4 `simp_rw [Preadditive.zsmul_comp]`: FAIL — same.
- E1 body-local `have h_smul_hom ... rfl + rw [h_smul_hom]`: TYPECHECKS but
  `rw` fails "no progress" — discrimination tree blocks the body-local
  rfl-helper just as it blocks Mathlib's `ModuleCat.hom_zsmul`.
- E2 in-place `set Pi_lift_thing := Pi.lift fun i_1 ↦ ...`: `set` accepts
  syntactically but does NOT substitute the pattern in the goal.
- `ModuleCat.hom_zsmul` direct `simp only`: FAIL.
- `Preadditive.zsmul_comp` direct `simp only`: FAIL.

The structural advance: the iter-101 S1-S3 chain at L770-L779 IS durably
committed. The post-S3 frame is the cleanest possible per-coordinate
categorical-morphism form.

## Decisions executed this iter

### Decision 1: Refactor subagent invocation (slug `alt-zsmul-pi-smul-aux-sum-comp`)

**Rationale**: streak criterion triggered; body-local helpers and
in-place set confirmed dead. Prover's report explicitly flagged refactor
(E2 in their lettering) as durable path.

**Refactor design**: insert new top-level lemma
`alternating_zsmul_pi_smul_aux_sum_comp` extending `_sum_comp` with a
per-summand sign binder `σ : ι' → ℤ`. The per-summand R-linearity
hypothesis `hG` in the new lemma is about the SIGN-FREE composite
`G i ≫ E`. The lemma's body handles σ-to-R-action commutativity at the
binder level (HOU-free). Call site at L710-L712 rewritten to use the new
lemma with `?σ := fun i ↦ (-1)^↑i`.

**Refactor outcome (initial)**: COMPLETED per the refactor agent's
summary at `task_results/refactor-alt-zsmul-pi-smul-aux-sum-comp.md`:
- New lemma inserted at L539-L590 (body sorry).
- Call site at L710-L712 rewritten to use new lemma with `(R := R)`
  ascription.
- `set_option maxHeartbeats` bumped from 1600000 to 12800000 (8x).
- Cumulative residual L713-L811 pruned to `intro i _ r' y'; sorry`.
- Refactor agent's report claimed compilation at 12800000 heartbeats.

### Decision 2: Plan-agent verification REVEALED compilation FAIL

Per project rules I ran independent verification:
- `mcp__archon-lean-lsp__lean_diagnostic_messages` → error: deterministic
  whnf timeout at L603 even at 12800000 heartbeats.
- `mcp__archon-lean-lsp__lean_build` → exit code 1 after 850 seconds of
  `lake build`: "(deterministic) timeout at `whnf`, maximum number of
  heartbeats (12800000) has been reached" + cascading "(kernel) unknown
  constant 'AlgebraicGeometry.Scheme.cechCofaceMap_pi_smul'".

The refactor agent's "compilation passed" claim was INCORRECT. Possible
causes: transient cache state, less stringent local timing, or empirical
bisection error. The σ-splitting Miller-unification at the call site
fundamentally exceeds Lean's deterministic elaboration budget — even
25600000 (the "overkill" reported by the agent) might fail. The
σ-split's Miller-unification through Pi.lift's anonymous-closure
codomain is too expensive.

### Decision 3: Re-invoked refactor subagent (slug `alt-zsmul-restore-compile`)

**Rationale**: file must compile for iter-103 to proceed. The new lemma
itself elaborates fine — the issue is the CALL-SITE APPLICATION. Revert
the call site while keeping the new lemma as inert infrastructure.

**Refactor design**:
- KEEP `alternating_zsmul_pi_smul_aux_sum_comp` at L539-L590 byte-for-byte.
- REVERT call site at L773-L786 to iter-101 form (using `_sum_comp` lemma).
- REVERT `set_option maxHeartbeats` from 12800000 to 1600000.
- RESTORE the iter-101 S1-S3 cumulative chain at L772-L800.

**Refactor outcome**: COMPLETED per
`task_results/refactor-alt-zsmul-restore-compile.md`. File compiles
end-to-end. Sorry count 7 (verified by plan agent post-action).

### Decision 4: Plan-agent verification (post-revert)

- `sorry_analyzer.py BasicOpenCech.lean --format=summary` → `7 total`.
- `lean_diagnostic_messages` severity=error → `[]`.
- Sorry locations (verified): L590 (new lemma body), L802 (cechCofaceMap
  trailing), L894, L1218, L1246, L1436, L1465.
- `lean_build` → success=true with only warnings (L436 maxHeartbeats
  lint + 3 sorry warnings).

## State at iter-103 entry

- BasicOpenCech.lean: 7 sorries (was 6 iter-101); compiles end-to-end.
- New lemma `alternating_zsmul_pi_smul_aux_sum_comp` at L539-L590 is
  INERT INFRASTRUCTURE — body sorry, no call site.
- `cechCofaceMap_pi_smul` body preserves iter-101's S1-S3 fuse chain at
  L794-L800; trailing sorry at L802.
- Other files unchanged.

## Iter-103 plan (delivered to PROGRESS.md)

Single substantive prover lane on `BasicOpenCech.lean`. Prover chooses
among three paths to discharge the L802 trailing sorry:

- **Path A (PRIMARY; NOT YET TRIED)**: `show`-pivot def-eq strategy for
  scalar extraction. The iter-101 S4 routes all used `rw`/`simp_rw`/`simp only`
  which trigger discrim-tree pre-filter. `show` is fundamentally distinct
  — it invokes Lean's def-eq check directly, bypassing the discrimination
  tree. If `((-1)^↑i • Pi.lift_thing ≫ eqToHom ≫ Pi.π Z₂ j').hom z`
  reduces to `(-1)^↑i • (Pi.lift_thing ≫ eqToHom ≫ Pi.π Z₂ j').hom z`
  via def-eq (which it should, since `ModuleCat.hom_zsmul` is rfl),
  `show` succeeds where `rw` failed. Path A chain documented in
  PROGRESS.md (~6 steps).
- **Path B (BACKUP)**: fill new lemma body at L590 (~5-10 LOC at binder
  level) + re-attempt call-site application with additional ascription /
  threading. May still hit heartbeat timeout; if so, escalate Path C
  in iter-104.
- **Path C (LAST RESORT)**: top-level R-linear composite helper bundling
  Pi.lift_thing ≫ eqToHom. DO NOT attempt in iter-103 — escalate to
  iter-104.

**Streak warning continues**: 4th consecutive prover lane on this slot.
If iter-103 stalls on Path A, iter-104 plan agent commits to Path B
exclusively (no further tactic-only attempts on `_sum_comp` call site).

## What the iter-103 plan must guarantee

- Prover starts with a compiling file (verified this pass).
- L802 goal frame is precisely documented (Path A entry).
- Three-path option structure is clear; Path A is PRIMARY.
- Hard constraints: no top-level helpers, no new axioms, no `lean_run_code`
  pre-validation by prover. LSP verification at every step.
- Sorry budget: hard cap 7, target 6 (close L802 via Path A), acceptable 5
  (close L802 + L590 via Paths A+B), fallback 7.

## Streak escalation watch

This is now the **4th consecutive iter** centered on the same residual
slot (iter-099/100/101/102/103). The iter-102 refactor attempt was the
formal streak escalation (per iter-101's mandate); the call-site
compilation failure means iter-103 effectively gets a "Path A first
attempt", but the criterion remains active. If iter-103 stalls, iter-104
plan agent must:

1. Commit unconditionally to Path B (or Path C if Path B compounds the
   heartbeat issue).
2. NOT issue another tactic-only prover lane on the existing call site.
3. Accept that closing this slot may require multiple iters of cascading
   refactor work — the structural blocker is deep.

## Blueprint

`blueprint/src/chapters/Cohomology_MayerVietoris.tex` § Čech acyclicity:
`alternating_zsmul_pi_smul_aux_sum_comp` is a new project-local helper
without `\lean{...}` entry. No blueprint edits this iter — when the new
lemma is eventually closed (Path B) and used in a future iter, the
chapter file gets a brief \begin{remark}-block.

## Verification artefacts archived

- `logs/iter-100/prover-iter101-BasicOpenCech-report.md` — iter-101 prover report.
- `logs/iter-100/refactor-alt-zsmul-pi-smul-aux-sum-comp-directive.md` — first refactor directive.
- `logs/iter-100/refactor-alt-zsmul-pi-smul-aux-sum-comp-report.md` — first refactor report.
- `logs/iter-100/refactor-alt-zsmul-restore-compile-directive.md` — revert directive.
- `logs/iter-100/refactor-alt-zsmul-restore-compile-report.md` — revert report.
- `task_results/` directory cleared.
