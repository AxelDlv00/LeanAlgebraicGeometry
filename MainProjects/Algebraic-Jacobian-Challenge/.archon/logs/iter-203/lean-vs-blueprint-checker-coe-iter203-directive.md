# Lean ↔ Blueprint Checker Directive

## Slug
coe-iter203

## Lean file
AlgebraicJacobian/Albanese/CodimOneExtension.lean

## Blueprint chapter
blueprint/src/chapters/Albanese_CodimOneExtension.tex

## Known issues
- The three remaining `sorry`s (the `isRegularLocalRing_stalk_of_smooth`
  chain / Stage 6.A capstone) are known-open and scope-fenced — flag only if
  the blueprint MIS-describes them, not for their mere existence.
- This iter added 4 axiom-clean substrate declarations for the Matsumura
  "linearly-independent cotangent classes ⟹ regular sequence" criterion
  (Step A1): `quotSMulTop_quotientRing_linearEquiv`,
  `isRegular_cons_of_quotient_ring`, `matsumura_descent_cotangent`,
  `matsumura_isRegular_of_linearIndependent_cotangent`. The prover reports
  these currently have NO `\lean{...}` pin in the chapter (the recipe lives in
  prose at `\subsec:stage6_iib_substrate_iter200`). Confirm whether that is
  so, and whether the prose recipe matches the landed signatures — this is a
  blueprint-adequacy question, report it under direction (B).
