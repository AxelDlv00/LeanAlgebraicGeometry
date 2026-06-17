# Iter-236 objectives (per-lane detail)

## Lane 1 — `Picard/TensorObjSubstrate/StalkTensor.lean` [mathlib-build] — d.2 critical path

**Goal:** close the d.2 stalk–tensor commutation iso `stalkTensorIso`
(`lem:stalk_tensor_commutation`) by closing the SOLE residual `revBihom_balanced`, then
`stalkTensorRev`, then the bundle — IN ONE ROUND (no sub-helper fragmentation).

State entering: stages (i)–(iv-descent) axiom-clean, 0 sorries. 21 of ~24 planned decls landed.

### Step 1 — `revBihom_balanced` (the residual)
Prove the `R_x`-balancing at the STALK level:
`revBihom (germ_x r · a) b = (germ_x r) · revBihom a b`,
scalar staying in `R_x = R.stalk x` throughout, via `germ_smul` (germ–scalar compatibility
`germ_x (r·s) = (germ_x r)·(germ_x s)`, the same compatibility used in stages (i)/(iii)).
- DO NOT reduce to a `W`-section identity `(A.map r'•a') ⊗ B.map b' = …`: there `map_smul`
  produces a `restrictScalars`-wrapped action over the RingCat carrier `(R∘forget₂)(W)`, not the
  CommRingCat carrier `R(W)` annotating the section tensor → `TensorProduct.smul_tmul'` fails to
  synthesize (the iter-235 wall).
- If a carrier identity is unavoidable, reuse the stage-(iii) `stalkTensorDescU_smul` / `RingEquiv`
  bridge (`lem:stalk_tensor_linear_map`).

### Step 2 — `stalkTensorRev`
`stalkTensorRev := TensorProduct.liftAddHom (ConcreteCategory.hom (revBihom A B x)) revBihom_balanced`
(the `A_x ⊗_{R_x} B_x →+ (A⊗ᵖB).stalk x` additive map; upgrade to `R_x`-linear if the bundle needs it).

### Step 3 — `stalkTensorIso` (bundle, stage v)
- fwd = `stalkTensorLinearMap` (DONE), rev = `stalkTensorRev`.
- `fwd∘rev = id` on `germ a ⊗ germ b`: `stalkTensorLinearMap_germ_tmul` + `TensorProduct.induction_on`.
- `rev∘fwd = id` on `germ(a⊗b)`: `revBihom_germ_tmul` + `stalk_hom_ext` (germ joint-epi) +
  `TensorProduct.induction_on` per section.
- Bundle into the iso of `R_x`-modules (`lem:stalk_tensor_commutation`).

Constraints: mathlib-build (no sorry pins). Keep file import-minimal (no `Vestigial` import;
mirror d.1 `stalkLinearMap` germ pattern). Blueprint stage-(iv) prose expanded this iter with the
Step-1 guidance.

Recipe: `Picard_TensorObjSubstrate.tex` §`sec:tensorobj_stalk_tensor` stages (iv)/(v);
iter-235 handoff `task_results/archive/iter-235/AlgebraicJacobian_Picard_TensorObjSubstrate_StalkTensor.lean.md`.

## Lane 2 — `Cohomology/FlatBaseChange.lean` [mathlib-build] — engine brick

**Goal:** build the single Mathlib-absent brick `AlgebraicGeometry.pushforward_spec_tilde_iso`, then
close `affineBaseChange_pushforward_iso`.

### Step 1 — `pushforward_spec_tilde_iso`
Object iso of `(Spec R).Modules`:
`pushforward (Spec.map φ) (tilde M) ≅ tilde (restrictScalars φ.hom M)`. Four movements:
1. Sections agree on `⊤` with no transport: `(Spec.map φ)⁻¹ᵁ ⊤ = ⊤` is `rfl` (`Scheme.preimage_top`);
   `pushforward_obj` rfl. Global sections: LHS = `M`, RHS = `restrictScalars φ M`, same abelian group.
2. Comparison ring map at `⊤` = `f.appTop` (`f = Spec.map φ`), conjugate to `φ` via
   `Scheme.ΓSpecIso_inv_naturality`. So the `R`-action on the pushforward sections is restriction of
   scalars along `φ`. Accessor: `f.toRingCatSheafHom.hom.app (op ⊤)` / `f.appTop` (NOT `.val`).
3. Assemble via `tilde` full-faithfulness (`Tilde.fullyFaithfulFunctor`) + the `fromTildeΓ` counit isos
   on both QC sides (`isIso_fromTildeΓ_iff`).
4. Residual `ModuleCat`-level scalar-compat: `letI := Module.compHom … (algebraMap …)` +
   `IsScalarTower.of_algebraMap_smul` + `algebraMap_smul` (idiom copied from Mathlib `Tilde.lean`; the
   action IS nameable — refutes the iter-234 "not synthesizable" diagnosis).

### Step 2 — close `affineBaseChange_pushforward_iso`
Full-faithfulness reframe: `isIso_fromTildeΓ_iff` + `fromTildeΓNatTrans` reflect-isos ⇒
`IsIso α ↔ IsIso (moduleSpecΓFunctor.map α)`, a concrete `ModuleCat R` map = `cancelBaseChange`.
The object iso also gives QC-of-pushforward for free (`IsClosedUnderIsomorphisms` + `tilde` instance).

Constraints: mathlib-build (no sorry pins; commit axiom-clean fragments + decomposition if not fully
closed). WATCH: a zero-commit round re-triggers STUCK (progress-critic ts236). Do NOT attempt the deep
`flatBaseChange_pushforward_isIso` (Čech+flatness) — it stays a documented sorry.

Recipe: `Cohomology_FlatBaseChange.tex` (`lem:pushforward_spec_tilde_iso`, 4-movement sketch added this
iter); `analogies/fbc-dict.md`.
