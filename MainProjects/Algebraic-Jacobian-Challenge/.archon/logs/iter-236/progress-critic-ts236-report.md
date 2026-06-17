# Progress Critic Report

## Slug
ts236

## Iteration
236

## Routes audited

### Route 1 — `Picard/TensorObjSubstrate/StalkTensor.lean` (d.2 stalk-tensor commutation)

- **Sorry trajectory**: 0 → 0 → 0 across iters 233–235 (mathlib-build mode; sorry-elimination is not the structural currency — named-stage completions are).
- **Helper accumulation**: 7 decls (iter-233, stages i–ii); 4 decls (iter-234, stage iii); 10 decls (iter-235, stage iv descent). 21 total — each batch closes a distinct named stage, not a set of wrappers around a future stage. Confirmed by reading the current `StalkTensor.lean`: all 21 private and non-private decls are present, axiom-clean, and correspond to distinct structural roles (bilinear map, descent, germ lemmas, inner/outer descent, outer descent, germ characterisation of the outer descent).
- **Recurring blockers**: "CommRingCat/RingCat carrier-duality" appeared in iter-234 (RETIRED same iter via `erw`/defeq recipe at stage iii) and re-appeared in iter-235 (the `revBihom_balanced` balancing residual). This is the same conceptual class of wall but at a new site. Critically: the fix IS already known from iter-234 — mirror `stalkTensorDescU_smul`, which solved the identical carrier-duality at the section level, now applied at the stalk level via `germ_smul`. The wall is not "unresolved for ≥3 iters"; it is a one-iter residual with a prescribed resolution.
- **Avoidance patterns**: none. Route has been active every iter; no off-critical-path reclassification; no deferral language.
- **Prover status pattern**: COMPLETE (iter-233), COMPLETE (iter-234), PARTIAL (iter-235).
- **Throughput**: ON_SCHEDULE — STRATEGY.md estimate ~4–7 iters; elapsed 4 iters (entering iter-236 as the 4th). Well within envelope.
- **CHURNING rule check**: "helpers added in ≥2 of last K iters" YES; "sorry count net unchanged" YES (0→0→0); "no structural change in approach" NO — each iter completed a distinct named stage (i–ii, iii, iv descent), with the named carrier-duality risk identified and retired (iter-234) and immediately re-applied (iter-235). The third condition fails; CHURNING does not fire.
- **PARTIAL in iter-235 is not a stall**: iter-235 completed 10 of the ~11 planned stage-iv constructions. The sole residual (`revBihom_balanced`) is documented as a named in-file comment with a precise proof sketch — not a sorry, not a wall, not a gap the prover failed to characterise. The descent framework (`revBihom`, `revBihom_germ_tmul`, all germ characterisations) is complete. The residual is one balancing identity whose fix mirrors a successful technique from one iter ago.
- **State entering iter-236**: 21 axiomatic-clean decls landed; remaining = (a) `revBihom_balanced` (balancing, 1 step, fix known), (b) `stalkTensorRev` (descend via `TensorProduct.liftAddHom`, ~5–10 LOC), (c) `stalkTensorIso` (bundle fwd+rev+two inversion identities, ~20–40 LOC). The full iso is 2–3 declarations away.
- **Verdict**: **CONVERGING**

The carrier-duality resurfacing at iter-235 is NOT a churning signal: the same recipe that retired the identical wall in iter-234 applies directly; the prover explicitly documented this fix. The pattern COMPLETE→COMPLETE→PARTIAL (10/11 decls) on a 21-total-decl build heading for a 3-decl final bundle is the canonical late-stage convergence shape. Dispatching a prover to close `revBihom_balanced`→`stalkTensorRev`→`stalkTensorIso` in iter-236 is appropriate. The planner's proposed unit (balancing→rev→iso in one round, not further sub-helper accumulation) is the right assignment.

---

### Route 2 — `Cohomology/FlatBaseChange.lean` (engine affine-lane)

- **Sorry trajectory**: 1 → 2 → 2 → 2 across iters 232–235. Net unchanged at 2 for 3 consecutive iters; 0 sorries eliminated.
- **Helper accumulation**: 1 decl (iter-232); 3 decls (iter-233, locality criteria); 0 new decls committed (iter-234, zero-commit); 0 new helper decls (iter-235, refactor agent fixed signatures + blueprint-writer, no new decl). Across K=3 iters in the current phase (233–235): 3 helpers added, 0 sorries eliminated.
- **Prover status pattern**: PARTIAL (iter-233), INCOMPLETE/zero-commit (iter-234), no-prover-dispatched / corrective-only (iter-235).
- **Recurring blockers**: "instance wall — buried Γ-actions not synthesizable" appeared once (iter-234). The iter-235 mathlib-analogist consult DISSOLVED it as a wrong-altitude symptom (not a genuine instance-synthesis problem — the issue was using the wrong API tier). Not recurring for ≥3 iters.
- **Avoidance patterns**: none — the route was actively worked every iter; the iter-235 no-prover-dispatch was the prescribed corrective (Mathlib analogy consult), not avoidance.
- **Throughput**: ON_SCHEDULE — STRATEGY.md estimate ~30–60 iters for the engine phase; elapsed 3 iters. No throughput concern.

#### Technical STUCK signal vs. genuine structural reset

The mechanical STUCK rule fires: sorry count 2→2→2 for 3 iters AND prover status window includes INCOMPLETE (iter-234). Rule text: "sorry count unchanged across K iters AND prover statuses include INCOMPLETE."

However, the rule fires on a K-window that spans two materially different approaches:
- **Old approach (abandoned)**: directly prove the Γ-level `map_smul'` compatibility at the section level via explicit `Module.compHom`/`restrictScalars` instance threading (iter-234 blocker). Every iter spent on this was in service of a theorem typed for arbitrary `F : X.Modules`, which is **false as typed** (missing `[F.IsQuasicoherent]`; confirmed by the iter-235 mathlib-analogist).
- **New approach (iter-235 onward)**: use `tilde` full-faithfulness to reduce `IsIso α` to `IsIso` of a concrete `ModuleCat R'` map, then close by `cancelBaseChange`. No section-level Module/SMul instances ever named. Single Mathlib-absent brick: `lem:pushforward_spec_tilde_iso` (`pushforward (Spec.map φ)(tilde M) ≅ tilde(restrictScalars φ M)`), which also discharges QC-of-pushforward as a corollary.

The iter-235 corrective constitutes a **genuine structural reset**, not cosmetic recipe variation:
1. Soundness defect fixed (both theorem signatures corrected; `[F.IsQuasicoherent]` added).
2. Proof route completely overhauled (wrong-altitude diagnosis; the element-level smul-dictionary approach is ABANDONED, not refined).
3. New target is a single, named, blueprint-complete lemma with a specified proof route — not "try the same thing again with a different instance."
4. Blueprint chapter reframed and verified clean (iter-235 blueprint-writer report: COMPLETE, 4 corrections applied).

The new target `lem:pushforward_spec_tilde_iso` has received 0 prover attempts. There is no K-iter window of prover data on the new approach.

**Verdict**: **UNCLEAR** — the old approach was STUCK (correctly diagnosed and corrected in iter-235); the new approach is fresh (< K iters of data, blueprint complete, proof route specified). By rule: "route is fresh (< K iters of data) OR signals are ambiguous."

Re-engagement in iter-236 is justified. The planner should watch for:
- Whether `lem:pushforward_spec_tilde_iso` hits a new instance wall at the `tilde` full-faithfulness / counit-naturality step (the analogist flagged this as the standard idiom, but `fromTildeΓNatTrans` coherence should be verified in the first prover round).
- Whether the sorry trajectory changes (it MUST close at least 1 sorry — `affineBaseChange_pushforward_iso` — if the route and closing algebra (`cancelBaseChange`) are correct).
- A zero-commit prover round on `lem:pushforward_spec_tilde_iso` in iter-236 would re-trigger the STUCK assessment and require escalation.

**No primary corrective** required this iter (the corrective was already executed; the new target is fresh).

---

## PROGRESS.md dispatch sanity

Verdict: **OK** — file count 2 within cap 10; no under-dispatch finding (directive identifies only these 2 active files; no additional ready-but-not-dispatched files named).

---

## Must-fix-this-iter

*(No CHURNING or STUCK verdicts on the current routes. No OVER_BUDGET, OVER_CAP, UNDER_DISPATCH, or BLOAT findings. Section omitted.)*

---

## Informational

**Route 1 — dispatch unit is appropriate**: the planner's "close balancing → rev → iso in one round" framing matches the structure of the remaining work. The three-step unit (revBihom_balanced, stalkTensorRev, stalkTensorIso) is small enough for a single prover round and large enough to complete the stage. Do NOT decompose further into sub-helpers — stage (iv)'s lesson is that the full descent structure arrives in one batch; the iso assembly should do the same.

**Route 2 — watch the first prover round carefully**: the mathlib-analogist's claims that `fromTildeΓNatTrans` gives `IsIso α ↔ IsIso (moduleSpecΓFunctor.map α)` and that `(Spec.map φ) ⁻¹ᵁ ⊤ = ⊤` is rfl should be verified by the prover in iter-236. If either fails, route STUCK re-diagnosis is warranted immediately (not after another zero-commit iter). The prover should commit at minimum the `lem:pushforward_spec_tilde_iso` declaration (even as a sorry-placeholder with the correct signature) and one closing step of the sorry-reduction in `affineBaseChange_pushforward_iso`; a zero-commit outcome triggers STUCK at the next progress-critic pass.

**`flatBaseChange_pushforward_isIso` (line 259)**: remains a deep sorry (Čech/affine-cover infrastructure absent from Mathlib). The planner correctly leaves this as a documented sorry this iter. The iter-236 prover target should NOT attempt this theorem.

---

## Overall verdict

Both routes are in viable states for iter-236 dispatch. Route 1 (StalkTensor) is CONVERGING — three iters of named-stage completion, 21 of ~24 planned decls landed, final bundle 2–3 decls away. Dispatch the prover to close `revBihom_balanced`→`stalkTensorRev`→`stalkTensorIso` in a single round. Route 2 (FlatBaseChange) is UNCLEAR after the iter-235 corrective reset — the old approach was STUCK (correctly diagnosed and overhauled), the new target `lem:pushforward_spec_tilde_iso` is fresh with a complete blueprint and a specified proof route. Re-engagement is justified; the planner should treat the new target cautiously (zero-commit in iter-236 is a STUCK re-trigger, not an acceptable "partial"). No avoidance patterns, no dispatch cap issues, no over-budget throughput findings.
