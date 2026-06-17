# Recommendations for the next plan iteration (post-iter-152)

## Context

No prover lane ran iter-152 (mechanical HARD GATE during the `[IsAlgClosed
kbar]` pivot). The pivot landed build-clean: 4 signatures re-signed, full
`lake build` 0 errors / 0 new axioms. Sorry count 9 → 9. The progress-critic
set a hard deadline: **a prover MUST validate the corrected signatures by
iter-154** or the pivot becomes a refactor-only stall. iter-153 is the
scheduled validation iter.

## HIGH — iter-153 prover lane (the planned validation)

1. **`constants_integral_over_base_field`** (`ChartAlgebra.lean:468`) —
   **GUARANTEED 9 → 8.** Under the new `[IsAlgClosed k]`, close via the
   3-step alg-closed chain documented in the body comment (L475-485):
   integral ⟹ Γ is a field; `finite_appTop_of_universallyClosed`;
   `IsAlgClosed.algebraMap_bijective_of_isIntegral` (verified,
   `Mathlib.FieldTheory.IsAlgClosed.Basic`). This is the cheapest, surest
   win and proves the pivot was worth it.
2. **`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`**
   (`ChartAlgebra.lean:256`) — attempt the field-of-fractions argument
   (FT.1–FT.3 in the rewritten RigidityKbar.tex KDM proof block; residual
   `sorry` at L383). Now mathematically TRUE, so this is a genuine target,
   not a wall. Closing it also discharges df_zero's transitive `sorryAx`.

   **PREREQUISITE (HARD GATE)**: the iter-153 mandatory blueprint-reviewer
   must confirm `RigidityKbar.tex` is now `complete:true / correct:true`.
   The iter-152 lean-vs-blueprint-checker already found the pivot faithfully
   reflected with 0 must-fix, so this should clear.

## HIGH — comment cleanup (lean-auditor: 7 major, actively misleading)

The refactor re-routed bodies but left docstrings describing the abandoned
pre-pivot route. These will mislead the iter-153 prover about the intended
proof. The review agent cannot edit `.lean`; assign to the file owner
(prover) or a `refactor` directive **alongside** the iter-153 prover lane:

- `ChartAlgebra.lean:433-485` — `constants_integral_over_base_field`
  docstring (3-substep base-change-to-`k̄` recipe) **contradicts** its own
  iter-152 body comment. Fix FIRST — the iter-153 prover reads this docstring
  to close the lemma. **Worst offender.**
- `ChartAlgebra.lean:39-61` — file-level "Status (iter-146)" cites
  `: True := sorry` skeletons that no longer exist.
- `ChartAlgebra.lean:227-255, 387-428` — update KDM + df_zero docstrings to
  mention the new `[IsAlgClosed k]`+`[IsDomain B]` hypotheses.
- `ChartAlgebraS3.lean:59-63, 148-179, 306-323` — stale consumer cross-refs
  (claim constants consumes the (S3.*) lemmas at wrong line numbers L367/
  L431/L457; the iter-152 consumer at L468 consumes none).
- `GrpObj.lean:433-443, 465-525` — ~60-line orphaned comment blocks for
  decls excised iter-145.
- `RigidityKbar.lean:20-29, 70-74` (minor) — mention the iter-152
  `[IsAlgClosed kbar]`+`[CharZero kbar]` additions.

## MEDIUM — recurring stale PROOF-block `\leanok` (sync_leanok gap)

`RigidityKbar.tex` carries a `\leanok` on the **proof block** of both
`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` and
`lem:constants_integral_over_base_field`, whose Lean bodies hold open
`sorry`s (KDM L383, constants L485). Per the marker vocab a proof-block
`\leanok` asserts "proof closed, no sorry" — so these are **stale**. (The
**statement-block** `\leanok` on the same lemmas is CORRECT — it only asserts
the declaration is formalized with at least a sorry present; do not touch
those.) This exact stale proof-block `\leanok` was flagged in iter-151 too,
so it is persisting across iters. `\leanok` is `sync_leanok`'s deterministic
domain (the review agent must not edit it). **Action for the plan agent**:
confirm `sync_leanok` actually ran this iter and is correctly removing
proof-block `\leanok` from sorry-bearing proofs — a 2-iter persistence
suggests either it is skipped on no-prover-lane iters or it cannot map these
two declarations. If iter-153's prover closes them, the markers self-correct;
if not, the sync gap should be investigated so the blueprint does not show
false "proof complete" on open obligations.

## MEDIUM — track the honest sorryAx-laundering

`df_zero_factors_through_constant_on_chart` (L411) and
`nonempty_jacobianWitness` (Jacobian.lean:249) are sorry-free in body but
carry `sorryAx` transitively. This is now *incompleteness* (open obligation),
NOT *unsoundness* (the iter-151 false-lemma issue is resolved). No action
needed beyond the `% NOTE` already added — but do NOT read the "9 sorries"
headline as the full unsound/incomplete surface. When KDM and the two
witness sorries close, these consumers become axiom-clean automatically.

## Do NOT retry

- **Do NOT re-attempt KDM as a bare `B`-only lemma** or with only
  `[CharZero k]`+std-smooth (iter-148/149/151 confirmed FALSE; counterexamples
  `B=k×k`, `ℚ(√2)/ℚ`). The only correct form carries `[IsAlgClosed k]`+
  `[IsDomain B]` (now landed). See PROJECT_STATUS.md KB "honest-wrong-signature"
  entry (marked RESOLVED iter-152).
- **Do NOT re-open the (S3.*) base-change-to-`k̄` chain** (`ChartAlgebraS3.lean`,
  4 off-path sorries) as a critical-path target — it is descoped by the
  alg-closed pivot. Keep the labels/citations (cref cascade) but it is not
  blocking.

## Reusable proof patterns discovered

- **Joint-hypothesis repair of a false derivation-kernel lemma**: when
  `ker(D) = base` fails on disconnected (`k×k`) AND non-alg-closed-extension
  (`ℚ(√2)`) counterexamples, the joint `[IsAlgClosed k]`+`[IsDomain B]` is the
  minimal sound repair; test both counterexamples are killed before assuming
  one hypothesis suffices.
- **Honest vs unsound `sorryAx`-laundering**: a sorry-free consumer of an
  open-but-true lemma carries `sorryAx` transitively — this is incompleteness,
  not unsoundness. Run `lean_verify` on the consumer to see it; annotate the
  blueprint so the deterministic proof-block `\leanok` is not misread.
