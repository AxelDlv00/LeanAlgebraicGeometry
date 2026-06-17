# lean-vs-blueprint-checker — AbelianVarietyRigidity, iter-158

Bidirectional verification of ONE Lean file against its blueprint chapter.

## Lean file
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/AbelianVarietyRigidity.lean`

## Blueprint chapter
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex`

## What to check

1. **Lean → blueprint.** Do the Lean signatures of `rigidity_lemma`, `rigidity_core`,
   `rigidity_eqOn_dense_open`, `snd_left_isClosedMap`, `morphism_P1_to_grpScheme_const`,
   `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme` match the corresponding
   blueprint statements (`thm:rigidity_lemma`, `lem:rigidity_eqOn_dense_open`,
   `prop:morphism_P1_to_AV_constant`, `prop:genusZero_curve_iso_P1`,
   `thm:rigidity_genus0_curve_to_AV`)? Flag fake/placeholder statements, signature mismatches.
2. **The collapse hypothesis `_hf`.** The blueprint (`lem:rigidity_eqOn_dense_open` and
   `rmk:rigidity_lemma_decomposition`) now explicitly insists the collapse hypothesis is
   load-bearing and must be threaded through all helpers. Verify the Lean actually carries and
   consumes `_hf` consistently with this prose.
3. **Stale review note.** The proof of `thm:rigidity_lemma` carries a `% NOTE (iter-157 review)`
   block asserting the Lean is UNSOUND because `_hf` was dropped. Determine whether that note is
   now STALE (i.e. the Lean has been repaired this iter and threads `_hf`). Report explicitly so
   the review agent can update the marker.
4. **blueprint → Lean.** Is any chapter block too thin to have guided the formalization, or does
   it overclaim what the Lean proves? The two `sorry`s in `rigidity_eqOn_dense_open` (`hfib`,
   agreement equation) — does the blueprint proof prose honestly cover these as the deferred
   geometric inputs?

Report bidirectionally with must-fix / major / minor severity. Write to your task_results file.
