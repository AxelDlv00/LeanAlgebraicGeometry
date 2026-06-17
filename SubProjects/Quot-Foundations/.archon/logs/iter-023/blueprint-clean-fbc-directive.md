# Blueprint Clean Directive

## Slug
fbc

## Target chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

## Context
An effort-breaker round just split `lem:base_change_mate_gstar_transpose` into a 5-lemma `\uses`-linked chain (Seam A: `lem:base_change_mate_inner_unitReduce` → `lem:base_change_mate_inner_eCancel` → `lem:base_change_mate_inner_value_eq`; Seam B: `lem:base_change_mate_gstar_generator_close`; Seam C: `lem:base_change_mate_gstar_counit_transport`) and rewrote the target proof to a short 4-move combine. These five new blocks (and the rewritten target proof) are the primary thing to clean.

## Tasks (priority order)
1. **Strip Lean leakage & project history from the NEW/edited blocks.** The effort-breaker report references the "landed `huce` scaffold", "iter-022 scaffold", "lines ~1552–1589", etc. Ensure none of that project-history / Lean-implementation narrative leaked into the chapter prose. The blocks must read as timeless mathematics. Remove any tactic names, `set`/`have` references, line-number references, or "iter-NNN" stamps if present in prose.
2. **Verify citation discipline on the new blocks that derive from Stacks.** `lem:base_change_mate_inner_value_eq` and `lem:base_change_mate_gstar_generator_close` should each carry a `% SOURCE:` (read from `references/stacks-coherent.tex`) + verbatim `% SOURCE QUOTE:` and a visible `\textit{Source: …}`. Confirm the quotes are verbatim from the local `references/stacks-coherent.tex` (the "boils down to the equality `(R'⊗_R A)⊗_A M = R'⊗_R M`" step around L933–938, and the `X' = Spec(R'⊗A)` step around L928–932). If any quote is missing or paraphrased, open the local file and insert the verbatim text. The purely-categorical bridge blocks (`inner_unitReduce`, `inner_eCancel`, `counit_transport`) are project-bespoke conjugate-calculus and need no external source — do not fabricate one.
3. **Trim verbosity** in the rewritten target proof and the new blocks — keep prose concise and mathematically precise; remove redundant restatement.
4. **Fix any LaTeX / `\uses{}` / `\label{}` formatting issues** in the edited region. NOTE: there is a pre-existing dangling `\uses{lem:base_change_regroup_linearEquiv}` in `lem:base_change_mate_regroupEquiv` — that is a known issue being handled by the review agent's `% NOTE:` marker; do NOT try to fix it here (leave it).

## Out of scope
- Do NOT touch `\leanok` / `\mathlibok` markers anywhere.
- Do NOT edit the dead `lem:base_change_mate_fstar_reindex` / `_legs` blocks (separate refactor).
- Do NOT touch any other chapter.
