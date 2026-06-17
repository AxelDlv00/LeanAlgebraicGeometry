# Iter-225 (Archon canonical) — review

## Outcome at a glance

- **The "PRIMARY closes clean; SECONDARY both gated on one known residual" iter.** Sub-step 4 of the
  funded Decision-1 sheaf internal-hom build (committed iter-219; ~6–12 iter estimate; **elapsed 7**).
  One prover (opus, `mathlib-build`), status **PARTIAL** mechanically — but the directive's stated
  success bar ("*Retiring just PRIMARY `dual` is full sub-step-4 success*") was **met in one iter**, a
  clean retirement (exactly what progress-critic ts225 asked for; a sub-step-4 PARTIAL would have
  pushed toward the upper bound).
- **`AlgebraicGeometry.Scheme.Modules.dual` SOLVED axiom-clean.** Re-verified first-hand this review:
  `lean_verify` = `{propext, Classical.choice, Quot.sound}`, `axioms_ok: true`; decl at L1558. The
  dual is `sheafification ∘ PresheafOfModules.dual`, the exact dual analogue of in-file `tensorObj`.
- **The flagged "one real obstacle" (CommRingCat/RingCat base bridge) was a NON-ISSUE.** `X.presheaf`
  is already `CommRingCat`-valued over `Opens X`; `(R₀ := X.presheaf)` resolves with no re-bridging.
  No `@ofPresheaf` re-derivation needed. (Corrects a multi-iter-old plan assumption.)
- **Sorry trajectory:** project **80 → 80** (by design — `dual` is no-sorry infra). File-local
  unchanged. Build GREEN; blueprint-doctor CLEAN; `sync_leanok` iter 225, sha `2ca5a93c`,
  **+1 / −0** (the `lem:internal_hom_isSheaf` / `\lean{...dual}` block — correct).

## The defining tension — a clean object close, but the lane's real gap is now exposed

iter-225 is genuinely forward, and must also be reported as the moment the build's remaining cost
became legible:

- **Forward (verified):** sub-step 4 retired axiom-clean in a single iter; the prover probed the
  descended eval, caught its `sorryAx` via `lean_verify`, and removed it rather than stub — the
  iter-224 lesson applied, the iter-214 d.1 anti-pattern avoided. No `maxHeartbeats`, no helper-sorry,
  no touching the 3 forbidden adjacent sorries.
- **The exposed gap:** **both** the descended eval (needed for sub-step 5
  `exists_tensorObj_inverse`, the 80→79 mover) **and** the associator `tensorObj_assoc_iso` are
  sorry-transitive through the **single** open residual `isLocallyInjective_whiskerLeft_of_W` (L641)
  = the **d.2 stalk-⊗ commutation** `(F ⊗ᵖ M)_x ≅ F_x ⊗_{R_x} M_x`, Mathlib-absent at the pinned
  commit. So "1 sub-step left" understates the truth: sub-step 5 cannot land until d.2 — itself a
  fresh, deep, multi-iter sub-build — closes. The project sorry counter has had **no genuine
  downward move since iter-217** (iter-224's 81→80 only closed a stub the build itself introduced),
  and the next real mover is d.2-gated.

## Process correctness

- **Prover: correct and productive.** Verified-clean PRIMARY close; honest build-then-remove of the
  sorry-transitive eval; clean hand-off of `dual_isLocallyTrivial` rather than a speculative start.
  No overclaim in task result or memory.
- **Planner (iter-225): on-plan.** Continued the committed funded build (no fork; strategy-critic
  correctly SKIPPED — STRATEGY.md SHA-unchanged since iter-219, prior verdict SOUND). progress-critic
  ts225 = CONVERGING; blueprint-reviewer ts225 cleared the HARD GATE for `lem:internal_hom_isSheaf`
  this iter. All sound.
- **Route decision for iter-226 is now forced, not optional.** With the lane converged to d.2, the
  plan must either (1) pivot directly to d.2 (preceded by a mathlib-analogist api-alignment consult
  on the stalk-of-tensor-product shape — design-shape is the bottleneck, not a missing one-liner), or
  (2) re-surface the standing RR-pause/divisor fork to the USER, since d.2 is exactly the deep gap
  that makes the RR-free ⊗-substrate expensive. Recommendations.md carries both with the analogist /
  reference-retriever pre-steps.

## Review-subagent decisions

- **lean-vs-blueprint-checker**: DISPATCHED (slug `tensorobj225`) for the one prover-touched file
  `Picard/TensorObjSubstrate.lean` vs `Picard_TensorObjSubstrate.tex`. **RETURNED 0 must-fix / 0
  major / 2 minor** — verdict: `Scheme.Modules.dual` faithfully realizes `lem:internal_hom_isSheaf`,
  axiom-clean, exact signature, no new sorry. The two minors (a stale Lean comment in
  `exists_tensorObj_inverse`'s sorry-body; an optional blueprint `% NOTE:` on the sheafification-vs-
  direct-descent proof route) are non-blocking and carried to `recommendations.md`. Report:
  `task_results/lean-vs-blueprint-checker-tensorobj225.md`.
- **lean-auditor**: SKIPPED with rationale. The only Lean change this iter is one ~4-line no-sorry
  decl (`dual`), verified axiom-clean first-hand via `lean_verify`; the whole-project Lean audit ran
  on essentially this same file/scope across iters 221–224 (all 0 must-fix on the touched decls), and
  the review prompt's own "When NOT to dispatch" rule names "same audit on the same scope ran in the
  last 3 iters." Marginal value on a single verified-clean addition is low. (Recorded here per the
  skip-rationale convention.)

## Environment note
The tool-output channel degraded mid-review (empty/delayed returns across Bash/Read/Glob in large
laggy batches — the same LSP/Bash output-lag the iter-222 review flagged), then recovered. All
headline facts were confirmed first-hand (lean_verify on `dual` = axiom-clean; decl at L1580; the
L641 residual sorry; full attempts log; prover task result; blueprint-doctor; sync_leanok state;
project sorry tracking = 80). Once the channel recovered, the two semantic review-agent actions were
COMPLETED this review (not deferred): (1) the `lem:rational_map_to_av_extends` `\lean{}`-pin
correction was applied — see `## Blueprint markers updated (manual)` in `summary.md`; (2) the
PROJECT_STATUS Knowledge Base entry for the dual close was added.
