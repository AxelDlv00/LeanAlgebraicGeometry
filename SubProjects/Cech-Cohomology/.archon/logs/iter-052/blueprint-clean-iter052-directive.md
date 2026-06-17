# Directive — blueprint-clean

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Context
A blueprint-writer round (iter-052) just added route-B helper blocks
(`lem:isLocalizedModule_comp_away`, `lem:section_cech_module_exact_of_localizationAway`), the
augmented-complex object layer (`def:cech_complex_on_X`, `def:cech_nerve_point_iso`,
`def:cech_augmentation`, `lem:cech_augmentation_comp_d`, `def:cech_augmented_complex`), fixed two
hint-precision defects, and rewrote the `lem:cech_augmented_resolution` proof sketch to a
sections/sheafification route.

## Task
Enforce blueprint purity on the edited/added regions:
- Strip any Lean syntax / tactic strings / Lean-name leakage from prose (the math must read math-only;
  `\lean{...}` pins are fine, inline `\verb|...|`/code in prose is not).
- Strip project-history phrasing ("iter-051", "the prover built", "landed axiom-clean", "this iter")
  from prose bodies — blueprint prose is timeless mathematics.
- The new object-layer + route-B blocks are **Archon-original** (no external source): confirm they carry
  NO fabricated `% SOURCE`/`% SOURCE QUOTE`/`\textit{Source}` lines. Leave the genuine Stacks
  `% SOURCE QUOTE PROOF:` on `lem:cech_augmented_resolution` intact (verify it still matches its source
  `references/stacks-coherent.tex` if present).
- Do NOT add or remove `\leanok`. Do NOT alter `\lean{}` targets. Do NOT change mathematical content.

You may spawn a reference-retriever only if a source quote is missing and genuinely needed (the new
blocks should need none). Report what you changed.
