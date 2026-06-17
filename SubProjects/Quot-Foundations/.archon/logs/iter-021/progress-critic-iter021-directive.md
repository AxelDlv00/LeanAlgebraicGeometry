# Progress-critic directive — iter-021

Assess convergence per ACTIVE route. Two routes carry prover dispatch this iter (FBC, GF);
QUOT's live-math route completed iter-020 (keystone closed) and gets a structural refactor only.

## Route: FBC — AlgebraicJacobian/Cohomology/FlatBaseChange.lean
Last 4 iters (active sorry count in file / what happened):
- iter-017: 4 sorries. Seam-2 `fstar_reindex` motive wall; 4 axiom-clean sub-lemmas added.
- iter-018: 4 sorries. `fstar_reindex` step-(iii) UNMOVED ("literal-form lock"); +1 scaffold line only.
- iter-019: 4 sorries. effort-broke step-(iii) into 5 atomic lemmas; 2/5 closed axiom-clean; assembly unmoved.
- iter-020: 4 sorries. NO prover — a `refactor` ROUTE-SWAPPED: built `base_change_mate_domain_read`
  axiom-clean and re-routed `section_identity` to derive from domain_read+codomain_read+`gstar_transpose`,
  making the 6-iter-stuck `fstar_reindex` crux DEAD CODE. New live crux = `gstar_transpose` @1525
  (never directly attempted before — the route swap just promoted it).
Recurring blocker phrase: "Seam-2 fstar_reindex literal-form lock" (iters 014–019) — now bypassed by the
route swap. Helpers added per iter: many (mate sub-lemmas), but iter-020's was a genuine structural reroute.
Strategy (FBC-A row): Status ACTIVE, Iters-left 3–4. Phase entered: pre-iter-014.
Proposed iter-021 objective: PROVE `gstar_transpose` @1525 (first attempt at the NEW crux; blueprint block
`lem:base_change_mate_gstar_transpose` is complete+correct per iter-020 reviewer, 3-step counit-factorization recipe).

## Route: GF — AlgebraicJacobian/Picard/FlatteningStratification.lean
Last 4 iters (active sorry count / what happened):
- iter-017: 3 sorries (L5 `exists_free_localizationAway_polynomial` CLOSED, −1 from prior).
- iter-018: 3 sorries. L4 foundation F1–F6 landed; single assembly residue.
- iter-019: 3 sorries. L4 INJECTIVITY crux CLOSED axiom-clean (5-iter-stuck); +helper isLocalization_lift_injective. Only L4 finiteness leaf @754 remains in L4.
- iter-020: 3 sorries. `genericFlatnessAlgebraic` dévissage motive + 2/3 obligations CLOSED axiom-clean
  (subsingleton, short-exact). L4 finiteness leaf @754 UNCHANGED (deliberate budget scope-call; prover
  found the collapsing lemma `IsIntegral.exists_multiple_integral_of_isLocalization` for next iter).
Recurring blocker phrase: "L4 finiteness leaf @754 unchanged" (iters 018/019/020) — deferred for budget,
NOT stuck-on-attempt; injectivity (the genuinely hard crux) closed iter-019. Helpers added: modest, each load-bearing.
Strategy (GF-alg row): Status ACTIVE, Iters-left 2. Phase entered: ~iter-007.
Proposed iter-021 objective: PROVE L4 finiteness @754 (new single-call denominator-clearing recipe), which
cascades to close the `genericFlatnessAlgebraic` B/𝔭 obligation @1810.

## Route: QUOT — AlgebraicJacobian/Picard/QuotScheme.lean (context only — completed iter-020)
- iter-020: SNAP-S2 keystone `gradedModule_hilbertSeries_rational` CLOSED axiom-clean (the last live math leaf).
  Remaining sorries are 4 PROTECTED file-skeleton stubs (gated on QUOT-defs predicate builds, not proveable yet).
- iter-021 plan: NO prover; a `refactor` file-splits the graded-Hilbert–Serre machinery into a new file +
  de-privates the IsRatHilb toolkit (honors a standing user parallelism directive; clears recurring M1 hygiene).

## Proposed iter-021 `## Current Objectives` (2 prover lanes, file basenames):
1. FlatteningStratification.lean (GF — prove L4 finiteness + cascade)
2. FlatBaseChange.lean (FBC — prove gstar_transpose)
(QUOT gets a refactor, not a prover lane.)

Return a per-route verdict (CONVERGING/CHURNING/STUCK/UNCLEAR), the corrective TYPE for any CHURNING/STUCK,
and a dispatch-sanity check on the 2-lane proposal.
