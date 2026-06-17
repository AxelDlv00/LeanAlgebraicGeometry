# AlgebraicJacobian/AbelianVarietyRigidity.lean

## iter-159 summary

Lane: `rigidity_eqOn_dense_open` — closed BOTH internal sorries' first one (`hfib`) and isolated
the second (bridge 2) into a clean named helper. Net: the Rigidity-Lemma chain now has **exactly
one** `sorry` (down from two), and `rigidity_eqOn_dense_open` is **`sorry`-free in its own body**.

### (a) Signature change `[IsAlgClosed kbar]` — DONE
Added `[IsAlgClosed kbar]` to `rigidity_eqOn_dense_open`, `rigidity_core`, `rigidity_lemma`.
Build stayed green; instances flow down the call chain. Confirmed no downstream consumer exists
(grep: these three lemmas are referenced ONLY within this file — the headline
`rigidity_genus0_curve_to_grpScheme`, which Jacobian consumes, already carried `[IsAlgClosed]`),
so the change is fully contained.

### (b) `hfib` (pullback-fibre over the `k̄`-point `y₀`) — RESOLVED, axiom-clean
Implemented the 7-step `IsPullback`-pasting skeleton from `analogies/rigidity-hfib.md`. Key
deviations from the recipe that were needed to compile:
- `htoUnit : (toUnit X).left = X.hom` and `hsec : y₀.left ≫ Y.hom = 𝟙 _` close by **`by simp`**
  (the `rwa [Over.tensorUnit_hom, Category.comp_id]` form FAILED — `Category.comp_id` mysteriously
  did not match `_ ≫ 𝟙 (Spec _)`; `simp` handles it directly).
- `hsp2` ends with `exact congrArg (· ≫ y₀.left) htoUnit` — a plain `rw [..., htoUnit]` left a
  **reflexive goal `a = a` UNSOLVED** because the two sides differ syntactically in the middle
  object (`(𝟙_).left` vs `Spec _`, defeq but not syntactic); `rw`'s auto-rfl + even `simp only`
  refused to close it. `congrArg` sidesteps the defeq mismatch.
- `houter` built via `rwa [← hsp1, ← hsec] at hiso` from an `IsPullback.of_horiz_isIso ⟨by simp⟩`
  identity square — the forward `rw [hsp1, hsec]` form FAILED with a spurious "did not find
  pattern `y₀.left ≫ Y.hom`" (the pattern was visibly present; rewriting under the dependent
  `IsPullback` is fragile). Rewriting the *hypothesis* backwards is robust.
- Range lemma is `AlgebraicGeometry.Scheme.image_preimage_eq_of_isPullback` (NOT
  `...Scheme.Pullback.image_preimage_eq_of_isPullback` as the analogy stated — the `Pullback`
  namespace closes at PullbackCarrier.lean:376, before the lemma at :414, so it lives in
  `AlgebraicGeometry.Scheme`).

### (c) Stale-docstring cleanup — DONE
Updated module docstring (link 1 no longer "scaffolded as sorry"), `rigidity_eqOn_dense_open`
docstring (dropped "both bridges discharged" / "sole remaining sorry"; now states it is
`sorry`-free in its own body and delegates bridge 2 to the helper), `rigidity_core` docstring
(bridge 1 marked BUILT, bridge 2 isolated in the helper), and `rigidity_lemma` docstring (status
updated). No `\leanok` touched (deterministic sync owns it).

### (d) Bridge 2 (slice-constancy / agreement equation) — PARTIAL (committal)
The genuinely-deep residual (analogist estimate ~1–2 further iter). Concrete progress:
- **Proved inline** `hfU : ∀ u ∈ U, f.left.base u ∈ U₀` — `f` maps the saturated open
  `U = p₂⁻¹(Gsetᶜ)` into the affine `U₀`, read off the definition of `Gset = p₂ '' (f⁻¹ U₀ᶜ)` by
  `by_contra` + `exact hu ⟨u, hcon, rfl⟩` (2 lines, no infrastructure).
- **Extracted** the residual as a new named top-level helper
  `rigidity_eqOn_saturated_open_to_affine` (faithful statement: `p₂`-saturated open `U`, affine
  `U₀`, `f` lands in `U₀` ⟹ `f` agrees with `retract ≫ f` on `U`), with a full **route-B**
  docstring (per-closed-slice `ext_of_isAffine` + `isField_of_universallyClosed` +
  `finite_appTop_of_universallyClosed` + alg-closed; globalize over dense closed points via
  `closure_closedPoints` + `ext_of_isDominant_of_isSeparated'`; the lone missing connective is
  "dense-closed-points ⟹ hom-ext", buildable from a coproduct probe, NOT cohomology). Body is
  `sorry`. The inline goal is discharged by `exact rigidity_eqOn_saturated_open_to_affine ...`.

## Axiom status (lean_verify)
- `snd_left_isClosedMap`: `{propext, Classical.choice, Quot.sound}` — **axiom-clean** (no sorryAx).
- `rigidity_lemma`: `{propext, sorryAx, Classical.choice, Quot.sound}` — honest transitive
  `sorryAx` from the single helper; **no custom axioms**.

## Sorry landscape (this file, iter-159 close)
- L124 `rigidity_eqOn_saturated_open_to_affine` — NEW bridge-2 helper (the lone Rigidity-chain sorry).
- L453 `morphism_P1_to_grpScheme_const`, L477 `genusZero_curve_iso_P1`,
  L502 `rigidity_genus0_curve_to_grpScheme` — the 3 deferred scaffolds (cube / Riemann–Roch),
  left untouched per directive.
`rigidity_snd_lift`, `snd_left_isClosedMap`, `rigidity_eqOn_dense_open`, `rigidity_core`,
`rigidity_lemma` — all `sorry`-free in their own bodies.

## Blueprint markers (for review agent)
- `lem:rigidity_eqOn_dense_open` (`rigidity_eqOn_dense_open`) — now `sorry`-free in its own body;
  remains a `\leanok` statement. A NEW Lean declaration `rigidity_eqOn_saturated_open_to_affine`
  exists (bridge 2) — it has no blueprint environment yet; the plan agent may want to add one
  (it is the formal home of the "Bridge 2" prose in the proof of `lem:rigidity_eqOn_dense_open`).
- `thm:rigidity_lemma` — proof now closed modulo the single bridge-2 helper.

## Next step (concrete continuation for bridge 2)
Prove `rigidity_eqOn_saturated_open_to_affine` via route B (recipe in
`analogies/rigidity-affineconst.md`). Decompose: (1) a per-closed-point slice-constancy sub-lemma
(`ext_of_isAffine` into `U₀`, `Γ(slice) = k̄` from `isField_of_universallyClosed` +
`finite_appTop_of_universallyClosed` + alg-closed); (2) the "dense closed points ⟹ hom-ext"
connective (coproduct `∐_{x∈closedPoints U} Spec κ(x) ⟶ U` dominant via `closure_closedPoints`,
then `ext_of_isDominant_of_isSeparated'`). Need `[GeometricallyIrreducible X.hom]` / X reduced for
slice integrality — derivable from `(X ⊗ Y)` instances but itself a sub-step. Do NOT attempt the
relative Stein / `f_*𝒪 = 𝒪` framing (confirmed Mathlib gap).
