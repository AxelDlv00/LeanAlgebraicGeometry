# Lean ↔ Blueprint Checker Directive

## Slug
rigiditykbar-iter127

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RigidityKbar.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RigidityKbar.tex

## Known issues
- `RigidityKbar.lean:87` `rigidity_over_kbar` body is a single `sorry` — recognized iter-126 scaffold. Do not flag as must-fix.
- The Lean file was NOT modified this iter; the blueprint was substantially extended this iter by `blueprint-writer-rigiditykbar-piece-i-iter127` (+101 lines, adding 5 lemma blocks + 1 remark for piece (i) sub-decomposition), AND the chapter introduction was rewritten by the plan-agent for the iter-127 over-k commitment. The newly-added lemma blocks (`lem:GrpObj_lieAlgebra`, `lem:GrpObj_lieAlgebra_finrank`, `lem:GrpObj_mulRight_globalises`, `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`) reference Lean targets that DO NOT YET EXIST in the project — those are iter-128+ targets. Flag the missing `\lean{...}` resolutions as **informational** (not must-fix), but do verify the chapter's existing `\lean{rigidity_over_kbar}` block still aligns with the actual Lean declaration.
- The iter-127 inline chapter intro now describes the over-k variant (vs the prior over-`k̄` framing); confirm the Lean declaration `rigidity_over_kbar` signature (still `[Field kbar]`-parameterised) is consistent with the new prose framing.
