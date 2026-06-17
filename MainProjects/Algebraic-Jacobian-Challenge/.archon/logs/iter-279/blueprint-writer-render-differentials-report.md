# Rendering-cleanup report — `blueprint/src/chapters/Differentials.tex`

**Iteration 279 · slug `render-differentials` · NON-SEMANTIC pass**

## Summary
All literal `…~REF` placeholders eliminated (17 tokens across 11 lines — the directive
estimated "16", one more was present). Every replacement is a `\cref{<label>}` to a label
that exists live in this chapter. **No rewording was required**: although the iter-126 bridge
*declaration* was excised, the section that documents it (`\label{sec:bridge}`, "Standalone
K\"ahler-localization utilities (post-iter-126 M1 excise)") and the converse section
(`\label{sec:converse-out-of-scope}`) both still exist, so every dangling reference had a
correct live target.

No `math-delim`, `bare-label`, or `undefined-macro` defects were present in this chapter.

## Edits (line · defect class · before → after)
All `literal-ref`, all resolved by `\cref` (none by rewording):

| Line | Token | → target |
|------|-------|----------|
| 6  | `Section~REF` (standalone utilities) | `\cref{sec:bridge}` |
| 6  | `Section~REF` (converse documented separately) | `\cref{sec:converse-out-of-scope}` |
| 31 | `Section~REF` (bridge documented) | `\cref{sec:bridge}` |
| 42 | `Lemma~REF` (ring-level lemmas transfer) | `\cref{lem:relative_kaehler_presheaf_obj}` |
| 42 | `Section~REF` (the bridge) | `\cref{sec:bridge}` |
| 47 | `Section~REF` (sidestepping presheaf bridge) | `\cref{sec:bridge}` |
| 47 | `Section~REF` (converse is false; see) | `\cref{sec:converse-out-of-scope}` |
| 112 | `Definition~REF` (presheaf-form) | `\cref{def:relative_kaehler_presheaf}` |
| 112 | `Theorem~REF` (algebra-K\"ahler form on chart) | `\cref{thm:smooth_locally_free_omega}` |
| 112 | `Theorem~REF` (forward criterion closed iter-120) | `\cref{thm:smooth_locally_free_omega}` |
| 114 | `Lemma~REF` (M1.d PR candidate, "below") | `\cref{lem:kaehler_quotient_localization_iso}` |
| 145 | `Lemma~REF` (left term vanishes / subsingleton) | `\cref{lem:kaehler_localization_subsingleton}` |
| 150 | `Lemma~REF` (equivOfFormallyUnramified candidate) | `\cref{lem:kaehler_quotient_localization_iso}` |
| 182 | `Remark~REF` (counterexample) | `\cref{rem:converse_counterexample}` |
| 187 | `Remark~REF` (deformation-theoretic content) | `\cref{rem:converse_lemma_hypotheses}` |
| 187 | `Theorem~REF` (forward implication = easy direction) | `\cref{thm:smooth_locally_free_omega}` |
| 192 | `Section~REF` (M4 converse) | `\cref{sec:converse-out-of-scope}` |

### Resolution notes
- **Line 42 `Lemma~REF`** — directive's generic hint mapped all `Lemma~REF` to the
  K\"ahler-localization utility lemma, but in context this token ("all ring-level Mathlib
  lemmas about Ω_{B/A} transfer verbatim under Lemma~REF") is the *sections-identification*
  lemma `lem:relative_kaehler_presheaf_obj` — that is the lemma licensing the transfer.
  Resolved from sentence content, not the blanket hint.
- **Lines 145 vs 150 `Lemma~REF`** disambiguated within the same section: 145 (inside the
  proof of `lem:kaehler_quotient_localization_iso`, justifying the vanishing of a subsingleton
  term) → the subsingleton lemma `lem:kaehler_localization_subsingleton`; 150 (the PR-candidate
  remark naming `equivOfFormallyUnramified`) → `lem:kaehler_quotient_localization_iso` itself.

## Verification
- Re-grep for `(Section|Theorem|Lemma|Definition|Remark|Chapter)~REF` and `\S~REF`: **zero** remain.
- Every introduced `\cref{…}` label confirmed defined exactly once in the blueprint
  (`sec:bridge`, `sec:converse-out-of-scope`, `lem:relative_kaehler_presheaf_obj`,
  `def:relative_kaehler_presheaf`, `thm:smooth_locally_free_omega`,
  `lem:kaehler_quotient_localization_iso`, `lem:kaehler_localization_subsingleton`,
  `rem:converse_counterexample`, `rem:converse_lemma_hypotheses`).
- `\cref` already used across the blueprint (cleveref loaded), so no preamble change needed.
- No interleaved `$…\(` math delimiters present.
- Changed NO statement text, NO `\lean{}`, NO `\label{}`, NO `\uses{}`, NO `\leanok`/`\mathlibok`;
  no declaration blocks added/removed/reordered. All edits are in prose/proof/section-intro text.

## Unresolved defects
None.
