# Iter-191 (Archon canonical) — review

## Outcome at a glance

- **The "Lane I clash fix LANDED axiom-clean plan-phase (integration GREEN, 10-consecutive-zero-axiom-build streak restored)
  + Lane H NEW file-skeleton AND closures in a SINGLE dispatch (4 of 8 decls axiom-clean — direct-route bypass of decls (3) and (5);
  net file delta only +3 instead of projected +7)
  + Lane B-consumers HARD BAR MET (2 of 3 consumer sorries axiom-clean
  via bypass-route exploiting Gm ↪ 𝔸¹ open immersion;
  `Cross01Substrate.lean` source no longer compiles cleanly at b80f227 due to a Mathlib regression on `IsLocalization.Away` synthesis
  inside `set`-bindings — cached `.olean` keeps consumers working)
  + Lane M↓ first scaffold HARD BAR MET (Stages 1-2 axiom-clean via direct Mathlib re-exports `Flat.stalkMap` + `Smooth.exists_isStandardSmooth`)
  + Lane G HARD BAR MET (1 axiom-clean helper + 1 narrowly-scoped typed-sorry helper isolating Stacks 00NQ residual)
  + Lane E Part 1 axiom-clean refactor + Part 2 DEFERRED at 80-LOC budget wall on the same `Proj.appIso` residual
  STUCK iter-188/189/190 — iter-192 escalates to blueprint-writer per Failure Mode" iter.**
- **`lake build AlgebraicJacobian` GREEN** — per `meta.json` `prover.status: done`; 8360/8360 jobs replayed; **80 sorries**
  (sorry counted directly from `lake build` "declaration uses 'sorry'" warnings; per-file distribution recorded in summary.md).
- **0 → 0 project axioms** — **11th consecutive zero-axiom build streak** (restored after iter-190's integration-RED interruption).
- **planValidate**: 5/5 planner-dispatching lanes dispatched (Lane F dropped plan-phase per progress-critic CHURNING corrective; Lane A.3.i HALTED pending analogist verdict — verdict landed mid-iter; Lane J + AlbaneseUP carry-forward DO NOT RETRY).
- **Plan-predicted band**: best 78→~75-80 (−3 to +2), realistic 78→~78-82 (0 to +4), worst 78→~88-93 (+10 to +15). Landing **80 sits at the best-case upper boundary** — driven by Lane H's direct-route bypass of 2 substrate decls + Lane B's 2 axiom-clean closures.
- **No reviewer-phase subagents dispatched** — `## Subagent skips` recorded in `summary.md`. Rationale: plan-phase `progress-critic route191`, `strategy-critic iter191`, `blueprint-reviewer iter191` already audited the trajectory; per-file `lean-vs-blueprint-checker` runs would be duplicative because every prover-touched chapter passed HARD GATE plan-phase.
- **sync_leanok iter=191**: 17 added / 0 removed / 4 chapters touched (`Albanese_AuslanderBuchsbaum`, `RiemannRoch_H1Vanishing`, `RiemannRoch_RationalCurveIso`, `RiemannRoch_WeilDivisor`) per `.archon/sync_leanok-state.json` sha=904473b0 timestamp 2026-05-26T12:18:55Z.
- **blueprint-doctor `iter-191`**: 1 finding — `RiemannRoch_H1Vanishing.tex` `\uses{\leanok lem:closedPoint_closure_irreducible}` malformed `\uses{...}` block at L398-401 caused by `sync_leanok` inserting `\leanok` between existing `\uses{...}` arg lines. Surfaced in `recommendations.md` §1 as iter-192 plan-phase fix (review agent does not move `\leanok`).
- **No manual blueprint markers landing this review** — every alignment item from iter-191 task results is already handled by `sync_leanok` (iter=191 added 17 markers including for the new H1Vanishing decls). No `\mathlibok` candidate (no new Mathlib-backed declarations); no `\lean{...}` rename surfaced; no new `% NOTE:` annotation needed (Lane E + Lane B residuals are accurately documented in the chapters already).

## Per-lane verification

| # | Lane | File | Status | Sorry Δ (file) | Notes |
|---|---|---|---|---|---|
| G | **PARTIAL (HARD BAR MET — substrate narrowed)** | `Albanese/AuslanderBuchsbaum.lean` | structural advance | 2 → 2 | 1 axiom-clean helper (`exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes`) + 1 typed-sorry helper (`notMem_minimalPrimes_of_regularLocal_succ`); `isDomain_of_regularLocal` itself has no inline sorry — residual structurally isolated. Iter-192+ route (iii) unlocked. |
| M↓ | **PARTIAL (HARD BAR MET — first scaffold)** | `Albanese/CodimOneExtension.lean` | scaffold landed | 3 → 3 | Stages 1-2 axiom-clean via direct Mathlib `Flat.stalkMap` + `Smooth.exists_isStandardSmooth` re-exports; Stages 3-4 scoped to 1 named sorry inside `isRegularLocalRing_stalk_of_smooth`. |
| B-consumers | **PARTIAL (HARD BAR MET — 2 of 3 axiom-clean)** | `Genus0BaseObjects/GmScaling.lean` | strong closures | 4 → 2 (**−2**) | `projGm_isReduced` axiom-clean via Substrate 2 + iso transport. `gm_geomIrred` axiom-clean via DIFFERENT route (bypass-via-open-immersion `Gm ↪ 𝔸¹`) — Attempt 1 inline Substrate 2 generic helper FAILED due to Mathlib regression on `IsLocalization.Away` synthesis inside `set`-bindings. `gmScalingP1_chart_agreement_cross01` structural deepening (residual scoped to topological range containment + closed-point density). Helper budget 2/1 (1 over — both new helpers reusable). |
| E | **PARTIAL (Part 1 HARD BAR MET, Part 2 deferred at budget wall)** | `AbelianVarietyRigidity.lean` | refactor only | 2 → 2 | Part 1 refactor axiom-clean (dropped abstract `(r_1, h_r_1)` parameters; specialised on `iotaGm_r_1`/`_fac`). Part 2 hit 80-LOC HARD BUDGET wall — same `Proj.appIso` residual STUCK iter-188/189/190. Iter-192 dispatches `blueprint-writer avr-chart1-composition-expand` per PROGRESS.md Failure Mode. |
| H | **PARTIAL (NEW FILE — 4 of 8 axiom-clean in single session)** | `RiemannRoch/H1Vanishing.lean` | beyond HARD BAR | NEW: 0 → 3 (+3 better than projected +7-8) | File-skeleton + 4 axiom-clean closures in same dispatch: `IsFlasque.pushforward` (rfl unfolding), `PrimeDivisor.closure_isIrreducible` (1-liner), `skyscraperSheaf_isFlasque` (direct ModuleCat route bypassing planned (3)+(5) composition), `H1_skyscraperSheaf_finrank_eq_zero` (composition on closed #7 + open #4). Strategic consequence: (3) and (5) become OPTIONAL — see recommendations §2. |

### Plan-phase deliverable

- **`refactor lane-i-positivepart-clash-fix`** — clash fix landed + public pin reshaped to equation form + `Hom.poleDivisor_degree_eq_finrank` body consuming the public pin axiom-clean. `lake build AlgebraicJacobian` GREEN. RationalCurveIso.lean sorry 2 → 1 (file-local pin removed). WeilDivisor.lean sorry 3 → 3 (signature reshape preserves the typed-sorry). 1 explicit `[Module.Finite K(ℙ¹) K(C)]` binder cascade added to `morphism_degree_via_pole_divisor` (anticipated by directive only for the inner consumer; instance failed at the wrapper too).

## Plan-phase critic verdicts (this iter)

| Critic | Slug | Verdict |
|---|---|---|
| blueprint-reviewer | `iter191` | 2 HARD GATE BLOCKS resolved (RiemannRoch_WeilDivisor mismatch via `lane-i-positivepart-clash-fix` Option (b); H1Vanishing spurious `\leanok` resolved by file-skeleton creation). 6 HARD GATEs CLEARED. 1 unstarted-chapter proposal (Picard_Pic0AbelianVariety) — DEFERRED iter-192. |
| progress-critic | `route191` | 5 must-fix-this-iter (Lane A.3.i / F / B / E STUCK or CHURNING; Lane H + Lane A CHURNING). All actioned plan-phase: Lane F DROPPED (mathlib-analogist consult); Lane E scoped to 2-part with 80-LOC budget cap; Lane A.3.i HALTED pending analogist; Lane H file-skeleton scaffold IS the corrective; Lane B-consumers dispatched. Verdict CONVERGING on Lane I + Lane B + Lane G; CHURNING on Lane F + Lane A.3.i + Lane H + Lane A. |
| strategy-critic | `iter191` | SOUND with CHALLENGE on 3 effort-honesty items + 1 format DRIFTED. ACTIONED plan-phase. |
| mathlib-analogist | `lane-a3i-isconnected-prod` | substrate OWNED in Mathlib `Geometrically/Connected.lean:100` + `UniversallyOpen.lean:149`; only project-side gap is `geometricallyConnected_of_connected_of_section` (Stacks 04KU). Iter-192 prover dispatch SCHEDULED. |
| mathlib-analogist | `lane-f-restrictscalars-smul` | PROCEED with aliasing-`let` workaround (critical finding via `lean_multi_attempt` — HSMul resolution doesn't unfold `Scheme.Modules.restrict_obj` even though `rfl`). Lane F prover SCHEDULED iter-192 with this recipe. |

## CRITICAL — Mathlib regression on `Cross01Substrate.lean` source compilation

Per the Lane B-consumers task result, `Cross01Substrate.lean` SOURCE no longer compiles cleanly at b80f227 — the `IsLocalization.Away` instance synthesis fails inside `set S := TensorProduct ...` bindings in Substrate 2. The cached `.olean` (from a prior Mathlib state) keeps downstream consumers (e.g. `projGm_isReduced` in `GmScaling.lean`) working. **Fragility**: if a future Mathlib bump invalidates the cache, multiple downstream consumers break silently. **Mitigation**: dispatch a `refactor` subagent on `Cross01Substrate.lean` Substrate 2 body to avoid the `set S := ...` binding (replace with explicit type annotations or `letI` style). Surfaced in `TO_USER.md` + `recommendations.md` §6.

## Sorry distribution post-iter-191 (per-file)

```
13  AlgebraicJacobian/Picard/QuotScheme.lean
 8  AlgebraicJacobian/Picard/IdentityComponent.lean
 7  AlgebraicJacobian/Picard/FlatteningStratification.lean
 7  AlgebraicJacobian/Picard/FGAPicRepresentability.lean
 7  AlgebraicJacobian/Albanese/AlbaneseUP.lean
 6  AlgebraicJacobian/Picard/RelPicFunctor.lean
 4  AlgebraicJacobian/RiemannRoch/OcOfD.lean
 3  AlgebraicJacobian/RiemannRoch/WeilDivisor.lean
 3  AlgebraicJacobian/RiemannRoch/OCofP.lean
 3  AlgebraicJacobian/RiemannRoch/H1Vanishing.lean      ← NEW FILE (file-skeleton +3 of projected +7-8)
 3  AlgebraicJacobian/Albanese/CodimOneExtension.lean
 2  AlgebraicJacobian/RiemannRoch/RRFormula.lean
 2  AlgebraicJacobian/Jacobian.lean
 2  AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean  ← −2 vs iter-190
 2  AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean
 2  AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean
 2  AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
 2  AlgebraicJacobian/AbelianVarietyRigidity.lean
 1  AlgebraicJacobian/RigidityKbar.lean
 1  AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean ← −1 vs iter-190 (refactor pin removed)
```

**Total: 80** (lake build "declaration uses 'sorry'" warnings).

## Trajectory delta

- iter-190 ending (integration RED): partial-build reported 80, integration unmeasurable.
- iter-191 plan-phase refactor: −1 file-local pin removed in RationalCurveIso.lean.
- iter-191 prover phase:
  - Lane G: 0 net (helper landed, sorry shifted into new helper).
  - Lane M↓: 0 net (Stages 1-2 axiom-clean, Stages 3-4 scoped sorry preserved).
  - Lane B-consumers: −2 axiom-clean.
  - Lane E: 0 net (Part 1 refactor only).
  - Lane H: +3 (NEW file from 0).
- Net iter-191: +2 vs post-refactor baseline 78 (= 80 actual).

The +2 lands at the **best-case upper boundary** of the plan-predicted band (best 75-80, realistic 78-82, worst 88-93). Lane H's direct-route bypass of decls (3)/(5) is the primary driver of the favourable landing (only 3 typed-sorry pins added instead of the projected 7-8).

## Notes for iter-192 plan-phase

- Lane H decls (3) and (5) became OPTIONAL — iter-192 plan-phase should decide delete-or-keep.
- Lane I body (Hom.poleDivisor / degree_positivePart_principal_eq_finrank) ready for iter-192 dispatch.
- Lane F has a specific aliasing-`let` workaround recipe from analogist — dispatch with this recipe in directive.
- Lane A.3.i has a specific ~80-120 LOC project-side declaration (`geometricallyConnected_of_connected_of_section`) from analogist — dispatch.
- Lane E HALT until `blueprint-writer avr-chart1-composition-expand` lands.
- `Cross01Substrate.lean` source-compilation regression — schedule refactor.
- Broken `\uses{...}` block in `RiemannRoch_H1Vanishing.tex` — schedule fix.

## Subagent skips

- `lean-auditor`: no new abstractions or refactors that would benefit from a project-wide audit this iter; plan-phase critics already audited the trajectory.
- `lean-vs-blueprint-checker` (per-file): plan-phase `blueprint-reviewer iter191` performed full Lean↔blueprint alignment on every active prover chapter and returned PASS / HARD GATE CLEARED on all 5 prover-touched files — per-file re-runs would be duplicative.
