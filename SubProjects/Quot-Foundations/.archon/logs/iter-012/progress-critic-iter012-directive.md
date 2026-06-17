# Progress-critic — iter-012 convergence audit

Assess per-route convergence for the four active routes from the last 3–4 iters' SIGNALS only.
Verdict per route: CONVERGING / CHURNING / STUCK / UNCLEAR. Your verdict gates the planner's
prover dispatch.

## Route: FBC (`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`)
- Phase: FBC-A, active since ~iter-008. STRATEGY `Iters left`: 2–3.
- Sorry counts: iter-008 ~5 → iter-009 (no prover, DAG iters) → iter-011 **3** (−2 this iter).
- Helpers/decls: iter-011 closed `base_change_mate_regroupEquiv` axiom-clean (the multi-iter
  `map_smul'` "transparent-instance wall", open since iter-008, via `erw [TensorProduct.zero_tmul]`).
  Renamed the orphan `generator_trace_eq` → `base_change_mate_section_identity`.
- Statuses: iter-008 PARTIAL; iter-011 DONE (regroupEquiv) + PARTIAL (section_identity formalized,
  RHS now computable, LHS adjoint-mate crux left as a typed sorry with a 3-step decomposition).
- Recurring blocker phrase: "adjoint-mate unwinding is Mathlib-absent"; "blueprint sketch
  under-specified on the formalization path".
- iter-012 plan: NO prover this iter — effort-break the section-identity into 3 sub-lemmas first.

## Route: GF (`AlgebraicJacobian/Picard/FlatteningStratification.lean`)
- Phase: GF-alg, active. STRATEGY `Iters left`: 2–3.
- Sorry counts: iter-008 5 → iter-011 5 (flat) but **+3 axiom-clean load-bearing sub-lemmas** landed
  (`gf_torsion_annihilator`, `gf_nagata_monic_lastVar`, `mvPolynomial_quotient_finite_of_monic_lastVar`
  — the genuinely Mathlib-absent Nagata change-of-variables, transcribed from Mathlib's field-only
  private machinery to a domain).
- Statuses: iter-011 PARTIAL on `gf_torsion_reindex` — the 3 sub-lemmas now WIRE TOGETHER in its body
  (typecheck), the remaining obligation is localization-module-transport plumbing (~120–180 LOC),
  decomposed into 5 concrete steps with every Mathlib anchor scouted. Deferred to keep iter-011
  output 100% axiom-clean, NOT attempted-and-failed.
- Recurring blocker phrase: "localization-module transport plumbing / instance diamonds".
- iter-012 plan: PROVER lane [prove] on `gf_torsion_reindex` (line 949) with the 5-step recipe.

## Route: QUOT (`AlgebraicJacobian/Picard/QuotScheme.lean`)
- Phase: QUOT-defs, active. STRATEGY `Iters left`: 4–7.
- Sorry counts: iter-011 4 → 4 (the 4 skeleton stubs, downstream-blocked) but **+5 axiom-clean defs**
  landed (`annihilator`, `annihilator_ideal_le`, `schematicSupport`, `schematicSupportι`,
  `HasProperSupport`) — pulled `def:schematic_support` + `def:has_proper_support` forward from the
  next-iter ramp.
- Statuses: iter-011 first real prover data point — 5 clean, 1 blocked
  (`isLocalizedModule_basicOpen` bridge, genuine Mathlib infra gap needing a new sub-build).
- iter-012 plan: NO prover this iter — writer authors the bridge sub-build decomposition + coverage
  blocks; prover lane next iter.

## Route: GrassmannianCells (`AlgebraicJacobian/Picard/GrassmannianCells.lean`)
- Phase: QUOT-repr GR-cells. STRATEGY `Iters left` (QUOT-repr): many.
- Sorry counts: iter-008 0 committed edits → iter-009 GREEN no-op → iter-011 **+16 decls, GREEN, 0
  sorries**. A 2-iter STUCK turned around decisively via the iter-011 effort-break + fast-path.
- Statuses: iter-011 DONE (full transition chain through `transitionMap` + `transitionMap_self`).
- iter-012 plan: writer pins `lem:gr_cocycle` signature → PROVER lane [prove] on `cocycleCondition`
  if the scoped re-review clears (fast-path).

## iter-012 objectives proposal (file count + basenames)
2 prover lanes: (1) `FlatteningStratification.lean` [prove] gf_torsion_reindex; (2)
`GrassmannianCells.lean` [prove] cocycleCondition (conditional on the fast-path gate clearing this
iter). FBC + QuotScheme are writer-only this iter (no prover). Dispatch-sanity check: is deferring
FBC and QUOT to writer rounds (no prover) the right call, or is there ready prover work I am missing?
