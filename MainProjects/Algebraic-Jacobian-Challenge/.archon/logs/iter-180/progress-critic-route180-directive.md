# progress-critic directive — slug `route180`

## Active routes for iter-180

Read only the signals below. Do NOT read STRATEGY.md, blueprint chapters,
or full iter sidecars.

K = 5 iters (iter-175 → iter-179 inclusive).

### Route 1 — Genus-0 chart-bridge body retirement (`Genus0BaseObjects/GmScaling.lean`)

| Iter | Sorry-count (file) | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| 175 | 5 (pre-axiom) | 1 (`congrHom` restructure helper bypassed analogist) | PARTIAL — prover bypassed analogist's verified recipe | "session-limit reset window" (8 of 10 lanes dropped) |
| 176 | 5 | 0 | PARTIAL — Steps 1-4 land; Step 5+ stuck on cover-vs-Proj.awayι syntactic mismatch | "second syntactic mismatch surfaced after consult option (a) verified" |
| 177 | 2 (+2 TEMP axioms) | 0 | HARD STOP corrective fired — 2 TEMP axioms admitted | "iter-176 HARD STOP trigger" |
| 178 | 2 (+2 TEMP axioms) | 0 | PARTIAL+DEAD-END on AVR sibling lane (iotaGm_isDominant) — `IsOpenImmersion.isDominant _` recipe dead-end | "directive recipe dead-end" |
| 179 | 3 (+2 TEMP axioms) | 0 | PARTIAL — reversal trigger fired; 4/6 recipe steps land; `pullbackSpecIso_hom_base` stuck on `Algebra.compHom` instance synthesis heartbeat sink | "Algebra.compHom-based instance is a heartbeat sink under erw" |

Strategy `Iters left` (per STRATEGY.md row): **1** ("axiom-laundered;
kernel-only contract VIOLATED until retired — Trigger: iter-181
RETIRE-OR-ESCALATE")

Entered current phase at: iter-177 (axiom admission).

### Route 2 — `Picard/RelativeSpec.lean` body fills

| Iter | Sorry-count (file) | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| 175 | 0 (placeholder body `RelativeSpec _𝒜 := X`) | 0 | (file not touched) | — |
| 176 | 0 (placeholder body still) | 0 | flagged CRITICAL placeholder-laundering by auditor-176 | "structural elimination, not encoding" |
| 177 | 0 (placeholder body still) | 0 | (file not touched this iter) | — |
| 178 | 0 (placeholder body still) | 0 | consult dispatched; recipe at `analogies/relative-spec-encoding.md` | — |
| 179 | 2 (post-refactor placeholder retired; `base_change` via 2 named helpers) | 2 | SUCCESS — 2/3 sorries closed kernel-clean, 1 via 2 substantive named helpers (no laundering) | "Coequifibered.pullback Mathlib gap" |

Strategy `Iters left`: **~6-10** (`RelativeSpec`).

Entered current phase at: iter-179 (placeholder retirement).

### Route 3 — RR bridge chain (`RiemannRoch/`)

#### 3a — RR.1 WeilDivisor (`RiemannRoch/WeilDivisor.lean`)

| Iter | Sorry-count (file) | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| 175 | (skel +N) | — | file-skeleton landed | — |
| 176 | 3 | 1 | partial | — |
| 177 | 2 (`-1`) | 1 (rationalMap_order_finite_support) | SUCCESS — `principal` + `principal_hom` axiom-clean | — |
| 178 | 2 | 0 | PARTIAL — `principal_degree_zero` constant branch closed axiom-clean; non-constant gated on RR.4 | "Hartshorne II.6.9 multiplicativity gap" |
| 179 | 2 | 0 | (file deferred) | — |

#### 3b — RR.4 RationalCurveIso (`RiemannRoch/RationalCurveIso.lean`)

| Iter | Sorry-count (file) | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| 175 | (skel +N) | — | file-skeleton landed | — |
| 176 | 3 | 0 | (file deferred) | — |
| 177 | 3 | 0 | (file deferred) | — |
| 178 | 3 (Part A sig fix, Part B PARTIAL) | 0 | PARTIAL+SUCCESS — Part A sig fix; Part B excuse-comment confessing missing hypothesis | "auditor 178A excuse-comment / weakened-wrong" |
| 179 | 2 (`-1`) | 0 | SUCCESS — sig tightened (auditor 178A resolved); Pin 1 closed kernel-clean | — |

#### 3c — Thm32 (`Albanese/Thm32RationalMapExtension.lean`)

| Iter | Sorry-count (file) | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| 175 | 1 | — | file-skeleton; untouched | — |
| 176 | 1 | — | untouched | — |
| 177 | 1 | — | untouched | — |
| 178 | 1 | — | untouched (4-iter inaction streak) | "STUCK by inaction" |
| 179 | 1 | 1 (av_isIntegral_and_codimOneFree) | PARTIAL — body landed; helper consolidates 2 Mathlib gaps | "Smooth ⟹ IsReduced Mathlib gap" |

#### 3d — RRFormula (`RiemannRoch/RRFormula.lean`)

| Iter | Sorry-count (file) | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| 175 | (skel) | — | file-skeleton | — |
| 176-179 | 3 | 0 | (file deferred all 4 iters) | "STUCK by inaction" |

#### 3e — OCofP (`RiemannRoch/OCofP.lean`)

| Iter | Sorry-count (file) | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| 175 | (skel) | — | file-skeleton | — |
| 176 | 4 | 1 | partial advance | — |
| 177 | 5 (`+1` from auditor must-fix `True` placeholder fix) | 1 | PARTIAL build broken by Lane WD signature race | "signature-mutating lane race" |
| 178 | 5 (build restored) | 0 | SUCCESS — FIX-BUILD 1-LOC instance threading | "iter-177 race fix" |
| 179 | 5 | 0 | (file deferred) | "STUCK by inaction" |

### Route 4 — Albanese chain

#### 4a — AuslanderBuchsbaum (`Albanese/AuslanderBuchsbaum.lean`)

| Iter | Sorry-count (file) | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| 175 | 6 | — | file-skeleton | — |
| 176-177 | 6 | 0 | (file deferred) | — |
| 178 | 5 (`-1`) | 0 | SUCCESS — `projectiveDimension` kernel-clean re-export | — |
| 179 | 5 | 0 | SUCCESS+PARTIAL — auditor 178C docstring fix; depth re-export STRETCH PARTIAL (Mathlib gap documented) | "Module.depth Mathlib gap" |

#### 4b — CodimOneExtension (`Albanese/CodimOneExtension.lean`)

| Iter | Sorry-count (file) | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| 175 | (skel) | — | file-skeleton landed iter-177 | — |
| 176 | 4 | 0 | — | — |
| 177 | 4 | 0 | (file-skeleton landed; 2/6 pins concrete) | — |
| 178 | 3 (`-1`) | 0 | PARTIAL+SUCCESS — `extend_iff_order_nonneg` closed kernel-clean (but shallow per auditor 178B) | "auditor 178B shallow body" |
| 179 | 3 | 0 | PARTIAL+SUCCESS (Path D2) — rename + binder drop + docstring demotion + structural advance | "Mathlib gap: smooth ⟹ regular-local-ring" |

#### 4c — AlbaneseUP (`Albanese/AlbaneseUP.lean`)

| Iter | Sorry-count (file) | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| 177 | 7 (new file-skeleton) | — | SUCCESS — skeleton landed | — |
| 178-179 | 7 | 0 | (file deferred) | "gated on Sym^g substrate / A.4.a CodimOne / A.3" |

### Route 5 — Points.gm_grpObj (`Genus0BaseObjects/Points.lean`)

| Iter | Sorry-count (file) | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| 169-179 | 1 | 0 | (11-iter persistent deferral) | "deferral pattern" |
| 179 | 1 | 0 | analogist consult `gm-grpobj-representable` dispatched; 8-step recipe at `analogies/gm-grpobj-representable.md` | "recipe ready for iter-180" |

Strategy `Iters left`: not in STRATEGY.md per-row (Mathlib-gap, not phase).

Entered current phase: iter-168 (per KB memory note).

### Route 6 — QuotScheme (`Picard/QuotScheme.lean`)

| Iter | Sorry-count (file) | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| 178 | 6 | 1 | STRETCH PARTIAL — structural one-liner + 1 named helper carrying Stacks 02KH(ii) | — |
| 179 | 6 | 0 | (file deferred) | "iter-180+ helper body target" |

## Planner's PROGRESS.md `## Current Objectives` proposal for iter-180

(File count, basenames only — for dispatch-sanity check.)

Likely 5–7 lanes:

1. `Genus0BaseObjects/GmScaling.lean` — chart-bridge wrapper consumption + axiom retirement (after plan-phase `refactor pullback-spec-iso-wrapper`).
2. `Genus0BaseObjects/Points.lean` — gm_grpObj body via 8-step recipe.
3. `RiemannRoch/OCofP.lean` — smallest body sorry first (`globalSections_iff` or `lineBundleAtClosedPoint`).
4. `RiemannRoch/RRFormula.lean` — `l_eq_degree_plus_one_of_genus_zero` (smallest).
5. `Picard/QuotScheme.lean` — `canonicalBaseChangeMap_app_app_isIso` helper body.
6. (possibly) `AbelianVarietyRigidity.lean` — `iotaGm_isDominant` resumed if Lane A closes.

## What to assess

Per route: CONVERGING / CHURNING / STUCK / UNCLEAR plus per-CHURNING/STUCK
finding, the corrective TYPE you recommend (blueprint expansion,
Mathlib-idiom consult, structural refactor, route pivot, etc.).

Also:
- Dispatch-cap sanity (planner proposing 5–7; cap is ~10).
- Any UNDER_DISPATCH signal on persistently-deferred files (OCofP 4 iters
  deferred; RRFormula 4 iters deferred; QuotScheme 2 iters deferred;
  AlbaneseUP 2 iters deferred).
- Any HELPER-CHURN signal on Route 1 (Lane A has been adding/removing
  bodies for 5 iters without retiring the axioms).

Report verdicts per route. Recommend correctives by TYPE only — the
plan agent will pick the subagent that matches.
