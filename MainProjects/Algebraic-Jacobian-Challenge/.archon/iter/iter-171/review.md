# Iter-171 (Archon canonical) — review

## Outcome at a glance

- **The "armed-trigger satisfied — `gmScalingP1` body skeleton LANDED + AVR file SPLIT" iter.** iter-170's reviewer-mandated re-attempt of the body-first test (the test that died to API-500 with 0 edits) FIRED this iter and PASSED its falsification predicate ("can the prover write the body shape?"). The iter-170 → iter-171 reversal trigger does **NOT** fire — option (c) inline chart-glue at scale remains the committed route, now with a concrete body skeleton instead of three iters of conjecture.
- **Substantive iter-171 advances** (independently verified this review via `lean_verify` + `lake build` + Grep):
  - `algebraKbarAway` (L91) — **axiom-clean** `{propext, Classical.choice, Quot.sound}`. The 3-line `Algebra.compHom kbar → ↥(𝒜 0) → Away 𝒜 f` instance that unblocks `Algebra kbar (TensorProduct kbar (Away _ _) (GmRing kbar))` synthesis. Matches `analogies/tensoraway-instance.md` Q2 verdict end-to-end.
  - `gmScalingP1_chart1_ringMap` / `gmScalingP1_chart0_ringMap` (L659, L668) — **axiom-clean**. Built via `MvPolynomial.eval₂Hom`. Chart-1 sends `u ↦ u ⊗ λ`; chart-0 sends `t ↦ t ⊗ λ⁻¹` (via `IsLocalization.Away.invSelf`).
  - `gmScalingP1_cover` (L679) — **axiom-clean**. The 2-chart cover via `(projectiveLineBarAffineCover kbar).openCover.pullback₁ (pullback.fst …)`.
  - **`gmScalingP1` body (L742) is no longer a bare `sorry`.** It is now a concrete `Over.homMk ((gmScalingP1_cover kbar).glueMorphisms (gmScalingP1_chart kbar) (gmScalingP1_chart_agreement kbar)) (gmScalingP1_over_coherence kbar)` invocation; `lean_verify` axioms `{propext, sorryAx, Classical.choice, Quot.sound}` (sorryAx propagates honestly through the three named internal helper sorries).
  - **Three named top-level scaffold sorries** factored out of the body skeleton: `gmScalingP1_chart` (L695, chart-`i` scheme morphism), `gmScalingP1_chart_agreement` (L705, cocycle), `gmScalingP1_over_coherence` (L721, over-side coherence). Each is a top-level named declaration — the body skeleton has no buried sorries, satisfying the progress-critic's PARTIAL acceptance criterion.
  - `homogeneousLocalizationAwayIso_aux_left` (L384) — body REWRITTEN from bare `sorry` to a real cancel-surjective proof that depends on one focused new helper `mvPolyToHomogeneousLocalizationAway_surjective` (L372, surjectivity claim closable in ~60-80 LOC via `Away.adjoin_mk_prod_pow_eq_top` specialised to `d=1, v=![X 0, X 1], dv=![1,1]`).
- **Dispatch MATCHED the plan — 14th consecutive iter** with no plan/dispatch contradiction. The plan specified ONE Lane A re-attempt verbatim per the iter-170 reviewer recommendation; one lane fired; the lane closed PRIMARY + SECONDARY per the planner's PARTIAL acceptance criterion.
- **Global bare-sorry 13 → 15 (NET +2)** is the expected shape (per the prover's PARTIAL projection: the body skeleton breaks one sorry into 3 named internal scaffold sorries; SECONDARY refactors `aux_left` from bare-sorry to real-body-depending-on-1-helper-sorry). Per-file inventory verified this review via Grep `^\s*sorry\s*$|:=\s*sorry`:
  - `AlgebraicJacobian/AbelianVarietyRigidity.lean` (354 LOC; refactor-split this iter) — **2** at L89 (`iotaGm_isDominant`, unchanged but file moved) and L296 (`genusZero_curve_iso_P1`, unchanged but file moved). Build line numbers point at the declaration heads L86, L290.
  - `AlgebraicJacobian/RigidityLemma.lean` (902 LOC; **NEW** this iter via refactor-split) — **0 sorries**, all Mumford chain + Cor 1.5 + Cor 1.2 declarations migrated axiom-clean.
  - `AlgebraicJacobian/Genus0BaseObjects.lean` (880 LOC) — **10** at L188, L195, L375, L624, L697, L711, L727, L766, L844, L876.
  - `AlgebraicJacobian/Jacobian.lean` — **2** unchanged.
  - `AlgebraicJacobian/RigidityKbar.lean` — **1** unchanged.
- The sorry COUNT is no longer the headline metric (per the iter-171 plan and the progress-critic `route171`). The headline metric is **body-skeleton landing on the load-bearing residual** + **`avr-split` decoupling the proven Mumford chain from genus-0 final assembly**. Both LANDED.
- `lake build AlgebraicJacobian` GREEN (sorry + long-line warnings only). `sync_leanok` ran clean (iter 171, added 0, removed 0, chapters_touched empty).

## What the iter-171 prover did, verified independently

Verified via `Read`/`Grep` on `AlgebraicJacobian/Genus0BaseObjects.lean` + `lean_verify` on each named decl + reading `.archon/logs/iter-171/provers/AlgebraicJacobian_Genus0BaseObjects.jsonl` (73 events; 4 edits):

1. Added the `algebraKbarAway` instance (L91, 3 lines body) per the `analogies/tensoraway-instance.md` Q2 recipe. Verified `lean_verify` axioms `{propext, Classical.choice, Quot.sound}` (no `sorryAx`). This is the load-bearing instance that the iter-169 prover MIS-DIAGNOSED as a missing `CommRing` instance; iter-170 mathlib-analogist `tensoraway` correctly identified it; iter-171 lands it cleanly. **KB pattern update**: confirms `Algebra.compHom`-based `kbar → 𝒜 0 → Away` chains are the right idiom and refutes the iter-169 "CommRing missing" diagnosis.
2. Added `gmScalingP1_chart1_ringMap` / `gmScalingP1_chart0_ringMap` (L659, L668) via `MvPolynomial.eval₂Hom`. Each axiom-clean. The chart-0 case uses `IsLocalization.Away.invSelf` to express the `λ⁻¹` factor — a Mathlib-canonical idiom located via 5 `grep` lookups during the lane.
3. Added `gmScalingP1_cover` (L679) via `(projectiveLineBarAffineCover kbar).openCover.pullback₁ (pullback.fst …)`. Axiom-clean. The `pullback₁` API lives in `Mathlib.AlgebraicGeometry.Cover.Directed` and `Mathlib.CategoryTheory.Sites.Hypercover.Zero:97` — both confirmed by the prover's `grep` chain (logs L51, L57, L59, L61).
4. Replaced the L693 `gmScalingP1` bare-sorry body with a concrete `Over.homMk ((gmScalingP1_cover kbar).glueMorphisms (gmScalingP1_chart kbar) (gmScalingP1_chart_agreement kbar)) (gmScalingP1_over_coherence kbar)`. Introduced THREE NEW top-level named declarations to host the now-explicit internal obligations:
   - `gmScalingP1_chart` (L695) — chart-`i` scheme morphism;
   - `gmScalingP1_chart_agreement` (L705) — cocycle on `pullback`s of `(gmScalingP1_cover).f`;
   - `gmScalingP1_over_coherence` (L721) — over-side structure map intertwining.

   Each is a top-level sorry (no buried sorries) per the progress-critic's PARTIAL acceptance criterion.
5. Rewrote `homogeneousLocalizationAwayIso_aux_left` (L384) from bare `sorry` to a real cancel-surjective body. The proof obtains `p` from `mvPolyToHomogeneousLocalizationAway_surjective kbar i x`, applies `homogeneousLocalizationAwayIso_aux_right` to get `(Away→mvPoly) ∘ (mvPoly→Away) p = p`, and finishes by `simp`. The one new helper sorry `mvPolyToHomogeneousLocalizationAway_surjective` (L372) is the FOCUSED surjectivity claim with a clear closure path (~60-80 LOC) via `Away.adjoin_mk_prod_pow_eq_top` specialised to `d=1`.
6. Rewrote three docstrings (`gmScalingP1` L729-741, `gmScalingP1_collapse_at_zero` L750-761, `homogeneousLocalizationAwayIso_aux_left` L377-383) to remove iter-169/170 "PARTIAL/escalation" prose per the iter-171 plan's stale-docstring purge.

Build / sorry inventory (verified this review):

- `lake build AlgebraicJacobian.Genus0BaseObjects` — exit 0, sorry warnings on L186, L193, L372, L624, L695, L705, L721, L762, L842, L872 (10 sorries; the prover's claim of "8 → 10 (net +2)" matches).
- `lake build AlgebraicJacobian.AbelianVarietyRigidity` — exit 0; 2 sorries unchanged at the new line numbers (L86, L290 after refactor-split).
- `lake build AlgebraicJacobian` — exit 0; 15 sorries total (`projectiveLineBar_geomIrred`, `projectiveLineBar_smoothOfRelDim`, `mvPolyToHomogeneousLocalizationAway_surjective`, `gm_grpObj`, `gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence`, `gmScalingP1_collapse_at_zero`, `gm_geomIrred`, `projGm_isReduced`, `iotaGm_isDominant`, `genusZero_curve_iso_P1`, `Jacobian.lean × 2`, `RigidityKbar.lean × 1`).

## Refactor: `avr-split` LANDED

The iter-171 plan's structural pre-work also LANDED this iter, before the prover lane fired:

- `AlgebraicJacobian/RigidityLemma.lean` (**NEW**, 902 LOC, 0 sorries) — contains the entire Mumford Form-I Rigidity Lemma chain (`rigidity_snd_lift`, `snd_left_isClosedMap`, `morphism_eq_of_eqAt_closedPoints`, `eq_comp_of_isAffine_of_properIntegral`, `isIntegral_of_retract`, `rigidity_eqAt_closedPoint_of_proper_into_affine`, `rigidity_eqOn_saturated_open_to_affine`, `rigidity_eqOn_dense_open`, `rigidity_core`, `rigidity_lemma`) + Milne §I.1 corollaries (`hom_additive_decomp_of_rigidity` = Cor 1.5, `av_regularMap_isHom_of_zero` = Cor 1.2). All migrated axiom-clean.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` (REDUCED, 354 LOC, 2 sorries) — contains only the genus-0 final assembly (`iotaGm_isDominant`, `morphism_P1_to_grpScheme_const_aux`, `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme`).
- `AlgebraicJacobian.lean` — `import AlgebraicJacobian.RigidityLemma` added.
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` `% archon:covers` extended to all three files: `AbelianVarietyRigidity.lean`, `Genus0BaseObjects.lean`, `RigidityLemma.lean`.

**Why this matters**: future Route A.4 (Albanese UP) consumers can `import AlgebraicJacobian.RigidityLemma` without pulling in `Genus0BaseObjects` and its 10 gated sorries. The proven core is now a first-class module.

## Reversal-trigger status

The iter-170 plan committed: "If iter-171 Lane A's body-first test RUNS and returns PARTIAL-no-body-skeleton, iter-172 plan agent fires the HARD PIVOT escalation."

**Falsification predicate**: "the prover cannot WRITE the body shape" — i.e. the body skeleton cannot be transcribed as an `Over.homMk + Scheme.Cover.glueMorphisms` invocation even with internal sorries.

**Result**: iter-171 prover wrote the body shape as a concrete `Over.homMk ((gmScalingP1_cover kbar).glueMorphisms _ _) _` with 3 named internal sorries. The falsification predicate is FALSE. **Reversal trigger DOES NOT fire.**

Route C with option (c) inline chart-glue at scale remains the committed strategy. iter-172 plan should advance to: (a) close `mvPolyToHomogeneousLocalizationAway_surjective` (unblocks `aux_left` axiom-clean and downstream `gmScalingP1_chart`); (b) close one of the three internal scaffold sorries (`gmScalingP1_chart kbar i` body via `pullbackSpecIso ≫ Spec.map _ ≫ Proj.awayι`); (c) open the iter-172 file-skeleton lanes B/C (Picard/RelativeSpec + RiemannRoch/WeilDivisor) per the iter-171 plan's decomposition commitment.

## Blueprint markers updated (manual)

- `AbelianVarietyRigidity.tex`, `def:gaTranslationP1` (L1144-1145): refreshed `% NOTE:` from iter-170 "still ships as a typed `sorry` THIS iter" to iter-171 "body landed as concrete `Over.homMk + Scheme.Cover.glueMorphisms` with 3 named internal sorries — chart morphism, cocycle, over-coherence — pending iter-172+ closure."
- `AbelianVarietyRigidity.tex`, `lem:gmScaling_fixes_zero` (L1206): refreshed `% NOTE:` to "gated on `gmScalingP1_chart` body landing (iter-172+); body-skeleton iter-171 PARTIAL acceptable."

(No `\leanok` writes — that is the deterministic sync's domain. No `\mathlibok` adds this iter — no new Mathlib-direct re-exports landed. No `\notready` strips — none present on prover-touched blocks.)

## Subagent dispatches this review

- `lean-auditor` dispatched (slug `iter171`, whole-project, 17 files audited) — COMPLETE. Verdict: **1 CRITICAL** excuse-comment + 5 MAJOR stale-narrative + 5 MINOR. Headline: `Jacobian.lean:237-263` carries a 28-line excuse-comment block under `genusZeroWitness.isAlbaneseFor.key`'s `sorry` claiming the proof "cannot be wired" due to three "out-of-file / plan-level" gates (import cycle, char-p, missing base-change functor). **All three gates are now INVALID** under the iter-163 Route C commitment: `AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme` (in `AbelianVarietyRigidity.lean`) is import-clean (no cycle through `Rigidity`), char-free (no `[CharZero]`), and the consumer doesn't need a base-change functor. This is the "lying to itself" pattern the rubric warns against, blocking the headline `genusZeroWitness` sorry from being closed via a now-available path. Full report at `.archon/task_results/lean-auditor-iter171.md`.
- `lean-vs-blueprint-checker` dispatched (slug `g0bo171`, file `Genus0BaseObjects.lean` vs `AbelianVarietyRigidity.tex`) — PASS overall (13 pinned signatures all match; no fake bodies; no excuse-comments; iter-171 ``cancel surjective'' iso rewrite landed exactly as the blueprint prose pre-described). 1 MAJOR finding (`mvPolyToHomogeneousLocalizationAway_surjective` — the NEW iter-171 substantive sorry — is not `\lean{...}`-pinned in the chapter; recommended action = iter-172 blueprint-writer dispatch to add a sub-lemma block) + 5 MINOR (two stale NOTEs already refreshed this review; three are low-priority blueprint-adequacy tweaks). Full report at `.archon/task_results/lean-vs-blueprint-checker-g0bo171.md`.

(Findings folded into `recommendations.md`. Full reports auto-archived to `logs/iter-171/`.)

## Subagent skips

- None. All [HIGHLY RECOMMENDED] review-phase subagents dispatched this iter.

## Blueprint-doctor

`logs/iter-171/blueprint-doctor.md` reports ONE finding: chapter `RiemannRoch_WeilDivisor.tex` (NEW this iter via `blueprint-writer rr-bridge-subbuild`) covers `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`, which does not exist. This is an expected/transient state — the iter-171 plan's decomposition commitment puts the corresponding file-skeleton lane on iter-172. **No action this review** other than flagging to the next plan agent: dispatch the Lane C file-skeleton iter-172 to clear the doctor finding.

## What ships in TO_USER

The iter-171 plan's `## Decision made` ratifies option (c) inline chart-glue at scale committed across iter-170 → iter-172, with the body-first test as the cheapest falsification signal. The signal PASSED this iter (`gmScalingP1` body skeleton landed). TO_USER banner: report the body-skeleton landing as a decision-progress milestone and confirm the project continues on Route C option (c).
