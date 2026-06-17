# Blueprint Writer Report

## Slug
render-picard-fgapicrepresentability

## Status
COMPLETE — all flagged math-delim and bare-label defects repaired; the
mathematics, every `\lean{}`, `\label{}`, and the semantic `\uses{}` set are
untouched. `leandag build --json` reports `unknown_uses: 0`.

## Target chapter
blueprint/src/chapters/Picard_FGAPicRepresentability.tex

## Changes Made

### math-delim (8 doctor findings + 5 additional interleaved sites)
The doctor's line-based heuristic flagged the interleaved `$ … \( … \) … $`
sites on lines 128–129, 135–137 (8 occurrences). I repaired those and, while
scanning the full file, found 5 more multi-line interleaved sites the heuristic
missed. All converted to a single consistent `\( … \)` style:

- **L128–129** `$\Hilb_{C/k} = \Quot…\( … \)k$` → `\(\Hilb_{C/k} = \Quot…\)`
  + `\(k\)`-scheme.
- **L135–137** `$Z := …\( … \)q\( … \)…$` (image/closed/Div span) → clean
  `\(…\)` per formula.
- **L112–113** `$A_{C/k} : \mathrm{Div}_{C/k} \to \Pic^\sharp_{(C/k)\et}$`
  → `\(…\)` (was adjacent to a `\(k\)` group; normalized to one style).
- **L236–237** `$P^\phi \subseteq \Pic^\sharp…\( … \)T$-points` → `\(…\)`.
- **L267–268** `$C \times_k T'\( with \)H^1(…)=0$` → `\(…\)` per formula.
- **L464–465** `$[\mathcal L]+[\mathcal M]=…\( , inverse \)-[\mathcal L]…$`
  → `\(…\)` per formula.
- **L550–551** `$R \subseteq Z \times_k Z\( … \)k\(-scheme \)Z$` → `\(…\)`.

### bare-label (7 doctor findings + 4 additional bare external labels)
Every raw Kleiman-internal label id pasted into rendered prose replaced with the
source's human-readable number, recovered by computing the
section-scoped theorem counter from
`references/kleiman-picard-src/kleiman-picard.tex` (envs `thm/cor/lem/prp/dfn/
eg/ex/rmk/sbs` share one `[section]` counter; `sbsthm/sbscor` nest as
`<thm>.<n>`):

| internal label | human-readable | sites fixed |
|---|---|---|
| `lm:ctn`   | Lemma 3.4      | L141, L151, L1030 (`\texttt`) |
| `th:repDiv`| Theorem 3.7    | L97, L977 (`\texttt`) |
| `dfn:Abel` | Definition 4.6 | L97 |
| `df:Pfs`   | Definition 2.2 | L436 |
| `df:Psch`  | Definition 4.1 | L437, L510 |
| `th:main`  | Theorem 4.8    | L166, L200, L228, L1141, L1166 (`\texttt`) |
| `lm:qt`    | Lemma 4.9      | L278, L315 |
| `cor:algsch`| Corollary 4.18.3 | L201, L287, L1142 (`\texttt`) |
| `ex:univshf`| Exercise 4.3  | L1386 |
| `eg:Mumford`| Example 4.14  | L1393 |

The doctor counted 7 (its heuristic skips `\textit{Source:}` lines and
`\texttt{}`-wrapped ids); I additionally fixed those rendered-but-unflagged
sites so the chapter renders uniformly with no raw label ids.

### literal-ref `REF` tokens (in verbatim `% SOURCE QUOTE:` comments)
Three `REF` placeholders survived inside verbatim Kleiman quote comments. Not
doctor-flagged (comments don't render), but the directive forbids any literal
`REF`. Restored to the source's true verbatim text:
- L358: `Exercise~REF` → `Exercise~\ref{ex:epi}` (Kleiman L2412).
- L432, L506: `Definition~REF` → `Definition~\ref{df:Pfs}` (Kleiman L2058).

## Cross-references introduced
None. No `\cref{}`/`\uses{}` edges added or retargeted — the bare external
Kleiman labels are paper-internal (not project labels), so they became
human-readable numbers in prose, not `\cref{}`. All pre-existing project
`\cref{}`/`\uses{}` left intact. `leandag build --json`: `unknown_uses: 0`.

## References consulted
- `references/kleiman-picard.md` — confirmed the project's Kleiman-paper index
  and section/label map (`th:main` L2155, `lm:qt` L2368, `cor:algsch` L2686).
- `references/kleiman-picard-src/kleiman-picard.tex` — derived the verbatim
  theorem/definition/lemma numbers by computing the shared section-scoped
  counter (theorem env declarations at L201–227; section + env line positions);
  recovered verbatim `\ref{ex:epi}` (L2412) and `\ref{df:Pfs}` (L2058) for the
  restored SOURCE QUOTE comments.

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- The blueprint-doctor's bare-label / math-delim heuristics are line-based and
  miss (a) multi-line interleaved `$…\(…\)…$` formulas and (b) bare labels
  inside `\textit{Source:}` and `\texttt{}`. This chapter had 5 extra
  interleaved formulas and 5 extra bare-label sites beyond the 15 reported
  findings; all are now fixed, but other chapters cleaned this round may have
  analogous unreported residue worth a manual `grep '\$' | grep '\\('` pass.
- `cor:algsch` numbers as **Corollary 4.18.3** in the arXiv source's 3-level
  `sbscor` numbering (nested under the `rmk` `rk:exist` = 4.18). If the project
  prefers the FGA-Explained book numbering elsewhere, this should be made
  consistent across chapters — but within this chapter the arXiv-source number
  is internally consistent with the other citations (all from the same source).

## Strategy-modifying findings
None.
