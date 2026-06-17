# AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean

## Summary
- **Declarations added (6, all axiom-clean `{propext, Classical.choice, Quot.sound}`):**
  - `revBihom_balanced_germ` (private helper, germ-wrapped section identity) — line ~480
  - `revBihom_balanced` (the SOLE residual feeding `liftAddHom`) — line ~423
  - `stalkTensorRev` (the reverse map) — line ~458
  - `stalkTensorRev_germ_tmul` (germ characterisation of the reverse) — line ~466
  - `germ_tensorObj_map_tmul` (private helper, germ of a restricted simple tensor) — line ~488
  - `stalkTensorIso` (**the d.2 iso, `lem:stalk_tensor_commutation`**) — line ~505
- **Declarations blocked:** none.
- **Sorry count (this file): 0 → 0.** No sorry at any point; every step axiom-clean.
- **`lake env lean` exit 0**; LSP diagnostics empty (no errors, no warnings).

## OUTCOME: d.2 CRITICAL PATH CLOSED
The full d.2 stalk–tensor commutation isomorphism `stalkTensorIso :
(A ⊗ᵖ B).stalk x ≃ₗ[R.stalk x] A_x ⊗_{R_x} B_x` is **complete and axiom-clean**. This was
the single Mathlib-absent ingredient gating the unconditional associator
(`isLocallyInjective_whiskerLeft_of_W`) ⇒ `thm:pic_commgroup`. Stage (iv) balancing → reverse map
→ stage (v) bundle all landed in one round, as dispatched.

## Blueprint markers ready (sync_leanok will apply)
- `lem:stalk_tensor_commutation` (`\lean{PresheafOfModules.stalkTensorIso}`): **statement + proof closed** → `\leanok` on both blocks.

## revBihom_balanced (line ~423)
- **Approach:** Reduce `revBihom (r•m) n = revBihom m (r•n)` (the `liftAddHom` balancing
  condition) on germ generators over a common neighbourhood `W := T ⊓ U ⊓ V` via
  `germ_res_apply` + `germ_smul` + `revBihom_germ_tmul`, landing on the `W ⊓ W` section identity,
  closed by `revBihom_balanced_germ`.
- **Result:** RESOLVED — axiom-clean.
- **KEY RECIPE (carrier-duality wall resolution):** The iter-235 wall was REAL but avoidable.
  The section identity `(r₀•a)⊗b = a⊗(r₀•b)` is proved at the **W level** (over the `CommRingCat`
  carrier `R(W)`, where `TensorProduct.smul_tmul` synthesises cleanly because `R' = R`, no carrier
  mixing) and transported down via `congrArg ((tensorObj A B).map j.op)` + `erw [tensorObj_map_tmul]`.
  Do NOT use `map_smul` at the `W ⊓ W` section level (produces a `RingCat`-carrier scalar →
  `smul_tmul` synth fails).
- **CRITICAL GOTCHA (the multi-attempt time-sink):** a STANDALONE lemma whose statement is a bare
  `... ⊗ₜ[R.obj (op Z)] ...` of `A.presheaf.map` outputs FAILS to elaborate (`Module ↑(R.obj (op Z))
  ↑(A.presheaf.obj (op Z))` synth fails — the relative-tensor needs an expected type to resolve the
  `A.presheaf.obj`-vs-`A.obj` carrier). FIX: **wrap the equality in `germ`** (the germ's domain
  supplies the expected module type), exactly as the existing `revBihom_germ_tmul` does. Hence
  `revBihom_balanced_germ` is germ-wrapped, NOT a bare section identity. Inside its proof `congr 1`
  strips the germ (terms already elaborated) and the W-transport closes it.

## stalkTensorRev / stalkTensorRev_germ_tmul (line ~458)
- **Approach:** `TensorProduct.liftAddHom (ConcreteCategory.hom (revBihom A B x)) revBihom_balanced`;
  germ char via `TensorProduct.liftAddHom_tmul` + `revBihom_germ_tmul`.
- **Result:** RESOLVED — axiom-clean.

## stalkTensorIso (line ~505)
- **Approach:** `LinearEquiv` with `toFun := stalkTensorLinearMap`, `invFun := stalkTensorRev`.
  `left_inv`/`right_inv` by `TensorProduct.induction_on` (+ `germ_exist` to reach germ generators);
  tmul cases use `stalkTensorLinearMap_germ_tmul` / `stalkTensorRev_germ_tmul` + the helper
  `germ_tensorObj_map_tmul` (left) / `germ_res_apply` (right).
- **Result:** RESOLVED — axiom-clean.
- **GOTCHAS:** (1) `TensorProduct.induction_on` produces tmuls over the **RingCat** carrier
  `(R⋙forget₂).obj` while the germ-char lemmas use `R.obj` (CommRingCat) — bridge with `erw`
  (defeq), not `rw`. (2) `zero`/`add` cases: `simp only [map_zero/​map_add]` makes NO progress on
  `ConcreteCategory.hom (germ ...)`-applied terms — use `erw [map_zero, map_zero, map_zero]` /
  `erw [map_add, map_add, map_add, hp, hq]`. (3) folding `A.map`/`B.map` via `← tensorObj_map_tmul`
  needs a SINGLE restriction map (so `germ_tensorObj_map_tmul` takes one `j`, applied with
  `inf_le_left`; the `B`-side `inf_le_right` unifies by proof-irrelevance defeq) AND the
  `presheaf.map`→`map` bridge `← presheaf_map_apply_coe`.

## Why I stopped
**Real progress: 6 axiom-clean declarations added, d.2 critical path fully closed.** The dispatched
unit (balancing → reverse map → iso) is complete; `stalkTensorIso` verified
`#print axioms` = kernel-only. No further declarations in this file's chain remain — the next
consumer (`isLocallyInjective_whiskerLeft_of_W` / the unconditional associator) lives in other
substrate files. Nothing blocked, no skipped approaches.

## Handoff to planner
- The associator lane can now consume `PresheafOfModules.stalkTensorIso` unconditionally → close
  `thm:pic_commgroup`. Repoint `thm:rel_pic_addcommgroup_via_tensorobj`'s `\uses` to `thm:pic_commgroup`
  (per standing deferral).
- The two private helpers (`revBihom_balanced_germ`, `germ_tensorObj_map_tmul`) are file-local; if
  another substrate file needs the germ-of-restricted-tensor fact, promote `germ_tensorObj_map_tmul`
  to non-private.
