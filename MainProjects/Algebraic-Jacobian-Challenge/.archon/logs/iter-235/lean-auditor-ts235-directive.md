# lean-auditor directive — iter-235

## Files to audit

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`

## Focus

This file received prover work this iteration: ~10 new `private` declarations forming a
nested double-colimit "reverse map" descent (`revInnerLeg`, `revInnerLeg_apply`, `revInner`,
`germ_revInner`, `revInner_germ`, `revOuterLeg`, `revOuterLeg_apply`, `revBihom`,
`germ_revBihom`, `revBihom_germ_tmul`), appended after the existing forward-map block
(`stalkTensorDesc`, `stalkTensorLinearMap`, etc.).

Audit as Lean, with no bias toward what the construction "should" prove. Pay attention to:

- Whether the new `private` definitions are genuine (non-vacuous) constructions or
  degenerate/trivial stand-ins (e.g. a `colimit.desc` whose cocone is trivial, an
  additive map that collapses to zero, a `germ` characterization that is vacuously `rfl`).
- Whether the cocone-naturality sub-proofs actually discharge their goals or lean on
  `erw`/`congr 1`/`sorry`-adjacent escape hatches that mask an unproven equality.
- Any `sorry`, `admit`, `native_decide`, or new `axiom`.
- Outdated comments, dead code, or in-file handoff comments that describe a gap as
  "remaining" — confirm the file genuinely has 0 sorries (there is a large comment block
  near the end describing a `revBihom_balanced` gap that was intentionally NOT added as a
  decl; confirm it is a comment, not a stubbed decl).
- Bad Lean practices (excessive `erw`, fragile `ConcreteCategory.hom`/`restrictScalars`
  coercions) that a future consumer would trip over.

Report per-file checklist + flagged-issues block with severity.
