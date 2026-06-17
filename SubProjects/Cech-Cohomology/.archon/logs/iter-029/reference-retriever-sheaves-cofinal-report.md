# Reference Retriever Report

## Slug
sheaves-cofinal

## Status
COMPLETE

All directive items downloaded and verified. The `sheaves.tex` source is on disk and the target
lemma `lemma-cofinal-systems-coverings-standard-case` (Tag 009L, Lemma 6.30.4) is located and
confirmed at lines 3861–3887.

## Sources fetched

- **Stacks Project "Sheaves on Spaces"** — https://raw.githubusercontent.com/stacks/stacks-project/master/sheaves.tex
  — downloaded `references/stacks-sheaves.tex` (181 KB, 5337 lines, LaTeX source, VERIFIED: begins with `\input{preamble}` + `\begin{document}`)
  — pointer card written: `references/stacks-sheaves.md`

- **Tag 009L confirmed** via https://raw.githubusercontent.com/stacks/stacks-project/master/tags/tags
  (entry: `009L,sheaves-lemma-cofinal-systems-coverings-standard-case`)
  and cross-checked against https://stacks.math.columbia.edu/tag/009L (Lemma 6.30.4, §6.30 "Bases and sheaves").

- **No PDF sought** — the directive requests TeX source primarily; the Stacks website PDF is
  generated per-section and is not a separate downloadable chapter file. The TeX source is
  machine-readable and authoritative.

## Index updates
- `references/summary.md` — appended 1 entry: `stacks-sheaves` (row added after `stacks-schemes`).

## Notes for Dispatcher

- **Verbatim lemma location:** `references/stacks-sheaves.tex` lines 3861–3887 (`Read` with
  `offset: 3861, limit: 27`). The statement is at lines 3862–3878 and the proof at 3881–3887.

- **Related tag 009K** (`lemma-cofinal-systems-coverings`, lines 3772–3859) is the more general
  predecessor that 009L reduces to; the 009L proof is one sentence referencing it. Both are in
  `stacks-sheaves.tex` and may be useful for the blueprint `% SOURCE QUOTE:` block.

- **No PDF obtained** — if the dispatcher later needs a PDF rendering, the Stacks Project
  generates per-tag HTML+PDF at https://stacks.math.columbia.edu/tag/009L (page 1 of
  the dynamically compiled document). The TeX source is sufficient for verbatim quoting.

- **No pre-existing stacks-sheaves entry in references/** — this is a fresh addition; no
  existing entry was modified.
