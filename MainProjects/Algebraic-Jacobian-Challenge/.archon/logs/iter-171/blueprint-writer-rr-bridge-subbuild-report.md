# Blueprint Writer Report

## Slug
rr-bridge-subbuild

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RiemannRoch_WeilDivisor.tex (NEW, 445 lines)

## Summary

Created the new chapter `RiemannRoch_WeilDivisor.tex` for the RR.1 sub-build
of the RR-bridge in-tree decomposition. The chapter establishes the
project-bespoke Weil-divisor stack on a Noetherian integral scheme under
Hartshorne's condition (*), specialises to a smooth proper curve over an
algebraically closed field for the degree map, and lands the
linear-equivalence relation. Every declaration block that derives from
external source material carries a verbatim `% SOURCE QUOTE:` block from
the local PDF `references/hartshorne-algebraic-geometry.pdf` (II §6,
pp. 130–138, read this session via PDF page rendering).

## Changes Made

- **First line declared**: `% archon:covers AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`.
- **Chapter command + label**: `\chapter{Weil divisors on a smooth proper curve (RR.1)}` / `\label{chap:RiemannRoch_WeilDivisor}`.
- **Section "Setup and motivation"**: one paragraph naming the RR.1–RR.4 decomposition, the consumer (`genusZero_curve_iso_P1`), and the Mathlib-adjacent pieces (`MeromorphicOn.divisor`, `CommRing.Pic`, `Scheme.RationalMap`) that are NOT the data structure needed. Cites the survey `analogies/rrbridge-survey.md`. Names Hartshorne's condition (*) with a verbatim quote.
- **Added definition** `\label{def:codim1_cycles}` / `\lean{AlgebraicGeometry.Scheme.WeilDivisor}` — free abelian group on codim-1 prime divisors. Verbatim quote from Hartshorne II.6 p.130.
- **Added definition** `\label{def:order_at_point}` / `\lean{AlgebraicGeometry.Scheme.RationalMap.order}` — `ord_Y(f) = v_Y(f)` via the DVR `O_{X,η}`. Verbatim quotes (two — one for the valuation, one for "zero/pole along Y") from Hartshorne II.6 pp. 130–131.
- **Added definition** `\label{def:divisor_closed_point}` / `\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint}` — `[P] := 1·P ∈ Div(C)` for a closed point on a curve. Verbatim quote from Hartshorne II.6 p.137 ("Divisors on Curves").
- **Added definition** `\label{def:divisor_degree}` / `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree}` — `deg(Σ nᵢ [Pᵢ]) = Σ nᵢ` over `k̄`. Verbatim quote from Hartshorne II.6 p.137.
- **Added theorem** `\label{thm:divisor_degree_hom}` / `\lean{AlgebraicGeometry.Scheme.WeilDivisor.degree_hom}` — `deg : Div(C) → ℤ` is a group homomorphism. No verbatim quote (statement is the universal-property of free abelian groups; proof sketch present).
  - Proof sketch added: Y (one paragraph: degree is the unique hom sending generators to 1).
- **Added definition** `\label{def:principal_divisor}` / `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal}` — `div(f) := Σ ord_Y(f) · Y` with finite support by Hartshorne 6.1. Two verbatim quotes (Lemma 6.1 + the definition immediately following) from Hartshorne II.6 p.131.
- **Added theorem** `\label{thm:principal_hom}` / `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_hom}` — `div : K(C)^× → Div(C)` is a group homomorphism. Verbatim quote from Hartshorne II.6 p.131 (the "Note that … homomorphism" paragraph).
  - Proof sketch added: Y (one paragraph: from DVR-axiom additivity of v_Y, summed over Y with finite support preserved).
- **Added theorem** `\label{thm:principal_deg_zero}` / `\lean{AlgebraicGeometry.Scheme.WeilDivisor.principal_degree_zero}` — `deg(div(f)) = 0` on a smooth proper curve. Verbatim quote from Hartshorne II.6 Corollary 6.10 p.138.
  - Proof sketch added: Y, with `% SOURCE QUOTE PROOF:` directly above `\begin{proof}` containing the verbatim Hartshorne proof of Corollary 6.10. Includes a "sub-build note" inside the proof body flagging the two auxiliary lemmas (II.6.9 finite-pullback multiplicativity + the I.6.12 finite-morphism factorisation) that the proof depends on and that are not unpacked in this chapter.
- **Section "Divisor class group"**: one paragraph naming `Cl(C) := Div(C)/im(div)` and forward-referencing the line-bundle interpretation that lives in `RR.3`.
- **Added definition** `\label{def:linear_equivalence}` / `\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}` — `D ∼ D' ⟺ D − D' = div(f)`. Verbatim quote from Hartshorne II.6 p.131 (definition of linear equivalence and of `Cl X`).
- **Section "Out of scope"**: bullet list naming (a) `O_C(D)` line-bundle construction → `RiemannRoch_OcOfD.tex` (RR.3); (b) RR formula → `RiemannRoch_RRFormula.tex` (RR.2); (c) "rational ⟹ ≅ ℙ¹" → `RiemannRoch_RationalIsoP1.tex` (RR.4); (d) Cartier divisors deferred to a future Mathlib upstream PR; (e) higher-codim cycles out of scope; (f) the two auxiliary sub-lemmas inside the proof of `thm:principal_deg_zero` are flagged but not unpacked.

## Cross-references introduced

All `\uses{...}` annotations cross-reference labels declared in this chapter:

- `def:order_at_point` uses `def:codim1_cycles`.
- `def:divisor_closed_point` uses `def:codim1_cycles`.
- `def:divisor_degree` uses `def:codim1_cycles`, `def:divisor_closed_point`.
- `thm:divisor_degree_hom` uses `def:divisor_degree`.
- `def:principal_divisor` uses `def:codim1_cycles`, `def:order_at_point`.
- `thm:principal_hom` uses `def:principal_divisor`, `def:order_at_point`.
- `thm:principal_deg_zero` uses `def:divisor_degree`, `def:principal_divisor`, `thm:principal_hom`.
- `def:linear_equivalence` uses `def:codim1_cycles`, `def:principal_divisor`, `thm:principal_hom`.

No cross-chapter `\uses{...}` references introduced — the chapter is intentionally self-contained at RR.1 (the headline consumer `prop:genusZero_curve_iso_P1` in `AbelianVarietyRigidity.tex` will pick up `\uses{def:linear_equivalence, thm:principal_deg_zero, ...}` once RR.3/RR.4 land).

## References consulted

- `references/summary.md` — index of project references; identified `references/hartshorne-algebraic-geometry.pdf` as the local source for Hartshorne II §6 and confirmed the page offset (body: doc N → PDF N+17).
- `references/hartshorne-algebraic-geometry.md` — Hartshorne reference card. Used it to confirm the page offset and to locate Hartshorne II §6 "Divisors" (doc p.129, PDF p.146 onward). Note: the card was Genus-0-arm-focused and named only Chapter IV cites; the II §6 pages used here for RR.1 are new local reads not previously summarised.
- `references/hartshorne-algebraic-geometry.pdf` — PDF pages 147–156 (= doc pp. 130–139). Verbatim quotes copied character-by-character from rendered page images (the PDF has no text layer):
  - p.130: "(*)" condition; "Definition" of prime divisor / Weil divisor.
  - p.131: valuation $v_Y$ of a prime divisor; Lemma 6.1 (finite-support); definition of $\div(f)$; the group-homomorphism remark; definition of linear equivalence and of $\Cl X$.
  - p.137: "Divisors on Curves" definition of curve + the prime-divisor-on-curves identification + definition of degree.
  - p.138: Corollary 6.10 (principal-divisor degree zero) + its proof (used for `% SOURCE QUOTE PROOF:` above `thm:principal_deg_zero`).
- `analogies/rrbridge-survey.md` — iter-168 Mathlib survey of RR-bridge dispatchability. Cited in the chapter's "Setup and motivation" section as the audit grounding the in-scope/out-of-scope decisions. Used to phrase the gap correctly ("MeromorphicOn.divisor is analytic / normed-field, NOT formal-sum-on-scheme" — verbatim from the survey).
- `blueprint/src/chapters/Rigidity.tex` (read offset 0, lines 1–100) — used as a chapter-format reference for `% SOURCE:` / `% SOURCE QUOTE:` / `\textit{Source: ...}` placement and `\begin{theorem}` style.
- `blueprint/src/chapters/Genus.tex` (lines 1–100) — used as a chapter-format reference for `\definition` blocks, the `\lean{...}` hint placement, and the `% NOTE:` comment style.
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` (lines 1140–1240 and 1440–1515) — used as a chapter-format reference for `% SOURCE QUOTE PROOF:` placement immediately above `\begin{proof}`, and for the format of `\textit{Source: ...}` prefixes on theorem prose bodies.

## Stacks tag pointers (no verbatim quotes)

The directive named Stacks tags 02RW (divisors), 02ME (order at a point),
0BE0 (degree on a curve), 0BE3 (principal degree-0) as supplementary
references. The chapter cites these as POINTERS in the `% SOURCE:`
comments (`Stacks pointer: tag XXXX`) without verbatim `% SOURCE QUOTE:`
blocks, because the project's local references directory does NOT contain
the Stacks chapter sources for tags 02RW/02ME/0BE0/0BE3 (the only Stacks
references on disk are 02KH = `stacks-coherent.tex`, plus
`stacks-algebra.tex` / `stacks-varieties.tex` / `stacks-fields.tex`). All
verbatim quotes are from Hartshorne, the local file I actually read this
session.

If the plan agent wants the Stacks verbatim quotes as a redundancy check,
the next iter can dispatch a reference-retriever for
`https://stacks.math.columbia.edu/tag/02RW` etc. — but Hartshorne suffices
for RR.1 as stated.

## Macros needed (if any)

None. Standard LaTeX (`\Div`, `\Cl`, `\ord`, `\div`, `\codim`) — all
either standard amsmath / Hartshorne-style mnemonics or already in
`macros/common.tex` (`\Spec`, `\Jac`, `\HModule`, etc. confirmed by
`blueprint/src/chapters/Rigidity.tex` / `Genus.tex` usage). If
`leanblueprint` errors on any of `\Div`, `\Cl`, `\ord`, `\codim`, those
are one-liner `\providecommand` additions to `macros/common.tex` — flagged
here for the plan agent (out of my write-domain).

## Reference-retriever dispatches (if any)

None — Hartshorne II §6 (already on disk) supplied every verbatim quote
needed. Stacks tags 02RW/02ME/0BE0/0BE3 are recorded as POINTERS
(no-verbatim-quote citations) per the citation discipline.

## Notes for Plan Agent

- **`content.tex` needs an `\input{chapters/RiemannRoch_WeilDivisor}`** —
  the chapter is new, so `content.tex` (out of my write-domain) must be
  updated by the plan agent for the chapter to appear in the typeset
  blueprint. The natural slot is before
  `AbelianVarietyRigidity.tex` (since `genusZero_curve_iso_P1` lives there
  and will eventually `\uses{...}` from this chapter).
- **Sibling chapters RR.2/RR.3/RR.4 are flagged but not present**: the
  "Out of scope" section names them as `RiemannRoch_RRFormula.tex`,
  `RiemannRoch_OcOfD.tex`, `RiemannRoch_RationalIsoP1.tex`. The plan
  agent will likely dispatch three additional `blueprint-writer` rounds
  (one per sibling) before the prover lane on
  `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` is meaningful — RR.1
  alone is type-only; the consumer `prop:genusZero_curve_iso_P1` does
  not close without RR.4.
- **`thm:principal_deg_zero`'s proof itself decomposes**: the proof body
  cites (a) the finite-morphism factorisation `C → ℙ¹` induced by a
  non-constant rational function (Hartshorne I.6.12) and (b)
  multiplicativity of degree under finite pullback (Hartshorne II.6.9).
  Both are flagged in the proof body's "sub-build note" but NOT extracted
  as standalone `\theorem` blocks in this chapter. If the prover for
  `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` needs them as
  standalone Lean lemmas, the plan agent should dispatch a follow-up
  blueprint-writer round to extract them — alternatively, they may be
  best left as in-file helpers when the prover lane begins.
- **The chapter's `\lean{...}` hints assume a target file
  `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`** (per the
  `% archon:covers` line). That file does not yet exist; iter-172's
  prover lane will scaffold it.
- **Hartshorne's I.6.12 ("a curve is rational ⟺ ≅ ℙ¹") is cited in the
  proof body of `thm:principal_deg_zero`** but lives in Hartshorne
  Ch.~I §6 (doc p.39 / PDF p.56), which is NOT in the page range I read
  this session. The citation is a parenthetical pointer only, not a
  verbatim-quoted source. If the plan agent wants a verbatim block, a
  reference-retriever (or extended PDF read) is needed.

## Strategy-modifying findings

None. Writing the chapter did not surface any strategy-level conflict;
the in-tree RR.1/RR.2/RR.3/RR.4 decomposition lines up cleanly with
Hartshorne II.6 + IV.1.3.5 and with the survey
`analogies/rrbridge-survey.md` option (1). The iter-171 reversal of
iter-170's "defer to upstream Mathlib" is structurally compatible with
the chapter as written: the chapter is fully self-contained and can be
formalised in-tree without touching Mathlib.

If, while writing RR.3, the writer discovers that
`\lean{AlgebraicGeometry.Scheme.WeilDivisor.LinearEquivalence}` is more
naturally formalised as a quotient (`Setoid` / `QuotientGroup`) rather
than the equivalence relation declared here, the natural fix is a
follow-up edit to `def:linear_equivalence`'s `\lean{...}` hint — that is
a future-blueprint-writer concern, not a strategy issue.
