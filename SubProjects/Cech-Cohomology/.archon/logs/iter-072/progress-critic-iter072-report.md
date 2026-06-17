# Progress Critic: iter072
**Iter:** 072

## Routes

- **`CechSectionIdentification.lean`**: CHURNING (by mechanical PARTIAL×5 rule + net-zero sorry over 5 informative iters).
  - Sorry trajectory: 2→2→2→3→2 across iters 063–067 (informative window). Net = 0 over 5 iters. Iter-067 progress was real (2 chain lemmas + `hcompat` closed) but sorry count returned to 2 after the iter-066 +1 split, so the window reads flat.
  - Helpers added: iter-066 (+3 augmentation helpers, no net closure); iter-067 (+6 decls, closed `hcompat`+2 chain lemmas, but sorry count net 2). Helper accumulation is paying off locally but the residual has not shrunk below 2 in any iter.
  - Recurring blocker: `coreIso_comm` sum-bookkeeping — named (or avoided) in both iter-066 AND iter-067; 2 consecutive appearances = STUCK sub-pattern on this one lemma.
  - Infrastructure note: iters 068–071 = 4 consecutive zero-edit rounds (3 outage casualties + 1 stale-objectives run). These are excluded as infrastructure failures per directive; they do NOT contribute to the avoidance-churn count. Without them the 5×PARTIAL sequence is the only mechanical trigger.
  - Corrective: **Blueprint expansion** — specifically the effort-break of `coreIso_comm` into (a) per-coface naturality sub-lemma and (b) elementwise sum-bookkeeping identity. This corrective was already prescribed last iter and is stated to be dispatched THIS plan phase (iter-072) before the prover. That is the correct action; the CHURNING verdict stands by rule but the corrective is being executed.

## Dispatch Sanity

- **Verdict**: OK. 1 file dispatched / 1 file active (no under-dispatch; sole route = CSI). Effort-break dispatched before prover as required.

## Must-fix-this-iter

- Route `CechSectionIdentification.lean`: CHURNING — blueprint effort-break of `coreIso_comm` MUST land (per-coface sub-lemma + sum-bookkeeping identity) before the prover is dispatched. Planner states this is underway; confirm sub-lemmas appear in blueprint before closing plan phase.

## Overall

- 1 route CHURNING (mechanical PARTIAL×5 + flat sorry), corrective (blueprint expansion of `coreIso_comm`) actively underway, dispatch OK; if effort-break lands this plan phase trajectory should converge in 1–2 prover iters.
