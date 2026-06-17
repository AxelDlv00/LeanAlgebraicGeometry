# Progress Critic Directive

## Slug
route171

## Iter
171

## Active routes / files under review

### Route: genus-0 rigidity — `gmScalingP1` body assembly (G0BO.lean Lane A)

- **Started at iter**: 165 (scaffold landed iter-165; body sorry untouched since then)
- **Iters audited**: 166–170

#### Sorry counts per iter (on Genus0BaseObjects.lean; total project = 14, 14, 14, 13, 13)
- iter-166: 11 (file)
- iter-167: 10 (file)
- iter-168: 9 (file) — `projectiveLineBarAffineCover` + `projectiveLineBar_isReduced` axiom-clean closures
- iter-169: 8 (file) — `ga_grpObj` + `ga_smooth` DELETED (-1 net)
- iter-170: 8 (file) — NET 0; prover lane DIED to API-500 with 0 edits

#### Helpers added per iter (on G0BO.lean)
- iter-166: 3 ℙ¹ k̄-points (`zeroPt`/`onePt`/`inftyPt`) + `morphism_P1_to_grpScheme_const` body via 𝔾_m-scaling
- iter-167: 4 Lane A exports axiom-clean + 3 honest-scaffold-sorry exports + 4 AVR aux closures
- iter-168: `projectiveLineBarAffineCover` + `projectiveLineBar_isReduced` (axiom-clean) + 5 ring-hom helpers + iso skeleton with `aux_left` residual
- iter-169: 4 hygiene refreshes + `ga_grpObj` deletion + 3 attempted routes to `gmScalingP1` body (Mathlib-blocked each)
- iter-170: 0 (API-500 killed lane before any edit)

#### Prover statuses per iter
- iter-166: COMPLETE — Lane 1 closed `morphism_P1_to_grpScheme_const` via 𝔾_m-scaling shortcut
- iter-167: COMPLETE — aux-pile discharge
- iter-168: PARTIAL — landed step 1+3 axiom-clean + step 2 partial (iso skeleton)
- iter-169: PARTIAL — three routes to body each hit Mathlib gap; `ga_grpObj` deletion
- iter-170: error (API-500); 0 file edits

#### Prover count per iter (files dispatched)
- iter-166: 2 (G0BO Lane 1 + Lane 2)
- iter-167: 1 (G0BO Lane A — aux-pile)
- iter-168: 1 (G0BO Lane A)
- iter-169: 1 (G0BO Lane A)
- iter-170: 1 (G0BO Lane A; AVR sorries all gated downstream)

#### Recurring blocker phrases
- "`gmScalingP1` body untouched" appears in iter-167/168/169/170 plans — 5 consecutive iters of zero body advancement (4 with prover attempts + 1 API-500).
- "Mathlib lacks ..." (variants: scheme-level divisors, relative-Proj base-change, GroupAction/scheme) appears in iter-169 prover report (three routes, three different missing pieces).
- "defer to iter-172" / "schedule next iter" — `gm_grpObj` (3-iter deferral), `projGm_isReduced` (gated), `iotaGm_isDominant` (gated on body), `genusZero_curve_iso_P1` (deferred to upstream).

#### Deferral language per iter (verbatim from planner sidecars)
- iter-167: "iter-168 escalation watch on `gm_grpObj` (now 3-iter deferred)"
- iter-168: "4th consecutive deferral triggers user-escalation iter-169"
- iter-169: "armed-trigger commitment: iter-170 fires option (a) if PARTIAL-no-body"
- iter-170: "iter-170 was the iter the iter-169 plan committed to user escalation — planner made the call (option c)"
- iter-170 review: "iter-171 must re-attempt the test before the reversal is in play"

#### Route status changes per iter
- iter-166: active (Lane 1+2)
- iter-167: active (single Lane A)
- iter-168: active (single Lane A)
- iter-169: active (single Lane A)
- iter-170: active (single Lane A) → API-error; reviewer recommends re-dispatch iter-171

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md row "genus-0 rigidity — `gmScalingP1` body"**: `~3–5` (iter-170 → iter-171 revision)
- **Elapsed iters in current phase**: 6 (iter-165 scaffold → iter-170 API-error)
- **Phase started at iter**: 165

#### Planner's current proposal for this iter
The planner proposes RE-DISPATCH iter-170 Lane A verbatim per reviewer recommendation (the body-first test never ran due to API-500; it must be re-attempted before the reversal trigger fires). PLUS three parallel plan-phase lanes (writers + refactor) addressing user-hint absorptions:
- blueprint-writer `route-a1-decompose` on `Jacobian.tex` (Route A.1 sub-phase prover-ready decomposition)
- blueprint-writer `rr-bridge-subbuild` on `AbelianVarietyRigidity.tex` or new chapter (RR-bridge 4-sub-phase in-tree decomposition)
- refactor `avr-split` on `AbelianVarietyRigidity.lean` (split 1198 LOC into 2 files)

### Route: Route A — Picard scheme / Albanese via FGA (Jacobian.lean L344 `positiveGenusWitness`)

- **Started at iter**: pre-iter-100 (long-standing committed route)
- **Iters audited**: 166–170

#### Sorry counts per iter (Jacobian.lean total)
- iter-166: 2 (unchanged)
- iter-167: 2 (unchanged)
- iter-168: 2 (unchanged)
- iter-169: 2 (unchanged)
- iter-170: 2 (unchanged)

#### Helpers added per iter
- iter-166: 0
- iter-167: 0
- iter-168: 0
- iter-169: 0
- iter-170: 0 Lean-side; blueprint-side iter-170 landed per-sub-phase LOC/iter budget + Mathlib-prerequisite cascade in `Jacobian.tex` L347-L432 via blueprint-writer `jacobian-routeA170`.

#### Prover statuses per iter
- iter-166 through iter-170: NEVER DISPATCHED (Route A has had 0 prover lanes across the 5-iter window).

#### Prover count per iter (Route A files dispatched)
- All 5 iters: 0

#### Recurring blocker phrases
- "deferred to a future writer-pass" / "blueprint sketch-level" / "after the genus-0 stack" / "off-critical-path" — Route A status across all 5 iters.
- iter-170 strategy-critic flagged: "infrastructure-deferral inside Route A" + "parallelism under-exploited."

#### Deferral language per iter
- All 5 iters: variants of "Route A scaffolding entry — schedule for a future iter once the genus-0 stack stabilizes" / "deferred to future iters" / "Route A is the dominant cost — schedule after genus-0".

#### Route status changes per iter
- iter-166 through iter-170: continuously "active critical path" in STRATEGY.md but "deferred to future iter" in PROGRESS.md. 5 consecutive iters of deferral.

#### Strategy estimate vs reality
- **`Iters left` from updated STRATEGY.md row "Route A.1"**: `~6–10` (4-row split this iter; previous `~33–54` was for the unsplit Route A)
- **Elapsed iters in current phase**: 5+ iters of deferral with 0 prover dispatch
- **Phase started at iter**: ?? (deferred throughout the audit window; no active phase)

#### Planner's current proposal for this iter
This iter's STRATEGY.md update splits Route A into 4 rows (A.1/A.2/A.3/A.4); blueprint-writer `route-a1-decompose` is dispatched to produce prover-ready sub-chapters for A.1; iter-172+ opens parallel file-skeleton lanes (e.g. `Picard/RelativeSpec.lean`).

### Route: genus-0 RR bridge — `genusZero_curve_iso_P1` (AVR L1141)

- **Started at iter**: pre-iter-100 (long-standing deferred item)
- **Iters audited**: 166–170

#### Sorry counts: 1 (AVR L1141) — unchanged across all 5 iters

#### Helpers added per iter: 0 Lean-side
#### Prover statuses: NEVER DISPATCHED (all 5 iters)
#### Prover count: 0 (all 5 iters)
#### Recurring blocker: "deferred to upstream Mathlib" (5 consecutive iters)
#### Strategy estimate: previously `~3–6` iters with `0/it` velocity; iter-171 STRATEGY revises to in-tree sub-build commitment (`~12–20` iters / 4 sub-phases)
#### Planner's proposal: blueprint-writer `rr-bridge-subbuild` to decompose the RR bridge per `analogies/rrbridge-survey.md` option (1).

## PROGRESS.md proposal (this iter)

- **File count**: 1 (Lane A on `AlgebraicJacobian/Genus0BaseObjects.lean`)
- **Files**: `Genus0BaseObjects.lean` (re-attempt iter-170 Lane A verbatim)
- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**: AVR L934 `iotaGm_isDominant` (gated on body landing); AVR L1141 `genusZero_curve_iso_P1` (RR bridge in-tree sub-build now committed but file-skeleton + first sub-phase prover-ready chapter not yet landed this iter); `Jacobian.lean` `positiveGenusWitness` (Route A — same gating story); `Jacobian.lean` `genusZeroWitness` (gated on AVR axiom-clean). **None CURRENTLY ready as standalone prover lanes**: the gated AVR sorries cannot close in iter-171 (body landing prerequisite), and the new sub-build files have to wait for blueprint-writer outputs to clear the HARD GATE.
- **Dispatch cap (from --max-objectives)**: 10

## Out of scope

Lane B on AVR's `iotaGm_isDominant` (gated on `gmScalingP1` body landing concrete); `genusZero_curve_iso_P1` body (deferred until RR sub-build chapters clear HARD GATE — at earliest iter-172); Route A files (need blueprint-writer output first then file-skeleton iter-172).
