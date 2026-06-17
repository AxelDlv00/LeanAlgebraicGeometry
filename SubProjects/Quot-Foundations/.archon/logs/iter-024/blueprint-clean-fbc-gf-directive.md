# Blueprint Clean Directive

## Slug
fbc-gf

## Scope
Two chapters were edited this iter and need the post-write purity pass before provers run:

1. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — a second-pass effort-breaker
   split `lem:base_change_mate_inner_eCancel` into three one-cancellation atoms
   (`lem:base_change_mate_inner_eCancel_eUnit`, `..._pushforwardComp`, `..._pullbackComp`)
   plus the assembly lemmas (`inner_eCancel`, `inner_value_eq`). Focus your purity pass on
   the region roughly lines 1990–2290 (the new Seam-A chain) and the Seam-B / Seam-C blocks.
2. `blueprint/src/chapters/Picard_FlatteningStratification.tex` — a blueprint-writer added two
   geometric-bridge lemmas `lem:gf_qcoh_fintype_finite_sections` (G1) and
   `lem:gf_flat_locality_assembly` (G3) in a new subsection, plus de-staled the
   `thm:generic_flatness` header. Focus on those new blocks and the geometric proof body.

## Tasks (standard)
- Strip project-history narrative from RENDERED PROSE: "iter-NNN", "our failed route",
  "this iter", "previously", "STUCK", deferral chatter, etc. Make the prose timeless.
- Trim conversational verbosity; keep math precise.
- Verify citation discipline on the new blocks (G1 carries a Stacks Tag 01PB
  `% SOURCE QUOTE:` from `references/stacks-properties.tex`; Seam-B `gstar_generator_close`
  carries a Stacks "Affine base change" quote from `references/stacks-coherent.tex`). If any
  `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` is missing on a block that derives from a
  reference present in `references/`, open the actual reference file and insert the verbatim
  quote.
- Fix any LaTeX / `\uses{}` / `\label{}` formatting errors.

## IMPORTANT — preserve these (NOT leakage, project convention)
- **Do NOT remove `% LEAN SIGNATURE` / `% theorem ...` comment blocks.** These are deliberate
  prover target hints attached to each `\lean{}` pin; they are LaTeX comments (never rendered)
  and the prover relies on them to create the Lean declarations. Keep them verbatim.
- **Do NOT remove `% SOURCE:` / `% SOURCE QUOTE:` / `% SOURCE QUOTE PROOF:` / `% NOTE:`
  comments.** These are citation and semantic-marker discipline.
- **Do NOT touch `\leanok` / `\mathlibok` markers** (managed by sync_leanok / review agent).
- Only strip narrative that leaks PROJECT HISTORY or Lean *tactic* strategies from the
  rendered prose body — not the comment-block scaffolding.

## Out of scope
- Do not edit any other chapter.
- Do not alter mathematical content of the proofs; you are a purity/citation pass, not a rewrite.
