# AlgebraicJacobian/Cohomology/BasicOpenCech.lean — iter-078 prover report

## Status

**IN PROGRESS** — partial structural progress, sorry count unchanged (6 → 6).
File compiles cleanly with 0 errors.

## Lane 2 target: `h_diff_pi_smul_f` (now L1094)

### What I did

1. **Added `set_option maxHeartbeats 800000 in`** at L411 directly above the
   docstring of `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`. This is
   the heartbeats lift required for *any* further tactic work inside the
   `have h_diff_pi_smul_f` block: even adding two more tactic steps below
   `intro r y` previously cascaded into a `whnf` timeout at L412 (theorem
   head) because the `(r • _) j` smul forces `HSMul ↑R ↑(Z₂ j) ?_` synthesis
   that whnf-s through `h_mod_pi₂`'s `RingHom.toModule (presheaf.map …).hom`
   builder.

2. **Replaced `intro r y; sorry`** with the S1–prefix:
   ```
   intro r y
   funext j
   sorry
   ```
   `funext j` cleanly reduces to the per-output-index goal:
   ```
   e₂ ((scK₀.f).hom (e₁.symm (r • y))) j = (r • e₂ ((scK₀.f).hom (e₁.symm y))) j
   ```
   I initially tried `simp only [Pi.smul_apply]` here but it produced an
   "unused simp argument" warning (simp doesn't unify `Pi.smul_apply` with
   the `h_mod_pi₂`-mediated smul without first exposing the `Pi.module`
   builder by `change`). Removed it from the final code, but the next-iter
   prover should still try `change` to a concrete per-component formula
   before re-attempting any `Pi.smul_apply`-based simplification.

### What remains

The substantive content S2–S8 of the iter-073 recipe:

- **S2 (5-layer dsimp).** Unfold `scK₀.f` through
  `cechCochain → cechComplexFunctor → FormalCoproduct.cochainComplexFunctor →
   FormalCoproduct.cosimplicialObjectFunctor + AlgebraicTopology.alternatingCofaceMapComplex`.
  After this, `(scK₀.f).hom` is exposed as `objD X (prev n)` where
  `X := (evalOp.obj P) ∘ ((mk … cech).rightOp)` for the underlying presheaf
  `P := (sheafToPresheaf _).obj (toModuleKSheaf C)`.
- **S3.** Use `AlgebraicTopology.AlternatingCofaceMapComplex.objD` to expose
  the differential as `∑ k : Fin (prev n + 2), (-1)^k • X.δ k` where
  `X.δ k = X.map (op (SimplexCategory.δ k))`.
- **S4.** `Pi.smul_apply` on the LHS to evaluate `(r • y) (j ∘ δ_k.toOrderHom)`.
- **S5 (`Finset.smul_sum`).** Distribute `r •` across the alternating sum.
- **S6 (`Finset.sum_congr`).** Reduce to per-summand R-linearity.
- **S7 (per-summand).** For each `k`, the j-component of `X.δ k` (read off
  via `evalOp_obj_map` and `Pi.lift`) is
  `Pi.π Z₁ (j ∘ δ_k.toOrderHom) ≫ (P.map (φ_k j).op)` where `φ_k j` is a
  morphism in `Scheme.Opens` with `V_j ≤ V_{j ∘ δ_k}`. Per-component
  R-linearity then follows from:
  ```
  (presheaf.map (V_j ≤ V_{j∘δ_k}).op).hom ((presheaf.map (V_{j∘δ_k} ≤ U).op).hom r * x)
    = (presheaf.map (V_j ≤ U).op).hom r * (presheaf.map (V_j ≤ V_{j∘δ_k}).op).hom x
  ```
  (ring-hom distributivity + presheaf-functoriality on the `(V_j ≤ U)` chain).
- **S8 (`rfl` or `ring`).** Close after the chain.

### Why this is hard

Three compounding obstacles:

1. **Heartbeat sensitivity.** Any rewrite touching the `(r • _) : Π → Π`
   smul triggers `HSMul ↑R ↑(Z_i j) ?_` synthesis that pushes whnf past the
   200000 default budget *at the theorem head*, not just locally. The
   `set_option maxHeartbeats 800000 in` lift this iteration is a necessary
   prerequisite for any further work.

2. **The `K₀.d ↔ objD` opacity.** `K₀.d (prev n) n` is `K₀.d` via
   `CochainComplex.of` + `(up ℕ).Rel (prev n) n` case-split. The "is-Rel"
   case is not reducible by `dsimp` without explicit
   `CochainComplex.of_d_eq_succ` rewrites for the `up ℕ` shape.

3. **Pi-product index gymnastics.** The differential's j-component
   identification requires chasing through `Pi.lift`/`Pi.π` + `evalOp.obj`
   on `FormalCoproduct.cosimplicialObjectFunctor.cech.rightOp`. The
   `evalOp_obj_map` simp lemma (verified in Mathlib at
   `Mathlib/CategoryTheory/Limits/FormalCoproducts/Basic.lean` L383) provides
   the structural fact `(evalOp.obj F).map f = Pi.lift (fun i ↦ Pi.π _ (f.unop.f i) ≫ F.map (f.unop.φ i).op)`,
   but the chain through `cech.rightOp` and `powerMap` adds an extra layer.

### Approaches I tried and ruled out

- **`rw [Pi.smul_apply]`**: failed with "Did not find an occurrence of the
  pattern (?a • ?f) ?i". The smul instance on the RHS doesn't unify with
  `Pi.instSMul` without unfolding through `h_mod_pi₂`'s opaque builder.
- **`show e₂ (…) j = r • (e₂ (…)) j`**: failed with "failed to synthesize
  instance of type class HSMul ↑R ↑(Z₂ j) ?_". There's no standalone R-action
  on `Z₂ j` — only on the product, via `h_mod_pi₂`.
- **`exact (LinearEquiv.map_smul e₂ r _)`**: failed — `e₂` is `k`-linear, not
  `R`-linear.
- **Constructing `L : (∀ i, Z₁ i) →ₗ[R] (∀ i, Z₂ i)` directly**: doesn't avoid
  the work — `L.map_smul` still requires the substantive per-summand chain.

### Mathlib references confirmed this pass

- `ModuleCat.piIsoPi_inv_kernel_ι` : `(piIsoPi Z).inv ≫ Pi.π Z i = ofHom (LinearMap.proj i)`
- `ModuleCat.piIsoPi_hom_ker_subtype` : `(piIsoPi Z).hom ≫ ofHom (LinearMap.proj i) = Pi.π Z i`
  (both `@[elementwise]` — gives applied forms)
- `CategoryTheory.Limits.FormalCoproduct.evalOp_obj_map` : the explicit
  `Pi.lift` form for the cosimplicial differential
- `AlgebraicTopology.AlternatingCofaceMapComplex.objD` :
  `objD X n = ∑ i : Fin (n + 2), (-1)^i • X.δ i`
- Project-local `AlgebraicGeometry.Scheme.toModuleKSheaf.algebraMap_naturality`
  (L161 of `StructureSheafModuleK.lean`) — the k-level version of per-component
  R-linearity. The R-level analogue is what S7 above needs.

## Other sorries in BasicOpenCech.lean (unchanged this lane)

- L496 (substep (a)): extra-degeneracy on `s`-indexed slice cover — dead end this lane.
- L820 (kernel acyclicity / `h_π_split` end-state): dead end this lane.
- L848 (substep (a) for `s₀`-indexed slice cover): dead end this lane.
- L1134 (`g_R.map_smul'`): downstream of `h_diff_pi_smul_f` — gated on Lane 2 landing.
- L1163 (`h_loc_exact`): needs `IsLocalizedModule.Away f.1` infrastructure — iter-079+.

## Recommendations for plan agent / next iteration

1. **Keep `set_option maxHeartbeats 800000 in`** — removing it will re-trigger
   the timeout cascade.
2. **Resume from the L1087–1094 state** — the `funext j` reduction is sound;
   build the S2 dsimp + S3 `objD` exposure on top.
3. **Consider `change`-based manual exposure** of the smul as a workaround
   for `simp only [Pi.smul_apply]` not firing — e.g., explicitly state the
   per-component smul formula via the per-i restriction map.
4. **Alternative**: skip the `funext`-then-rewrite approach entirely and
   construct `f_R` directly as `LinearMap.mk` using a `restrictScalars`-
   transported underlying differential — but this requires building the
   R-side cochain differential, which is itself iter-079+ work and depends
   on the same per-summand R-linearity content.

## Blueprint marker recommendation

No change. `h_diff_pi_smul_f` is internal to
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf` and has no `\lean{...}`
hint of its own; the parent theorem already lacks `\leanok` (still has
sorries).
