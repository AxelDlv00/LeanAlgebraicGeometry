# Lean ↔ Blueprint Checker Directive

## Slug
cotangent-grpobj-review136

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex

## Known issues (do not re-report)
- Iter-135 lean-vs-blueprint-checker MED-C noted partial L61/L107/L146/L155/L160 file-header line-anchor de-pinning in `Cotangent/GrpObj.lean` docstrings. That is a deferred minor; reflag only if you see new such drift introduced this iter.
- The pointer chapter `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` exists alongside `RigidityKbar.tex` as the per-Lean-file pointer; do not audit it here (that is the blueprint-reviewer's scope).
- The two sibling lemmas in this file with `sorry` bodies are intentional iter-137+ work: `relativeDifferentialsPresheaf_basechange_along_proj_two` at L480 (`lem:GrpObj_omega_basechange_proj`) and `mulRight_globalises_cotangent` at L599 (`lem:GrpObj_mulRight_globalises`). Their blueprint blocks carry `\notready` markers; that is correct.

## What changed this iter (for context)
The iter-136 prover lane substantively closed `relativeDifferentialsPresheaf_restrict_along_identity_section` at L508 (`lem:GrpObj_omega_restrict_to_identity_section`, blueprint L484), using `PresheafOfModules.pullbackComp` twice plus a new private helper `section_snd_eq_identity_struct` (L452) for the underlying scheme-morphism identity `s.left ≫ pr_2.left = G.hom ≫ η[G].left`. Body verifies kernel-only via `lean_verify`. Please confirm:
- Does the Lean body match the blueprint's proof sketch at L522–526?
- Is the blueprint statement at L515 still marked `\notready` even though the Lean body is now closed? (The review agent will fix the marker; flag for the record.)
- Is the new private helper `section_snd_eq_identity_struct` reasonable as an unannounced helper, or should the blueprint name it explicitly?
- Are the chapter's `\lean{...}` macros, line-anchors, and `% NOTE iter-135:` comments still accurate now that the Lean body has been closed?
