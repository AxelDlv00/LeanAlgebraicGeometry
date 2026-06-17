# Blueprint Writer Report

## Slug
a2a-flatteningstrat

## Status
COMPLETE — chapter scaffolded with one verbatim-quote gap explicitly marked
(Stacks tag 052H, listed as parallel pointer only; not silently fabricated).
See "Notes for Plan Agent" for the 052H retrieval recommendation.

## Target chapter
`blueprint/src/chapters/Picard_FlatteningStratification.tex` (NEW file, 631 lines)

## Changes Made
- **NEW chapter** `chap:Picard_FlatteningStratification` --- packages the
  Nitsure §4 flattening-stratification theorem as the A.2.a Route-A sub-row.
- **Added definition** `def:coherent_sheaf_flat` (`\lean{AlgebraicGeometry.Scheme.CoherentSheafFlat}`)
  --- coherent-sheaf flatness over a noetherian base, defined stalk-wise with
  the affine-local module-flatness restatement.
- **Added theorem** `thm:generic_flatness_algebraic` --- the Nitsure §4
  algebraic lemma on generic flatness (verbatim quote of statement L1711–L1716;
  proof-quote excerpted L1719–L1772 with structural restatement). Helper input
  for the main theorem.
  - Proof sketch added: Y, full Noether-normalisation chain restated in
    project notation.
- **Added theorem** `thm:generic_flatness` (`\lean{AlgebraicGeometry.genericFlatness}`)
  --- the Nitsure §4 geometric `generic flatness` theorem (verbatim L1781–L1787).
  - Proof sketch added: Y, the one-sentence Nitsure proof restated.
- **Added theorem** `thm:flattening_stratification_exists` (`\lean{AlgebraicGeometry.flatteningStratification}`)
  --- the main existence theorem with parts (i)–(iii), full verbatim quote of
  statement L1811–L1841 from Nitsure §4.
  - Proof sketch added: split into three sub-lemmas per the directive's
    sub-statement recommendation.
- **Added lemma** `lem:flat_locus_open` --- the $n=0$ special case
  (matrix-rank stratification of the flat locus); verbatim quote L1849–L1885.
  - Proof sketch added: Y, restated from Nitsure's special-case body.
- **Added lemma** `lem:nonflat_locus_proper` --- the Noetherian-induction
  reduction (via generic flatness) producing the flat-pieces decomposition;
  verbatim quote L1888–L1929 including statement (A).
  - Proof sketch added: Y, the irreducible-component plus reduced-complement
    induction restated.
- **Added lemma** `lem:noetherian_induction_strata` --- the assembly step
  combining the $n=0$ special case applied to direct images
  $E_i = \pi_*\F(N+i)$; verbatim quote excerpted L1992–L2090 (proof body too
  long for single verbatim, with quote-marker pointing to range).
  - Proof sketch added: Y, the full $W_f$/$S_f$ construction with the
    base-change-via-cohomology argument.
- **Added theorem** `thm:flattening_stratification_universal` (`\lean{AlgebraicGeometry.flatteningStratification_universal}`)
  --- the universal property of the disjoint coproduct $\coprod_f S_f \to S$;
  verbatim quote L1826–L1834 (part (ii) of the main theorem); proof verbatim
  L2065–L2082.
  - Proof sketch added: Y.
- **Added lemma** `lem:smooth_proper_curve_projective` --- folklore-level
  result that a smooth proper curve over a field is projective; cited
  structurally to Hartshorne II.6.7 / II.7.6 (no verbatim quote, classical
  result marked as such).
  - Proof sketch added: Y, the standard divisor-embedding argument.
- **Added corollary** `cor:flattening_stratification_curve` --- the Route A
  consumer specialisation to a relative curve $C \times_k T \to T$, deriving
  from `thm:flattening_stratification_exists` via the relative-$\PP^n$ closed
  immersion.
  - Proof sketch added: Y.
- **Mathlib status section** --- enumerates the existing Mathlib pieces
  (`Module.Flat`, `Mathlib.AlgebraicGeometry.Morphisms.Flat`) and lists the
  five missing constructions the chapter introduces, plus four Mathlib inputs
  the proof consumes.
- **Out-of-scope section** --- explicit demarcation against
  Castelnuovo--Mumford regularity (Nitsure §2), Quot construction (A.2.b),
  relative Picard functor (A.1.c), Picard-representability assembly (A.2.c).

## Cross-references introduced
- `\uses{def:coherent_sheaf_flat}` in `thm:generic_flatness_algebraic`,
  `thm:generic_flatness`, `thm:flattening_stratification_exists`,
  `lem:flat_locus_open`, `lem:nonflat_locus_proper`,
  `thm:flattening_stratification_universal` --- the definition is local.
- `\uses{thm:generic_flatness_algebraic}` in `thm:generic_flatness` --- local.
- `\uses{thm:generic_flatness}` in `lem:nonflat_locus_proper`,
  `lem:noetherian_induction_strata` --- local.
- `\uses{lem:flat_locus_open, lem:nonflat_locus_proper}` in
  `lem:noetherian_induction_strata` --- local.
- `\uses{thm:flattening_stratification_exists, def:coherent_sheaf_flat}` in
  `thm:flattening_stratification_universal` --- local.
- `\uses{thm:flattening_stratification_exists, lem:smooth_proper_curve_projective}`
  in `cor:flattening_stratification_curve` --- local.
- `\cref{chap:Picard_RelativeSpec}` (sibling chapter reference) --- exists at
  `blueprint/src/chapters/Picard_RelativeSpec.tex`, verified.

## References consulted
- `references/summary.md` --- entry index; identified the Nitsure source as
  authoritative for §4 and noted the Stacks-coherent file's restriction to
  tag 02KH.
- `references/nitsure-hilbert-quot.md` --- contents map; located §4 at L1698
  in the source.
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` --- the
  primary verbatim source for every `% SOURCE QUOTE:` block in the chapter:
  - L1711–L1716: algebraic generic-flatness lemma statement.
  - L1719–L1772: algebraic generic-flatness lemma proof (excerpted with
    pointer-only continuation).
  - L1781–L1787: geometric generic-flatness theorem statement.
  - L1776–L1777: geometric generic-flatness theorem proof (the one-sentence
    Nitsure proof).
  - L1811–L1841: main flattening-stratification theorem statement.
  - L1849–L1885: special case $n=0$ (sub-lemma `lem:flat_locus_open`).
  - L1888–L1929: general case reduction (sub-lemma `lem:nonflat_locus_proper`).
  - L1992–L2090: assembly via direct images (sub-lemma
    `lem:noetherian_induction_strata`).
  - L2065–L2082: universal-property proof (for `thm:flattening_stratification_universal`).
- `references/stacks-coherent.md` --- consulted to confirm that the local
  stacks-coherent file covers only tag **02KH** (flat base change for
  cohomology), NOT tag 052H. The Stacks 052H citation in the chapter is
  therefore listed as a parallel pointer only (see "Notes for Plan Agent").
- `references/fga-explained.md` --- confirmed the FGA Explained book numbers
  Nitsure's §4 at p.122 (§5.4 in book numbering); not used for verbatim
  quotes (the arXiv form is more granular).
- `blueprint/src/chapters/Rigidity.tex` --- structural template for chapter
  layout (statement / proof sketch / use / Mathlib status sections).
- `blueprint/src/chapters/Picard_RelativeSpec.tex` --- structural template
  for the Stacks-cited blocks (`% SOURCE:` + verbatim `% SOURCE QUOTE:` +
  `\textit{Source:}` discipline) and for the chapter's sibling-A.1.a
  positioning.

## Macros needed (if any)
- `\Quot` and `\quot` --- used in §5.1 / §5.2 introduction prose. Nitsure
  defines these in its preamble; the project may or may not have them. **NOT
  added by me** (`macros/common.tex` is out of write-domain). Plan agent:
  please verify `\Quot`/`\quot` are defined in `macros/common.tex` before next
  PDF typeset; if not, add them (e.g.\ `\newcommand{\Quot}{\mathrm{Quot}}`,
  `\newcommand{\quot}{\mathrm{Quot}}`).
- `\Hom`, `\Spec`, `\Pic`, `\Jac`, `\Sch`, `\PP`, `\F`, `\OO`, `\Z`, `\Q`,
  `\sym`, `\spec` --- all standard; assumed defined in the project's macro
  file (Picard_RelativeSpec.tex uses them).
- `\hra` --- "hookrightarrow"; Nitsure uses it in the verbatim quotes (e.g.\
  `\hra` in L1820, L1830, etc.). The verbatim quotes preserve this. The
  project's prose uses `\hookrightarrow` directly. Both forms appear in the
  chapter; if `\hra` is not defined in `macros/common.tex` the LaTeX typeset
  will fail. **Plan agent**: please add
  `\newcommand{\hra}{\hookrightarrow}` to `macros/common.tex` if absent (this
  is purely a verbatim-source convenience macro).
- `\pp` --- Nitsure uses `\pp` for `\mathfrak{p}` (prime ideal); appears in
  the verbatim proof-quote of `thm:generic_flatness_algebraic`. The project
  prose uses `\mathfrak{p}` directly. Same recommendation: add
  `\newcommand{\pp}{\mathfrak{p}}` if absent.
- The `enumerate[label=(\roman*)]` syntax uses `enumitem`; assumed
  loaded by the blueprint preamble (the existing chapter
  `Picard_RelativeSpec.tex` uses `enumerate` without options, so this is a
  minor extension; if `enumitem` is not loaded, the enumerate inside
  `thm:flattening_stratification_exists` will fall back gracefully).

## Reference-retriever dispatches (if any)
None this iteration.  See "Notes for Plan Agent" for the recommended Stacks
tag 052H retrieval for a future iteration; I did NOT dispatch because the
Nitsure §4 verbatim quotes already cover every claim in the chapter and the
Stacks pointer is non-load-bearing (Nitsure is the project's named source for
A.2.a).  Listing 052H as a parallel pointer with verbatim explicitly
unavailable preserves the chapter's value while staying inside the
no-fabrication rule.

## Notes for Plan Agent

1. **Stacks tag 052H verbatim retrieval is NOT in this chapter.** The
   directive named Stacks 052H as a secondary citation source, but
   `references/stacks-coherent.md` covers only tag 02KH; 052H is in a different
   Stacks chapter (Section "Flattening stratifications" inside chapter 38
   "More on Morphisms", file `more-morphisms.tex`). I have NOT fabricated a
   verbatim quote for 052H. Every block in the chapter is sourced from Nitsure
   §4 (which IS local and is the canonical project source per the directive's
   "Read source verbatim from" line). The Stacks 052H pointer appears in two
   `\textit{Source:}` lines as "cf.\ [Stacks Project], tag 052H." (no verbatim
   quote). If a future iter wants the chapter's Stacks citations to be
   verbatim-backed, dispatch a reference-retriever for
   `more-morphisms.tex` covering tags 052G/052H (Section "Flattening
   stratifications") and add `% SOURCE QUOTE:` blocks pointing at the new local
   file.

2. **Strategy concern --- Nitsure's projective hypothesis vs project's proper
   hypothesis.** The directive flagged this as a "hypotheses can be relaxed
   for our setting" lemma, and §4 of the chapter
   (`lem:smooth_proper_curve_projective` + `cor:flattening_stratification_curve`)
   handles it: smooth proper curves over a field ARE projective, so the
   instantiation is direct. **No strategy modification needed.** The Route A
   consumer side is unaffected.

3. **Castelnuovo--Mumford regularity dependency.** The proof of
   `lem:noetherian_induction_strata` invokes Castelnuovo--Mumford regularity
   / Serre vanishing implicitly (statement (B) in Nitsure's proof: existence
   of uniform $N_1$ with vanishing of higher cohomology of $\F(m)$ for $m \ge
   N_1$). The chapter cites this structurally and defers the formal proof to
   a future planned chapter `Picard_CastelnuovoMumford.tex` (not yet
   scaffolded). **Plan agent**: please add Castelnuovo--Mumford as an A.2.a
   sub-sub-row in the next planning iteration; it is a load-bearing input
   for the Lean port of `lem:noetherian_induction_strata`.

4. **Sub-lemma `\lean{}` pins not added.** The three sub-lemmas
   (`lem:flat_locus_open`, `lem:nonflat_locus_proper`,
   `lem:noetherian_induction_strata`) and the helper
   `lem:smooth_proper_curve_projective` do NOT yet have `\lean{...}`
   declarations because the directive listed only three required pins
   (`def:coherent_sheaf_flat`, `thm:flattening_stratification_exists`,
   `thm:flattening_stratification_universal`). Future iters may want to pin
   the sub-lemmas as well; suggested names (in the same
   `AlgebraicGeometry.FlatteningStratification` namespace):
   - `flatLocusStratification` for `lem:flat_locus_open`
   - `flatLocusReduction` for `lem:nonflat_locus_proper`
   - `flatLocusAssembly` for `lem:noetherian_induction_strata`
   - `IsProjective.of_smoothProperCurve` for `lem:smooth_proper_curve_projective`
   - `flatteningStratification_curve` for `cor:flattening_stratification_curve`

5. **`% archon:covers` line present** at the top of the file as the directive
   required.

6. **`\input{chapters/Picard_FlatteningStratification}` in `content.tex` is
   plan-agent territory**, not added by me as instructed.

## Strategy-modifying findings
None. The Nitsure §4 hypotheses (noetherian base + projective morphism) are
compatible with the Route A consumer setting; the
`lem:smooth_proper_curve_projective` + `cor:flattening_stratification_curve`
pair handles the projective-vs-proper instantiation cleanly. The
Castelnuovo--Mumford dependency surfaced by the proof of
`lem:noetherian_induction_strata` is a known A.2.a sub-row that the plan
agent should add to the planning grid (it is not a strategy *change*, just
a strategy *expansion* to a sub-sub-row that the project will need anyway
for the Quot construction).
