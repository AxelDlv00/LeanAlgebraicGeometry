# Directive: lean-auditor — iter-208 whole-project audit

## Files

Audit all `.lean` files under
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/`.

## Focus areas (do not let these bias a clean read of the rest)

- `Picard/TensorObjSubstrate.lean` received the only prover edit this iter: one
  new `refine ... .mapIso ?_` reduction step in `tensorObj_restrict_iso`
  (def ~L330, sorry body ~L399), plus a long in-code analysis comment. Verify
  the new step is genuine (not comment-laundering a still-`sorry` body) and the
  three named sorries (`tensorObj_restrict_iso` ~L399,
  `exists_tensorObj_inverse` ~L442, `addCommGroup_via_tensorObj` ~L481) are
  honestly labelled.
- Re-confirm the two long-standing held-lane placeholders flagged in prior audits
  (do NOT treat as new): `Picard/RelPicFunctor.lean` `PicSharp`/`functorial`
  placeholders; `Picard/IdentityComponent.lean` sanctioned-temporary sorry;
  `Genus0BaseObjects/BareScheme.lean` ~L220 sorry-instance. Report whether each
  is still present and still honestly annotated.

## What I need

Your standard per-file checklist (outdated comments, suspect defs, dead-end
proofs, bad Lean practice) plus a flagged-issues block separating NEW must-fix
findings from pre-existing/tracked ones. Pay attention to whether any comment in
the project claims a proof is closed/working when the body is `sorry`.

Write to `task_results/lean-auditor-iter208.md`.
