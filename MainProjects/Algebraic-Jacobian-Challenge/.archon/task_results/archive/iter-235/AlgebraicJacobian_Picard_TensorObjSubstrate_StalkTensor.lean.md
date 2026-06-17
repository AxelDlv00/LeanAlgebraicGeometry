# AlgebraicJacobian/Picard/TensorObjSubstrate/StalkTensor.lean

## Summary

Stage (iv) of d.2 (the **reverse map** of the stalk–tensor commutation) — the nested
colimit descent that the planner flagged as ~150–250 LOC with **no Mathlib shortcut** — is
now **built end-to-end as axiom-clean infrastructure**. The whole double-colimit reverse
descent `A_x ⊗_{R_x} B_x ← (build the bilinear bihom out of the two B/A stalk colimits)`
is in place; the **only** residual is the final `R.stalk x`-balancing condition, which is
blocked on a precisely-characterised `restrictScalars`/carrier-duality wall (documented
in-file + below).

- **Declarations added: 10, all axiom-clean** (`{propext, Classical.choice, Quot.sound}`):
  `revInnerLeg`, `revInnerLeg_apply`, `revInner`, `germ_revInner`, `revInner_germ`,
  `revOuterLeg`, `revOuterLeg_apply`, `revBihom`, `germ_revBihom`, `revBihom_germ_tmul`.
- **Declarations blocked: 2** (NOT added; replaced by a precise in-file handoff comment):
  `revBihom_balanced` (the balancing) and `stalkTensorRev` (its consumer via
  `TensorProduct.liftAddHom`).
- **sorry count: 0 → 0.** File compiles clean (`lake env lean` exit 0); `grep sorry` empty.

## What landed (the reverse-map descent, all `private` except none — internal infra)

Nested filtered-colimit descent of the `R_x`-bilinear map `(germ a, germ b) ↦ germ(a|⊗b|)`:

1. `revInnerLeg U hxU a V hxV` (L235) — inner cocone leg `B(V) → (A⊗ᵖB).stalk x`,
   `b ↦ germ_{U⊓V}((a|)⊗(b|))`. `revInnerLeg_apply` (L249) = its `rfl` evaluation.
2. `revInner U hxU a` (L262) — **inner descent** `B.stalk x ⟶ (A⊗ᵖB).stalk x` via
   `colimit.desc`; the cocone **naturality** is the hard sub-proof (germ_res + tensorObj_map_tmul
   + presheaf functoriality + poset thinness). `germ_revInner`/`revInner_germ` (L289/L297) =
   germ characterisation.
3. `revOuterLeg U hxU` (L318) — outer cocone leg `A(U) →+ (B_x →+ St)`; additivity in `a`
   checked on germ generators via `revInner_germ` + `add_tmul`/`zero_tmul`.
4. `revBihom` (L340) — **outer descent** `A.stalk x ⟶ AddCommGrpCat.of (B_x →+ St)` via the
   second `colimit.desc`; outer naturality mirrors (2) with A/B roles swapped.
   `germ_revBihom`/`revBihom_germ_tmul` (L373/L382) = germ characterisation:
   `revBihom (germ a) (germ b) = germ_{U⊓V}(a|⊗b|)`.

This is the full additive bilinear comparison `A_x →+ B_x →+ (A⊗ᵖB).stalk x`. The forward
map `stalkTensorLinearMap` (stage iii, DONE earlier) and this reverse bihom are the two
halves of `stalkTensorIso`.

## `revBihom_balanced` / `stalkTensorRev` — NOT added (precise blocker)

**Goal:** `revBihom (r • a) b = revBihom a (r • b)` (the balancing feeding
`TensorProduct.liftAddHom` to produce `stalkTensorRev : A_x ⊗_{R_x} B_x →+ St`).

**Where it stands (verified live):** the germ reduction works completely. With
`a = germ a₀`, `b = germ b₀`, `r = germ r₀`, common nbhd `W := T ⊓ U ⊓ V`, the proof
```
rw [hrW, haW, hbW, ← germ_smul A x W hxW, ← germ_smul B x W hxW,
    revBihom_germ_tmul, revBihom_germ_tmul]
congr 1
```
brings the goal to the **section-level identity** (in `A(W⊓W) ⊗_{R(W⊓W)} B(W⊓W)`)
```
(A.map _ (r' • a')) ⊗ₜ (B.map _ b') = (A.map _ a') ⊗ₜ (B.map _ (r' • b')).
```

**The wall (restrictScalars/carrier duality, root cause pinned via `set_option`-level error):**
`PresheafOfModules.map_smul` pulls the scalar through the restriction, but the resulting smul
is over the **`RingCat`** carrier `(R ⋙ forget₂).obj (op (W⊓W))` and on the
**`restrictScalars`-module** `(ModuleCat.restrictScalars _).obj (A.obj (op (W⊓W)))`, whereas
the section tensor is annotated over the **`CommRingCat`** carrier `R.obj (op (W⊓W))` on the
plain module `A.obj (op (W⊓W))`. `TensorProduct.smul_tmul` then fails to synthesize a
`DistribMulAction` defeq to the inferred `ModuleCat.instModuleCarrierObjRestrictScalars`
(exact mismatch observed: synthesized `A.obj.isModule` vs inferred
`ModuleCat.instModuleCarrierObjRestrictScalars` on the `restrictScalars.obj`).

Tried & FAILED (all hit the same synth/defeq wall): `exact smul_tmul _ _ _`;
`smul_tmul (R := ↑(R.obj (op (W⊓W))))`; `smul_tmul (R := ↑((R⋙forget₂).obj …))`;
`haveI := ModuleCat.isModule (A.obj (op (W⊓W)))` then `smul_tmul` (→ defeq-mismatch with the
restrictScalars instance); `rw`-based `smul_tmul`/`smul_tmul'`.

**NEXT PROVER ROUND — two viable routes (documented in-file at the removed lemma site):**
1. Close the section identity with the over-ring `erw`/`smul_tmul'` recipe, mirroring
   `stalkTensorDescU_smul` (already in this file, L109) which solves the SAME
   `RingCat`-vs-`CommRingCat` section smul — insert the canonical `RingEquiv` carrier bridge
   flagged in the blueprint stage-(iii) note (`§sec:tensorobj_stalk_tensor`, "carrier-duality
   obstacle"). The obstruction here is strictly the extra `restrictScalars` wrapper from
   `map_smul`, absent in `stalkTensorDescU_smul`'s formulation — so prefer reformulating to
   avoid `map_smul`.
2. **Recommended:** avoid the `W⊓W` section smul entirely — prove the balancing at the
   **stalk level** `revBihom (r • a) b = r • (revBihom a b)` (St carries the `R_x`-action from
   `ModuleCat.Stalk`), using the `T`-presheaf `germ_smul` so the scalar stays at `R_x` (clean,
   no RingCat/restrictScalars carrier — this is exactly where the existing stalk-level
   `stalkTensorBilin_balanced`/`stalkTensorDescU_smul` smuls succeed).

Then: `stalkTensorRev := TensorProduct.liftAddHom (ConcreteCategory.hom (revBihom A B x)) revBihom_balanced`.

## Stage (v) — `stalkTensorIso` (after stalkTensorRev lands)

`fwd = stalkTensorLinearMap` (DONE), `rev = stalkTensorRev`; `fwd∘rev = id` on
`germ a ⊗ germ b` via `stalkTensorLinearMap_germ_tmul` + `TensorProduct.induction_on`;
`rev∘fwd = id` on `germ(a⊗b)` via `revBihom_germ_tmul` + `stalk_hom_ext` (germ joint-epi) +
`TensorProduct.induction_on` per section. Bundle `fwd` (linear) with `rev` + the two
inversion identities → `stalkTensorIso` (blueprint `lem:stalk_tensor_commutation`).

## Reusable tactic recipes discovered this round (for the planner / next prover)

- **Cocone naturality plumbing**: `apply AddCommGrpCat.hom_ext; ext b;
  simp only [comp_apply, Functor.const_obj_map]; erw [ConcreteCategory.id_apply]` cleanly
  strips the `((const).obj _).map f = 𝟙` and the `(𝟙).hom` wrapper (the `𝟙` survives `rw
  [Category.comp_id]`/`simp`; it must be killed at the element level by
  `erw [CategoryTheory.ConcreteCategory.id_apply]`).
- **Expanding a `private` `rfl`-leg-eval lemma under a `(𝟙)`/`ofHom` wrapper**: plain `rw`
  and a 2nd `erw` time out in `whnf`; use `conv_rhs => erw [leg_apply]` to narrow scope, or
  `simp only [legDef]` to unfold then handle the residual `ConcreteCategory.hom (ofHom _)` by
  `rfl`/`erw`.
- **Section-equality from presheaf functoriality + poset thinness** (the germ_res residual):
  `rw [← presheaf_map_apply_coe, …]` to uniformise `M.map`→`M.presheaf.map`,
  `erw [← CategoryTheory.ConcreteCategory.comp_apply, ← Functor.map_comp]` to merge composites
  (note: `comp_apply` combines ANY two composable `AddCommGrpCat` morphisms regardless of which
  functor produced them — used to merge `((incl).op⋙M.presheaf).map f` with `M.presheaf.map _`
  after `Functor.comp_map`), then `congr 1` discharges the morphism equality by thinness
  (proof irrelevance on the `≤`-proofs of `homOfLE`).
- **`map_add`/`map_zero` on bundled `ConcreteCategory.hom`**: plain `rw`/`simp` fail the
  `AddMonoidHomClass` synth during matching — use `erw [_root_.map_add, …]`.

## Blueprint markers (for review agent)

No new `\lean{}` pins are READY-for-`\leanok` as standalone blueprint blocks — the landed
declarations are internal (`private`) descent infra feeding the single pinned target
`lem:stalk_tensor_commutation` (`stalkTensorIso`), which is NOT yet built (stages iv-balancing
+ v remain). The existing `% NOTE: NOT YET BUILT` annotation on the `stalkTensorIso` pin stays
correct. No marker changes required this round.
