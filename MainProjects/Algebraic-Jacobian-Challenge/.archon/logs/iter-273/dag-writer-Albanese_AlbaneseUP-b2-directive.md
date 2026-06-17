# Blueprint-writer directive --- Albanese_AlbaneseUP (iter-273 batch-2, DAG 1-to-1 coverage)

## Goal

Close the 1-to-1 Lean<->blueprint coverage debt for
`blueprint/src/chapters/Albanese_AlbaneseUP.tex`: every uncovered helper decl below is proved
sorry-free in Lean but has NO blueprint entry. Add ONE `\lean{}`-pinned block per
decl and WIRE each into the chapter cone (no isolated nodes).

This chapter covers the Albanese universal property of Pic^0/the Jacobian (Route-1, RR-free): the universal map and its uniqueness/factorisation helpers.

## Uncovered declarations (one block each; pin the EXACT name)

```
AlgebraicGeometry.Pic0.Bundle
AlgebraicGeometry.Pic0.albanese_eq_iff_symmetricPower_eq
AlgebraicGeometry.Pic0.bundle
AlgebraicGeometry.Pic0.jacobianScheme
AlgebraicGeometry.Pic0.jacobianScheme_geomIrred
AlgebraicGeometry.Pic0.jacobianScheme_grpObj
AlgebraicGeometry.Pic0.jacobianScheme_isProper
AlgebraicGeometry.Pic0.jacobianScheme_smooth
```

## How to write each block

1. Read the Lean file(s) for exact signatures (do not guess from names):
   - `AlgebraicJacobian/Albanese/AlbaneseUP.lean`
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
   keep each `\uses{}` on a SINGLE line. End state: the chapter's albanese universal-property theorem (\cref{thm:albanese_universal_property}). transitively
   `\uses{}` every new helper; zero isolated nodes
   (`leandag query --isolated --chapter Albanese_AlbaneseUP` must return none).
4. Replace any literal "Theorem~REF"/"Lemma~REF"/etc. in RENDERED prose with a
   real `\cref{}`; leave verbatim `% SOURCE QUOTE` comment text untouched.

## Hard constraints

- Edit ONLY `blueprint/src/chapters/Albanese_AlbaneseUP.tex`. Never add `\leanok`. No broken
  `\uses{}`. Additive coverage + REF cleanup only.

## Report

Blocks added (label + `\lean{}`), statement-level `\uses{}` edges added, REF
fixes, and any decl whose intent you could not determine (flag, don't fabricate).
