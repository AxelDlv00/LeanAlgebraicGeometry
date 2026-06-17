# Blueprint Writer Report

## Slug
jacobian-cube-purge

## Status
COMPLETE — every theorem-of-the-cube reference in `Jacobian.tex` purged and replaced with the
correct cube-free Milne §I.3 rigidity-chain narrative; no broken `\cref{thm:theorem_of_the_cube}`
references remain.

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Changes Made
All edits are prose-only inside the genus-0 routing narrative; no declaration blocks, signatures,
labels, or markers were added/removed.

- **Revised line ~6 (chapter intro)** — "via the rigidity-lemma + theorem-of-the-cube chain" →
  "via the Milne §I.3 rigidity chain (Rigidity Lemma + additivity Corollary 1.5 + Corollary 1.2 +
  rational-map extension), cube-free and not the differential / Serre-duality argument".
- **Revised item (c) at C.2.d (line ~397)** — relabelled "Rigidity lemma + theorem of the cube" to
  "Milne §I.3 rigidity chain (cube-free)". Removed the broken `\cref{thm:theorem_of_the_cube}` and
  the false "the Rigidity Lemma alone does not suffice". Inserted the correct base case: the
  𝔾_a/𝔾_m incompatibility (Prop 3.9, `\cref{lem:hom_from_Ga_trivial}`) via the additive-defect map
  ψ extended to ℙ¹×ℙ¹ (`\cref{lem:rational_map_to_av_extends}`) and collapsed by the Rigidity Lemma
  (`\cref{thm:rigidity_lemma}`), with `\cref{lem:hom_additivity_over_product}` for the product
  packaging.
- **Revised C.2.g (line ~417)** — "the rigidity-lemma + theorem-of-the-cube chain" → "the Milne §I.3
  rigidity chain (cube-free)"; expanded the "uses neither" clause to include the theorem of the cube.
- **Revised (γ) Mathlib-infrastructure summary (line ~434)** — same phrase replacement; "uses
  neither the theorem of the cube, nor Serre duality, nor representability".
- **Revised subsection heading (line ~448)** — "Route (c): rigidity via the theorem of the cube …"
  → "Route (c): rigidity via Milne §I.3 (cube-free; committed genus-0 proof route)".
- **Rewrote subsection body (line ~453)** — replaced the "four links … the theorem of the cube …
  the cube is required" paragraph with the cube-free four-link §I.3 description (Rigidity Lemma →
  Cor 1.5 / Cor 1.2 → rational-map extension Thm 3.2/3.4 → 𝔾_a/𝔾_m incompatibility Prop 3.9), and
  added the riskiest-sub-build note pointing at `\cref{rmk:thm32_codim1_mathlib_gap}` (surface
  codim-1 indeterminacy, Milne Lemma 3.3, no Mathlib Weil-divisor theory; on the genus-0 critical
  path).
- **Revised genusZeroWitness body-closure status (line ~481)** — "rigidity-lemma + theorem-of-the-cube
  chain" → "Milne §I.3 rigidity chain (cube-free)"; decoupled from the cube as well as Route A and
  Serre duality.
- **Revised Layer I (line ~523)** — same phrase replacement.

## Cross-references introduced
All new `\cref{...}` targets verified to exist in `AbelianVarietyRigidity.tex` before use:
- `lem:hom_from_Ga_trivial` (line 813), `lem:hom_additivity_over_product` (642),
  `lem:rational_map_to_av_extends` (734), `rmk:thm32_codim1_mathlib_gap` (782),
  `thm:rigidity_lemma` (64), `prop:morphism_P1_to_AV_constant` (868),
  `prop:genusZero_curve_iso_P1` (927), `thm:rigidity_genus0_curve_to_AV` (985).
- Confirmed `thm:theorem_of_the_cube` no longer exists anywhere (label deleted this iter); all
  references to it are removed.

These are plain `\cref` prose references (not `\uses{}` dependency edges), consistent with the
existing routing-narrative style of this chapter.

## References consulted
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` (sibling chapter, read-only) — confirmed the
  corrected cube-free §I.3 chain, the surviving label names, `rmk:cube_not_needed`, and
  `rmk:thm32_codim1_mathlib_gap`; aligned all `Jacobian.tex` prose to it. No new external source
  quotes were introduced (this is a routing narrative; per directive, the §I.3 derivation is
  already sourced verbatim from Milne in `AbelianVarietyRigidity.tex`), so no `% SOURCE` blocks were
  added and `references/abelian-varieties.pdf` was not re-opened.

## Macros needed (if any)
None.

## Notes for Plan Agent
- The protected signatures (`thm:nonempty_jacobianWitness`, `def:genusZeroWitness`,
  `def:positiveGenusWitness`, `Jacobian.*`) and all `\lean{...}` hints were left untouched.
- `Jacobian.tex` is internally consistent with `AbelianVarietyRigidity.tex` after this edit: both
  now describe the genus-0 base case as cube-free Milne §I.3, and both flag the surface
  rational-map-extension (Lemma 3.3) as the riskiest sub-build on the genus-0 critical path.

## Strategy-modifying findings
None. The edit aligns prose with the already-decided Route C (Milne §I.3, cube-free) and the
already-corrected `AbelianVarietyRigidity.tex`; no new strategy-level issue surfaced.
