# Blueprint Clean Directive

## Slug
cech-bridge

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Context

A blueprint-writer just repaired this chapter (iter-010): it replaced a circular proof of
`lem:cech_to_cohomology_on_basis` with a torsor-free dimension-shift bridge, added two new bridge
lemmas (`lem:injective_cech_acyclic`, `lem:ses_cech_h1`), added a `\mathlibok` Mathlib-dependency
anchor `def:standard_affine_cover`, fixed `lem:higher_direct_image_presheaf`'s hypotheses, and
applied citation/`\uses` hygiene. Run the standard post-write purity + citation-validation pass.

## Focus

1. **Validate the new verbatim quotes.** The new/edited blocks quote `references/stacks-cohomology.tex`
   (PRESENT). Open it and confirm the `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF` text is verbatim and
   in the source's original language/notation for:
   - `lem:injective_cech_acyclic` — `lemma-injective-trivial-cech` (L1407–1431) + the supporting
     `lemma-cech-cohomology-derived-presheaves` excerpt (L1287–1398).
   - `lem:ses_cech_h1` — `lemma-ses-cech-h1` (L1593–1628).
   - `lem:cech_to_cohomology_on_basis` — the relocated `% SOURCE QUOTE PROOF` must be the verbatim
     `lemma-cech-vanish-basis` proof (01EO, L1695–1776), sitting immediately before `\begin{proof}`.

2. **Strip genuine Lean/implementation leakage and process prose.** Remove Lean-tactic mentions and
   conversational process notes. Where the chapter says things like "Mathlib provides it only for
   `Sheaf J AddCommGrpCat`" / "the prover must build this from scratch", rephrase as timeless math
   (e.g. "the presheaf-level Čech δ-functor formalism over `O_X`-modules is developed here"), keeping
   the mathematical point that this machinery is part of the chapter's content — drop the
   Mathlib-state / prover-facing framing.

3. **PRESERVE (do NOT strip):**
   - the `\mathlibok` anchor block `def:standard_affine_cover` and its `\lean{AlgebraicGeometry.Scheme.affineOpenCoverOfSpanRangeEqTop}` hint;
   - every `\lean{...}` hint and every `\uses{...}`/`\label{...}` (the dependency graph just got fixed — do not perturb it);
   - the two new bridge lemma blocks and their proof sketches;
   - the existing contracting-homotopy `% SOURCE QUOTE PROOF` of `lem:cech_acyclic_affine`.
   - Do NOT touch `\leanok` markers (deterministic phase owns them).

4. **LaTeX hygiene.** Fix any syntax errors introduced; confirm the relocated `% SOURCE QUOTE PROOF`
   block and the new lemma environments are well-formed.

## Out of scope
- Other chapters; `.lean` files; `content.tex`.
- Do NOT re-argue the mathematics or change any statement/proof structure — this is a purity +
  citation-validation pass, not a rewrite.
