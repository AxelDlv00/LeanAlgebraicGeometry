# Iter-158 (Archon canonical) — review

## Outcome at a glance

- **The soundness-repair iter.** iter-157 landed `rigidity_lemma` as "proven modulo one geometric
  sorry", but the iter-157 review (two independent subagents) found the decomposition **UNSOUND**:
  `rigidity_core` and `rigidity_eqOn_dense_open` had **dropped the collapse hypothesis `_hf`** and
  were FALSE as stated (counterexample `f = fst` on `X=Y=Z=ℙ¹`, all instances satisfied), so the
  "sole remaining geometric sorry" was unsatisfiable — a true headline laundered through a false
  lemma. **This iter that must-fix is CLOSED.**
- **Dispatch MATCHED the plan** — the lane fired at `rigidity_eqOn_dense_open` exactly as PROGRESS.md
  prescribed. First iter since iter-154 with no plan/dispatch contradiction (iters 155–156 both fired
  on `Jacobian.lean` against the plan).
- **Global bare-`sorry` count 7 → 7 (NET 0).** The unit of progress is **soundness**, not count:
  a false/laundered chain became a verified-sound one with all residual geometry isolated in two
  TRUE-as-stated sorries.
- Per-file tally (re-verified): `AbelianVarietyRigidity.lean` 4 sorry-bearing decls
  (`rigidity_eqOn_dense_open` with 2 internal: `hfib` L154 + agreement L181; plus the 3 deferred
  scaffolds L366/L390/L419); `Jacobian.lean` 2 (L265, L303); `RigidityKbar.lean` 1 (L88).
- Prover activity (`attempts_raw.jsonl`): 3 edits, 2 goal checks, 3 diagnostic checks, 12 lemma
  searches, 1 build (green). No protected signature touched; no new axioms.

## The repair (headline, independently verified)

The plan-phase `refactor thread-hf` re-signed `rigidity_eqOn_dense_open` (L111) and `rigidity_core`
(L243) to carry `(y₀)(z₀)(_hf)`, and threaded `_hf` through `rigidity_lemma` (L324). Verified this
review by reading the source AND confirmed by both review subagents:

- `rigidity_lemma` L334 carries `_hf`, passes to `rigidity_core` (L341).
- `rigidity_core` L253 carries `_hf`, passes to `rigidity_eqOn_dense_open` (L261).
- `rigidity_eqOn_dense_open` L121 carries `_hf`, **genuinely consumes it** at L160-161:
  `have hcomp : s ≫ f.left = (toUnit X ≫ z₀).left := by rw [← Over.comp_left]; exact congrArg Over.Hom.left _hf`
  — used in `hy₀ : y₀pt ∉ Gset` (L156-166), the load-bearing non-emptiness of Mumford's `V := Y∖G`.

Soundness sanity: under `f = fst`, `_hf` reduces to `𝟙 X = toUnit X ≫ z₀` (X collapses to a point),
so the iter-157 counterexample no longer satisfies the antecedent. `lean_diagnostic_messages`
confirms NO sorry warning on `rigidity_core` (L243) or `rigidity_lemma` (L324) — both close fully
modulo the one deferred helper.

## The genuine forward motion

- **`snd_left_isClosedMap` (NEW helper, L83) — SOLVED, axiom-clean.** `IsClosedMap (snd X Y).left.base`
  for `[IsProper X.hom]`, via `Over.snd_left` (exact rewrite `(snd X Y).left = pullback.snd X.hom Y.hom`)
  + `IsProper.toUniversallyClosed` + `universallyClosed_isStableUnderBaseChange.of_isPullback
  (IsPullback.of_hasPullback X.hom Y.hom)` + `Scheme.Hom.isClosedMap`. `lean_verify` =
  `{propext, Classical.choice, Quot.sound}` (no `sorryAx`). This is "bridge 1" of the chain — now BUILT.
- **`rigidity_eqOn_dense_open` (L111) — bare sorry → full Mumford construction + 2 isolated sorries.**
  The construction (`U₀, F, G, V, U`, closed-map `G`, open `U`, k̄-point, slice section `s`) is wired
  and builds green; non-emptiness is closed modulo `hfib`. Two TRUE-as-stated residual sorries:
  1. `hfib` (L154): `(snd X Y).left.base ⁻¹' {y₀pt} ⊆ Set.range s.base` — needs a BUILT pullback-fibre
     lemma (located API: `Scheme.Pullback.carrierEquiv`/`Triplet`/`exists_preimage_of_isPullback`).
  2. Bridge 2 (L181): the agreement equation — relative "proper-into-affine is constant" /
     Stein-factorisation content (located absolute facts: `isField_of_universallyClosed`,
     `finite_appTop_of_universallyClosed`; the relative assembly is the genuine deep residual).

## Review-phase subagents (2 dispatched, both COMPLETE, 0 must-fix)

| Subagent | Slug | Verdict | Headline |
|---|---|---|---|
| `lean-auditor` | iter158 | **0 must-fix** / 2 major / 3 minor | "The iter-158 edits are SOUND — `_hf` genuinely consumed (prior unsoundness fixed), `snd_left_isClosedMap` complete, both internal `sorry`s honest true gaps." 2 majors = stale `.lean` docstrings overstating how much is unbuilt (`rigidity_core` L213-242; module L21-22). |
| `lean-vs-blueprint-checker` | av-rigidity-iter158 | **0 must-fix** / 1 major / 2 minor | "iter-157 unsoundness genuinely repaired; `rigidity_core`/`rigidity_lemma` now sorry-free; all 5 `\lean{}` signatures match." Major = the stale `% NOTE (iter-157 review)` block (retired this review). |

Both independently re-traced the `_hf` consumption and the counterexample exclusion. The 2 lean-auditor
majors are stale `.lean` docstrings (review agent cannot edit `.lean`) → routed to recommendations.md
for the next prover; harmless to correctness (overstate, not understate, what remains).

## Blueprint markers updated (manual)

- `AbelianVarietyRigidity.tex`, proof of `thm:rigidity_lemma`: replaced the stale
  `% NOTE (iter-157 review)` block (asserting the Lean was UNSOUND / `_hf` DROPPED / "never consumes
  `_hf`") with `% NOTE (iter-158 review)` recording the repair. Both review subagents flagged the old
  note as actively misleading.

## Independent verification

- `lean_verify snd_left_isClosedMap` → `{propext, Classical.choice, Quot.sound}` (axiom-clean).
- `lean_verify rigidity_eqOn_dense_open` → `{propext, sorryAx, Classical.choice, Quot.sound}` (honest).
- `_hf` threading + consumption read directly in source (L160-161, L253/261, L334/341).
- Build green (`lake build AlgebraicJacobian.AbelianVarietyRigidity`, log line 58).
- Blueprint doctor (iter-158): no structural findings.

## Recommendation for iter-159 (progress-critic binding fallback)

Do NOT fire a blind prover round on `hfib` / bridge 2. Dispatch a `mathlib-analogist` consult scoped
to the two BUILT lemmas (pullback-fibre over a k̄-point; relative affine-constancy), both with located
Mathlib entry points (see `recommendations.md`). Also: next prover on `AbelianVarietyRigidity.lean`
should fix the 2 stale docstrings flagged by `lean-auditor`.
