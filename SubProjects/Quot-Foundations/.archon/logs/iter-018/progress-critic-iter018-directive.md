# Progress Critic Directive

## Slug
iter018

## Iter
018

## Active routes / files under review

### Route: FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

- **Started at iter**: phase FBC-A entered ~iter-012
- **Iters audited**: 014–017

#### Sorry counts per iter
- iter-014: 4 (post; Seam-1 `base_change_mate_unit_value` closed 5→4)
- iter-015: 4 (Seam-2 leg-identification scaffold landed; sorry persists)
- iter-016: 4 (`pullbackPushforward_unit_comp` added; Seam-2 sorry persists)
- iter-017: 4 (motive-wall dissolved; Seam-2 content sorry MOVED + shrank into `base_change_mate_fstar_reindex_legs` step-iii)

#### Helpers added per iter
- iter-014: 0 net (Seam-1 closed)
- iter-015: +1 scaffold helper (`base_change_mate_fstar_reindex` leg-identification)
- iter-016: +1 (`pullbackPushforward_unit_comp`, axiom-clean)
- iter-017: +4 axiom-clean (`base_change_mate_codomain_read_legs`, 3 `gammaMap_pushforward*` Γ-collapses) + subst-able-legs restructure that DISSOLVED the "motive is not type correct" wall blocking iters 014–016

#### Prover statuses per iter
- iter-014: COMPLETE — Seam-1 closed
- iter-015: PARTIAL — Seam-2 scaffold, sorry remains
- iter-016: PARTIAL — Seam-2 `have key` wired, sorry remains
- iter-017: PARTIAL — multi-iter motive wall DISSOLVED via subst-able legs; Seam-2 sorry isolated to one concrete affine goal (step-iii mate-unwinding) inside `_legs`

#### Prover count per iter (files dispatched)
- iter-014..017: FBC dispatched every iter (1 lane; part of 2–3 lane iters)

#### Recurring blocker phrases
- "motive is not type correct" — appeared iters 014–016 as the Seam-2 wall; iter-017 reports it DISSOLVED (subst now acts on a well-typed motive). NOT recurring into 017's residual.
- "mate-unwinding crux / Mathlib-absent" — NEW in iter-017, the freshly-isolated step-iii goal (first appearance, not recurring).

#### Planner's current proposal for this iter
A `prove` pass targeting the single isolated step-iii crux inside `base_change_mate_fstar_reindex_legs` (line 1324): rewrite the surviving unit factor by `pullbackPushforward_unit_comp`, absorb the `e`-iso unit, identify the `Spec ιA`-unit via Seam-1 `base_change_mate_unit_value`, land `base_change_mate_inner_value`. Then cascade Seam-3 `base_change_mate_gstar_transpose`.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md (FBC-A row)**: 2–3
- **Elapsed iters in current phase**: ~6 (phase entered ~iter-012)
- **Phase started at iter**: ~012

### Route: GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

- **Started at iter**: GF-alg phase, ~iter-010
- **Iters audited**: 014–017

#### Sorry counts per iter
- iter-014: 4 (post; `gf_torsion_reindex` closed)
- iter-015: 5 (+1 — new abstract-T descent helper `free_localizationAway_of_away_tower`)
- iter-016: 4 (−1 — closed `free_localizationAway_of_away_tower`)
- iter-017: 3 (−1 — closed L5 `exists_free_localizationAway_polynomial`; OreLocalization diamond DEFUSED)

#### Helpers added per iter
- iter-015: +1 (`free_localizationAway_of_away_tower`, deliberate decomposition vehicle)
- iter-016: 0 (closed the helper)
- iter-017: 0 new decls (signature simplification of `gf_torsion_reindex` only)

#### Prover statuses per iter
- iter-014: COMPLETE — `gf_torsion_reindex`
- iter-015: PARTIAL — +1 descent helper (sorry)
- iter-016: COMPLETE — closed `free_localizationAway_of_away_tower`
- iter-017: COMPLETE — closed L5; OreLocalization 2-iter instance-diamond blocker (the prior critical-watch) RESOLVED

#### Recurring blocker phrases
- "OreLocalization instance-presentation diamond" — appeared iters 015–016 (prior critic flagged: defuse or STUCK at 018); iter-017 RESOLVED it (dropped the redundant canonical existential). No longer live.

#### Planner's current proposal for this iter
`prove` L4 `exists_localizationAway_finite_mvPolynomial` (sorry 516) via the prover's scouted 2-piece decomposition (algebraic-independence descent for injectivity + module-finiteness descent = Finset-fold of `gf_clear_one_denominator`), then `genericFlatnessAlgebraic` (1558) as budget allows.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md (GF-alg row)**: 1–3
- **Elapsed iters in current phase**: ~7
- **Phase started at iter**: ~010

### Route: QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean`

- **Started at iter**: SNAP-S2 Route-2 first dispatch iter-017 (Route-1 abandoned earlier as a kernel dead-end)
- **Iters audited**: 015–017

#### Sorry counts per iter
- iter-015: 4 (+3 axiom-clean graded-API decls landed additively; the 4 protected stubs unchanged)
- iter-016: 4 (no QUOT prover — Route-2 pivot decided structurally)
- iter-017: 4 (+13 axiom-clean Route-2 decls landed additively; protected stubs unchanged)

#### Helpers added per iter
- iter-015: +3 (D5 + G1 halves)
- iter-016: 0 (plan-only for QUOT, sanctioned route pivot)
- iter-017: +13 (keystone D6 `subquotient_degreewise_diff` + ambient homogeneity calculus); NO isDefEq/whnf pathology fired (validates Route-2)

#### Prover statuses per iter
- iter-015: PARTIAL — 3 axiom-clean decls, G2–G4 blocked by isDefEq pathology (pre-pivot)
- iter-016: N/A — no QUOT prover (Route-2 pivot)
- iter-017: PARTIAL — 13 axiom-clean decls including the mathematically hardest ambient lemma (D6); blocked on the finiteness encoding (`Module.Finite (κ[t]) M` from commuting endos), exact tool path scouted (`Algebra.adjoinCommRingOfComm`)

#### Recurring blocker phrases
- "isDefEq/whnf pathology" (Route-1, quotient/subtype graded decomposition) — RESOLVED by the Route-2 pivot; did NOT fire in iter-017.
- "finiteness encoding / Module.Finite from commuting endos" — NEW in iter-017 (first appearance), a build-size deferral with a fully scouted tool path, not a wall.

#### Planner's current proposal for this iter
`mathlib-build` lane: build the `Module.Finite (MvPolynomial (Fin r) κ) M` encoding via `Algebra.adjoinCommRingOfComm` + `aeval` + `Module.compHom`, fix the subquotient-datum `structure`, then `subquotient_finite_transfer` + the `P(r)` induction `subquotient_hilbertSeries_rational` + the `(⊤,⊥)` bridge into `gradedModule_hilbertSeries_rational`. D6 + homogeneity calculus are ready inputs.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md (SNAP-S2 row)**: 2–3
- **Elapsed iters in current phase**: 2 Route-2 prover iters (015 pre-pivot, 017 first true Route-2)
- **Phase started at iter**: Route-2 effectively iter-017

## PROGRESS.md proposal (this iter)

- **File count**: 3
- **Files**: FlatBaseChange.lean, FlatteningStratification.lean, QuotScheme.lean
- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**: none — all 3 ready lanes are being dispatched. (FBC-B, GF-geo, SNAP-S1, QUOT-repr are gated on the above or far-out, not ready.)
- **Dispatch cap (from --max-objectives)**: 10

## Out of scope
FBC-B (`flatBaseChange_pushforward_isIso`), GF-geo (`genericFlatness`), SNAP-S1 (`def:sectionGradedRing`), QUOT-repr (`thm:grassmannian_representable`) — all gated/far-out, not under review this iter.
