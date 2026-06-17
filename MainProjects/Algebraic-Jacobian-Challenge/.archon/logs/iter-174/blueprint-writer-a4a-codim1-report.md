# Blueprint Writer Report

## Slug
a4a-codim1

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/Albanese_CodimOneExtension.tex` (new file, created this session).

## Changes Made

Created the chapter from scratch (file did not exist). The chapter is the prover-ready
specification for the new Lean file `AlgebraicJacobian/Albanese/CodimOneExtension.lean`
(also not yet existing). Six declaration blocks + a Lean-encoding section + an
out-of-scope section.

- **Added strategy note** (top-of-file LaTeX comment block) — pins the role of A.4.a in
  Route A and lists the two outputs (Milne 3.1 + Milne 3.3) + the bonus Weil-divisor
  reformulation. Cross-refs A.4.b (Auslander--Buchsbaum) and A.4.c (Theorem 3.2).
- **Added `% archon:covers` line** + **`% NOTE:`** flagging shared material with
  RiemannRoch_WeilDivisor.tex (as directed).
- **Added definition** `\definition`/`\label{def:indeterminacy_locus}`/`\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacyLocus}` — domain-of-definition + indeterminacy locus of a rational map; Milne §I.3 p.16 source.
- **Added definition** `\definition`/`\label{def:codim_one_indeterminacy}`/`\lean{AlgebraicGeometry.Scheme.RationalMap.CodimOneFree}` — the predicate ``no codim-1 indeterminacy''. Encoded via `Order.coheight = 1` to match the RR.1 `def:prime_divisor` idiom.
- **Added lemma** `\lemma`/`\label{lem:smooth_codim_one_dvr}`/`\lean{AlgebraicGeometry.Scheme.localRing_dvr_of_codim_one}` — smooth ⇒ DVR at codim-1 points. Hartshorne II.6 p.130 source (verbatim quotes from the definition of ``regular in codimension one'' and the prime-divisor/DVR consequence).
  - Proof sketch added: smoothness ⇒ regular local ring ⇒ regular of dim 1 ⇒ DVR.
- **Added theorem** `\theorem`/`\label{thm:codim_one_extension}`/`\lean{AlgebraicGeometry.Scheme.RationalMap.extend_of_codimOneFree_of_smooth}` — Milne Theorem 3.1: rational map to a complete variety has codim ≥ 2 indeterminacy; if the map is codim-1-free, it extends.
  - Proof sketch added: two-step (Milne's curve case + reduction to dim 1) + the
    depth-≥2 codim-≥2 extension step that consumes `\cref{cor:regular_cohen_macaulay}`
    from A.4.b.
- **Added remark** `\remark`/`\label{rmk:codim1_role_of_ab}` — clarifies where
  Auslander--Buchsbaum enters and the smooth-surface specialisation needed by A.4.c.
- **Added lemma** `\lemma`/`\label{lem:milne_codim1_indeterminacy}`/`\lean{AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme}` — Milne Lemma 3.3: indeterminacy locus into a group variety is pure codim 1.
  - Proof sketch added: 4 sub-steps (the difference rational map $\Phi$; equivalence of $\Phi$-defined-at-$(x,x)$ and $\varphi$-defined-at-$x$; pullback-of-local-rings reformulation; pole locus on the diagonal is pure codim 1 via Krull's PIT on $X \times X$).
  - Verbatim quote of the Milne proof copied character-by-character into a
    `% SOURCE QUOTE PROOF:` block.
- **Added remark** `\remark`/`\label{rmk:milne_lem33_charfree}` — characteristic-freeness
  of Lemma 3.3.
- **Added theorem** `\theorem`/`\label{thm:weil_divisor_obstruction}`/`\lean{AlgebraicGeometry.Scheme.RationalMap.extend_iff_order_nonneg}` — Weil-divisor reformulation: $f$ extends at a prime divisor $W$ iff all coordinate pullbacks have $\ord_W \geq 0$. Sourced from Hartshorne II.6 pp.130-131 (the $v_Y$ valuation passage).
  - Proof sketch added: short, via the DVR characterisation
    $\mathcal{O}_{X, \eta_W} = \{ h \in K(X) : \ord_W(h) \geq 0 \} \cup \{0\}$.
- **Added remark** `\remark`/`\label{rmk:weil_obstruction_application}` — explains why
  the Weil-divisor form (rather than the abstract codim-$\geq 2$ form) is what the
  Lean prover consumes when working with `Scheme.WeilDivisor`.
- **Added** `\section{Lean encoding}` — enumerates the 6 Lean targets with their
  signatures, threads the Mathlib readiness audit (at commit `b80f227`), flags
  the local-cohomology vanishing as a substantial Mathlib gap with a smooth-surface
  workaround.
- **Added** `\section{Out of scope}` — explicitly excludes Auslander--Buchsbaum
  (A.4.b), Milne 3.2 itself (A.4.c), Milne 3.4-3.10, Weil-divisor degree on
  $X \times X$, Cartier divisors, non-algebraically-closed base, blow-up resolution.

## Cross-references introduced

All `\uses{...}` cross-references verified against existing labels on disk:
- `def:codim_one_indeterminacy` `\uses{def:indeterminacy_locus}` — same chapter.
- `thm:codim_one_extension` `\uses{def:indeterminacy_locus, def:codim_one_indeterminacy, lem:smooth_codim_one_dvr, cor:regular_cohen_macaulay}` — last refers to `chap:Albanese_AuslanderBuchsbaum` L416 — verified present.
- `lem:milne_codim1_indeterminacy` `\uses{def:indeterminacy_locus, def:order_at_point, def:codim1_cycles}` — last two refer to `chap:RiemannRoch_WeilDivisor` L260 and L220 — verified present.
- `thm:weil_divisor_obstruction` `\uses{def:order_at_point, def:codim1_cycles, def:indeterminacy_locus, lem:smooth_codim_one_dvr}` — all verified.
- Proof of `thm:codim_one_extension` also `\uses{cor:regular_cohen_macaulay}`.
- Proof of `lem:milne_codim1_indeterminacy` adds `\uses{lem:smooth_codim_one_dvr}`.
- Proof of `thm:weil_divisor_obstruction` `\uses{thm:codim_one_extension}` for the
  ``regular = no pole'' lemma invocation.

I cleaned up one mis-applied `\uses` on the proof of `lem:smooth_codim_one_dvr`
(it had referenced `def:codim_one_indeterminacy` though the proof doesn't depend on
it — the lemma is foundational for the predicate, not the other way around).

## References consulted

- `references/summary.md` — index of sources, confirmed the abelian-varieties
  card and the hartshorne card.
- `references/abelian-varieties.md` — Milne reference card; confirmed Lemma 3.3 is at
  doc p.17 (PDF p.23), Theorem 3.1 at doc p.16 (PDF p.22), Theorem 3.2 at doc p.16
  (PDF p.22).
- `references/abelian-varieties.pdf` pages 21-26 (rendered visually since the PDF has
  no text layer issues; pages 21-26 ↔ doc pages 15-20). Read the verbatim text of:
  - Theorem 3.1 statement + the full proof (covers PDF p.22-23 = doc p.16-17).
  - Theorem 3.2 statement + one-line proof (PDF p.23 = doc p.17).
  - Lemma 3.3 statement + the full proof (PDF p.23-24 = doc p.17-18).
- `references/hartshorne-algebraic-geometry.md` — Hartshorne card; confirmed II.6
  starts at doc p.129 (PDF p.146).
- `references/hartshorne-algebraic-geometry.pdf` pages 147-148 (= doc p.130-131).
  Read the verbatim text of:
  - The ``regular in codimension one'' definition (PDF p.147 = doc p.130).
  - The two-paragraph remark on nonsingular varieties having all-local-rings-regular
    (PDF p.147 = doc p.130).
  - The prime-divisor / generic-point / DVR / valuation $v_Y$ paragraph including
    the ``zero/pole along $Y$'' definition (PDF p.147-148 = doc p.130-131).
- `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — for the RR.1 chapter's
  labels I cross-referenced (`def:prime_divisor`, `def:codim1_cycles`,
  `def:order_at_point`, `def:principal_divisor`, `def:divisor_degree`) and for the
  `Order.coheight` encoding convention.
- `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex` — for the consumer
  chapter that this chapter is the input to; confirmed it expects
  `thm:codim_one_extension` and `lem:milne_codim1_indeterminacy` labels.
- `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` — for the sibling A.4.b
  chapter's labels I cross-referenced (`thm:auslander_buchsbaum`,
  `cor:regular_cohen_macaulay`) and for the proof-tone style.
- `blueprint/src/macros/common.tex` — confirmed `\Spec`, `\Pic` are defined as
  math operators; the chapter uses both.

## Macros needed

The chapter uses the same macros RR.1 already uses, namely:

- `\codim` — used 6× in this chapter (e.g. ``$\codim_X \overline{\{\eta\}} = 1$''); also used many times in `RiemannRoch_WeilDivisor.tex`. Not defined in `macros/common.tex` at the project's current state.
- `\ord` — used 8× in this chapter; also extensively used in `RiemannRoch_WeilDivisor.tex`. Not defined.
- `\div` — used 5× in this chapter for the divisor map; `RiemannRoch_WeilDivisor.tex` uses it the same way. Conflicts with the built-in `\div` ÷ symbol; should be `\DeclareMathOperator{\div}{div}` or `\renewcommand`. Not defined / not renamed.
- `\Div` — used 4× in this chapter (e.g. ``$\Div(X)$''); also used in `RiemannRoch_WeilDivisor.tex`. Not defined.
- `\Pic^0_{C/k}`, `\Pic^\tau$` etc. — `\Pic` IS defined; the superscript usage is standard.
- All other macros used (`\Spec`, `\mathcal{O}_{...}`, `\operatorname{...}`, etc.) are either defined in `common.tex` or built-in.

Since these macros are missing pre-existing-in-the-project (RR.1 already uses them
without definitions), the plan agent likely already has them queued. NOT added by me
(`macros/common.tex` is outside my write-domain).

## Reference-retriever dispatches

None. All required citations were backed by reference files already on disk
(Milne PDF + Hartshorne PDF), both of which I opened and read in this session.

## Notes for Plan Agent

1. **Two labels per Milne theorem, intentional.** The directive frames
   `thm:codim_one_extension` as ``Milne Lemma 3.3 — codim-1 extension over a smooth
   surface'', but the sibling chapter
   `Albanese_Thm32RationalMapExtension.tex` (L78-L82) reads
   `thm:codim_one_extension` as Milne Theorem 3.1 (``the codim-$\geq 2$ extension
   theorem'') and `lem:milne_codim1_indeterminacy` as Milne Lemma 3.3 (``the
   pure-codim-$1$ structure of the indeterminacy locus''). I followed the sibling
   chapter's labelling for cross-reference consistency, and treated the directive's
   prose as the combined statement that A.4.a should expose. The chapter therefore
   contains BOTH `thm:codim_one_extension` (= Milne 3.1) AND
   `lem:milne_codim1_indeterminacy` (= Milne 3.3), even though the directive's
   ``Required content'' section only enumerates one ``Theorem: Milne Lemma 3.3''.
   The Lean signature `extend_of_codimOneFree_of_smooth` reads naturally as ``$f$
   codim-1-free $\Rightarrow$ extends'', which is the conditional half of Milne 3.1
   (the assumed-true ``Codim-1-Free'' hypothesis turns the conclusion into a full
   extension). This matches the directive's prose.

2. **Local-cohomology vanishing is the main Mathlib gap.** Step 2 of
   `thm:codim_one_extension`'s proof (depth-$\geq 2$ extension across a codim-$\geq 2$
   regular point) needs $H^0_{\{x\}}(\mathcal{O}_X) = H^1_{\{x\}}(\mathcal{O}_X) = 0$
   in some form. Stacks tag 0AVF (and Hartshorne III.3.5 for the surface case) are
   the standard references but neither is in Mathlib at `b80f227`. I flagged two
   workarounds in `\section{Lean encoding}`: (a) prove the depth-$\geq 2$ extension
   property as a project-local lemma using A.4.b's `Module.depth` API, or
   (b) reformulate `thm:codim_one_extension` in the surface-only form (which is
   what A.4.c actually needs). The plan agent should decide between (a) and (b)
   before A.4.a's prover starts.

3. **`References` paragraph in the rational-map definition.** The Mathlib name
   `Scheme.RationalMap.domain` is what I assumed for the underlying open set; the
   prover should grep at `b80f227` to confirm the exact field name. If it's
   `Scheme.RationalMap.openSet` or `Scheme.RationalMap.dom`, the
   `indeterminacyLocus` definition should adjust accordingly. The chapter uses
   `f.domain` as the informal name.

4. **Bonus theorem `thm:weil_divisor_obstruction` may not be strictly necessary
   for A.4.c.** The consumer chapter
   `Albanese_Thm32RationalMapExtension.tex` cites only `thm:codim_one_extension` and
   `lem:milne_codim1_indeterminacy`; the Weil-divisor reformulation is in the
   directive's required-content list but does not appear as a cross-reference
   target downstream. I included it as directed but it could be dropped if the
   plan agent revisits the chapter scope (e.g. to shave LOC). Conversely, it could
   be promoted to a load-bearing theorem if A.4.d's symmetric-product Albanese proof
   prefers to phrase its codim-1 obstructions in Weil-divisor language.

5. **Cross-reference safety of `cor:regular_cohen_macaulay`.** I cross-referenced
   `cor:regular_cohen_macaulay` from `Albanese_AuslanderBuchsbaum.tex` L416. Verified
   the label is present at the time of writing. The chapter's `\uses{}` correctly
   threads this dependency on `thm:codim_one_extension`.

6. **Macro additions.** Listed above under ``Macros needed''. Five macros
   (`\codim`, `\ord`, `\div`, `\Div`, plus the renaming of the built-in `\div`) are
   used by both this chapter and `RiemannRoch_WeilDivisor.tex` without being defined
   in `common.tex`. This is a pre-existing project state, not something my chapter
   introduced. If `RiemannRoch_WeilDivisor.tex` typesets cleanly today, my chapter
   will too.

## Strategy-modifying findings

None. The chapter writes out the Milne 3.1 + Milne 3.3 + Weil-divisor reformulation
package as the directive specifies. The strategy claim that A.4.a is the
risk-dominant Route A piece (STRATEGY.md L29) is supported by the writing
experience: the chapter is straightforward to lay out at the blueprint level
(every claim has an immediate textbook source), but the formalisation side has
two genuine Mathlib gaps that the prover will hit:

(a) the local-cohomology / depth-$\geq 2$ extension property needed in Step 2
    of `thm:codim_one_extension`'s proof, and
(b) the ``rational map regular at codim-1 point $\Leftrightarrow$ pullback lands in
    $\mathcal{O}_{X, \eta_W}$'' lemma needed in `thm:weil_divisor_obstruction`'s
    proof (this is folklore-standard in algebraic geometry but I am not aware of
    a Mathlib-direct version).

Neither gap is project-fatal, but both confirm the STRATEGY.md L29 risk
characterisation. No revision to the strategy is required from the writing pass;
the prover round should plan for (a) and (b) explicitly.
