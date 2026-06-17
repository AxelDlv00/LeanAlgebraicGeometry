# Lean Auditor Directive

## Slug
iter106

## Scope (files)
all

## Focus areas (optional)
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` — received prover work this iter (h_loc_exact partial-proof inline at L1781-L1802; geometric scaffolding lemmas h_V_le_U / h_slice_eq plus trailing sorry).
- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` and `AlgebraicJacobian/Rigidity.lean` — iter108-cleanup refactor replaced stale `## Status` blocks. Verify the new docstrings accurately describe state.
- `AlgebraicJacobian/Picard/LineBundle.lean` and `AlgebraicJacobian/Modules/Monoidal.lean` — items flagged CRITICAL in your prior `iter105` report (weakened-wrong `LineBundle` def; `instIsMonoidal_W := sorry`). Re-flag if still present.

## Known issues
- The previous `lean-auditor-iter105` report already flagged: (1) `LineBundle.lean:85-86` weakened-wrong def; (2) `Modules/Monoidal.lean:166-173` `instIsMonoidal_W := sorry`; (3) `StructureSheafModuleK.lean:27-31` stale Status block; (4) `Rigidity.lean:19-23` stale Status block. Items (3) and (4) were addressed by the `iter108-cleanup` refactor this iter; items (1) and (2) are deferred Phase C0/C1 structural work, but if you still see them they should remain on the must-fix list with severity unchanged — do not soften.
- No need to re-report the L1120 cechCofaceMap_pi_smul partial-proof scaffold or the L1802 h_loc_exact partial-proof scaffold UNLESS you find them mathematically wrong as Lean (excuse-comments, dead-end constructions). They are intentional, plan-agent-blessed work in progress.
