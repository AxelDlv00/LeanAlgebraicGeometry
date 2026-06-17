# Blueprint Writer Report

## Slug
jacobian-iter151

## Status
COMPLETE

All six targeted Route-A declarations now carry verbatim `% SOURCE QUOTE:`
blocks copied character-for-character from
`references/kleiman-picard-src/kleiman-picard.tex`, each with a `% SOURCE:`
pointer naming the local file and a visible `\textit{Source: …}` line. No quote
was fabricated. The classical Albanese definition was covered honestly by a
genuine verbatim quote from Kleiman's `rmk:Alb` (the directive's permitted
option) rather than the no-quote Serre/Lang flag. Nitsure is cited (prose
pointer) for the A1 Quot/Hilbert engine.

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Changes Made
- **Cited** `def:IsAlbanese` (`AlgebraicGeometry.IsAlbanese`) — verbatim quote of
  Kleiman `rmk:Alb` final paragraph (the Albanese universal property: every
  $b\colon X\to B$ factors uniquely through $u\colon X\to A$). Used the
  directive's permitted `rmk:Alb` option (read it first; it covers the universal
  property exactly), so NO Serre/Lang no-quote flag was needed.
- **Cited** `thm:Jacobian_smooth_genus`
  (`Jacobian.smoothOfRelativeDimension_genus`) — three verbatim quotes:
  `cor:sm` (dim $\le \dim H^1(\mathcal O_X)$, equality iff smooth at 0),
  `cor:ch0` (char-0 ⟹ smooth of that dimension), and the smoothness clause of
  `prp:P0` (smooth over reduced $S$).
- **Cited** `thm:Jacobian_proper` (`Jacobian.instIsProper`) — verbatim quote of
  `prp:P0` ($\mathrm{Pic}^0_{X/S}$ closed in $\mathrm{Pic}_{X/S}$ and proper over
  $S$ when fibres are complete).
- **Cited** `thm:Jacobian_geomIrred` (`Jacobian.instGeometricallyIrreducible`) —
  verbatim quotes of `lem:agps` ($G^0$ open-closed, finite type, geometrically
  irreducible, commutes with field extension) and `prp:pic0` (specialisation to
  $\mathrm{Pic}_{X/k}$).
- **Cited** `thm:nonempty_jacobianWitness` (`nonempty_jacobianWitness`) —
  verbatim quote of `ex:jac` (generalized Jacobians form a smooth
  quasi-projective family of relative dimension $p_a$, projective iff $X/S$
  smooth).
- **Cited** `def:positiveGenusWitness` (`positiveGenusWitness`) — verbatim quote
  of `rmk:Jac` first paragraph ($J:=\mathrm{Pic}^0_{X/S}$ for a smooth projective
  genus-$g>0$ family exists and is a projective abelian $S$-scheme). The
  directive's bullet 1 named `nonempty_jacobianWitness` and/or
  `positiveGenusWitness`; I cited both, since `ex:jac` (integral curves, genus
  $p_a$) is the natural existence/smoothness/projectivity source for the
  foundational theorem and `rmk:Jac` (smooth genus-$g>0$ curves) is the precise
  positive-genus match.
- **Added** a prose pointer to Nitsure, "Construction of Hilbert and Quot
  Schemes" (§4 flattening stratification, §5 Quot construction) in the A.2
  Mathlib-status sub-step (the Quot/Hilbert representability engine for Route A).
  Used `\mathrm{Quot}`/`\mathrm{Hilb}` to avoid undefined macros.

No proof sketches, route decomposition, `\leanok`/`\mathlibok` markers, or other
chapters were touched. No new `\begin`/`\end` environments introduced (count
verified balanced: 39/39).

## Cross-references introduced
- None. No new `\uses{...}` added; all citation content is in `% SOURCE*`
  comments and `\textit{Source:}` prose lines, which do not enter the dependency
  graph.

## References consulted
- `references/summary.md` — index; confirmed Kleiman + Nitsure are the bundled
  Route-A sources and their local-file paths.
- `references/kleiman-picard.md` — the section→label→PDF-page map; used to locate
  `ex:jac` (L3911), `rmk:Jac` (L3990), `rmk:Ablsch` (L3920), `rmk:Alb` (L3960),
  `prp:P0` (L3661), `cor:sm` (L3421), `cor:ch0` (L3442), `lem:agps` (L2851),
  `prp:pic0` (L2921), and the arXiv page numbers.
- `references/kleiman-picard-src/kleiman-picard.tex` — the LaTeX source from which
  every `% SOURCE QUOTE:` was copied verbatim (lines: `lem:agps` 2851–2863,
  `prp:pic0` 2921–2929, `cor:sm` 3421–3427, `cor:ch0` 3442–3446, `prp:P0`
  3661–3670, `ex:jac` 3911–3917, `rmk:Alb` 3960–3988, `rmk:Jac` 3990–3996).
- `references/nitsure-hilbert-quot.md` — for the §4/§5 prose pointer (Quot/Hilbert
  construction engine) added to A.2; arXiv id and section titles taken from here.

## Macros needed (if any)
- None. `\Spec`, `\Pic`, `\Sym`, `\genus`, `\Jac` are already defined in
  `macros/common.tex`. `\Quot`/`\Hilb` are NOT defined, so I deliberately wrote
  `\mathrm{Quot}` / `\mathrm{Hilb}` in the Nitsure pointer rather than introduce
  new macros. The verbatim Kleiman macros (`\IPicz`, `\IPic`, `\tu`, `\mc`,
  `\fppf`, `\et`, `\wh`, `\x`, `\:`, etc.) appear ONLY inside `%` comment lines
  and therefore never reach the typesetter — no macro definitions are required
  for them.

## Reference-retriever dispatches (if any)
- None. Both required sources (Kleiman, Nitsure) were already bundled in-tree.

## Notes for Plan Agent
- The `% SOURCE:` pointer parentheticals name
  `references/kleiman-picard-src/kleiman-picard.tex` (the actual `.tex` source I
  read and copied from), not a `.md` file — the project's `.md` for this source
  is a section/page MAP only and explicitly directs quoting from the `-src/.tex`.
  This matches the discipline rule ("the local file you opened to produce the
  verbatim quote").
- `rmk:Alb` is stated by Kleiman over an algebraically closed field $k$ and for a
  normal integral projective $X$, deriving the Albanese map $u\colon X\to A$ from
  autoduality of $\mathrm{Pic}^0$. The chapter's `def:IsAlbanese` is stated over a
  general $k$ for a curve; the quote backs the universal-property *content*, with
  the project-notation restatement (over general $k$) living in the prose body as
  intended. Flagging in case the reviewer wants the over-$\bar k$ vs over-$k$
  distinction annotated with a `% NOTE:` (out of my write-domain to add).

## Strategy-modifying findings
- None. This was a citation-only round; the Route A / Route B decomposition and
  all proof-sketch mathematics are unchanged, and nothing in the sources
  contradicted the chapter's existing claims.
