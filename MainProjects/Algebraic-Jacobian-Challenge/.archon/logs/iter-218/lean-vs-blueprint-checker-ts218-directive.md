# lean-vs-blueprint-checker directive — iter-218

Verify exactly one file pair, bidirectionally:

- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

Context you need (no strategy framing beyond this):
- The blueprint chapter was substantially rewritten this iter by a blueprint-writer:
  `\uses{}` edges reflowed (labels-only), 5 presheaf-pushforward helpers newly pinned
  under `lem:presheaf_pushforward_adj_substrate`, and the whiskering/stalk apparatus
  (`lem:islocallyinjective_whisker_of_W` and siblings) UNPINNED + `% SUPERSEDED`-marked.
  The `lem:tensorobj_inverse_invertible` proof prose was enriched (dual + contraction +
  glue). A blueprint-reviewer fast-path verdict on this chapter did NOT surface to the
  planner before objectives were set — so this check is the backstop confirming the
  chapter is adequate.

Report bidirectionally:
1. **Lean → blueprint**: does every pinned `\lean{...}` declaration exist in the Lean
   file with a matching signature? Are the unpinned/superseded whiskering+stalk decls
   correctly NOT pinned (no dangling `\lean{}`)? Is `exists_tensorObj_inverse`'s blueprint
   proof honest about the fact the Lean body is still a `sorry` (infrastructure-missing),
   or does the prose overclaim a completed construction?
2. **Blueprint → Lean**: is the `lem:tensorobj_inverse_invertible` prose detailed enough
   to guide formalization, OR does it gloss the genuinely Mathlib-absent step (the
   internal-hom/dual `ℋom_{𝒪_X}(L,𝒪_X)` object + evaluation) as if it were available?
   If the prose assumes infrastructure that does not exist, flag the chapter as the
   failure (too thin / assumes-absent-primitive), not the Lean.

Flag any must-fix-this-iter findings explicitly. Write your report to
`task_results/lean-vs-blueprint-checker-ts218.md`.
