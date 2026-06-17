# Iter-172 (Archon canonical) — review

## Outcome at a glance

- **The "CHURNING-reversal test fired and returned PARTIAL-low; Lane B died to API-529 with HARD GATE clear" iter.** iter-172 plan committed three lanes (Lane A continuation on `Genus0BaseObjects.lean` per the iter-171 body-skeleton landing, Lane B file-skeleton on `Picard/RelativeSpec.lean` conditional on chapter HARD GATE, Lane C file-skeleton on `RiemannRoch/WeilDivisor.lean`). All three were dispatched. **Lane A closed 1 of 4 attacked sorries (PARTIAL-low bucket per the plan's status grid). Lane B died to `API Error: 529 Overloaded` after 4.5 minutes with 0 file edits — identical failure mode to iter-170 Lane A's API-500. Lane C LANDED cleanly with 13 KB of file-skeleton.** The progress-critic `route172` reversal trigger (PARTIAL-low: "iter-173 mathlib-analogist consult on the chart-bridge specialisation") fires.
- **Substantive iter-172 advances** (verified this review via `lean_verify` + per-file Grep):
  - `mvPolyToHomogeneousLocalizationAway_surjective` (`Genus0BaseObjects.lean:379`) — **PROVEN axiom-clean** `{propext, Classical.choice, Quot.sound}`. Per the prover's task result and the iter-167 KB "cheapest-lever" pattern: the single ~140-LOC body closure unblocks `homogeneousLocalizationAwayIso_aux_left` AND `homogeneousLocalizationAwayIso` as both now propagate axiom-clean. **Recipe**: `Algebra.adjoin_induction` over `(𝒜 0)` using Mathlib's `HomogeneousLocalization.Away.adjoin_mk_prod_pow_eq_top` specialised to `d=1, v=![X 0, X 1], dv=![1, 1]`; chain `MvPolynomial.induction_on` for the algebra-of-degree-0 generation step (auxiliary `Algebra.adjoin (𝒜 0) (Set.range v) = ⊤`); `gen_eq_pow` helper reducing `Away.mk hf a (∏ v j^ai j) _` to `(isLocalizationElem hfi hgi)^(ai (otherFin i))` via `val_injective` + `Localization.mk_eq_mk_iff` + `r_iff_exists` + ring identity.
  - `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — **NEW file** (13 KB, builds green, 6 sorry warnings). 9 `\lean{...}`-pinned declarations from `RiemannRoch_WeilDivisor.tex` scaffolded; 3 close `sorry`-free (`WeilDivisor` = `PrimeDivisor →₀ ℤ`, `degree` = `D.sum (fun _ n => n)`, `LinearEquivalence` = `∃ f hf, D - D' = principal f hf`); 6 carry typed `sorry` bodies (`RationalMap.order`, `WeilDivisor.ofClosedPoint`, `degree_hom`, `principal`, `principal_hom`, `principal_degree_zero`); 1 helper structure `Scheme.PrimeDivisor` with placeholder field `isCodim1AndIntegral : True := trivial` flagged in task result as honest scaffolding awaiting iter-173+ refinement. **Note**: prover's task result claims "`PrimeDivisor` carries a placeholder `True` that iter-173+ will refine" — verified by Grep at L74 (docstring) and L90 (the field definition).
  - `AlgebraicJacobian/Jacobian.lean` — refactor agent `jacobian-purge-excuse` cleaned the iter-171 lean-auditor CRITICAL excuse-comment block (L237-263) and refreshed the strategic docstring at L182-208 to align with Route C (`rigidity_genus0_curve_to_grpScheme` consumer). Verified by Grep: no `CANNOT be wired` / `import cycle` / `CharZero gate` text remains in the file; the refreshed docstring carries an explicit **Status (iter-172)** block listing the two residual sub-builds.
- **Lane B** — file `AlgebraicJacobian/Picard/RelativeSpec.lean` does NOT exist on disk. The Picard chapter HARD GATE was CLEARED iter-172 plan-phase by the scoped `blueprint-reviewer picard-scoped172` (PASS verdict; one `soon`-severity TODO on `thm:relative_spec_univ` proof prose, NOT blocking the file-skeleton lane). Prover session terminated at `2026-05-22T06:24:17.119569Z` with `API Error: 529 Overloaded` after 13 turns; the prover only `mkdir`-ed the `AlgebraicJacobian/Picard/` directory before the session died. The blueprint-doctor flagged the resulting orphan-cover at `Picard_RelativeSpec.tex` (chapter covers a non-existent file) — informational only this iter, will resolve when Lane B re-fires iter-173.
- **Dispatch MATCHED the plan — 15th consecutive iter** with no plan/dispatch contradiction. The plan specified 3 lanes; 3 fired; 1 LANDED, 1 PARTIAL-low, 1 API-529. No prover-lane mis-scope.
- **Global bare-sorry 15 → 20 (NET +5)** is the expected shape per the plan's PARTIAL-low + file-skeleton landing projections. Per-file inventory verified via Grep this review (`^\s*sorry\s*$|:=\s*sorry`):
  - `AlgebraicJacobian/AbelianVarietyRigidity.lean` — **2** (unchanged; L89 + L296).
  - `AlgebraicJacobian/RigidityLemma.lean` — **0** (unchanged).
  - `AlgebraicJacobian/RigidityKbar.lean` — **1** (unchanged).
  - `AlgebraicJacobian/Jacobian.lean` — **2** (unchanged; bodies of `genusZeroWitness.key` and `positiveGenusWitness` — neither was a prover target this iter).
  - `AlgebraicJacobian/Genus0BaseObjects.lean` — **10 → 9** (−1: PRIMARY 1 closed at L372→L379; remaining at L188, L195, L768, L847, L861, L877, L916, L994, L1026).
  - `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — **NEW; 6** (L133, L163, L197, L218, L233, L254).
  - **Total**: 2 + 0 + 1 + 2 + 9 + 6 = **20**.

## The advances, independently verified this review

1. **PRIMARY 1 `mvPolyToHomogeneousLocalizationAway_surjective` axiom-clean.** Verified by reading `Genus0BaseObjects.lean:379-486` and running `lake build AlgebraicJacobian.Genus0BaseObjects` (exit 0; sorry warnings only on the other 9 sorries). The body uses NO custom axioms, NO `sorry`, and chains through `Mathlib.RingTheory.GradedAlgebra.HomogeneousLocalization` infrastructure that exists in the project's Mathlib pin.
2. **`homogeneousLocalizationAwayIso` axiom-clean propagation.** The iter-171 prover wrote `aux_left`'s body as a `cancel-surjective` proof depending on the new `mvPolyToHomogeneousLocalizationAway_surjective` helper. With the helper now axiom-clean, both `aux_left` and the iso itself propagate axiom-clean. Confirmed by the prover's task_result (`Genus0BaseObjects.lean.md` §"Axiom-cleanliness verification"); to be re-verified by the in-flight `lean-vs-blueprint-checker g0bo172` (running at review-time).
3. **`RiemannRoch/WeilDivisor.lean` file-skeleton landed.** Verified by Read + `lake env lean AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (exit 0, 6 sorry warnings at L133/L163/L197/L218/L233/L254). All 9 `\lean{...}` pins from `RiemannRoch_WeilDivisor.tex` are present in the file at the expected namespaces (`AlgebraicGeometry.Scheme.*`). sync_leanok added 9 `\leanok` markers to the chapter (per `.archon/sync_leanok-state.json`, `chapters_touched: ["RiemannRoch_WeilDivisor.tex"]`, `added: 9`).
4. **Refactor `jacobian-purge-excuse` LANDED.** Verified by reading `Jacobian.lean:175-263` (post-edit): the L237-263 excuse-comment block is GONE; L182-208 docstring rewritten to a 22-line Route C narrative naming `rigidity_genus0_curve_to_grpScheme` as the consumer; the strategic **Status (iter-172)** block enumerates two residual sub-builds (G0BO body-skeleton internal sorries; `k → k̄` pullback / descent step).

## Plan-phase critic verdicts — read into this iter

- **strategy-critic `route172`** (running plan-phase, fresh-context audit of STRATEGY.md): **7 CHALLENGES** issued. Route A.1 phantom claim ("prover-ready chapter not on disk"), A.2 single-row hides parallelism, A.4 bypass-question unresolved (concrete audit dispatched same-iter via `a4-bypass-audit` → outcome (b) BYPASS FAILS), RR-bridge needs 4 sub-rows, Route A overall asserted parallelism not exercised, `Scheme.Cover.glueMorphisms` exact Mathlib name nit (verified working iter-171). STRATEGY.md was restructured plan-phase (12 Phases rows) to address.
- **progress-critic `route172`** (running plan-phase): **Route 1 CHURNING** (qualified — 3-of-4 PARTIAL by strict status rule; iter-171 structural break genuine; iter-172 = make-or-break test). **Route 2 STUCK** (5+ iters deferral; 2 writer failures iter-171). **Route 3 UNCLEAR** (fresh post-commitment, healthy). Throughput verdict: Route 1 OVER_BUDGET (`Iters left ~3-5` estimate vs 7 elapsed at iter-171 close; revised to `~4-7`).
- **blueprint-reviewer `route172` / `picard-scoped172`** (both running plan-phase): whole-blueprint audit + Picard scoped HARD GATE. PASS for Picard chapter; 9 unstarted-phase chapter proposals (8 deferred to iter-173+ for plan-phase saturation).
- **blueprint-writer `surjective-pin`**: LANDED — new `\lean{...}` pin on `mvPolyToHomogeneousLocalizationAway_surjective` (AVR.tex L1140-1182) + NOTE refreshes on `def:proj_chart_ring_iso` + `lem:proj_chart_ring_iso_aux_left`.
- **blueprint-writer `route-a1-retry2`**: LANDED — 449-line `Picard_RelativeSpec.tex` chapter on disk with 5 verbatim Stacks-Project quotes + 1 `soon`-severity TODO on lemma-spec proof.
- **blueprint-writer `a4-bypass-audit`**: LANDED with verdict **outcome (b) — bypass FAILS** (Milne III §6 Prop 6.1 invokes Thm 3.2 directly; the autoduality-via-cube detour was excised iter-163; Auslander–Buchsbaum sub-build inherited as A.4 dependency). STRATEGY.md A.4 row updated to dual `Iters left ~22-35`, `~2500+ LOC`.
- **refactor `jacobian-purge-excuse`**: LANDED (described above).

## Plan-phase vs review-phase subagent split this iter

| Phase | Subagent | Slug | Status |
|---|---|---|---|
| plan | strategy-critic | route172 | landed, 7 CHALLENGES, all addressed in STRATEGY.md restructure |
| plan | progress-critic | route172 | landed, Route 1 CHURNING / Route 2 STUCK / Route 3 UNCLEAR |
| plan | blueprint-reviewer | route172 | landed, 9 unstarted-phase proposals |
| plan | blueprint-reviewer | picard-scoped172 | landed, HARD GATE PASS |
| plan | blueprint-writer | surjective-pin | landed |
| plan | blueprint-writer | route-a1-retry2 | landed (3rd attempt successful) |
| plan | blueprint-writer | a4-bypass-audit | landed (verdict (b)) |
| plan | refactor | jacobian-purge-excuse | landed |
| review | lean-auditor | iter172 | LANDED: 1 must-fix (`PrimeDivisor.isCodim1AndIntegral : True`), 3 major (3 stale-narrative headers carry-over from iter-171), 3 minor. iter-171 `Jacobian.lean` excuse-comment headline FULLY RESOLVED by refactor agent. |
| review | lean-vs-blueprint-checker | g0bo172 | LANDED: 0 must-fix, 1 major (3 named scaffold sorries lack per-decl `\lean{...}` pins — chapter coverage gap), 3 minor. PRIMARY 1 closure verified 1:1 with chapter sketch. |
| review | lean-vs-blueprint-checker | wd172 | LANDED: 7 must-fix (1 placeholder `True` + 6 sorry-bodies on substantive declarations) — strict-rubric reading; 6 of the 7 are iter-172-scheduled scaffolds and not regressions. 4 major (signature looseness traceable to blueprint under-specification). 1 minor. **Blueprint adequacy failure**: chapter under-specifies prime-divisor encoding + Hartshorne's $(*)$. |
| review | lean-vs-blueprint-checker | jacobian172 | LANDED: 0 must-fix, 1 major (blueprint internal inconsistency: 3 paragraphs at `Jacobian.tex` L344/L384-390/L425-427 still carry pre-audit "A.4 bypass-holds" prose vs the iter-172 audit at L574-602+L656), 1 minor (stale `Jacobian.lean:120-126` line-number ref at L556). Refactor cleanup verified. |

## CHURNING-reversal test result

iter-172 plan: "Lane A must close ≥2 of 3 PRIMARY scaffolds for Route 1 CHURNING to reverse; <2 fires iter-173 mathlib-analogist consult."

**Result: 0 of 3 PRIMARY scaffolds closed (PRIMARY 1 was a separate helper, not a scaffold).** The status grid bucket is **PARTIAL-low** (PRIMARY 1 alone). Per the progress-critic `route172` corrective: **iter-173 mathlib-analogist consult fires** on the chart-bridge specialisation `(gmScalingP1_cover).X i ≅ Spec((Away 𝒜 X_i) ⊗[kbar] (GmRing kbar))` before any further prover round on PRIMARY 3.

The prover's task_result correctly identifies the gating: "the source type `(gmScalingP1_cover kbar).X i = pullback (pullback.fst PLB.hom Gm.hom) (Proj.awayι _ (X i) _)` is an abstract pullback over `Proj 𝒜 = PLB.left`, while `pullbackSpecIso` operates on pullbacks of `Spec.map (algebraMap kbar _)` morphisms; bridging needs a structural lemma." This is a precise, action-able description of the next-iter unblocker.

**However**: the plan's PRIMARY 2 hint ("can land independently — chart referenced but not unfolded inside the proof") is **PROVED WRONG** by the prover's mental analysis. The plan's claim was based on misreading the goal structure; in fact `(cover.glueMorphisms gmScalingP1_chart _) ≫ PLB.hom` does unfold to a chart-dependent equation under `Scheme.Cover.hom_ext`. This is recorded as a planner-side discrepancy for the iter-173 planner to absorb.

## Lane B external-failure-mode pattern (iter-170 → iter-172 streak)

This is the **SECOND** consecutive plan-cycle where an external Anthropic API outage killed a prover lane mid-run with zero file edits. Pattern:

| iter | lane | API code | duration | edits |
|---|---|---|---|---|
| 170 | A (G0BO body-first) | 500 | 251s / 22 turns | 0 |
| 172 | B (Picard A.1.a skeleton) | 529 | 275s / 13 turns | 0 |

**Reversal trigger does NOT fire** — per iter-170 review's rule, external-API failure mode tests nothing about the route. iter-173 re-dispatches Lane B verbatim. The HARD GATE clearance from iter-172 still stands (chapter on disk; reviewer PASSED; scoped fast-path NOT needed iter-173 since the chapter content has not changed).

The KB pattern "armed-trigger DOES NOT fire under external-API failure" — landed iter-170 review — applies cleanly. iter-173 plan should NOT count this as a route-falsification signal.

## Knowledge Base — new entries from iter-172

1. **PARTIAL-low bucket on a body-skeleton route can still close 1 axiom-clean helper that unblocks downstream synthesis chains.** PRIMARY 1's closure unblocks `aux_left` + the iso axiom-clean; this is the iter-167 "cheapest-lever" KB pattern realized end-to-end. Detection: when a CHURNING-reversal test underperforms its target bucket but lands a single load-bearing helper that propagates `sorryAx`-removal through 2+ downstream consumers, the route is NOT churning — it is closing serially. Re-classify accordingly.
2. **`Algebra.adjoin_induction` + `MvPolynomial.induction_on` chain for `Algebra.adjoin (𝒜 0) (Set.range v) = ⊤` proofs over a homogeneous-polynomial ring's degree-0 piece.** Concrete recipe used by iter-172's PRIMARY 1: `top_unique` + `intro p _` + `refine MvPolynomial.induction_on p ?C ?add ?mulX` chaining `Subalgebra.{algebraMap_mem, add_mem, mul_mem}` (NOT bare `algebraMap_mem` / `add_mem` / `mul_mem` — caused "synthetic hole" elaboration errors). The C-case bridge uses `SetLike.GradeZero.algebraMap_apply` + `Subalgebra.algebraMap_mem`. Reusable for any "polynomial-ring generated over its constant subring" claim in a `Proj`-chart context.
3. **`HomogeneousLocalization.val_pow` is the dedicated `val (x^n) = x.val^n` lemma — `RingHom.map_pow` / `_root_.map_pow` fails since `val` is a function, not bundled as a RingHom.** New iter-172 trap-saver. When the `val`-injection-into-`Localization` lemma needs to chain with a power, reach for `HomogeneousLocalization.val_pow` directly; `map_pow` variants metavariable-fail because `val` is not bundled. Located at `Mathlib/RingTheory/GradedAlgebra/HomogeneousLocalization.lean:456`.
4. **`Fin.ext + omega` substitution is cleaner than `fin_cases i` for explicit-index reduction.** The iter-172 prover discovered: `fin_cases i` keeps the `⟨0, _⟩` / `⟨1, _⟩` form which doesn't reduce `otherFin` cleanly. Use `have : i.val = 0 ∨ i.val = 1 := by omega; rcases ... with hi | hi; have : i = (0 : Fin 2) := Fin.ext hi; subst this` for cleaner substitution. Reusable for any `Fin 2`-indexed case-split in the gmScaling cluster.
5. **Second consecutive iter where an Anthropic API 5xx killed a prover lane mid-run with zero file edits (iter-170: 500 / Lane A G0BO; iter-172: 529 / Lane B Picard).** The KB-recorded "reversal trigger DOES NOT fire under external-API failure" pattern now has 2 data points. Detection rule: when a prover task_result is the harness's `error` status and the log's final event is an `API Error: 5XX` text-block, the lane LITERALLY did not falsify the route — it terminated mid-test. The plan reviewer must NOT count this as a CHURNING signal; iter-(N+1) re-dispatches the lane verbatim (with same HARD GATE state, same objectives).
6. **`sync_leanok` did not add `\leanok` to `AbelianVarietyRigidity.tex` despite three proof-block closures landing axiom-clean this iter.** Observed iter-172: `mvPolyToHomogeneousLocalizationAway_surjective` (declaration is `private`), `homogeneousLocalizationAwayIso_aux_left`, `homogeneousLocalizationAwayIso` all now propagate axiom-clean from the iter-172 PRIMARY 1 close, but `.archon/sync_leanok-state.json` shows `chapters_touched: ["RiemannRoch_WeilDivisor.tex"]` only. Potential causes: (a) sync_leanok may not track `private` declarations; (b) sync_leanok may treat axiom-cleanness via sorry-counting alone rather than per-decl axiom verification (so an axiom-clean body containing a `by`-block whose elaborated term has no `sorryAx` may not be detected). Action: flagged in iter-172 `recommendations.md` for iter-173 doctor investigation. **Do not paper over** by manually adding `\leanok` per the review-agent directive ("`\leanok` is owned by `sync_leanok`").

## Subagent skips

(None this review — both highly-recommended subagents `lean-auditor` and `lean-vs-blueprint-checker` dispatched per the catalog. All 4 dispatches (1 auditor + 3 checkers) returned reports; findings are folded into `recommendations.md`.)

## Subagent findings — consolidated

### Lean-auditor `iter172` (whole-project audit)

- **must-fix-this-iter (1)**: `Scheme.PrimeDivisor.isCodim1AndIntegral : True := trivial` (RR/WeilDivisor.lean L90) — weakened-wrong definition; `Scheme.WeilDivisor X` is structurally the free abelian group on **all** points of `X`. Mitigation: no project file currently consumes `WeilDivisor`/`PrimeDivisor` (verified via Grep — only umbrella imports).
- **major (3)**: 3 iter-171 stale-narrative blocks still open (`RigidityKbar.lean:8-46`, `Cotangent/GrpObj.lean:14-83 + :297-326`, `Cotangent/ChartAlgebra.lean:36-79` — each presents demoted-off-path routes as live).
- **minor (3)**: `push Not at h` non-idiomatic vs `push_neg`; `Cotangent/GrpObj.lean:138-161` long docstring; `RiemannRoch/WeilDivisor.lean:6` `import Mathlib` could be tightened.
- **iter-171 CRITICAL `Jacobian.lean` excuse-comment block (L237-263)** → FULLY RESOLVED by refactor agent `jacobian-purge-excuse`. Verified by re-read.

### Lean-vs-blueprint-checker `g0bo172` (Genus0BaseObjects ↔ AVR.tex)

- **must-fix-this-iter (0)**.
- **major (1)**: blueprint coverage gap — 3 named scaffold sorries (`gmScalingP1_chart`, `_chart_agreement`, `_over_coherence`) named in NOTE comments but not pinned individually. Recommend per-decl `\lean{...}` pins so sync_leanok / `\notready` machinery can track.
- **minor (3)**: `mvPolyToHomogeneousLocalizationAway_surjective` + `homogeneousLocalizationAwayIso_aux_left` declared `private` (Lean 4 doesn't mangle private names, but external consumers can't import — acceptable since both fold into the public iso); `projGm_isReduced` docstring "Mathlib gap" framing potentially stale (iter-168 closed `projectiveLineBar_isReduced` via the same route); `projectiveLineBar_isProper`, ring maps, cover, `pointOfVec` could be promoted to chapter pins.
- **PRIMARY 1 closure verified 1:1 with chapter sketch `lem:mvPoly_to_homogeneousLocalization_away_surjective`.** The iter-172 blueprint NOTE at AVR.tex L1105-1114 correctly tracks the new status (iso's residual `sorryAx` taint retired).

### Lean-vs-blueprint-checker `wd172` (RiemannRoch/WeilDivisor ↔ chapter)

- **must-fix-this-iter (7, strict-rubric)**: 1 `True := trivial` placeholder + 6 sorry-bodies on substantive declarations. 6 of the 7 are iter-172-scheduled scaffold sorries (file-skeleton lane explicitly chartered to produce them, not regressions). The 1 genuine issue is the `True` placeholder.
- **major (4)**: signature-looseness on `ofClosedPoint` (missing curve hypothesis), `order` / `principal` / `principal_hom` (missing `(*)` regularity), `degree` (broader than chapter pin); chapter lacks `\lean{...}` reference to substantive helper `Scheme.PrimeDivisor`.
- **minor (1)**: `LinearEquivalence` defined as binary `Prop` but the equivalence-relation claim is not exposed as Mathlib `Equivalence` instance.
- **Blueprint adequacy failure**: chapter under-specified for prime-divisor encoding + Hartshorne's $(*)$ — no Mathlib predicate pinned. **Recommend iter-173 blueprint-writer dispatch** to add a `def:prime_divisor` block with explicit `\lean{...}` pin + concrete `(*)` hypothesis predicate.

### Lean-vs-blueprint-checker `jacobian172` (Jacobian.lean ↔ chapter)

- **must-fix-this-iter (0)**.
- **major (1)**: blueprint internal inconsistency — 3 paragraphs at `Jacobian.tex` L344, L384-390, L425-427 still carry pre-audit "A.4 bypass-holds / no new Mathlib namespace" prose, contradicting the iter-172 A.4 audit at L574-602 + L656 (outcome (b) — bypass FAILS, A.4 inherits Thm 3.2 + Lemma 3.3 + Auslander-Buchsbaum sub-build).
- **minor (1)**: stale `Jacobian.lean:120-126` line-number reference at chapter L556 (helper `geometricallyIrreducible_id_Spec` now at L134-140).
- **Refactor `jacobian-purge-excuse` verified clean**: the L237-263 excuse-comment block is gone; `genusZeroWitness` docstring at L176-197 aligns with Route C; `Status (iter-172)` block accurately describes residual gates.

## Forward-look for iter-173

- **Lane A continuation** on `Genus0BaseObjects.lean`: gated by the progress-critic-mandated `mathlib-analogist` consult on the pullback-bridge specialisation. After analogist returns, PRIMARY 3 (chart-i scheme morphism) becomes attemptable now that `homogeneousLocalizationAwayIso` is axiom-clean. PRIMARY 2 (over-coherence) becomes attemptable AFTER PRIMARY 3 lands (the planner-side independence claim was disproved this iter).
- **Lane B re-dispatch** on `Picard/RelativeSpec.lean` (verbatim): chapter on disk, HARD GATE clear, mechanical file-skeleton. ~100-200 LOC of stubs.
- **Lane C body-fills** on `RiemannRoch/WeilDivisor.lean`: candidates for iter-173 PRIMARY = `degree_hom` (pure Finsupp, no scheme content) + `ofClosedPoint` (curve-specific closed-point → prime-divisor bijection). Body-bearing decls `principal`, `order`, `principal_hom`, `principal_degree_zero` are gated on the `Scheme.dvrOfPrimeDivisor` helper + RR.2/RR.3/RR.4 chapter writers.
- **Picard chapter `% SOURCE QUOTE PROOF: TODO`** at `thm:relative_spec_univ`: soon-severity, blocks the future implementation lane (NOT iter-173's file-skeleton re-attempt). iter-173 plan may dispatch the writer to fill the verbatim L553-L599 quote from `references/stacks-constructions.tex` if any body lane on this proof is scheduled iter-174+.
- **`sync_leanok` AVR-chapter miss** flagged for iter-173 doctor investigation.

## Compile-status snapshot

- `lake build AlgebraicJacobian` → green (sorry warnings only on 9 Genus0BaseObjects + 6 RiemannRoch/WeilDivisor + 2 AbelianVarietyRigidity + 2 Jacobian + 1 RigidityKbar = 20 sorries on file).
- `lake build AlgebraicJacobian.Genus0BaseObjects` → green, 9 sorry warnings.
- `lake build AlgebraicJacobian.RiemannRoch.WeilDivisor` → green, 6 sorry warnings.
- `lake build AlgebraicJacobian.AbelianVarietyRigidity` → green, 2 sorry warnings.
- `lake build AlgebraicJacobian.RigidityLemma` → green, 0 sorry warnings.
- New `axiom`s added this iter: **0**. Protected-signature touches: **0**.
