# Strategy Critic Directive

## Slug
route174

## Iteration
174

## Current STRATEGY.md

[Read verbatim from `.archon/STRATEGY.md` — DO NOT skip; the SHA may have shifted since prior iters because iter-173 plan-phase touched the file].

## References index

See `references/summary.md` for the source-file roster (challenge.lean.ref protected signatures; Kleiman FGA; Nitsure FGA; Milne *Abelian Varieties*; Hartshorne; Stacks tags).

## Blueprint summary (chapter titles)

| Chapter | Topic |
|---|---|
| `Cohomology_*` | Cohomology infrastructure (sheaf compose, structure sheaf, MayerVietoris) |
| `Differentials` | Differential infrastructure (off critical path; fallback-(a) only) |
| `Genus` | Genus = `dim_k H¹(C, O_C)` |
| `AbelianVarietyRigidity` | Route C — Milne §I.3 rigidity chain; covers Genus0BaseObjects + RigidityLemma + AbelianVarietyRigidity Lean files |
| `Jacobian` | The protected goal: `JacobianWitness`, `nonempty_jacobianWitness` |
| `Rigidity` | `ext_of_eqOnOpen` packaging |
| `RigidityKbar` | Fallback-(a) rigidity over `k̄` (off critical path) |
| `AlgebraicJacobian_Cotangent_GrpObj` | Cotangent of group schemes |
| `AbelJacobi` | Protected interface (Jacobian.ofCurve / unique / comp / exists_unique) |
| `Picard_RelativeSpec` | Route A.1.a — relative Spec of a qcoh-algebra (chapter LANDED iter-172) |
| `Picard_LineBundlePullback` | Route A.1.b — line-bundle pullback on `C ×_k T` (chapter LANDED iter-173) |
| `RiemannRoch_WeilDivisor` | Genus-0 RR.1 — Weil divisors on a smooth curve (chapter LANDED iter-172 + iter-173 spec-refine) |
| `RiemannRoch_RRFormula` | Genus-0 RR.2 — Riemann–Roch formula (chapter LANDED iter-173) |

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge: nine protected declarations in `references/challenge.lean.ref`, headlined by `AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` — the existence of an Albanese/Jacobian object uniform over the `k`-rational pointing of a smooth proper geometrically irreducible curve `C/k`, with **no** `C(k) ≠ ∅` hypothesis. End-state: zero inline `sorry`, kernel-only axioms.

## Specific questions

1. **A.4 risk-dominance** — the current STRATEGY.md row L29 for A.4.a names it "the risk-dominant Route-A piece, project-fatal if it stalls" with ~8-13 iters / ~900-1200 LOC. Reality check: are these estimates plausible against the Mathlib gap (no Weil divisors, no codim-1 indeterminacy machinery)? Is there a cheaper bypass?
2. **Genus-0 row velocity** — STRATEGY.md L33 says `~3-6 iters / ~100-170 LOC` and `~25/it`. iter-173 closed 1 PRIMARY axiom-clean (chart body); iter-174 plan continues with shared-helper closure of 2 remaining PRIMARYs. Plausible?
3. **Parallelism reality** — STRATEGY.md L51-53 names 5 parallel-startable lanes. iter-174 plan opens 2 NEW file-skeleton lanes (`Picard/LineBundlePullback.lean` for A.1.b, `RiemannRoch/RRFormula.lean` for RR.2). Plus 8 chapters still in "NOT YET WRITTEN" state (A.1.c, A.2.a/b/c, A.4.a/b/c/d, RR.3, RR.4). Per user-hint, iter-174 plans to fan out blueprint-writers across all 8. Verify this parallelism is sound — any chapters that need an upstream chapter first?
4. **Refactor scheduling** — STRATEGY.md L40-41 names G0BO + StructureSheafModuleK refactors as "deferred". User-hint says "launch them now". The G0BO refactor will redistribute the file across 4 modules (bare-scheme + Points + ChartIso + GmScaling). Lane A's iter-174 PRIMARYs (`gmScalingP1_chart_agreement` + `gmScalingP1_over_coherence`) live in what would become the GmScaling sub-file. Is it safe to run the G0BO refactor **before** the iter-174 Lane A prover, or should the refactor go AFTER prover phase?
5. **Goal honesty** — has the strategy drifted from the protected `challenge.lean.ref` signatures? Are there any Mathlib gaps the strategy ignores or under-estimates?

## What I need

Strategic verdict: SOUND / CHALLENGE / REJECT, with concrete rebuttals for each challenge so the planner can either rebut or amend STRATEGY.md.
