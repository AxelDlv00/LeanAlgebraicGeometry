# Directive: blueprint-clean — purify the re-routed keystone sub-lemma chain

## Scope
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` only.

## Context
A blueprint-writer just replaced the (circular) keystone proof with a sheaf-axiom equalizer route and
added four new sub-lemma blocks immediately before `lem:qcoh_section_isLocalizedModule`:
`lem:qcoh_section_equalizer`, `lem:localized_module_map_exact_mathlib` (`\mathlibok` Mathlib anchor),
`lem:tile_section_localization`, `lem:qcoh_section_kernel_comparison`. It also rewrote the keystone
proof and the `rem:o1i8_decomposition` remark.

## Task
Strip Lean-syntax leakage / implementation-note verbosity from the four new blocks + the rewritten
keystone proof + the `rem:o1i8_decomposition` remark, keeping the mathematics intact:
- Remove raw Lean identifiers from prose where they are pure API plumbing (keep genuine named-construction
  anchors). Watch for things like `Function.Exact`, `IsLocalizedModule.map`, `qcohRestriction_eq_comparison`
  used as prose — keep the mathematical phrasing, drop bare Lean-name plumbing not needed for the math.
- Do NOT touch `\leanok` (none should be present on the new blocks). PRESERVE the single `\mathlibok` on
  `lem:localized_module_map_exact_mathlib`. Do NOT alter any `\lean{}`/`\uses{}` targets (the writer set
  them deliberately for DAG coverage).
- PRESERVE the keystone's `% SOURCE`/`% SOURCE QUOTE`/`% SOURCE QUOTE PROOF` (Stacks 01HV(4)) verbatim.
- Do NOT touch the DONE B0–B4 blocks or other chapters.
- Do not fabricate citations; the four sub-lemmas are project-bespoke and stand on their informal proofs.
