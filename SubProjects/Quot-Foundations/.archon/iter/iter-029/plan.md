# Iter 029 — Plan (Quot-Foundations)

## TL;DR

Processed the iter-028 prover round (FBC 5→4; QUOT G1-core reduced to a single gap1 lemma; GR `cocycle`
reduced to a ring identity). The load-bearing call was the **FBC CHURNING corrective**: the iter-028
tripwire named a mathlib-analogist consult, which I executed — and it returned a strong result, the GR
term-mode recipe **ports directly to the FBC `X.Modules`/`Functor.map` setting, with 3 compiling in-file
precedents** (`pullbackPushforward_unit_comp`, `gammaDistribute`, `eCancel_pushforwardComp`). That is a
genuinely new proof mechanism (term-mode `congrArg`/`Functor.congr_map`/`.trans`/`exact` splicing the
SHIPPED eCancel atoms; abandon `hpfc`), so FBC gets a prover THIS iter — the corrective applied, not a
reworded re-dispatch. Re-dispatched all three import-independent lanes after a full blueprint cycle
(3 writers → clean → whole re-review, all GATE-CLEARED via the sanctioned same-iter fast path).

## State at entry (verified from iter-028 task_results + leandag)

- **FBC** 4 sorries: `_legs` @1445 (root crux, diamond-blocked), `gstar_transpose` @1817 (gated on
  `_legs`, same diamond), affine @1995, FBC-B @2017. Seams B/C closed; `inner_value_eq` closed via cascade.
- **QUOT** 4 protected stubs. G1-core ≡ gap1 ≡ `isIso_fromTildeΓ_of_isQuasicoherent` (the iff + 3-field
  engine in-file). +2 axiom-clean helpers this round. Sub-build `exists_isIso_fromTildeΓ_basicOpen_cover`
  handed off.
- **GR** 0 sorries. `t'`/`t_fac`/ring-identity landed; `cocycle` reduced to the ring identity `Φ=id`.
- **GF** 1 sorry (geo, gated on gap1).
- Coverage debt: 6 unmatched `lean_aux` (2 QUOT + 4 GR iter-028 helpers).

## Subagents this iter (8; all returned)

- **progress-critic `iter029`** — FBC **CHURNING** (PARTIAL×3, net 0.33/round, OVER_BUDGET; entered
  iter-018, est 2–4, 10+ elapsed) but the iter-029 plan is "the right structural response, not avoidance."
  Must-fix: (1) gate FBC prover on the analogist output (satisfied — consult returned before dispatch),
  (2) revise FBC-A estimate (done). QUOT **UNCLEAR** (2 rounds, structurally narrowing; watch iter-030 —
  must attack the sub-build directly). GR **CONVERGING**. Dispatch sanity OK (3 files).
- **mathlib-analogist `fbc-diamond`** (cross-domain) — the GR `exact congrArg`/defeq-inside-`exact` recipe
  **ports directly**; 3 in-file precedents over `X.Modules`. Mechanism = `congrArg`/`Functor.congr_map`,
  `.trans`-chained, `exact`-closed; abandon `hpfc`, splice the SHIPPED atoms. `analogies/fbc-functorimage-diamond.md`.
- **strategy-critic `iter029`** — CHALLENGE×2 + DRIFT (see `## Prior critique status`).
- **blueprint-writer `fbc-diamond`** — folded the diamond mechanism into `inner_eCancel_assemble` +
  `gstar_transpose` (the 2 iter-028 must-fix), removed the phantom `base_change_regroup_linearEquiv` ref.
- **blueprint-writer `quot-gap1`** — G1-core → corollary of gap1; gap1 elevated + split into
  `lem:exists_isIso_fromTildeΓ_basicOpen_cover` + Mayer–Vietoris; 2 coverage blocks + `\mathlibok` anchor.
- **blueprint-writer `gr-glue`** — 4 coverage blocks + `def:gr_glued_scheme` expanded (cocycle `Φ=id` +
  GlueData assembly + partial-state NOTE).
- **blueprint-clean `iter029`** — removed 4 orphaned Route-F `\mathlibok` anchors; 0 isolated nodes.
- **blueprint-reviewer `iter029`** (whole, HARD-GATE) — all three chapters **complete+correct, 0 must-fix,
  GATE-CLEARED**; leandag 0 isolated, 0 broken refs.

## Decision made

### FBC gets a prover THIS iter despite CHURNING — because the corrective produced a NEW mechanism
- **Option chosen:** execute the mathlib-analogist consult (the named corrective), then dispatch the FBC
  prover this iter with the analogist's term-mode mechanism.
- **Why:** the failure mode the CHURNING gate guards against is re-dispatching with cosmetic recipe
  variation. The analogist's output is the opposite — a structurally different proof mechanism (term-mode
  `congrArg`/`.trans`/`exact` vs the `rw`/`simp`/`erw` that the diamond defeats), VERIFIED by 3 compiling
  in-file precedents. The progress-critic explicitly endorsed this: "the iter-029 plan is the right
  structural response and does not itself constitute an avoidance pattern," with the sole hard gate being
  "FBC prover dispatched AFTER the consult returns" — which it was.
- **Trade-off:** if the assembly is large, the prover may land a partial `.trans` chain rather than fully
  closing; that is acceptable progress (each link is independently checked). Reversal signal: if the
  prover reports the term-mode mechanism ALSO fails to fire (not just "ran out of budget mid-chain"), the
  diamond is deeper than diagnosed → next iter escalate to an effort-breaker splitting `_legs` into
  per-atom sub-lemmas. The 3 in-file precedents make this unlikely.

### FBC Q2 (canonical-iso vs ∃-iso) resolved by the frozen signature — no parent-repo read needed
- Both FBC targets are signed `IsIso (pushforwardBaseChangeMap …)` (verified in-file @1964/2004) — IsIso
  of the CANONICAL base-change map. The `regroupEquiv`-only shortcut proves a weaker ∃-iso statement that
  does NOT discharge `IsIso (pushforwardBaseChangeMap …)`. So the gstar Seam-3 chain IS required; Open Q2
  is closed and removed from STRATEGY.

## Prior critique status (strategy-critic `iter029` — CHALLENGE×2 + DRIFT, ALL ADDRESSED)

- **FBC CHALLENGE (sunk-cost: revised estimate DOWN, Q2 unscheduled):** ADDRESSED. Q2 resolved by the
  frozen `IsIso(pushforwardBaseChangeMap)` signature (in-repo, no parent read) — gstar required. Estimate
  set to 1–3 (not 1–2): basis is the concrete mechanism + 3 in-file precedents, not optimism; risk note
  kept.
- **QUOT CHALLENGE (SNAP behind two unscheduled prerequisites, no sub-build/timeline):** ADDRESSED.
  STRATEGY Open Q1 now states a concrete decision + trigger: defer the (a)/(b) route pick until gap1
  lands (higher leverage), then dispatch a reference-retriever for the Serre `m≫0` agreement (verify the
  "Hartshorne II.5.17" attribution) and decide; `def:sectionGradedRing` tensor-powers sub-build noted as
  a separate owed prerequisite. SNAP row → BLOCKED.
- **Format DRIFTED (17.4 KB > 12 KB; per-iter narrative in table/Routes):** ADDRESSED — rewrote STRATEGY
  to 11.9 KB; stripped iter numbers / "this iter" / OVER_BUDGET from cells and Routes.
- **Prerequisite: `LocallyOfFiniteType.finiteType_appLE` MISSING:** ADDRESSED — re-anchored to
  `HasRingHomProperty.appLE` in the GF-geo row (tagged `[gap]` in PROGRESS). gap1 reduction confirmed a
  legitimate decomposition (no REJECT).

## Dispatch (PROGRESS.md `## Current Objectives`)

3 import-independent prover lanes: FBC (`prove`, term-mode mechanism) · QUOT (`mathlib-build`, gap1
sub-build) · GR (`mathlib-build`, cocycle + glued scheme). All HARD-GATE clear.

## Tool substitutions
None. (No LLM API key in env — `archon-informal-agent.py` unavailable; used the mathlib-analogist subagent
instead, which is the correct in-catalog substitute for the diamond consult.)
