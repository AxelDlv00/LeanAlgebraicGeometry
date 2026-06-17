# Iter 008 — Objectives detail

## Lane 1 — FBC-A (`Cohomology/FlatBaseChange.lean`) [prove]

Targets (chapter `Cohomology_FlatBaseChange.tex`):
- BUILD + prove `base_change_mate_unit_value` (`lem:base_change_mate_unit_value`, blk @1320).
- BUILD + prove `base_change_mate_fstar_reindex` (`lem:base_change_mate_fstar_reindex`, blk @1348).
- BUILD + prove `base_change_mate_gstar_transpose` (`lem:base_change_mate_gstar_transpose`, blk @1378).
- CLOSE `base_change_mate_generator_trace_eq` (`lem:…_generator_trace_eq`, blk @1415) — sorry @985.
  RHS independent of `map_smul'`; can close on its own from the 3 sub-lemmas.
- CLOSE `map_smul'` in `base_change_mate_regroupEquiv` (`lem:…_regroupEquiv`, blk @1230) — sorry @939.
  Route (a): `restrictScalars.smul_def` → `ExtendScalars.smul_tmul` → `tmul_mul_tmul`, `TensorProduct.ext`
  at the full carrier. NOT the refuted `exact LinearEquiv.toModuleIso …` one-liner.
Untouched: `affineBaseChange_pushforward_iso` (@1116), `flatBaseChange_pushforward_isIso` (@1138).

## Lane 2 — GF-alg (`Picard/FlatteningStratification.lean`) [prove]

Recipe: `analogies/gf-generic-rank-ses.md`. Chapter `Picard_FlatteningStratification.tex`.
Order:
1. RESTRUCTURE the L5 induction in `exists_free_localizationAway_polynomial` (sorry @513) to
   `Nat.strong_induction_on` generalizing the BASE DOMAIN `A` (revert `A` + instances into the motive).
2. BUILD + prove `gf_generic_rank_ses` (`lem:gf_generic_rank_ses`, blk @514; full `% LEAN SIGNATURE`
   in chapter): SES `0→P_d^{⊕m}→N→T→0`, `m := finrank (FractionRing P_d) (LocalizedModule
   (nonZeroDivisors P_d) N)`, over `P_d` directly (no `g`-inversion).
3. BUILD + prove `gf_clear_one_denominator` (`lem:gf_clear_one_denominator`, blk @356) — the shared
   single-variable-Nagata + denominator-clear engine.
4. BUILD + prove `gf_torsion_reindex` (`lem:gf_torsion_reindex`, blk @587) using the engine.
5. CLOSE assemblies in order: L5 core (@513), `exists_localizationAway_finite_mvPolynomial` L4 (@445),
   `genericFlatnessAlgebraic` (@580).
Untouched: `genericFlatness` (@647, GF-geo).
Tripwire: land ≥1 atomic sub-lemma axiom-clean even if assemblies don't close (zero closures → STUCK).

## Lane 3 — GrassmannianCells (`Picard/GrassmannianCells.lean`) [mathlib-build]

Chapter `Picard_GrassmannianCells.tex`:
- BUILD `Grassmannian.transitionMap` (`def:gr_transition`, blk @82): `θ_{I,J}(X^J) = (X^I_J)⁻¹ X^I`,
  Cramer inverse of the `J`-minor, over localized polynomial rings `ℤ[X^I, 1/P^I_J]`. Bottom-up,
  axiom-clean; hand off a decomposition if blocked on the matrix-inverse/localization plumbing.
- BUILD `Grassmannian.cocycleCondition` (`lem:gr_cocycle`, blk @140) if budget: `θ_{I,K} = θ_{J,K} ∘
  θ_{I,J}`, `θ_{I,I} = id`.
- DELETE the stale `affineChart` docstring (line ~59, "the body is a typed `sorry`").

## Deferred (gate-pending iter-009)

- QUOT-A (`Picard/QuotScheme.lean`): chapter edited this iter (annihilator sub-build); mandatory
  blueprint-reviewer next iter, then build `Scheme.Modules.isLocalizedModule_basicOpen`
  (`lem:qcoh_section_localization_basicOpen`) + assemble `Scheme.Modules.annihilator`.
  `sectionGradedRing` stays BLOCKED (needs a monoidal/tensor-powers `SheafOfModules` sub-build first).
