# Progress Critic Report

## Slug
ts242

## Iteration
242

## Routes audited

### Route A — `Picard/TensorObjSubstrate.lean` (A.1.c substrate: `IsInvertible.pullback`, Route Z)

- **Sorry trajectory**: 2 → 2 → 2 → 2 across iter-238 to iter-241 — CONSTANT. However, the two persistent sorries are explicitly acknowledged DEFERRED dual-bridge sorries (`exists_tensorObj_inverse` L693, `addCommGroup_via_tensorObj` L1181), which are off the active sub-lane. All new declarations on the active sub-lane are sorry-free by construction (new decls added axiom-clean each iter). The meaningful "residual" for this lane is the phase checklist, not the deferred file count.
- **Helper accumulation**: +9 (group law, iter-238), +1 (sheafifyTensorUnitIso, iter-239), +2 (linchpins pullbackObjUnitToUnit_comp + unitToPushforwardObjUnit_comp, iter-240), +4 (pullbackUnitIso + 3 bricks, iter-241). 16 total helpers over 4 iters. **Every helper closed a named milestone** — the group law (iter-238), the Phase-1 linchpin (iter-240), the Phase-1 PRIMARY (iter-241). This is not the helper-without-payoff accumulation pattern.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL — 4/4. The CHURNING rule "PARTIAL prover status ≥3 of last K iters" is technically triggered. Assessment of whether this is genuine churn or staged development is below.
- **Recurring blockers**: "genuine Mathlib-absent build, no comparison map" for Phase 2 (`pullbackTensorIso`) appears in iter-239 (dead sectionwise recipe) and iter-241 (Phase 2 absent). That is 2 iters — below the ≥3 threshold for STUCK. Crucially, the iter-242 target is a DIFFERENT approach (direct `pullbackObjTensorToTensor` comparison map build), not a re-attempt of the dead recipe. No recurring blocker at ≥3 iters.
- **Avoidance patterns**: none. Route has been dispatched every iter in the window.
- **Throughput**: ON_SCHEDULE — strategy estimates ~5–9 iters for A.1.c (Phase 1 + Phase 2 + Phase 3). Elapsed = 4 iters (iter-238 to iter-241). Phase-1 closed at iter-241 (within estimate). Phase-2 + Phase-3 remain; the analogist pbu-canon confirmed Phase-2 and Phase-3 use the same bundled-`asIso` idiom and Phase-3 has no recurrence.

**PARTIAL criterion assessment.** The rule fires mechanically (4/4 PARTIAL). However, the PARTIAL statuses correspond to sequential phase closures on a 3-phase build, not a "made some progress but residual unchanged" stall. iter-238 PARTIAL closed the group law (Phase-0 prerequisite). iter-239 PARTIAL added a reusable brick with Phase-1 not yet reached. iter-240 PARTIAL closed the Phase-1 linchpins. iter-241 PARTIAL closed the Phase-1 PRIMARY. Each PARTIAL advanced the phase checklist to completion of a named sub-step. A mechanical CHURNING verdict would direct the planner to run an analogy consult or blueprint expansion — but pbu-canon already covers Phase-2/3 (Q3: same fix, no recurrence), and the blueprint reviewer (ts241-fastpath) cleared the chapter as complete and correct. Running a corrective subagent would consume an iteration without adding information.

- **Verdict**: **CONVERGING**. The PARTIAL criterion fires as a false positive on a staged multi-phase build. Phase-1 closed within the strategy estimate; Phase-2 is a fresh, well-scoped target with an existing analogist answer (pbu-canon Q3). Dispatching a mathlib-build prover is the right move. The deferred file sorries (2, constant) are acknowledged off-lane and do not affect this verdict.

---

### Route B — `Cohomology/FlatBaseChange.lean` (A.2.c-engine: flat base change i=0)

- **Sorry trajectory**: 2 → 3 → 3 → 2 across iter-236 to iter-241. Net: unchanged. The +1 at iter-239 was a deliberate new PINNED decl (not regression — a planned scaffold). The −1 at iter-241 is a genuine sorry closure (`pushforward_spec_tilde_iso`, axiom-clean). Over the 4-iter window, the CONVERGING rule's "strictly decreasing" requirement is not met.
- **Helper accumulation**: +3 (Γ-fragment decls, iter-236), +2 (bricks, iter-239), +0 (iter-240), +0 (iter-241). Helpers were added in 2 of 4 iters. The last 2 iters added zero helpers — the work was structural (carrier wall fix, NatIso refactor) rather than brick accumulation. CHURNING's helper criterion requires "no structural change in approach," which is not satisfied here: iter-240 introduced `algebraize [φ.hom]` (structural pivot) and iter-241 applied the `eqToIso → restrictScalarsCongr` one-line refactor that closed the sorry.
- **Prover status pattern**: PARTIAL, PARTIAL, PARTIAL, PARTIAL — 4/4. CHURNING trigger fires mechanically.
- **Recurring blockers**: "`restrictScalarsComp'App` rewrite-matching / carrier wall" appeared from iter-237 through iter-240 (4 iters). This IS a 4-iter recurring blocker — and it is NOW RESOLVED in iter-241. The `hsq` naturality square closed via `ext x; rfl` after the `eqToIso → restrictScalarsCongr` swap (iter-241 memory). The prior-iter STUCK verdict (ts241) and its trip-wire ("sorry MUST strictly decrease") were both armed correctly, and the route met the trip-wire condition.
- **Avoidance patterns**: none. Route dispatched every iter in the window.
- **Throughput**: ON_SCHEDULE — strategy estimates ~30–60 iters remaining for A.2.c-engine. Phase entered ~iter-233. Elapsed = 9 iters. The estimate is for the FULL engine (Quot/Cartier, ~3400–5500 LOC); the FlatBaseChange sub-lane is a parallel seed. 9 iters into a 30–60-iter phase is early. No over-budget concern.

**PARTIAL criterion + sorry-trajectory assessment.** The PARTIAL rule fires (4/4). The sorry trajectory is net flat (2→3→3→2), which technically fails the CONVERGING requirement of strictly decreasing over the K-iter window. However: (a) the net-flat trajectory reflects a deliberate scaffold pin (+1) followed by resolution (-1); (b) the 4-iter recurring blocker that caused the ts241 STUCK verdict is now definitively resolved; (c) the last iter (iter-241) DID reduce the sorry count (3→2); (d) the proposed iter-242 target (pullback-of-tilde affine dictionary) is a NEW, fresh objective not previously attempted, and is distinct from the now-closed pushforward direction. The trip-wire condition was met; the route earned its re-dispatch.

**Concern — fresh large build without a dedicated analogist pass.** The pullback-of-tilde affine dictionary (`pullback (Spec.map φ)(tilde M) ≅ tilde (R'⊗_R M)`) is a new ~hundreds-LOC target. The pushforward direction required 4+ iters to resolve a carrier wall. The pullback direction has NOT had an analogist consult scoping the available Mathlib lemmas (`IsLocalizedModule.extendScalarsOfIsLocalization`, `AlgebraicGeometry.ΓSpec.locallyRingedSpaceAdjunction`, etc.). The blueprint reviewer cleared the FlatBaseChange chapter but the proof sketch for the pullback affine dictionary may be thinner than the pushforward section. This is a minor concern, not a blocker — the blueprint cleared and the approach is standard — but the prover should be briefed to bail early if a new carrier wall appears rather than accumulating helpers.

- **Verdict**: **CONVERGING**. The PARTIAL criterion fires as a false positive on a route that (a) just closed its 4-iter recurring blocker, (b) reduced the sorry count in the last iter (trip-wire condition met), and (c) is now starting a genuinely fresh target. Dispatch mathlib-build on the pullback-tilde dictionary. If a new carrier wall appears mid-dispatch, report early rather than accumulating helpers.

---

## PROGRESS.md dispatch sanity

Verdict: **OK** — file count 2 (cap 10). Both files are the only active lanes in the project (RPF gated on `IsInvertible.pullback` not yet landed; HigherDirectImage explicitly gap-blocked; all Route-C lanes PAUSED; A.3/A.4 gated A.2.c). No ready-but-not-dispatched files exist. No over-cap. No under-dispatch finding.

---

## Informational

**Route A — Phase-2 dispatch note.** The prover inherits the pbu-canon analogist finding (Q3: Phase-2 uses the same bundled-`asIso` idiom, no `OplaxMonoidal` packaging required). The PROGRESS.md objective is already annotated with this. No additional analogy pass is needed before dispatch. If Phase-2 closes in iter-242, Phase-3 (`IsInvertible.pullback` composite) is a short follow-through — the objectives file should prompt the prover to attempt Phase-3 in the same dispatch rather than leaving it for iter-243.

**Route B — pullback-tilde monitoring.** The pushforward-spec direction required resolving an `eqToIso`/`restrictScalarsComp'App` carrier wall over 4 iters. The pullback-tilde direction may hit an analogous wall if the `IsLocalizedModule` instance for `R'⊗_R M` does not synthesize cleanly. The prover should be directed to use `ext` + `rfl` idioms early (following the iter-241 memory) rather than `rw`-matching on restricted-scalar morphisms.

---

## Overall verdict

Both routes are **CONVERGING**. Route A closed Phase-1 (primary `pullbackUnitIso`) axiom-clean in iter-241, within the strategy estimate of 5–9 iters (4 elapsed); Phase-2 is a fresh well-scoped target with existing analogist coverage. Route B resolved its 4-iter recurring carrier wall and eliminated a sorry in iter-241, meeting the ts241 trip-wire; the pullback-tilde affine dictionary is a fresh target with blueprint coverage. The PARTIAL criterion technically fires on both routes (4/4 PARTIAL statuses each) and the sorry trajectories are not strictly monotone decreasing — but both trigger as false positives on staged multi-phase development with genuine milestone closures, not on the helper-accumulation-without-payoff pattern the criterion exists to catch. Dispatch mathlib-build on both files this iter. No corrective subagent is warranted.
