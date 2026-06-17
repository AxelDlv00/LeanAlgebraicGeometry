# Blueprint Reviewer Directive

## Slug
iter149

## Iteration
149

## Scope (read every chapter)

Audit ALL 11 chapter files under `blueprint/src/chapters/` plus
`blueprint/src/content.tex` and `blueprint/src/macros/common.tex`.
Use your standard per-chapter checklist.

## Plan-agent context for this iter (informational; do not act on it,
just so the audit is properly calibrated)

- **Build-blocker fix landed this plan phase.** The iter-149 plan
  agent identified and patched a depgraph cycle that crashed
  `leanblueprint web` with `RecursionError` in
  `plastexdepgraph.ancestors`. Cycle: `def:Jacobian` ↔
  `thm:nonempty_jacobianWitness`. Fix: dropped the spurious
  `\uses{def:Jacobian}` from the statement-block of
  `thm:nonempty_jacobianWitness` at `Jacobian.tex:243`
  (the definition uses the existence theorem; the existence
  theorem must NOT use the definition). The build now succeeds
  end-to-end (`leanblueprint web` exits 0; all 11 chapter HTML
  files render). Verify the fix is the right shape (i.e. the
  cycle was a genuine miswiring, not a wider modelling issue
  the planner missed).

- **Sorry state going into iter-149**: 5 declarations using sorry
  / 5 inline sorries (verified via grep on `AlgebraicJacobian/`):
  - `Cotangent/ChartAlgebra.lean` L168 — KDM forward inclusion;
    iter-147 closed reverse inclusion, iter-148 docstring refresh
    only (no closure on forward inclusion).
  - `Cotangent/ChartAlgebra.lean` L367 — constants substep 3;
    iter-148 landed the smart-proof path (b) framework sorry-free
    in the proof body; residual sorry concentrated at the single
    consolidated `IsPurelyInseparable k Γ ∧ Algebra.IsSeparable k Γ`
    claim, decomposed into 4 named sub-claims (S3.pi.1, S3.pi.2,
    S3.sep.1, S3.sep.2).
  - `Jacobian.lean` L197 — `genusZeroWitness` body; gated on
    chart-algebra closure.
  - `Jacobian.lean` L223 — `positiveGenusWitness` body; gated on
    M3 Route A.
  - `RigidityKbar.lean` L87 — `rigidity_over_kbar` body; gated on
    chart-algebra piece (ii).

## Focus areas

1. **Build-fix verification.** Confirm the `\uses{def:Jacobian}`
   removal from `thm:nonempty_jacobianWitness` is correct. Read
   the statement-block prose and confirm the theorem really does
   NOT mathematically depend on the definition (it asserts
   existence of a `JacobianWitness`, which precedes the
   definition of `Jacobian`).

2. **Stale `\lean{...}` hints.** The iter-146 report flagged
   three broken `\lean{...}` hints pointing at non-existent
   declarations (`GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent`,
   `GrpObj.omega_free`, `GrpObj.omega_rank_eq_dim`). Confirm
   whether these are still present in the active text (the iter-146
   review claimed they were addressed but the iter-149 plan agent's
   grep shows comment-only mentions — verify in your audit).

3. **Chart-algebra (Route C) chapter coverage.** `RigidityKbar.tex`
   § "Chart-algebra piece (ii) first-class decomposition" carries
   five sub-pieces (α, β-core, lift, KDM, constants). 3 are
   closed in Lean (α, β-core, lift); 2 are PARTIAL (KDM,
   constants substep 3). Verify the chapter prose for
   `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`
   adequately decomposes the (p2) char-0 bridge (BR.1–BR.5 sub-gaps)
   and the (p1) char-p alternative. Verify the chapter prose for
   `lem:constants_integral_over_base_field` adequately decomposes
   the path (b) smart-proof framework (S3.pi.1 / S3.pi.2 / S3.sep.1
   / S3.sep.2 sub-claims) so an iter-149+ prover can target each
   independently.

4. **M3 Route A coverage in `Jacobian.tex`.** Verify the four
   sub-step decomposition A.1–A.4 is complete enough that an
   iter-170+ Route A prover lane has a concrete starting point.

5. **HARD GATE per-file decision.** For each `.lean` file the
   planner is considering for iter-149 prover dispatch (see below),
   apply the HARD GATE rule from your descriptor's
   `dispatcher_notes`.

## Iter-149 prover dispatch consideration

Planner's working hypothesis for iter-149 `## Current Objectives`:

- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (2 in-scope
  sorries — same file as iter-146/147/148; substantive multi-lane
  work via:
  - (S3.sep.1) `Smooth ⇒ Algebra.IsSeparable k Γ` bridge build
    (substep 3 sep arm; ~120–180 LOC ad hoc),
  - (S3.pi) `IsPurelyInseparable k Γ` bridge build (substep 3 pi
    arm; ~150–250 LOC ad hoc — includes the iter-148-named
    flat-base-change-of-Γ-for-proper-schemes (S3.pi.1) gap),
  - (KDM) (p2) char-0 bridge: inflate signature with
    `[CharZero k] + [Algebra.IsStandardSmoothOfRelativeDimension k B]`
    and land the (BR.1)–(BR.5) bridge body (~100–180 LOC).
  Aggregate proof-script work for the iter-149 prover lane:
  **~370–610 LOC**, materially larger than the iter-146/147/148
  envelope. Per the user's standing hint that lanes should
  represent "several hundred LOC of proof script".

## Reminders

- 11 chapters total: `Cohomology_SheafCompose`,
  `Cohomology_StructureSheafAb`, `Cohomology_StructureSheafModuleK`,
  `Cohomology_MayerVietoris`, `Differentials`, `Genus`, `Jacobian`,
  `Rigidity`, `RigidityKbar`, `AlgebraicJacobian_Cotangent_GrpObj`,
  `AbelJacobi`.

- Report path: `.archon/task_results/blueprint-reviewer-iter149.md`.

- HARD GATE per-file decision is the single most important
  output. State explicitly whether
  `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` is cleared for
  iter-149 prover dispatch.
