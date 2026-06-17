# Blueprint-Reviewer Directive — iter-036

Perform your standard WHOLE-blueprint audit (all chapters under
`blueprint/src/chapters/`). Per-chapter completeness + correctness checklist, plus the
unstarted-phase proposals section.

## Context for the HARD GATE (files under active/candidate prover work this iter)
- `AlgebraicJacobian/Cohomology/TildeExactness.lean` — continuation lane (build
  `tildePreservesFiniteLimits`, 01I8 step P3). Backed by
  `Cohomology_CechHigherDirectImage.tex`, block `lem:tilde_preserves_kernels`. This block was
  fast-path re-reviewed and cleared iter-035; the iter-035 prover added 4 helpers realizing
  its sub-step (A). I need to know if the proof sketch for the REMAINING build (sub-steps
  B/C: jointly-reflecting stalk assembly → `tildePreservesFiniteLimits`) is detailed enough
  to dispatch a prover, OR whether it needs a writer pass first. NOTE: the planner has found
  that `SheafOfModules.toSheaf` exists in Mathlib (the sketch's "no toSheaf" obstruction is
  false); if the sketch hardcodes that obstruction, flag it for rewrite.
- `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` — backed by the same chapter,
  blocks `lem:modules_restrict_basicOpen` (L1, done), `lem:tilde_restrict_basicOpen` (L2,
  blocked), `lem:presentation_restrict_basicOpen` (L3). May be PAUSED this iter pending a
  route re-mapping; still audit the chapter blocks for completeness/correctness.

## Specific things to check
1. Whether `lem:tilde_preserves_kernels`'s proof sketch is dispatchable for the remaining
   build, and whether it encodes the now-false "`Scheme.Modules.toSheaf` does not exist"
   obstruction that should be corrected to `SheafOfModules.toSheaf` (exists, preserves
   finite limits, reflects isos).
2. Coverage debt: the iter-035 provers added helpers without blueprint entries —
   `stalkMapₗ`, `stalkMapₗ_eq`, `stalkMapₗ_injective`, `tilde_germ_algebraMap_smul`
   (TildeExactness); `specBasicOpen`, `specAwayToSpec`, `specAwayToSpec_eq`
   (QcohRestrictBasicOpen). The planner will author/repoint these this iter; tell me the
   correct `\uses{}` parents you'd expect for each.
3. Whether the `% archon:covers` header should add
   `AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` (currently absent).
4. Any stale `% NOTE` blocks (e.g. the resolved iter-034 Cov must-fix on
   `def:affine_cover_system`).
