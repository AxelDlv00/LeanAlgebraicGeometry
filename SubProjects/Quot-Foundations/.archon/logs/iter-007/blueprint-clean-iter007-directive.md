# Blueprint-clean directive — iter-007

Two chapters were rewritten this iter by blueprint-writers (crux effort-breaks):
- `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — rewrote the
  `lem:base_change_mate_regroupEquiv` proof (removed an unsound one-liner prescription, encoded the
  sound generator-wise R'-linearity rationale); added 3 new sub-lemma blocks
  (`lem:base_change_mate_unit_value`, `lem:base_change_mate_fstar_reindex`,
  `lem:base_change_mate_gstar_transpose`) and rewrote `lem:base_change_mate_generator_trace_eq` as a
  thin assembly.
- `blueprint/src/chapters/Picard_FlatteningStratification.tex` — added `lem:gf_generic_rank_ses`,
  `lem:gf_torsion_reindex`, `lem:gf_clear_one_denominator`; rewrote `lem:gf_polynomial_core` (L5) and
  `lem:gf_noether_clear_denominators` (L4) as thin assemblies; added `% LEAN PROOF STRUCTURE` /
  base-domain-generalization notes.

## Clean both chapters
Apply the standard blueprint-purity pass to BOTH files:
- Strip any Lean tactic syntax / code leakage from the prose (the new sub-lemmas may carry Lean-ish
  signature prose — keep `\lean{}` pins and `% LEAN SIGNATURE`/`% LEAN PROOF STRUCTURE` comment blocks
  intact, but ensure the *visible* prose is mathematical, not Lean tactics).
- Remove project-history / session-narrative verbosity from prose bodies (iter-NNN references in
  visible text). NOTE comments documenting structural decisions (base-domain generalization, shared
  engine, tensor-order convention) are legitimate and should be KEPT as `% NOTE:` comments.
- Validate every `% SOURCE:` / `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` block: confirm the named
  `references/` file exists and the quote is verbatim. The new sub-lemmas reuse the Nitsure §4 and
  Stacks "Affine base change" citations already in the chapters; confirm those quotes are intact and
  correctly attributed. If a new sub-lemma needs a source quote that is missing, insert it from the
  local reference file (`references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` for GF;
  `references/stacks-coherent.tex` for FBC) — spawn a reference-retriever ONLY if the needed local
  file is genuinely absent.
- Do NOT add or remove `\leanok` / `\mathlibok` markers.
- Do NOT change any `\lean{}` pin, `\label{}`, or `\uses{}` edge (the leandag graph is already
  verified consistent — preserve it).

## Report
Per file: what was stripped/fixed, and confirmation that the SOURCE quotes are verbatim against the
local reference files. Confirm no `\uses{}`/`\label{}`/`\lean{}` edges were altered.
