# Lean audit — iter-057 prover-touched files

Audit the following three Lean files as Lean (no strategy bias). For each, produce the
per-file checklist (outdated comments, suspect/vacuous/fake definitions, dead-end proofs,
excuse-comments, bad practices) and a flagged-issues block.

Absolute paths to read:
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechAcyclic.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentification.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

Focus areas:
- New declarations added this iter; verify their statements are non-vacuous and the
  hypotheses are genuine (not trivially-satisfiable placeholders): in CechAcyclic.lean the
  `dDiff_exact_of_affineCover` / `sectionCech_homology_exact_of_affineCover` /
  `sectionCech_homology_exact_of_affineOpen` / `isLocalizedModule_baseChange_away` /
  `basicOpen_algMap_section` chain; in CechSectionIdentification.lean the `widePullback_openImm_inter`
  / `cechBackbone_obj_widePullback` / `coverArrowOverSigmaIso` (+ `coverArrowOverCofan`,
  `coverArrowOverIsColimit`, `mem_iInf_opens_of_finite`) chain; in OpenImmersionPushforward.lean
  the `pushforwardEquivOfIso` / `pushforwardExtAddEquiv` / `modulesIsoSpecExtTransport` chain.
- The remaining `sorry`s: CechAcyclic.lean:110 (dead `affine`), CechSectionIdentification.lean
  (5 stubs at ~189/239/330/424/481), OpenImmersionPushforward.lean (~373/439). Confirm each is an
  honest hole with a correctly-typed goal, NOT a papered/forced result.
- Any `set_option maxHeartbeats`/`synthInstance.maxHeartbeats` raises — flag if they mask a real
  problem vs. genuinely-needed.
- `letI`/`haveI` ad-hoc instance constructions in `sectionCech_homology_exact_of_affineOpen`
  (the `Algebra Γ(V) Γ(D a)` section-restriction instance) — confirm soundness.
