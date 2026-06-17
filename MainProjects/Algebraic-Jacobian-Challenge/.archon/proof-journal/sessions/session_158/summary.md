# Session 158 — review of iter-158

## Metadata

- **Iteration / session:** 158
- **Prover lane:** single DEEP lane on `AlgebraicJacobian/AbelianVarietyRigidity.lean`, scoped to
  `rigidity_eqOn_dense_open` (the genuine geometric heart of the Rigidity Lemma chain).
- **Global bare-`sorry` declaration count:** 7 → 7 (NET 0). The unit of progress this iter is
  **soundness**, not sorry-count: iter-157's laundered/false keystone became a verified-sound chain.
- **Build:** GREEN (`lake build AlgebraicJacobian.AbelianVarietyRigidity`, 8321 jobs, log line 58).
- **Dispatch vs plan:** the lane **matched the plan** (fired at `rigidity_eqOn_dense_open` as the
  plan prescribed) — the first iter since iter-154 where the dispatch did not contradict PROGRESS.md.
- **Prover activity (`attempts_raw.jsonl`):** 3 edits, 2 goal checks, 3 diagnostic checks, 12 lemma
  searches, 1 build (green). No protected signature touched; no new axioms.

## The headline: iter-157's UNSOUND keystone is REPAIRED

iter-157 landed `rigidity_lemma` as "proven modulo one geometric sorry", but two independent review
subagents found the decomposition **UNSOUND**: `rigidity_core` and `rigidity_eqOn_dense_open` had
**dropped the collapse hypothesis `_hf`** and were FALSE as stated (counterexample `f = fst` on
`X=Y=Z=ℙ¹`), so the "sole remaining geometric sorry" was unsatisfiable — a true headline laundered
through a false lemma.

This iter the plan-phase `refactor thread-hf` re-signed `rigidity_eqOn_dense_open` and `rigidity_core`
to carry `(y₀) (z₀) (_hf)`, and threaded `_hf` through `rigidity_lemma`. **Verified this review:**

- `rigidity_lemma` (L324) carries `_hf` (L334) and passes it to `rigidity_core` (L341).
- `rigidity_core` (L243) carries `_hf` (L253) and passes it to `rigidity_eqOn_dense_open` (L261).
- `rigidity_eqOn_dense_open` (L111) carries `_hf` (L121) and **genuinely consumes it** at L160-161:
  `have hcomp : s ≫ f.left = (toUnit X ≫ z₀).left := by rw [← Over.comp_left]; exact congrArg Over.Hom.left _hf`
  — used inside `hy₀ : y₀pt ∉ Gset` (the load-bearing non-emptiness of Mumford's `V := Y∖G`).

The counterexample `f = fst` is now excluded: under `f = fst`, `_hf` reduces to `𝟙 X = toUnit X ≫ z₀`
(X collapses to a point), so the statement is no longer false-as-stated. The iter-157 must-fix is
closed.

## The genuine forward motion (verified)

### `snd_left_isClosedMap` (NEW helper, L83) — SOLVED, axiom-clean
`IsClosedMap (snd X Y).left.base` for `[IsProper X.hom]`. Proof: `Over.snd_left` rewrites
`(snd X Y).left = Limits.pullback.snd X.hom Y.hom` (EXACT — the monoidal `⊗` on `Over S` is the chosen
pullback), then `IsProper.toUniversallyClosed` + `universallyClosed_isStableUnderBaseChange.of_isPullback
(IsPullback.of_hasPullback X.hom Y.hom)` + `Scheme.Hom.isClosedMap`. **`lean_verify` axioms =
`{propext, Classical.choice, Quot.sound}` (NO `sorryAx`)** — independently re-confirmed this review.
GOTCHA (cost ~20 min): `inferInstance` synthesises `UniversallyClosed (pullback.snd f g)` for abstract
`f g` with bound `[UniversallyClosed f]`, but FAILS for `X.hom`/`Y.hom` from `Over (Spec k)`; must apply
`of_isPullback` explicitly. Will bite any future base-change-of-`X.hom` step.

### `rigidity_eqOn_dense_open` (L111) — PARTIAL: bare sorry → full construction + 2 isolated sorries
The body is now the complete Mumford construction (`U₀, F, G, V, U`, closed-map `G`, open `U`, chosen
`k̄`-point, slice section `s`). Non-emptiness is reduced to a single fact `hfib` and CLOSED modulo it.
Two TRUE-as-stated sorries remain:

1. **`hfib` (L154, inline):** `(snd X Y).left.base ⁻¹' {y₀pt} ⊆ Set.range s.base`. True because `y₀` is a
   section of `Y.hom` ⟹ `κ(y₀pt) = k̄` ⟹ the pullback fibre is `Spec(κ(x) ⊗_{k̄} k̄) = Spec(field) = pt`,
   determined by its `X`-coordinate `= s x`. Needs a BUILT lemma; located API: `Scheme.Pullback.carrierEquiv`,
   `Scheme.Pullback.Triplet`/`.tensor`, `Scheme.Pullback.exists_preimage_of_isPullback` (existence only).
2. **Bridge 2 (L181):** the agreement equation `U.ι ≫ f.left = U.ι ≫ (retract ≫ f).left`. The relative
   "proper + geom-connected fibres into affine ⟹ constant on slices" / Stein-factorisation content.
   Mathlib has the absolute facts (`isField_of_universallyClosed`, `finite_appTop_of_universallyClosed`);
   assembling them into a scheme-morphism equality on `U` is the genuine deep residual.

`lean_verify rigidity_eqOn_dense_open` axioms = `{propext, sorryAx, Classical.choice, Quot.sound}` —
honest transitive sorry, **no custom axioms** — re-confirmed this review.

## Per-file bare-`sorry` tally (re-verified)

- `AbelianVarietyRigidity.lean` — **4 declarations** use sorry: `rigidity_eqOn_dense_open` (2 internal:
  `hfib` L154 + agreement L181), `morphism_P1_to_grpScheme_const` (L366, deferred — theorem of the cube),
  `genusZero_curve_iso_P1` (L390, deferred — Riemann–Roch), `rigidity_genus0_curve_to_grpScheme` (L419,
  headline). `rigidity_lemma`/`rigidity_core`/`rigidity_snd_lift`/`snd_left_isClosedMap` are sorry-free in
  their own bodies (transitively depend on the one honest sorry below them).
- `Jacobian.lean` — **2**: `genusZeroWitness.key` (L265), `positiveGenusWitness` (L303).
- `RigidityKbar.lean` — **1**: `rigidity_over_kbar` (L88, NAMED GAP, fallback route (a)).

## Independent verification (this review)

- `lean_verify snd_left_isClosedMap` → `{propext, Classical.choice, Quot.sound}` (axiom-clean, no sorryAx).
- `lean_verify rigidity_eqOn_dense_open` → `{propext, sorryAx, Classical.choice, Quot.sound}` (honest).
- `_hf` threading + genuine consumption: read directly in the source (L160-161).
- Blueprint doctor: **no structural findings** (all chapters `\input`'d, all refs resolve, no `axiom` decls).

## Review-phase subagents (2 dispatched, both COMPLETE, 0 must-fix)

| Subagent | Slug | Verdict | Headline |
|---|---|---|---|
| `lean-auditor` | iter158 | **0 must-fix** / 2 major / 3 minor | "The iter-158 edits are SOUND — `_hf` is genuinely consumed (prior unsoundness fixed), `snd_left_isClosedMap` is complete, both remaining internal `sorry`s are honest true gaps." 2 majors = stale `.lean` docstrings overstating how much is unbuilt (`rigidity_core` L213-242 still calls BOTH bridges "to be built" — bridge 1 now built; module docstring L21-22 says chain "all scaffolded as sorry" — link 1 now proven). |
| `lean-vs-blueprint-checker` | av-rigidity-iter158 | **0 must-fix** / 1 major / 2 minor | "The iter-157 unsoundness is genuinely repaired — `_hf` threaded through and consumed by all three helpers, `rigidity_core`/`rigidity_lemma` now sorry-free, all 5 `\lean{...}` signatures match." Major = the stale `% NOTE (iter-157 review)` blueprint block (now retired by this review). |

Both independently re-verified the `_hf` consumption (L160-161 → `hy₀` → non-emptiness witness) and
confirmed the `f = fst` counterexample no longer satisfies the antecedent. Reports:
`task_results/lean-auditor-iter158.md`, `task_results/lean-vs-blueprint-checker-av-rigidity-iter158.md`.

The 2 lean-auditor majors are **stale `.lean` docstrings** (review agent cannot edit `.lean`) — routed
to `recommendations.md` for the next prover to fix; both are harmless to correctness (they overstate how
much remains unbuilt, not the reverse).

## Blueprint markers updated (manual)

- `AbelianVarietyRigidity.tex`, proof of `thm:rigidity_lemma`: replaced the stale
  `% NOTE (iter-157 review)` block (which asserted the Lean was UNSOUND / `_hf` DROPPED) with a
  `% NOTE (iter-158 review)` recording that `_hf` is now threaded + consumed, the counterexample is
  excluded, and `rigidity_lemma`/`rigidity_core` are sorry-free with the residual isolated in two
  TRUE-as-stated sorries. Both review subagents flagged the old note as actively misleading.

## Key findings / patterns

- **`Over.snd_left` is the keystone idiom for bridging monoidal `Over S` projections to scheme pullbacks**
  — it makes `(snd X Y).left = pullback.snd X.hom Y.hom` an exact rewrite, letting Mathlib's base-change
  stability lemmas apply directly.
- **Instance-resolution inconsistency:** `inferInstance` finds `UniversallyClosed (pullback.snd f g)` for
  abstract `f g` but not for `X.hom`/`Y.hom` from `Over (Spec k)`; apply `of_isPullback` explicitly.
- **Threading a load-bearing hypothesis through a helper stack is the only honest fix for laundering** —
  the iter-157→158 repair is the canonical example: re-sign every helper to carry `_hf`, then consume it.

## Recommendations for next session

See `recommendations.md`. Headline: do NOT fire another blind prover round on the two residual sorries;
dispatch a `mathlib-analogist` consult scoped to (1) the pullback-fibre lemma and (2) relative
affine-constancy, per the progress-critic's binding iter-158 fallback.
