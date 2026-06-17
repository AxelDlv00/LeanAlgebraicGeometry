# Lean ↔ Blueprint Checker Directive

## Slug
cotangent-grpobj-review133

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex

The `Cotangent/GrpObj.lean` declarations are documented in § Piece (i) (specifically § Piece (i.a) for `cotangentSpaceAtIdentity` + `cotangentSpaceAtIdentity_eq_extendScalars` + `cotangentSpaceAtIdentity_finrank_eq`) of `RigidityKbar.tex`. The chapter went 324 → 511 LOC in iter-133 via `blueprint-writer-rigiditykbar-piecei-iterb-prep-iter133`.

## Known issues
- Iter-132's `lean-vs-blueprint-checker-cotangent-grpobj-review132` flagged MED-B (no `\lean{cotangentSpaceAtIdentity_eq_extendScalars}` block) + MED-C (rewrite-pattern paragraph drift) — both ABSORBED iter-133 via the blueprint-writer; verify the absorptions landed cleanly.
- Iter-133 added two new helper sub-lemmas (`lem:GrpObj_omega_basechange_proj` and `lem:GrpObj_omega_restrict_to_identity_section`), both marked `\notready` because the Lean declarations don't yet exist; flag as INFO only (these are deliberately deferred to iter-134+).
- `lem:GrpObj_mulRight_globalises` was hardened with signature stub + 3-step proof prose; the underlying Lean declaration `mulRight_globalises_cotangent` does not yet exist (deliberately deferred to iter-134+ prover lane); flag as INFO only.
- The blueprint chapter file `AlgebraicJacobian_Cotangent_GrpObj.tex` does NOT exist (verified iter-132); the slug-mapping is `Cotangent/GrpObj.lean → RigidityKbar.tex` § Piece (i). This is intentional; do not flag.
