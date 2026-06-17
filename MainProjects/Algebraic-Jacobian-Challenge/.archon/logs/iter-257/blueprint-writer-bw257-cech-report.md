# Blueprint Writer Report

## Slug
bw257-cech

## Status
COMPLETE — new chapter `Cohomology_CechHigherDirectImage.tex` authored with all 6
directive declarations (3 definitions, 3 lemmas, each lemma with a proof sketch),
all citation blocks grounded in `references/stacks-coherent.tex`, and the
`\input` added to `content.tex`.

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex (NEW)

## Changes Made
- **Created chapter** with `\chapter{...}` + `\label{chap:Cohomology_CechHigherDirectImage}`
  + `% archon:covers AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` + a top
  `% SOURCE:` block. Setup section explicitly motivates the unconditional (no
  `[HasInjectiveResolutions]`) {\v C}ech route as the complement to
  `Cohomology_HigherDirectImage.tex`.
- **Added definition** `\definition`/`\label{def:cech_nerve}`/`\lean{AlgebraicGeometry.CechNerve}`
  — {\v C}ech nerve of a finite affine open cover as an augmented simplicial object in
  `QCoh(X)` (pushforwards over finite intersections; standard-cover affine model).
- **Added definition** `\definition`/`\label{def:cech_complex}`/`\lean{AlgebraicGeometry.CechComplex}`
  `\uses{def:cech_nerve}` — the {\v C}ech complex `Č^•(𝔘,ℱ)` (global-sections version
  and the relative `f_*`-version in `QCoh(S)`), with the localisation form over an affine.
- **Added lemma** `\lemma`/`\label{lem:cech_acyclic_affine}`/`\lean{AlgebraicGeometry.CechAcyclic.affine}`
  `\uses{def:cech_complex}` — {\v C}ech cohomology of a quasi-coherent sheaf on an affine
  vanishes in positive degrees (Serre vanishing). Proof sketch added: Y (contracting
  homotopy after localisation + basis-cohomology comparison).
- **Added lemma** `\lemma`/`\label{lem:cech_computes_cohomology}`/`\lean{AlgebraicGeometry.cech_computes_higherDirectImage}`
  `\uses{lem:cech_acyclic_affine, def:cech_complex}` — for separated quasi-compact `f`
  and an affine cover, `H^i(Č^•(𝔘,ℱ)) ≅ R^i f_*ℱ`. Proof sketch added: Y
  ({\v C}ech-to-cohomology + Leray degeneration over affine base).
- **Added definition** `\definition`/`\label{def:cech_higher_direct_image}`/`\lean{AlgebraicGeometry.cechHigherDirectImage}`
  `\uses{lem:cech_computes_cohomology}` — the UNCONDITIONAL `R^i f_*ℱ` as the `i`-th
  cohomology sheaf of the relative {\v C}ech complex, with cover-independence note.
- **Added lemma** `\lemma`/`\label{lem:cech_flat_base_change}`/`\lean{AlgebraicGeometry.cech_flatBaseChange}`
  `\uses{def:cech_higher_direct_image, lem:cech_computes_cohomology}` — flat base change
  `g^*(R^i f_*ℱ) ≅ R^i f'_*((g')^*ℱ)`. Proof sketch added: Y (term-wise `−⊗_A B` on
  the {\v C}ech complex + flatness ⇒ exactness commutes with cohomology).
- **Edited** `blueprint/src/content.tex`: inserted `\input{chapters/Cohomology_CechHigherDirectImage}`
  in the Cohomology group, immediately after `Cohomology_HigherDirectImage` (directive
  explicitly authorized this content.tex edit; the write succeeded under the granted
  write-domain).

## Cross-references introduced
All `\uses` edges are internal to this chapter and resolve to labels defined in it:
- `def:cech_complex \uses def:cech_nerve` ✓
- `lem:cech_acyclic_affine \uses def:cech_complex` ✓
- `lem:cech_computes_cohomology \uses lem:cech_acyclic_affine, def:cech_complex` ✓
- `def:cech_higher_direct_image \uses lem:cech_computes_cohomology` ✓
- `lem:cech_flat_base_change \uses def:cech_higher_direct_image, lem:cech_computes_cohomology` ✓
No cross-chapter `\uses` were introduced (forward-spec chapter, isolated as directed).

## References consulted
- `references/summary.md` — index; confirmed `stacks-coherent.tex` = Stacks ch.30
  "Cohomology of Schemes" and that Tag 02KH = flat base change.
- `references/stacks-coherent.tex` — verbatim quotes for every citation block:
  - Lemma `lemma-cech-cohomology-quasi-coherent-trivial` (L44–135): standard cover,
    {\v C}ech complex form, contracting-homotopy proof → `def:cech_nerve`,
    `def:cech_complex`, `lem:cech_acyclic_affine`.
  - Lemma `lemma-quasi-coherent-affine-cohomology-zero` (L145–174): Serre vanishing
    statement + basis-comparison proof → `lem:cech_acyclic_affine`.
  - Lemma `lemma-cech-cohomology-quasi-coherent` (L245–264): {\v C}ech computes
    `H^p(X,ℱ)` when all intersections affine → `lem:cech_computes_cohomology`.
  - Lemma `lemma-quasi-coherence-higher-direct-images-application` (L843–868):
    `H^q(X,ℱ)=H^0(S,R^qf_*ℱ)` over affine `S` + Leray-degeneration proof →
    `lem:cech_computes_cohomology`, `def:cech_higher_direct_image`.
  - Lemma `lemma-flat-base-change-cohomology` (L947–1050): flat base change statement
    + {\v C}ech-complex `−⊗_A B` proof → `lem:cech_flat_base_change`.

## Macros needed (if any)
None new. Chapter uses `\operatorname{Spec}`, `\operatorname{QCoh}`, `{\v C}ech`,
`\check{...}`, `\widehat{...}`, `\widetilde{...}` — all standard / already used by the
sibling `Cohomology_HigherDirectImage.tex`.

## Reference-retriever dispatches (if any)
None. All needed material was present in `references/stacks-coherent.tex`.

## Notes for Plan Agent
- **Tag numbers vs. label names.** The directive specifies Stacks tags 02KE–02KH, but
  `references/stacks-coherent.tex` is the source `.tex` and carries `\label{lemma-...}`
  names, NOT literal `\tag{02Kx}` macros (none of `02KE/02KF/02KG/02KH` appear as text
  in the file). To honour the "cite only what you read" rule I cited each block by its
  verifiable `\label{...}` name plus exact line range, and attached the directive's tag
  (02KG affine vanishing, 02KE {\v C}ech-computes, 02KH flat base change) as a secondary
  pointer where the directive named one. This matches the convention already used in the
  sibling `Cohomology_HigherDirectImage.tex` (which likewise pairs a tag with the Stacks
  lemma label). If the project wants exact tag verification, a reference-retriever could
  confirm the tag↔label map on stacks.math.columbia.edu, but the verbatim quotes here are
  exact copies of the local file.
- **Relation to `HigherDirectImage.lean`.** This chapter is deliberately self-contained
  and does not `\uses` anything from `Cohomology_HigherDirectImage.tex`; the two `R^i f_*`
  constructions (derived-functor, gated by `[HasInjectiveResolutions]`, vs. unconditional
  {\v C}ech) are isolated as requested. A future iteration may add a single bridge lemma
  identifying the two when both are defined — flagged for awareness, not authored here.
- **`def:cech_higher_direct_image` is partly Archon-original packaging** (the
  unconditional cohomology-of-{\v C}ech-complex definition); I grounded it in
  `lemma-quasi-coherence-higher-direct-images-application` and
  `lemma-cech-cohomology-quasi-coherent` and labelled the packaging explicitly as
  Archon-original in the visible `\textit{Source: ...}` line, per citation discipline for
  bespoke results.

## Strategy-modifying findings
None. The {\v C}ech route as specified is mathematically standard (Stacks 02KE/02KG/02KH)
and the unconditional construction is sound; nothing surfaced that contradicts STRATEGY.md.
