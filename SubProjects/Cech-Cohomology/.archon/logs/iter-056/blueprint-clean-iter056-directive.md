# Blueprint-clean directive — purity pass after the iter-056 writer rounds

## Chapter to clean
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Context
Two blueprint-writer rounds this iter edited `lem:open_immersion_pushforward_comp` Proof detail (2)
and surrounding blocks: round 1 added a transport route that was then REPLACED in round 2 by the
sound two-need split (Need #1 whole-scheme `Scheme.isoSpec` transport + Need #2 enlarged-basis
general-affine-open Serre vanishing). New/edited blocks: `lem:rightDerivedNatIso`,
`lem:sectionsFunctorCorepIso`, `lem:sectionsFunctor_additive`, `lem:toPresheafOfModules_additive`,
`lem:isZero_homology_of_iso_homotopy_id_zero`, `lem:affine_serre_vanishing_general_open` (TODO),
`lem:modules_isoSpec_ext_transport` (TODO), the `Scheme.isoSpec` / `Ext.mapExactFunctor` /
`Scheme.Modules.pushforward` Mathlib anchors, and a DEAD-END remark.

## Tasks
- Strip any Lean syntax leakage (tactic strings, `:=`, raw Lean term snippets) from prose bodies —
  keep `\lean{}`/`\uses{}`/`\mathlibok` markers (those are legitimate).
- Remove project-history verbosity / iter-narrative that leaked into prose ("round 1", "the prover
  built", "iter-0NN we…") — EXCEPT keep the substantive DEAD-END mathematical remark (that the
  open-subscheme `j⁻¹V ≅ Spec Γ(j⁻¹V)` transport forces restriction-preserves-injectives) since it
  is mathematically load-bearing guidance; reword it as a clean mathematical remark, not a
  project-history note.
- Verify the `% SOURCE` / `% SOURCE QUOTE PROOF` blocks for `lem:open_immersion_pushforward_comp`
  and `lem:affine_serre_vanishing` are intact and correctly attached; do not fabricate new ones.
- Confirm new Mathlib anchors carry `\mathlibok` and the two TODO targets carry NO marker.
- Keep all prose mathematical, textbook-level, project notation.

## Out of scope
Only this one chapter. Do not alter the Sub-brick A stub blocks' mathematical content.
