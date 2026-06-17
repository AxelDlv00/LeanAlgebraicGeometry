# Reference Retriever Report

## Slug
stacks-cohomology

## Status
COMPLETE

All two directive items (the TeX source file and both named lemmas) are downloaded,
verified as real TeX, and located by exact line number in `stacks-cohomology.tex`.

## Sources fetched

- **Stacks Project "Cohomology" chapter** (`cohomology.tex`)
  - URL: https://raw.githubusercontent.com/stacks/stacks-project/master/cohomology.tex
  - Downloaded: `references/stacks-cohomology.tex` — 508 KB, 14535 lines, verified as
    LaTeX source (opens with `\input{preamble}` / `\begin{document}`, not HTML)
  - Pointer file: `references/stacks-cohomology.md`

### Lemma locations (line numbers in `stacks-cohomology.tex`)

| Label | Line | Section |
|-------|------|---------|
| `lemma-describe-higher-direct-images` (tag 01XJ) | **592** | §Locality of cohomology (§ starts l.488) |
| `lemma-cech-vanish-basis` (tag 01EO) | **1696** | §Čech cohomology and cohomology (§ starts l.1404) |

Both lemma blocks confirmed present verbatim in the downloaded file.

## Index updates
- `references/summary.md` — appended 1 entry: `stacks-cohomology`

## Notes for Dispatcher
- Label names inside `cohomology.tex` use the chapter-local form (e.g.
  `\label{lemma-cech-vanish-basis}`), without the `cohomology-` chapter prefix that
  appears in cross-chapter `\ref{}` calls. Both forms refer to the same lemma.
- Stacks tag numbers 01EO and 01XJ were provided in the directive seeds; they have not
  been independently verified against the live tag server, but the label names and lemma
  content in the downloaded file are definitively correct.
- No related sources were noticed that the dispatcher would want; "Cohomology of Schemes"
  (`coherent.tex`) is already local as `stacks-coherent.tex` and was not re-fetched per
  directive instructions.
