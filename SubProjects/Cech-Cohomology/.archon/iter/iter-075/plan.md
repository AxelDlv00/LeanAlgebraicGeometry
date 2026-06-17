# iter-075 plan — CSI route to ONE leaf; HARD GATE cleared via fast-path; 1 lane dispatched

## Situation
- iter-074 closed 2 sorries (CSI route 2→1): `sectionCechAugV_π` (CSI, axiom-clean) +
  `backboneIncl_proj` (Leg, sync_leanok-verified +19 `\leanok`). iter-074 STUCK-watch resolved POSITIVELY.
- Reconciled actual state: CSI=0-sorry, Base=0-sorry, **Leg=1 real sorry** (`pushPull_interLegHom_sections`
  @1003 — `coreIso_comm_leg` was restructured to reduce to this extracted leaf). Project term-sorries:
  this leaf + `CechAugmentedResolution:229` (consumes CSI) + frozen `CechHigherDirectImage:780`.
- iter-074 review's ONE must-fix = blueprint **silent on `pushPull_interLegHom_sections`** → HARD GATE
  blocked a Leg prover. The full 5-step route already exists in `task_results/…Leg.lean.md` (Steps 0–3′
  scratch-compiled green).

## Actions this phase
- blueprint-writer `pushpull-interleg`: authored `lem:pushPull_interLegHom_sections` (4-step a–d) +
  `lem:pushPull_leg_coherence`, `lem:backboneIncl_proj`, `lem:backboneIncl_nerveδ`, `lem:coreIso_objIso_π`;
  bundled 12 public helpers; wired all 4 into `coreIso_comm_leg`'s proof `\uses`; removed broken private
  `abHom_finsetSum_apply` pin. leandag clean (unknown_uses=[], no new isolated).
- blueprint-clean `iter075`: 2 purity edits (stripped "five"/"finitary pre-extensive"/"whiskered" jargon;
  `eqToHom`→"canonical equality isomorphism").
- **blueprint-reviewer `fastpath-csi-iter075` = HARD GATE SATISFIED** — `lem:pushPull_interLegHom_sections`
  adequate for a prover; 4 supporting blocks complete+correct; only a cosmetic soon-finding (private pin
  on `pushPull_leg_coherence` → no `\leanok`, harmless). ⟹ Leg file may enter objectives.
- progress-critic `iter075` = **CONVERGING** (1 route, 0 churn/stuck, dispatch=OK).
- Updated task_done (2 closes), task_pending top block (iter-075), STRATEGY P5a residual cell (2→1 leaf),
  PROGRESS (1 lane).

## Decision made
- **ONE focused lane (`CechSectionIdentificationLeg.lean`), not parallel.** `hSec` (CechAug:229) and P5b
  are genuinely BLOCKED on this leaf (sorryAx-tainted until CSI sorry-free) — not parallelism opportunities,
  blocked deps. The EnoughInjectives connector is speculative P5b-prereq work with no scaffold/file yet;
  adding it now risks scope creep off the single critical path. Trade-off: forgo parallelism for focus on
  the whole project's bottleneck. Cheapest reversal signal: if this leaf closes early, next iter opens
  `hSec` + connector as parallel lanes.
- **`prove` mode, not fine-grained:** the route is concrete and scratch-compiled (Steps 0–3′ green); only
  Step-4 transcription remains. fine-grained is reserved for the STUCK-watch escalation if it stalls.

## Subagent skips
- strategy-critic: STRATEGY.md route + decomposition UNCHANGED (only a within-phase residual-cell refresh,
  2 leaves→1); prior verdict SOUND, no live CHALLENGE. Re-blessing the identical route is the hollow-dispatch
  failure mode.
