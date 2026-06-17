# Progress-critic directive — iter-021

Assess convergence per active route. Signals are last K=4 iters (017–020). Verdict each route.

## Route 1 — P3 standard-cover Čech vanishing (section-complex form) — `CechAcyclic.lean`

- STRATEGY estimate: `Iters left ~4–6`; route active since early project (P3), section-form re-sign since iter-017.
- Signals (decls added / status / named targets):
  - iter-017: no prover run (plan-only noop fix).
  - iter-018: +22 axiom-clean (away-localisation comparison algebra `AwayComparison.*` + `CechLocalized.*` capstone `cechLocalized_exact`). Status PARTIAL. No named top-target.
  - iter-019: +24 axiom-clean; **named target `dDiff_exact` landed** (step (a), positive-degree `Function.Exact` of un-localised `D•`). Status PARTIAL→named-landing.
  - iter-020: +4 axiom-clean; **named target `qcohSectionsAwayLocalized` landed** (step (b), tilde case) + 2 bricks (`basicOpen_sprod`, `qcohRestriction_eq_comparison`). Status PARTIAL.
- Recurring blocker phrase: step (c) `sectionCech_homology_exact` — `sectionCechComplex` is `Ab`-valued with categorical-product `∏ᶜ` objects, so `moduleCat_exact_iff` does not apply; needs a 3-sub-lemma bridge (`∏ᶜ↔pi AddEquiv`, alternating-coface unfold/match, `ab_exact_iff` transfer of the already-proved `dDiff_exact`). Prover explicitly states "not new mathematics", recommends effort-break.
- Proposed iter-021 action: effort-break step (c) into the 3 named sub-lemmas (blueprint), then dispatch the prover on them + step (d) assembly.

## Route 2 — P3b free-presheaf complex quasi-iso — `FreePresheafComplex.lean`

- STRATEGY estimate: `Iters left ~4–7`; route active since iter-016 (free side).
- Signals:
  - iter-017: no prover run (noop).
  - iter-018: +3 +1 repair (augmentation chain map `cechFreeComplexAug`). Status PARTIAL.
  - iter-019: +3; **`quasiIso_of_evaluation` landed** (objectwise reduction — reduces target to one per-`V` obligation). Status PARTIAL.
  - iter-020: +10; **2 named sub-targets landed** (`cechFreeEval_X`, `cechFreeEval_quasiIso_of_isEmpty`) + the full `FreeCechEngine` combinatorial contracting-homotopy engine (`combHomotopy_spec` = `d∘h+h∘d=id`) + per-summand evaluation bridges. Status PARTIAL.
- Recurring blocker phrase: the named target `cechFreeComplex_quasiIso` has NOT landed in 3 prover iters. Remaining blocker NOW = the **differential match on coproduct injections** (evaluated alternating-face differential ↔ `FreeCechEngine.combDifferential` under the degreewise iso), i.e. step 1 of the prover's 5-step handoff; given that, steps 2–5 (define `h`, `d∘h+h∘d=id` via the engine, package `Homotopy`→`QuasiIso`, glue) are mechanical.
- iter-020 BINDING condition you (critic) set last iter: "Route 2 must ATTEMPT the per-`V` contracting homotopy this iter, not another setup round, else CHURNING at iter-021." Assessment input: iter-020 DID build the engine (the `combHomotopy_spec` homotopy content) + the empty case + the per-summand bridges; the unbuilt piece is now the differential-match, NOT the homotopy identity.
- Proposed iter-021 action: effort-break adds an explicit differential-match sub-lemma node to the blueprint; dispatch prover on the differential-match → nonempty case → glue.

## Note on CechBridge.lean (NOT proposed as a prover lane this iter)
Bridge is complete (0 sorries); its only open target `injective_cech_acyclic` is gated on Route 2's `cechFreeComplex_quasiIso` (does not yet exist), so it would be a noop lane. Excluded from objectives this iter. (Listed only so you know why it is absent.)

## PROGRESS.md `## Current Objectives` proposal for iter-021 (2 files)
1. `FreePresheafComplex.lean` — build the differential-match sub-lemma + nonempty per-`V` homotopy + `cechFreeComplex_quasiIso`. [mathlib-build]
2. `CechAcyclic.lean` — build the 3 step-(c) sub-lemmas + step (d) `sectionCech_affine_vanishing`. [mathlib-build]

Give a per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and, for any CHURNING/STUCK, the corrective TYPE.
