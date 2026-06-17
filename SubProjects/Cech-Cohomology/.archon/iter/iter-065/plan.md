# Iter-065 plan — the iter-064 decompose+mode-switch corrective CONVERTED both routes (first real closures); this iter = the targeted single-leaf `prove` dispatch the iter-064 review recommended, after clearing one blueprint-adequacy gate item via fast-path

## Entering state (verified from iter-064 prover results + iter-064 review subagents)
- iter-064 ran 2 FINE-GRAINED lanes (the progress-critic-prescribed decompose+mode-switch corrective). **The
  corrective CONVERTED both routes** — first real closures in each chain. sorry 9→12 is the *deliberate* cost of
  cracking 2 opaque monoliths into tractable leaves (lean-auditor iter-064: 0 must-fix, all 12 holes honest).
  - **CSI (sorry 5→4):** CLOSED the substantive Option-step `coprodToProd_isIso_option`. Residual = 2 named
    induction leaves — `pushPull_coprod_prod_empty` (983, `IsZero` over the empty/initial scheme) +
    `coprodToProd_isIso_of_equiv` (999, whiskerEquiv reindex). Both close Stub 2.
  - **OpenImm (sorry 2→5 by decomposition):** decomposed `case hqc` into 4 typed leaves, CLOSED 2 sub-lemmas +
    the `leftAdjointUniq` half of `pushforwardSlicePullbackIso`; `_acyclic` body now sorry-free; upper chain
    compiles. Residual collapses to ONE keystone φ'' (607); H₁/H₂/pullbackIso (649/660/692) fall once φ'' concrete.
- iter-064 review subagents: lean-auditor 0 must-fix / 1 major (the `case hqc` "in full" comment); **lvb-csi 4
  must-fix** of which the load-bearing one is the blueprint-adequacy gap on `coprodToProd_isIso_of_equiv` (one
  sentence, no Lean tools — left its leaf an un-formalizable full sorry); lvb-openimm 0 must-fix (3 stale-NOTE
  + 1 minor φ'' under-spec, advisory).

## What I did this phase
1. **progress-critic `iter065`** (dispatched first, after collecting prover results): **BOTH routes CHURNING but
   the iter-064 corrective CONVERTED them** (first sorry-elimination in each chain). Critically, the critic
   EXPLICITLY confirms "the proposed targeted dispatch on the 2 named leaves / on φ'' IS the correct corrective
   and is already adopted" — i.e. my proposed targeted single-leaf `prove` move is the right action, NOT a bare
   re-dispatch. Must-fix: revise STRATEGY `Iters left` (both OVER_BUDGET, ~11 elapsed vs ~2–4 est) — DONE. Route
   B caveat: a one-iter bet on φ'' — recorded the STUCK-WATCH contingency (effort-break / mathlib-analogist).
2. **HARD GATE clearance (fast-path, same iter):** the lvb-csi must-fix (`coprodToProd_isIso_of_equiv`
   under-specified) gates the CSI lane.
   - **blueprint-writer `gate065`:** added dedicated `lem:coprodToProd_isIso_of_equiv` (full formalizable proof:
     source/target reindexing isos + projection chase + IH) + `def:coprodOverIncl`/`def:coprodToProdMap` framing +
     `lem:coprodToProd_isIso_option` block + realigned `pushPull_coprod_prod_empty` proof to the `IsZero`-over-
     empty-scheme route + expanded φ'' part (a) `sheafPushforwardContinuousComp'` / part (b) object-relabel iso.
     0 broken `\uses`; no strategy-modifying findings. (Task 4a: the 3 OpenImm NOTEs were already accurate BUILT
     annotations — no edit.)
   - **blueprint-clean `iter065`:** 2 minor notation fixes (`Sigma.ι`→`\iota_i`, `Pi.π`→`\pi_i`).
   - **blueprint-reviewer `rescope065` (fast-path scoped):** **HARD GATE CLEARS** — `correct: true`, 0 must-fix;
     all 4 changed blocks adequate; coverage wired (no isolated nodes). 2 non-blocking "soon" items → review
     housekeeping (orphan `lem:pullbackObjUnitToUnit_mathlib`; `\mathlibok` on `sheafPushforwardContinuousComp'`).
3. Updated STRATEGY (both rows: OVER_BUDGET, Iters-left revised, current keystone-leaf state, STUCK-WATCH on φ''),
   PROGRESS (iter-065 context + decisions + 2 `prove` objectives + Next-iter plan), task_done (iter-064 entry),
   task_pending (iter-065 status), this sidecar, objectives.md, TO_USER. Cleared the 2 processed prover result files.

## Decision made — D1: targeted single-leaf `prove` dispatch on both routes THIS iter (NOT another decompose pass, NOT mathlib-build)
- **Why:** both routes are now ONE precisely-specified keystone leaf from cascading closure (CSI: 2 leaves →
  Stub 2/4; OpenImm: φ'' → cascade → `_acyclic`). The iter-064 decomposition already cracked the monoliths; the
  remaining work is closing specific sorries with established recipes — exactly `prove` mode's job (NOT
  fine-grained: no further decomposition needed; NOT mathlib-build: the recipes exist, per the mode notes).
- **Mode choice:** `prove` (default) for both. The CSI empty-scheme `IsZero` is a small inline infra build the
  `prove` prover does as part of closing the leaf; the reindex leaf is mechanical bookkeeping; φ'' part (b) is a
  ~40–80 LOC object-relabel iso with a precise recipe.
- **Not churning:** the progress-critic confirmed this is the correct adopted corrective. The concrete structural
  action distinguishing this from a bare re-dispatch: (a) the blueprint-writer this iter filled the genuine
  adequacy gap that left the reindex leaf un-formalizable, and (b) the mode is `prove`-on-isolated-leaves, a
  different regime from iter-064's decompose+fine-grained.
- **Reversal signal:** if φ'' part (b) (Route B) comes back open, do NOT re-dispatch whole — effort-break part (b)
  or mathlib-analogist the relabel pattern (recorded in Next-iter plan + STRATEGY). Same for any stalled CSI leaf.

## Subagent skips
- **strategy-critic:** strategy substance UNCHANGED — same Route A, same two converging lanes on the same
  precisely-specified keystone leaves; no route swap, no decomposition revision, no new strategic fork. The only
  STRATEGY edit this iter was the progress-critic-mandated `Iters left` estimate revision (OVER_BUDGET), which is
  a calibration update, not a soundness change. The strategy is well-validated (Route A, many completed phases);
  the open questions (Need#1, EnoughInjectives connector) are RESOLVED/tracked. Re-running a fresh-context
  soundness critic on an unchanged, converging strategy would be a hollow dispatch.
