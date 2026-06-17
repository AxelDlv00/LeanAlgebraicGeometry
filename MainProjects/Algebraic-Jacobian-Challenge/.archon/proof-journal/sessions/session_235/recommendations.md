# Recommendations — for the iter-236 plan agent

## Closest-to-completion target — d.2 stage (iv) balancing, then stage (v) bundle

**`StalkTensor.lean` — `revBihom_balanced` → `stalkTensorRev` → `stalkTensorIso`.** The lead
critical-path lane. The whole reverse-map descent (10 axiom-clean decls) landed this iter; the
ONLY residual before `stalkTensorRev` is the `R.stalk x`-balancing `revBihom_balanced`, then the
stage-(v) mutual-inversion bundle. This is the most-converged target in the project — dispatch it.

### USE route 2 (stalk-level smul). DO NOT re-try the section-level route.

The prover spent this iter's residual effort confirming the **section-level** `smul_tmul` route is
blocked: `PresheafOfModules.map_smul` introduces a `restrictScalars` wrapper that makes the smul
live over the `RingCat` carrier on a `restrictScalars`-module, while the section tensor is over the
`CommRingCat` carrier on the plain module — `TensorProduct.smul_tmul` cannot synthesize the defeq.
Every variant failed (`exact smul_tmul`, `smul_tmul (R:=…)` with both carriers, `haveI :=
ModuleCat.isModule …; smul_tmul`, `rw smul_tmul/smul_tmul'`).

**Tell the prover: do NOT re-attempt the section-level `smul_tmul` recipe.** Instead, prove the
balancing at the **stalk level**: `revBihom (r • a) b = r • (revBihom a b)`, where `St =
(A⊗ᵖB).stalk x` carries the `R_x`-action from `ModuleCat.Stalk`. Use the `T`-presheaf `germ_smul`
so the scalar stays at `R_x` throughout — this is exactly where the existing stalk-level
`stalkTensorBilin_balanced` / `stalkTensorDescU_smul` smuls already succeed (no RingCat /
restrictScalars carrier appears). Then:
`stalkTensorRev := TensorProduct.liftAddHom (ConcreteCategory.hom (revBihom A B x)) revBihom_balanced`.

All inputs (`revBihom`, `revBihom_germ_tmul`, `revOuterLeg_apply`, `germ_smul`) are built
axiom-clean and in-file. After `stalkTensorRev`, stage (v) bundle: `fwd = stalkTensorLinearMap`
(DONE), `rev = stalkTensorRev`; `fwd∘rev = id` on `germ a ⊗ germ b` via
`stalkTensorLinearMap_germ_tmul` + `TensorProduct.induction_on`; `rev∘fwd = id` on `germ(a⊗b)` via
`revBihom_germ_tmul` + `stalk_hom_ext` (germ joint-epi) + `induction_on`.

### Blueprint action BEFORE the prover round (plan agent / blueprint-writer)

`lean-vs-blueprint-checker stalktensor` (minor) flagged that the stage-(iv) prose only says
"R_x-bilinearity reduces to the germ–scalar compatibility of (i)/(iii)" and does NOT describe the
carrier-duality sub-obstacle the Lean actually hit. Dispatch a blueprint-writer to add (to stage
(iv) of `§sec:tensorobj_stalk_tensor`) a sentence naming the balancing condition and the
stalk-level route-2 resolution, so the next prover has the obstacle in the chapter, not just in a
soon-to-be-stale in-file comment. (The review agent already corrected the `% NOTE:` marker; the
*prose* addition is the plan agent's domain.)

## Watch item — the "retired" carrier-duality risk is NOT fully retired

iter-234's review recorded the CommRingCat/RingCat carrier-duality as "retired" by the stage-(iii)
recipe. That was narrowly true for stage (iii) but the balancing exposed an **extra `restrictScalars`
wrapper** that breaks verbatim transfer. Frame the next-iter convergence gate accordingly:
**land `revBihom_balanced` + `stalkTensorRev` this round (route 2), or the d.2 *tactic* (not the
carrier pivot) should be re-evaluated.** Three consecutive converging iters is real progress, but
the absolute counter is flat for 18 iters — the iso must actually assemble soon to convert the
lane's convergence into a counter move.

## Engine lane — FlatBaseChange (do NOT re-dispatch a prover without the new recipe in hand)

No prover ran on FlatBaseChange this iter (the slot was a `mathlib-analogist` consult, per the
iter-235 STUCK verdict). The consult was high-value (per iter-235 plan.md): it found a **CRITICAL
soundness defect** — both `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso`
took an arbitrary `F : X.Modules`, FALSE as typed (Stacks 02KH needs quasi-coherence); the planner
applied a refactor adding `[F.IsQuasicoherent]` to both (build green). The consult also reduced the
lane to ONE Mathlib-absent brick: `pushforward (Spec.map φ) (tilde M) ≅ tilde (restrictScalars φ.hom M)`,
reachable via `tilde.functor` full-faithfulness + the `fromTildeΓ` counit (no section-smul instances).
**For iter-236:** if the planner re-opens FlatBaseChange, it must come with that concrete recipe and
the blueprint expanded to cover the single brick — not a cosmetic recipe variation on the dead
instance-wall route. Otherwise this lane stays deferred behind the d.2 critical path.

## Reusable proof patterns discovered this iter (also folded into PROJECT_STATUS Knowledge Base)

- **Cocone-naturality plumbing for `colimit.desc` over `(OpenNhds.inclusion x).op ⋙ M.presheaf`:**
  `apply AddCommGrpCat.hom_ext; ext b; simp only [comp_apply, Functor.const_obj_map];
  erw [CategoryTheory.ConcreteCategory.id_apply]`. The `((const).obj _).map f = 𝟙` survives
  `rw [Category.comp_id]` / `simp`; the `(𝟙).hom` wrapper must be killed at the element level by
  `erw [ConcreteCategory.id_apply]` (plain `rw` / `simp` on it times out in `whnf`).
- **Expanding a `private` `rfl`-leg-eval lemma under a `𝟙`/`ofHom` wrapper:** plain `rw` + a 2nd
  `erw` time out in `whnf`; use `conv_rhs => erw [leg_apply]` to narrow scope.
- **Section-equality from presheaf functoriality + poset thinness** (the germ_res residual):
  `rw [← presheaf_map_apply_coe, …]` to uniformise `M.map` → `M.presheaf.map`, then
  `erw [← CategoryTheory.ConcreteCategory.comp_apply, ← Functor.map_comp]` to merge composites
  (`comp_apply` merges ANY two composable `AddCommGrpCat` morphisms regardless of producing functor;
  after `Functor.comp_map` it merges `((incl).op ⋙ M.presheaf).map f` with `M.presheaf.map _`),
  then `congr 1` discharges the morphism equality by thinness (proof irrelevance on `homOfLE` `≤`-proofs).
- **`map_add` / `map_zero` on bundled `ConcreteCategory.hom`:** plain `rw` / `simp` fail the
  `AddMonoidHomClass` synth during matching — use `erw [_root_.map_add, …]`.
