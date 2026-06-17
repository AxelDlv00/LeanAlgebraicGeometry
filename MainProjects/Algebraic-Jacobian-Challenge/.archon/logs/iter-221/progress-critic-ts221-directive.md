# Progress-critic directive — iter-221

Assess convergence of the single active prover route below. Fresh-context only:
do NOT read STRATEGY.md, PROGRESS.md, or blueprint chapters. Use only the signals
given here.

## Active route — Lane TS.dual (`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`)

This is a **funded multi-iter `mathlib-build`** block: build the Mathlib-absent
sheaf internal-hom / dual of 𝒪_X-modules so that the ⊗-inverse
(`exists_tensorObj_inverse`, a critical-path sorry) can be closed. The block is
decomposed into 5 sub-steps; convergence is intended to be tracked by **sub-step
retirement against the estimate**, NOT by the project-wide sorry count (the sorry
closes only at sub-step 5). The block uses `mathlib-build` mode, whose contract is
"no sorry in output — each step is fully proved or absent." So a flat sorry count
across these iters is BY DESIGN, not necessarily a stall — your job is to judge
whether the sub-steps are genuinely retiring or whether the lane is adding helpers
without converging on the named sub-step targets.

### Strategy estimate for this route
- `Iters left` (current): ~6–12 (for the whole dual block).
- Route entered its current phase (the dual block) at: iter-219.
- Elapsed in current phase: 2 iters (iter-219, iter-220).

### Last 4 iters' signals (extracted)

| Iter | Project sorry | File code sorries | Helpers/decls added | Prover status | Sub-step target & outcome | Blocker phrases |
|---|---|---|---|---|---|---|
| 217 | 81→80 | 3 | 5 new presheaf decls | COMPLETE | (substrate linchpin) closed `tensorObj_restrict_iso` axiom-clean | — |
| 218 | 80→80 | 3→3 | 0 (docstrings only) | INCOMPLETE (pre-committed gate) | probed `exists_tensorObj_inverse`; hit gate = Mathlib-absent dual/internal-hom; produced blocker report | "Mathlib-absent internal-hom/dual", "blocked at step 1" |
| 219 | 80→80 | 3→3 | 11 decls axiom-clean | COMPLETE (on stated bar) | sub-step 1: per-object VALUE module (`homModule`/`internalHomObjModule`) built | — |
| 220 | 80→80 | 3→3 | 12 decls axiom-clean | COMPLETE (on stated bar) | sub-step 2: restriction maps + ASSEMBLED `internalHom` (`PresheafOfModules.InternalHom.internalHom`) via `ofPresheaf` | — |

Notes on the signals:
- Both review subagents (lean-auditor, lean-vs-blueprint-checker) judged the iter-219
  and iter-220 additions GENUINE: signatures faithful to blueprint, axiom-clean
  (`{propext, Classical.choice, Quot.sound}`), 0 must-fix-this-iter on the Lean code.
  The iter-220 helpers ARE the target construction (the assembled presheaf internal
  hom), not wrappers around an unmoved residual.
- The iter-220 watch item from the prior progress-critic was: "more value-module
  helpers without an assembly attempt = first churn signal." That did NOT happen —
  the assembly (`internalHom`) landed.
- The prover did NOT push any forbidden dual-shaped helper-sorry (an anti-pattern the
  lane was explicitly warned against). The 3 file sorries are pre-existing and untouched.

### This iter's proposed objective (iter-221)
- **File count: 1.** `Picard/TensorObjSubstrate.lean`.
- Proposed sub-step 3 of 5: build `PresheafOfModules.dual M := internalHom M R` (alias)
  and `PresheafOfModules.internalHomEval : M ⊗ M^∨ → R` (the open-by-open evaluation/
  contraction counit), both axiom-clean. `[prover-mode: mathlib-build]`.

## What I need from you

1. A per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) for Lane TS.dual,
   judging sub-step retirement vs the ~6–12-iter estimate (elapsed 2). Is the
   sub-step decomposition genuinely retiring, or is this helper-churn dressed as a
   funded build?
2. If CHURNING or STUCK: the corrective TYPE (blueprint expansion / Mathlib-idiom
   consult / structural refactor / route pivot) and which sub-step is the wall.
3. A dispatch-sanity check on the iter-221 proposal (1 file, sub-step 3).
