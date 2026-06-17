# Directive — blueprint-reviewer @ iter-148

## Task

Whole-blueprint audit at iter-148. Produce a per-chapter checklist
(`complete: true | partial | false`, `correct: true | partial | false`)
and a list of must-fix-this-iter findings (if any) for the plan
agent to act on this iter.

## Scope

All 11 chapters under `blueprint/src/chapters/`:

- AbelJacobi.tex
- AlgebraicJacobian_Cotangent_GrpObj.tex
- Cohomology_MayerVietoris.tex
- Cohomology_SheafCompose.tex
- Cohomology_StructureSheafAb.tex
- Cohomology_StructureSheafModuleK.tex
- Differentials.tex
- Genus.tex
- Jacobian.tex
- Rigidity.tex
- RigidityKbar.tex

## Context (iter-147 close → iter-148 open)

- Iter-147 prover lane on `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
  delivered NET −1 sorry (β-core closed; KDM and constants substep
  3 partial). State entering iter-148: **5 declarations using
  `sorry` / 5 inline sorries**:
  - `Cotangent/ChartAlgebra.lean` — L139 (KDM forward inclusion),
    L294 (constants substep 3 surjectivity).
  - `Jacobian.lean` — L197 (`genusZeroWitness`), L223
    (`positiveGenusWitness`).
  - `RigidityKbar.lean` — L87 (`rigidity_over_kbar`).

- Iter-147 review landed 3 `% NOTE: (iter-147 review)` annotations
  in `RigidityKbar.tex` documenting (a) constants surjectivity-form
  reduction + 7-step closure chain + step (e) Mathlib gap; (b)
  α `inferInstance` discipline; (c) β-core sorry-free delegation
  to KDM with iter-148+ refinement of `ext_of_diff_zero` to encode
  `df = dg`.

- The iter-147 blueprint-doctor (deterministic phase) ran clean: no
  orphan chapters, no broken `\ref`/`\uses`, no empty annotations,
  no new `axiom` declarations.

- The iter-146 + iter-147 mandatory blueprint reviewers were both
  ALL CLEAN; HARD GATE CLEARS. Iter-148 expects the same unless
  the iter-147 prover lane or iter-147 review introduced new drift.

## Specific focus areas (informational, NOT replacing the whole-blueprint audit)

1. `RigidityKbar.tex` § "Chart-algebra piece (ii) first-class
   decomposition": verify the 5 sub-piece blocks still match the
   Lean signatures iter-147 landed in `ChartAlgebra.lean`. In
   particular the `\lean{...}` hints should point at the
   real declaration names (not the iter-145 `: True` placeholder
   names):
   - `algebra_isPushout_of_affine_product`
   - `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
   - `df_zero_factors_through_constant_on_chart`
   - `constants_integral_over_base_field`
   - `Scheme.Over.ext_of_diff_zero`

2. `RigidityKbar.tex` step (e) — the iter-147 prover identified
   flat base change of `Γ` for proper schemes (Stacks 02KH/0BUG)
   as the substantive Mathlib gap. Is this gap surfaced in the
   chapter's `lem:constants_integral_over_base_field` proof
   sketch or only via the iter-147 review's `% NOTE:` annotation?
   If only the latter, please flag whether the chapter prose
   itself should be expanded to lay out the 7-step chain with
   explicit lemma names (so the next prover lane reads from prose
   rather than from in-Lean comment blocks).

3. `RigidityKbar.tex` KDM block: the iter-146 writer's KDM (p1)
   4-substep recipe + the iter-147 prover's "(p2) char-0 bridge
   via `Differential.ContainConstants`" need to coexist as
   alternative paths. Is the chapter prose currently presenting
   both paths cleanly, or does it bias toward (p1)? The iter-148
   prover may attempt (p2) first.

4. `Jacobian.tex` `def:positiveGenusWitness` block: M3 Route A is
   off-critical-path; the scaffold proof in `Jacobian.lean:223`
   stays. Confirm the block remains complete + correct per the
   iter-145 disposition (Route A committed, Route B historical
   only).

## What you read

- `blueprint/src/chapters/*.tex` (all 11)
- `references/summary.md` (1-line per source)
- `references/challenge.lean` (authoritative signature surface)
- `blueprint/src/macros/common.tex` (macro definitions)
- The 4 `.lean` files named above for `\lean{...}` resolution:
  - `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
  - `AlgebraicJacobian/Jacobian.lean`
  - `AlgebraicJacobian/RigidityKbar.lean`
  - `AlgebraicJacobian/Cotangent/GrpObj.lean`

## What you DO NOT read

- `STRATEGY.md`, `PROGRESS.md`, `task_pending.md`, `task_done.md`,
  `PROJECT_STATUS.md`, `task_results/`, `iter/iter-NNN/*`.
- Per-iter narrative.
- Prover or session journals.

## Output format

Standard per-chapter checklist + must-fix list per the descriptor
prompt body. Write to `task_results/blueprint-reviewer-iter148.md`.
