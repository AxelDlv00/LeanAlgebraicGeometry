# Lean audit — iter-034 prover-touched files

Audit the following two Lean files as Lean code (outdated comments, suspect
definitions, dead-end proofs, bad practices, vacuous/over-general statements,
universe/heartbeat smells, anything misleading):

- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/TildeExactness.lean

Focus areas:
- AffineSerreVanishing: a 4-decl chain was just added (`toSheaf_preservesFiniteColimits`,
  `toSheaf_preservesEpimorphisms`, `affine_surj_of_vanishing`, `affineCoverSystem`). Check the
  `affineCoverSystem.Cov` definition: the prover notes it is ALL finite basic-open families
  (does NOT encode the covering condition `D f = ⨆ D(gᵢ)`), with the covering property established
  inside `affine_surj_of_vanishing` instead. Assess whether this is sound or smuggles vacuity.
  Check the `set_option maxHeartbeats 2000000` usages are genuine perf needs, not masking a problem.
- TildeExactness: 2 decls added (`tilde_stalkFunctor_map_toStalk`, `tildePreservesFiniteLimits_of_toPresheaf`);
  named target `tildePreservesFiniteLimits` intentionally absent (no sorry). Verify the module docstring
  is accurate (it was rewritten this iter to retract a prior false "obstruction 2" claim). Check the
  germ-naturality identity is non-vacuous and the categorical reduction is genuine.

Report a per-file checklist plus flagged issues with severity.
