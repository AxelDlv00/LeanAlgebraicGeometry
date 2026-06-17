# Lean ↔ Blueprint Checker — AuslanderBuchsbaum iter199

## Files in scope

- Lean: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- Blueprint: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`

## Iter-199 changes

Lean: 1 new axiom-clean substrate helper added
(`RingTheory.Module.exists_minimalSurjection_finite_localRing` L1198–L1296,
~99 LOC body). Docstring updates on `auslander_buchsbaum_formula_succ_pd`
(L1330–L1432) reflecting iter-199 progress (gap (4) closed iter-198,
gap (1) first-step substrate landed iter-199, gaps (2)-(3) remain).
File-level sorry count: 1 → 1 (unchanged).

Blueprint: plan-phase iter-199 dispatch `ab-gap-sequence` (writer)
added a `\subsection{Inductive-step substrate: per-gap decomposition of
pd(M)=k+1}` `\label{subsec:succ_pd_gap_sequence}` with a per-gap table,
dependency diagram, and iter budget refinement to 5-8 iters sequential.

## What to check (bidirectional)

1. Does the new Lean helper `exists_minimalSurjection_finite_localRing`
   need a blueprint pin? Per the prover task report, the writer's
   iter-199 chapter expansion did NOT include a pin for this declaration.
2. Is the chapter's per-gap table accurate w.r.t. the iter-199 first-step
   substrate landing (gap (1) status: ABSENT → PARTIAL)?
3. Stale `\lean{...}` pins? The plan-phase added pins for
   `RingTheory.auslander_buchsbaum_formula_succ_pd` and
   `RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` —
   do these names match the Lean declarations exactly?
4. Any prose mismatches with the file's current state?
