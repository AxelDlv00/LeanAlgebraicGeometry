# Lean Auditor Directive

## Slug
iter056

## Files to audit (modified this iteration)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

## Focus areas
- AffineSerreVanishing.lean: 7 declarations were added near the end of the file
  (`isAffineOpen_specBasicOpen`, `standard_cover_cofinal_affine`, `affine_surj_of_vanishing_affine`,
  `affineCoverSystemGeneral`, `affine_cech_vanishing_qcoh_general_of_tildeVanishing`,
  `affine_serre_vanishing_general_of_seed`, `affine_serre_vanishing_general_of_tildeVanishing`).
  Several carry residuals as explicit hypotheses (`hseed` / `htilde`) rather than `sorry`. Verify
  these hypotheses are genuine, non-vacuous, and not silently false; verify no `set_option
  maxHeartbeats` masks a real problem; verify the `BasisCovSystem` structure literal fields are sound
  (especially that the `Cov` set carries its covering/affineness condition).
- CechSectionIdentification.lean: this file carries 5 `sorry` scaffold stubs. One declaration
  (`pushPull_leg_sections`) was completed this iter. A large `⚠ PROVER FINDING` NOTE block was added
  above the Stub 5 region claiming Stubs 5 and 6 are "provably false as written". Scrutinize that
  claim — is the counterexample (one-member cover gives H⁰ = Fp(V) ≠ 0) actually airtight, or is it
  an excuse-comment masking a route the prover simply could not complete? Also check whether any
  reverted-but-leftover scratch declarations remain.

## Read paths
Both absolute paths above. Read the full files.
