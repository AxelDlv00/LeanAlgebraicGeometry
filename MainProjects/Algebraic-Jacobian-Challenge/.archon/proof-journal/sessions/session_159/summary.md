# Session 159 — review of iter-159

## Metadata
- Iteration / session: 159
- Global bare-`sorry` count: **7 → 7** (NET 0). Re-verified `^\s*sorry\s*$`:
  `AbelianVarietyRigidity.lean` 4 (L141 bridge-2 helper, L462/486/515 deferred scaffolds);
  `Jacobian.lean` 2 (L265, L303); `RigidityKbar.lean` 1 (L88).
- Lane: single deep prover on `AlgebraicJacobian/AbelianVarietyRigidity.lean`, scoped to
  `rigidity_eqOn_dense_open`. **Dispatch matched the plan** (lane fired exactly where PROGRESS.md
  prescribed — second consecutive clean plan/dispatch alignment).
- Prover activity (`attempts_raw.jsonl`): 19 edits, 1 goal check, 11 diagnostic checks, 2 lemma
  searches, 0 `lake build`. No protected signature touched; no new axioms.

## The unit of progress: one genuine geometric sorry CLOSED + clean isolation of the residual

Although the global count is flat, the AVR Rigidity-Lemma chain went from **two** internal
`sorry`s inside `rigidity_eqOn_dense_open` to **one** cleanly-isolated named obligation. Two
independent review subagents (lean-auditor, lean-vs-blueprint-checker) confirmed the work is
sound and not a laundering relocation.

### (a) `[IsAlgClosed kbar]` added to the three chain lemmas — legitimate, contained
Added to `rigidity_eqOn_dense_open`, `rigidity_core`, `rigidity_lemma`. Antecedent
strengthening (cannot launder a gap). Verified contained: the three are referenced ONLY within
AVR (grep), and the downstream headline `rigidity_genus0_curve_to_grpScheme` (consumed by
`genusZeroWitness`) already carried `[IsAlgClosed kbar]` (L502-503). Build stayed green.

### (b) `hfib` — the pullback-fibre fact over the k̄-point y₀ — CLOSED, axiom-clean
`(snd X Y).left.base ⁻¹' {y₀pt} ⊆ Set.range s.base` proved by `IsPullback` pasting (L215-242):
- outer iso square `IsPullback.of_horiz_isIso ⟨by simp⟩`, rewritten **backwards into the
  hypothesis** (`rwa [← hsp1, ← hsec] at hiso`) — the forward goal-rewrite failed ("did not find
  pattern `y₀.left ≫ Y.hom`") because rewriting under a dependent `IsPullback` is fragile;
- pasted off the canonical square via `IsPullback.of_right ... (IsPullback.of_hasPullback ...)`;
- fibre read off the coarse layer with `AlgebraicGeometry.Scheme.image_preimage_eq_of_isPullback hL.flip Set.univ`.

Robustness lessons (now in Knowledge Base):
- `htoUnit : (toUnit X).left = X.hom` and `hsec : y₀.left ≫ Y.hom = 𝟙 _` close by **`by simp`**;
  the `rwa [Over.tensorUnit_hom, Category.comp_id]` form FAILED (`Category.comp_id` did not match
  `_ ≫ 𝟙 (Spec _)`).
- `hsp2` needs `exact congrArg (· ≫ y₀.left) htoUnit`; a plain `rw [..., htoUnit]` (and even
  `simp only`) left a reflexive `a = a` UNSOLVED because the middle object differs syntactically
  (`(𝟙_).left` vs `Spec _`, defeq-not-syntactic). `congrArg` sidesteps the defeq mismatch.

### (c) `hfU` (affine-containment) — proved inline, 2 lines
`∀ u ∈ U, f.left.base u ∈ U₀` by `by_contra` + `exact hu ⟨u, hcon, rfl⟩`, read straight off the
definition `Gset = p₂ '' (f⁻¹ U₀ᶜ)` (L270-275). No infrastructure.

### (d) Bridge 2 (slice-constancy) — EXTRACTED to a faithfully-stated named helper (sorry)
New top-level `rigidity_eqOn_saturated_open_to_affine` (L124-141): on a `p₂`-saturated open
`U = p₂⁻¹(Vset)` where `f` lands in a single affine `U₀`, `f` agrees with the collapse
`retract ≫ f` on `U`. Consumed at L276. After this, `rigidity_eqOn_dense_open` is **`sorry`-free
in its own body** (diagnostics: sorry warnings only at L141/L462/L486/L515, NOT L170).

## Soundness verification (this review + 2 subagents)
- `_hf` (collapse hypothesis) is **genuinely consumed** at L244-254 (`hy₀ : y₀pt ∉ Gset`,
  `congrArg Over.Hom.left _hf`) — the iter-157 laundering remains repaired. `f := fst`
  counterexample stays excluded.
- The new helper is **TRUE-as-stated, every hypothesis load-bearing** (`_hfU`, `_hU₀`, `_hUV`,
  `[IsProper]`, `[IsAlgClosed]` — drop any and the conclusion fails), applied **non-vacuously**
  (caller discharges all premises with genuine proofs). NOT a stand-in. (lean-auditor §1,
  lean-vs-blueprint-checker Q3/Q4.)
- `lean_verify`: `snd_left_isClosedMap` axiom-clean `{propext, Classical.choice, Quot.sound}`;
  `rigidity_eqOn_dense_open` / `rigidity_lemma` = `{propext, sorryAx, Classical.choice,
  Quot.sound}` (honest transitive `sorryAx` via the single helper, no custom axiom). Zero
  `axiom` declarations project-wide.

## Review subagents (2 dispatched, both COMPLETE, 0 must-fix)

| Subagent | Slug | Verdict | Headline |
|---|---|---|---|
| `lean-auditor` | iter159 | **0 must-fix / 2 major / 2 minor** | iter-159 AVR work sound + honest; new helper true-as-stated, non-vacuous; `_hf` consumed; no false-as-stated sorry / excuse-comment / unauthorized axiom anywhere. Majors: 2 STALE section docstrings in `Cotangent/GrpObj.lean` (L297-327, L428-451) referencing iter-145-EXCISED declarations (`mulRight_globalises_cotangent`, base-change step) — a reader would think the file still has live sorries; it has none. Minors: stale ChartAlgebra header NOTE; unbacked `HasAffineCechAcyclicCover` Prop class. Report: `task_results/lean-auditor-iter159.md`. |
| `lean-vs-blueprint-checker` | avr-iter159 | **0 must-fix / 2 major / 2 minor** | Lean side sound + faithful (chain lemmas sorry-free in own bodies, bridge-2 obligation cleanly isolated + faithfully stated). Major: the new helper `rigidity_eqOn_saturated_open_to_affine` has **NO `\lean{}` block** → no `\uses` edge → `\leanok`-tagged `rigidity_lemma`/`rigidity_eqOn_dense_open` proofs render as fully proven despite verified transitive `sorryAx` (a marker-graph laundering vector). Also stale status prose (`rmk:rigidity_lemma_decomposition` "two residual sorries inside dense_open" — now one, extracted). Report: `task_results/lean-vs-blueprint-checker-avr-iter159.md`. |

## Tooling reliability finding
The `mathlib-analogist` recipe in `analogies/rigidity-hfib.md` gave the WRONG namespace for the
key range lemma (`Scheme.Pullback.image_preimage_eq_of_isPullback`) despite claiming all decls
were "LSP-verified at iter-159"; the actual lemma is `AlgebraicGeometry.Scheme.image_preimage_eq_of_isPullback`
(the `Pullback` namespace closes before it). The prover caught + fixed it, but the analogist's
"LSP-verified" stamp was unreliable — future consults should re-verify cited namespaces.

## Blueprint markers updated (manual)
- `AbelianVarietyRigidity.tex`, `thm:rigidity_lemma` proof block: refreshed the iter-158 `% NOTE`
  to iter-159 state (hfib CLOSED → dense_open sorry-free in own body; lone residual = bridge 2
  extracted to `rigidity_eqOn_saturated_open_to_affine`, audited true-as-stated). Appended a
  `% TODO (plan agent / blueprint-writer)` flagging the missing `\lean{}` block + `\uses` edge
  for the new helper (the marker-graph laundering vector) and the stale
  `rmk:rigidity_lemma_decomposition` wording.
- No `\leanok` touched (sync_leanok owns it); no `\mathlibok` added (no new Mathlib re-export).

## Blueprint doctor
No structural findings (all chapters `\input`'d, all refs resolve, no new axioms).

## Recommendations
See `recommendations.md`. Headline: (1) plan agent must dispatch a **blueprint-writer** for
`AbelianVarietyRigidity.tex` to add the helper block + `\uses` edge BEFORE the next prover lane
on AVR (HARD GATE + closes the marker-graph laundering vector); (2) next prover target is
`rigidity_eqOn_saturated_open_to_affine` via route B; (3) a cheap `Cotangent/GrpObj.lean`
docstring-cleanup (2 stale blocks).
