# Lean ↔ Blueprint Checker Directive

## Slug
cotangent-grpobj-review137

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex

(Note: the relevant § "Piece (i.b)" cross-chapter prose with statement +
proof outlines lives in `blueprint/src/chapters/RigidityKbar.tex`. Both
chapters should be read; the `\lean{...}` hints are in `RigidityKbar.tex`
for piece (i.b) declarations.)

## Known issues
- 2 sorries remain in this file (L508 = `_basechange_along_proj_two` Step 2,
  L635 = `mulRight_globalises_cotangent` Main). Both are iter-135 honest
  scaffolds with intended-type signatures. Verify the signatures still match
  blueprint pinning; do NOT re-flag the `sorry` bodies as fake placeholders
  (the sorry is on an honest scaffold, not a hollow `Nonempty (X ≅ X)` body).
- Iter-137 PARTIAL outcome on `_basechange_along_proj_two`. Docstring at
  L479–L499 updated to reflect the inverse-direction-via-adjunction analysis
  finding (see `task_results/Cotangent_GrpObj.lean.md` for the full prover
  narrative). Verify the docstring's prose is consistent with the still-sorry
  body and the blueprint's L362–L401 + iter-135 NOTE L452–L463 + iter-136
  NOTE L505–L518.
- Iter-135 NOTE-block in `RigidityKbar.tex` near `lem:GrpObj_omega_basechange_proj`
  statement (L452–L463) — known carry-over until Step 2 closes. Do NOT
  re-flag as must-fix.
- Iter-136 NOTE-block in `RigidityKbar.tex` near Step 3 prose (L505–L518) —
  known iter-135+iter-136 carry-over, do NOT re-flag.
- File-header line anchors in `Cotangent/GrpObj.lean` at L61/L107/L146/L155/L160
  are stale (~+12 drift since iter-136 baseline) — known carry-over, do NOT
  re-flag.
- Optional iter-136 MED-C carry-over (`% NOTE` near `RigidityKbar.tex:490`
  distinguishing `schemeHomRingCompatibility` from the `toRingCatSheafHom`-
  route): blueprint-reviewer-iter137 verdict ruled this DEFERRED-iter138+
  because covered in 3 other places. Do NOT re-flag as must-fix.

## Special instruction
Iter-137 was a **docstring-only PARTIAL session**: no code changes, no
signature changes, no new declarations. Body of `_basechange_along_proj_two`
unchanged from iter-135 honest-scaffold state. Audit accordingly — your
critical questions are:

1. Did the new docstrings introduce excuse-comments or false claims that
   the body is closer to closed than it really is?
2. Does the iter-137 inverse-direction analysis (docstring at L479–L499)
   accurately predict the iter-138+ closure path, or does it misrepresent
   the blueprint's prose?
3. Are the `\lean{...}` hints in `RigidityKbar.tex` still correctly pinned
   to the still-sorry signatures (no signature drift since iter-135)?
4. Blueprint adequacy: did the prover's inverse-direction-via-adjunction
   finding surface a blueprint-side prose gap that should be addressed by
   a future blueprint-writer dispatch?

## Report path
`.archon/task_results/lean-vs-blueprint-checker-cotangent-grpobj-review137.md`
