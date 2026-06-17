# Iter-021 objectives (detail)

Two parallel prover lanes, both HARD-GATE-cleared (blueprint-reviewer iter021), both
[prover-mode: mathlib-build] (build new axiom-clean decls bottom-up; no sorry pins).

## Lane 1 — FreePresheafComplex.lean (CHURNING corrective: the differential match)
Build, in order:
1. `cechFreeEvalEngineIso` (`lem:cech_free_eval_engine_iso`) — THE bottleneck. Degreewise iso
   `((eval V).mapHomologicalComplex _).obj (cechFreePresheafComplex 𝒰) ≅ C•`,
   `C•_p = ⊕_{σ:Fin(p+1)→I₁(V)} O_X(V)`, differential = `FreeCechEngine.combDifferential`.
   Index split via `freeYonedaEval_iso_of_le`/`_isZero_of_not_le` + `cechFreeEval_X`; differential
   match on coproduct injections via `Limits.Sigma.hom_ext` + `PreservesCoproduct.iso` naturality +
   `cechFreeSimplicial` face reindexing `σ↦σ∘Fin.succAbove i`, sign `(-1)ⁱ` from `objD`.
2. `cechFreeEvalPrependHomotopy` (`lem:cech_free_eval_prepend_homotopy`) — `Sigma.desc` prepend-`i_fix`,
   transported through the engine iso; mirrors `FreeCechEngine.combHomotopy`.
3. `cechFreeEvalPrependHomotopy_spec` (`lem:..._spec`) — `d∘h+h∘d=id`; via `cechFreeEvalEngineIso` this
   reduces to `FreeCechEngine.combHomotopy_spec` (already proved).
4. `cechFreeEval_quasiIso_of_nonempty` (`lem:cech_free_eval_nonempty`) — package as
   `HomologicalComplex.Homotopy (id≃0)` → `HomotopyEquiv` with `O_𝒰(V)[0]` → `QuasiIso`.
5. `cechFreeComplex_quasiIso` (`lem:cech_free_complex_quasi_iso`) — glue: `quasiIso_of_evaluation` →
   per-V case split (empty = done; nonempty = step 4).
If step 1 stalls: land the index-split half + hand off the differential-match sub-step precisely; do NOT
pin a sorry (nonempty Homotopy is all-or-nothing). 3rd setup-only return → planner escalates to
mathlib-analogist on Homotopy packaging.

## Lane 2 — CechAcyclic.lean (P3 step c effort-break + step d)
Step (a) `dDiff_exact` + step (b) `qcohSectionsAwayLocalized` already landed. Build:
- c1 `sectionCechProductEquiv` (`lem:section_cech_product_equiv`) — `∏ᶜ↔pi` `AddEquiv` in `Ab` via
  `CategoryTheory.Limits.Concrete.productEquiv`; per-σ identify section group with `dCoeff` via
  `IsLocalizedModule` uniqueness (`qcohSectionsAwayLocalized`).
- c2 `sectionCechCofaceMatch` (`lem:section_cech_coface_match`) — unfold `alternatingCofaceMapComplex`
  differential, match each face restriction to `dDiff` via `qcohRestriction_eq_comparison`+`basicOpen_sprod`.
- c3 `sectionCechAbExact` (`lem:section_cech_ab_exact`) — `exactAt_iff_isZero_homology` +
  `ShortComplex.ab_exact_iff` (NOT `moduleCat_exact_iff` — Ab-valued `∏ᶜ`), transport `dDiff_exact`
  across c1's product equiv.
- glue `sectionCech_homology_exact` (`lem:section_cech_homology_exact`).
- (d) `sectionCech_affine_vanishing` (`lem:cech_acyclic_affine` §section form) — assemble (b)+(c).
Add `import AlgebraicJacobian.Cohomology.PresheafCech` (no cycle). Keep all existing
`CombinatorialCech.*`/`AwayComparison.*`/`CechLocalized.*`/`SectionCechModule.*` verbatim.
