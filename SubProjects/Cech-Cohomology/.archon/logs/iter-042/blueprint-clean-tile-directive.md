# Blueprint-clean directive

## Chapter
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Context
A blueprint-writer round (slug `tile-descent`) just edited this chapter to (a) add a base-ring-descent
lemma block `lem:isLocalizedModule_powers_restrictScalars_of_algebraMap`, (b) add two sub-lemma blocks
`lem:tile_image_opens_identities` (Sub-lemma A) and `lem:tile_section_comparison` (Sub-lemma B), and
(c) rewrite the proof sketch of `lem:tile_section_localization` to an honest 5-step base-ring descent
(replacing an unsound `restrict_obj`-rfl recipe). It also added `AlgebraicGeometry.res_trans_apply` to the
`\lean{}` list of `lem:qcoh_section_equalizer`.

## Task
Enforce blueprint purity on the **edited blocks** (the four blocks named above and their proofs). In
particular:
- Strip Lean-syntax leakage from the PROSE (not from `\lean{}` / `\uses{}` / `\label{}` / `% NOTE` /
  `% SOURCE` comments, which are structural and must stay). The new prose may contain bare Lean
  identifiers such as `modulesSpecToSheaf.obj`, `restrict_obj`, `globalSectionsIso`, `restrictScalars`,
  `Module.End.isUnit_iff`, `PrimeSpectrum.basicOpen_mul`, `IsScalarTower`, `IsLocalizedModule`,
  `of_restrictScalars`, `algebraMap`, the `''ᵁ` image-open notation, etc. Where these appear in
  *rendered math/prose*, replace them with the project's mathematical notation (e.g. spell out
  "the global-sections identification", "the image open `ι(V)`", "localisation at the powers of `f`"),
  while PRESERVING the mathematical content and the distinction the writer is drawing (local-ring
  `Γ(M,-)` functor where the comparison is definitional vs the global-ring sections functor where it is
  not). It is acceptable — even desirable — to keep a single `% NOTE` comment that names the underlying
  Lean functors for the prover's benefit, since comments do not render; just keep them OUT of the visible
  prose.
- Remove any project-history / iter-narrative verbosity from the visible prose (a brief `% NOTE` comment
  recording that the old recipe was unsound is fine as a COMMENT, not as rendered text).
- Validate `\uses{}`/`\label{}` consistency; do not change the dependency structure the writer set up.
- Do NOT add or remove `\leanok` / `\mathlibok`.
- Do NOT touch blocks other than the four edited ones (and the `lem:qcoh_section_equalizer` `\lean{}`
  line, which is correct as-is — leave it).

## Scope
Only `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`. `references/**` is in your write
domain in case a missing source quote must be inserted (none is expected — this content is
project-bespoke plumbing, no external citation).
