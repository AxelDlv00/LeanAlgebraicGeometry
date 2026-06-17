# Blueprint-reviewer directive — iter-058

Whole-blueprint audit (read every chapter under blueprint/src/chapters/). Per-chapter completeness + correctness checklist with HARD-GATE verdicts (complete: true/false, correct: true/false, must-fix-this-iter).

## Why now
A `dag` phase (iter-057) reorganized \uses/\lean edges and the frontier. Two routes are heading to a prover THIS iter and need a current gate verdict:
- **Picard_FlatteningStratification.tex** (GF) — a prover will close the final `flatV` sorry in `genericFlatness`. Confirm the chapter's flatV route + GF helpers (`lem:gf_flat_of_isEpi`, `lem:gf_isEpi_restrict_of_affine_le`, `gf_flat_localizedModule_sameBase`, `isLocalizedModule_basicOpen`, `free_of_isLocalizedModule`) are present and faithful.
- **Picard_SectionGradedRing.tex** (SNAP) — a prover will build `relTensorActL` (action nat-trans) toward the coequalizer presentation `lem:relativeTensor_as_coequalizer`. Confirm the chapter adequately specifies the presheaf-promotion pipeline and that `relTensorTriplePresheaf` (NEW Lean decl, currently unmatched in the DAG) has/needs a blueprint block.

## Known issues to confirm/triage (from prior per-file checkers)
- **Picard_GrassmannianQuot.tex** has 3 PHANTOM blocks describing an abandoned route: `def:gr_modules_gluePresheaf`, `def:gr_modules_gluePresheafModule`, `lem:gr_modules_gluePresheaf_isSheaf` — their `\lean{}` pins point at declarations that do NOT exist (Lean took the equalizer-of-pushforwards route). Also `def:scheme_modules_glue` "Construction" paragraph still describes the presheaf route, not the equalizer route actually used. The GL_d bundle transition cocycle (for `universalQuotient`/`tautologicalQuotient`/`represents`) is NOT yet decomposed in the chapter. Flag these and judge whether the chapter blocks any prover (note: GR is NOT getting a prover this iter).

## Also report
- Your `## Unstarted-phase blueprint proposals` section per descriptor.
- Coverage-debt anchors: confirm whether `Scheme.Modules.relTensorTriplePresheaf`, `Scheme.Modules.opensTopology`, `gf_stalk_flat_localBase` have/need blueprint entries.
