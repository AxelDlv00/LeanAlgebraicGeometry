# Iter 006 — Plan (Quot-Foundations)

## TL;DR

Prover-stage plan iter following an intervening iter-005 dag-only stage (which rebuilt the graph
and declared the blueprint structurally complete, but whose queued blueprint-reviewer/strategy-critic
directives never produced reports — context reset). Processed the iter-004 prover results (FBC: L4-a
core + L4-c closed; GF: full L3 chain closed — both axiom-clean) and the three iter-005 review
subagents (lean-auditor + 2 lean-vs-blueprint-checkers: all 0 must-fix). This turn: (1) fixed the one
blueprint major (stale L4 `% LEAN SIGNATURE` in GF) + resolved the FBC coverage debt by giving
`base_change_regroup_linearEquiv` its own 1:1 chapter; (2) dispatched the refactor `split-regroup`
that moves that helper into a separate compilation unit — the CONFIRMED fix for the FBC `map_smul'`
instance-diamond wall that had sat undeployed 2 cycles; (3) ran the mandatory progress-critic
(**CHURNING×2, dispatch=OK**) and blueprint-reviewer (**HARD GATE CLEARS both lanes, 0 must-fix**).
Both lanes dispatch with their structural correctives deployed: FBC closes `map_smul'` via the now-
imported one-liner + first real attempt at the mate-trace crux; GF restructures L5 to strong
induction (`Nat.strongRecOn`, ∀N) — the critic's named corrective — then attempts the dévissage.

## State at entry

- iter-004 prover landed: FBC `base_change_regroup_linearEquiv` (L4-a core) + `…_generator_trace`
  (L4-c) axiom-clean; GF entire L3 chain (4 lemmas) axiom-clean + L4 re-sign/Step-1 + L5 torsion
  sub-case. Build green; FBC 4 sorries, GF 4 sorries.
- iter-005 was a `dag` stage (graph rebuild, blueprint-complete attempt). Its blueprint-reviewer-iter005
  + strategy-critic-iter005 directives are on disk but produced NO reports — treat as not-run.
- Latest COMPLETED reviews of record were iter-004 (cleared FBC+GF) + the iter-005 read-only audits
  (lean-auditor-iter004, lean-vs-blueprint-checker-fbc/gf: 0 must-fix).

## Critic dispositions

- **blueprint-reviewer (`iter006`, ran this turn): HARD GATE CLEARS both active lanes.** 6 chapters
  audited, 0 must-fix, 0 incomplete, 0 broken `\uses{}`/isolated nodes, 0 unstarted-phase proposals.
  Confirmed: the new `Cohomology_RegroupHelper.tex` block is well-formed + correct (coverage debt
  resolved); the corrected GF L4 `% LEAN SIGNATURE` now matches the landed decl; the QUOT/GR/SNAP
  frontier defs are complete+correct enough to open a QUOT-defs scaffold lane next iter.
- **progress-critic (`iter006`, ran this turn): CHURNING×2, dispatch=OK.** See `## CHURNING response`.
- **strategy-critic: SKIPPED** (see `## Subagent skips`).

## CHURNING response (must-fix obligation)

The critic flagged BOTH lanes CHURNING on the standalone PARTIAL×3 criterion, but its root-cause
diagnosis is explicit and is NOT "unmoving residual / pile on more helpers" — it is "a known
structural fix was identified and left undeployed." The required corrective for each is a CONCRETE
STRUCTURAL action deployed THIS iter, not another reworded helper round:

- **FBC-A corrective — DONE this turn.** The confirmed `map_smul'` one-liner fix needed the helper
  in a separate compilation unit. I dispatched refactor `split-regroup` → `base_change_regroup_linearEquiv`
  now lives in `Cohomology/RegroupHelper.lean`, imported by FlatBaseChange; full project builds, same 4
  sorries. The prover now closes `map_smul'` outright via
  `exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`, then makes the FIRST real prove
  attempt at `base_change_mate_generator_trace_eq` (it was a typed-sorry with no attempt yet, not a
  re-dispatch of a stalled attempt).
- **GF-alg corrective — directed this turn.** The critic's named corrective is "restructure L5 to
  `Nat.strongRecOn` (∀N) before any further helper accumulation." PROGRESS.md makes that the PRIMARY,
  mandatory GF objective (the strong-induction skeleton MUST land this iter); the L4 denominator-
  clearing is demoted to budget-permitting. This is a proof-skeleton rewrite (prove mode), not a
  cosmetic re-attempt — the existing `rcases`-split skeleton is structurally non-viable (no IH in
  scope), which is exactly why repeated prove attempts couldn't progress.

No "another helper round on a CHURNING lane" is being issued. Both correctives are structural and
deployed. If iter-006 still returns either lane PARTIAL with no structural advance, the ramp escalates
to effort-break (FBC mate-trace per step; GF dévissage SES seams) — recorded in PROGRESS ramp.

## Decision made

### Keep two single-file lanes; do NOT split GF; deploy fixes rather than effort-break (this iter)
- **Option chosen:** prove-mode on FBC + GF, structural correctives deployed (refactor done for FBC;
  prover-directed restructure for GF). No effort-break, no GF file-split this iter.
- **Why:** progress-critic explicitly found NO serial bottleneck in GF (L4/L5 independent; blockers
  are content/structure, not file-scope) → single lane correct, file-split unjustified. And the two
  cruxes (FBC mate-trace, GF dévissage SES) have not yet had a single real prove attempt against a
  CORRECT structure — effort-breaking before that first attempt is premature decomposition. Deploy the
  structural prerequisites (separate-module helper; strong-induction skeleton) so the first real
  attempt happens against a viable structure.
- **Trade-off:** 1 iter of latency if the cruxes still stall post-fix; cheaper than paying an
  effort-break iter on a crux whose first honest attempt might close it. Cheapest reversal signal: if
  iter-006 returns FBC `generator_trace_eq` or GF dévissage PARTIAL with zero per-step progress, the
  ramp effort-breaks them next iter (already queued).

## Actions taken this turn

1. Processed iter-004 prover results + iter-005 review audits → `task_done.md` (created),
   `task_pending.md` (rewritten to iter-006 state).
2. Blueprint edits (mine): corrected the stale GF L4 `% LEAN SIGNATURE` block (added the retained
   `Algebra A_g B_g` binder; reworded the "replaces … anonymous instance" sentence) — the iter-005
   checker's one major. Created `chapters/Cohomology_RegroupHelper.tex` (block
   `lem:base_change_regroup_linearEquiv`, 1:1 slug for the new Lean file), `\input` in content.tex,
   and added the `\uses{lem:base_change_regroup_linearEquiv}` edge from `lem:base_change_mate_regroupEquiv`
   (statement + proof) — resolves the iter-005 coverage debt.
3. Dispatched refactor `split-regroup` (COMPLETE — helper moved, builds green, 4 sorries unchanged).
4. Dispatched progress-critic `iter006` (CHURNING×2, dispatch=OK) + blueprint-reviewer `iter006`
   (HARD GATE CLEARS both lanes) in parallel.
5. Wrote PROGRESS.md objectives (2 lanes, prove mode, structural correctives) + this sidecar.

## Subagent skips

- strategy-critic: STRATEGY.md SHA-unchanged from prior iter (git shows no diff vs HEAD) and the
  prior verdict (iter-003) was SOUND for FBC/GF with the QUOT challenge addressed — no live CHALLENGE.
  Routes are mid-execution and converging on the same arc; I am deploying tactical structural fixes,
  not changing any route/phase/decomposition. The iter-005 dag stage queued a strategy-critic directive
  but it never ran; since STRATEGY is unchanged and routes are sound, that creates no live obligation.

## Notes / non-blocking debt carried forward

- lean-auditor `iter004` majors (all non-blocking, deferred to polish/golf): ~22 deprecated
  `Sheaf.val` sites in FBC; stale "What remains" comment misrepresenting `pushforward_spec_tilde_iso`;
  `UniversalProperty`/`affine_base_iff` naming drift in RelativeSpec.
- lean-vs-blueprint-checker noted a systematic absence of proof-block `\leanok` across ~19 proved FBC
  lemmas — this is the deterministic `sync_leanok` phase's job (runs between prover and review), NOT a
  plan/blueprint action. Flag only; no action.
- QUOT-defs is the next parallelism lever: chapters cleared, frontier ready — open a `mathlib-build`
  lane on QuotScheme.lean once a FBC/GF slot frees.
