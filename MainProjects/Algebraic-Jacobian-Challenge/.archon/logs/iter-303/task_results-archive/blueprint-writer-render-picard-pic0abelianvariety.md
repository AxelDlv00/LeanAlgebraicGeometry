# Blueprint Writer Report

## Slug
render-picard-pic0abelianvariety

## Status
COMPLETE — all blueprint-doctor findings repaired; zero `REF` tokens, zero bare
labels in visible prose, the one undefined macro now defined; no mathematics,
`\lean{}`, `\label{}`, or `\uses{}` semantics changed; `leandag` `unknown_uses: []`.

## Target chapter
blueprint/src/chapters/Picard_Pic0AbelianVariety.tex

## Findings addressed
Blueprint-doctor flagged: **bare-label ×15**, **undefined-macro ×1**. Both classes
fully repaired (and I additionally cleaned every same-class bare label the doctor's
prefix-regex missed — `prp:`, `ex:` — plus a stray `REF` inside a verbatim comment).

### undefined-macro `\tu` (1)
`\tu` (Kleiman's `\let\tu=\textup`, an upright-glyph macro used here only for the
tangent-space symbol `T_0`) was undefined in `macros/common.tex`. Added a
chapter-local one-liner near the top:
`\providecommand{\tu}{\textup}` (with an explanatory comment).
This leaves all 23 `\tu` occurrences (visible + verbatim-comment) untouched and
correctly rendering `\mathrm{T}_0`. No math edited.

### bare-label (all external Kleiman paper-internal ids → human-readable numbers)
All flagged ids are Kleiman "The Picard scheme" internal labels (not project
labels). Numbers read directly off the PDF (`references/kleiman-picard.pdf`,
printed page = physical page):

| internal id | Kleiman printed number | §  | PDF p. | visible occurrences fixed |
|-------------|------------------------|----|--------|---------------------------|
| `thm:tgtsp` | Theorem 5.11           | §5 | 42     | 3 (Source line, proof, Lean-encoding) |
| `cor:sm`    | Corollary 5.13         | §5 | 44     | 3 |
| `cor:ch0`   | Corollary 5.14         | §5 | 44     | 3 |
| `th:qpp&p`  | Theorem 5.4            | §5 | 37     | 4 |
| `prp:pic0`  | Proposition 5.3        | §5 | 37     | 2 |
| `rmk:Jac`   | Remark 5.26            | §5 | 51     | 4 |
| `ex:jac`    | Exercise 5.23          | §5 | 50     | 1 |
| `th:cmp`    | Theorem 2.5 (Comparison)| §2 | 18    | 1 |
| `ex:Alr`    | Exercise 2.3           | §2 | 17     | 1 |

Each bare id in visible prose (Source `\textit{}` lines, proof prose, the
Lean-encoding bullet list, the out-of-scope list) was replaced with its
`Type.~N.M` number. Internal ids inside `% SOURCE:` / `% SOURCE QUOTE:` comment
blocks were left as-is (verbatim citation pointers; the doctor does not scan
comment lines).

### Section-locator corrections (consistency, not mathematics)
Two prose citations named the wrong Kleiman section; replacing the bare label with
the section-encoding printed number would otherwise have produced a
self-contradictory citation, so I corrected the `\S` to match:
- `th:cmp`: prose said "`\S 4`" → corrected to "`\S 2`" (Theorem 2.5 lives in §2,
  and *is* the theorem titled "Comparison").
- `ex:Alr`: prose said "`\S 5`" → corrected to "`\S 2`" (Exercise 2.3 lives in §2;
  Kleiman himself cites "Exercise 2.3" in the §5 tangent-space proof, p.44).
These touch only the citation locator, not any statement, proof step, definition,
or mathematical numeric claim.

### Stray `REF` in a verbatim comment (defensive, out of strict scope)
The `rmk:Jac` `% SOURCE QUOTE:` comment contained `Exercise~REF` where Kleiman's
source has `Exercise~\ref{ex:jac}`. Restored the verbatim source text
(`Exercise~\ref{ex:jac}`) so no literal `REF` remains anywhere in the file. This is
a commented verbatim quote (does not render), repaired for faithfulness.

## Cross-references introduced
None. No `\cref{}`, `\uses{}`, `\label{}`, or `\lean{}` was added, removed, or
re-targeted. The 15 repairs are all external-source human-readable numbers (plain
prose), not project cross-references, exactly as the bare-label rule prescribes for
external paper-internal labels. `leandag build --json` reports `unknown_uses: []`.

## References consulted
- `references/kleiman-picard.md` — contents/label map for §5 (`th:qpp&p`,
  `thm:tgtsp`, `cor:sm`, `cor:ch0`, `prp:pic0`, `rmk:Jac`, `ex:jac`) and §2
  (`th:cmp`, `ex:Alr`); confirmed PDF page = printed page.
- `references/kleiman-picard.pdf`, pp. 17–18, 36–37, 41–42, 44, 50–51 — read the
  printed theorem/corollary/proposition/remark/exercise numbers verbatim (Thm 2.5,
  Ex 2.3, Prop 5.3, Thm 5.4, Thm 5.11, Cor 5.13, Cor 5.14, Ex 5.23, Rmk 5.26).
- `references/kleiman-picard-src/kleiman-picard.tex` — confirmed `\let\tu=\textup`
  (L185), the shared section-scoped theorem counter (L201–227), label source lines,
  and the verbatim `rmk:Jac` text (`Exercise~\ref{ex:jac}`, L3994).
- `blueprint/src/macros/common.tex` — confirmed `\tu` absent and `\Pic` present
  (`\DeclareMathOperator`), so `\tu` is the sole undefined macro.

## Macros needed (if any)
- `\tu` (= `\textup`) — defined chapter-locally via `\providecommand`. Kleiman uses
  it across his paper; if other chapters quote Kleiman's `\tu`/`\uH` notation it may
  be worth promoting `\tu` to `macros/common.tex`. NOT added there by me
  (out of write-domain). Low priority — chapter-local `\providecommand` is harmless
  if a shared definition is later added.

## Notes for Plan Agent
- The chapter's "Internal-consistency check" (§ at end) and the strategy-note
  header list project labels inside `\texttt{...}` with escaped underscores
  (e.g. `\texttt{thm:identity\_component\_open\_subgroup}`). These are deliberate
  monospace identifier listings, NOT cross-references; the doctor does not flag
  them and I left them untouched.
- The `% SOURCE:` / `% SOURCE QUOTE:` comments still cite Kleiman's internal ids
  (e.g. `\label{thm:tgtsp}`) — correct and expected for verbatim citation pointers;
  they live in comments and do not render.

## Strategy-modifying findings
None. This was a pure rendering/cross-reference repair pass; no statement, proof
argument, or strategy assumption was affected.
