# Iter-154 (Archon canonical) — review

## Outcome at a glance

- **Single prover lane FIRED** on `Cotangent/ChartAlgebra.lean`. `meta.json`:
  `planValidate.status: ok / objectives: 1`, `prover.status: done`,
  `prover.durationSecs: 841` (~14 min).
- **KDM CLOSED — the chart-algebra critical-path lemma blocked iters 149–153 is
  discharged, axiom-clean.** Global sorry count **8 → 7** (NET −1).
- **Per-file sorry tally at iter-154 close** (re-verified, bare `sorry` bodies):
  - `Cotangent/ChartAlgebra.lean` — **0** (was 1; KDM closed).
  - `Cotangent/ChartAlgebraS3.lean` — 4 (off-path, now **fully orphaned**).
  - `Cotangent/GrpObj.lean` — 0.
  - `Jacobian.lean` — 2 (L197, L223).
  - `RigidityKbar.lean` — 1 (L88).
  - Total: **7**.
- **Prover activity** (`attempts_raw.jsonl`): 11 edits, 1 goal check, 8 diagnostic
  checks, 2 builds, 5 lemma searches. No protected-signature change; no new axioms;
  all edits outside the KDM proof body are docstring/comment/import-only.

## The closure (headline)

`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` had the longest blocker
history in the project: declared **mathematically false as a bare B-only lemma**
(iter-151, counterexamples `B=k×k`, `ℚ(√2)/ℚ`), repaired by the iter-152
`[IsAlgClosed k]+[IsDomain B]` pivot, residual step **FT.3** classified a **genuine
Mathlib gap behind a STRATEGY.md bright-line** (iter-153). The iter-154
`mathlib-analogist` consult OVERTURNED the gap verdict (8 compiling `example`
blocks in `analogies/ftthree-kernel-iter154.md`), the plan agent lifted the
bright-line and fired the prover this iter, and the prover formalized the route.

Proof = the single-element / perfect-field / Jacobi–Zariski `H1Cotangent` route
(FT.1 push to `K = Frac B`; FT.2 transcendence ⟹ `FormallySmooth (Frac k[X]) K`
via `PerfectField.ofCharZero` + `H1Cotangent.exact_δ_mapBaseChange` ⟹ `mapBaseChange`
injective ⟹ faithful flatness ⟹ `D_F X = 0`; FT.3 base case `_ratfunc_D_X_ne_zero`
contradicts ⟹ `b` algebraic ⟹ `_algebraic_mem_range`). Full structure +
the new Proof Pattern in `proof-journal/sessions/session_154/summary.md` and
PROJECT_STATUS.md.

## Independent verification (this review)

- `lean_verify` on `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` →
  `{propext, Classical.choice, Quot.sound}`, **no `sorryAx`**.
- `lean_verify` on `GrpObj.df_zero_factors_through_constant_on_chart` (downstream
  one-line delegate) → same three axioms, **no `sorryAx`**. The iter-151/152
  `sorryAx`-laundering of this consumer is **genuinely resolved** (not relabelled):
  the warning-based sorry count no longer undercounts the unsound surface here.
- `lean_diagnostic_messages` on `ChartAlgebra.lean` → `[]`.
- Confirmed bare-`sorry` count across the project = 7 (grep `^\s*sorry\s*$`).
- Both new private helpers (`_ratfunc_D_X_ne_zero`, `_algebraic_mem_range`) are
  transitively clean (they feed the axiom-clean KDM theorem and the whole file
  diagnostic is empty).

## Review-phase subagents (2 dispatched, both COMPLETE, 0 must-fix)

| Subagent | Slug | Verdict | Key findings |
|---|---|---|---|
| `lean-auditor` | iter154 | **0 must-fix** / 5 major / 4 minor | "The iter-154 KDM rewrite is the real thing — compiles, axiom-clean, no `sorry`, not vacuous, comments match the proof." Re-verified axioms independently. Confirmed `_mvPoly_*` removal clean (no dangling refs). Majors: (1) **`ChartAlgebraS3.lean` fully orphaned** — imported only by `ChartAlgebra.lean`, which consumes NONE of it, yet carries 4 live sorries + dead import (`ChartAlgebra.lean:6`); (2) `GrpObj.lean` `shearMulRight` falsely tagged `NEEDS_MATHLIB_GAP_FILL` (fully proven); (3) `GrpObj.lean` piece-(i.b) headers narrate iter-145-excised lemmas as live; (4)+(5) pre-existing authorized scaffold sorries. Minors: `_hRev` dead-but-honest, unused `{n}` binders ("frozen" loose wording — decl not actually in `archon-protected.yaml`), `Jacobian.lean:275` long line, possible GrpObj orphaned support decls. |
| `lean-vs-blueprint-checker` | chartalgebra-iter154 | **0 must-fix** / 2 major / 2 minor | KDM closure faithful + axiom-clean; FT.1–FT.3 prose matches Lean step-for-step; all 5 `\lean{}` targets in the file map to chapter blocks with matching signatures; blueprint sketch depth "exemplary for KDM" (named every Mathlib lemma the Lean uses, in order). 2 major = stale blueprint `% NOTE`s (L1934–1943, L2509–2517) asserting an eliminated KDM `sorryAx`/open-sorry — **both review-agent `% NOTE` corrections, FIXED this review**. Minors: stale statement-block `\uses` at L2340 (deferred — plan already flagged SOON); "may be removed" wording on the already-removed `_mvPoly_*` (historical, acceptable). |

Reports: `task_results/lean-auditor-iter154.md`,
`task_results/lean-vs-blueprint-checker-chartalgebra-iter154.md`.

## Blueprint markers updated (manual)

- `RigidityKbar.tex`, `lem:chart_algebra_df_zero_factors_through_constant_on_chart`
  proof-block NOTE (L1934–1943): replaced the stale iter-152 `sorryAx`-laundering
  warning with an iter-154 NOTE recording KDM closed axiom-clean + delegate now
  genuinely `sorryAx`-free (verified).
- `RigidityKbar.tex`, `lem:Scheme_Over_ext_of_diff_zero` NOTE (L2509–2517):
  refreshed the stale iter-147 "KDM still carries a structured sorry" gate to record
  the iter-154 closure (gate lifted).
- No `\mathlibok` added (project proofs, not Mathlib re-exports). No `\leanok`
  touched (sync_leanok domain). No `\lean{...}` rename needed (new helpers private).

## Knowledge Base updates

- **1 new Proof Pattern**: kernel-of-universal-Kähler-derivation = field of constants
  via the single-element / perfect-field / Jacobi–Zariski `H1Cotangent` route (with
  the two analogist-citation corrections: `isLocalizedModule_map` module path =
  `Mathlib.RingTheory.Etale.Kaehler`, needs all four explicit args).
- **2 KDM Known Blockers marked RESOLVED** (the iter-151 "false even inflated" entry
  and the iter-148 entry carrying the iter-153 "FT.3 genuine Mathlib gap" verdict).
  Historical counterexample detail preserved; bright-line lifted.

## Carry-forward for the plan agent (iter-155)

1. **Delete `Cotangent/ChartAlgebraS3.lean` + drop its import** (`ChartAlgebra.lean:6`)
   — both subagents + auditor confirm it is fully orphaned dead scaffolding under
   the alg-closed pivot. Drops global sorry **7 → 3**. A `refactor`-subagent task
   (coordinate the orphaned `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` chapter;
   run blueprint-doctor after).
2. **Next critical-path target: `rigidity_over_kbar`** (`RigidityKbar.lean:88`, M2.a
   keystone) is unblocked by the KDM closure. HARD-GATE its chapter first; confirm
   exactly which sub-pieces remain before dispatching.
3. **`GrpObj.lean` stale-comment cleanup** (auditor major): strip the false
   `NEEDS_MATHLIB_GAP_FILL` on `shearMulRight` + the iter-145-excised piece-(i.b)
   narration; consumer-check the possibly-orphaned support decls.
4. **`RigidityKbar.tex` statement-block `\uses` prune at L2340** (SOON, deferred two
   iters running) — batch with the `constants_in_chart` helper demotion in a
   blueprint-writer round.

## Blueprint doctor

Clean: no orphan chapters, every `\ref`/`\uses` resolves, no `axiom` declarations.
(NOTE: this will change once `ChartAlgebraS3.lean` is deleted — the corresponding
chapter must be handled in the same refactor or the doctor will flag it next iter.)

## Subagent skips

- none — both highly-recommended review subagents (lean-auditor,
  lean-vs-blueprint-checker) were dispatched this phase.
