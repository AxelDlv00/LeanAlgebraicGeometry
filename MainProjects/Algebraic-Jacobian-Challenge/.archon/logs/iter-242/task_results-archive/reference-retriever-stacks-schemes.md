# Reference Retriever Report

## Slug
stacks-schemes

## Status
COMPLETE

All directive items downloaded and verified. The `schemes.tex` source is on disk and the target lemma `lemma-widetilde-pullback` (tag **01I9**) has been located precisely.

## Sources fetched

- **Stacks Project "Schemes" chapter** — https://raw.githubusercontent.com/stacks/stacks-project/master/schemes.tex — downloaded `references/stacks-schemes.tex` (LaTeX source, 171 KB, verified: starts with `\input{preamble}`) — pointer `references/stacks-schemes.md`.

## Lemma location (deep map — the primary directive deliverable)

| Item | Value |
|------|-------|
| Label | `lemma-widetilde-pullback` (full cross-ref: `schemes-lemma-widetilde-pullback`) |
| Stacks tag | **01I9** |
| File | `references/stacks-schemes.tex` |
| `\begin{lemma}` | line **1241** |
| `\label{...}` | line **1242** |
| `\end{lemma}` | line **1256** |
| Proof | lines **1258–1269** |
| Section | §7 "Quasi-coherent sheaves on affines" (`section-quasi-coherent-affine`), begins line **1067** |

The two parts of the lemma:
1. (Pullback) `ψ* M̃ = (S ⊗_R M)~` functorially in the R-module M.
2. (Pushforward) `ψ_* Ñ = (N_R)~` functorially in the S-module N.

The proof of part (1) cites `lemma-compare-constructions` and `modules-lemma-restrict-quasi-coherent`; part (2) is a direct computation on standard opens `D(f)`.

A cross-reference to the same lemma also appears at line **1272** (remark immediately after the proof) and line **4816** (inside §24 "Functoriality for quasi-coherent modules").

## Index updates
- `references/summary.md` — appended 1 entry: `stacks-schemes`

## Notes for Dispatcher

- The blueprint-writer can now open `references/stacks-schemes.tex` at lines 1241–1256 and copy the statement verbatim for the `% SOURCE QUOTE:` block.
- The companion `stacks-constructions.tex` already has the relative-spectrum / affine base-change material; `stacks-schemes.tex` is the dedicated source for the tilde-pullback statement.
- Stacks tag `01I9` is stable. The chapter tag for "Schemes" is **020J** (the chapter-level tag, distinct from the lemma tag).
- No other Stacks chapters were fetched (per "Out of scope" instruction).
