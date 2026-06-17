# Iter-020 objectives (3 parallel prover lanes, mathlib-build)

All gate-cleared (blueprint-reviewer `iter020` HARD GATE), all CONVERGING (progress-critic `iter020`).

## Lane 1 — `FreePresheafComplex.lean` — `cechFreeComplex_quasiIso` via the 6-link chain (BINDING)
Build bottom-up the 5 new sub-lemmas (quasiIso_of_evaluation already exists), then glue:
- `cechFreeEval_X` (`lem:cech_free_eval_sectionwise`)
- `cechFreeEval_quasiIso_of_isEmpty` (`lem:cech_free_eval_empty`)
- `cechFreeEvalPrependHomotopy` (`lem:cech_free_eval_prepend_homotopy`) — port `CombinatorialCech.combHomotopy`
- `cechFreeEvalPrependHomotopy_spec` (`lem:cech_free_eval_prepend_homotopy_spec`) — hard core, port `combHomotopy_spec`
- `cechFreeEval_quasiIso_of_nonempty` (`lem:cech_free_eval_nonempty`)
- `cechFreeComplex_quasiIso` (glue via `quasiIso_of_evaluation`)
Fix stale module docstring (~19–22). progress-critic BINDING: attempt the per-V homotopy this iter.

## Lane 2 — `CechAcyclic.lean` — P3 L1 steps (b)–(d)
- (b) `qcohSectionsAwayLocalized` (`def:qcoh_sections_localized`) — tilde-M case first
- (c) `sectionCech_homology_exact` (`lem:section_cech_homology_exact`) — add PresheafCech import; `dDiff_exact`→`IsZero homology`
- (d) `sectionCech_affine_vanishing` (`lem:cech_acyclic_affine` §section form) — assemble
Leave line-109 superseded sorry. Step (a) `dDiff_exact` = ready `Function.Exact` input.

## Lane 3 — `CechBridge.lean` — injective-acyclicity bridging infra
Build the general bridge: contravariant additive `Hom(-,I)`, `I` injective, sends a chain quasi-iso to a
`Hom`-cochain quasi-iso (standalone, independent of `cechFreeComplex_quasiIso`). Do NOT add
`injective_cech_acyclic` yet (gated on Lane 1). Fix stale module docstring (~29–44).

## Decisions
- D2: route (a) (direct prepend homotopy) for the quasi-iso; route (b) ExtraDegeneracy = fallback.
- strategy-critic skipped (STRATEGY.md unchanged, prior CHALLENGE addressed, all routes CONVERGING).
