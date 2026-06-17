# Progress Critic Report

## Slug
iter029

## Iteration
029

## Routes audited

### Route: FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Sorry trajectory**: 5 → 5 → 4 across prover rounds iter-026 / iter-028 (K=3 prover rounds within the K=4 window; iter-024 parent group adds a 4th PARTIAL round). Net −1 across 3 rounds = 0.33/round (< 0.5 threshold).
- **Helper accumulation**: `erw`-unlock (iter-026); dead `hpfc` term (iter-028). Helpers added in ≥2 of last 3 prover rounds. No sorry closes attributable to the helpers directly: `inner_value_eq` closed via a one-liner cascade onto the pre-existing `fstar_reindex`, not via the `hpfc` helper (which is now dead). The `_legs` residual is unchanged.
- **Prover dispatch pattern**: 1 of 1 active FBC file dispatched for all 3 prover rounds (no under-dispatch since only 1 FBC file). Dispatch count is correct for this lane.
- **Recurring blockers**:
  - "literal-form lock" appeared iter-020, iter-022, iter-024, iter-026 (4 consecutive iters). Resolved via `erw` at iter-026 — no longer active.
  - "`X.Modules` instance diamond — composed-⋙ vs nested-obj domains; `rw`/`simp` no-match, `erw` whnf-timeout at 4M heartbeats" — first appears iter-028. NOT yet recurring (1 iter). However, the iter-028 prover report explicitly diagnosed it as blocking BOTH `_legs` AND `gstar_transpose`, and named the same instance-diamond class responsible for 3 prior cancellation failures. Treat as a high-risk emerging blocker.
- **Avoidance patterns**: none. Route has been continuously dispatched.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL (all 3 prover rounds in K=4 window; PARTIAL×4 if the iter-024 parent group is counted, which is the conservative reading).
- **Throughput**: OVER_BUDGET — FBC-A phase entered iter-018; STRATEGY.md `Iters left` = 2–4 iters (verbatim from the directive); ≥10 iters elapsed; 10 > 2× 4.
- **Verdict**: **CHURNING**

  PARTIAL×3 prover-status rule fires verbatim (≥3 of last K iters carry PARTIAL). Additionally: net sorry rate 0.33/round is below the 0.5/round threshold, and helpers have been added in ≥2 prover rounds. OVER_BUDGET on phase duration also applies.

  **Does the iter-029 proposal read as churning?** Assessed directly per the directive's question:
  the proposal does NOT repeat the old recipe (reworded blueprint expansion → another structural-helper round). It executes the Mathlib-analogist consult prescribed by both the iter-026 escalation tripwire and the iter-028 must-fix, seeded with the GR lane's WORKING recipe for the same diamond class (`erw` + `exact congrArg (_ ≫ ·)` + `Iso.inv_comp_eq`, defeq-inside-`exact`). This is a genuinely different corrective mechanism — not churn-by-rotation. **The CHURNING verdict stands on signal grounds, but the iter-029 plan is the right structural response and does not itself constitute an avoidance pattern.** The critical gate (see below) is that the FBC prover must not run until the analogist consult returns.

- **Primary corrective**: **Mathlib analogy consult** (already prescribed and executing this iter). The consult should explicitly ask: given the GR lane's working recipe (`erw` + `exact congrArg (_ ≫ ·)` + `Iso.inv_comp_eq`), what is the analogous term-mode mechanism for the `X.Modules` composed-⋙ vs nested-obj diamond in the `_legs` telescoping? The FBC prover must be dispatched AFTER the consult returns a concrete mechanism — not concurrently. If the consult cannot be run (e.g., no available subagent slot), defer the FBC prover dispatch to iter-030 with the consult output in hand.
- **Secondary corrective**: Revise STRATEGY.md FBC-A phase estimate (currently 2–4 iters; reality is ≥10 iters elapsed). The estimate-vs-reality gap is now large enough to mislead throughput budgeting for downstream milestones.

---

### Route: QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean`

- **Sorry trajectory**: 4 → 4 → 4 across iter-024 parent / iter-026 / iter-028. Flat by design: the 4 sorries are protected out-of-scope stubs (`hilbertPolynomial` / `QuotFunctor` / `Grassmannian` / `Grassmannian.representable`). The actual target (`isLocalizedModule_basicOpen_of_isQuasicoherent`) is a new declaration, not an existing sorry.
- **Helper accumulation**: +2 axiom-clean decls (iter-024/parent); +5 axiom-clean glue decls (iter-026); +2 axiom-clean decls (iter-028). Total 9 axiom-clean decls added across 3 prover rounds. None are dead. Each iter reduces the target to a smaller residual: iter-028 established G1-core ≡ gap1 ≡ ONE lemma `isIso_fromTildeΓ_of_isQuasicoherent`, Mathlib gap verified by grep. This is structural narrowing, not helper accumulation for its own sake.
- **Recurring blockers**: evolving each iter (gap1 hand-wavy → multi-session Stacks-01HA descent → finite tilde cover from `QuasicoherentData`). No single phrase recurs. Blocker evolution is convergent (each iter the gap is named more precisely).
- **Prover status pattern**: PROGRESS, PROGRESS (2 prover rounds in G1-core sub-phase; "PROGRESS" treated as PARTIAL for rule purposes — 2 of K=4 iters, below the ≥3 PARTIAL threshold).
- **Throughput**: ON SCHEDULE — G1-core sub-phase entered ~iter-026; 2 prover rounds elapsed; STRATEGY.md `Iters left` = 4–7 for QUOT-defs (verbatim from directive). 2 elapsed ≤ 4 lower bound.
- **Verdict**: **UNCLEAR**

  Only 2 prover rounds of G1-core sub-phase signal. PARTIAL×3 does not fire (only 2 rounds). The helper-churn rule does not fire: helpers ARE being added in ≥2 iters, and sorry count IS net unchanged — but the "no structural change in approach" condition is not met (approach changes structurally each iter as the gap narrows). STUCK does not fire (no INCOMPLETE, no recurring blocker). CONVERGING does not fire (sorry count not strictly decreasing — but the flat count is definitionally correct for a target that doesn't yet exist as a sorry).

  **The route is structurally converging on a concrete single lemma, but there is insufficient trajectory to certify CONVERGING.** The iter-029 dispatch at the handed-off sub-build (`exists_isIso_fromTildeΓ_basicOpen_cover` + Mayer–Vietoris induction) is the correct next step.

  **Watch signal for iter-030**: if iter-029 returns 4→4 sorry with only further infrastructure decls (no progress toward `isIso_fromTildeΓ_of_isQuasicoherent` itself), flip to CHURNING at iter-030. The handed-off sub-build must be directly attacked in iter-029, not set up for a subsequent round.

---

### Route: GR — `AlgebraicJacobian/Picard/GrassmannianCells.lean`

- **Sorry trajectory**: 0 → 0 → 0 throughout (0-sorry mathlib-build lane; progress is new axiom-clean decls, not sorry elimination).
- **Helper accumulation**: +11 axiom-clean decls (iter-026, 7 GlueData fields + awayPullbackIso + legs + awayMulCommEquiv); +4 axiom-clean decls (iter-028: `chartTransition'`, `awayMulCommEquiv_comp_algebraMap`, `chartTransition'_ringIdentity`, `chartTransition'_fac`). All are building blocks toward `theGlueData`; none are dead.
- **Recurring blockers**: none. The HasPullback/Scheme instance diamond was encountered in iter-028 for `chartTransition'_fac` and resolved in that same iter via the documented recipe (`erw` + `exact congrArg (_ ≫ ·)` + `Iso.inv_comp_eq`). The recipe is now on-file for the next prover.
- **Prover status pattern**: PROGRESS, PROGRESS (2 rounds, GR-glue sub-phase).
- **Throughput**: ON SCHEDULE — GR-glue entered ~iter-026; 2 prover rounds elapsed; STRATEGY.md `Iters left` = 6–12 for QUOT-repr (GR-glue). Well within estimate.
- **Verdict**: **CONVERGING**

  All CONVERGING conditions are met except the literal sorry-count check, which is vacuously inapplicable (sorry = 0 throughout by design — the route cannot go lower). Concrete remaining task is documented in a HANDOFF comment: `cocycle` (ring identity `Φ = RingHom.id`, `IsLocalization.ringHom_ext` approach, ~30–50 LOC, no diamond) → `theGlueData` body → `Grassmannian.scheme`. No recurring blockers. All supporting lemmas are in file. Recipe for the remaining diamond (if re-encountered) is documented. Assembly is a volume task, not a missing-fact task.

---

## PROGRESS.md dispatch sanity

- **File count**: 3 (cap: 10)
- **Ready but not dispatched**: none — all 3 active lanes are in the proposal
- **Over the cap**: no
- **Under-dispatch finding**: no
- **Sequencing note** (not a dispatch-sanity finding, but flag for the planner): FBC prover and the Mathlib-analogist consult are both assigned this iter. These are NOT parallel — the prover must be dispatched AFTER the analogist consult returns. The proposal's language ("I am executing it this iter... I then plan to dispatch FBC with that genuinely-new term-mode mechanism") implies correct sequencing. Confirm that the prover dispatch is gated on the consult output in the plan phase execution, not co-dispatched.

**Verdict: OK** — file count 3 within cap 10, no under-dispatch, no bloat.

---

## Must-fix-this-iter

- **Route FBC: CHURNING** — primary corrective: **Mathlib analogy consult** (already executing). Gate: the FBC prover MUST NOT be dispatched until the analogist consult completes and delivers a concrete diamond-robust term-mode recipe. "Seeded with GR recipe" is necessary but not sufficient — the consult must translate `erw + exact congrArg + Iso.inv_comp_eq` from the GlueData/categorical-pullback domain into the `X.Modules` Seam-2 setting (composed-⋙ vs nested-obj, counit `app` under `Γ.map`). Dispatching the FBC prover before this translation is done would be a 4th structural helper round under a different name.

- **Route FBC: OVER_BUDGET** — STRATEGY.md FBC-A phase estimates 2–4 iters; ≥10 iters have elapsed (entered iter-018). Update the STRATEGY.md estimate to reflect real burn-rate. The gap is large enough that downstream milestone budgeting (e.g., QUOT 4–7 iters) may be miscalibrated if the same optimistic-estimate pattern applies there.

---

## Informational

**QUOT (UNCLEAR)**: The route is following the correct trajectory: each prover round narrows the gap precisely rather than adding dead helpers. The iter-029 dispatch at `exists_isIso_fromTildeΓ_basicOpen_cover` is the highest-value next move. If the sub-build closes at iter-029 and the Mayer–Vietoris induction follows at iter-030 or iter-031, the route resolves within the STRATEGY.md estimate. No action needed now; re-assess at iter-031.

**GR (CONVERGING)**: The `cocycle` ring identity is concrete and ring-level (no diamond). The `theGlueData` assembly spec is fully documented in the HANDOFF comment. The `f_id` / `f_hasPullback` fields may re-encounter the HasPullback diamond — the recipe (`erw` + `exact congrArg` + `Iso.inv_comp_eq`) is already on-file. One prover round should suffice for `cocycle` + `theGlueData` + `Grassmannian.scheme` (or at worst two). No corrective needed.

---

## Overall verdict

One route is **CHURNING** (FBC), one is **UNCLEAR** (QUOT), and one is **CONVERGING** (GR). FBC has been PARTIAL for all prover rounds since iter-018 (≥10 iters elapsed vs. a 2–4 iter estimate) and its latest blocker — the `X.Modules` instance diamond — is the same blocking class that the GR lane already resolved. The iter-029 plan is the correct structural response: run the Mathlib-analogist consult with GR seeding before dispatching the FBC prover. This is NOT avoidance — it is the prescribed escalation from the iter-028 tripwire. The hard gate is sequencing: the FBC prover dispatch must follow the consult output, not run in parallel with it. QUOT is structurally converging on a single concrete lemma but has only 2 prover rounds of G1-core data; dispatch at the concrete sub-build this iter is the right call. GR has a fully documented recipe for the remaining assembly and is on track to complete in 1–2 more prover rounds. Dispatch sanity is OK (3 files, within cap, all active lanes covered).
