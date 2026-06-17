# lean-vs-blueprint-checker — iter-044, QcohTildeSections

Bidirectional verification of ONE Lean file against its blueprint chapter.

## Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

## Blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(this consolidated chapter declares `% archon:covers AlgebraicJacobian/Cohomology/QcohTildeSections.lean`)

## What changed this iter

The prover added 5 axiom-clean declarations (lines ~760–895):
`appTop_appIso_inv_eq_res`, `key_morph`, `tile_appIso_comp`, `tile_section_ring_identity`,
`tile_scalar_compat`.

The prover's stated intent: `tile_scalar_compat` IS the formalization of the residual ring/scalar
identity that the blueprint `lem:tile_section_comparison` (label near line 4467) reduces to. The
prover recommends pinning `\lean{AlgebraicGeometry.tile_scalar_compat}` onto `lem:tile_section_comparison`.

## Specific questions to answer (bidirectional)

1. **Statement-vs-statement for the proposed pin.** Does the Lean `tile_scalar_compat` (a *scalar
   compatibility* lemma — read its signature) actually match the STATEMENT of
   `lem:tile_section_comparison` (which asserts a *natural R_g-linear isomorphism of section
   functors*)? If the Lean proves only the scalar core, not the full natural iso, then pinning
   `\lean{tile_scalar_compat}` onto that block would over-claim formalization. Report whether the pin
   is appropriate, or whether the block needs (a) restatement to match the Lean, or (b) a separate
   dedicated block for `tile_scalar_compat`.

2. **Blueprint → Lean adequacy.** Is the `lem:tile_section_comparison` proof sketch (routes A/B,
   "single structure-sheaf ring identity") accurate now that the prover landed route (A)? Earlier iters
   flagged the sketch as imprecise (overstating residual size). Is it still misleading?

3. **Coverage debt.** The 4 helper lemmas `appTop_appIso_inv_eq_res`, `key_morph`, `tile_appIso_comp`,
   `tile_section_ring_identity` have NO blueprint block. Confirm and note what each would need.

4. **`lem:tile_section_localization` (label ~line 4530)** — the NEXT target, not yet built. Is its
   sketch sound given the prover's finding that the descent must happen at the underlying-type level
   (the bundled `ModuleCat R` vs `ModuleCat R_g` carriers do NOT match by rfl)?

Report Lean→blueprint and blueprint→Lean findings with severity. No global strategy context.
