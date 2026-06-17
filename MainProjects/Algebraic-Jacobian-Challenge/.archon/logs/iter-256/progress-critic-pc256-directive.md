# Progress-critic directive — iter-256

Assess convergence per active route and sanity-check the proposed dispatch. K=5.

## Route 1 — Lane TS-cmp `Picard/TensorObjSubstrate.lean` (pullback-monoidality arc)
Signals (sorry = file proof-body sorry count; status = prover self-report):
- iter-251: status PARTIAL; helpers +6; sorry 3→3
- iter-252: status PARTIAL (route pivot); helpers +1; sorry 3→3
- iter-253: status PARTIAL (STEP A blocked across 3 approaches; Sq1 done); helpers +2; sorry 3→3
- iter-254: status COMPLETE for STEP A helper (5-iter whisker wall fell, axiom-clean); D1' still partial; sorry 3→2
- iter-255: status COMPLETE for **D1' `pullbackTensorMap_natural`** (axiom-clean, the assigned canonical target); sorry 2→1
- Remaining file sorry: `exists_tensorObj_inverse` (cross-file gated, NOT this lane). 
- Proposed iter-256 work: scaffold + prove **D3' `pullbackTensorMap_restrict`** (next sub-lemma; all blueprint deps now closed: D1' just landed, D2' landed iter-250, plus proven unit-analog `pullbackObjUnitToUnit_comp`; recipe = mirror that analog reusing the D1' `show…from` spelling device).
- Recurring blocker phrase (now resolved): "δ_natural MonoidalCategory carrier-spelling synthesis" — dissolved iter-255 via a one-line proof-side ascription.

## Route 2 — Lane TS-inv `Picard/TensorObjSubstrate/DualInverse.lean` (dual-inverse / group inverse)
Signals (target = `homOfLocalCompat`):
- iter-251: status PARTIAL; helpers +several; sorry 2→2
- iter-252: PARTIAL — `homLocalSection` CLOSED; `homOfLocalCompat` scaffolded; sorry 2→2
- iter-253: PARTIAL — sub-step (b) `topSectionToHom` CLOSED; sorry 2→2 (internal advanced)
- iter-254: PARTIAL — sub-step (a) IsCompatible CLOSED, (c) linearity ~90%; sorry 2→2 (internal sorries 2→1)
- iter-255: PARTIAL — **M-leg of (c) CLOSED** via `Scheme.Modules.map_smul`; residual narrowed to ONE native↔`restrictScalars 𝟙` f-leg smul bridge (all bridge lemmas named+verified); sorry 2→2
- Recurring blocker phrase: "carrier-duality / restrictScalars smul instance bridge" (present 4 iters, but the obstacle is provably SMALLER each iter — whole-decl → sub-step → M-leg → single f-leg identity-ring-map smul).
- Proposed iter-256 work: close `homOfLocalCompat` (recipe fully in-file: `ModuleCat.restrictScalars.smul_def`/`restrictScalarsId'App` + `(U i).ι.appIso = Iso.refl`), then attempt `dual_restrict_iso` Step-4 (a known hard slice-site base-change build; secondary, gated behind homOfLocalCompat closing).

## Route 3 — Lane engine `Picard/LineBundleCoherence.lean` (A.2.c coherence entry) — NEW
- No prior prover data. Blueprint chapter `Picard_LineBundleCoherence.tex` authored iter-255, cleared complete+correct.
- Proposed iter-256 work: file-skeleton scaffold (sorry stubs from the chapter) + first-iter de-risk investigation of the `J.over X` / `X.ringCatSheaf` site instances (HasWeakSheafify / WEqualsLocallyBijective / HasSheafCompose); do NOT attempt proofs.

## Strategy estimation (verbatim from STRATEGY.md phase row)
- A.1.c.sub: Iters left ~4–7; phase is OVER_BUDGET (~22 elapsed vs 6–11 original); residual described as bounded carrier/ring-spelling plumbing, closing lemma-by-lemma (D1'/D3'/D4'/dual-chain).
- A.2.c-engine: Iters left ~85–140 (dominant pole, opening now).

## This iter's PROGRESS.md `## Current Objectives` proposal (3 files / M=3)
1. `Picard/TensorObjSubstrate/DualInverse.lean` [prove] — close `homOfLocalCompat`; then attempt `dual_restrict_iso` Step-4.
2. `Picard/TensorObjSubstrate.lean` [prove] — scaffold + prove D3' `pullbackTensorMap_restrict`.
3. `Picard/LineBundleCoherence.lean` [prove/scaffold] — scaffold + site-instance de-risk.

## Questions for you
1. Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR), with attention to: is Route 2 (PARTIAL×5 on one target, never closed, but provably narrowing) CHURNING or CONVERGING?
2. Dispatch-sanity on M=3: are these 3 lanes independent and right-sized, or is one a deep-lane overload / premature?
3. For Route 2's secondary `dual_restrict_iso` Step-4 (a recurring hard wall deferred several iters), is re-entering it this iter sound, or should it stay gated/await a structural consult?
