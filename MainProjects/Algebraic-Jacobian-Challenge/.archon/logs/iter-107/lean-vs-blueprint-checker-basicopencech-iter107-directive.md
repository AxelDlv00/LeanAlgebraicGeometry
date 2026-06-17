# Lean ↔ Blueprint Checker Directive

## Slug

basicopencech-iter107

## Lean file

/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cohomology/BasicOpenCech.lean

## Blueprint chapter

/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Cohomology_MayerVietoris.tex

## Known issues (do not re-report)

- The four-step proof sketch at L1162–L1170 of `Cohomology_MayerVietoris.tex` does not yet preview the Mathlib API used at iter-108's geometric setup (`Scheme.basicOpen_res`, `IsAffineOpen.isLocalization_of_eq_basicOpen`, `IsLocalizedModule.pi`). Iter-106 checker noted this as a "soon" carry-over and PASS. Treat that as the prior status.
- The named-family + R-linearity engine (iter-104/105) and the `h_loc_exact` partial proof are intentionally unreferenced helpers — do not flag those as "missing from blueprint" unless it has hardened to blocking level this iter.
- `cechCofaceMap_pi_smul` at L1120 is PAUSED (sunk-cost decision); the partial-proof scaffold is preserved intentionally. Do not re-flag the L1120 sorry as a "blueprint inadequacy" if the chapter's high-level sketch still covers the route.
- `L1212` augmented Čech sorry, `L1536` `K→K₀` transport sorry, `L1564` substep (a) for `s₀`, and `L1754` `g_R.map_smul'` are all long-standing transient sorries. Note only if newly suspect.

## What changed this iter

The prover added ~40 LOC of inline scaffolding inside `h_loc_exact` at L1796–L1834: three `have`s named `h_pi_eq_inf'`, `h_V_affine`, `h_isLoc`. The trailing sorry shifted from L1802 to L1846. Verify whether the blueprint sketch at `Cohomology_MayerVietoris.tex` § Čech-acyclicity covers the path the inline scaffolding takes (per-coord `IsLocalization.Away` via `IsAffineOpen.isLocalization_of_eq_basicOpen` + image-Finset bridging via `Finset.inf'`). If the chapter still does not preview this micro-step at the level the prover needed, flag as a blueprint-adequacy "soon" or "must-fix" depending on whether the prover would have benefited from a more detailed sketch.
