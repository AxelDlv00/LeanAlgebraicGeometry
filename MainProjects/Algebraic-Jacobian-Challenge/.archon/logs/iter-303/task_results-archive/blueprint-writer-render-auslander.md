# Rendering cleanup — Albanese_AuslanderBuchsbaum.tex (iter-279)

Chapter: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`
Scope: non-semantic rendering repair only (math-delim + bare-label).

## Edits applied

1. **math-delim** — lines 158–159 (proof of `lem:depth_via_ext`).
   Inverted block `$\text{Ext}^*_R(\kappa,-)\(. Multiplication by \)x\( annihilates each \)\text{Ext}^j_R(\kappa, M)$`.
   Before→after: rewrote to math-in-`\(...\)`, prose outside:
   `\(\text{Ext}^*_R(\kappa,-)\). Multiplication by \(x\) annihilates each \(\text{Ext}^j_R(\kappa, M)\)`.
   Mathematical content preserved verbatim (three formulas, two prose fragments).

2. **math-delim** — lines 402–403 (inductive step of `thm:auslander_buchsbaum`).
   Inverted block `$x \in \mathfrak{m}\( exists. Take a minimal finite free resolution of \)M$`.
   Before→after: `\(x \in \mathfrak{m}\) exists. Take a minimal finite free resolution of \(M\)`.

3. **bare-label** — line 578, inside the `\begin{verbatim}` dependency diagram (lines 559–579).
   Raw slug `see lem:depth_drops_by_one)`.
   Resolution: **REWORDED**, not `\cref`'d. `\cref{}` cannot be used inside a `verbatim`
   environment (it would print literally), so per the directive's reword fallback I changed it to
   `see the lemma above)` — the diagram line directly above (577) already names it
   "depth drops by one (CLOSED;", and the lemma block `lem:depth_drops_by_one` (line 482) is above
   this point. The live `\cref{lem:depth_drops_by_one}` on the very next prose line (581) keeps the
   real cross-reference intact.

## Defects NOT requiring action

- **`literal-ref` (`REF`)**: 13 `REF` tokens exist (lines 130–351, 1554–1556) but ALL are inside
  `%` SOURCE-QUOTE comment lines — they never render. The doctor did not flag literal-ref for this
  chapter; left untouched.
- **Balanced `$...$` at lines 393–394**: a plain, balanced `$\text{depth}(R) = e = \dots$` formula
  with no delimiter interleaving. Not one of the four defect classes and not flagged by the doctor;
  left untouched per the "ONLY repair the four defect classes" constraint.
- `$` on lines 719–740 are inside `%` SOURCE-QUOTE comments (non-rendering).

## Verification
- `grep REF` (non-comment): zero rendered occurrences (all in `%` comments).
- `grep '$'` (non-comment): only the balanced 393–394 formula remains; no `$…\(…\)…$` interleaving
  anywhere.
- Bare `lem:depth_drops_by_one` (outside `\cref`/`\uses`/`\label`): zero remaining.
- No statement text, `\lean{}`, `\label{}`, `\uses{}` semantics, `\leanok`, or block ordering
  changed. All three edits are confined to proof prose / a verbatim diagram annotation.
