# Blueprint Writer Report

## Slug
render-picard-flatteningstratification

## Status
COMPLETE — all 23 literal-ref findings and both math-delim findings repaired; the
mathematics is untouched and `leandag build` reports `unknown_uses: []`.

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Changes Made

This was a pure rendering / cross-reference repair pass. No statement, proof
argument, definition, numeric claim, `\lean{}`, `\label{}`, or `\uses{}` edge was
altered.

### literal-ref (23 doctor findings, all rendered prose)
Each `Theorem~REF` / `Lemma~REF` / `Definition~REF` / `Corollary~REF` placeholder
was replaced with the correct `\cref{<label>}`, target determined from the
surrounding prose and the chapter's `\label{}`s:

| Line (orig) | Context | Replaced REF → |
|---|---|---|
| 192 | proof of `thm:generic_flatness`: "Theorem~REF produces \(f\in A\)…" | `\cref{thm:generic_flatness_algebraic}` |
| 482 | proof of `lem:nonflat_locus_proper`: "By Theorem~REF applied to \(\F\|_{\PP^n_U}\)" | `\cref{thm:generic_flatness}` |
| 531 | statement of `lem:noetherian_induction_strata`: "be as in Theorem~REF" | `\cref{thm:flattening_stratification_exists}` |
| 536 | same: "Iterating the \(n=0\) stratification (Lemma~REF)" | `\cref{lem:flat_locus_open}` |
| 543 | same: "subschemes \(S_f\subseteq W_f\) of Theorem~REF" | `\cref{thm:flattening_stratification_exists}` |
| 557 | proof: "By Lemma~REF, the family of Hilbert polynomials… is finite" | `\cref{lem:nonflat_locus_proper}` |
| 573 | proof: "Apply Lemma~REF sequentially to … \(E_i=\pi_*\F(N+i)\)" | `\cref{lem:flat_locus_open}` |
| 702 | statement of `thm:..._universal`: "be as in Theorem~REF" | `\cref{thm:flattening_stratification_exists}` |
| 733 | proof of universal: "end of the proof of Theorem~REF" | `\cref{thm:flattening_stratification_exists}` |
| 744 | proof of universal: "(Lemma~REF) yields a unique scheme morphism" | `\cref{lem:flat_locus_open}` |
| 755 | curve section prose: "Nitsure's Theorem~REF demand projective" | `\cref{thm:flattening_stratification_exists}` |
| 796 | statement of `cor:..._curve`: "conclusion of Theorem~REF applies" | `\cref{thm:flattening_stratification_exists}` |
| 807 | proof of corollary: "By Lemma~REF, \(C\times_k T\to T\) is projective" | `\cref{lem:smooth_proper_curve_projective}` |
| 813 | proof of corollary: "Apply Theorem~REF to \(\tilde\F\)" | `\cref{thm:flattening_stratification_exists}` |
| 839 | Mathlib status: "(Definition~REF)" | `\cref{def:coherent_sheaf_flat}` |
| 844 | Mathlib status: "flatteningStratification (Theorem~REF)" | `\cref{thm:flattening_stratification_exists}` |
| 846 | Mathlib status: "flatLocusStratification (Lemma~REF)" | `\cref{lem:flat_locus_stratification_lean}` |
| 847 | Mathlib status: "flatLocusReduction (Lemma~REF…)" | `\cref{lem:flat_locus_reduction_lean}` |
| 849 | Mathlib status: "flatLocusAssembly (Lemma~REF)" | `\cref{lem:flat_locus_assembly_lean}` |
| 852 | Mathlib status: "flatteningStratification\_universal (Theorem~REF)" | `\cref{thm:flattening_stratification_universal}` |
| 856 | Mathlib status: "ofCurve (Corollary~REF)" | `\cref{cor:flattening_stratification_curve}` |
| 875 | Mathlib status: "construction in Lemma~REF" | `\cref{lem:noetherian_induction_strata}` |
| 893 | out-of-scope: "inside the proof of Lemma~REF" | `\cref{lem:noetherian_induction_strata}` |

All referenced labels exist in this chapter; `leandag` confirms `unknown_uses: []`.

### math-delim (2 findings, single interleaved site)
In the proof of `thm:flattening_stratification_universal` (orig lines 741–742) the
formula was mangled with interleaved delimiters:
`… for $i \ge N'\(, the universal property of \)S_f \subseteq W_f$ as the closed`
(a `\(` opened inside `$…$`, plus a `\)` with no matching `\(`). Rewritten single-style:
`… for \(i \ge N'\), the universal property of \(S_f \subseteq W_f\) as the closed`.
This same edit also resolved the `Lemma~REF` on the following line. No other formula
was touched; the standalone balanced `$\dim \mathrm{supp}…$` formula (orig line 153)
is single-style and was not a finding, so it was left as-is.

### Comment-block REF cleanup (not among the 23 doctor findings, but removes every
remaining literal `REF` from the file)
- Our own explanatory parenthetical in the `% SOURCE QUOTE PROOF:` note before
  `thm:generic_flatness`'s proof ("deduce the geometric form from Theorem~REF"):
  rewritten to "the algebraic generic flatness statement
  (\cref{thm:generic_flatness_algebraic})".
- Four `REF` tokens sitting inside verbatim `% SOURCE QUOTE` / `% SOURCE QUOTE PROOF:`
  comment blocks were restored to Nitsure's **actual** internal references, read from
  the source `.tex`, improving verbatim fidelity (these are LaTeX comments, so the
  `\ref{}`s are not parsed and create no broken refs):
  - "as follows from Lemma REF" → `Lemma \ref{graded module is flat}` (Nitsure L1900)
  - "By Theorem REF on generic flatness" → `Theorem \ref{generic flatness} on generic flatness` (Nitsure L1909)
  - "By Lemma REF," → `By Lemma \ref{base change without flatness},` (Nitsure L2066)
  - "by Lemma REF," → `by Lemma \ref{graded module is flat},` (Nitsure L2071)

## Cross-references introduced
All `\cref{}` targets are labels defined within this same chapter; verified present
and `leandag build --json` reports `unknown_uses: []` (no broken refs introduced).

## References consulted
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` — read L1772–1790,
  L1888–1935, L2060–2090 to recover the actual internal cross-reference labels Nitsure
  uses ("generic flatness", "graded module is flat", "base change without flatness")
  so the verbatim `% SOURCE QUOTE` comment blocks could be restored faithfully instead
  of leaving the `REF` placeholders.

## Macros needed (if any)
None. `\cref` (cleveref) is already used elsewhere in this chapter.

## Notes for Plan Agent
- All `\lean{...}` hints, `\uses{}` edges, definitions, proof sketches, and numeric
  content are unchanged — this was a cleanup-only pass as directed.
- No `bare-label` or `undefined-macro` findings were present in this chapter (the
  directive listed only literal-ref ×23 and math-delim ×2); none were needed.
- Several proof bodies use plain `\ref{...}` (e.g. `\ref{lem:nonflat_locus_proper}`,
  `\ref{thm:generic_flatness}` in the existence-theorem proof) rather than `\cref{}`.
  These render fine and were not flagged; left untouched to stay in scope. A future
  consistency pass could normalise them to `\cref{}` if desired.

## Strategy-modifying findings
None. The repair was purely typographic/cross-referential; no strategy-level issue
surfaced.
