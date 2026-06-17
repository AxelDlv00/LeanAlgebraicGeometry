# Picard/TensorObjSubstrate/StalkTensor.lean

## Summary
- **NEW file created** and compiles clean (no `sorry`, no warnings), standalone.
- **7 axiom-clean declarations added** (all verified `{propext, Classical.choice, Quot.sound}`):
  1. `PresheafOfModules.stalkTensorBilin` — the `R(U)`-balanced bilinear AddMonoidHom
     `A(U) × B(U) → A_x ⊗_{R_x} B_x`, `(a,b) ↦ germ a ⊗ germ b`.
  2. `PresheafOfModules.stalkTensorBilin_balanced` — the balancing `(r•a)⊗b ↦ a⊗(r•b)`.
  3. `PresheafOfModules.stalkTensorDescU` — per-neighbourhood descent
     `(A⊗ᵖB)(U) = A(U)⊗_{R(U)}B(U) → A_x⊗_{R_x}B_x` via `TensorProduct.liftAddHom`.
  4. `PresheafOfModules.stalkTensorDescU_tmul` — its value on a simple tensor.
  5. `PresheafOfModules.stalkTensorDesc` — **THE d.2 forward comparison map**
     `(A⊗ᵖB).stalk x ⟶ AddCommGrpCat.of (A_x⊗_{R_x}B_x)` via `colimit.desc` (full cocone
     naturality discharged). This is the object `stalkTensorIso` will be built from.
  6. `PresheafOfModules.germ_stalkTensorDesc` — `germ ≫ stalkTensorDesc = stalkTensorDescU`
     (colimit `ι_desc`).
  7. `PresheafOfModules.stalkTensorDesc_germ_tmul` — `stalkTensorDesc (germ (a⊗b)) = germ a ⊗ germ b`.
- sorry count in this file: 0 → 0 (new file, never had a sorry).

## Why I stopped
**Partial progress (real).** Built the forward comparison map `stalkTensorDesc` axiom-clean
— the project's first concrete construction toward the d.2 bottleneck (dodged ~20 iters).
The blueprint-pinned `PresheafOfModules.stalkTensorIso` (the full iso) is NOT yet built;
it needs three further pieces, the first of which is blocked on a specific plumbing wall:

### Blocker hit: `R_x`-linearity packaging (`stalkTensorLinearMap`)
To upgrade `stalkTensorDesc` to an `R.stalk x`-linear map I need the helper
`stalkTensorDescU_smul : stalkTensorDescU (r • w) = germ R r • stalkTensorDescU w`.
The proof (induction on `w`, `tmul` case via `TensorProduct.smul_tmul'` + `germ_smul`) is
**mathematically trivial but blocked by the CommRingCat/RingCat carrier duality**:
- The tensor `(tensorObj A B).obj (op U)` is a module over `(R ⋙ forget₂ _ _).obj (op U)`
  (RingCat carrier), but the natural scalar `r : R.obj (op U)` is the CommRingCat carrier.
- With `r : ↑(R.obj (op U))`, `TensorProduct.smul_tmul'`/`smul_zero`/`smul_add` fail to fire
  (instance `DistribMulAction ↑(R.obj (op U)) ↑(A.obj (op U))` / `SMulCommClass` not synthesized).
- With `r : ↑((R ⋙ forget₂ _ _).obj (op U))` the tensor smul lemmas DO fire, but then
  `germ R U x hx r` no longer typechecks (carrier mismatch — needs an explicit cast/eqToHom).
- This is the known carrier-duality issue (memory: "use erw"; CommRingCat/RingCat duality).
  Resolution needs a small bridging lemma casting between `↑(R.obj (op U))` and
  `↑((R ⋙ forget₂ _ _).obj (op U))` (a `RingEquiv`/`eqToHom` round-trip), then the smul
  lemmas and `germ_smul` compose. ~20–40 LOC of careful `change`/`erw` plumbing.

## Remaining work to reach `stalkTensorIso` (precise decomposition)
1. **`stalkTensorDescU_smul`** (blocked as above) → then
   **`stalkTensorLinearMap : (A⊗ᵖB).stalk x →ₗ[R.stalk x] A_x⊗_{R_x}B_x`** (mirror the existing
   d.1 `PresheafOfModules.stalkLinearMap` in `Vestigial.lean`, lines ~391–426; same
   germ-representative pattern with `germ_exist` + `germ_res` + `germ_smul`).
2. **Reverse map** `stalkTensorInv : A_x ⊗_{R_x} B_x → (A⊗ᵖB).stalk x` via `TensorProduct.lift`
   of an `R_x`-bilinear map out of the two stalks (`germ a, germ b ↦ germ_{U∩V}(a|⊗b|)`).
   This is a **nested colimit descent** (bilinear out of two filtered colimits over the
   varying ring) — the larger remaining piece, ~150–250 LOC.
3. **`stalkTensorIso`** = bundle 1+2 as mutually inverse on generators: `f∘g = id` checked on
   `germ a ⊗ germ b` (uses `stalkTensorDesc_germ_tmul`), `g∘f = id` checked on
   `germ_U (a⊗b)` via `germ`-jointly-epi (`TopCat.Presheaf.stalk_hom_ext`) + simple-tensor
   `TensorProduct.induction_on`. This generator route avoids the hard direct injectivity argument.

## Wiring TODO (NOT editable by prover — for plan/refactor agent)
- The aggregator `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` imports `Vestigial` and
  `PresheafInternalHom` but **NOT** `StalkTensor`. Add
  `import AlgebraicJacobian.Picard.TensorObjSubstrate.StalkTensor` so the new file enters the
  canonical build (otherwise the lakefile glob may still pick it up, but the aggregator should
  list it for consistency with the `% archon:covers` annotation).
- Blueprint `lem:stalk_tensor_commutation` pins `\lean{PresheafOfModules.stalkTensorIso}`, which
  does **not yet exist** as a declaration (only the comparison map `stalkTensorDesc` is built).
  `\leanok` sync will (correctly) not mark it this iter. Consider an intermediate `\lean{}` hint
  for `stalkTensorDesc` if a partial-progress marker is desired.

## Key reusable lessons (validated this session)
- `.presheaf` of a `PresheafOfModules` is valued in **`AddCommGrpCat`** (not `Ab`/`AddCommGrp`);
  constructors are `AddCommGrpCat.of` / `AddCommGrpCat.ofHom`.
- `(tensorObj A B).presheaf.obj (op U)` is defeq to `TensorProduct (R.obj (op U)) (A.obj (op U)) (B.obj (op U))`.
- Coercion reductions that fire: `ConcreteCategory.hom_ofHom` (for `ConcreteCategory.hom (ofHom f) z`),
  `AddCommGrpCat.ofHom_apply`. For descU-of-tmul use a `change` to the underlying `liftAddHom`
  then `TensorProduct.liftAddHom_tmul; rfl`.
- **Cocone naturality for `colimit.desc` into `AddCommGrpCat`**: use **bare `ext z`** (categorical),
  then `induction z using TensorProduct.induction_on`:
  - `zero`/`add`: generic `map_zero`/`map_add`/`rw` do NOT match the `AddCommGrpCat.Hom.hom` wrapper;
    close with **term-mode** `exact (AddMonoidHom.map_zero _).trans (AddMonoidHom.map_zero _).symm`
    and `exact (AddMonoidHom.map_add _ p q).trans ((congrArg₂ HAdd.hAdd hp hq).trans (AddMonoidHom.map_add _ p q).symm)`.
  - `tmul`: `simp only [CategoryTheory.comp_apply, Functor.const_obj_map]` then
    `erw [tensorObj_map_tmul, stalkTensorDescU_tmul, stalkTensorDescU_tmul]` then
    `erw [germ_res_apply, germ_res_apply]` then `rfl`. **`erw` is essential** (R vs R⋙forget₂
    and PoM-map vs presheaf-map are defeq-but-not-syntactic).
