# Progress Critic Directive

## Slug
routec-stuck

## Iter
152

## Active routes / files under review

### Route: AlgebraicJacobian/Cotangent/ChartAlgebra.lean + ChartAlgebraS3.lean (Route C — chart-algebra piece (ii))

- **Started at iter**: current phase entered iter-144 (chart-algebra pivot)
- **Iters audited**: iter-147 to iter-151

#### Sorry counts per iter (declaration-level, project-wide)
- iter-147: 5
- iter-148: 5
- iter-149: 9   (+4 — planner-authorised decomposition: new ChartAlgebraS3.lean with 4 (S3.*) scaffolds)
- iter-150: 9
- iter-151: 9

#### Helpers added per iter
- iter-147: signature refinements; structured sorries
- iter-148: path-(b) (S3.*) decomposition prose; sorry split
- iter-149: NEW FILE ChartAlgebraS3.lean (+322 LOC, 4 scaffolds); +89 LOC ChartAlgebra
- iter-150: +194 LOC ChartAlgebra (~90 LOC MvPolynomial FREE-CASE helpers + functoriality); +1 closed helper in ChartAlgebraS3
- iter-151: comment-only (false-as-stated diagnosis block); 0 new code

#### Prover statuses per iter
- iter-147: PARTIAL — signature refinement, structured sorry
- iter-148: PARTIAL — (S3.*) decomposition
- iter-149: PARTIAL — 4 scaffolds + 1 in-tree branch closure
- iter-150: PARTIAL — MvPolynomial helpers deposited, transfer step residual
- iter-151: PARTIAL→IMPOSSIBLE — the bounded "convergence test" lane discovered the KDM lemma `mem_range_algebraMap_of_D_eq_zero` is mathematically FALSE as stated (counterexamples B=k×k, ℚ(√2)/ℚ). NET sorry unchanged 9→9. STUCK trigger fired per the standing bright-line.

#### Recurring blocker phrases
- "transfer step" / "Mathlib gap" — iter-149, iter-150, iter-151 reports (the KDM (C.d) residual) — culminated in iter-151 finding it is FALSE, not a gap.
- "consumer-compatibility wall" / "needs upstream [CharZero k] cascade" — iter-150 (S3.sep.*) — blocked signature inflation.

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (Chart-algebra row, post-pivot): 3–6
- **Elapsed iters in current phase**: ~8 (iter-144 to iter-151)
- **Phase started at iter**: iter-144

#### Planner's current proposal for this iter
The planner is NOT assigning another helper round. It is executing the
bright-line's forced corrective: a ROUTE PIVOT. Specifically: (a) STRATEGY.md
updated to add `[IsAlgClosed kbar]` (resolving the standing user fork),
collapsing `constants_integral_over_base_field` and descoping the (S3.*) chain;
(b) a blueprint-writer rewrite of the RigidityKbar.tex chart-algebra section;
(c) a `refactor` subagent dispatch to apply the corrected signatures
(`[IsAlgClosed k]`+`[IsDomain B]` on the KDM lemma, re-route constants, fix the
sorryAx-laundering consumer). No prover lane this iter (refactor in flight +
blueprint re-review pending next iter per the HARD GATE). Question for you:
does this pivot adequately respond to the STUCK signal, or is it itself a
"keep refactoring, never test" stall risk?

## PROGRESS.md proposal (this iter)
- **File count**: 0 prover files (no prover dispatch — architectural refactor + blueprint rewrite iter)
- **Files**: (none)
- **Dispatch cap (from --max-objectives)**: 10

## Out of scope
- Route A (positiveGenusWitness / Jacobian.lean L223) — off-critical-path, not assessed.
- Jacobian.lean genusZeroWitness, RigidityKbar.lean rigidity_over_kbar bodies — gated, not assessed.
