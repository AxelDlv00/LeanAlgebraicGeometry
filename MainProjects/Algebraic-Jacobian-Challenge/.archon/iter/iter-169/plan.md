# Iter-169 plan-agent run

## Headline outcome

**The "honor the armed escalation trigger — pivot to Option B and land the
`gmScalingP1` body" iter.** progress-critic `routec169` returned **CHURNING**
with the headline target `gmScalingP1` body **untouched for 4 consecutive
iters** (iter-165 scaffold opened the sorry; iter-166/167/168 each landed
~120-370 LOC of *support* infrastructure but never the body). The iter-168
planner's own commitment was "4th consecutive deferral triggers user-escalation
iter-169." That trigger is **ARMED**. The critic's primary corrective is
**refactor**: adopt the iter-168 prover's Option B (direct
`Proj.fromOfGlobalSections` from chart-side ring maps
`MvPoly (Fin 2) kbar → Away 𝒜 (X i) ⊗ GmRing`), drop the iso-skeleton
sub-build's load-bearing role, and make iter-169 PRIMARY = "land
`gmScalingP1` body via Option B," not "close `aux_left` then iso then body."

One prover lane on `AlgebraicJacobian/Genus0BaseObjects.lean`, attacking
`gmScalingP1` body + `gmScalingP1_collapse_at_zero` body via **Option B**,
plus the auditor must-fix hygiene items (stale docstrings, drop `ga_grpObj`).

## Decision made (lane count + route pivot)

**ONE prover lane on `Genus0BaseObjects.lean`, attacking the headline body via
Option B (NOT the iso-route Option A). NO Lane B on AVR this iter.**

Reasoning:

- The progress-critic explicitly named refactor-to-Option-B as the primary
  corrective and warned that "continuing to chase the iso would be ratifying
  the same churn pattern." Opening Option A (close `aux_left` first) would
  burn another iter of supports — exactly the churn pattern. Option B
  bypasses the iso entirely.
- Lane B on AVR is gated on Lane A landing concrete `gmScalingP1` body. If
  Lane A doesn't land, Lane B can't close `iotaGm_isDominant`. With parallel
  dispatch, there's no race-free way to chain them in one iter. Defer Lane B
  to iter-170 (which becomes a trivial `infer_instance`-closeable
  axiom-clean closure once Lane A lands).
- File-disjoint Lane B WOULD be the dispatch-sanity sweet spot if AVR had a
  ready sorry that's not body-gated on Lane A, but it doesn't — the only AVR
  sorries are `iotaGm_isDominant` (gated) and `genusZero_curve_iso_P1` (RR
  bridge, deferred to upstream Mathlib per iter-168 `rrbridge` analogist).
  So single-lane is correct here, not an under-dispatch artifact.

**The iso skeleton (`homogeneousLocalizationAwayIso` + 5 helper ring-homs +
`aux_left` residual sorry) is NOT deleted this iter** — it stays in tree as
deferred infrastructure with a refreshed honest docstring. Reasoning: ~80
LOC of almost-complete iso infrastructure is reasonable to keep as a future
upstream candidate (a single Mathlib PR
`HomogeneousLocalization.PolynomialQuotient` would absorb it). The blueprint
pin `def:proj_chart_ring_iso` (just landed by the writer with a `% NOTE:`
flagging scaffold status) accurately documents the iso's deferred state.
What changes: the iso is no longer load-bearing for the genus-0 closure
(Option B sidesteps it), so the misleading "iter-168 partial: structural
setup via ..." docstring on `aux_left` MUST be rewritten to "TODO — no
body landed; deferred infrastructure not on the genus-0 critical path."

**Cheapest reversal signal**: if the iter-169 prover discovers Option B
also fails to land the body (e.g. `Proj.fromOfGlobalSections` from the
chart-i ring map needs a section condition / irrelevant-ideal condition
that's just as hard as the iso route), the critic's secondary corrective
fires: escalate to the user. iter-170 plan would surface the strategic
question "the genus-0 base case needs an upstream Mathlib sub-build that
the project cannot land in <50 LOC; should we (a) commit to the Mathlib
sub-build as its own ~5-iter detour, (b) accept `[CharZero]` as a temporary
hypothesis and use `rigidity_over_kbar` as the artifact, (c) something
else?" — and proceed with whichever option the user picks, or pick one
ourselves and notify via TO_USER. iter-170 does NOT open a 6th iter of
supports.

## Prior critique status

- **progress-critic `routec168` verdict CHURNING (iter-168) with 3 must-fix
  items** — iter-168 plan addressed items (i) (mathlib-analogist consult),
  (ii) (bounded decomposition commitment), (iii) (RR-bridge dispatchability
  statement). Item (ii)'s commitment was "Steps 1+2 axiom-clean → body iter-168
  OR iter-169." iter-168 delivered Step 1 ✓ + Step 3 ✓ + Step 2 PARTIAL ✗
  + Steps 4-7 NOT ATTEMPTED. **The bounded commitment was NOT satisfied**
  (Step 3 cannot substitute for Step 2). This iter (169) honors the
  resulting armed trigger by pivoting to Option B + committing to user
  escalation if the body doesn't land.

- **progress-critic `routec169` verdict CHURNING (iter-169 fresh)** with 3
  must-fix-this-iter items — ALL ADDRESSED THIS ITER (see "Acting on the
  critic's must-fixes" below).

- **lean-auditor `iter168` 11 must-fix items** — addressed as follows this
  iter:
  - **iter-169 prover lane addresses 6 of 11** in `Genus0BaseObjects.lean`:
    rewrite stale `aux_left` docstring (#3); refresh `projectiveLineBar_isReduced`
    docstring (#9); land `gmScalingP1` body (#4) + `gmScalingP1_collapse_at_zero`
    body (#5); honestly classify `projectiveLineBar_geomIrred` /
    `projectiveLineBar_smoothOfRelDim` / `gm_geomIrred` / `projGm_isReduced`
    docstrings (#6-#8, #11) — re-audit "Mathlib gap" claims per critic's
    lesson, refresh to either close or honestly document.
  - **iter-169 prover lane drops `ga_grpObj`** (auditor major item)
    — off-path per iter-168 plan, no live consumer; delete the sorried
    instance.
  - **iter-169 also TOUCHES `gm_grpObj` decision**: per progress-critic,
    Option B may sidestep `gm_grpObj` (the direct `Proj.fromOfGlobalSections`
    chart-i ring map doesn't need GrpObj structure on `Gm` for the
    morphism itself; only for downstream Cor 1.5 consumption). If Lane A's
    body lands without consuming `gm_grpObj`, the off-critical-path
    re-classification from iter-168 plan stands; otherwise it goes
    on-critical-path. The prover decides based on what Option B actually
    needs.
  - **Deferred to a future hygiene iter (5 of 11)**: AVR `iotaGm_isDominant`
    (must-fix #10) waits for iter-170 (`infer_instance`-closeable once Lane A
    lands); Jacobian `genusZeroWitness.key` 26-line stale excuse (must-fix
    #12) waits for the Jacobian-touch iter (gated on Lane A + AVR axiom-clean
    lift). Reason: changing them this iter would expand scope past the
    critic's narrow corrective (land the body).

- **lean-vs-blueprint-checker `g0bo-iter168` verdict CONVERGING** with 3
  major coverage gaps + 2 stale Lean docstrings — ADDRESSED this iter:
  - Coverage gaps (4 missing `\lean{...}` pins): **CLOSED** by
    `blueprint-writer g0bo-pins-iter169` (4 new blocks landed —
    `def:projlinebar_affine_cover`, `def:proj_chart_ring_iso`,
    `lem:proj_chart_ring_iso_aux_left`, `lem:projlinebar_isReduced`).
  - Stale Lean docstrings (2 items): rolled into the iter-169 prover lane's
    hygiene pass (see auditor #2/#9 above).

- **blueprint-doctor (iter-168)**: no structural findings.

## Acting on the critic's must-fixes

iter-169 plan executes the critic's recommended path verbatim:

1. **PRIMARY — refactor to Option B**: prover lane PRIMARY target is
   `gmScalingP1` body via direct `Proj.fromOfGlobalSections` from chart-i
   ring maps `MvPolynomial (Fin 2) kbar → Away 𝒜 (X i) ⊗ GmRing`. NO use
   of `homogeneousLocalizationAwayIso` in the body. The iso stays in tree
   as deferred infrastructure (`aux_left` sorry refreshed to honest TODO).
2. **Deferral trigger acknowledged + committed**: if iter-169 ALSO produces
   PARTIAL/INCOMPLETE on the body, the iter-170 plan opens with USER
   ESCALATION via TO_USER.md — NOT a 5th iter of supports.
3. **`gm_grpObj` deferred-helper watch**: Option B may sidestep `gm_grpObj`
   for the *morphism* construction; the rigidity body's collapse step
   already consumes `[GrpObj A]` on the target, NOT on `Gm`. Lane A
   prover decides whether to engage `gm_grpObj` based on what Option B
   needs. If sidestepped, the off-critical-path classification stands.

## Subagent dispatches this iter

1. **progress-critic `routec169`** [HIGHLY RECOMMENDED] — DISPATCHED.
   Report at `task_results/progress-critic-routec169.md`. Verdict:
   CHURNING. Acted on above.

2. **blueprint-writer `g0bo-pins-iter169`** — DISPATCHED. Report at
   `task_results/blueprint-writer-g0bo-pins-iter169.md`. Verdict:
   COMPLETE; 4 new pins landed; no strategy-modifying findings. The
   `% NOTE:` flag on `def:proj_chart_ring_iso` accurately documents the
   iso's deferred status (aligned with this iter's Option B pivot, where
   the iso is no longer load-bearing).

## Subagent skips

- **strategy-critic**: STRATEGY.md unchanged since iter-167 (last
  edit), and the prior verdict was SOUND with no live CHALLENGE /
  REJECT. Per dispatcher_notes, this satisfies all three skip
  conditions (file SHA-equal, prior SOUND, no live challenges).
- **blueprint-reviewer (whole-blueprint pass)**: HARD GATE was cleared
  for `AbelianVarietyRigidity.tex` at iter-161 (and verified iter-164,
  iter-165, iter-167, iter-168). No chapter under `blueprint/src/chapters/`
  was edited by an external writer this iter beyond the targeted
  `g0bo-pins-iter169` writer round, whose 4 new blocks are coverage
  improvements (not corrections). The chapter remains
  `complete: true + correct: true` for every file under prover work
  (the targeted writer round only ADDS pins, never deletes or
  re-shapes existing content). No must-fix-this-iter finding from
  the prior dispatch remains live. The iter-168 lean-vs-blueprint
  checker explicitly verdict was CONVERGING (no must-fix-this-iter).

## Tool substitutions

None this iter — all proactive consults landed via the prescribed
subagent dispatches (no `archon-informal-agent.py` fallback needed;
no `WebSearch`/`WebFetch` needed; no `reference-retriever` dispatch
needed since iter-168 `gmscaling-deep.md` already covers the prover's
Mathlib idioms and Option B is a recombination of the same idioms,
not a new mathematical sub-build).

## Sorry landscape (entering iter-169)

- `AbelianVarietyRigidity.lean` — **2 sorries** (L934 `iotaGm_isDominant`,
  gated on Lane A; L1141 `genusZero_curve_iso_P1`, deferred to upstream
  Mathlib).
- `Genus0BaseObjects.lean` — **9 sorries** (L175, L182, L368, L537, L622,
  L661, L678, L763, L795).
- `Jacobian.lean` — 2 sorries (`genusZeroWitness`, `positiveGenusWitness`).
- `RigidityKbar.lean` — 1 sorry (`rigidity_over_kbar`, fallback `[CharZero]`).

Project total: **14**. The iter-169 prover lane targets G0BO L661
(`gmScalingP1` body) and L678 (`gmScalingP1_collapse_at_zero` body) as
PRIMARY; the auditor must-fix hygiene items are inline within the same
file (refresh L368/L708 docstrings; drop L537 `ga_grpObj`; re-audit
docstrings of L175/L182/L763/L795).

If Lane A's PRIMARY lands axiom-clean:
- G0BO L661 + L678 close (−2).
- L537 (`ga_grpObj`) deletes (−1).
- If `gm_grpObj` is NOT engaged by Option B's morphism construction
  AND remains a separately-deferred OPT-IN, L622 stays a sorry (no
  delta). If Option B's body needs `gm_grpObj`, the prover decides
  whether to attempt or to honestly classify as a remaining residual.
- Best case: G0BO 9 → 6 (−3) and AVR L934 becomes `infer_instance`
  -closeable in iter-170 (an additional −1 next iter).

## Reversal trigger (commit)

**If iter-169 prover lands PARTIAL/INCOMPLETE on `gmScalingP1` body**
(via Option B OR any other route), iter-170 plan opens with **user
escalation via TO_USER.md** — NOT another helper-supports round.
Specific message format: "the genus-0 base-case `ℙ¹→A` const sub-build
has been stalled for 5 consecutive iters with the headline
`gmScalingP1` body untouched; options are (a) commit to a Mathlib
sub-build PR for `HomogeneousLocalization.PolynomialQuotient` as a
~5-iter detour, (b) accept `[CharZero]` as a temporary hypothesis and
use `rigidity_over_kbar` as the artifact (closes the genus-0 arm
char-0-only), (c) something else; the planner has chosen option (X)
and proceeds — user can override via USER_HINTS." The iter-170 plan
records that choice + proceeds — no waiting on user.

## User-silent fallback executed

N/A — no user hints this iter; no prior-iter sidecar `## Fallback if no
user response` section needed; proceeding normally.
