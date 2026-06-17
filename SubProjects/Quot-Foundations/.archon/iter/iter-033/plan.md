# Iter 033 — Plan (Quot-Foundations)

## TL;DR

Processed the iter-032 prover round (**GR-glue CLOSED**, **QUOT gap1 bridge C CLOSED**, **FBC 4→4** partial)
and the iter-032 plan-cycle subagents (2 critics, effort-breaker `fbcb`, coverage writers `gr-cov`/`quot-cov`)
— the iter-032 plan phase ran them but was interrupted before finalizing PROGRESS/sidecar, so this iter
consumes that work. Ran the post-writer gates (blueprint-clean + whole blueprint-reviewer HARD GATE) on the
3 edited chapters; all 4 proposed lanes clear the gate. Dispatched **4 parallel import-independent lanes**:

1. **FBC-A** [prove] — the **final** direct-on-sections round on `_legs` (Open Q2 firm cutover). The prior 4
   rounds were *non-executable*: the eCancel atoms are declared after `_legs`. This round inlines them ahead,
   collapses the `Eq.mpr` casts, then term-mode splices. Hard commit: no further round if it fails.
2. **FBC-B** [mathlib-build] — NEW split-out file `FlatBaseChangeGlobal.lean`; scaffold + build the
   effort-breaker's 7-block H⁰-as-equalizer chain bottom-up. Independent of `_legs` — the strategy-critic's
   parallelism corrective.
3. **QUOT-P1** [mathlib-build] — build `isIso_fromTildeΓ_restrict_basicOpen` via the now-unblocked
   `overRestrictPullbackIso` + `Presentation.map`.
4. **GR-sep** [mathlib-build] — scaffold + prove `isSeparated` (diagonal closed immersion, Nitsure §1).

STRATEGY.md edited to address the strategy-critic CHALLENGE (Risk cells shrunk to one line; FBC-B promoted to
an ACTIVE parallel split-out lane; Open Q2 made a firm iter-034 cutover with both arms). Coverage debt cleared.

## State at entry (verified from task_results + leandag + blueprint-reviewer `iter033`)

- **GR** 0 sorries. `Grassmannian.scheme` axiom-clean (LANE GR-glue CLOSED iter-032). Next target
  `isSeparated`/`isProper` do NOT exist yet (scaffold). lem:gr_separated source-quoted + gate-cleared.
- **QUOT** 4 protected stubs. Bridge C CLOSED (`overRestrictIso`+3 helpers axiom-clean). P1 node
  `isIso_fromTildeΓ_restrict_basicOpen` does NOT exist yet (build target); gate-cleared.
- **FBC** 4 sorries: `_legs` @~1381 (live, the 15-iter crux), `gstar_transpose` @~1721 (gated), affine @~1994,
  FBC-B target @~2034 (superseded by the new file). FBC-B 7-block chain blueprinted + gate-cleared (conditional
  on the prover verifying 2 Mathlib anchor names — flagged in the directive).
- **GF** 1 sorry (gated on gap1).

## FBC STUCK rebuttal (progress-critic `iter032` requires an explicit one — the 3 conditions)

The progress-critic returned **STUCK** for FBC with primary corrective "user escalation (tripwire fires)",
and stated that overriding it requires a written rebuttal meeting three conditions. The
**standing AUTONOMOUS-OPERATION directive forbids user escalation** ("There is no reason for Archon to
escalate to the user … always find the best path … refactoring may be a good option to a dead-end"), so I
take the override path and satisfy all three conditions:

- **(a) Name the structural change.** The structural change is the **declaration-ordering discovery**: all
  three eCancel atoms (`base_change_mate_inner_eCancel_eUnit`/`_pullbackComp`/`_pushforwardComp`) and
  `inner_value_eq` are declared AFTER `_legs` in the file, so they were *out of scope at the sorry for every
  one of the 4 prior rounds*. The prescribed splice referenced lemmas the elaborator could not see —
  `Unknown identifier` confirmed by the iter-032 prover. The route was non-executable by construction, not
  tried-and-failed. iter-033 changes the approach concretely: **inline the canceller content ahead of `_legs`
  (≤3 lines each, no reference to the later atoms) + collapse the `Eq.mpr` casts via the concrete-legs read**
  — a route never attempted.
- **(b) Unconditional commitment.** If iter-033 does NOT close at least one of the `_legs`/`gstar_transpose`
  sorries, the direct-on-sections vehicle is **ABANDONED** — no further wrapper/prove round on `_legs`.
  iter-034 pivots to Open Q2 **arm (a)**: re-encode the base-change map at the `ModuleCat`/`SheafOfModules`
  level so the `X.Modules` diamond never forms. This is written into STRATEGY.md Open Q2 as a firm,
  non-re-datable cutover.
- **(c) Accept and document the OVER_BUDGET cost.** Acknowledged: FBC-A is ~15 iters into a 1–2 iter estimate
  (7–15×). The cost is accepted for exactly ONE final round because (i) the cheap fix was provably never run,
  and (ii) the alternative (ModuleCat re-encoding) is a heavier refactor worth attempting only after the
  1-iter inlining route is ruled out. Documented for the user via TO_USER.md (FYI + override channel).

I do **not** soften the STUCK verdict — I accept it and respond with a structurally-different final round
plus a hard pivot trigger, which is precisely the "one final round with the ordering-bug fix as an explicit
override" option the critic itself enumerated.

## Decision made — FBC fork (Open Q2)

- **Chosen:** one final direct-on-sections round (lane 1) **in parallel with** unblocking FBC-B (lane 2) and
  preparing the ModuleCat re-encoding as the documented iter-034 fallback. This is the strategy-critic's
  explicit recommendation (run the corrective AND the fork prep in parallel; unblock FBC-B now).
- **Why:** the never-executed inlining route is a ~1-iter bet with a genuinely better-than-prior chance
  (per the progress-critic's own caveat); FBC-B is high-value, fully independent of `_legs`, and de-risked
  (the effort-breaker located the Mathlib sheaf-condition API). Running both costs nothing on the FBC-B side
  and resolves the FBC-A question definitively this iter.
- **Cheapest reversal signal:** if the iter-033 FBC-A prover again reports the splice blocked by the diamond
  *after* inlining + cast-collapse, that is the disproof of "it was only an ordering bug" — iter-034 pivots
  to arm (a) without re-litigating.
- **Rejected:** arm (b) "accept the 4 sorries as deferred stubs + escalate" — forbidden by the standing
  directive. ModuleCat re-encoding THIS iter — premature before the cheap inlining route is tried.

## Prior critique status

- **strategy-critic `iter032` CHALLENGE (FBC) — ADDRESSED.** (a) Open Q2 already documents both arms; I made
  it a firm iter-034 cutover (no re-dating). (b) Stopped the "ordering, not a math wall" framing in
  STRATEGY (the Risk cell now says `X.Modules`-diamond splice). (c) FBC-B promoted from NEXT to an ACTIVE
  parallel split-out lane and dispatched THIS iter; the ModuleCat fork is the written iter-034 fallback.
- **strategy-critic `iter032` format NON-COMPLIANT — ADDRESSED.** Risk cells (FBC-A, FBC-B, GF-geo,
  QUOT-defs) shrunk to one short line; per-iter narrative kept out of STRATEGY (lives here).
- **strategy-critic `iter032` prerequisite note — ADDRESSED.** `isIso_fromTildeΓ_*` are project-side (not
  Mathlib) — the STRATEGY Mathlib-gaps bullet already says so. Stacks 01HA (keystone D) is UNVERIFIED against
  `references/summary.md`; recorded in the iter-034 ramp as "confirm the tag before blueprint-quoting D".
- **blueprint-reviewer `iter033` §M1 (FBC-B anchors) — ROUTED to the prover** (verify the 2 anchor names
  before coding; the directive flags it as blocking). §M2 (empty `\uses{}`) — FIXED by the plan agent.

## Subagent skips

- progress-critic: fresh `iter032` report already in hand this plan cycle (the interrupted iter-032 plan
  dispatched it); acting on its FBC **STUCK** verdict via the explicit rebuttal above. No new prover
  trajectory since — re-dispatch would be a hollow repeat.
- strategy-critic: fresh `iter032` report already in hand this plan cycle; the STRATEGY edits directly
  implement its named must-fix correctives (Open Q2 fork firmed, Risk cells shrunk, FBC-B parallelized). A
  re-review of edits that implement its own asks would be confirmatory; deferred to iter-034.

## Subagents this iter (this plan cycle)

- **blueprint-clean `iter033`** — purity pass on the 3 edited chapters: validated the 4 FBC-B 02KH source
  quotes verbatim against `references/stacks-coherent.tex`; stripped Lean-isms; trimmed the stale ~30-line
  cocycle prose in `def:gr_glued_scheme` (now covered by the new blocks).
- **blueprint-reviewer `iter033`** (whole, HARD GATE) — FBC-B / QUOT-P1 / GR-sep all PASS; FBC-B conditional
  on the prover verifying `isSheaf_iff_isSheafEqualizerProducts` + `tensorEqLocusEquiv`. 3 sync_leanok
  advisories on GR (handled deterministically next sync). 1 covers_problem (FlatBaseChangeGlobal.lean doesn't
  exist yet — expected; the prover creates it).
- (from the interrupted iter-032 cycle, consumed here) **progress-critic `iter032`**, **strategy-critic
  `iter032`**, **effort-breaker `fbcb`**, **blueprint-writer `gr-cov`**, **blueprint-writer `quot-cov`**.

## Dispatch sanity

4 files, all import-independent, within the cap of 10. Two scaffold dispatches (FBC-B new file, GR-sep new
decl) carry scaffold keywords to pass the no-op filter. Balanced load: 1 deep final round (FBC-A), 1 fresh
bottom-up build with a mechanical floor (FBC-B), 1 geometric transport (QUOT-P1), 1 deep scaffold (GR-sep).
