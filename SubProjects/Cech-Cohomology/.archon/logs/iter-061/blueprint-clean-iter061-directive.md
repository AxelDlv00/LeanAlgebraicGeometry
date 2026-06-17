# Blueprint-clean directive — iter-061

Chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

This iter the chapter received: (1) a new standalone sub-lemma `lem:pushPull_coprod_prod` further
split by an effort-breaker into `lem:isIso_modules_of_toPresheaf` (L1 reflection wrapper) +
`lem:pushPull_binary_coprod_prod` (L2 binary base) + the top induction node; (2) coverage-debt
bundling of 4 helper names into `lem:cech_backbone_left_sigma` and `lem:jshriek_transport_along_iso`;
(3) removal of stale `\uses` anchors.

Tasks:
- Purity pass on the edited blocks only: strip any Lean tactic syntax / project-history verbosity that
  leaked into the new prose; keep the math textbook-rigorous.
- **Verify every `\uses{}` label introduced this iter resolves to an existing block.** In particular
  the new leaves reference `lem:forget_reflectsIso_mathlib` and `lem:evaluation_preserves_products_mathlib`
  — confirm these labels EXIST in the chapter; if either is absent, add a minimal Mathlib dependency
  anchor block (statement in project notation, `\lean{}` naming the real Mathlib decl, `\mathlibok`)
  so the `\uses` resolves. Do NOT invent a project obligation; these are Mathlib-provided.
- Do NOT touch `\leanok` markers, any `.lean` file, or other chapters.
