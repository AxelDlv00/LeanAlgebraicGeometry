# Lean Audit Report

## Slug
iter157

## Iteration
157

## Scope
- files audited: 1 — `AlgebraicJacobian/AbelianVarietyRigidity.lean` (per directive; this is the only file that received prover work this iter)
- files skipped (per directive): rest of project — directive narrowed scope to the newly-created file.

## Per-file checklist

### AlgebraicJacobian/AbelianVarietyRigidity.lean
- **outdated comments**: none
- **suspect definitions**: 1 flagged — `rigidity_core` / `rigidity_eqOn_dense_open` conclusion is **false as stated** (missing hypothesis).
- **dead-end proofs**: 1 flagged — `rigidity_lemma`'s proof routes through the false `rigidity_core` and never uses its own collapse hypothesis `_hf`.
- **bad practices**: 1 flagged — dead hypotheses `y₀`, `z₀`, `_hf` on `rigidity_lemma` (proof ignores them).
- **excuse-comments**: none verbatim, but see overclaiming docstrings under Must-fix.
- **notes**:
  - **Compile/axiom facts (verified via LSP).** Only four `sorry` warnings: lines 81 (`rigidity_eqOn_dense_open`), 258, 282, 307. `rigidity_lemma` (225), `rigidity_core` (147), `rigidity_snd_lift` (64) compile with no `sorry` warning. `lean_verify`: `rigidity_snd_lift` is `sorryAx`-free (genuinely proven); `rigidity_core` and `rigidity_lemma` carry `sorryAx` (only via `rigidity_eqOn_dense_open`) plus the standard `propext/Classical.choice/Quot.sound`. So the chain is `rigidity_lemma ← rigidity_core ← rigidity_eqOn_dense_open` with the latter the sole gap — *as advertised mechanically*. The problem is mathematical, not mechanical.
  - **THE CORE PROBLEM (line 147, 81).** Verified goal of `rigidity_core` (line 156): hypotheses are `[IsProper X.hom] [GeometricallyIrreducible (X⊗Y).hom] [IsReduced (X⊗Y).left] [IsSeparated Z.hom]`, an *arbitrary* `f : X⊗Y ⟶ Z`, an *arbitrary* point `x₀`, and goal `f = lift (toUnit (X⊗Y) ≫ x₀) (snd X Y) ≫ f`. That goal says `f(x,y) = f(x₀,y)` for all `x` — i.e. **`f` is independent of the `X`-coordinate, for every `f`**. This is FALSE. Counterexample within the stated instances: `X = Y = Z = ℙ¹` (proper, geom-irred, reduced, separated all hold) and `f = fst : X⊗Y ⟶ X(=Z)` the first projection; then `retract ≫ f = (x,y) ↦ x₀ ≠ (x,y) ↦ x = f`. Equally, `Y = 𝟙_`, `f = id : X ⟶ X` gives `id = const_{x₀}`, false. Mumford's Rigidity Lemma is simply false without the rigidifying hypothesis `f(X×{y₀}) = {z₀}`; that hypothesis is exactly what makes the dense open `V` non-empty in his proof.
  - Consequently `rigidity_eqOn_dense_open` (line 81) — which asserts, with **no** collapse hypothesis, that there EXISTS a *non-empty* open `U` on which `f.left = (retract ≫ f).left` — is also FALSE: for `f = fst` (or `id`) no non-empty open of agreement exists (`fst` is nowhere locally collapsed to `x₀`). The `sorry` at line 90 therefore cannot ever be honestly discharged as written; the two "Mathlib bridges" in the docstring cannot prove a false statement.
  - **`rigidity_lemma` (line 225) is laundering.** Its conclusion `∃ g, f = snd X Y ≫ g` IS true given the genuine collapse hypothesis `_hf` (this is the real Mumford lemma). But the proof (lines 237–242) is `refine ⟨lift (toUnit Y ≫ x₀) (𝟙 Y) ≫ f, ?_⟩; rw [← Category.assoc, rigidity_snd_lift]; exact rigidity_core f x₀` — it never uses `_hf`, `y₀`, or `z₀`, and instead derives the result from the *stronger-and-false* `rigidity_core`. A correct proof of the Rigidity Lemma MUST consume the collapse hypothesis; a proof that ignores it is a tell that the real content has been pushed into a false sorry. The theorem appears "proven modulo one geometric sorry" but the sorry is unprovable, so the apparent progress is illusory.
  - **`rigidity_snd_lift` (line 64) — SOUND.** `ext1 <;> simp`, `sorryAx`-free. The statement is a genuine cartesian-monoidal identity (`snd ≫ lift (toUnit Y ≫ x₀) (𝟙 Y) = lift (toUnit (X⊗Y) ≫ x₀) (snd X Y)`); no laundering. The cited cube-free/categorical-algebra reduction (lines 211–216, 237–240) is the one part that is honest.
  - **Cited Mathlib lemmas in `rigidity_core` apply correctly (mechanically).** `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`, `Scheme.PartialMap.Opens.isDominant_ι`, `Over.OverMorphism.ext`, and `ext_of_isDominant_of_isSeparated'` all type-check and the instance `IsSeparated (Z.left ↘ Spec …) := ‹IsSeparated Z.hom›` resolves (file compiles). So the *gluing* machinery is real — but it is fed by the false hypothesis `h` from `rigidity_eqOn_dense_open`, so soundness of the machinery does not rescue the result.
  - **Three bare scaffolds (lines 258, 282, 307).** `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme := sorry`. These are openly-declared `SCAFFOLD`/provisional-signature stubs of not-yet-attempted declarations — honest sorries, not laundering. Per the literal must-fix rule (`:= sorry` on load-bearing claim) they are listed below, but with the caveat that they are normal new-declaration stubs, unlike the false `rigidity_eqOn_dense_open`.
  - **Dead hypotheses on `rigidity_lemma`.** `y₀ : 𝟙_ ⟶ Y`, `z₀ : 𝟙_ ⟶ Z`, and `_hf` are unused by the proof (they only exist to state `_hf`, which is itself unused). This is the structural symptom of the laundering above, not a cosmetic lint.

## Must-fix-this-iter

- `AbelianVarietyRigidity.lean:81` — `rigidity_eqOn_dense_open` is `:= sorry` on a statement that is **false as stated** (no rigidifying/collapse hypothesis; counterexample `f = fst`, `X=Y=Z=ℙ¹`). Why must-fix: a false load-bearing sorry can never be honestly filled, and it silently makes everything downstream of it (`rigidity_core`, `rigidity_lemma`) mathematically unsound. The statement needs the collapse hypothesis (`lift (𝟙 X) (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀`) threaded into it (and into `rigidity_core`) before it is true.
- `AbelianVarietyRigidity.lean:147` — `rigidity_core`'s conclusion `f = retract ≫ f` holds for *arbitrary* `f` under only proper/geom-irred/reduced/separated; this is false (same counterexample). Why must-fix: it is "proven" only via the false `rigidity_eqOn_dense_open`; the declaration as signed is a false lemma masquerading as proven-modulo-sorry.
- `AbelianVarietyRigidity.lean:225` — `rigidity_lemma`'s proof never uses its collapse hypothesis `_hf` and instead invokes the false `rigidity_core`; the genuine geometric content has been laundered into an unprovable sorry. Why must-fix: the headline "Rigidity Lemma … categorical reduction closed; only the geometric core remains" is not true — the remaining core is false as isolated, so the lemma is not on a path to an honest proof.
- `AbelianVarietyRigidity.lean:92-146` & `AbelianVarietyRigidity.lean:71-80` — docstrings present the false `rigidity_eqOn_dense_open` as honest deferred geometry ("PROVEN, modulo …", "the sole remaining `sorry`", "the actual geometry below", "located concrete Mathlib entry points for both bridges"). Why must-fix: these comments explain away a gap that is in fact a false statement, overstating both what is proven and Mathlib availability (no Mathlib lemma can discharge a false goal). This is the over-claim pattern the auditor must escalate.
- `AbelianVarietyRigidity.lean:258`, `:282`, `:307` — `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme` are `:= sorry` on load-bearing claims. Why must-fix (per literal rule): bare sorries on load-bearing declarations. Caveat: these are openly-labeled fresh scaffolds (provisional signatures, `SCAFFOLD` comments) — honest stubs, materially different from the false sorry above; reviewer may treat as expected new-declaration debt rather than as laundering.

## Major

- `AbelianVarietyRigidity.lean:233-235` — dead hypotheses `y₀`, `z₀`, `_hf` on `rigidity_lemma` (unused by the proof). Symptom of the laundering; once the statement is repaired so that `_hf` is actually consumed, these stop being dead.
- `AbelianVarietyRigidity.lean:189-199` — the "iter-157 signature correction" docstring correctly diagnoses that the `[IsProper]`-only scaffold was false and adds geom-irred/reduced/separated, but stops short: it kept `_hf` in `rigidity_lemma` yet allowed `rigidity_core`/`rigidity_eqOn_dense_open` to drop it, which is precisely the residual falsehood. The note thus reads as "fixed" while the bug migrated one level down.

## Minor

- `AbelianVarietyRigidity.lean:35-43` — "Encoding notes" say signatures of decls 1–3 are provisional and "the prover may refine the encoding"; fine, but decl 1 (`rigidity_lemma`) has now been given a proof, so its signature should be treated as load-bearing, not still-provisional.

## Excuse-comments (always called out separately)

No verbatim "TODO/placeholder/temporary/will-fix" tokens. However, the following docstrings function as gap-explaining overclaims and are flagged at **critical** because they cover a *false* load-bearing sorry:

- `AbelianVarietyRigidity.lean:92` (`rigidity_core`): "**Geometric core of the Rigidity Lemma (PROVEN, modulo `rigidity_eqOn_dense_open`).**" — the core is not on a path to proof; the isolated remainder is false. Severity: critical.
- `AbelianVarietyRigidity.lean:140-146`: "iter-157 located concrete Mathlib entry points for *both* [bridges] … the obstruction is assembly … not absent infrastructure … the sole `sorry` of the Rigidity-Lemma chain." — overstates Mathlib availability for a goal that is false as stated. Severity: critical.
- `AbelianVarietyRigidity.lean:71-80` (`rigidity_eqOn_dense_open`): "the genuine geometric content, deferred … the sole remaining `sorry`." — presents a false existential as merely deferred. Severity: critical.

## Severity summary

- **must-fix-this-iter**: 5 (lines 81, 147, 225, the 92-146/71-80 docstring cluster, and the 258/282/307 scaffold-sorries) — the first four block all downstream work in this file because the Rigidity-Lemma chain is currently unsound; the scaffolds are expected debt.
- **major**: 2
- **minor**: 1
- **excuse-comments**: 3 (overclaiming docstrings; also counted under must-fix) — they document the file presenting a false lemma as honestly-deferred.

Overall verdict: `rigidity_snd_lift` is genuinely proven, but `rigidity_lemma`/`rigidity_core` are NOT proven-modulo-an-honest-sorry — they reduce to `rigidity_eqOn_dense_open`, which is **false as stated** (the collapse/rigidifying hypothesis was dropped), so the chain is laundering a true headline through an unprovable gap and must be re-signed to thread the collapse hypothesis before any of it can be honestly closed.
