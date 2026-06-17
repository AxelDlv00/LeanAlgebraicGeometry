# Progress-critic directive — iter-016 (Quot-Foundations)

Assess convergence per active route. Three live prover routes, one file each. Signals
are the last K=4 iters (iter-012..015; iter-013 was a DAG-only iter with no prover phase).

## Route FBC — AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- Phase FBC-A entered iter-012. STRATEGY `Iters left`: 1–2.
- Signals (sorry count / helpers added / prover status / blocker phrase):
  - iter-012: 5 / +3 seams + inner_value proven / PARTIAL / "section_identity decomposed into 3 seams"
  - iter-013: 5 / 0 / (no prover, DAG-only) / —
  - iter-014: 5→4 / 0 / COMPLETE on Seam 1 `base_change_mate_unit_value` / "conjugate-unit calculus closed Seam 1"
  - iter-015: 4→4 / 0 / PARTIAL / "Seam 2 leg-identification scaffold landed, stalled at the conjugate-calculus coherence gap; precise recipe (`conjugateEquiv_pullbackComp_inv` + `unit_conjugateEquiv` + Seam 1) recorded"
- Proposed iter-016 action: blueprint-writer expands Seam 2/3 mechanism, scoped re-review, then prove Seam 2 → Seam 3 (Seam 3 cascades to section_identity/generator_trace/cancelBaseChange).

## Route GF — AlgebraicJacobian/Picard/FlatteningStratification.lean
- Phase GF-alg entered iter-012. STRATEGY `Iters left`: 1–3.
- Signals:
  - iter-012: reindex hard-finiteness landed, 1 sorry / +helpers / PARTIAL / "reindex"
  - iter-013: (no prover) / 0 / — / —
  - iter-014: 5→4 / +5 helpers / COMPLETE on `gf_torsion_reindex` / "broke prior wall via (a)-(e) helper factoring"
  - iter-015: 4→5 / +1 helper `free_localizationAway_of_away_tower` / PARTIAL / "L5 steps 1,2,5 wired; steps 3-4 isolated to one sorry; OreLocalization instance-diamond blocked the IH application, so phrased a new abstract-T descent helper"
- Proposed iter-016 action: blueprint the new helper + fix Step 4 prose, scoped re-review, then CLOSE `free_localizationAway_of_away_tower` (no further decomposition — closure target), then L5 splice, then L4 / genericFlatnessAlgebraic.

## Route QUOT — AlgebraicJacobian/Picard/QuotScheme.lean
- Phase SNAP-S2 graded-API first real prover lane entered iter-015. STRATEGY `Iters left`: 2–4.
- Signals:
  - iter-012: 4 / +8 power-series-engine decls (`IsRatHilb`) / COMPLETE on power-series half / —
  - iter-013: (no prover) / 0 / — / —
  - iter-014: 4 / 0 / (no QUOT prover; setup/blueprint only) / —
  - iter-015: 4→4 / +3 axiom-clean decls (D5, G1a `homogeneousSubmodule_inf_iSupIndep`, G1b `homogeneousSubmodule_iSup_inf_eq`) / PARTIAL (additive content, headline 4 stubs untouched) / "G2-G4 blocked by isDefEq/whnf runaway over quotient/subtype graded Decomposition; confirmed non-terminating at 2M heartbeats; recommend Hilbert-function-level restatement to avoid building graded structures on quotient modules"
- Proposed iter-016 action: NO raw re-dispatch on the blocked bundled form. Instead mathlib-analogist consult (running this iter) + strategy pivot to ambient-M / Hilbert-function-level architecture + blueprint surgery (split G1 pins). QUOT prover deferred to iter-017 on the restated form (pending analogist verdict; may fast-path this iter if the pivot lands clean).

## Question
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and, for any CHURNING/STUCK,
the corrective TYPE (blueprint expansion / Mathlib-idiom consult / structural refactor /
route pivot). Also a dispatch-sanity read on the proposed action list above.
