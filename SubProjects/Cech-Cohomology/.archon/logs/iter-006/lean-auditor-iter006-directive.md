# lean-auditor directive (iter-006)

Audit the Lean code as Lean — no strategy bias.

## Files to read (absolute paths)

- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

## Focus areas

- This file received heavy prover work this iter: 14 new declarations were added,
  including a project-local Mathlib supplement
  `HomologicalComplex.HomologySequence.quasiIso_τ₂`, the horseshoe assembly
  `CategoryTheory.InjectiveResolution.ofShortExact`, the middle-resolution
  `ofShortExact_resolvesMiddle`, and the object-level dimension shift
  `CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic`.
- Check each new declaration for: non-vacuity (hypotheses genuinely consumed, not
  discharged trivially), no `sorry`/`admit`/`native_decide` shortcuts, axiom cleanliness,
  no dead-end or circular definitions, and whether any embedded status/strategy comments
  are now stale or misleading.
- Pay attention to the `quasiIso_τ₂` supplement: confirm it is a faithful general statement
  (does not secretly assume the conclusion) and that its boundary hypotheses are the right
  general shape, not a degree-0-only special case smuggled in.
- Confirm the iter-004 code-fence false-positive trap (a backtick `def` inside a `/-! -/`
  comment that sync_leanok misread) has NOT been reintroduced.

Report a per-file checklist plus a flagged-issues block (critical / major / minor).
Write your report to `task_results/lean-auditor-iter006.md`.
