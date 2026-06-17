# Blueprint-clean directive — iter-054

The blueprint-writer (iter054) just expanded `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`:
- Step 3 of `lem:cech_augmented_resolution` now names the Lean homotopy⟹IsZero mechanism + the
  concrete-section-complex identification + the ExtraDegeneracy dead-end note.
- Two new helper lemma blocks (`isZero_of_faithful_preservesZeroMorphisms`,
  `isZero_presheafToSheaf_of_locally_isZero`).
- The proof of `lem:open_immersion_pushforward_comp` now names Bridges (1)–(3) with Mathlib decl names.
- An optional `\mathlibok` Ext↔Hom-complex anchor; `isAffineHom_of_affine_separated` bundled into a `\lean{}`.

Purify this chapter: strip any Lean tactic syntax that leaked in (named decl POINTERS as formalization
guidance are OK; tactic blocks / `:= by …` are NOT), remove project-iteration-history verbosity ("this
iter", "the prover", churn narrative), confirm every `% SOURCE`/`% SOURCE QUOTE` block is intact and
verbatim, and validate the new blocks are well-formed (matching `\begin`/`\end`, valid `\label`/`\lean`/
`\uses`). Do not weaken mathematical content. Report what you changed.
