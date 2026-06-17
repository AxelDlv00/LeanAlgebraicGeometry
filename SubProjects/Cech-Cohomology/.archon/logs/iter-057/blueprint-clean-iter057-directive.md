# Blueprint-clean directive — iter-057

The chapter `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` received two write rounds this
iter: (1) blueprint-writer `cech-fixes` (re-spec Stubs 5/6 to the augmented complex `D'_aug`; new
change-of-ring seed `lem:affine_cech_vanishing_general_seed`; revised `lem:affine_serre_vanishing_general_open`;
7 coverage-debt blocks + wire-ups); (2) effort-breaker `stub1` (split `lem:cech_backbone_left_sigma` into
`lem:cechBackbone_obj_widePullback`, `lem:coproduct_distrib_fibrePower`, `lem:widePullback_openImm_inter`
+ Mathlib anchors).

Enforce blueprint purity on the chapter:
- Strip any Lean tactic syntax / code leakage from the new/edited prose (math-only proof sketches).
- Remove project-history verbosity / iteration references that crept into prose.
- Validate that `% SOURCE:` / `% SOURCE QUOTE:` comments on the new blocks (Stacks 01HV, 02KE
  `lemma-cech-cohomology-quasi-coherent-trivial`, 009L) are present, verbatim, and name the local
  `references/` file they were read from; insert missing verbatim quotes from the `references/` PDFs/TeXs
  if any are absent (you may spawn a reference-retriever via the authorized `references/**` domain).
- Do NOT add or remove `\leanok`/`\mathlibok`. Do NOT alter mathematical content or `\uses{}` edges.
- Keep the build-target `% NOTE:` lines (they flag decls the prover will create).
