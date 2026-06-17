# blueprint-clean — iter-033

## Scope
Three chapters received substantial writer edits this plan cycle and must be purity-checked
BEFORE provers run on them:

1. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — an effort-breaker added a 7-block
   FBC-B chain (`lem:sheaf_equalizer_products_mathlib`, `lem:finite_affine_cover_qcqs`,
   `lem:gamma_finite_equalizer`, `lem:base_changed_equalizer_diagram`,
   `lem:flat_base_change_separated`, `lem:flat_base_change_mayer_vietoris`,
   `lem:flat_base_change_reduce_global_sections`) plus a rewritten target proof for
   `thm:flat_base_change_pushforward`. A new `% archon:covers ... FlatBaseChange.lean
   FlatBaseChangeGlobal.lean` line was just added at the top (KEEP it — it is a structural
   directive, not verbosity).
2. `blueprint/src/chapters/Picard_QuotScheme.tex` — three coverage blocks added in the
   OverRestrictBridge region: `def:over_restrict_equiv`, `lem:over_restrict_functor_iso`,
   `lem:over_restrict_pullback_iso`.
3. `blueprint/src/chapters/Picard_GrassmannianCells.tex` — three coverage blocks added:
   `def:gr_the_glue_data`, `lem:gr_chartTransition'_cocycle`,
   `lem:gr_awayMulCommEquiv_comp_awayInclLeft`.

## Task
Standard purity pass: strip any Lean tactic syntax / Lean leakage, remove project-history /
per-iter narrative verbosity (there is a known long stale iter-031 `% NOTE` on
`def:gr_glued_scheme` whose prose now overlaps the new `lem:gr_chartTransition'_cocycle` block —
trim the redundant inline cocycle narrative, but do NOT touch `% NOTE:` semantic markers that
review owns, and do NOT remove the `% archon:covers` line). Validate that every `% SOURCE QUOTE`
on the FBC-B 02KH-derived blocks (L3/L4/L5 and the reduction block) is a verbatim quote actually
present in `references/stacks-coherent.tex` / `references/stacks-coherent.md`; insert any missing
quote. Do NOT add or remove `\leanok`/`\mathlibok`. Do NOT alter mathematical content or `\uses{}`.

You may spawn a reference-retriever if a source quote needs a file not present.
