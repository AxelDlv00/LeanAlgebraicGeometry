# Blueprint-writer directive --- AbelianVarietyRigidity (iter-273 batch-2, DAG 1-to-1 coverage)

## Goal

Close the 1-to-1 Lean<->blueprint coverage debt for
`blueprint/src/chapters/AbelianVarietyRigidity.tex`: every uncovered helper decl below is proved
sorry-free in Lean but has NO blueprint entry. Add ONE `\lean{}`-pinned block per
decl and WIRE each into the chapter cone (no isolated nodes).

This chapter covers the rigidity theorem and genus-0 rational-map machinery (morphisms from rational/unirational varieties and from genus-0 curves into abelian varieties are constant; the bare-rigidity lemma and its supporting plumbing).

## Uncovered declarations (one block each; pin the EXACT name)

```
AlgebraicGeometry.iotaGm_chart1_composition_isOpenImmersion
AlgebraicGeometry.iotaGm_chart1_section
AlgebraicGeometry.iotaGm_inner_lift_compat
AlgebraicGeometry.iotaGm_isDominant
AlgebraicGeometry.iotaGm_isOpenImmersion
AlgebraicGeometry.iotaGm_r_1
AlgebraicGeometry.iotaGm_r_1_eq_specMap
AlgebraicGeometry.iotaGm_r_1_fac
AlgebraicGeometry.iotaGm_r_1_range_subset
AlgebraicGeometry.iotaGm_range_isOpen
AlgebraicGeometry.kbarChart1Ring
AlgebraicGeometry.kbarChart1Ring_specMap_fac
AlgebraicGeometry.morphism_P1_to_grpScheme_const_aux
AlgebraicGeometry.rigidity_core
AlgebraicGeometry.rigidity_snd_lift
AlgebraicGeometry.snd_left_isClosedMap
```

## How to write each block

1. Read the Lean file(s) for exact signatures (do not guess from names):
   - `AlgebraicJacobian/AbelianVarietyRigidity.lean`
   - `AlgebraicJacobian/RigidityLemma.lean`
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
   keep each `\uses{}` on a SINGLE line. End state: the chapter's rigidity theorems (e.g. the rational-map-to-AV-extends / Mor(P^1,A)-constant results) and the genus-0 witness. transitively
   `\uses{}` every new helper; zero isolated nodes
   (`leandag query --isolated --chapter AbelianVarietyRigidity` must return none).
4. Replace any literal "Theorem~REF"/"Lemma~REF"/etc. in RENDERED prose with a
   real `\cref{}`; leave verbatim `% SOURCE QUOTE` comment text untouched.

## Hard constraints

- Edit ONLY `blueprint/src/chapters/AbelianVarietyRigidity.tex`. Never add `\leanok`. No broken
  `\uses{}`. Additive coverage + REF cleanup only.

## Report

Blocks added (label + `\lean{}`), statement-level `\uses{}` edges added, REF
fixes, and any decl whose intent you could not determine (flag, don't fabricate).
