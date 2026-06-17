# Blueprint-writer directive --- Picard_QuotScheme (iter-273 batch-2, DAG 1-to-1 coverage)

## Goal

Close the 1-to-1 Lean<->blueprint coverage debt for
`blueprint/src/chapters/Picard_QuotScheme.tex`: every uncovered helper decl below is proved
sorry-free in Lean but has NO blueprint entry. Add ONE `\lean{}`-pinned block per
decl and WIRE each into the chapter cone (no isolated nodes).

This chapter covers the Quot-scheme representability engine (RR-free): boundedness, valuative-criterion, reduction-to-pi_*W, and base-map helpers behind quot representability.

## Uncovered declarations (one block each; pin the EXACT name)

```
AlgebraicGeometry.canonicalBaseChangeMap_app_app_isIso_of_affineCover
AlgebraicGeometry.canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen
AlgebraicGeometry.canonicalBaseChangeMap_app_app_isIso_of_isAffineOpen_of_isAffineBase
AlgebraicGeometry.pullback_app_isoTensor_baseMap
AlgebraicGeometry.pullback_app_isoTensor_baseMap_isBaseChange
AlgebraicGeometry.pullback_app_isoTensor_isBaseChange
AlgebraicGeometry.pullback_app_isoTensor_unitAtV
AlgebraicGeometry.pushforward_pullback_section_eq_pullback_section
```

## How to write each block

1. Read the Lean file(s) for exact signatures (do not guess from names):
   - `AlgebraicJacobian/Picard/QuotScheme.lean`
2. Add `\begin{lemma}`/`\begin{definition}` (theorem only for headline) with a
   `\label{}`, a single `\lean{<exact name>}` (pinned exactly once project-wide),
   a 1--3 sentence prose statement (NO Lean syntax), and a
   `\begin{proof} Proved directly in Lean. \end{proof}` body. Internal helpers
   need no external `% SOURCE`; if one literally restates a Mathlib result, make
   it a `\mathlibok` anchor pinned to the real Mathlib name instead.
3. **WIRING (critical, and note this leandag quirk):** leandag builds edges ONLY
   from **statement-level** `\uses{}` (the `\uses{}` placed in the
   `\begin{lemma}...` statement, BEFORE `\begin{proof}`). A `\uses{}` written
   *inside* a `\begin{proof}` block does NOT create a graph edge. Therefore wire
   every new helper by adding its label to a **statement-level** `\uses{}` of the
   already-blueprinted result whose Lean proof calls it (preferred), or give the
   helper its own statement-level `\uses{}` to the sub-lemmas it depends on. Also
   keep each `\uses{}` on a SINGLE line. End state: the chapter's Quot representability results (\cref{thm:quot_representable} and its supporting lemmas). transitively
   `\uses{}` every new helper; zero isolated nodes
   (`leandag query --isolated --chapter Picard_QuotScheme` must return none).
4. Replace any literal "Theorem~REF"/"Lemma~REF"/etc. in RENDERED prose with a
   real `\cref{}`; leave verbatim `% SOURCE QUOTE` comment text untouched.

## Hard constraints

- Edit ONLY `blueprint/src/chapters/Picard_QuotScheme.tex`. Never add `\leanok`. No broken
  `\uses{}`. Additive coverage + REF cleanup only.

## Report

Blocks added (label + `\lean{}`), statement-level `\uses{}` edges added, REF
fixes, and any decl whose intent you could not determine (flag, don't fabricate).
