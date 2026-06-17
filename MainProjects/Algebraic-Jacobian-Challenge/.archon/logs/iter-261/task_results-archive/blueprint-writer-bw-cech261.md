# blueprint-writer report — bw-cech261

## Outcome: DONE — citation hygiene fix applied, zero broken visible `\ref{}`

Edited only `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`. No
`\leanok`/`\mathlibok` markers touched; no mathematical content changed; covers-line
left as-is (forward-spec for `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`).

## What was wrong
The chapter used `\ref{}` (a DAG cross-reference macro) where plain Stacks-tag
citations were meant. The targets are Stacks-project *internal* lemma names with no
`\label{}` anywhere in the blueprint, so they broke the DAG and rendered as "??" in the
visible `\textit{Source: ...}` lines. The five offending names:
`lemma-cech-cohomology-quasi-coherent-trivial`,
`lemma-quasi-coherent-affine-cohomology-zero`,
`lemma-cech-cohomology-quasi-coherent`,
`lemma-quasi-coherence-higher-direct-images-application`,
`lemma-flat-base-change-cohomology`.

## Fix
Converted every `\ref{<one-of-the-five>}` to a plain-text Stacks citation:

**Visible `\textit{Source:}` lines (DAG-critical)** — rewrote with tags where confident:
- `lemma-cech-cohomology-quasi-coherent` → `Stacks, Tag 02KE (\texttt{...})`
- `lemma-flat-base-change-cohomology` → `Stacks, Tag 02KH (\texttt{...}, ``Flat base change'')`
- `lemma-quasi-coherent-affine-cohomology-zero` → `Stacks, Tag 02KG (\texttt{...}, Serre vanishing on affines)`
- `lemma-cech-cohomology-quasi-coherent-trivial` → `\texttt{...}` (no tag — see below)
- `lemma-quasi-coherence-higher-direct-images-application` → `\texttt{...}` (no tag — see below)

Tags 02KE / 02KG / 02KH were the ones already present in the chapter (02KH cross-checked
against `references/stacks-coherent.md`, which documents the Tag→label map for that
lemma). For the two lemmas where no tag is asserted in the chapter and I could not confirm
one with certainty from the available references (`stacks-coherent.tex` carries no inline
tags; no `tags/tags` map in `references/`), I followed the directive's fallback and cited
the lemma by its Stacks label-name in `\texttt{...}` without `\ref{}` and without an
invented tag.

**Comment occurrences (`% SOURCE:` blocks)** — the same five names appearing in the
`% SOURCE:` header/comment lines were converted from `\ref{name}` to `\texttt{name}` so
the source comments read as plain Stacks citations too.

## Verification
- Every `\ref`/`\cref` on a **visible (non-comment) line** now targets a local label:
  `chap:Cohomology_HigherDirectImage` (confirmed present in
  `Cohomology_HigherDirectImage.tex:2`), `def:cech_nerve`, `def:cech_complex`,
  `def:cech_higher_direct_image`, `lem:cech_acyclic_affine`, `lem:cech_computes_cohomology`.
  All defined in-chapter (the genuine local refs were correctly left untouched).
- No non-local `\ref` survives on any non-comment line (grep confirmed empty).

## Remaining non-local `\ref`s are all inside `%` comments (left untouched, by design)
The verbatim `% SOURCE QUOTE` reproductions of Stacks proof text still contain Stacks
`\ref{}`s to *other* chapters' lemmas — `algebra-lemma-cover-module`,
`algebra-lemma-characterize-zero-local`, `cohomology-lemma-cech-vanish-basis`,
`cohomology-lemma-cech-spectral-sequence-application`, `cohomology-lemma-Leray`,
`cohomology-lemma-base-change-map-flat-case`, `lemma-affine-base-change`,
`lemma-quasi-coherence-higher-direct-images`, `schemes-definition-standard-covering`, and
the matched `equation-extended` label/ref pair. These were NOT in the directive's
named-pattern list and the deterministic doctor did not flag them — consistent with the
doctor scanning only non-comment lines. They are verbatim quote text, so I left them
intact rather than mutate quoted source. (`equation-extended` is additionally a matched
`\label`/`\ref` pair, both in comments, so it is not broken even if comments are scanned.)

## No blocks needed promotion
None of the broken `\ref`s genuinely referred to a lemma that should become a *local*
blueprint block — they were all Stacks-project citations. Nothing to scope separately.
