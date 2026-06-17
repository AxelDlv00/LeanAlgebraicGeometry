# Lean ↔ blueprint check — TildeExactness.lean (iter-034)

Lean file: /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/TildeExactness.lean
Blueprint chapter: /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; the relevant block is `lem:tilde_preserves_kernels` and its sub-steps)

This iter the prover added 2 declarations (both axiom-clean, no sorry):
- `tilde_stalkFunctor_map_toStalk` — germ-naturality transport identity
- `tildePreservesFiniteLimits_of_toPresheaf` — categorical reduction of the named target
The named target `tildePreservesFiniteLimits` is intentionally ABSENT (no sorry, real geometry gap remains).

Verify bidirectionally:
- Lean → blueprint: both new decls currently have NO blueprint block (they appear as `unmatched`/`lean_aux`).
  Confirm they are genuine (non-vacuous, real proofs) and report that they need blueprint entries (the
  planner must add them — natural home is sub-steps under `lem:tilde_preserves_kernels`). Check the named
  target's absence is honestly documented in the blueprint (no false `\leanok`, a `% NOTE` if appropriate).
- Blueprint → Lean: is `lem:tilde_preserves_kernels` detailed enough to guide the remaining build (the
  R-linearity-of-stalk-map + jointly-reflecting-stalks assembly)?

Report must-fix-this-iter findings explicitly if any.
