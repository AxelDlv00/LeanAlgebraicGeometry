# Blueprint Reviewer Directive (scoped re-review — fast path)

## Slug
injcech-recheck

## Purpose

This is a same-iter fast-path re-review to clear the HARD GATE for `CechHigherDirectImage.lean`. The
iter011 review flagged ONE must-fix on `Cohomology_CechHigherDirectImage.tex`:
`lem:injective_cech_acyclic`'s proof referenced undeclared presheaf-level sub-lemmas ("developed as
part of the chapter's foundational content" placeholder). A blueprint-writer + blueprint-clean round
has now added the missing declarations. Verify the fix and re-issue a HARD GATE verdict for this
chapter.

## What was added (verify these)

A new `\subsection{Presheaf-level Čech machinery}` immediately before `lem:injective_cech_acyclic`:
- `def:cech_free_presheaf_complex` (`\lean{AlgebraicGeometry.cechFreePresheafComplex}`) — the K(𝒰)_•
  complex of free presheaves.
- `lem:cech_complex_hom_identification` — `Hom(K(𝒰)_•, F) = Č•(𝒰, F)`.
- `lem:cech_free_complex_quasi_iso` — K(𝒰)_• quasi-iso to `O_U[0]`.
- `lem:grothendieck_enough_injectives` (`\mathlibok`, `\lean{CategoryTheory.IsGrothendieckAbelian.enoughInjectives}`).
- `lem:module_cat_grothendieck` (`\mathlibok`, `\lean{instIsGrothendieckAbelianModuleCat}`).
- `lem:presheaf_modules_enough_injectives` — PMod(O_X) has enough injectives (NOT `\mathlibok`; a real
  project obligation routed through the Grothendieck engine).
- `lem:cech_delta_functor_presheaves` — Čech functors form a δ-functor = right-derived of Ȟ⁰.
- `lem:injective_cech_acyclic` proof `\uses{}` rewired to reference these.
- `lem:cech_to_cohomology_on_basis` statement got a clarifying sentence (target is vanishing `H^p=0`).

## Checks
1. Is `lem:injective_cech_acyclic` now formalization-ready (no placeholder; its proof's `\uses{}`
   names the new sub-lemmas)?
2. Are the new blocks' source quotes verbatim against `references/stacks-cohomology.tex` and citations
   well-formed?
3. Are the two `\mathlibok` anchors faithful (`IsGrothendieckAbelian.enoughInjectives`,
   `instIsGrothendieckAbelianModuleCat`)?
4. Is the dependency graph still acyclic with no broken `\uses{}` (run `leandag build --json`)?
5. Non-circularity preserved (no `\uses` from `cech_to_cohomology_on_basis` back to
   `affine_serre_vanishing`)?

Issue a `complete`/`correct` verdict for `Cohomology_CechHigherDirectImage.tex`. (You read the whole
blueprint as always, but the other two chapters were `complete + correct` this iter and unchanged.)

## Strategy snapshot
Goal: prove `cech_computes_higherDirectImage`. The consolidated chapter
`Cohomology_CechHigherDirectImage.tex` (`% archon:covers CechHigherDirectImage.lean`) gates the only
covered file. Phases: P3 (`cech_acyclic_affine`), P3b bridge (`injective_cech_acyclic` + the new
sub-lemmas, `ses_cech_h1`, `cech_to_cohomology_on_basis`, `affine_serre_vanishing`), P5a
(`higher_direct_image_presheaf` — P3/P3b-independent; `cechAugmented_exact`;
`open_immersion_pushforward_comp`; `cech_term_pushforward_acyclic`), P5b
(`cech_computes_higherDirectImage` assembly). P1/P2/P4 complete.

## References
- `references/stacks-cohomology.tex`: 01XJ, 01EO, `lemma-ses-cech-h1`, `lemma-injective-trivial-cech`,
  `lemma-cech-map-into` (≈L1138), `lemma-homology-complex` (≈L1199),
  `lemma-cech-cohomology-derived-presheaves` (≈L1287), `lemma-cech-cohomology-delta-functor-presheaves`
  (≈L1066).
- `references/stacks-coherent.tex`: 02KG, 02KE. `references/homological-acyclic-*.tex`: 015E (P4 done).

## Known issues (do not re-report)
- Frontier `\lean{}` targets are `[expected]` (decls not yet in Lean — scaffolding planned). Judge the
  blueprint, not Lean presence.
- `cech_eq_cohomology_of_basis` name vs vanishing-form statement: already noted as a soon/non-blocking
  scaffolder rename decision.
