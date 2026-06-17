# blueprint-clean bc258

Post-write purity gate on the two chapters edited this iter. For each: strip any Lean tactic syntax /
Lean leakage, remove project-history / iteration-narrative verbosity, ensure prose is math-only, and
validate that every `% SOURCE:` / `% SOURCE QUOTE:` is well-formed (these are Archon-original /
Mathlib-provenance blocks — they carry code-location `% SOURCE:` comments, NOT external-literature
verbatim quotes; do not invent quotes). Do NOT touch `\leanok`/`\mathlibok` markers.

## Chapters to clean
1. `blueprint/src/chapters/Picard_SheafOverEquivalence.tex` — NEW this iter (the SHARED-ROOT
   `SheafOfModules.overEquivalence` construction). Check: the `% archon:covers ...SheafOverEquivalence.lean`
   line is present and well-formed; the four declaration blocks
   (`def:sheafofmodules_over_equivalence`, `lem:sheafofmodules_restrict_over_iso`,
   `lem:sheafofmodules_unit_over_iso`, `lem:chart_over_iso`) read as mathematics, not as a Lean
   construction transcript.
2. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — only the D3′ Sq2/Sq2b paragraph was edited
   (`lem:pullback_tensor_map_basechange`). Check that paragraph + any inserted Sq2b sub-step block for
   Lean leakage / iteration-label noise; leave the rest of the (large) chapter untouched.

Report what you stripped per chapter.
