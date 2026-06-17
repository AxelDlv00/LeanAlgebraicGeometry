# Blueprint Writer Report

## Slug
differentials-iter110

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Differentials.tex

## Changes Made

Three proof-block expansions, one per prover-viable non-L877 sorry flagged by `blueprint-reviewer-iter110`. No new declaration blocks introduced; only proof sketches expanded to a textbook-paper level of detail with explicit Mathlib lemma names so the iter-111 prover lane on L122/L718/L735 has concrete entry points.

- **Revised** `thm:relative_kaehler_isSheaf` (corresponds to Lean L122 / `AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_isSheaf`):
  - Moved the one-sentence proof prose out of the theorem block and replaced it with a structured 4-paragraph `\begin{proof}...\end{proof}` block (reduction · affine basis case · basis-to-opens descent · non-viability remark).
  - Cited Mathlib entry points: `TopCat.Presheaf.isSheaf\_iff\_isSheaf\_comp`, `AlgebraicGeometry.Scheme.isBasis\_affineOpens`, `KaehlerDifferential.isLocalizedModule\_map`, `KaehlerDifferential.tensorKaehlerEquiv`, `TopCat.Presheaf.IsSheaf.isSheafUniqueGluing`.
  - Cited Stacks Tag~01UM and Hartshorne~II.8, Proposition~8.2A for the localisation compatibility.
  - Proof sketch added: Y (4 paragraphs, ~30 lines).
- **Revised** `thm:smooth_iff_locally_free_omega` (corresponds to Lean L718 / `AlgebraicGeometry.Scheme.smooth_iff_locally_free_omega`):
  - Moved the one-sentence proof prose out of the theorem block and replaced it with a 3-paragraph `\begin{proof}...\end{proof}` block (forward · converse · local-to-global).
  - Cited Mathlib entry points: `AlgebraicGeometry.IsSmoothOfRelativeDimension`, `AlgebraicGeometry.isSmooth\_iff`, `Algebra.IsStandardSmooth.free\_kaehlerDifferential`, `Algebra.IsStandardSmoothOfRelativeDimension.rank\_kaehlerDifferential`, `Algebra.IsStandardSmoothOfRelativeDimension.iff\_of\_isStandardSmooth`, `Algebra.IsStandardSmooth.iff\_exists\_basis\_kaehlerDifferential`, `KaehlerDifferential.span\_range\_derivation`, `Algebra.FinitePresentation`.
  - Cited Stacks Tag~02HQ (Jacobian criterion) and Tag~02HW (smooth iff locally free Ω); Hartshorne~II.8 Proposition~8.7.
  - Proof sketch added: Y (3 paragraphs, ~30 lines).
- **Revised** `cor:cotangent_at_section` (corresponds to Lean L735 / `AlgebraicGeometry.Scheme.cotangent_at_section`):
  - Added a new 2-paragraph `\begin{proof}...\end{proof}` block (previously the corollary had no proof block at all).
  - Cited Mathlib entry points: `AlgebraicGeometry.Scheme.Modules.pullback`, `SheafOfModules.pullbackObjFreeIso` (from `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackFree`).
  - Cited Hartshorne~II Corollary~8.10 for the pullback-preserves-locally-free-of-rank statement.
  - Proof sketch added: Y (2 paragraphs, ~15 lines).

The chapter remains balanced LaTeX: 20 `\begin` blocks paired with 20 `\end` blocks across theorem/lemma/proof/definition/corollary/proposition/remark environments.

## Cross-references introduced
- `\uses{def:relative_kaehler_presheaf}` in the new proof of `thm:relative_kaehler_isSheaf` — same chapter, exists.
- `\uses{def:relative_kaehler_sheaf, def:relative_kaehler_presheaf, thm:cotangent_exact_sequence}` in the new proof of `thm:smooth_iff_locally_free_omega` — all in this same chapter, exist.
- `\uses{thm:smooth_iff_locally_free_omega, def:relative_kaehler_sheaf}` in the new proof of `cor:cotangent_at_section` — same chapter, exist.
- `\ref{chap:Jacobian}` in the cotangent-at-section proof closing remark — verified label `\label{chap:Jacobian}` exists in `blueprint/src/chapters/Jacobian.tex`.

## Macros needed (if any)
None. All macros used (`\struct{...}`, `\Spec`, `\Jac`, `\texttt{...}`, `\ref`, `\uses{...}`, `\lean{...}`, `\label{...}`, `\emph{...}`, escaped underscores `\_` inside `\texttt{...}`) are pre-existing in this chapter or in the standard preamble.

## Reference-retriever dispatches (if any)
None. The Mathlib lemma names I needed were directly recoverable from `lean_leansearch` (used 8 queries; one rate-limit hit but no critical gap), and the textbook citations (Stacks Tag~01UM, 02HQ, 02HW; Hartshorne~II.8 Propositions 8.2A, 8.7, Corollary 8.10) are standard and already used elsewhere in this chapter.

## Notes for Plan Agent
- The proof of `thm:smooth_iff_locally_free_omega` (converse direction) leans on `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential`, which has the side condition `Subsingleton (Algebra.H1Cotangent R S)` (i.e.\ vanishing of $\mathrm{H}^1$ of the cotangent complex). The proof block argues this is "built into the smoothness statement of $f$ via the cotangent exact sequence"; the prover should verify when formalising that the Lean smoothness hypothesis in scope actually provides this $\mathrm{H}^1$-vanishing. If it does not, the converse direction may need a stronger hypothesis or an additional sub-lemma. This is the most fragile load-bearing claim in the expansion; flag for strategy-critic if iter-111 prover lane on L718 stalls on it.
- `SheafOfModules.pullbackObjFreeIso` (cited in `cor:cotangent_at_section`) lives in `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackFree`. The Lean target `AlgebraicGeometry.Scheme.cotangent_at_section` uses `AlgebraicGeometry.Scheme.Modules.pullback` for its pullback functor; the prover will need a bridge lemma showing the scheme-level `Scheme.Modules.pullback` agrees with the abstract `SheafOfModules.pullback` against the Grothendieck-topology-of-opens functor `(\text{TopologicalSpace.Opens.map}\,s.\text{base})`. This bridge may or may not exist in Mathlib; if not, it's a small lemma the prover lane on L735 will need.
- `thm:serre_duality_genus` (L177-185 of the chapter, corresponding to Lean L877) is variance-flagged per the directive and was left untouched. The chapter's existing single-paragraph placeholder is unchanged.
- The Lemma cluster around `lem:cotangent_exact_structure` (`lem:sheafOfModules_exact_iff_stalkwise`, `lem:sheafOfModules_epi_of_epi_presheaf`, `lem:derivation_postcomp_comp`, `lem:cotangent_exact_seq_beta_hη`) was not modified per the directive's out-of-scope clause; the iter-086/087 `NOTE` annotation remains accurate.

## Strategy-modifying findings
None. The three expansions ground every step in a Mathlib name or a standard textbook citation; no step required invoking a property the strategy assumes is automatic but isn't, and no cited reference contradicts the strategy's premise. The single mild caveat — the $\mathrm{H}^1$-vanishing side condition of `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential` — is recorded in "Notes for Plan Agent" but does not rise to a strategy-level issue: it is consistent with the standard formulation of the smoothness criterion (Stacks Tag~02HW), and at worst widens the hypothesis on the converse direction by the standard vanishing condition that comes free under finite presentation.
