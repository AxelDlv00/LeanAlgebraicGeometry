# Blueprint Writer Report

## Slug
a4c-thm32

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex` (new file)

## Changes Made
- **Created chapter** `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex`
  with `\label{chap:Albanese_Thm32RationalMapExtension}` and `% archon:covers
  AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean` directive.
- **Strategy-note block** (top of file) — explains A.4.c position in Route A,
  records the dependency on A.4.a (codim-$\geq 2$ extension + Lemma 3.3) and
  A.4.b (Auslander--Buchsbaum), flags the existing AVR placeholder Lean target
  for plan-agent reconciliation, and states that the Lean file does not yet
  exist.
- **Added theorem** `\theorem`/`\label{thm:rational_map_to_av_extends}`/`\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}`
  --- Milne's Theorem 3.2 statement (rational map from a nonsingular variety to
  an abelian variety extends to a regular morphism) with full citation block
  (`% SOURCE:` + verbatim `% SOURCE QUOTE:` + visible `\textit{Source: ...}`).
  - Proof sketch added: yes. Verbatim `% SOURCE QUOTE PROOF:` (Milne's one-line
    "Combine Theorem 3.1 with the next lemma") + a 3-step project-notation
    expansion (codim-$\geq 2$ from A.4.a's Thm~3.1 + pure-codim-$1$ from A.4.a's
    Lemma~3.3 $\Rightarrow$ empty indeterminacy $\Rightarrow$ everywhere
    defined).
- **Added remark** `\label{rmk:thm32_role_of_ab}` explaining where the
  Auslander--Buchsbaum corollary (A.4.b) enters --- not in the proof body of
  Thm~3.2 but inside Thm~3.1's codim-$\geq 2$ half, via the depth-$\geq 2$
  property of regular local rings of dim $\geq 2$.
- **Added section** `\label{sec:thm32_char_free}` --- explicit char-free
  argument trail (both inputs are char-free, so the join is char-free), aligned
  with project's char-free invariant.
- **Added application section** `\label{sec:thm32_application_to_a4d}` ---
  records how A.4.d (Albanese universal property of $\Pic^0_{C/k}$) consumes the
  theorem via the symmetric-product map $C^{(g)} \dashrightarrow A$.
- **Added Lean-encoding section** `\label{sec:thm32_lean_encoding}` --- specifies
  the target Lean declaration `AlgebraicGeometry.Scheme.RationalMap.extend_to_av`
  as a method on the existing `Scheme.RationalMap` namespace (consistent with
  `RiemannRoch_WeilDivisor.tex` use of the same namespace).
- **Added out-of-scope section** `\label{sec:thm32_out_of_scope}` --- enumerates
  what the chapter does NOT cover (Milne Thm~3.1, Lemma~3.3, AB and CM corollary
  themselves, downstream Thm~3.4/3.7/3.8/3.9/3.10, the Albanese UP, non-$\bar k$
  descent).

## Cross-references introduced
- `\uses{thm:codim_one_extension, thm:auslander_buchsbaum, cor:regular_cohen_macaulay}`
  on `\thm:rational_map_to_av_extends` --- verify
  `thm:codim_one_extension` exists in `Albanese_CodimOneExtension.tex` (sibling
  chapter written this iter) and `thm:auslander_buchsbaum` /
  `cor:regular_cohen_macaulay` exist in `Albanese_AuslanderBuchsbaum.tex`
  (verified present at lines 259 and 416 of that file).
- `\cref{lem:milne_codim1_indeterminacy}` (Milne Lemma 3.3 in A.4.a chapter) ---
  the directive's "Lemma 3.3 (A.4.a)" referent. The exact label inside
  `Albanese_CodimOneExtension.tex` should match this; if A.4.a writer chose
  a different label (e.g. `lem:codim1_indeterminacy_into_group_variety`), the
  Plan Agent should reconcile via a one-line label rename in this chapter.
- `\cref{chap:Albanese_CodimOneExtension}`, `\cref{chap:Albanese_AuslanderBuchsbaum}`,
  `\cref{chap:Albanese_AlbaneseUP}` --- assumed chapter labels.
- `\cref{chap:AbelianVarietyRigidity}` (existing).
- `\cref{chap:Jacobian}`, `\cref{sec:Jacobian_routeA4_albaneseUP}` (existing).
- `\cref{rmk:base_case_fourth_route}` (existing in `AbelianVarietyRigidity.tex`).
- `\cref{chap:RigidityKbar}`, `\cref{chap:RiemannRoch_WeilDivisor}` (existing).

## References consulted
- `references/summary.md` --- to identify the Milne PDF as the canonical
  reference for Theorem~3.2 (and to confirm no LaTeX source is available, only
  PDF, so verbatim quotes are pulled from the rendered PDF).
- `references/abelian-varieties.md` --- the per-source contents map, locating
  Theorem~3.2 at doc p.~17, PDF p.~23, with Theorem~3.1 at doc p.~16 (PDF p.~22)
  and Lemma~3.3 at doc p.~17--18 (PDF p.~23--24).
- `references/abelian-varieties.pdf` pages 21--26 (PDF page numbers; doc pages
  15--20) --- verbatim `% SOURCE QUOTE:` for Theorem~3.2 statement and verbatim
  `% SOURCE QUOTE PROOF:` for its one-line proof "Combine Theorem 3.1 with the
  next lemma". Confirmed visually; the Theorem~3.1 and Lemma~3.3 verbatim quotes
  remain authoritative in `AbelianVarietyRigidity.tex` L820--L858 (an earlier
  iter already extracted them), so this chapter cross-references rather than
  re-pasting them.
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` (existing; for the
  reserved placeholder `lem:rational_map_to_av_extends` at L818--L872, and the
  `\cref{rmk:base_case_fourth_route}` referent).
- `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` (sibling, just
  written this iter; for the `\uses{}` references and the section-6
  description of how AB feeds the codim-$\geq 2$ extension).
- `blueprint/src/chapters/Jacobian.tex` L340--L450 (existing; for the
  `\cref{sec:Jacobian_routeA4_albaneseUP}` referent and the Route-A budget /
  bypass-fails framing).
- `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` L37--L42, L259--L262
  (existing; for the canonical `AlgebraicGeometry.Scheme.RationalMap`
  namespace already in use).
- `blueprint/src/content.tex` (existing; to confirm
  `Albanese_Thm32RationalMapExtension` is already wired in the `\input{}` chain,
  L29).

## Macros needed (if any)
None. The chapter uses only standard project macros / built-in LaTeX commands.

## Reference-retriever dispatches (if any)
None. All necessary source material was already in `references/abelian-varieties.pdf` /
`references/abelian-varieties.md`; the verbatim quote was extracted directly
this session.

## Notes for Plan Agent
- **Lean-name reconciliation needed in `AbelianVarietyRigidity.tex` L820--L821.**
  That chapter reserves the placeholder lemma `lem:rational_map_to_av_extends`
  with Lean name `AlgebraicGeometry.rationalMap_to_av_extends`. This new
  chapter promotes the same statement to a theorem under the canonical
  Lean name `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` (consistent
  with the `Scheme.RationalMap` namespace already in use in
  `RiemannRoch_WeilDivisor.tex`). The two LaTeX labels are distinct
  (`lem:` vs `thm:`) so there is no LaTeX duplicate-label error, but the AVR
  placeholder will be a redundant copy until the Plan Agent decides whether
  to (a) re-target the AVR placeholder at the theorem proved here (replacing
  its body with `\cref{thm:rational_map_to_av_extends}` and removing the
  duplicated SOURCE QUOTE block), or (b) keep both for the dependency graph's
  benefit and just align the Lean name. Recommendation: (a), since the AVR
  block was explicitly marked "Route-A-only" and this chapter is the
  Route-A canonical home.
- **A.4.a label assumption.** This chapter `\uses{thm:codim_one_extension}`
  and `\cref{lem:milne_codim1_indeterminacy}`. Verify that
  `Albanese_CodimOneExtension.tex` (written this iter by a sibling
  blueprint-writer dispatch) actually uses those label slugs. If A.4.a chose
  different slugs (e.g. `thm:milne_codim_two_extension`,
  `lem:codim1_indeterminacy_into_group_variety`), the Plan Agent should
  align both chapters in a one-line rename pass before next iter's typeset.
- **`thm:rational_map_to_av_extends` is the new canonical label.** Other
  consumers (`Jacobian.tex` L401, L451, and the A.4.d chapter when written)
  currently cite `lem:rational_map_to_av_extends`; the Plan Agent should
  globally re-target those `\cref` sites at `thm:` once the AVR placeholder
  is retired. Until then both labels coexist without conflict.
- **No new axioms or constructions introduced.** The chapter is a
  three-paragraph combination chapter; the math content is exactly Milne's
  one-line proof. Total LOC: ~160 lines of LaTeX, dominated by surrounding
  exposition rather than mathematical content.

## Strategy-modifying findings
None. The chapter content matches the directive exactly: Theorem 3.2's
statement is in scope, its proof is the verbatim combination "Theorem 3.1 +
Lemma 3.3 $\Rightarrow$ everywhere defined" already named in the directive,
and the char-free assertion follows because both inputs are char-free in
Milne's own treatment. Auslander--Buchsbaum's role is the "depth-$\geq 2$
at codim-$\geq 2$ point" hidden inside Theorem 3.1's codim-$\geq 2$ extension
step --- this matches the project's understanding (see `Albanese_AuslanderBuchsbaum.tex`
\S 6 "Application: codim-1 extension on a regular surface (gating A.4.a)").
The directive's framing "Use Lemma 3.3 (A.4.a) to extend over codim-2 points
once codim-1 is excluded" reads slightly oddly (in Milne, Lemma 3.3 says
indeterminacy is pure codim 1, not that it extends over codim 2); the proof I
wrote follows the mathematically faithful Milne combination (Thm 3.1 gives
codim $\geq 2$; Lemma 3.3 says pure codim 1; together $\Rightarrow$ empty)
rather than the directive's literal phrasing. This is not a strategy change,
just a faithful reading of Milne; the directive's high-level intent (combine
A.4.a + A.4.b into Thm 3.2) is preserved.
