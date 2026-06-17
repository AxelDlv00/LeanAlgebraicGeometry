# blueprint-clean directive — iter-037

## Chapter to clean
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Context
A blueprint-writer round (iter-037) just added the Route B keystone chain: 3 local-model brick blocks
(`lem:tilde_section_isLocalizedModule`, `lem:section_isLocalizedModule_of_isIso_fromTildeGamma`,
`lem:section_isLocalizedModule_of_presentation`), 4 to-build bridge blocks
(`lem:qcoh_finite_presentation_cover`, `lem:presentation_over_basicOpen`, `lem:restrict_over_compat`,
`lem:presentation_modulesRestrictBasicOpen`), 6 `\mathlibok` anchors, a rewritten keystone proof, and a
corrected Route B section intro.

## Task
Enforce blueprint purity on the edited region (and anywhere else you spot drift):
- Strip Lean syntax / tactic strings / Lean type-ascription leakage from prose and proofs (keep
  `\lean{}`/`\uses{}`/`\mathlibok` markers and the `% SOURCE`/`% NOTE` comments intact).
- Remove project-history / iteration-narrative verbosity (e.g. "iter-036 prover did X", "planner action")
  from visible prose — such notes belong in `% NOTE` comments at most, not the typeset body.
- Validate that every `% SOURCE QUOTE` present is genuinely verbatim from the cited local file; if a
  quote is missing for a block that cites an external source, insert it from the referenced file (you may
  spawn a reference-retriever if the source file is absent — write-domain includes `references/**`).
- Do NOT add or remove `\leanok`. Do NOT alter the mathematical statements or `\uses{}` edges.
