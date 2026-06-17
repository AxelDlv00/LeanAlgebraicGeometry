# Iter-151 (Archon canonical) — review

## Outcome at a glance

- **Single bounded prover lane FIRED** on `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` — the progress-critic's CHURNING (C.d) transfer-step convergence test under the STRATEGY.md bright-line. Result: **confirmed mathematical impossibility**. `meta.json`: `planValidate.status: ok / objectives: 1`, `prover.status: done`, `prover.durationSecs: 511` (~8.5 min).
- **Sorry count (declaration-level)**: 9 → **9** (NET 0). STUCK trigger fired per the bright-line — (C.d) did not (and cannot) net-reduce. Per file at iter-151 close: `Cotangent/ChartAlgebra.lean` 2 (KDM L256/sorry-L422 + hPI L507/sorry-L651); `ChartAlgebraS3.lean` 4; `GrpObj.lean` 0; `Jacobian.lean` 2; `RigidityKbar.lean` 1.
- **Code delta**: comment-only. The prover replaced the prior (C.d) "transfer-gap" comment with a false-as-stated diagnosis block (`ChartAlgebra.lean:361–422`) and retained the `sorry` verbatim. Per `attempts_raw.jsonl`: 2 edits, 0 goal checks, 4 diagnostic checks, 0 builds, 5 lemma searches. No new code, no protected-signature change, no new axioms.

## The finding (headline)

`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` is **mathematically FALSE** even under its iter-149 inflated signature `[Field k] [CharZero k] [Algebra.FiniteType k B] [Algebra.IsStandardSmoothOfRelativeDimension n k B]`. This **supersedes** the iter-148 KB entry that marked the lemma "RESOLVED iter-149 via signature inflation."

Two counterexamples satisfy every hypothesis yet break the conclusion:
- **(CE1)** `B = k×k`, `n=0` — finite étale ⟹ `Ω=0` ⟹ `D=0`; `range` = diagonal, `(1,0) ∉ range`. Kills "add connectedness."
- **(CE2)** `k=ℚ`, `B=ℚ(√2)`, `n=0` — finite separable ⟹ étale ⟹ `D=0`; `range = ℚ ⊊ ℚ(√2)`. Kills "add `[IsDomain B]`."

`IsStandardSmoothOfRelativeDimension n k B` = "∃ submersive presentation of dim n" (`StandardSmooth.lean` L88), carrying **no** geometric-connectedness data. The true statement needs `k` algebraically closed in `B` — exactly the `GeometricallyIrreducible`+`IsReduced` content carried at the scheme level by `df_zero_factors_through_constant_on_chart`, **lost** when reduced to this `B`-only algebra lemma.

Both pre-staged closure paths were attacked and fail for the same reason (false goal): (S5.a) explicit `ker_map_of_surjective` Leibniz chase — the step "`pderiv_i α₁ ∈ I` ⟹ `α₁` constant" is false in CE2; (S5.b) `subsingleton_h1Cotangent` H¹-vanishing — only splits the conormal sequence, cannot prove a false statement.

## Review-phase subagents (2, both COMPLETE, mutually + prover-consistent)

| Subagent | Slug | Verdict | Key findings |
|---|---|---|---|
| `lean-auditor` | chartalgebra-iter151 | 2 must-fix | (1) known-false `sorry` L422; (2) **`df_zero_factors_through_constant_on_chart` L450 launders `sorryAx`** (clean compile, no `sorry` warning, yet `sorryAx` in axiom set). Major: orphaned ~110 LOC `_mvPoly_*` chain; live WIP `sorry` L651; misleading name `ext_of_diff_zero`. Independently re-verified CE1+CE2. |
| `lean-vs-blueprint-checker` | chartalgebra-iter151 | consistent | Lean ↔ blueprint now mutually consistent post-NOTE (resolves iter-150 prose-vs-Lean divergence). Major: stale **proof-block `\leanok`** at `RigidityKbar.tex:~2356` on the sorry-bearing KDM proof (sync_leanok domain). Missing dedicated chapter = organizational-only. |

Reports: `task_results/lean-auditor-chartalgebra-iter151.md`, `task_results/lean-vs-blueprint-checker-chartalgebra-iter151.md`.

## Secondary unsoundness surfaced

`df_zero_factors_through_constant_on_chart` (L450) is a one-line delegate to the false KDM lemma. It compiles with **no `sorry` warning** but `lean_verify` shows `sorryAx` in its axiom set. The warning-based "9 sorries" headline therefore **undercounts** the unsound dependency set. The geometric data the fix needs (`GeometricallyIrreducible`+`IsReduced`) is already in this consumer's hypotheses, discarded by the delegate — that site is the concrete fix location.

## Manual blueprint markers
- `RigidityKbar.tex` `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`: `% NOTE (iter-151, review)` at the statement block (false-as-stated + CE1/CE2 + missing geometric hypothesis + architectural escalation + pointers).
- `RigidityKbar.tex` (C.d) bullet: `% NOTE (iter-151, review)` marking the (S5.a)/(S5.b) closure prose UNREACHABLE for the false goal.
- No `\leanok` touched.

## Knowledge Base updates
- **2 Proof Patterns**: `lean_verify` catches `sorryAx`-laundering consumers; counterexample-driven impossibility detection for derivation-kernel/constants goals.
- **1 DEFINITIVE Known Blocker**: KDM false even with inflated signature (supersedes the iter-148 "RESOLVED iter-149" entry); do-not-retry (C.d) via S5.a/S5.b/(p2); corrective is architectural signature change.

## Blueprint doctor (iter-151)
Clean — no orphan chapters, no broken `\ref`/`\uses`, no empty annotations, no new axioms.

## Carry-forward for iter-152 (see recommendations.md)
1. **No prover lane on KDM** until the signature carries a geometric hypothesis. Architectural change (consider the `refactor` subagent), coupled to the `[IsAlgClosed kbar]` decision.
2. Quarantine or lockstep-fix the `sorryAx`-laundering consumer L450.
3. Confirm sync_leanok clears the stale proof-block `\leanok` at `RigidityKbar.tex:~2356`.
4. Preserve (do not delete) the orphaned `_mvPoly_*` chain — reusable for the corrected lemma.

## Subagent skips
(None — both highly-recommended review-phase subagents dispatched.)
