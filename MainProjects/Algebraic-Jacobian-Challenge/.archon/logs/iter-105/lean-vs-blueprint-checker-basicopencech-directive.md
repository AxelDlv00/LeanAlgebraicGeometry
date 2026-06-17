# Lean ↔ Blueprint Checker Directive

## Slug
basicopencech

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/BasicOpenCech.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Known issues
- 6 syntactic sorries currently in BasicOpenCech.lean at L1120, L1212, L1536, L1564, L1754, L1783. The L1120 sorry is the active prover target this iter inside `cechCofaceMap_pi_smul`'s per-summand `hG` discharge. Others are long-standing deferred substeps (augmented Čech / s₀ extra-degeneracy / `g_R.map_smul'` / `h_loc_exact`). Do not flag these sorries themselves; flag only if the blueprint chapter contradicts what the Lean is doing or if blueprint adequacy is insufficient.
- Iter-105 plan-phase dispatched a blueprint-writer (`mv-fix` slug) to fix a broken `\uses{def:Scheme_HModule_eq_HModule_prime_linearEquiv}` reference; verify that fix landed.
- New top-level helpers from iter-104/105: `cechCofaceMap_summand_family` (L454+), `cechCofaceMap_summand_family_R_linear` (L494+), `cechCofaceMap_summand_family'` (wrapper, L604+), `cechCofaceMap_summand_family'_R_linear` (wrapper R-linearity, L634+). These are project-local; check if they map cleanly to blueprint declarations OR are properly identified as helpers.
