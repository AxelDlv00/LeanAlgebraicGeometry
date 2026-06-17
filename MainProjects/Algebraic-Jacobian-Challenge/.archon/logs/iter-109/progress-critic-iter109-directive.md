# Progress Critic Directive

## Slug
iter109

## Iter
109 (Archon canonical) / 111 (project narrative)

## Active routes / files under review

### Route 1: `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` L1846 (`h_loc_exact`)

- **Started at iter**: 106 (Archon) — first prover round on this slot
- **Iters audited**: 106 / 107 / 108 (Archon canonical numbering)

#### Sorry counts per iter (entire file)
- iter-106: BasicOpenCech file count = 6 (residual at L1783 just opened)
- iter-107: BasicOpenCech file count = 6 (residual at L1802 after iter-107 partial)
- iter-108: BasicOpenCech file count = 6 (residual at L1846 after iter-108 partial)

#### Helpers added per iter (top-level)
- iter-106: 0 new top-level helpers (all scaffolding inline)
- iter-107: 0 new top-level helpers (all scaffolding inline)
- iter-108: 0 new top-level helpers (only `sorry`-annotation edit)

#### Helpers added per iter (inline `have` declarations inside `h_loc_exact`)
- iter-106: 2 inline `have`s landed: `h_V_le_U` (≤ U), `h_slice_eq` (V_x ⊓ D(f) = D(f|V_x) via `Scheme.basicOpen_res`). ~19 LOC.
- iter-107: 3 inline `have`s landed: `h_pi_eq_inf'` (image-Finset bridge), `h_V_affine`, `h_isLoc` (per-coord `IsLocalization.Away`). ~40 LOC.
- iter-108: 0 inline `have`s; only annotation. 10 LOC of `-- DEFERRED (budget): ...` comment.

#### Prover statuses per iter
- iter-106: PARTIAL — "Steps 1a + 1b landed (h_V_le_U, h_slice_eq); Steps 1c-4 deferred; trailing sorry preserves the recipe."
- iter-107: PARTIAL — "Step 1c landed (h_pi_eq_inf', h_V_affine, h_isLoc); Step 2 attempts (A) and (B) failed at `letI ... in <goal-type>` propagation + algebra-arg-order brittleness; Steps 2-4 deferred."
- iter-108: PARTIAL by sorry-count metric / COMPLETE by route-pivot intent — "Trailing sorry at L1846 replaced with 10-line `-- DEFERRED (budget): ...` annotation per Phase A escape-valve Option (i); no closure attempt; inline iter-106 + iter-107 scaffolding preserved byte-for-byte as inert infrastructure."

#### Recurring blocker phrases
- "Steps 2-4 deferred" — appears verbatim in iter-106 + iter-107 task reports.
- "letI ... in <goal-type> does not propagate to body binders for per-x algebra threading" — appears in iter-107 task report; root cause for the iter-108 escape-valve firing.
- "inert infrastructure for future re-attempt" — appears in iter-108 task report (used to justify preserving the iter-106+iter-107 scaffolding past the annotation).

#### Planner's current proposal for this iter
- L1846 route is **closed-out as a budget-deferred sorry per iter-108 Option (i) escape-valve**. The annotation landed iter-108; this route is OFF-LIMITS this iter. No prover work on L1846 planned.

### Route 2: `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` L1120 (`cechCofaceMap_pi_smul`)

- **Started at iter**: ~099 (project narrative; corresponds to a long Phase A slot)
- **Iters audited**: 104 / 105 / 106 / 107 / 108 (Archon canonical numbering for the last 5 iters)

#### Sorry counts per iter (the L1120 sorry alone)
- iter-104 through iter-108: 1 (preserved)

#### Helpers added per iter (top-level)
- iter-104: 1 new top-level helper `cechCofaceMap_summand_family_R_linear` (closed body, ~50 LOC).
- iter-105: 1 new top-level helper `cechCofaceMap_summand_family'_R_linear` (wrapper, closed body).
- iter-106: 0 (PAUSED per progress-critic-iter106 STUCK).
- iter-107: 0 (PAUSED preserved).
- iter-108: 0 (PAUSED preserved).

#### Prover statuses per iter
- iter-104: PARTIAL (substantive helper landed; the trailing L1120 sorry remained).
- iter-105: PARTIAL (wrapper helper landed; whole proof not closed).
- iter-106: PAUSED — no prover work assigned on L1120.
- iter-107: PAUSED preserved.
- iter-108: PAUSED preserved.

#### Recurring blocker phrases
- "anonymous-closure Pi.lift codomain" — appears 6 / 7 of the L1120 PARTIAL iters (iter-099 / 100 / 101 / 103 / 105 / 106 / 107 — project narrative).
- "discrim-tree pattern-unification" — 5 / 7.
- "whnf timeout" — 4 / 7.
- "eqToHom-vs-Pi.π transport" — 4 / 7.
- "Fin index mismatch / Fin.cast" — 4 / 7.

#### Planner's current proposal for this iter
- L1120 PAUSED preserved (iter-108 progress-critic STUCK verdict ratified; no new helper rounds). Route is OFF-LIMITS.

### Route 3: `AlgebraicJacobian/Picard/LineBundle.lean` (C1 promotion — FRESH ROUTE)

- **Started at iter**: 109 (Archon canonical) — i.e. this iter — first dispatch
- **Iters audited**: NONE (fresh route this iter)

#### Sorry counts per iter
- N/A (fresh)

#### Helpers added per iter
- N/A (fresh; first dispatch is iter-109)

#### Prover statuses per iter
- N/A (fresh; this iter will be the first round)

#### Recurring blocker phrases
- N/A (fresh)

#### Planner's current proposal for this iter
- **Fire C1 promotion via `refactor` subagent dispatch on `Picard/LineBundle.lean`**. The dispatch is informed by the iter-108 mathlib-analogist `c1-route` report (saved at `analogies/c1-route.md`), which returned 4 decisions:
  - Decision A: rename target to `(Shrink (Skeleton X.Modules))ˣ` (canonical idiom mirroring `CommRing.Pic`) — ALIGN_WITH_MATHLIB.
  - Decision B: accept that post-C1, `instIsMonoidal_W` becomes load-bearing for the entire Pic-and-down arc (re-classified from "dormant deferred" to "load-bearing deferred") — ALIGN_WITH_MATHLIB with disclosure cost (already folded into STRATEGY.md End-state framing).
  - Decision C: `Functor.Monoidal (Scheme.Hom.pullback f)` is absent from Mathlib. Default option (c): accept a 5th named sorry `SheafOfModules.pullback_tensorObj`. — NEEDS_MATHLIB_GAP_FILL.
  - Decision D: register inhabitants via hand-rolled `Units.mkOfMulEqOne` (no scheme-side `Invertible` typeclass exists in Mathlib) — PROCEED.
- Concurrent `blueprint-writer` for `Picard_LineBundle.tex` to update the chapter to reflect the post-refactor state.
- Refactor inserts sorries at downstream call-sites in `Picard/Functor.lean` and `Picard/FunctorAb.lean` it can't mechanically translate (expected: maybe 1-3 new sorries that the next prover iter resolves).
- Expected outcome: project total goes from 14 → ~15-18 (depending on downstream rippling); project named-sorry count goes from 4 to 5 (`SheafOfModules.pullback_tensorObj` is added as a 5th named gap).

#### Question for the critic
- Is this fresh route well-shaped, given the analogist's pre-work? Specifically:
  - The CHURNING / STUCK detection signal is "no convergence after K iters." For a fresh route there is no prior signal. Render UNCLEAR or render a hard-shape pre-launch verdict ("this route's helper-churn risk profile is X based on analogist findings + structural complexity").
  - Is the refactor scope **bounded** (file-confined to `Picard/LineBundle.lean` + minimal downstream call-site fixes), or does it have CHURNING potential (refactor that keeps inserting sorries at downstream sites without converging)?

## Question for you

Render a per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) for each of Routes 1, 2, 3. For Routes 1 and 2, the planner expects ratification of the current PAUSED + OFF-LIMITS framings (Route 2 STUCK carry; Route 1 now retired as a budget-deferral). For Route 3, render the fresh-route verdict noted above. Flag any signal that the planner is missing.

Per dispatcher notes: do not read STRATEGY.md, blueprint chapters, iter sidecars, or task_pending. Your value is the narrow signal-level view.
