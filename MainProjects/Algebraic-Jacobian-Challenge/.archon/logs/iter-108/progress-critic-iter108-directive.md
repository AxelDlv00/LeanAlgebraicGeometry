# Progress Critic Directive

## Slug
iter108

## Iter
108 (Archon canonical) / 110 (project narrative)

## Active routes / files under review

### Route: BasicOpenCech.lean L1846 `h_loc_exact` (post-iter-109 narrative)

- **Started at iter**: 108 (project narrative; was L1783 then displaced to L1802 by Steps 1a+1b, then to L1846 by Step 1c)
- **Iters audited**: 108, 109 (project narrative — corresponding to Archon iter-106, 107 that we just consumed)

#### Sorry counts per iter (whole BasicOpenCech file)
- iter-108 entry: 6 (5 deferred + 1 active L1783)
- iter-108 exit / iter-109 entry: 6 (5 deferred + 1 active L1802 — sorry shifted +19 by Steps 1a+1b inline scaffolding; *no* sorry closed)
- iter-109 exit (this iter to plan): 6 (5 deferred + 1 active L1846 — sorry shifted +44 by Step 1c inline scaffolding; *no* sorry closed)

#### Helpers added per iter (file-wide top-level helpers)
- iter-108: 0 top-level helpers; 2 inline `have`s landed (`h_V_le_U`, `h_slice_eq` at L1786–L1795 = 10 LOC inline scaffolding inside `h_loc_exact` body)
- iter-109: 0 top-level helpers; 3 inline `have`s landed (`h_pi_eq_inf'` 14 LOC, `h_V_affine` 5 LOC, `h_isLoc` 13 LOC = 32 LOC inline scaffolding, plus ~8 LOC of comment notes documenting the deferred Steps 2–4)

#### Prover statuses per iter
- iter-108: PARTIAL — Steps 1a + 1b (geometric setup `h_V_le_U` + `h_slice_eq`) landed inline, no top-level helper churn, deferred Steps 1c-4
- iter-109: PARTIAL — Step 1c (per-coord IsLocalization.Away via `h_pi_eq_inf'`/`h_V_affine`/`h_isLoc`) landed inline, no top-level helper churn, deferred Steps 2-4. **Identified a concrete structural blocker on Step 2**: `letI ... in <goal>` propagation does not give body binders for per-x algebra threading. Two routes named in iter-109 prover report: (i) move algebra setup BEFORE `have h_IsLocMod` so instances are stable in outer scope (but then they're not per-x, contradicts the recipe); (ii) build per-x `IsLocalizedModule` term-mode via `IsLocalizedModule.mk` directly (avoiding the `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid` instance entirely).

#### Recurring blocker phrases (across iter-108 and iter-109 narratives)
- "Steps 2–4 deferred" appears in iter-108 and iter-109 prover reports — same residual deferral chunk; recipe partials accumulate but residual unchanged.
- "letI in goal type does not propagate to body binders" — appears in iter-109 only (single iter; structural blocker freshly identified, not recurring yet).
- "no top-level helper churn" — appears in iter-108 and iter-109 reports — *positive* signal (prover discipline is holding, contrary to typical churn).
- "L1802 → L1846 shifted +44" — appears in iter-109 report (line shifted, sorry not closed).

#### Planner's current proposal for this iter

**Per the strategy-critic-iter107 exit criterion** (single-further-iter budget on L1846 ratified iter-107), this is the iter where the **Phase A escape-valve menu** must fire. Two consecutive PARTIAL outcomes on the same residual sorry; the iter-107 strategy explicitly forbids "silent continuation of the L1846 lane" past iter-110 (narrative).

The planner is leaning toward **Option (i): defer L1846 as a named Mathlib-gap sorry** (cheapest; preserves all iter-108 and iter-109 inline scaffolding as inert infrastructure; the iter-109 prover report itself recommends Option (i) as RECOMMENDED). Option (ii) is firing C1 promotion (independently mandated by user iter-107 hint, but doesn't help L1846 specifically — it's an orthogonal architectural refactor).

**Question for the critic**: is Option (i) the right call here, or is the planner falling for sunk-cost reasoning by preserving the inline scaffolding instead of considering a complete pivot? Specifically: (a) are 2 PARTIALs on a fresh-route enough to declare STUCK, given the iter-109 PARTIAL DID identify a concrete structural blocker (Step 2 letI propagation issue) that names a clean path forward for a future iter? (b) Is "defer-as-named-Mathlib-gap" essentially the same cost-of-pivot as a true STUCK-pivot, or is it a softer landing that the planner is using to avoid a harder strategic recheck?

### Route: BasicOpenCech.lean L1120 `cechCofaceMap_pi_smul` (PAUSED)

- **Started at iter**: ~099 (project narrative)
- **Iters audited**: 108, 109 (project narrative — these were the PAUSED iters where the lane was deliberately not extended)

#### Sorry counts per iter (file-wide; L1120 is one specific sorry within)
- iter-108: 6 (L1120 PAUSED; iter-105/107 partial-proof scaffold preserved byte-for-byte)
- iter-109: 6 (L1120 PAUSED; scaffold byte-for-byte preserved)

#### Helpers added per iter (for this route)
- iter-108: 0 (paused; no edits to L1064-L1119)
- iter-109: 0 (paused; no edits to L1064-L1119)

#### Prover statuses per iter
- iter-108: N/A (route not dispatched; PAUSED)
- iter-109: N/A (route not dispatched; PAUSED)

#### Recurring blocker phrases
- L1120's 7-iter PARTIAL streak (iter-099/100/101/103/105/106/107 narrative) was ratified STUCK by progress-critic-iter105 and re-affirmed STUCK by progress-critic-iter107. Iter-108 and iter-109 successfully observed the PAUSE — no extension of the streak.

#### Planner's current proposal for this iter
**Continue PAUSE.** No new prover dispatch on L1120. The progress-critic-iter107 STUCK verdict has not been challenged; the corrective ("route pivot") is in place. The iter-105/107 partial-proof scaffold remains as inert infrastructure.

**Question for the critic**: just confirm the PAUSE is operating as intended (no streak extension); no further verdict needed.

## Out of scope

- All other files (`Differentials.lean`, `Modules/Monoidal.lean`, `Jacobian.lean`, `Picard/Functor.lean`): not under iter-108 prover dispatch consideration.
- Strategic soundness of Option (i) vs Option (ii): that's strategy-critic territory (separate dispatch).
- Blueprint chapter adequacy: that's blueprint-reviewer territory (separate dispatch).
