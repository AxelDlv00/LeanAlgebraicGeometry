# Iter-152 (Archon canonical) — review

## Outcome at a glance

- **NO PROVER LANE this iter** — intentional skip. `meta.json`:
  `planValidate.status: ok_intentional_skip`, `objectives: 0`,
  `prover.status: done / durationSecs: 0`. `attempts_raw.jsonl` line 1
  carries `no_prover_lane: true`. The skip is a **mechanical HARD GATE**
  (RigidityKbar.tex was `correct:false` pending the pivot rewrite, and the
  architectural refactor was in flight), not a stall.

- **The substantive forward work was the `[IsAlgClosed kbar]` architectural
  pivot** — the executed corrective for the STUCK Route C (iter-151 proved
  the KDM core lemma FALSE as a bare `B`-only statement). Landed via the
  plan phase: STRATEGY trim + 4 blueprint writers + `refactor
  isalgclosed-signatures`. Full `lake build` clean (8332 jobs, 0 errors,
  0 new axioms, 0 protected signatures touched).

- **Sorry count (declaration-level): 9 → 9** (NET 0, by design). Per file
  at iter-152 close (independently re-verified): `Cotangent/ChartAlgebra.lean`
  2 (KDM L256/sorry-L383 + constants L468/sorry-L485); `Cotangent/ChartAlgebraS3.lean`
  4 (off-path); `Cotangent/GrpObj.lean` 0; `Jacobian.lean` 2; `RigidityKbar.lean`
  1 (rigidity_over_kbar L75/sorry-L88).

## The four re-signed declarations (refactor, build-verified)

| Declaration | Signature change | Body | Axiom state |
|---|---|---|---|
| `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` | `+[IsAlgClosed k] +[IsDomain B]` | genuine `sorry` (field-of-fractions FT.1–FT.3) | `sorryAx` (own open sorry) |
| `constants_integral_over_base_field` | `+[IsAlgClosed k]` | body re-routed to single alg-closed `sorry` | `sorryAx` (own open sorry) |
| `df_zero_factors_through_constant_on_chart` | `+[IsAlgClosed k] +[IsDomain B]` (propagated) | sorry-FREE (one-line delegate to KDM) | `sorryAx` **transitively** via KDM |
| `rigidity_over_kbar` | `+[IsAlgClosed kbar] +[CharZero kbar]` | `sorry` | `sorryAx` (own open sorry) |

## Headline soundness finding (verified this review)

The plan recorded `df_zero_factors_through_constant_on_chart` as **"now
SORRY-FREE — the iter-151 sorryAx-laundering unsoundness is RESOLVED"**.
This is **half-right and worth pinning precisely**:

- `df_zero`'s OWN body is sorry-free (one-line delegate). ✅
- The lemma it delegates to (KDM) is **no longer false** — the pivot
  repaired it. So the iter-151 *false-lemma* laundering (proving a true
  consumer via a false lemma) is genuinely gone. ✅
- BUT `lean_verify` confirms `df_zero` STILL carries `sorryAx` in its
  axiom set (`{propext, sorryAx, Classical.choice, Quot.sound}`), because
  KDM has a genuine open `sorry`. So `df_zero` is **not axiom-clean**; it
  is an *honest open obligation*, not a closed result. ❌ to "RESOLVED"
  if read as "fully discharged".

Both review subagents independently confirmed this. Net: character of the
laundering changed from **unsound (false lemma)** → **incomplete (open
obligation)**; the risk that drove the iter-151 finding (warning-based
sorry count undercounts the unsound surface; `sync_leanok` will mark
df_zero's proof-block `\leanok`) **persists**. Same pattern at
`nonempty_jacobianWitness` (Jacobian.lean:249).

## Review-phase subagents (2, both COMPLETE, 0 must-fix)

| Subagent | Slug | Verdict | Key findings |
|---|---|---|---|
| `lean-vs-blueprint-checker` | chartalgebra-iter152 | consistent, 0 must-fix | Pivot faithfully reflected — `[IsAlgClosed k]`+`[IsDomain B]` present on BOTH Lean and blueprint sides for KDM + constants; KDM sketch rewritten to the field-of-fractions chain with both counterexamples documented; the two `sorry`s honest open obligations. 2 minor: (1) df_zero statement block lacked an iter-152 NOTE on the new hypotheses; (2) stale proof-block `\leanok` (sync_leanok domain). |
| `lean-auditor` | iter152 | 0 must-fix / 7 major / 4 minor | KDM re-signing is a **genuine mathematical repair** (signature now plausible; remaining sorry is a real to-prove obligation). Major cluster = **STALE COMMENTS** describing the abandoned pre-pivot route + `sorryAx`-laundering at df_zero L411. No excuse-comments, no weakened-wrong defs, no parallel APIs, no unauthorized axioms. |

Reports: `task_results/lean-vs-blueprint-checker-chartalgebra-iter152.md`,
`task_results/lean-auditor-iter152.md`.

## Stale-comment cluster (lean-auditor major — dominant issue)

The refactor changed signatures + re-routed bodies but left in-source
docstrings/status-blocks describing the OLD (now-abandoned) closure route.
These actively mislead the next prover about the intended proof and are the
top cleanup priority (file-owner / refactor work — review agent cannot edit
`.lean`):

- `ChartAlgebra.lean:433-485` — `constants_integral_over_base_field`
  docstring (3-substep base-change-to-`k̄` recipe, `IsPurelyInseparable`/
  `IsSeparable` split) is directly **contradicted by the iter-152 body
  comment** ("none of the four (S3.*) lemmas are consumed"). Worst offender.
- `ChartAlgebra.lean:39-61` — file-level "Status (iter-146)" cites
  `: True := sorry` skeletons that no longer exist + an abandoned chain.
- `ChartAlgebra.lean:227-255, 387-428` — docstrings of the two re-signed
  decls don't mention the new `[IsAlgClosed k]`+`[IsDomain B]` (header lags
  the body comment, which does cover them).
- `ChartAlgebraS3.lean:59-63, 148-179, 306-323` — stale consumer cross-refs:
  claim constants consumes the (S3.*) lemmas at `L367/L431/L457`; the iter-152
  consumer (now L468) consumes none, and the line numbers are wrong.
- `GrpObj.lean:433-443, 465-525` — ~60-line orphaned comment blocks
  describing Step 2 / Compose-main decls **excised iter-145**.
- `RigidityKbar.lean:20-29, 70-74` (minor) — status/docstring don't mention
  the iter-152 `[IsAlgClosed kbar]`+`[CharZero kbar]` additions.

## Manual blueprint markers updated

- `RigidityKbar.tex`, df_zero statement block (`lem:chart_algebra_df_zero_factors_through_constant_on_chart`):
  added `% NOTE (iter-152 review)` ×2 — (a) records the `[IsAlgClosed k]`+
  `[IsDomain B]` Lean-signature propagation (statement-block NOTE history was
  frozen at iter-148); (b) records that the proof-block `\leanok` reflects
  only df_zero's own sorry-free body, while it transitively depends on the
  open KDM `sorry` (sorryAx), so `\leanok` ≠ "fully discharged".
- No `\mathlibok` added (no new Mathlib-backed re-exports this iter).
- No `\lean{...}` corrections (refactor preserved all names).
- No stale `\notready` stripped (all `\notready` markers sit on genuinely
  unformalized deferred/off-path lemmas; no prover landed any block).

## Blueprint doctor (iter-152)

Clean — no orphan chapters, no broken `\ref`/`\uses`, no new axioms.

## Subagent skips

(None — both highly-recommended review-phase subagents dispatched, even
though no prover lane ran: the refactor modified `.lean` files this iter,
so the lean-auditor skip condition was not met, and the rewritten chapter +
changed signatures made the lean-vs-blueprint check on the pivot file
high-value.)
