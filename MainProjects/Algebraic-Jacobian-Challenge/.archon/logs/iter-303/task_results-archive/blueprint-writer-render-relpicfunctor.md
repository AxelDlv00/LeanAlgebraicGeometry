# Rendering cleanup — Picard_RelPicFunctor.tex (iter-279)

Chapter: `blueprint/src/chapters/Picard_RelPicFunctor.tex`
Directive defects: 3 `literal-ref` (`\S~REF`) + 3 `bare-label`. All resolved.

## Edits

### literal-ref (3 tokens, 1 edit op — lines ~51,52,56)
- **L51–56, literal-ref**: `(\S~REF and \S~REF) ... (\S~REF)` → `(\cref{sec:relpic_group}
  and \cref{sec:relpic_groupvalued}) ... (\cref{sec:relpic_etale_sheaf})`.
  - "first half" = the two group-structure sections: `sec:relpic_group` (§ Group structure
    on the relative Picard quotient) and `sec:relpic_groupvalued` (§ The relative Picard
    presheaf as a group-valued presheaf).
  - "second half" = `sec:relpic_etale_sheaf` (§ Étale sheafification).
  - All three labels verified present in this file via `\label{...}` (resolved by `\cref`,
    NOT by rewording).

### bare-label (3, all EXTERNAL Kleiman labels in plain section narrative)
These are not project-internal (the directive's "project-internal" note is a template
default; no project label id appears bare anywhere in this chapter's prose). They are raw
internal LaTeX labels of the Kleiman source, sitting in plain `\section` prose (the
`\textit{Source:}` attribution blocks and the def/proof-body occurrences of `df:Pfs`/`ex:Alr`
were NOT flagged and were left untouched — they are inside statement/proof bodies and outside
the doctor's running-prose scope, which is consistent with the count of exactly 3). I could
not assert exact Kleiman theorem numbers with confidence, so per defect-class-3 I REWORDED to
drop the dangling label token while preserving the human-readable citation (rather than invent
a possibly-wrong number or a `\cref` to a non-existent label):
- **L581, bare-label**: `main existence theorem \S 4 (th:main) represents.` →
  `main existence theorem in \S 4 represents.`
- **L953, bare-label**: `(Kleiman \S 4, th:main: ``\dots represents` →
  `(Kleiman \S 4, the main existence theorem: ``\dots represents`
- **L970, bare-label**: `(Kleiman \S 2, th:cmp) ---` →
  `(Kleiman \S 2, the comparison theorem) ---`

## Verification
- Re-grep for `REF` placeholder: **0 remaining**.
- Re-grep for `th:main`/`th:cmp` in non-comment prose: **0 remaining** (one residual is a
  `%`-comment in the chapter header, which does not render).
- No `$ ... \( ... \) ... $` interleaving introduced or present (chapter had 0 `math-delim`
  defects; the balanced `$...$` formula on L968 left as-is).
- Every introduced `\cref{}` (`sec:relpic_group`, `sec:relpic_groupvalued`,
  `sec:relpic_etale_sheaf`) names a label that exists in this file.
- Changed NO `\begin{definition|lemma|theorem}` statement math, NO proof mathematical
  content, NO `\lean{}`, NO `\label{}`, NO `\uses{}` semantics. No `\leanok`/`\mathlibok`
  added/removed; no blocks added/deleted/reordered.

## Notes / unresolved
- The non-flagged bare external labels `df:Pfs` (L418 definition body, L833 proof prose),
  `df:aPf`/`df:Pfs` (inside several `\textit{Source:}` attribution blocks), and `ex:Alr`
  (L638 definition body) were intentionally left untouched: they fall inside statement/proof
  bodies or structured source-attribution blocks (hard-constraint risk), were not among the
  3 flagged defects, and still read sensibly as "[Kleiman] ... Def.~df:Pfs" source pointers.
  Flagging here in case a future pass wants them normalized to human-readable Kleiman numbers.
