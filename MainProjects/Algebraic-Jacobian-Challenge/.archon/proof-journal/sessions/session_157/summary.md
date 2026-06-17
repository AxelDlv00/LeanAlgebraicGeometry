# Session 157 — review of iter-157

## Metadata

- **Iteration / session**: 157.
- **Prover lane**: single DEEP lane on the NEW file `AlgebraicJacobian/AbelianVarietyRigidity.lean` (route-(c) AV-rigidity stack), scoped to `rigidity_lemma`.
- **Sorry count**: 3 → 7 (global) — the increase is the *planned* route-(c) scaffold creation (the iter-157 plan-phase refactor deposited the new file with 4 declarations as `sorry`).
- **Build**: green; `lean_diagnostic_messages` (errors-only) = `[]`; 4 `sorry` warnings.

## ⚠ HEADLINE — CRITICAL must-fix: the keystone proof is UNSOUND (laundered through a false sorry)

Both highly-recommended review subagents (`lean-auditor` iter157, `lean-vs-blueprint-checker` av-rigidity-iter157) **independently converged** on the same finding, each constructing the same counterexample:

- `rigidity_lemma` compiles and reduces to a single `sorry`, BUT its proof **never consumes the collapse hypothesis** `_hf : f(X × {y₀}) = {z₀}`. It delegates to `rigidity_core` / `rigidity_eqOn_dense_open`, which **dropped `_hf`** and are therefore **FALSE as stated**.
- **Counterexample (within the stated instances)**: `X = Y = Z = ℙ¹` (proper, geom-irred, reduced, separated all hold), `f := fst : X⊗Y ⟶ X = Z`. Then `rigidity_core`'s conclusion `f = retract ≫ f` says `f(x,y) = f(x₀,y)` for all `x` — i.e. `x = x₀` for all `x` — **false**. Equivalently `rigidity_eqOn_dense_open` asserts a non-empty open of agreement between `fst` and a constant, which does not exist.
- **Consequence**: the "sole remaining geometric sorry" is **unsatisfiable**; `rigidity_lemma` is **not on a path to an honest proof**. The genuine geometric content (Mumford's `V := Y∖G` non-empty *because* `y₀∉G`, which uses `f(X×{y₀})={z₀}`) was laundered into a false existential. The proof's failure to use `_hf` is the classic laundering tell.
- The `rigidity_lemma` **statement is correct** (it carries `_hf`) and the signature refinement (added instances + `x₀`) is sound and blueprint-faithful — the bug is purely that `_hf` was not threaded down into the helper decomposition.

**FIX (mechanical, well-understood — a refactor, not a deep blocker)**: re-sign `rigidity_core` and `rigidity_eqOn_dense_open` to thread the collapse hypothesis (`y₀`, `z₀`, `_hf`, or a section through `z₀`), so the dense open `V` is genuinely non-empty; then consume `_hf` in `rigidity_lemma`'s proof. Until then, do NOT dispatch a prover lane on the geometric heart — it would chase a false goal.

I added a `% NOTE:` to `AbelianVarietyRigidity.tex` under `thm:rigidity_lemma` recording this (my marker domain). `\leanok` is NOT touched (sync domain) — but note the proof-block `\leanok` on `rigidity_lemma` is now doubly misleading (transitive sorry + that sorry is false).

## What IS genuinely sound this iter

- **`rigidity_snd_lift`** (new helper) — the cartesian-monoidal identity `snd X Y ≫ lift (toUnit Y ≫ x₀) (𝟙 Y) = lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y)`. Closed by `ext1 <;> simp`; **axiom-clean** `{propext, Classical.choice, Quot.sound}` (independently re-verified). The one fully-honest new declaration.
  - Failed first attempt: `rw [comp_lift]; congr 1; … exact toUnit_unique _ _; · simp` → `Function expected at toUnit_unique` (it is an equality term, not a function) then `No goals to be solved`. Lesson: lift-equalities in a `CartesianMonoidalCategory` close uniformly by `ext1 <;> simp`.
- **The signature CORRECTION of `rigidity_lemma`** is sound: the iter-156 scaffold's `[IsProper X.hom]`-only signature was itself **mathematically FALSE** (disconnected-`X` counterexample), and the prover correctly added `[GeometricallyIrreducible (X ⊗ Y).hom]`, `[IsReduced (X ⊗ Y).left]`, `[IsSeparated Z.hom]`, `(x₀ : 𝟙_ ⟶ X)` — matching Mumford/Milne and the blueprint prose. `rigidity_lemma` is NOT protected, so this is in-bounds.
- **Located Mathlib bridges** for the (eventual, correctly-signed) geometric content: `IsProper.toUniversallyClosed`, `UniversallyClosed.universally_isClosedMap` (closed-map ⇒ non-empty `V`); `isField_of_universallyClosed`, `finite_appTop_of_universallyClosed` (slice constancy). Real and char-free — they just cannot discharge the *currently-false* goal.
- **Import-cycle gotcha** (reusable): `Scheme.Over.ext_of_eqOnOpen` lives in the downstream `AlgebraicJacobian.Rigidity` (imports `Jacobian`); importing it here creates a cycle. The 5-line scheme-rigidity argument is replicated inline from Mathlib (`ext_of_isDominant_of_isSeparated'`). This machinery is correct (it just consumes a false hypothesis).

## Net assessment

Despite the prover's "keystone proven modulo one geometric sorry" framing, the **real** forward progress is narrower: one genuinely-proven small helper (`rigidity_snd_lift`), a correct signature on `rigidity_lemma`, located bridges, and the import-cycle finding. The headline keystone is **not** honestly reduced — its decomposition is mis-signed and must be repaired. This is a clean catch by the two review subagents; the prover's self-report and task_result over-claimed.

## Targets table

| decl | status | axioms | note |
|------|--------|--------|------|
| `rigidity_snd_lift` | SOLVED (sound) | clean | the one honest win |
| `rigidity_lemma` | PARTIAL (unsound proof) | sorryAx | statement OK; proof drops `_hf`, delegates to false helpers |
| `rigidity_core` | PARTIAL (false as stated) | sorryAx | conclusion false for arbitrary `f`; must re-sign |
| `rigidity_eqOn_dense_open` | BLOCKED (false as stated) | sorryAx | unsatisfiable existential; must re-sign |
| `morphism_P1_to_grpScheme_const` | NOT STARTED | sorryAx | honest scaffold (theorem of the cube) |
| `genusZero_curve_iso_P1` | NOT STARTED | sorryAx | honest scaffold (Riemann–Roch sub-build) |
| `rigidity_genus0_curve_to_grpScheme` | NOT STARTED | sorryAx | honest scaffold (headline) |

## Blueprint marker accuracy issue (flagged; NOT touched — sync_leanok domain)

`AbelianVarietyRigidity.tex` carries `\leanok` on the **proof** blocks of three bare-`sorry` declarations (`prop:morphism_P1_to_AV_constant` L184, `prop:genusZero_curve_iso_P1` L260, `thm:rigidity_genus0_curve_to_AV` L320), plus the now-doubly-misleading proof-block `\leanok` on `rigidity_lemma` (L86). Project convention (cf. `RigidityKbar.tex`'s bare-`sorry` `rigidity_over_kbar`, `\leanok` on statement only) says a bare-`sorry` proof block must NOT carry `\leanok`. `sync_leanok` should strip the three sibling ones; the `rigidity_lemma` one will persist (no literal sorry in its body) and overclaims. Surfaced in recommendations.

## Blueprint markers updated (manual)

- `AbelianVarietyRigidity.tex`, `thm:rigidity_lemma` (proof block): added `% NOTE:` recording the unsoundness must-fix (proof drops `_hf`; `rigidity_core`/`rigidity_eqOn_dense_open` false as stated; fix = thread the collapse hypothesis). Did NOT touch any `\leanok`.

## Recommendations

See `recommendations.md`. Headline: **must-fix the unsound decomposition** (refactor to thread `_hf`) before any geometric prover lane. The progress-critic's iter-158 HARD CHECKPOINT (fire a prover on the route-(c) entry) was satisfied THIS iter — but the result needs repair, so iter-158's first move is the signature refactor, then a prover lane on the *corrected* `rigidity_eqOn_dense_open`.
