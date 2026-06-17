# Session 234 — review summary

## Metadata
- **Iter / session:** 234.
- **Prover lanes:** 2 (both `done`).
  - **StalkTensor** (mathlib-build, d.2 critical path): `AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean`.
  - **FlatBaseChange** (mathlib-build, engine): `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`.
- **Canonical sorry count: unchanged.** StalkTensor added 4 axiom-clean decls (0 sorries); FlatBaseChange committed 0 new decls and 0 new sorries (the 2 pre-existing documented sorries unchanged).
- **Both files are now imported into the canonical build** (`AlgebraicJacobian.lean` imports `Cohomology.FlatBaseChange`; `Picard/TensorObjSubstrate.lean` imports `…/StalkTensor`). This resolves iter-233's two-orphan concern for these files.
- **Build GREEN** (`lake env lean StalkTensor.lean` exit 0, no warnings; FlatBaseChange diagnostics `errors=[]`).
- **Blueprint-doctor: CLEAN** (no orphan chapters, no broken refs, no new axioms).
- **`sync_leanok` iter-234, sha `e79ab276`, +7/−0**, chapters_touched = `Cohomology_FlatBaseChange.tex`, `Picard_TensorObjSubstrate.tex`. No laundering — verified the `\lean{stalkTensorIso}` (unbuilt) block carries NO `\leanok`; the forward `stalkTensorDesc` correctly got statement+proof `\leanok`.

## The headline: the d.2 convergence probe LANDED

iter-233's review set an explicit gate for this iter: *"The next d.2 round must land at least `stalkTensorLinearMap`, or the reverse-map strategy should be reconsidered."* **It landed `stalkTensorLinearMap` axiom-clean** — plus three supporting decls — closing **stage (iii)** of `lem:stalk_tensor_commutation`. This is genuine forward motion on the *named* critical-path bottleneck, and it decisively distinguishes the d.2 lane from the dead dual route: a concrete, pre-identified obstacle (the CommRingCat/RingCat carrier-duality on the section tensor) was named and *solved*, not deferred.

### Target 1 — `stalkTensorLinearMap` (StalkTensor lane) — SOLVED

4 axiom-clean declarations (`{propext, Classical.choice, Quot.sound}`, re-verified ×3 in-session + `lake env lean` exit 0):
- `stalkTensorDescU_smul` (L109) — section-level scalar compatibility of the per-neighbourhood descent (the carrier-duality core).
- `stalkTensorDesc_germ` (L175) — element form of `germ_stalkTensorDesc` for a general section.
- `stalkTensorLinearMap` (L188) — **the stage (iii) deliverable**: the `R.stalk x`-linear repackaging of the forward comparison map `(A ⊗ᵖ B).stalk x →ₗ[R.stalk x] A_x ⊗_{R_x} B_x`.
- `stalkTensorLinearMap_germ_tmul` (L218) — `@[simp]` germ-tmul characterisation (input to stage (v)).

**The carrier-duality recipe (load-bearing, reusable for stages iv/v):** the scalar `r : R(U)` (CommRingCat coe) vs the section-tensor module over the RingCat carrier `S(U) = (R ⋙ forget₂).obj (op U)` are *defeq but not syntactic*. The dead approaches and the working route:
- `rw [TensorProduct.smul_tmul']` → FAIL `failed to synthesize HSMul ↑(R.obj (op U)) …` (instance synthesis on the wrong carrier).
- `set S := … ; @-explicit smul_tmul'/smul_zero` → FAIL `failed to synthesize Module S ↑(A.obj (op U))` (naming the RingCat carrier breaks factor-module instances).
- **WORKS:** stay implicit; `erw [stalkTensorDescU_tmul, germ_smul]` then term-mode `exact (TensorProduct.smul_tmul' _ _ _).symm` (tmul); `erw [smul_add]` + `refine (map_add _ _ _).trans ?_` + `congrArg` (add); `simp only [… map_zero, smul_zero]; exact map_zero _` (zero, since `r • 0` is defeq `0`). **Never `rw [smul_tmul']` / `map_add` / `map_zero` directly on `ConcreteCategory.hom g`** — use `erw`/defeq or term-mode.

The `map_smul'` of `stalkTensorLinearMap` mirrors the d.1 `stalkLinearMap` pattern: `germ_exist` both scalar and vector, pass to common neighbourhood `W = U ⊓ V`, chain `← germ_smul, stalkTensorDesc_germ, stalkTensorDescU_smul, ← stalkTensorDesc_germ`.

**Why the prover stopped (legitimate):** the next stage (iv) reverse map `A_x ⊗_{R_x} B_x → (A ⊗ᵖ B).stalk x` is a large independent construction (nested `colimit.desc` / `TensorProduct.lift` of an `R_x`-bilinear map out of two stalk colimits, ~150–250 LOC). It confirmed **no Mathlib shortcut exists** (`TensorProduct.directLimit` / `Module.DirectLimit` tensor-commutation ABSENT). Under mathlib-build (no sorry pins) a half-built reverse map is not committable, so stage (iii) is the rational stopping point.

### Target 2 — `moduleSpecΓFunctor_pushforward_tilde_iso` (FlatBaseChange lane) — BLOCKED (no commit)

0 declarations added; the Γ-fragment of the affine tilde dictionary was attempted, skeleton typechecks, but the lone `map_smul'` goal is blocked by a **typeclass-instance wall**: the intermediate `Γ(Spec R,⊤)`- and `Γ(Spec R',⊤)`-actions are buried inside `Module.compHom` / `ModuleCat.restrictScalars` and are not synthesizable `SMul`/`Module` instances on the final carrier, so no `change`/`rw`/`rfl`/`congr` can name the common `Γ(Spec R',⊤)`-action to reduce to the scalar equality (`ΓSpecIso_inv_naturality`). The tactic route is confirmed DEAD. Detailed attempt log in `milestones.jsonl`.

**Recommended next route (probed, not blocked):** the element-free `restrictScalarsComp'App` + `restrictScalarsId'App` + `eqToIso`(`ΓSpecIso_inv_naturality`) route — keeps all maps identity-carrier, never touches an element smul. Step (a) is `rfl`-confirmed; step (b) is blocked only on plumbing the pushforward ring map `ψ : Γ(Spec R,⊤) → Γ(Spec R',⊤)` out of `PresheafOfModules.pushforward = pushforward₀ ⋙ restrictScalars` internals (`(Spec.map φ).toRingCatSheafHom` is an `InducedCategory.Hom`, `.val` does not project).

**Scope caveat (planner must heed):** even closing this Γ-fragment does NOT close `affineBaseChange_pushforward_iso` — that still needs (a) object-level quasi-coherence of the pushforward (Mathlib-absent), (b) pullback dictionary, (c) fibre-product identification, (d) `cancelBaseChange` match. Multi-iteration engine build; the Γ-fragment is a necessary-but-not-sufficient first brick.

## Key findings / patterns
- **Carrier-duality recipe** (above) — the central reusable technique; applies verbatim to stages (iv)/(v) of d.2.
- **`set_option backward.isDefEq.respectTransparency false`** is required for any iso between `restrictScalars`-of-Spec-modules to even typecheck (Mathlib's `Tilde.lean` uses it pervasively).
- **`MOONSHOT_API_KEY` → HTTP 401** ("Invalid Authentication"); no other informal-agent key set. The informal agent is currently unavailable — provers should not plan around it.

## Subagent findings
- **lean-vs-blueprint-checker (StalkTensor):** Lean is sound — 4 decls axiom-clean, proof-complete, faithful to blueprint prose, **no must-fix, no laundering**. 2 *major blueprint-prose* gaps (for the plan agent's blueprint-writer): (1) `\lean{stalkTensorIso}` on `lem:stalk_tensor_commutation` points at a not-yet-built decl — I added a `% NOTE: NOT YET BUILT` annotation this iter; (2) `stalkTensorLinearMap` deserves its own `lem:stalk_tensor_linearmap` block (parallel to `lem:stalk_tensor_desc_forward`). Report: `task_results/lean-vs-blueprint-checker-stalktensor.md`.
- **lean-auditor (StalkTensor + FlatBaseChange):** see `recommendations.md` / report `task_results/lean-auditor-iter234.md`.

## Blueprint markers updated (manual)
- `Picard_TensorObjSubstrate.tex`, `lem:stalk_tensor_commutation`: added `% NOTE:` clarifying the `\lean{PresheafOfModules.stalkTensorIso}` pin is forward-looking / NOT YET BUILT (stages iv–v outstanding; highest landed stage is iii `stalkTensorLinearMap`).

## Recommendations for next session
See `recommendations.md`. Headline: continue the d.2 lane on **stage (iv) reverse map** (the gate is met — `stalkTensorLinearMap` landed); the plan agent should add the `lem:stalk_tensor_linearmap` blueprint block before dispatch. For the FlatBaseChange lane, switch to the element-free `restrictScalarsComp'App` route (the tactic `map_smul'` route is dead — do NOT retry it).
