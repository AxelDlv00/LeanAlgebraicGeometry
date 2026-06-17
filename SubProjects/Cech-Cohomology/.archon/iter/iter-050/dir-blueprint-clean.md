# Blueprint-clean directive

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Context
Two blueprint-writer passes this iter edited the 02KG region of this chapter:
1. Fixed `lem:affine_cech_vanishing_qcoh` to the change-of-base-to-`R_f` argument; added the residual
   chain + `lem:cechCohomology_isZero_of_iso` transport + `lem:affine_cover_span_localizationAway`.
2. Realigned the residual `lem:affine_cech_vanishing_tilde_subcover` from route A to route B
   (change-of-ring, pinned to `sectionCech_homology_exact_of_localizationAway`); deleted the route-A infra
   blocks; added the `AwayComparison.comparison_isLocalizedModule` anchor.

## Task
Standard post-write purity pass over the edited 02KG blocks (and any block whose `\uses{}` was touched):
- Strip any Lean-identifier leakage, project-history / iteration narrative, and planner-process phrasing
  from the prose (keep `% NOTE`/`% SOURCE`/`% TODO` comment lines — those are intentional machine markers).
- Verify the `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` lines match the cited Stacks source
  (`references/stacks-coherent.tex`, Tag 02KG / `lemma-cech-cohomology-quasi-coherent-trivial`); insert a
  missing quote if any source claim lacks one.
- Confirm the math reads as math (no "the prover", "this iter", "route A/B" implementation chatter in the
  proof bodies; a brief neutral phrasing of the change-of-ring argument is fine).
- Do NOT alter `\uses{}`/`\lean{}`/`\label{}` wiring or add `\leanok`.
