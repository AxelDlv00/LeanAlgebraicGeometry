# blueprint-reviewer directive — iter-031

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`), per your standard per-chapter
completeness + correctness checklist. This is a HARD GATE before this iter's prover dispatch.

## Context for this dispatch
The consolidated chapter `Cohomology_CechHigherDirectImage.tex` (`% archon:covers` all 10 Cohomology
files) was heavily edited this iter:
- Coverage debt cleared: 50 `…Fam` decls + 3 QcohTilde decls bundled into existing `\lean{...}` lists
  (`archon dag-query unmatched` now = 1, the dead `CechAcyclic.affine`).
- CechBridge family-form pins added: `injective_cech_acyclicFam`, `sectionCechComplexMapOpIsoFam`.
- `rem:o1i8_decomposition` expanded into a Route-P `\uses`-chain P0–P4:
  `lem:exists_finite_basicOpen_subcover` (P0), `lem:qcoh_localized_sections` (P1),
  `lem:qcoh_global_generation` (P2), `lem:qcoh_kernel_qcoh` (P3) + sub-gap `lem:tilde_preserves_kernels`,
  `lem:isIso_fromTildeGamma_of_quasicoherent` (P4); plus small blocks `free_isQuasicoherent`,
  `isIso_fromTildeΓ_of_genSections`, `qcoh_iso_tilde_sections_of_genSections`.
A blueprint-clean pass verified all 12 new-block source quotes verbatim against
`references/stacks-schemes.tex` and confirmed all `\uses{}` resolve.

## This iter's prover targets (the files whose chapter blocks must be COMPLETE + CORRECT)
1. `CechBridge.lean` — the family-form `injective_cech_acyclicFam` + `sectionCechComplexMapOpIsoFam`
   (blocks `lem:injective_cech_acyclic`, `lem:section_cech_complex_mapop_iso`).
2. `QcohTildeSections.lean` — P0 `lem:exists_finite_basicOpen_subcover` (must be fully self-contained:
   a prover formalizes it this iter from the block alone) and P1 `lem:qcoh_localized_sections`.

Report whether each is FORMALIZE-READY, and (your usual) the per-chapter complete/correct verdict plus
any must-fix-this-iter findings. Note any `## Unstarted-phase blueprint proposals` if a strategy phase
lacks coverage.
