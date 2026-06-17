# Lean ↔ blueprint check — OpenImmersionPushforward.lean (iter-061)

## Lean file
`/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`

## Blueprint chapter
`/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(consolidated chapter; this file is one of its `% archon:covers` entries). Relevant labels:
`lem:pushforward_commutes_restriction`, `lem:pushforward_iso_preserves_qcoh`, and the leaf
`higherDirectImage_openImmersion_acyclic` with its two residual cases `hjt` (closed iter-060) and
`hqc` (still `sorry`), plus `higherDirectImage_openImmersion_comp` (`_comp`, still `sorry`).

## What to verify (bidirectional)
1. **Lean → blueprint:** the new decls `coversTop_preimage_of_iso` (private) and
   `pushforward_iso_qcoh_of_slice_qcoh` (non-private). Do they correspond to a blueprint statement?
   The prover suggests `pushforward_iso_qcoh_of_slice_qcoh` is the `of_coversTop`-reduction half of
   `lem:pushforward_iso_preserves_qcoh` (or a fresh feeding lemma). Confirm whether the blueprint
   already has a node for it or it is uncovered `lean_aux`.
2. **`hqc` residual honesty:** confirm the `case hqc => sorry` at ~line 588 is typed at the genuine
   goal `((pushforwardEquivOfIso U.isoSpec).functor.obj H).IsQuasicoherent` and not laundered.
3. **Blueprint adequacy:** the prover reports the genuine obstacle is a cross-ring slice presentation
   transport (~100–150 LOC, absent from Mathlib), and recommends a SIMPLER `pullback ψ_r` route than
   the blueprint's `pushforwardPushforwardEquivalence` recipe. Does the blueprint
   `lem:pushforward_iso_preserves_qcoh` reflect a feasible route, or is it prescribing the harder
   quadruple recipe? Report if the chapter should be updated to the simpler single-hom route.

## Output
Bidirectional report. Flag any must-fix-this-iter. Write to your task_results file.
