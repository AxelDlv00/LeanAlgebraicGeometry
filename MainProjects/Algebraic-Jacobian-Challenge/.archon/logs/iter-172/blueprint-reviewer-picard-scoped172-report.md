# Blueprint Review Report

## Slug
picard-scoped172

## Iteration
172

## Mode

Scoped same-iter fast-path re-review (per blueprint-reviewer workflow). Target: `blueprint/src/chapters/Picard_RelativeSpec.tex` ONLY. The whole-blueprint dispatch this iter (`route172`) stands for every other chapter.

## HARD GATE: PASS

Lane B (file-skeleton scaffold for `AlgebraicJacobian/Picard/RelativeSpec.lean`) may be added to iter-172 `## Current Objectives`. See severity summary for the one residual citation-discipline TODO, which is `soon`-severity (does not gate the file-skeleton lane; should be filled before the implementation lane fires on `thm:relative_spec_univ`).

## Per-chapter

### blueprint/src/chapters/Picard_RelativeSpec.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All 6 expected declaration blocks present with the asked-for fields:
    - `def:qc_sheaf_of_algebras` → `\lean{AlgebraicGeometry.Scheme.QcohAlgebra}` (L41); `% SOURCE: ... (read from references/stacks-constructions.tex, L312-L318)`; `% SOURCE QUOTE:` (L46-L49); `\textit{Source: [Stacks Project], tag 01LL ...}` (L50). Verbatim quote matches source L312-317 character-for-character.
    - `thm:relative_spec_exists` → `\lean{...RelativeSpec}` (L71); `% SOURCE:` (L74) + `% SOURCE QUOTE:` (L75-97) + `\textit{Source:}` (L98); `% SOURCE QUOTE PROOF:` (L117-122) BEFORE `\begin{proof}`. Quote matches source L381-404 verbatim; proof-quote matches L407-414 verbatim.
    - `thm:relative_spec_univ` → `\lean{...RelativeSpec.UniversalProperty}` (L139); `% SOURCE:` (L141) + `% SOURCE QUOTE:` (L144-166) + `\textit{Source:}` (L167); proof quote is TODO (see below). Statement quote matches source L436-465 + L547-551 verbatim.
    - `thm:relative_spec_affine_base` → `\lean{...RelativeSpec.affine_base_iff}` (L212); `% SOURCE:` (L214) + `% SOURCE QUOTE:` (L217-220) + `\textit{Source:}` (L221); `% SOURCE QUOTE PROOF:` (L232-252) matches source L500-520 verbatim.
    - `thm:relative_spec_base_change` → `\lean{...RelativeSpec.base_change}` (L281); `% SOURCE:` (L283-285) + `% SOURCE QUOTE:` (L286-300) + `\textit{Source:}` (L301); `% SOURCE QUOTE PROOF:` (L312-317) matches source L483-488 verbatim.
    - `thm:relative_spec_functorial` → `\lean{...RelativeSpec.functor}` (L338); `% SOURCE:` (L340-342) + `% SOURCE QUOTE:` (L343-364) + `\textit{Source:}` (L365). Quote concatenates source L641-655 (definition-relative-spec) + L675-681 (lemma-spec-properties part 3) verbatim.
  - `% archon:covers AlgebraicJacobian/Picard/RelativeSpec.lean` declared at L3 — single-file mapping is correct.
  - Mathematical content faithfully reproduces Stacks tags 01LL/01LO/01LQ/01LR/01LS. Cross-references between the five theorems (`relative_spec_exists → relative_spec_univ → relative_spec_affine_base → relative_spec_base_change → relative_spec_functorial`) form a sound DAG with no `\uses{}` cycle.
  - `references/stacks-constructions.tex` exists on disk and the cited line ranges (L312-L318, L381-L405, L427-L466, L491-L545, L467-L489, L547-L551, L602-L691) are accurate (spot-verified against the local source).
  - Writer's `## References consulted` (in `task_results/blueprint-writer-route-a1-retry2.md`) lists exactly `references/stacks-constructions.tex` — matches every `% SOURCE: ... (read from references/...)` parenthetical in the chapter. No fabricated citations.
  - **Residual citation-discipline finding (soon-severity)**: the proof of `thm:relative_spec_univ` (L185-190) carries `% SOURCE QUOTE PROOF: TODO retrieve from references/stacks-constructions.tex (proof of lemma-spec, L553-L600, ~50 lines covering the Zariski sheaf property, the subfunctors $F_i$ associated to an affine cover, and identifying each $F_i$ with the affine-base case via lemma-spec-base-change and lemma-spec-affine). Verbatim quote omitted for length; the structural steps are restated below in project notation.` The proof prose IS a structural translation of source L553-599; per project rule "every reference must be local + verbatim", the TODO is non-compliant. Acceptable for the file-skeleton lane (which consumes signatures, not proof prose); **NOT** acceptable before the implementation lane fires on this proof — writer must return with the verbatim L553-599 quote before iter-173 implementation work begins on `RelativeSpec.UniversalProperty`'s body.
  - Minor (informational): the visible `\textit{Source: ...}` lines on `thm:relative_spec_exists`, `thm:relative_spec_univ`, and `thm:relative_spec_functorial` include a `cf.\ [Hartshorne], II~Ex.~5.17(a/b)` secondary pointer that does not appear in the `% SOURCE:` machine line. Writer is honest about this (their report explicitly says "I did NOT open Hartshorne... cited as a secondary `\textit{Source: ...}` pointer but NOT used as the verbatim-quote source"). Conventional `cf.` usage; not a fabrication. No action needed.

## Top-level summaries

### Citation discipline
- `Picard_RelativeSpec.tex` / `thm:relative_spec_univ` proof: `% SOURCE QUOTE PROOF: TODO` placeholder; writer must fill the verbatim L553-L599 quote from `references/stacks-constructions.tex` before the implementation lane fires on this proof (soon-severity; does NOT block file-skeleton Lane B).

## Severity summary

- **must-fix-this-iter**: none.
- **soon**: 1 citation-discipline finding — fill `% SOURCE QUOTE PROOF:` for `thm:relative_spec_univ` before iter-173 implementation lane.
- **informational**: 1 — `cf.\ [Hartshorne]` secondary pointer in three visible `\textit{Source:}` lines (no `% SOURCE:` mirror; honest disclosure in writer's report; no action).

Overall verdict: **HARD GATE PASS** — chapter is complete + correct + no must-fix-this-iter; planner may include `AlgebraicJacobian/Picard/RelativeSpec.lean` (file-skeleton scaffold) in iter-172 `## Current Objectives`. The single citation-discipline TODO on the multi-page `lemma-spec` proof is soon-severity and gates only the future implementation lane on that one body, not the skeleton lane.
