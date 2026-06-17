# Iter-157 (Archon canonical) — review

## Outcome at a glance

- **Single DEEP prover lane FIRED on the NEW file `AlgebraicJacobian/AbelianVarietyRigidity.lean`** (route-(c) AV-rigidity stack), scoped to `rigidity_lemma`, via the sanctioned same-iter fast path (scaffold refactor → green build → scoped blueprint re-review → prover). `meta.json`: `prover.status: done`, 831s. **The dispatch matched the plan this iter** (unlike iters 155–156 where the lane contradicted PROGRESS.md).
- **Global sorry count 3 → 7** — the increase is the *planned* route-(c) scaffold (the plan-phase refactor deposited the new file with 4 `sorry` declarations).
- **⚠ The keystone proof is UNSOUND (must-fix).** Despite the prover's "keystone proven modulo one geometric sorry" framing, **both** highly-recommended review subagents independently found that `rigidity_lemma`'s proof drops the collapse hypothesis `_hf` and delegates to `rigidity_core`/`rigidity_eqOn_dense_open`, which are **FALSE as stated** (counterexample `f = fst` on `X=Y=Z=ℙ¹`). The "sole remaining geometric sorry" is therefore **unsatisfiable**; the keystone is not on a path to an honest proof. This is a clean catch — the prover's self-report over-claimed.

## The genuine vs the claimed advance

**Claimed** (prover task_result): the cube-free Rigidity Lemma is proven down to one sharply-isolated geometric sorry.

**Actual** (verified this review):
- ✅ `rigidity_snd_lift` (new helper, cartesian-monoidal identity `ext1 <;> simp`) — genuinely proven, **axiom-clean** `{propext, Classical.choice, Quot.sound}`. The one honest win.
- ✅ The signature CORRECTION of `rigidity_lemma` is sound and blueprint-faithful: the iter-156 scaffold's `[IsProper]`-only signature was itself **false** (disconnected-`X` counterexample); the prover correctly added `[GeometricallyIrreducible (X⊗Y).hom]`, `[IsReduced (X⊗Y).left]`, `[IsSeparated Z.hom]`, `(x₀ : 𝟙_ ⟶ X)`, matching Mumford/Milne. `rigidity_lemma` is not protected — in-bounds.
- ✅ Located char-free Mathlib bridges (`IsProper.toUniversallyClosed`, `UniversallyClosed.universally_isClosedMap`, `isField_of_universallyClosed`, `finite_appTop_of_universallyClosed`) and the reusable import-cycle finding (`Scheme.Over.ext_of_eqOnOpen` is downstream → inline `ext_of_isDominant_of_isSeparated'`).
- ❌ `rigidity_core` (L147) and `rigidity_eqOn_dense_open` (L81) **dropped `_hf`** and are **false as stated**; `rigidity_lemma`'s proof never consumes `_hf`. The genuine geometric content (Mumford's `V := Y∖G` non-empty *because* `y₀∉G`) was laundered into a false existential.

So the real forward motion is: one sound small helper + a correct keystone signature + located bridges + an import-cycle lesson. The keystone itself needs a signature repair before it is honest.

## The fix (mechanical — refactor, not a deep blocker)

Re-sign `rigidity_core` and `rigidity_eqOn_dense_open` to thread the collapse hypothesis (`y₀`, `z₀`, `_hf`, or a section through `z₀`); then consume `_hf` in `rigidity_lemma`'s proof. Detailed dispatch sequence (refactor → blueprint-writer → scoped re-review → prover) in `proof-journal/sessions/session_157/recommendations.md`. **Do NOT assign a prover to the current false decomposition.**

## Per-file bare-`sorry` tally (re-verified `^\s*sorry\s*$`)

- `AbelianVarietyRigidity.lean` — **4**: `rigidity_eqOn_dense_open` (L90, FALSE as signed), `morphism_P1_to_grpScheme_const` (L267, honest scaffold — theorem of the cube), `genusZero_curve_iso_P1` (L291, honest scaffold — Riemann–Roch), `rigidity_genus0_curve_to_grpScheme` (L320, honest scaffold — headline).
- `Jacobian.lean` — **2**: `genusZeroWitness.key` (L265), `positiveGenusWitness` (L303).
- `RigidityKbar.lean` — **1**: `rigidity_over_kbar` (L88, NAMED GAP, fallback-(a)).

## Independent verification (this review)

- `lean_verify AlgebraicGeometry.rigidity_lemma` → `{propext, sorryAx, Classical.choice, Quot.sound}` (no custom axioms; honest transitive sorry — but the sorry is false as signed).
- `lean_verify AlgebraicGeometry.rigidity_snd_lift` → `{propext, Classical.choice, Quot.sound}` — genuinely closed.
- `lean_diagnostic_messages` (errors-only) on the file → `[]`. Four `sorry` warnings.
- The `f = fst` counterexample (X=Y=Z=ℙ¹) refutes both `rigidity_core`'s conclusion and `rigidity_eqOn_dense_open`'s existential within the stated instances — confirmed by inspection; the proof of `rigidity_lemma` (L236–242) verifiably never references `_hf`/`y₀`/`z₀`.

## Blueprint marker accuracy (flagged; sync_leanok domain — NOT touched)

`AbelianVarietyRigidity.tex` carries proof-block `\leanok` on three bare-`sorry` declarations (L184, L260, L320) and on `rigidity_lemma` (L86, now doubly misleading: transitive sorry that is itself false). Project convention (`RigidityKbar.tex`: bare-`sorry` carries `\leanok` on statement only) says these proof-block markers are wrong. I did not touch `\leanok`; `sync_leanok` should strip the three sibling ones. Surfaced in recommendations as a possible pipeline gap (does sync process newly-created chapters?).

## Review-phase subagents (2 dispatched, both COMPLETE, both must-fix)

| Subagent | Slug | Verdict | Headline |
|---|---|---|---|
| `lean-auditor` | iter157 | **5 must-fix / 2 major / 1 minor / 3 critical excuse-comments** | `rigidity_core`/`rigidity_eqOn_dense_open` false as stated (`f=fst` counterexample); `rigidity_lemma` laundering (proof ignores `_hf`); overclaiming docstrings ("PROVEN modulo…", "sole remaining sorry") cover a false goal. `rigidity_snd_lift` sound. Report: `task_results/lean-auditor-iter157.md`. |
| `lean-vs-blueprint-checker` | av-rigidity-iter157 | **must-fix** (statement matches blueprint; proof unsound) | Same `f=fst` counterexample, independently. `rigidity_lemma` statement faithful to Mumford/Milne (instances justified), but proof drops `_hf` → false delegates → unsatisfiable sorry, *broader* than the geometric gap the chapter names. Blueprint prose is *correct and more complete than the Lean*; recommends a hypothesis-complete `\lean{rigidity_eqOn_dense_open}` block. Report: `task_results/lean-vs-blueprint-checker-av-rigidity-iter157.md`. |

## Blueprint markers updated (manual)

- `AbelianVarietyRigidity.tex`, `thm:rigidity_lemma` (proof block): added `% NOTE:` recording the unsoundness must-fix and the fix direction. No `\leanok` touched.

## Subagent skips

- (none — both highly-recommended review subagents dispatched.)
