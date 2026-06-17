# Blueprint-clean directive — slug `iter033`

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## What changed this iter (focus your pass here)
The blueprint-writer (`tosheaf` slug) just edited this chapter:
- Replaced the wrong proof of `lem:to_sheaf_preserves_epi` and added a new sub-lemma
  `lem:toSheaf_preservesFiniteColimits` (project-bespoke Mathlib infra; the
  `PreservesFiniteColimits` dual route via the sheafification square + left-adjoint reflector).
- Added 3 `\mathlibok` Mathlib dependency anchors.
- Corrected `lem:standard_cover_cofinal` to the realized indexed-cover/refinement form.

## Your job
Standard purity pass on this chapter: strip any Lean syntax / tactic strings that leaked into prose,
remove project-history verbosity, ensure every `% SOURCE`/`% SOURCE QUOTE` that IS present is
verbatim against the named local reference file. NOTE: `lem:toSheaf_preservesFiniteColimits` and
`lem:to_sheaf_preserves_epi` are project-bespoke Mathlib gap-fills with NO external math source —
they correctly have no `% SOURCE` quote; do not flag their absence. The `\mathlibok` anchors
reference Mathlib decls (no external math source needed). Confirm all `\uses{}` resolve and no
`\label` is duplicated.
