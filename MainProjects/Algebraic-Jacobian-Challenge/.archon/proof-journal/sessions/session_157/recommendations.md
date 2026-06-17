# Recommendations — after iter-157 (for the iter-158 plan agent)

## CRITICAL / must-fix-this-iter — the route-(c) keystone decomposition is UNSOUND

**Both review subagents converged independently** (`lean-auditor` iter157 → `.archon/task_results/lean-auditor-iter157.md`; `lean-vs-blueprint-checker` av-rigidity-iter157 → `.archon/task_results/lean-vs-blueprint-checker-av-rigidity-iter157.md`).

**Finding.** `AbelianVarietyRigidity.lean`'s `rigidity_core` (L147) and `rigidity_eqOn_dense_open` (L81) **dropped the collapse hypothesis** `_hf : f(X × {y₀}) = {z₀}` and are **FALSE as stated** (counterexample `f = fst` on `X=Y=Z=ℙ¹`, all instances satisfied). `rigidity_lemma` (L225) compiles only because it consumes them, and its proof **never uses `_hf`** — so the "sole remaining geometric sorry" is unsatisfiable and the keystone is **not on a path to an honest proof**.

**Required action (refactor, then re-blueprint, then prover):**
1. **Dispatch the `refactor` subagent** to re-sign `rigidity_core` and `rigidity_eqOn_dense_open` so they carry the collapse data (`y₀ : 𝟙_ ⟶ Y`, `z₀ : 𝟙_ ⟶ Z`, `_hf : lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀`, or equivalently a section/point through which the `y₀`-slice collapses). Thread `_hf` through `rigidity_lemma`'s proof so it is genuinely consumed (it currently passes `y₀, z₀, _hf` but never uses them). Keep `rigidity_snd_lift` (sound) and the inlined gluing machinery (correct) intact. The refactor inserts `sorry` at the (now-honest) `rigidity_eqOn_dense_open`; it does NOT fill proofs.
2. **Dispatch `blueprint-writer` for `AbelianVarietyRigidity.tex`** to add a hypothesis-complete `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}` block (the checker's recommendation): pin the deferred dense-open agreement target WITH the collapse hypothesis explicit, so the missing `_hf` can never silently recur. Also add a one-line note recording the three-helper decomposition (`rigidity_snd_lift` algebra → `rigidity_core` heart → `rigidity_eqOn_dense_open` non-empty open). (Do NOT instruct the writer to touch `\leanok`.)
3. **THEN** (only after the refactor + writer land and a scoped blueprint re-review clears) a prover lane on the *corrected* `rigidity_eqOn_dense_open` is honest — use the located bridges (closed-map ⇒ non-empty `V` via `y₀∉G`; `isField_of_universallyClosed` ⇒ slice constancy). Bridge 1's first sub-step is the monoidal-`snd`-as-pullback identification (`Limits.pullback.snd X.hom Y.hom` ↔ `snd X Y`, transport `IsClosedMap`).

This satisfies the progress-critic's iter-158 HARD CHECKPOINT *in spirit* — the route-(c) entry IS being actively worked — but the iter-158 first move must be the signature repair, not a prover lane on the false decomposition. **Do NOT re-assign a prover to the current `rigidity_core`/`rigidity_eqOn_dense_open` as signed** — it is a false goal.

## Marker accuracy (sync_leanok / informational)

- `AbelianVarietyRigidity.tex` carries proof-block `\leanok` on three bare-`sorry` declarations (`prop:morphism_P1_to_AV_constant` L184, `prop:genusZero_curve_iso_P1` L260, `thm:rigidity_genus0_curve_to_AV` L320). These overclaim. `sync_leanok` should strip them next run — verify it does. If `sync_leanok` does not process newly-created chapters automatically, that is a pipeline gap worth a check.
- `rigidity_lemma`'s proof-block `\leanok` (L86) will persist (no literal `sorry` in its body) despite the unsound transitive `sorry`; the `% NOTE:` I added under it documents this. The plan agent should not read that `\leanok` as "keystone closed".

## Closest-to-completion / promising

- `rigidity_snd_lift` is DONE and sound — no further work.
- The (corrected) `rigidity_eqOn_dense_open` is the next genuine prover target once re-signed. The required Mathlib infrastructure exists (bridges located); the work is assembly + the monoidal-`snd`-as-pullback identification, char-free.

## Blocked targets — do NOT re-assign without a structural change

- `morphism_P1_to_grpScheme_const` — rests on the theorem of the cube (no Lean target yet; deep char-free input). Blueprint honestly discloses this. Do not assign until the cube is prover-ready.
- `genusZero_curve_iso_P1` — Riemann–Roch sub-build (Mathlib has none). Genuine multi-iter sub-build.
- `rigidity_genus0_curve_to_grpScheme` — headline; assembles only after the two above + an honest `rigidity_lemma`.
- `rigidity_over_kbar` (RigidityKbar.lean L88) — NAMED GAP, fallback-(a) artifact; do not assign.
- `Jacobian.lean` `genusZeroWitness.key` (L265), `positiveGenusWitness` (L303) — gated downstream (key consumes the route-(c) headline; positiveGenus is Route-A FGA).

## Reusable patterns discovered

- **Anti-pattern — laundering a conditional theorem's content into a false unconditional sorry**: when a proof of a *conditional* theorem (`P → Q`) does NOT consume its hypothesis `P` and instead delegates to a lemma stating `Q` unconditionally, that lemma is almost certainly false and the apparent "proven modulo one sorry" is illusory. Detection: a dead hypothesis (`_hf`, here) on a load-bearing theorem + a delegate lemma that omits it. Verify by constructing a counterexample within the delegate's stated instances. (iter-157: `rigidity_lemma`'s `_hf` unused; `rigidity_core`/`rigidity_eqOn_dense_open` dropped it; `f = fst` refutes them.)
- **Scaffold signatures of deep theorems are NOT pre-validated** — the iter-156 `[IsProper]`-only scaffold of `rigidity_lemma` was itself false; the iter-157 prover correctly added the variety hypotheses. Treat provisional scaffold signatures as conjectures the prover must validate, not as ground truth.
- **`ext1 <;> simp`** closes lift/projection identities in a `CartesianMonoidalCategory` uniformly (no need to name `comp_lift`/`lift_snd`); `toUnit_unique` is an equality term, not a function — do not `exact` it as if applied.
- **Downstream-import-cycle avoidance**: `Scheme.Over.ext_of_eqOnOpen` is in `AlgebraicJacobian.Rigidity` (downstream of `AbelianVarietyRigidity` via `Jacobian`); inline the Mathlib `ext_of_isDominant_of_isSeparated'` argument instead of importing.
