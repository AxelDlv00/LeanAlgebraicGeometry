# blueprint-clean — QuotScheme post-writer purity pass (iter-004)

A blueprint-writer just added predicate-encoding blocks to
`blueprint/src/chapters/Picard_QuotScheme.tex`:
- `def:modules_annihilator`, `def:schematic_support` (schematic-support primitive),
- `def:has_proper_support` + the `\mathlibok` anchor `lem:isProper_mathlib`,
- `def:is_locally_free_of_rank`,
- wired `def:quot_functor` and `def:grassmannian_scheme` to them.

## Scope
ONLY `blueprint/src/chapters/Picard_QuotScheme.tex`.

## What to do
Strip any Lean-syntax leakage (tactic idioms, dot-notation term syntax, explicit Lean argument
lists in math mode), project-history/encoding-rationale prose, and verbosity from the newly
added blocks. Verify each new block deriving from Nitsure carries a `% SOURCE:` +
verbatim `% SOURCE QUOTE:` + visible `\textit{Source: …}` line; if a verbatim quote is missing
and you can locate it in `references/nitsure-hilbert-quot-src/*.tex`, insert it. Confirm the
`\mathlibok` on `lem:isProper_mathlib` names a genuine Mathlib declaration
(`AlgebraicGeometry.IsProper`) and that NO project-built block (annihilator / schematic support /
proper-support / rank-`d`) carries `\mathlibok` or `\leanok`.

## Do NOT
- Touch `\leanok` markers (add or remove).
- Touch the `thm:grassmannian_representable` proof sketch / its deferred-open-question NOTE
  (deliberately deferred this iter).
- Touch any other chapter.

Report fixes applied and confirm LaTeX environments balanced + `\uses`/`\ref` resolve.
