# Blueprint-writer directive — Albanese_CodimOneExtension.tex

## Target file
`blueprint/src/chapters/Albanese_CodimOneExtension.tex`

## Problem (why dispatched)
`lem:smooth_algebra_krull_dim_formula` (≈L305) is a leandag **∞-node**: it has a
full statement (the Stacks dimension-at-a-point formula, tag 00OE) with its
`% SOURCE`/`% SOURCE QUOTE`/`\textit{Source:}` block intact, but **no
`\begin{proof}` block**, so leandag sees an empty proof body and the closure of
the codim-1 extension argument through it is ∞. Add a short informal proof.

## What to do
- Insert a `\begin{proof} ... \end{proof}` immediately after the lemma's
  `\end{lemma}`.
- The lemma is the standard dimension formula
  \(\dim_x(\operatorname{Spec} S) = \dim S_{\mathfrak q} +
  \operatorname{trdeg}_k \kappa(\mathfrak q)\) for a finite-type \(k\)-algebra
  \(S\) (Stacks tag 00OE). The informal proof is a citation-level argument:
  this is exactly Stacks tag 00OE (lemma-dimension-at-a-point-finite-type-field);
  reduce to it. State the standard one-paragraph reasoning: by Noether
  normalisation \(S\) is finite over a polynomial subalgebra, the going-up /
  dimension theory of finitely generated algebras over a field gives the formula
  via \(\dim_x = \dim \overline{\{x\}} + \operatorname{codim}\), and the
  transcendence-degree term records the residue field. Then note the
  specialisation already stated in the lemma (closed point over \(\bar k\):
  \(\operatorname{trdeg} = 0\) by the Nullstellensatz, so
  \(\dim S_{\mathfrak q} = \dim_x\)).
- Include a `\uses{}` for whatever the proof genuinely relies on. The lemma's
  statement block currently carries `\uses{lem:rank_kaehler_localization_eq_relative_dim}`;
  if that dependency belongs to the *proof* rather than the statement, move it
  into the `\begin{proof}\uses{...}` line. If the proof is a pure citation of
  Stacks 00OE plus Mathlib's dimension theory, you may author a **Mathlib
  dependency anchor** (a `\mathlibok` block) for the underlying Mathlib
  dimension lemma if a faithful one exists — but only if you can name the real
  Mathlib declaration; otherwise leave the proof as an informal citation of
  Stacks 00OE.

## Hard constraints
- Purely mathematical prose; no Lean code/tactics. Only the existing `\lean{}`
  annotation names Lean.
- **Do NOT add `\leanok`.** You MAY add `\mathlibok` ONLY on a genuine Mathlib
  dependency anchor block you author (with a real Mathlib `\lean{}` target),
  never on this project lemma.
- Do not change the statement or the existing `% SOURCE QUOTE` (Stacks 00OE).

## References (already cited in-chapter)
- `references/stacks-algebra.tex` — tag 00OE
  (lemma-dimension-at-a-point-finite-type-field, L28206–28217), and the
  Noether-normalisation / dimension-theory lemmas in the same section.

## Out of scope
- Do not touch other chapters or the two sibling lemmas
  (`lem:cotangent_kahler_over_field`, `lem:rank_kaehler_localization_eq_relative_dim`)
  unless one is itself an empty-proof ∞-node that blocks this proof's `\uses{}`
  closure — if so, report it rather than expanding scope silently.
