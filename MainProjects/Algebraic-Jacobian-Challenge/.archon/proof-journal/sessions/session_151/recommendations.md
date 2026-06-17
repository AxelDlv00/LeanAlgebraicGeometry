# Recommendations for the iter-152 plan agent

## CRITICAL / HIGH

### REC-1 — Do NOT re-assign the KDM (C.d) transfer step. It is mathematically impossible under the current signature.
`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` is **FALSE** even with `[CharZero k] + [IsStandardSmoothOfRelativeDimension n k B]` (counterexamples CE1 `B=k×k`, CE2 `B=ℚ(√2)`; both independently re-verified by `lean-auditor-chartalgebra-iter151`). Three closure routes are now exhausted-and-impossible — **do not retry any of them**: (S5.a) explicit `ker_map_of_surjective` unfold; (S5.b) `subsingleton_h1Cotangent`; (p2) `Differential.ContainConstants`. None can close a false goal. The bright-line STUCK trigger fired (NET 9→9).

**Required iter-152 corrective (architectural, NOT decomposition):**
1. Add a geometric-connectedness hypothesis to the lemma signature — `k` algebraically closed in `B`, or an `Algebra.IsGeometricallyConnected` / geometrically-integral premise. (Lemma is NOT in `archon-protected.yaml`, but the change ripples to the consumer, so escalate, do not edit unilaterally.)
2. Propagate it to the consumer `df_zero_factors_through_constant_on_chart` — which **already carries** `GeometricallyIrreducible (C ↘ Spec k)` + `IsReduced C` (`ChartAlgebra.lean:455–456`), currently **discarded** by its one-line delegate. That delegate site is the concrete location to thread the geometric data into KDM.
3. This couples to the standing `[IsAlgClosed kbar]` / geometric-irreducibility TO_USER decision (first asked iter-150). Resolve the geometric hypothesis once and thread it through both lemmas.
4. The (C.a)–(C.c) scaffolding (`_mvPoly_*` helpers + `_hFunct`) is sorry-free and **reusable** for the corrected lemma.

This is a structural-refactor task, not a prover task — consider dispatching the `refactor` subagent to apply the signature change (inserting `sorry` at the now-changed proof site) once the geometric hypothesis is decided, rather than another prover lane.

### REC-2 — `df_zero_factors_through_constant_on_chart` (L450) launders `sorryAx` — quarantine or fix in lockstep.
`lean-auditor-chartalgebra-iter151` found this consumer compiles with **no `sorry` warning** yet depends on `sorryAx` (via the one-line delegate to the false KDM lemma). So the project's "9 sorries" headline **undercounts** the unsound surface. Until KDM is corrected, this theorem must not present as closed: either give it its own explicit `sorry`, or correct it in lockstep with the KDM signature change (preferred — the geometric data is already in its hypotheses). **Action for iter-152**: when running `lean_verify`-based health checks, audit consumers of any `sorry` lemma for `sorryAx` laundering.

## MEDIUM

### REC-3 — Stale proof-block `\leanok` on the KDM proof (sync_leanok domain).
`RigidityKbar.tex:~2356` carries a **proof-block** `\leanok` that falsely marks the sorry-bearing KDM proof as closed (flagged by `lean-vs-blueprint-checker-chartalgebra-iter151`). This is `sync_leanok`'s domain (not an agent write). It may be a sync bug: sync_leanok may only manage statement-block `\leanok` and miss proof-block markers on sorry-bearing proofs. **Action**: have the plan agent confirm sync_leanok re-runs / clears it, or surface to the developer. (The statement-block `\leanok` at the theorem header is legitimate — a formalized declaration with a `sorry` present gets the statement-level marker.)

### REC-4 — Orphaned dead code: the `_mvPoly_*` / `_finsupp` chain (~110 LOC).
`_finsupp_sub_single_eq_of_one_le` → `_mvPoly_coeff_pderiv_at_shifted` → `_mvPoly_mem_range_C_of_pderiv_eq_zero` → `_mvPoly_mem_range_C_of_D_eq_zero` (`ChartAlgebra.lean:117–225`) are sorry-free and correct but **referenced only in comments** since their apex feeds the now-dead KDM lemma. **Do not delete** — they are reusable for the corrected lemma. Wire them into the corrected KDM proof when the signature is fixed; until then leave them with a one-line `% reusable for corrected KDM lemma` pointer rather than as comment-justified dead weight.

## LOW (notes)
- Misleading name `Scheme.Over.ext_of_diff_zero` (L720) — promises a "diff = zero" hypothesis absent from its signature (thin rename of `ext_of_eqOnOpen`). Docstring is honest; rename optional cleanup.
- Pervasive iter-by-iter narrative comments in `ChartAlgebra.lean` (several stale, e.g. references to `: True := sorry` placeholders that no longer exist) — candidate for a cleanup pass moving process notes to the blueprint/journal.
- Missing dedicated `..._ChartAlgebra.tex` chapter is **organizational only**, not a correctness gap (both checkers agree). The KDM prose lives coherently in `RigidityKbar.tex` § "Chart-algebra piece (ii)" with full `\uses` wiring. Do not block on it.

## Do-NOT-retry summary (for the plan agent's stuck-protocol gate)
- KDM (C.d) closure via (S5.a) / (S5.b) / (p2) — **impossible** under current signature (false lemma). 6 consecutive PARTIAL/blocked iters on Route C; this iter confirmed the blocker is architectural. No prover lane on KDM until the signature carries a geometric hypothesis.
- `constants_integral_over_base_field` hPI branch + `ChartAlgebraS3.lean` (S3.pi.*) — gated on the `[IsAlgClosed kbar]` user decision; do not re-assign until resolved.
