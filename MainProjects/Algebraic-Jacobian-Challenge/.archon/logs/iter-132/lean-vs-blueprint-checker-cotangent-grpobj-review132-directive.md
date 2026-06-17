# Lean ↔ Blueprint Checker Directive

## Slug
cotangent-grpobj-review132

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/GrpObj.lean

## Blueprint chapter
blueprint/src/chapters/RigidityKbar.tex

## Known issues
- The Lean file is `Cotangent/GrpObj.lean` but the corresponding
  blueprint content is organised as **§ Piece (i.a) of
  `RigidityKbar.tex`** (lemmas `lem:GrpObj_cotangentSpace`,
  `lem:GrpObj_cotangent_bridge`, `lem:GrpObj_lieAlgebra_finrank`,
  plus surrounding piece-(i) prose). There is intentionally NO
  `AlgebraicJacobian_Cotangent_GrpObj.tex` chapter; report whether
  this naming asymmetry is causing tooling confusion (the prover
  surfaced this; iter-132 task result has a flag in
  `.archon/task_results/AlgebraicJacobian_Cotangent_GrpObj.lean.md`).
- `lem:GrpObj_cotangent_bridge`, `lem:GrpObj_mulRight_globalises`,
  `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim` carry
  `\notready` — intentional iter-132+ deferrals. Do not flag.
- `cotangentSpaceAtIdentity` body uses a `Classical.choose`-chain via
  `let`-bindings. This is iter-131's deliberate structural shape;
  not a suspect body.
- Iter-132 added a new theorem `cotangentSpaceAtIdentity_finrank_eq`
  (lines 244-282). Verify the rank lemma statement matches the
  blueprint's `lem:GrpObj_lieAlgebra_finrank` (note: blueprint name
  uses legacy `lieAlgebra` slug; Lean uses
  `cotangentSpaceAtIdentity_finrank_eq`). Check whether this rename
  drift should be flagged or whether the chapter's `\lean{...}` hint
  already points to the new Lean name.

## Report path
.archon/task_results/lean-vs-blueprint-checker-cotangent-grpobj-review132.md
