# Blueprint Writer Report

## Slug
render-picard-identitycomponent

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_IdentityComponent.tex

## Summary
Pure rendering / cross-reference repair pass. No mathematics, no `\lean{}`,
no `\label{}`, no `\uses{}` edge, and no `\leanok`/`\mathlibok` markers were
changed. Only bare-label prose tokens, one literal `REF`, and one
math-delimiter style inconsistency were repaired.

## Changes Made

### bare-label (doctor count: 17 — lem:agps×12, th:qpp×3, cor:sm×2; plus
prp:pic0, ex:jac, rmk:Jac which the doctor regex missed but are equally bare)

All bare Kleiman-paper internal labels in **rendered prose** were replaced
with the source's human-readable numbers, verified against
`references/kleiman-picard.pdf` (theorems numbered by section,
`\newtheorem{thm}{Theorem}[section]`, shared counter):

| internal label | Kleiman number | verified via |
| --- | --- | --- |
| `lem:agps`  | Lemma 5.1      | PDF p.36 "Lemma 5.1" |
| `prp:pic0`  | Proposition 5.3| PDF p.36 "Proposition 5.3" |
| `th:qpp&p`  | Theorem 5.4    | PDF p.36 "Theorem 5.4" |
| `cor:sm`    | Corollary 5.13 | PDF p.44 "Corollary 5.13" |
| `ex:jac`    | Exercise 5.23  | PDF p.50 "Exercise 5.23" |
| `rmk:Jac`   | Remark 5.26    | PDF p.51 "Remark 5.26" |

Rendered-prose sites fixed (all now read e.g. "Lem.~5.1", "Thm.~5.4",
"Exercise~5.23"): the `\textit{Source: ...}` lines of
`def:identity_component_group_scheme`, `thm:identity_component_open_subgroup`,
`thm:identity_component_is_subgroup_homomorphism`,
`thm:identity_component_finite_type_geom_irreducible`,
`thm:identity_component_base_change_commutes`, `def:pic_zero_subscheme`,
`thm:pic_zero_is_abelian_variety`, `thm:pic_zero_dimension_equals_genus`;
the four "Following Kleiman's proof of Lem.~5.1~(3) ..." proof openers;
the abelian-variety proof body (steps (ii)/(iii)/(iv): Thm.~5.4, Exercise~5.23);
the dimension-formula proof body (Cor.~5.13); and the `\section{Lean encoding}`
itemize prose. The associated (non-rendering) `% SOURCE:` pointer comments were
updated to match for internal consistency.

### literal-ref (1)
- Line ~782: inside the **verbatim `% SOURCE QUOTE:` block** of `rmk:Jac`, the
  token `Exercise~REF` (a corruption of the original) was restored to the
  faithful Kleiman source text `Exercise~\ref{ex:jac}` (verified against
  `references/kleiman-picard-src/kleiman-picard.tex` L3994). No literal `REF`
  remains anywhere in the file. The token is inside a LaTeX comment, so it does
  not render; restoring it keeps the verbatim quote character-faithful.

### math-delim (1, consistency)
- The Hilbert-polynomial degree clause in `\section{The degree map}` mixed a
  `$\deg \mathcal{L} \in \mathbb{Z}$` formula into prose that otherwise uses
  `\( ... \)`. Converted to `\(\deg \mathcal{L} \in \mathbb{Z}\)` for a single
  consistent delimiter style. (Was balanced, not interleaved; content unchanged.)

### undefined-macro
- None. The only chapter-local macro `\connComp` is already `\providecommand`'d
  at the top of the chapter (line 4).

## Preservation checks
- All six verbatim `\label{lem:agps}`, `\label{prp:pic0}`, `\label{ex:jac}`,
  `\label{rmk:Jac}`, `\label{th:qpp&p}`, `\label{cor:sm}` tokens inside
  `% SOURCE QUOTE:` blocks are untouched (grep-confirmed).
- `grep REF` → none; `grep` of bare Kleiman labels in non-comment prose → none.
- No `\label{}`, `\lean{}`, or `\uses{}` was added, removed, or re-targeted.

## Cross-references introduced
- None. The replacements are human-readable external-source citations
  ("Lemma 5.1", etc.), not `\cref{}` — the targets are Kleiman-paper-internal
  labels, not project blueprint labels, so per directive class 3 they become the
  source's printed number.

## Dependency verification (leandag)
`leandag build --json`: `unknown_uses: []` (zero broken refs introduced).
`unmatched_lean: 44` is the pre-existing project-wide figure and is unrelated to
this prose-only edit (no `\lean{}` hints changed).

## References consulted
- `references/kleiman-picard.md` — label → source-line index for §5
  (`lem:agps` L2851, `th:qpp&p` L2935, `cor:sm` L3421, `ex:jac` L4808 app.,
  `rmk:Jac` L3990).
- `references/kleiman-picard.pdf` (pdftotext pp. 36, 44, 50–51) — confirmed the
  printed numbers Lemma 5.1 / Proposition 5.3 / Theorem 5.4 / Corollary 5.13 /
  Exercise 5.23 / Remark 5.26.
- `references/kleiman-picard-src/kleiman-picard.tex` — theorem-numbering setup
  (`\newtheorem{thm}{Theorem}[section]`, shared counter), §5 environment order
  (L2836–L4043), and the verbatim `rmk:Jac` body (L3990–L3996) used to restore
  `Exercise~\ref{ex:jac}`.

## Macros needed (if any)
- None.

## Reference-retriever dispatches (if any)
- None.

## Notes for Plan Agent
- The blueprint-doctor `bare-label` regex appears to skip labels whose token
  contains a digit or capital (`prp:pic0`, `ex:jac`, `rmk:Jac`): it reported 17
  (lem:agps×12, th:qpp×3, cor:sm×2) but those three additional bare labels were
  present in prose and are also fixed here. A future doctor-regex tweak to catch
  `[a-z]+:[A-Za-z0-9_]+` would have flagged them.
- Several `% NOTE:`/`% SOURCE:` *comments* (e.g. lines ~99, ~104, ~129, ~746,
  ~754, ~805) still mention the internal labels descriptively
  ("the verbatim source quote of lem:agps~(3)"). These are LaTeX comments, do not
  render, and are not doctor findings, so they were left as-is.

## Strategy-modifying findings
None.
