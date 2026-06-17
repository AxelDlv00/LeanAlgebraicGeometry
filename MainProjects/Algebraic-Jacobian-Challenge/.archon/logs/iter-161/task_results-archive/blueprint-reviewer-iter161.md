# Blueprint Review Report

## Slug
iter161

## Iteration
161

## Top-level summaries

### Lean difficulty quality
- `AbelianVarietyRigidity.tex` / `\lean{...genusZero_curve_iso_P1}` and the headline chain:
  the `\lean` targets are well-typed and present in
  `AlgebraicJacobian/AbelianVarietyRigidity.lean`, but `genusZero_curve_iso_P1`
  (`prop:genusZero_curve_iso_P1`) is a Riemann–Roch-flavoured sub-build that Mathlib does not
  back (the chapter's own `rmk:genusZero_iso_subbuild` admits this). The hint is *correctly
  formulated* — not a poor target — but it is a large independent obligation, not a near-term
  prover lane. Informational, not blocking; flagged so the plan agent does not mistake the
  green build for "the genus-0 chain is one short hop from closure."

(All other summary sub-sections — Incomplete parts, Proofs lacking detail, Multi-route
coverage, Citation discipline — are empty and omitted.)

## Per-chapter

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - iter-160 must-fix #1 (signature under-specification) RESOLVED. The chapter prose now
    states `[LocallyOfFiniteType (X ⊗ Y).hom]` on the rigidity chain (statement blocks of
    `lem:rigidity_eqOn_dense_open`, `lem:rigidity_eqOn_saturated_open_to_affine`,
    `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`, plus `rmk:rigidity_lemma_decomposition`),
    and the now-false "[IsAlgClosed] is the only added instance" claim is explicitly retired in
    three places. Verified against the Lean file: all five chain theorems
    (`rigidity_lemma`, `rigidity_core`, `rigidity_eqOn_dense_open`,
    `rigidity_eqOn_saturated_open_to_affine`, `rigidity_eqAt_closedPoint_of_proper_into_affine`)
    carry both `[IsAlgClosed kbar]` and `[LocallyOfFiniteType (X ⊗ Y).hom]`.
  - iter-160 must-fix #2 (bridge-2 decomposition) RESOLVED. Two new well-formed blocks present:
    `lem:morphism_eq_of_eqAt_closedPoints` (`\lean{AlgebraicGeometry.morphism_eq_of_eqAt_closedPoints}`,
    project-bespoke, source lines correctly omitted, proof complete in Lean — no sorry) and
    `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`
    (`\lean{AlgebraicGeometry.rigidity_eqAt_closedPoint_of_proper_into_affine}`, the residual
    `sorry`, reusing the verbatim Mumford quote with matching `% SOURCE` / `% SOURCE QUOTE PROOF`
    / visible `\textit{Source:}`). Both `\lean` targets verified to exist with the stated
    signatures.
  - `\uses` graph FORWARD-ACYCLIC, no recurrence of the iter-160 backward 2-cycle:
    `thm:rigidity_lemma`(proof)→`lem:rigidity_eqOn_dense_open`(proof)→
    `lem:rigidity_eqOn_saturated_open_to_affine`(proof)→
    {`lem:morphism_eq_of_eqAt_closedPoints`, `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`}.
    The two new leaf lemmas carry NO `\uses` edge back up to `saturated_open`/`dense_open`.
    `thm:rigidity_lemma`'s proof retains its forward edge.
  - Step-1 (`rigidity_eqAt_closedPoint_of_proper_into_affine`) proof sketch is adequately
    detailed for a prover (cohomology-free route named explicitly:
    `isField_of_universallyClosed` + `finite_appTop_of_universallyClosed` +
    alg-closed collapse + `ext_of_isAffine`; residue field = k̄ via finite-type/alg-closed).
  - `thm:theorem_of_the_cube` is honestly a DEFERRED prerequisite with no Lean target; correctly
    marked, not claimed formalized. No false `\lean{}` hint. This is the chain's heavy un-built
    input and is documented as such.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Fallback-(a) artifact (still carries `[CharZero kbar]`), explicitly NOT the declaration the
    genus-0 witness consumes — consistent with `Jacobian.tex`/`AbelJacobi.tex`/
    `AbelianVarietyRigidity.tex`. `thm:rigidity_over_kbar` body is a gated `sorry`; the proof
    decomposition and the four-piece cotangent-vanishing pile are documented as a gated named
    gap, off the active critical path. Internally consistent after the iter-155 corrections
    (the earlier "chart-algebra avoids Serre duality / piece (iv) off critical path" claim is
    retracted throughout; `H^0(C,Ω)=0` is now correctly stated as on the route-(a) critical
    path for producing `df=0`). Citation discipline holds (Mumford / Stacks tags verified;
    iter-151 Stacks-tag typo fixes recorded in-prose).
  - Not on any active prover lane this iter, so no HARD-GATE consequence.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.
### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.
### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.
### blueprint/src/chapters/Genus.tex — complete + correct, no notes.
### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.
### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes (pointer chapter to RigidityKbar §Piece (i)).
### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes (genus carrier ships conditional under `HasCechToHModuleIso` + `HasAffineCechAcyclicCover`, honestly documented).

## Cross-chapter notes

- Genus-0 routing is consistent across all four chapters that mention it
  (`Jacobian.tex`, `AbelJacobi.tex`, `AbelianVarietyRigidity.tex`, `RigidityKbar.tex`):
  `thm:rigidity_genus0_curve_to_AV` (char-free, `AbelianVarietyRigidity.lean`) is the consumed
  keystone; `thm:rigidity_over_kbar` (`RigidityKbar.lean`, `[CharZero]`) is the retained
  fallback-(a) artifact. No contradiction; the import-cycle break
  (`AbelianVarietyRigidity` upstream of `Jacobian`) is documented identically in both ends.
- INFORMATIONAL (deterministic-sync domain, not a finding): the genus-0 chain's proof blocks
  (`prop:morphism_P1_to_AV_constant`, `prop:genusZero_curve_iso_P1`,
  `thm:rigidity_genus0_curve_to_AV`) carry proof-level `\leanok` while their Lean bodies are
  `sorry` (transitively gated on `theorem_of_the_cube` / the genusZero sub-build). `\leanok` is
  owned by the deterministic `sync_leanok` phase, not by any agent — it will be reconciled at
  the next sync. Surfaced only so the plan agent does not read the green build as "genus-0 chain
  proofs closed."

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

The single residual `sorry` on the active rigidity lane
(`AlgebraicGeometry.rigidity_eqAt_closedPoint_of_proper_into_affine`) sits behind a chapter that
is `complete: true` AND `correct: true` with both iter-160 must-fix items resolved and a
forward-acyclic `\uses` graph; a prover may be dispatched on it this iter. No chapter is
`partial | false` on either axis; no broken `\uses{}`; no citation-discipline finding on any
block feeding a prover lane.

Overall verdict: Whole blueprint is complete and correct; `AbelianVarietyRigidity.tex` cleanly
resolves both iter-160 must-fixes (finite-type hypothesis stated across all five chain lemmas;
two new well-formed sub-lemma blocks with existing `\lean{}` targets; forward-acyclic `\uses`
with no 2-cycle recurrence), and the HARD GATE clears for the active rigidity prover lane.
