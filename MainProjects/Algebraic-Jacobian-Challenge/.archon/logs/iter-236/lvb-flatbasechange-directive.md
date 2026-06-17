# lean-vs-blueprint-checker directive — iter-236 — FlatBaseChange

Verify ONE Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## What to check
- This iter added 3 axiom-clean support decls: `gammaPushforwardIso`,
  `gammaPushforwardTildeIso`, `globalSectionsIso_hom_comp_specMap_appTop`. These
  currently have NO `\lean{...}` pins in the chapter. Report whether the chapter
  should gain pinned statement blocks for them (Lean→blueprint gap).
- The chapter's `lem:pushforward_spec_tilde_iso` (or equivalent) remains
  unformalized — its sole open obligation is quasi-coherence of the pushforward.
  Confirm the chapter prose accurately reflects this (not over-claiming a closed
  proof) and that the 4-movement proof sketch matches the Lean decomposition.
- The 2 remaining `sorry` sites (`affineBaseChange_pushforward_iso`,
  `flatBaseChange_pushforward_isIso`) — confirm the blueprint marks them as
  open, not `\leanok`.
- Report bidirectionally.
