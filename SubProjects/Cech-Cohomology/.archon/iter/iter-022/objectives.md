# Iter-022 objectives

## Lane 1 — `FreePresheafComplex.lean` [mathlib-build] — P3b free-side quasi-iso (CHURNING corrective)
Target: `cechFreeComplex_quasiIso` (`lem:cech_free_complex_quasi_iso`).
- (1) `cechFreeEvalEngineIso` — degreewise iso via `isoOfComponents`; per-degree =
  `cechFreeEval_X`(`PreservesCoproduct.iso`) ≫ hand-built drop-zeros ≫ `Sigma.whiskerEquiv`
  (`freeYonedaEval_iso_of_le`); `comm` on `Sigma.ι`. BOTTLENECK = chain-vs-cochain differential variance.
- (4) `cechFreeEval_quasiIso_of_nonempty` — Route B: `combDifferential_exact` →
  `moduleCat_exact_iff_function_exact` + deg-0 `toSingle₀Equiv`, transfer via `quasiIso_of_arrow_mk_iso`.
- (5) glue via `quasiIso_of_evaluation` (empty done / nonempty = (4)).
Recipe: `analogies/free-eval-engine-iso.md`. Escalation if 3rd setup-only: structural refactor.

## Lane 2 — `CechAcyclic.lean` [mathlib-build] — P3 L1 step c-concrete + d (HIGH-WATCH)
Target: `sectionCech_affine_vanishing` (`lem:cech_acyclic_affine` §section form).
- (A) φ_σ = `(IsLocalizedModule.iso (powers …) (tilde.toOpen M …).hom).toAddEquiv.symm` (rfl-level) +
  naturality square `qcohRestriction_eq_comparison` → `sectionCechCofaceMatch`/`sectionCechAbExact`.
- (B) ladder `Function.Exact.of_ladder_addEquiv_of_exact` feeding `dDiff_exact` + decl 5 →
  `sectionCech_homology_exact`.
- (d) assemble `sectionCech_affine_vanishing` (tilde case; general F via 01I8 deferred).
Recipe: `analogies/tilde-section-bridge.md`. Last iter before P3 OVER_BUDGET.

## Not dispatched
- `CechBridge.lean` (0 sorries; `injective_cech_acyclic` gated on Lane-1) — re-enters when Lane 1 lands.
- P5a/P5b/PresheafCech/AcyclicResolution/HigherDirectImage — done or blocked-upstream.
