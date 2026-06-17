# Blueprint Reviewer Directive — fast-path scoped re-review

## Slug
av-rigidity-fastpath

This is a HARD-GATE fast-path re-review (same iter as a writer round). You still read the
whole blueprint, but the verdict that matters this round is on the two chapters edited this
iter. Produce your per-chapter checklist (complete? correct? Lean targets well-formed? proofs
detailed enough? broken `\uses`/`\cref`?) and an explicit HARD-GATE line for each.

## Primary gate target — `blueprint/src/chapters/AbelianVarietyRigidity.tex` (NEW this iter)
This new chapter is the committed genus-0 route (c) and the home of the iter-158 prover lane
target. It declares `% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean` (a NEW
Lean file scaffolded this iter — `lake build` is GREEN with the four declarations as `sorry`).
Judge specifically:
- **Is `thm:rigidity_lemma` (`\lean{AlgebraicGeometry.rigidity_lemma}`) prover-ready?** It is
  the cube-free entry the iter-158 prover will attempt. The chapter gives Mumford's verbatim
  statement + a full prose proof (Form I, properness/closed-map argument). Confirm the proof is
  detailed enough to formalize and that the `\lean{}` target resolves to the scaffolded decl.
- Are the other three blocks (`thm:theorem_of_the_cube` — deferred deep input, no Lean target;
  `prop:morphism_P1_to_AV_constant` — blocked on the cube; `prop:genusZero_curve_iso_P1` —
  blocked on Riemann–Roch) HONESTLY scoped as deferred/blocked, with correct `\uses` edges?
- Citation discipline: each block has `% SOURCE` + verbatim `% SOURCE QUOTE` read from the
  scanned Mumford/Hartshorne/Milne PDFs. Confirm the four-element discipline is intact.
- Does `thm:rigidity_genus0_curve_to_AV` correctly describe the char-free headline that
  `genusZeroWitness` consumes (signature = `rigidity_over_kbar` minus `[CharZero]`)?

## Secondary — `blueprint/src/chapters/Jacobian.tex` (route-(c) blocks stripped this iter)
The duplicate route-(c) subsection was deleted; its crefs were redirected to the new chapter;
the iter-155/156 carry-over NOTE corrections (uniqueness epi-cancellation; C.2.f descent
re-cost; import-cycle honesty) were landed and the stale `% NOTE:` blocks removed. Confirm:
- No broken `\cref`/`\uses` (no surviving reference to the deleted labels
  `lem:rigidity_theorem`, `cor:complete_product_to_AV_decomp`, `lem:rational_map_to_AV_extends`,
  `prop:unirational_to_AV_constant`; the duplicate `thm:theorem_of_the_cube` /
  `prop:rigidity_genus0_curve_to_AV` now live only in the new chapter).
- The genus-0 prose now consumes the upstream `thm:rigidity_genus0_curve_to_AV`, not
  `rigidity_over_kbar`.
- Whether Jacobian.tex is now `complete`/`correct` enough that its remaining `partial` (Route A
  positive-genus sketch-level) is the ONLY residual — i.e. the genus-0 arm's blueprint is no
  longer the blocker.

## Also confirm (doctor follow-ups)
- `RigidityKbar.tex` `% archon:covers` now uses full repo-root paths
  (`AlgebraicJacobian/RigidityKbar.lean`, `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`).
- `RigidityKbar.tex` carries an iter-157 STRATEGY NOTE redirecting the committed route to the
  new chapter (reframing itself as the fallback-(a) home) — confirm the route-mismatch the
  iter157 review flagged is resolved.

## Output
Per-chapter checklist + HARD-GATE line per chapter. Be explicit whether
`AbelianVarietyRigidity.tex` is `complete: true` + `correct: true` with no must-fix (which
would clear the gate for an iter-158 prover lane on `rigidity_lemma`). Write to your
`task_results/` report.
