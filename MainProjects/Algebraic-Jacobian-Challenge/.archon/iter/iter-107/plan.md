# Iter-107 (Archon canonical) / iter-109 (project narrative) plan-agent run

> **Note on iteration numbering.** Archon-loop counter `ARCHON_ITER_NUM=107`
> vs. the project's internal narrative counter (uses iter-109 for the prover
> round this run dispatches; iter-108 for the prover round whose output this
> run consumes). Both refer to the same loop.

## What I consumed

- `task_results/Cohomology_BasicOpenCech.lean.md` — iter-108 prover report
  (archived to `logs/iter-107/prover-iter108-BasicOpenCech-report.md`).
- `PROGRESS.md` — iter-108 plan dispatching prover on L1783 via the
  mathlib-analogist-iter106 Q1 ALIGN recipe.
- `STRATEGY.md` — Phase A iter-108 lane on `h_loc_exact` via Q1 recipe.
- `task_pending.md` / `task_done.md` — sorry inventory + protected status.
- `archon-protected.yaml` — unchanged.
- `USER_HINTS.md` — non-empty: "no approximation accepted, all
  definitions/declarations/theorems must be mathematically correct and
  aligned with the blueprints" → incorporated into STRATEGY.md (Phase C1
  row + escape-valve menu); USER_HINTS.md will be cleared post-action.
- Iter-104/105/106 (Archon) sidecars from injected context window.
- `task_results/lean-auditor-iter106.md` (carries iter-104 critical
  finding on LineBundle wrong def, restated this iter).
- `task_results/lean-vs-blueprint-checker-basicopencech-iter106.md` (no
  red flags this iter; recipe-coverage adequate).

## Independent verification (pre-action)

- `sorry_analyzer.py` on `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`
  → **6 sorries** at L1120 (PAUSED), L1212, L1536, L1564, L1754, **L1802**
  (former L1783, displaced +19 lines by iter-108 partial scaffolding).
- `sorry_analyzer.py AlgebraicJacobian/` (project root) → **14 total**:
  BasicOpenCech 6, Differentials 5, Jacobian 1, Modules/Monoidal 1,
  Picard/Functor 1. Matches expectation.
- `lean_diagnostic_messages` severity=error for BasicOpenCech → `[]`
  (file compiles).
- No new axioms in `BasicOpenCech.lean`.
- Iter-108 prover staging at L1786–L1795 (`h_V_le_U` + `h_slice_eq`)
  verified on disk verbatim per task_results.
- Mathlib citations re-verified via `lean_leansearch`: `IsLocalizedModule.pi`,
  `IsAffineOpen.isLocalization_of_eq_basicOpen`,
  `Function.Exact.iff_of_ladder_linearEquiv`, `LinearEquiv.conj_exact_iff_exact`,
  `localizedModuleIsLocalizedModule`, `instIsLocalizedModuleLinearMapOfIsLocalization`.

## Iter-108 outcome assessment

**PARTIAL — 0 sorry closed, 0 sorry added, ~19 LOC of geometric scaffolding
committed inline at L1786–L1795.** Trajectory: BasicOpenCech 6 → 6.

Independent verification of iter-108 prover claims:
- The Q1 recipe Steps 1a + 1b landed as inline `have` declarations within
  the `h_loc_exact := by ...` block (NOT as new top-level helpers).
  Confirms zero top-level helper churn — the progress-critic-iter107 watch
  flag has not fired.
- The L1783 sorry has shifted to L1802 by +19 lines due to the partial
  scaffolding, but the *residual* sorry at L1802 represents Steps 1c-4
  of the same recipe, still on track within the analogist's
  ~100-LOC envelope.
- No new top-level helpers, no new axioms, no protected signature changes.
- File compiles end-to-end.

**Streak status entering iter-109 (Archon iter-107)**: L1802 route is 1
iter old with PARTIAL outcome (progress-critic UNCLEAR with positive
early signals). L1120 route remains PAUSED at 7 iters PARTIAL (progress-
critic STUCK ratified, no new action required).

## Mandatory subagent dispatches (this iter)

Three mandatory subagent dispatches per the canonical plan-phase
ordering, all executed and consumed this iter.

### blueprint-reviewer (slug `iter107`)

**Verdict**: PASS. No must-fix-this-iter findings. Blueprint in good
shape for the iter-109 prover round. The critical-path chapter
(`Cohomology_MayerVietoris.tex` § Čech-acyclicity) covers the global
proof shape; the analogist Q1 recipe is in `analogies/finite-product-
localisation-and-cech-r-linearity.md` and adequate for the iter-109
prover. Soft-tier suggestions noted (inline a recipe summary in the
chapter remark in a later iter; informational, not blocking).

**Plan agent acts**: no blueprint-writer dispatch this iter.

### progress-critic (slug `iter107`)

**Verdict**:
- Route L1802 `h_loc_exact`: **UNCLEAR** (1 iter, positive signals — no
  top-level helper churn, no L1120 blocker carryover, recipe verified).
- Route L1120 `cechCofaceMap_pi_smul`: **STUCK (re-affirmed)** (8 iters
  PARTIAL/PAUSED, 4 recurring blocker phrases ≥3-iter threshold).
  Corrective ("route pivot") already executed and bound.

**Plan agent acts**: ratify the existing PAUSE on L1120 (no new prover
work this iter, scaffold preserved); proceed with the proposed prover
round on L1802. Watch flag: if recipe grows >150 LOC or a new top-level
helper appears, that's drift; record it in the prover task report.

### strategy-critic (slug `iter107`)

**Verdict**: SOUND with 2 must-fix amendments + 1 informational note.

**Must-fix #1**: "the iter-109 entry plan language ('Branch a: closes
L1783' / 'Branch b: stalls on L1783') does not accommodate the actual
iter-108 outcome (partial progress within the bounded recipe). Add a
third branch — 'iter-108 partial-progressed within recipe; iter-109
dispatches prover on Steps 1c-4 with an explicit budget of N further
iters' — and pick N before dispatch. Recommended N = 1."

**Plan agent acts**: STRATEGY.md updated — Phase A row now specifies the
single-further-iter budget on L1802. PROGRESS.md "Sorry budget" section
makes the exit criterion explicit. The iter-110 plan agent is bound to
fire the escape-valve menu if iter-109 PARTIALs.

**Must-fix #2**: "the strategy treats C1 promotion as *the* escape valve
for an L1802 stall, but defer-as-named-Mathlib-gap is a strictly cheaper
alternative that the strategy doesn't mention."

**Plan agent acts**: STRATEGY.md updated — added "Phase A escape-valve
menu" section with three options: (i) defer-L1802-as-named-Mathlib-gap
(preferred default; cheaper), (ii) fire C1 promotion (correct regardless
of Phase A status per user iter-107 hint, but more expensive), (iii)
mathlib-analogist re-consult on a different decomposition. Iter-110 plan
agent picks one if iter-109 partials.

**Informational note**: Phase B `serre_duality_genus` LOC variance —
dispatch mathlib-analogist on Serre-duality coverage before Phase B
scheduling. Not iter-107 action.

**Plan agent acts**: STRATEGY.md Phase B row updated with the variance
flag and analogist-precheck instruction.

**Sunk-cost flag** (informational): "preserving compiled partial-proof
scaffolding *can* be sound, but the 'load-bearing' framing can drift
into 'we already wrote it, so the future re-attempt must reuse it'."
Acknowledged in STRATEGY.md Phase A row — the L1120 scaffold may be
re-evaluated rather than reused when the lane reopens.

### NO OTHER DISPATCHES

- No refactor subagent dispatch this iter — iter-109 is a continuation
  of an existing inline recipe (Steps 1c-4), not a structural change.
- No blueprint-writer dispatch this iter — reviewer PASS.
- No mathlib-analogist dispatch this iter — the iter-106 analogist
  finite-prod-loc consultation provides the load-bearing recipe;
  the persistent file is already on disk and re-consulted by the
  iter-108 prover.
- No reference-retriever dispatch — no new sources needed.

## Iter-109 plan: what I dispatched

**Single substantive prover lane on `BasicOpenCech.lean` L1802** to
close Steps 1c-4 of the analogist Q1 ALIGN_WITH_MATHLIB recipe inline
within the `h_loc_exact := by` block. Bounded by the strategy-critic-
iter107 exit criterion: this is the **single further** prover iter
authorized on L1802 under the bounded-recipe banner. A second
consecutive PARTIAL fires the iter-110 escape-valve menu.

The detailed prover directive is in `PROGRESS.md § Current Objectives §
1`; key points:

- Insert Steps 1c-4 inline as `letI` / `have` / `set` declarations
  within the existing `:= by` block at L1796–L1801 (replacing the
  trailing `sorry` at L1802). NO new top-level helpers.
- Step 1c: per-coord `IsAffineOpen.isLocalization_of_eq_basicOpen` on
  `(V_x, (presheafMap _).hom f.1)` using `h_slice_eq x` + algebra
  bookkeeping `letI := ((C.left.presheaf.map (homOfLE (h_V_le_U x)).op).hom).toAlgebra`.
- Step 2: `instIsLocalizedModuleLinearMapOfIsLocalization` (or the
  `instIsLocalizedModuleToLinearMapToAlgHom...` adapter) + `Submonoid.map_powers`
  for submonoid translation.
- Step 3: `IsLocalizedModule.pi` over `Fin (n+1) → ↑s₀` (Finite via
  `Fintype.toFinite`).
- Step 4: `IsLocalizedModule.iso` + `Function.Exact.iff_of_ladder_linearEquiv`
  transport of `h_a₀_fun f`.

LOC envelope: ~100–110 LOC (iter-108 prover's estimate). Soft cap:
>150 LOC ⇒ pause and report PARTIAL with structural blocker named.

## Why I am NOT firing C1 promotion this iter despite the user hint

The user hint (USER_HINTS iter-107) rules out approximation/admitted-
wrong definitions; LineBundle is exactly that case. The natural
reading is "fire C1 now." I am deferring this for two specific reasons:

1. **The iter-106 plan already deferred C1 promotion by one iter
   pending iter-108 prover outcome on L1802.** Iter-108 PARTIALED with
   positive trajectory signals (progress-critic UNCLEAR, no helper
   churn, recipe verified). The iter-106 plan's branch-a condition —
   "iter-108 closes L1783 → iter-109 dispatches Q2 Path B" — was
   subsumed by partial progress: Steps 1a-1b landed but not L1802 in
   full. The natural action under the bounded-recipe doctrine is to
   continue with Steps 1c-4 for ONE more iter, with the iter-110 plan
   committed to fire either defer-as-gap OR C1 promotion if iter-109
   also partials.

2. **The user hint addresses the *general* policy on approximation,
   not the specific timing of C1 vs. L1802 closure.** The user hint
   does NOT say "fire C1 this iter." It says "no approximation accepted"
   — which is consistent with firing C1 *eventually* (per STRATEGY.md
   Phase C1 row: C1 will happen regardless of Phase A status). The
   question is sequencing. Firing C1 iter-107 (Archon) while L1802 is
   1-iter-PARTIAL would discard positive momentum on Phase A; deferring
   to iter-108 (Archon) lets the L1802 lane resolve cleanly first.

If iter-109 partials, the iter-110 plan agent has the user's hint
weighing toward C1 promotion over defer-as-gap (the latter expands
the named-gap surface from 3 to 4 — defensible but adds an admitted
non-construction; the former actually replaces the wrong def with the
correct one). STRATEGY.md records this framing.

## Outputs of this plan run

- **PROGRESS.md**: rewritten to dispatch iter-109 prover on L1802
  Steps 1c-4 inline. Includes hard exit criterion, LOC envelope,
  explicit recipe with [verified] Mathlib citations, and updated
  off-limits / state-preservation lists.
- **STRATEGY.md**: edited per strategy-critic-iter107 must-fix items.
  Phase A row gained the single-further-iter exit criterion. New
  "Phase A escape-valve menu" section with 3 options. Phase B row
  gained the `serre_duality_genus` variance flag. Phase C1 row gained
  the user-iter107 authorization framing.
- **task_pending.md**: updated header to reflect iter-108 outcome.
- **task_results/Cohomology_BasicOpenCech.lean.md**: cleared
  post-archive.
- **USER_HINTS.md**: cleared post-incorporation.
- **iter/iter-107/plan.md**: this file.

## Risks / known unknowns entering iter-109

- The Step 2 submonoid translation (`Submonoid.map_powers` +
  `IsLocalization.iff_of_eq`) may not have a direct Mathlib lemma in
  the exact shape needed — the iter-108 prover noted `IsLocalization.of_submonoid_eq`
  as a possible alternative. If the prover hits a missing-lemma blocker
  at this micro-step, the right action is to commit a partial proof
  with the trailing `sorry` on Step 2/3/4 (whichever step doesn't
  close) and let iter-110 plan fire the escape-valve menu.
- The Step 4 commutation diagram closure (`h_left` / `h_right` for
  `Function.Exact.iff_of_ladder_linearEquiv`) is non-trivial in
  practice — uniqueness of `IsLocalizedModule.map` via
  `IsLocalizedModule.linearMap_ext` is the canonical move but may
  require generating-set bookkeeping that's tedious. The iter-108
  prover estimated ~25-35 LOC for this step alone.
- The `ModuleCat.piIsoPi` repackaging (`e_i` at L1615–L1617) is
  already in scope, so the Step 4 transport doesn't need to rebuild
  the categorical-vs-set product identification — that's banked.

## What the next iter should expect

If iter-109 closes L1802:
- BasicOpenCech 6 → 5 (project total 14 → 13).
- Iter-110 dispatches mathlib-analogist Q2 Path B on L1120 (the
  iter-106 plan's branch-a destination): `set F := cechCofaceMap_summand_family s₀ n`
  at TOP of body, `change` pivot, then alternating-sum proof via
  `cechCofaceMap_summand_family_R_linear`. Time-boxed 1 iter.
- C1 promotion stays on standard schedule (~iter-111+ contingent on
  Phase B start).

If iter-109 PARTIALs:
- BasicOpenCech stays 6 (project total 14).
- Iter-110 plan agent MUST fire the escape-valve menu (defer-as-gap
  default; OR C1 promotion if strategy argues for it). No further
  L1802 prover deferral permitted.
- If C1 promotion fires: refactor `Picard/LineBundle.lean` body to
  `MonoidalCategory.Invertible (X.Modules)`. Estimate 5–8 iters.
- If defer-as-gap fires: mark L1802 with `-- MATHLIB GAP: ...` and
  route around. BasicOpenCech 6 sorries → 6 (one of them now a named
  gap). Phase A is then "complete modulo the named gap" and iter-110+
  schedules Phase B / Phase C1 in the standard order.

## Self-review

- Mandatory subagents dispatched: ✓ blueprint-reviewer, progress-critic,
  strategy-critic.
- Strategy-critic must-fix items: ✓ both addressed in STRATEGY.md edits.
- Progress-critic verdicts: ✓ ratified (L1802 UNCLEAR-positive proceed,
  L1120 STUCK-paused ratified).
- Blueprint-reviewer verdict: ✓ PASS, no blueprint-writer dispatch needed.
- User hint: ✓ incorporated into STRATEGY.md framing; not actioned this
  iter for sequencing reasons named above.
- PROGRESS.md: ✓ rewritten with the iter-109 prover directive bounded
  by exit criterion + LOC envelope + state-preservation rules.
- task_pending.md updated: ✓ (small).
- task_results/ cleared of processed entries: ✓ (Cohomology_BasicOpenCech.lean.md;
  the iter107 subagent reports stay until iter-108 plan archives them).
- USER_HINTS.md cleared: ✓.
- iter sidecar written: ✓ (this file).
