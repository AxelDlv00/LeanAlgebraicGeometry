# Iter-112 (Archon canonical) — review

## Outcome at a glance

- **Single Phase B prover lane on `AlgebraicJacobian/Differentials.lean` L122** (`relativeDifferentialsPresheaf_isSheaf`) hitting **Bar B** of the iter-112 success bar per `PROGRESS.md` § "Concrete iter-112 success bar".
- **Result**: **PARTIAL — Bar B (acceptable)**. Route (a) chosen explicitly; ≥2 named helpers instantiated (`relativeDifferentialsPresheaf_isSheafOpensLeCover_type` load-bearing at L159, `relativeDifferentialsPresheaf_isSheaf_type` fully closed at L188); the surrounding scaffolding visibly enacts the Step 1 / Step 2+3 recipe. Bar A (file sorry 5 → 4) **NOT** met — helper #1's body still carries `sorry`.
- **Sorry trajectory**: project total **16 → 16** (no closure; structural advance — the L122 sorry was *moved* into helper #1 at L159, and the main theorem L220 is now fully closed). Per-file: `Differentials.lean` 5 → 5.
- **Compile-verified**: yes. `lake env lean AlgebraicJacobian/Differentials.lean` returns only the 5 expected `declaration uses sorry` warnings; `lean_diagnostic_messages` severity=error returns `[]`.
- **No new axioms**; no protected signatures touched; `archon-protected.yaml` unchanged (9 protected declarations).
- **Named-gap roster**: unchanged. 7 named Mathlib gaps + 1 budget-deferral (the iter-112 helper #1's `sorry` is not on the named-gap roster — it is documented Bar-B scaffolding pending iter-113+ closure).

## Overall progress (this session detail)

- **Total active syntactic sorry sites**: **16**, distributed:
  - `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`: **6** at L1120 PAUSED, L1212 / L1536 / L1564 substep-deferred, L1754 gated on L1120, L1846 budget-deferred (all off-limits this iter).
  - `AlgebraicJacobian/Differentials.lean`: **5** at:
    - L159 (`relativeDifferentialsPresheaf_isSheafOpensLeCover_type`; **iter-112 NEW Bar-B scaffolding helper**, replaces the prior L122 sorry).
    - L622 (`cotangentExactSeq_structure case h_exact`; named gap #2, parallel to `instIsMonoidal_W`; off-limits).
    - L816 (`smooth_iff_locally_free_omega`; Phase B prover-viable but **must-fix signature mismatch flagged this iter** by `lean-vs-blueprint-checker-differentials-iter112` — see below).
    - L832 (`cotangent_at_section`; Phase B; same signature mismatch).
    - L976 (`serre_duality_genus`; named gap #7; **must-fix signature mismatch** — Lean equation `H^0 = H^0` contradicts blueprint `H^0 = H^1`).
  - `AlgebraicJacobian/Modules/Monoidal.lean`: **1** at L173 (`instIsMonoidal_W`; Mathlib gap).
  - `AlgebraicJacobian/Picard/LineBundle.lean`: **2** at L82 (`pullback_tensorObj`; named Mathlib gap) + L96 (`pullback_oneIso`; sister Mathlib gap added iter-109).
  - `AlgebraicJacobian/Picard/Functor.lean`: **1** at L181 (`representable`; gated on Phase C3).
  - `AlgebraicJacobian/Jacobian.lean`: **1** at L179 (`nonempty_jacobianWitness`; Phase C3 exit policy).
- **Solved this iter**: **0**.
- **Partial this iter**: **1** — `relativeDifferentialsPresheaf_isSheaf` (L220, main theorem body fully closed; load-bearing residual exposed as helper #1 at L159).
- **Blocked this iter**: none.
- **Untouched (deferred)**: 15.

## What the iter-112 plan got right

- **Re-verification of Mathlib names**: the iter-112 plan agent re-verified 8 of the 10 cited names in the proof block (per `PROGRESS.md` § "Iter-112 Mathlib name re-verification"); all 8 names + the `tilde` namespace correction held under the prover's `lean_local_search` checks during the session. The plan-agent's pre-emptive `forget AddCommGrpCat`-vs-`CategoryTheory.forget AddCommGrpCat` namespace correction would have been useful — the prover hit and self-corrected this pitfall mid-session (Attempt 1 → Attempt 2).
- **Concrete success-bar spec**: the **Bar A / Bar B / Bar C** decomposition gave the prover a clean operational target and gave the review agent a clean scoring rubric. Bar B is achieved unambiguously; the prover stopped at the right cut.
- **LOC budget realism**: the iter-111 upward revision (~100–200 LOC for the basis-to-opens descent) tracks the prover's iter-113+ recipe estimate exactly (Sub-lemma A 40–80 + Sub-lemma B 50–100). The budget is not over-tight.

## What surfaced this iter that the plan didn't anticipate

**Three pre-existing must-fix signature mismatches** in `Differentials.lean`, surfaced by `lean-vs-blueprint-checker-differentials-iter112`:

1. **`smooth_iff_locally_free_omega` (L816)**: blueprint pins `IsSmoothOfRelativeDimension n f`; Lean uses dimension-free `Smooth f` + free `n : ℕ`. The biconditional is structurally unsatisfiable for free `n`. **The Lean signature has never matched the blueprint prose.**
2. **`cotangent_at_section` (L832)**: identical mismatch.
3. **`serre_duality_genus` (L976)**: Lean equation `dim H^0 = dim H^0`; blueprint asserts `dim H^0(Ω_{C/k}) = dim H^1(O_C)`. The Lean equation is **mathematically false** for genus > 1. The local docstring at L971–975 agrees with the blueprint, so the docstring is also internally inconsistent with the signature.

None of these are introduced by iter-112's prover round, but they were latent and the reviewer's bidirectional pass is the first to flag them formally. The review agent applied `% NOTE:` annotations to the corresponding blueprint blocks; the iter-113 plan agent should dispatch a **refactor lane** (not a prover) to align the Lean signatures with the blueprint before resuming Phase B on L735/L718/L877 (now L823/L840/L982).

## What progressed in the right direction

- **Helper exposure as a structural advance**: the Bar-B scaffolding shape (one load-bearing helper at the OpensLeCover level + one fully-closed bridge helper + closed main body) is the right shape for advancing a single-sorry "main theorem" through a multi-step recipe without regressing the sorry count. Reusable elsewhere in the project; documented in PROJECT_STATUS.md Knowledge Base this iter.
- **Namespace pitfalls catalogued**: the `Presheaf.isSheaf_iff_isSheaf_comp` vs `TopCat.Presheaf.isSheaf_iff_isSheaf_comp` choice, the `CategoryTheory.forget` vs bare `forget` parse trap, the `TopCat.Presheaf.IsSheafOpensLeCover (...)` qualified-standalone vs field-access pattern — all surfaced in this iter's attempt log and now in the Knowledge Base.
- **Compile-verification streak**: this is the **eighteenth consecutive compile-verified prover iteration** (iter-092 through iter-112 Archon canonical). `lake env lean` and `lean_diagnostic_messages severity=error` both clean at session end.

## Verification (pre-handoff, iter-112 review pass)

| Check | Status |
|---|---|
| Sorry count per file | BasicOpenCech 6, LineBundle 2, Modules-Monoidal 1, Picard-Functor 1, Differentials 5, Jacobian 1, others 0 = **16 total**. Verified by direct `lake env lean` + grep on each file. |
| File compilation (Differentials.lean) | `lean_diagnostic_messages severity=error` → `[]`; only 5 expected `declaration uses sorry` warnings. |
| `archon-protected.yaml` | unchanged (9 declarations). |
| New axioms | none across the project. |
| Subagent dispatches (review-phase, this iter) | 2 mandatory: `lean-auditor-iter112` (clean — 0 new must-fix, 3 carry-over majors, 1 new minor) + `lean-vs-blueprint-checker-differentials-iter112` (3 pre-existing must-fix signature mismatches surfaced). |
| Blueprint markers updated (manual, by review agent) | 3 `% NOTE:` annotations added to `Differentials.tex`: `thm:smooth_iff_locally_free_omega` (L183), `cor:cotangent_at_section` (L203), `thm:serre_duality_genus` (L223). No `\leanok` / `\mathlibok` / `\notready` touches by the review agent. |
| `TO_USER.md` | empty (no critical user-facing issue). |
| Compile-verified streak | 18 consecutive iters (iter-092 through iter-112 Archon canonical). |

## Recommendations for the next plan-agent iteration (iter-113)

See `proof-journal/sessions/session_112/recommendations.md`. Headline (in priority order):

1. **Refactor lane**: fix the 3 signature mismatches (`smooth_iff_locally_free_omega`, `cotangent_at_section`, `serre_duality_genus`) per the reviewer's must-fix flags. None of these declarations are protected; all currently have `sorry` bodies so the refactor only changes statements + re-inserts `sorry`. Project sorry count unchanged.
2. **Prover lane**: dispatch on **helper #1 `relativeDifferentialsPresheaf_isSheafOpensLeCover_type` (L159 of Differentials.lean)** following the iter-113+ recipe in the prover task result (Sub-lemma A — affine identification + Sub-lemma B — cofinality refinement; ~100–200 LOC total). Success metric: Bar A (file sorry 5 → 4 / project 16 → 15).
3. **Optional cleanup**: address carry-over majors from `lean-auditor` (Differentials.lean L27–30 header rot, BasicOpenCech.lean cross-iter excuse-comments, Differentials.lean L213–215 inline "Project-level sorry total: 5" claim). Low priority; not blocking.
