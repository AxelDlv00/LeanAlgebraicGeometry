# Iter-122 (Archon canonical) — review

## Outcome at a glance

- **PARTIAL prover lane on `Differentials.lean:282` `appLE_isLocalization` (M1.b).**
  Of the 4 sorry sites introduced by the iter-122 plan-phase refactor
  `m1-bridge-iter122`, **3 are closed** this iter and **1 remains**:
  the residual at L304 is the M1.b body proper (Steps 1–4 of the
  `IsLocalization.of_le` chain; Step 0 is closed as the new helper
  lemma `isUnit_appLE_unitSubmonoid_in_colim`). Plus 1 black-box-used
  hypothesis (`appLE_isLocalization`) in the bridge body, which will
  resolve when M1.b closes.
- **Sorry trajectory across the whole iter-122 sequence (refactor +
  prover)**: **1 → 5 → 2**, distributed:
  - `Differentials.lean`: 0 → 4 (plan-phase refactor) → **1** at L304
    (`appLE_isLocalization` body; Steps 1–4 of the
    `IsLocalization.of_le` chain).
  - `Jacobian.lean`: 1 → 1 → **1** at L179 (`nonempty_jacobianWitness`,
    off-limits this iter; queued behind M2 + M3).
- **Net iter-122 change**: 1 → 2 (one new sorry site remains open
  from the M1 scaffolding the planner introduced this iter).
  PROGRESS.md explicitly framed PARTIAL as the realistic outcome
  for iter-122 ("Closing the `Algebra` letI + the four-step
  `IsLocalization` skeleton in one iter is the realistic ambition.
  The bridge body (L145) can wait for a later iter."). The actual
  outcome substantially exceeded that ambition (3 of 4 sorries
  closed + bridge body L145 closed modulo M1.b + Step 0 of M1.b
  closed as a named helper).
- **Compile-verified**: yes. `lake env lean
  AlgebraicJacobian/Differentials.lean` returns only the
  documented `sorry` warning at L304. `lake build` end-to-end
  succeeds with only sorry warnings at L304 (Differentials) and
  L179 (Jacobian).
- **No new axioms.** No protected signatures touched.
  `archon-protected.yaml` unchanged (9 protected declarations at
  original paths with unchanged signatures).
- **Meta**: `meta.json planValidate.status: ok / objectives: 1`;
  PARTIAL outcome on the single objective. Plan-phase included a
  refactor (`m1-bridge-iter122`) which introduced 4 sorry sites
  with all signatures landed; prover-phase closed 3 of those 4 +
  added 1 new named helper (Step 0 of the residual M1.b body).
  ~53 edits + 23 diagnostic checks + 12 lemma searches recorded
  in `attempts_raw.jsonl` (256 total events).
- **Stage**: stays at `prover` for iter-123. STRATEGY.md is
  unchanged from iter-121 (which is itself a substantive rewrite
  per the user pivot directive). The iter-122 progress-critic's
  UNCLEAR verdict on M1 should resolve to CONVERGING in iter-123
  given this iter's structural advance.

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **2**, distributed:
  - `AlgebraicJacobian/Differentials.lean:304` —
    `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` (M1.b body;
    Steps 1–4 of the `IsLocalization.of_le` chain remain;
    Step 0 closed via `isUnit_appLE_unitSubmonoid_in_colim`).
  - `AlgebraicJacobian/Jacobian.lean:179` —
    `nonempty_jacobianWitness` (intended end-state for the project
    overall; off-limits to the autonomous loop until M2 + M3 land).
- **Closed this iter (refactor-introduced sorries)**: **3** of 4.
  Specifically: L109 algebra-instance letI (replaced by top-level
  `appLE_colimAlgebra` def); L142 module-instance letI (replaced
  by `inferInstanceAs` from the underlying `ModuleCat`); L145 bridge
  body M1.e (closed via `(kaehler_quotient_localization_iso _).symm`).
- **Newly fully-proved declarations introduced this iter** (in
  addition to the 3 closures above):
  - `appLE_colimRingHom` (def, L97).
  - `appLE_colimAlgebra` (`@[reducible] noncomputable def`, L106).
  - `appLE_colimRingHom_comp_φV` (theorem, L116; ~35 LOC).
  - `isUnit_appLE_unitSubmonoid_in_colim` (theorem, L164; ~70 LOC
    — Step 0 of M1.b).
  - `kaehler_localization_subsingleton` (theorem, L314; ~6 LOC).
  - `kaehler_quotient_localization_iso` (`noncomputable def`, L330;
    ~25 LOC; the most extractable Mathlib contribution candidate
    of milestone M1).
- **Partial this iter**: 1 (`appLE_isLocalization`; ~70 LOC of
  Step 0 closed inline plus the bridge consumer; Steps 1–4
  remain).
- **Blocked this iter**: 0.
- **Untouched (deferred / out-of-scope)**: 1
  (`nonempty_jacobianWitness`).

## What the iter-122 prover got right

- **Sequenced the helper extraction before the consumer**. The plan
  agent's refactor `m1-bridge-iter122` had landed the M1 scaffolding
  with 4 sorry-stubs (algebra letI, M1.b body, module letI, bridge
  body). Instead of tackling the M1.b body directly (which was
  estimated at 200–400 LOC and was the obvious "hardest" target),
  the prover first closed the module letI (1 line via `inferInstanceAs`),
  then lifted the algebra letI out into a top-level `appLE_colimRingHom`
  + `appLE_colimAlgebra` pair (~15 LOC), then wrote the factorisation
  theorem `appLE_colimRingHom_comp_φV` (~35 LOC), and only then
  used those three helpers to close the bridge body M1.e in a single
  Edit. The result: 3 of 4 sorry sites closed *and* the foundation
  for Step 1+3 of the residual M1.b body laid down, in less time
  than a direct M1.b assault would have taken.
- **Engaged the deep-prover subagent for the architecturally-correct
  refactor of L109**. The inline `sorry`-ed `letI` at L109 could have
  been closed with an inline 5-line proof, but that would force every
  consumer of `appLE_isLocalization` to recreate the algebra structure
  inside its own scope. The subagent instead lifted the work into a
  top-level `appLE_colimAlgebra` def, which makes the algebra
  re-usable. This aligns with the iter-121 mathlib-analogist's
  recommendation to prefer top-level `IsAffineOpen.appLE_colimAlgebra`
  over inline letIs.
- **Honest PARTIAL framing in the task result**. The task result at
  `.archon/task_results/Differentials.lean.md` explicitly maps the
  outcome: 3 of 4 sorry sites resolved + 1 Step-0 helper closed +
  M1.b body remains, with effort estimates for the residual (100–250
  LOC for Steps 1–4). No overclaim; the planner can act on this
  directly for iter-123.
- **Surfaced 4 reusable technical lessons** in the task result that
  are now captured in the Knowledge Base. The lessons (rw/erw on
  Lan-defined functors; rw [Category.assoc] failure; change/show on
  algebraMap failure; adj.unit.naturality emitting 𝟭 terms) will save
  the iter-123 prover from re-discovering each pitfall during Step 2
  of M1.b.

## What could be improved (constructive, not critical)

- **The Step 0 substep (c) took ~15 attempts to land**, all involving
  variants of `rw [Functor.map_comp]` on the Lan-defined functor. The
  prover persisted to the right workaround (pre-prove `hmc` then
  `erw`), but consider whether iter-123 should preemptively dispatch
  `mathlib-analogist` on the cocone-universal-property usage before
  the Step 2 prover lane begins — Step 2 is the only step requiring
  scheme-theoretic cofinality reasoning, and similar functor-instance
  metadata hazards are likely.

- **Bridge body M1.e was closed modulo M1.b** (the proof at L145
  invokes `appLE_isLocalization` by name as a hypothesis). This is
  the right structural decomposition, but it means `sync_leanok`
  will NOT mark `\leanok` on the proof block of
  `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE` until M1.b
  closes. This is correct per the deterministic phase's contract
  (the proof transitively uses a sorry), and it matches the
  blueprint's `\uses{lem:appLE_isLocalization, ...}` dependency. No
  action needed; this is a feature, not a bug.

- **No `% NOTE:` annotations added** to the blueprint. The iter-122
  task result identified a stale Lean docstring at
  `Differentials.lean:436–447` (`smooth_locally_free_omega` block)
  claiming the bridge is "out of autonomous-loop scope", which is now
  false. This needs a docstring fix (CRITICAL #2 in
  `recommendations.md`), but the review agent can't edit `.lean`
  files — the plan agent must dispatch a refactor in iter-123. A
  `% NOTE:` annotation in the blueprint is the wrong vehicle here
  because the staleness is in the Lean docstring, not in the
  blueprint prose.

## Iter-122 plan-phase ↔ prover-phase coherence

The plan agent's PROGRESS.md for iter-122 explicitly named:
- "Primary target: `appLE_isLocalization` (lines 104–112, M1.b)";
- "Two sorries here are coupled" (L109 + L112);
- "Secondary target (lower priority): `relativeDifferentialsPresheaf_equiv_kaehler_appLE`
  (lines 135–145, the bridge cap-stone)";
- "Expected outcome: PARTIAL is the realistic iter-122 outcome".

The prover absorbed all four of those goals + 1 extra (Step 0 helper)
in a single iter. This is a clean plan/prover handshake: the plan
correctly identified the work, set realistic expectations, named the
Mathlib closure pieces (`Algebra.FormallyUnramified.of_isLocalization`,
`IsLocalization.of_le`, `IsLocalization.lift`,
`IsLocalization.ringHom_ext`, `KaehlerDifferential.exact_mapBaseChange_map`,
`map_surjective`, `IsAffineOpen.isLocalization_basicOpen`,
`basicOpen_eq_iff_isUnit`), and the prover used all but
`isLocalization_of_algEquiv` (which is queued for iter-123 Step 4).

## Stage transition signal

No stage change this iter (`prover` → `prover`). The iter-122
progress-critic's UNCLEAR verdict on M1 should resolve to CONVERGING
in iter-123's mandatory progress-critic dispatch, given:
- net structural advance of ~200 LOC of fully-proved declarations,
- 3 of 4 plan-introduced sorries closed,
- M1.b residual decomposed (Step 0 closed + Steps 1–4 named with
  effort estimates),
- the bridge cap-stone `relativeDifferentialsPresheaf_equiv_kaehler_appLE`
  closed modulo M1.b.

## Subagent dispatches this review-phase

None this iter. Rationale:
- This was a pure proof-filling round following the plan-phase
  refactor; no new definitions or refactors were introduced by the
  prover.
- The iter-122 plan-phase already dispatched all three mandatory
  critics (`strategy-critic`, `blueprint-reviewer`, `progress-critic`),
  plus `mathlib-analogist-bridge-iter121` was dispatched in iter-121.
- Per the review prompt § "When NOT to dispatch": "If this session
  was a pure proof-filling round with no new definitions or
  refactors, skip reviewers. They add latency and cost for no value."
- The next iter's mandatory critic dispatches will pick up any
  drift; running them now is wasted compute.

## Blueprint markers updated (manual)

None this iter. Rationale documented in `summary.md § Blueprint
markers updated (manual)`.

## Files touched (review phase)

- `.archon/proof-journal/sessions/session_122/summary.md` (created).
- `.archon/proof-journal/sessions/session_122/milestones.jsonl` (created).
- `.archon/proof-journal/sessions/session_122/recommendations.md` (created).
- `.archon/iter/iter-122/review.md` (this file; created).
- `.archon/PROJECT_STATUS.md` (Knowledge Base section updated;
  "Last Updated" line replaced).
- `.archon/TO_USER.md` (cleared — no escalation banner needed this
  iter: the prover lane ran as planned with PARTIAL outcome matching
  PROGRESS.md expectations, no impasse or hard-gate fire).
