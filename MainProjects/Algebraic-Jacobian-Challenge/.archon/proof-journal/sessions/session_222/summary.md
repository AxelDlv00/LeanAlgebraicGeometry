# Session 222 — review of iter-222

## Metadata
- **Iteration / session:** 222
- **Lane:** one prover (opus, `mathlib-build`), status **PARTIAL**.
- **Sub-step:** 3 of ~6–12 of the funded Decision-1 sheaf internal-hom block (committed iter-219).
  **elapsed 4 iters; sub-step 3 spans 2 iters (221 slipped → 222).**
- **File touched:** `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` only.
- **Sorry trajectory:** file code sorries **3 → 4**; **project 80 → 81 (net +1)**.
- **Build:** GREEN (`lean_diagnostic_messages` severity=error → no items, no failed deps; re-verified).
- **blueprint-doctor:** CLEAN (no orphans, all `\ref`/`\uses` resolve, no `axiom` decls).
- **sync_leanok:** iter 222, sha `6d8ba509`, **added 1**, removed 0 (`Picard_TensorObjSubstrate.tex`).

## What landed (the math)

iter-221 built the dual object (`PresheafOfModules.dual`) + the per-object evaluation
`internalHomEvalApp` + helpers, but the full natural morphism `internalHomEval` slipped on
`Over.map` pseudofunctor coherence. **iter-222 SOLVED that coherence obstacle** and assembled
the morphism — but the morphism's naturality field is held as a typed `sorry` (see "the
defining tension" below).

Two genuinely-new **axiom-clean** declarations (`#print axioms = {propext, Classical.choice,
Quot.sound}`, re-verified first-hand via `lean_verify`):

1. **`internalHomEvalApp_tmul`** (≈L1421, `@[simp]`, `rfl`) — the value of the contraction on a
   simple tensor `s ⊗ φ ↦ evalLin M X φ s`, with the eval value kept at its NATURAL over-ring
   type (the [[ts-assoc-flatness-gap]] diamond-bridge trick), making it `rfl`-provable.
2. **`restr_map_homMk`** (≈L1434, `private`, `rfl`) — `(restr X.unop N).map (Over.homMk f.unop).op
   = N.map f`, isolating the heavy `Over.map`/`pushforward₀` `whnf` defeq into its own heartbeat
   budget. This is the iter-221 coherence obstacle, solved (for `N` abstract).

The third coherence lemma `dual_map_app_terminal` (`((dual M).map f φ).app term_Y = φ.app (op
(Over.mk f.unop))`, proof = `hom_app_heq` + `congrArg Over.mk (Category.id_comp f.unop)`) is
worked out and axiom-clean in isolation but is **NOT a live decl** — it lives in the
`task_results` handoff, not the compiled file.

## The defining tension — the naturality sorry: progress on the math, +1 on the counter

`internalHomEval` (≈L1449, blueprint `lem:internal_hom_eval`) is now a real `noncomputable def`
whose `app` field is the axiom-clean `internalHomEvalApp` and whose `naturality` field is a typed
`sorry` (`#print axioms` includes `sorryAx`, confirmed). This is the FIRST time in the funded
build (iters 219–222) that the project sorry counter moved UP: iters 219–221 honoured the
no-sorry invariant by keeping the morphism **absent** until it could be proven; iter-222 instead
landed the def with a stubbed naturality.

Two honest reads, both true:
- **Math progress is real.** The iter-221 blocker ("blocked on `Over.map` coherence") is gone:
  the coherence is solved (`restr_map_homMk`, `dual_map_app_terminal`, axiom-clean), the
  `tensor_ext` reduction to the per-section goal `G` is verified, and the remaining obstacle is
  purely **elaboration cost** — a `whnf` heartbeat bomb (>3.2M heartbeats, ~exponential) localized
  to instantiating the `rfl`-bridge at the concrete unit `𝟙_`, whose `whnf` normal form is
  enormous. Three concrete whnf-free fixes are recorded (generalize the unit; use Mathlib
  `pushforward_obj_map_apply'` for syntactic matching; close `G` elementwise).
- **The counter regressed.** A blueprint-pinned critical-path decl now carries a sorry that
  iters 219–221 deliberately avoided. It is honestly flagged (both the Lean docstring and the
  blueprint `% NOTE:` acknowledge the open obligation; the blueprint does NOT overclaim — the
  statement-block `\leanok` is sync's correct "declaration formalized at ≥1 sorry" marker, the
  proof block has no `\leanok`). It is also **not load-bearing** in the code-graph: `lean-auditor
  ts222` confirms nothing downstream consumes it yet. So it is a process/bookkeeping deviation,
  not a math fabrication — but iter-223 MUST close it (sorry should return 81→80).

This is NOT the iter-214 d.1 anti-pattern (pinning/forwarding a `dual`-shaped helper-sorry to
launder `exists_tensorObj_inverse`): the sorry is on the genuine target morphism, the worked
proof is preserved out-of-source, and the obstacle is precisely localized. But it sits one notch
closer to that pattern than iters 219–221 did, and the watch item below reflects that.

## Tooling note (session-level)
The prover reported a persistent LSP/Bash output lag (results returned in large delayed batches),
which inflated each edit→compile→read cycle to minutes and contributed to stopping with the sorry
in place. This is an environment factor, not a math obstacle — flagged so the next iter is not
mis-read as "the math is harder than it is."

## Review subagents (both 0 must-fix)
- **lean-auditor ts222** (`logs/iter-222/lean-auditor-ts222-report.md`): 0 must-fix; 2 major
  (stale file header `## Status` L37–47 still says 3 sorries vs actual 4; `internalHomEval`
  carries a sorry on a blueprint-pinned decl — honestly flagged, must resolve before
  `exists_tensorObj_inverse`); 2 minor (`restr_map_homMk` fragile `rfl`; "to keep the build
  GREEN" borderline phrasing). Confirmed NO large worked-proof comment block left in source (it
  was correctly moved to task_results).
- **lean-vs-blueprint-checker ts222** (`logs/iter-222/lean-vs-blueprint-checker-ts222-report.md`):
  0 must-fix; pin `\lean{PresheafOfModules.internalHomEval}` correct, no overclaim. 3 major:
  (1) the `lem:internal_hom_eval` proof sketch is **under-specified for the whnf fix** — the 3
  concrete tactic routes live in task_results, not the blueprint, so a prover guided by the
  chapter alone knows WHAT but not HOW to avoid the bomb; (2) `\leanok`-without-`\lean{...}` on
  `lem:islocallyinjective_whisker_of_W` and `lem:isiso_sheafification_map_of_W`; (3) missing
  `\leanok` on axiom-clean blocks (`lem:tensorobj_unit_iso`, `lem:presheaf_pushforward_adj_substrate`,
  `lem:restrictscalars_ringiso_strongmonoidal`) — likely a `sync_leanok` parse gap on the
  multi-pin `\lean{..., ...}` form.

## Blueprint markers updated (manual)
- None. The statement-block `\leanok` on `lem:internal_hom_eval` was added by the deterministic
  `sync_leanok` (correct: the decl now exists with ≥1 sorry); no proof-block `\leanok` (correct).
  No `\mathlibok` warranted (no Mathlib re-exports added). The `\lean{...}` pin is already correct.
  No stale `\notready` on the touched blocks. The checker's missing-`\lean{...}`-pin items are
  plan-agent/blueprint-writer territory (new hints, not rename corrections), so left for the plan
  phase — see recommendations.

## Recommendations (full list in `recommendations.md`)
1. **HIGH — close the `internalHomEval` naturality sorry** (tame the whnf bomb via one of the 3
   recorded routes; reduction is done). Single most-converging target; returns sorry 81→80.
2. **HIGH (blueprint gate) — blueprint-writer: enrich `lem:internal_hom_eval` proof sketch** with
   the whnf obstacle + 3 fixes before re-dispatching the prover (lvb major #1).
3. **MEDIUM — fold the stale-header fix (3→4 sorry) into the next prover directive** as a
   ride-along comment edit (auditor major #1; review cannot edit `.lean`).
4. **MEDIUM — fix `sync_leanok` pin gaps** (missing `\lean{...}` on whisker/sheafification blocks;
   multi-pin `\lean{..., ...}` not tracked) so the frontier stops under-reporting.
