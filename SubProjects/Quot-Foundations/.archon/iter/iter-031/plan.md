# Iter 031 — Plan (Quot-Foundations)

## TL;DR

Processed the iter-030 prover round (FBC distribution wall passed inside the locked `_legs` goal via the
shipped `link_distributeCollapse`; QUOT +6 axiom-clean bridge-C topological layer; GR no-output for the 2nd
straight iter). The load-bearing finding this iter is the **GR no-output root cause**: it was never a math
wall — a 0-sorry file is silently DROPPED by the loop's no-op objective filter (`sorry_count.py`) unless
the objective text carries a scaffold keyword, and the prior GR objectives said "NEW-declaration build"
(which the filter's regex does NOT match). Two iters were wasted on a dispatch-wording bug. Fixed: the
iter-031 GR objective is re-worded with an explicit scaffold keyword (verified against the regex).

Re-dispatched all three import-independent lanes after the mandatory blueprint cycle:
- **FBC** [fine-grained]: blueprint reconciled (Path B — L1+L2 merged into the `link_distributeCollapse`
  block pinning the shipped Lean decl; L3/L4/L5 kept as forward-ref wrapper blocks with sharpened term-mode
  recipes). Prover builds the 3 remaining clean-term wrapper lemmas + assembles `_legs`.
- **QUOT** [mathlib-build]: 6 coverage blocks added + `lem:over_restrict_iso` expanded to the 4-step
  decomposition; prover builds step 2 (geometric ring-sheaf id) → 3 → 4 ⟹ `overRestrictIso`.
- **GR** [mathlib-build]: standalone `lem:gr_cocycle_phi_id` block added; prover scaffolds + proves
  `cocyclePhiId`, `theGlueData`, `Grassmannian.scheme`.

## State at entry (verified from iter-030 task_results + leandag + lean-vs-blueprint-checkers)

- **FBC** 4 sorries: `_legs` @1461 (distribution done inside locked goal; residual = factors 2&4 eCancel
  telescoping + survivor), `gstar_transpose` @1833 (gated), affine @2014, FBC-B @2036.
- **QUOT** 4 protected stubs + bridge-C step 1 DONE (`overEquivalence_sheafCongr` + 5 instances,
  axiom-clean). Next = bridge-C step 2 (geometric ring-sheaf identification).
- **GR** 0 sorries; targets (`cocyclePhiId`, `theGlueData`, `Grassmannian.scheme`) are NEW decls. cocycle
  categorical reduction solved (in-file HANDOFF); residual = the Φ=id ring identity.
- **GF** 1 sorry (geo, gated on gap1). Coverage debt: 7 unmatched `lean_aux` (1 FBC + 6 QUOT) — CLEARED.

## Subagents this iter (6; all returned)

- **progress-critic `iter031`** — FBC **STUCK** (sorry-count 4 for 3 rounds, OVER_BUDGET ~13×) but the
  R-031 fine-grained wrapper approach is "a validated continuation, not churn"; FIRM iter-032 escalation
  tripwire (do NOT re-date). QUOT **CONVERGING**. GR **CONVERGING (conditional)** — accepts the dispatch-bug
  diagnosis; if R-031 still no-outputs the diagnosis is wrong → STUCK. Dispatch sanity OK (3 files).
- **blueprint-writer `fbc-reconcile`** — Path-B merge of L1+L2 into the `link_distributeCollapse` block
  (pins the shipped axiom-clean decl); sharpened L3/L4/L5 wrappers to precise term-mode (whiskering)
  recipes; repointed every `\uses`/`\ref` — no `_link_distribute`/`_link_collapseComp` name remains.
- **blueprint-writer `quot-bridgeC`** — 6 over-site infra coverage blocks + 3 Mathlib anchors;
  `lem:over_restrict_iso` expanded to the 4-step decomposition with step 2 flagged as the current obstacle.
  All 6 project decls matched; `unknown_uses` = 0.
- **(plan-agent) GR blueprint edit** — added `lem:gr_cocycle_phi_id` (Φ=id ring identity), wired into
  `def:gr_glued_scheme`. (Did NOT use a writer — single small block.)
- **blueprint-clean `iter031`** — 7 purity fixes (QuotScheme 1, FlatBaseChange 6); GrassmannianCells clean.
- **blueprint-reviewer `iter031`** (whole, HARD GATE) — all 3 chapters complete+correct, GATE-CLEARED. One
  must-fix: `\minordet` macro undefined in the new GR block — FIXED (replaced with the chapter's existing
  `P^I_J` notation). Cross-cutting minor: `lem:annihilator_localization_eq_map` isolated (left as-is — see
  Decisions).
- **strategy-critic `iter031`** — CHALLENGE×2 + format-non-compliant (see `## Prior critique status`).

## Decision made

### FBC gets ONE final wrapper round this iter (despite STUCK) — then a hard fork at iter-032
- **Chosen:** dispatch the FBC fine-grained prover with the 3-wrapper decomposition; record the encoding
  fork as STRATEGY Open Q2 with a firm iter-032 trigger.
- **Why:** the progress-critic — whose job is to catch exactly this — explicitly classifies the R-031
  approach as a validated continuation, not churn (the mechanism advanced the sorry structurally each of the
  last 2 rounds, and the residual is now 3 small clean-term lemmas + one splice, each diamond-free by
  construction). The structural corrective this iter is real: the blueprint was reconciled (Path B) and the
  monolithic `exact` was decomposed into 3 testable wrappers — not a reworded re-dispatch of keyed
  rewriting. This honors the CHURNING/STUCK rule (a concrete structural change, not another identical lane).
- **Trade-off / reversal signal:** FBC is ~13 iters over a 2–3 estimate. The cheapest reversal signal is
  this round failing to close `_legs`. If it does fail, iter-032 does NOT re-date another wrapper round —
  it executes Open Q2: either re-encode the transport at `ModuleCat` level (strategy-critic's suggestion —
  confine the diamond to one step) or escalate to the user. TO_USER.md carries the boundary FYI.

### GR no-output is a dispatch-wording bug, not a math wall — fixed by wording
- The no-op filter (`sorry_count.py::filter_noop_objectives`) drops a 0-sorry file unless the objective line
  matches `scaffold|skeleton|leave bodies as|declarations? for|does not (yet) exist|stub out|add the
  import`. Prior GR objectives said "NEW-declaration build" → dropped silently (the repeated USER_HINTS
  plan-validate warnings were the same signal). iter-031 objective now contains "scaffold" + "do not yet
  exist". Recorded as a standing note in PROGRESS.md so future planners don't repeat it.

### `lem:annihilator_localization_eq_map` left intentionally isolated
- The reviewer suggested adding it to `def:modules_annihilator`'s `\uses`. But the def block carries a
  deliberate NOTE: the Lean construction (`IdealSheafData.ofIdeals …`) is well-defined unconditionally and
  does NOT depend on the localization bridge at definition time; the lemma is consumed only by the
  annihilator forward-direction characterization, which is "not yet a blueprint block." Forcing the edge
  would contradict the documented well-definedness. Decision: leave isolated; the edge appears when the
  consumer block is written. Non-gating.

## Prior critique status (strategy-critic iter-031 CHALLENGE×2 + format)
- **C1 — FBC estimate dishonest / re-encoding suggested.** ADDRESSED: STRATEGY FBC row trimmed to a terse
  honest cell (`1–2`, "far over budget; escalation/re-encoding fork pending (Open Q2)"); the ModuleCat
  re-encoding is recorded as Open Q2 with the iter-032 trigger. The fine-grained round this iter is the
  progress-critic-endorsed continuation; the re-encoding is the explicit fallback, not silently dropped.
- **C2 — `def:hilbert_polynomial` missing standard-graded hypothesis.** ADDRESSED as Open Q3: the
  Stacks-00K1 rationality engine needs `S₊` generated in degree 1; the def must carry a standard-graded /
  very-ample hypothesis (ample-only insufficient). Fenced — must verify the signature BEFORE any SNAP/S1
  prover. SNAP is gated (Open Q1), so no prover budget is spent on a possibly-false statement this iter.
- **gap1 decomposition** — strategy-critic CONFIRMED canonically correct (D = the real keystone; C is a
  SheafOfModules-site framework artifact, no extra math; verified no ready `ModuleCat R ≌ Qcoh(Spec R)`
  short-circuit exists). No change; minor note that gap1 could be scoped against the concrete Spec tilde
  development first — folded into the existing C→P1→D→assembly order.
- **Format non-compliance** — FIXED: stripped per-iter narrative (`iter-NNN`, `OVER_BUDGET 13×`, `do NOT
  re-date`) and multi-line prose from the Phases table; narrative lives here.

## Subagent skips
- (none — all three highly-recommended plan-phase subagents dispatched: progress-critic, blueprint-reviewer,
  strategy-critic. blueprint-clean + 2 blueprint-writers also dispatched.)

## Disproof / soundness pass
- No prover budget committed this iter to a statement at risk of being false. The one missing-hypothesis
  finding (Q3, `def:hilbert_polynomial`) is on a DEFERRED/gated lane — fenced before any prover, not
  formalized this iter. The three active targets (FBC `_legs` assembly, QUOT `overRestrictIso`, GR Φ=id)
  are all established mathematics with concrete in-file/Mathlib recipes.
