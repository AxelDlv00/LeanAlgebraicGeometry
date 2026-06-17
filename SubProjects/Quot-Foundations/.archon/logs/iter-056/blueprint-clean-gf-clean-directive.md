## Target
`blueprint/src/chapters/Picard_FlatteningStratification.tex` — the open-immersion flat-descent
route blocks added this iter (region ~L2170–2450): `lem:mathlib_flat_isBaseChange`,
`lem:gf_openImmersion_isEpi`, `lem:gf_flat_descend_isEpi`, `lem:gf_flat_of_isBaseChange_id`,
`lem:gf_section_span_flat_descent`, and the `thm:generic_flatness` proof body.

## Action
Post-writer purity pass. Strip any Lean-tactic leakage, project-iteration history, or
redundant verbosity from the newly-written blocks. Confirm each `\mathlibok` anchor block
(`lem:mathlib_*`) states the Mathlib result in project notation only (no proof obligation prose).
These are project-bespoke / Mathlib-backed ring-module lemmas — NO external SOURCE/SOURCE QUOTE
citations are required or expected; do not invent any.

## Constraints
- Edit ONLY Picard_FlatteningStratification.tex. Math prose only.
- Do NOT add/remove `\leanok`. Do NOT alter `\lean{}` pins or `\label{}`s.
- Do NOT touch the algebraic-core blocks (`thm:generic_flatness_algebraic` and the B1/B2.x chain) —
  scope is the open-immersion descent route + the assembly proof body only.
