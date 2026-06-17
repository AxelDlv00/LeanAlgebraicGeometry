# Blueprint Writer Report

## Slug
dag-identitycomponent266

## Status
COMPLETE — the two combined proofs were redistributed into one focused
`\begin{proof}` block per theorem; all five ∞-source theorems now host a
non-empty proof body and report finite effort in leandag.

## Target chapter
blueprint/src/chapters/Picard_IdentityComponent.tex

## Changes Made

### First combined proof (abstract identity-component substrate, was ≈L302)
Split the four-paragraph combined proof of
`\crefrange{thm:identity_component_open_subgroup}{thm:identity_component_base_change_commutes}`
into four per-theorem `\begin{proof}` blocks, each immediately following
its `\end{theorem}`:

- **`thm:identity_component_open_subgroup`** — proof = "clopen subscheme"
  paragraph. `\uses{def:identity_component_group_scheme}`. The verbatim
  Kleiman `% SOURCE QUOTE PROOF:` (lem:agps(3) proof, L2864–L2911,
  covering all four conclusions) was **relocated** to immediately precede
  this proof (it was previously sitting ≈L272 before the combined proof).
- **`thm:identity_component_is_subgroup_homomorphism`** — proof =
  "subgroup homomorphism" paragraph (EGA IV₂ 4.5.8).
  `\uses{thm:identity_component_open_subgroup, def:identity_component_group_scheme}`.
- **`thm:identity_component_finite_type_geom_irreducible`** — proof =
  "finite type + geometric irreducibility" paragraph (EGA IV₂ 4.6.1,
  EGA I 6.1.10). Reworded "by the previous paragraph" → explicit
  `\cref{thm:identity_component_base_change_commutes}` since the
  paragraphs are no longer adjacent.
  `\uses{thm:identity_component_open_subgroup, thm:identity_component_base_change_commutes, def:identity_component_group_scheme}`.
- **`thm:identity_component_base_change_commutes`** — proof =
  "base-change commutation" paragraph. Wired the geometric-connectedness
  step explicitly to the first-class Stacks 037Q lemma already in the
  chapter. `\uses{thm:identity_component_open_subgroup, lem:geometricallyConnected_of_connected_of_section, def:identity_component_group_scheme}`.
- **Removed** the combined `\begin{proof}` (and the now-duplicated
  Kleiman `% SOURCE QUOTE PROOF:` comment + the stale "% Note: the lemma
  above … the proof block below" comment), replacing them with a short
  navigational `%` comment pointing at the four per-theorem proofs.

### Second combined proof (Pic-zero abelian variety, was ≈L621)
Split into per-theorem `\begin{proof}` blocks:

- **`thm:pic_zero_is_abelian_variety`** — proof = "Abelian-variety
  structure (i)–(iv)" paragraphs verbatim. The Kleiman `th:qpp&p`
  `% SOURCE QUOTE PROOF:` (projectivity) was **relocated** to precede
  this proof.
  `\uses{def:pic_zero_subscheme, thm:identity_component_open_subgroup, thm:identity_component_is_subgroup_homomorphism, thm:identity_component_finite_type_geom_irreducible, thm:identity_component_base_change_commutes, thm:fga_pic_representability, thm:pic_is_group_scheme}`.
- **`thm:pic_zero_dimension_equals_genus`** — proof = "Dimension equals
  the genus" paragraph. The Kleiman `cor:sm` `% SOURCE QUOTE PROOF:`
  (dimension) was **relocated** to precede this proof. "Step (iv) above"
  reworded to reference `\cref{thm:pic_zero_is_abelian_variety}` (step
  (iv) of its proof). `\uses{thm:pic_zero_is_abelian_variety, def:genus}`.
- **`thm:pic_zero_k_points_iff_degree_zero`** — proof = residual
  "Identification with the kernel of the degree map" paragraph (kept as
  this theorem's proof, per directive).
  `\uses{thm:pic_zero_is_abelian_variety, thm:identity_component_open_subgroup, def:pic_zero_subscheme, def:divisor_degree_pic}`.
- **Removed** the combined `\begin{proof}` and its (now-split) combined
  `% SOURCE QUOTE PROOF:` comment block.

### Descriptive comments
- Updated the two `%`-comment "roadmap" blocks (one before each section's
  theorem cluster) that previously said "The combined proof … follows the
  Nth block" to describe the new per-theorem proof structure. No
  `% SOURCE` / `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` / `\textit{Source:}`
  citation text was added, changed, or fabricated — only relocated verbatim.

No new mathematics was introduced; no theorem statements or `\lean{}`
targets were changed; no `\leanok`/`\mathlibok` markers were touched.

## Cross-references introduced
All `\uses{}` targets resolve (verified by leandag: `unknown_uses: []`,
`conflicts: []`). Targets and their home chapters:
- `def:identity_component_group_scheme`, `thm:identity_component_*`,
  `def:pic_zero_subscheme`, `def:divisor_degree_pic`,
  `lem:geometricallyConnected_of_connected_of_section` — this chapter.
- `thm:fga_pic_representability`, `thm:pic_is_group_scheme` — chapter
  `Picard_FGAPicRepresentability`.
- `def:genus` — chapter `Genus`.

## leandag verification
`leandag build --json`: `conflicts: []`, `unknown_uses: []`. After the
edit each of the five ∞-source theorems carries a non-empty `proof_tex`
and a finite `effort_total` (no longer null/∞):
- `thm:identity_component_open_subgroup` → effort_total 0 (Lean sorry-free)
- `thm:identity_component_is_subgroup_homomorphism` → 842
- `thm:identity_component_finite_type_geom_irreducible` → 1498
- `thm:identity_component_base_change_commutes` → 1127
- `thm:pic_zero_is_abelian_variety` → 3054
- `thm:pic_zero_dimension_equals_genus` → 710
- `thm:pic_zero_k_points_iff_degree_zero` → 1130

Environment delimiters balanced: 7 `\begin{theorem}` / 7 `\end{theorem}`,
8 real `\begin{proof}` / 8 `\end{proof}` (each theorem + the pre-existing
Stacks-037Q lemma each have exactly one proof).

## References consulted
No new citation blocks were authored; every `% SOURCE`/`% SOURCE QUOTE`/
`% SOURCE QUOTE PROOF`/`\textit{Source:}` line in the final chapter is a
verbatim relocation of text already present in the chapter on entry. I
confirmed the cited local source files exist on disk:
- `references/kleiman-picard-src/kleiman-picard.tex` — home of the
  relocated lem:agps(3), th:qpp&p, and cor:sm proof quotes.
- `references/abelian-varieties.pdf` — Milne quotes (already in statement
  blocks; not relocated).
- `references/stacks-varieties.tex` — Stacks 037Q/04KV (already in the
  lemma block; not relocated).

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The base-change proof of `thm:identity_component_base_change_commutes`
  now invokes `lem:geometricallyConnected_of_connected_of_section`
  (defined later in the same chapter — a forward `\cref`/`\uses`, which is
  fine for blueprint/leandag). This makes the prior "substrate footnote"
  status of that lemma into an explicit DAG edge, which is what the
  iter-194 note in the chapter intended.
- `thm:identity_component_finite_type_geom_irreducible` now `\uses`
  `thm:identity_component_base_change_commutes` (base-change to k̄ is the
  premise of the finite-type/irreducibility argument), so the two are
  ordered open → base_change-dependency in the DAG. No cycle (base_change
  does not use finite_type).

## Strategy-modifying findings
None.
