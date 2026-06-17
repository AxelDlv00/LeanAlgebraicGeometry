# Refactor Directive

## Slug
iter108-cleanup

## Problem

`lean-auditor-iter105` flagged 4 must-fix items. Of these, 2 are mechanical cleanup tasks that have been neglected for ≥3 plan rounds (progress-critic-iter106 Route 2 STUCK on neglect). The other 2 items (LineBundle wrong def; instIsMonoidal_W sorry instance) are structural Phase C0/C1 work and explicitly OUT OF SCOPE for this cleanup refactor — they remain documented in STRATEGY.md as deferred work.

This iteration's prover lane is going to attempt `h_loc_exact` at `BasicOpenCech.lean:1783` (single substantive lane). The mechanical cleanup is independent of that prover work; we run them in parallel.

The 2 mechanical cleanup items in scope:

1. **`AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:27-31`** — stale status block claims "## Status (iteration 006 — refactor scaffold) … The eight Phase A step 5 main declarations are scaffolded as `sorry`. The iter-006 prover round is responsible for filling them." All eight declarations are honestly closed; the block is ~100 iters out of date and actively misleads future readers.

2. **`AlgebraicJacobian/Rigidity.lean:19-23`** — stale status block claims "## Status (iteration 002 — refactor scaffold) … This file is a scaffold. The body of `eq_of_eqOnOpen` is `sorry`. Subsequent prover iterations are responsible for filling this sorry (Phase E of `STRATEGY.md`)." The body of `eq_of_eqOnOpen` at L88-112 is a closed ~25-line proof. Status is 80+ iterations out of date.

## Mathematical Justification

Both are pure cleanup of misleading documentation. No definitions, signatures, or proof bodies are touched. No protected declarations are involved. No new axioms; no new sorries.

The stale blocks date back to iter-002 / iter-006 scaffold drafts and were never updated after the declarations closed. They lie about file state and run counter to the lean-auditor descriptor's must-fix rule for documentation that misrepresents closure.

The replacement docstrings should:
- Briefly describe the file's current purpose (1-3 sentences).
- Drop the iter-NNN-scaffold framing.
- Drop the "responsible for filling them" framing.
- Mirror the style of similar updated file-status docstrings elsewhere in the project (e.g. `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` or `AlgebraicJacobian/AbelJacobi.lean`).

## Changes Requested

### File: `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`

Replace the docstring at L27-31 (the "## Status (iteration 006 — refactor scaffold)" block plus the line stating "The eight Phase A step 5 main declarations are scaffolded as `sorry`. The iter-006 prover round is responsible for filling them.") with a concise current-state description acknowledging:
- The file builds the `ModuleCat k`-valued structure sheaf `toModuleKSheaf C` for `C : Over (Spec (.of k))`.
- All Phase A step 5 declarations are closed.
- The file is downstream from `Cohomology/StructureSheafAb.lean` and `Cohomology/SheafCompose.lean`.

Read L1-L40 to identify the exact docstring boundaries. Replace only the stale block; preserve all module-level comments that aren't part of the stale status. Verify by running `lean_diagnostic_messages` on the file after the edit.

### File: `AlgebraicJacobian/Rigidity.lean`

Replace the docstring at L19-23 (the "## Status (iteration 002 — refactor scaffold)" block plus the "The body of `eq_of_eqOnOpen` is `sorry`. Subsequent prover iterations are responsible for filling this sorry (Phase E of `STRATEGY.md`)." text) with a concise current-state description acknowledging:
- The file proves `eq_of_eqOnOpen`: rigidity of morphisms agreeing on a dense open of a smooth proper irreducible scheme.
- The body is closed (iter-002).
- The "Hypothesis correction (iter 003 prover)" block at L36-68 is preserved verbatim — that block is accurate technical record and the lean-auditor explicitly retained it as "useful documentation, not stale".

Read L1-L35 to identify the exact docstring boundaries. Replace only the stale `## Status` block; preserve the iter-003 hypothesis correction note. Verify with `lean_diagnostic_messages`.

## Affected Files

- `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` (docstring only, no signatures touched)
- `AlgebraicJacobian/Rigidity.lean` (docstring only, no signatures touched)

No downstream files should require changes — comments do not affect compilation. After the edits, run `lean_diagnostic_messages` on both files to confirm `[]` for severity=error.

## Expected Outcome

- Both files compile (`lean_diagnostic_messages` severity=error returns `[]`).
- Sorry counts unchanged: 0 in both files.
- No new axioms; no protected signatures touched.
- The 2 must-fix items 3 and 4 from `lean-auditor-iter105` are resolved.

## Out of scope (DO NOT DO)

- DO NOT touch `Picard/LineBundle.lean` (Phase C1 territory; carried in STRATEGY.md as a separate route).
- DO NOT touch `Modules/Monoidal.lean` `instIsMonoidal_W` (Mathlib-gap deferred; documented in blueprint).
- DO NOT touch `BasicOpenCech.lean` (the iter-106/iter-107 partial-proof scaffold and `h_iter104` staging are LOAD-BEARING for iter-108's pivot lane on `h_loc_exact`).
- DO NOT touch `Differentials.lean` docstring (lean-auditor classified that one as Major, not must-fix; the strategy snapshot in the blueprint already documents Phase B deferrals honestly).
- DO NOT modify any blueprint chapters.
- DO NOT introduce new axioms or sorries.
- DO NOT improvise additional cleanups outside the two stale-docstring fixes named above.

