# Blueprint-reviewer directive — iter-260 (whole-blueprint audit + re-gate)

Perform your standard whole-blueprint per-chapter audit (completeness + correctness,
proof-sketch depth, well-formed Lean targets, broken `\uses{}`, unstarted-phase
proposals). Do NOT scope-limit — the cross-chapter view is the point.

## This iter's gate-relevant focus
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` was edited this iter by a
blueprint-writer (bw-tos260) + blueprint-clean (bc260) to fix a live MUST-FIX:

- The Sq2b paragraph of `lem:pullback_tensor_map_basechange` previously claimed (falsely)
  that the residual `pushforwardComp_lax_μ` closes "definitionally, exactly as the unit
  twin". The iter-259 prover empirically refuted this. The writer replaced it with an
  honest statement: the mate calculus (`pullbackComp_δ`) is proven and reduces Sq2b to ONE
  genuine residual `pushforwardComp_lax_μ` — the non-definitional "`pushforwardComp` is
  monoidal" `ModuleCat` change-of-rings coherence (~150 LOC; primitives
  `ModuleCat.restrictScalarsComp` / `extendScalarsComp` / `homEquiv_extendScalarsComp`).
- The `sliceDualTransport` / `dual_restrict_iso` section was recast as a route-(1) consumer
  of the now-green shared root `overEquivalence` (`restrictOverIso` / `unitOverIso`).

This consolidated chapter `% archon:covers` four files (`TensorObjSubstrate.lean`,
`StalkTensor.lean`, `Vestigial.lean`, `DualInverse.lean`). Its verdict gates prover
dispatch to `DualInverse.lean` (the iter-260 prover lane). Confirm whether
`Picard_TensorObjSubstrate.tex` is now `complete: true` AND `correct: true` with no
must-fix-this-iter finding — specifically whether the Sq2b correction is faithful and
whether the `dual_restrict_iso` route-(1) sketch is adequate to guide the prover.

Report per your standard format (per-chapter checklist + HARD GATE verdicts + any
unstarted-phase proposals).
