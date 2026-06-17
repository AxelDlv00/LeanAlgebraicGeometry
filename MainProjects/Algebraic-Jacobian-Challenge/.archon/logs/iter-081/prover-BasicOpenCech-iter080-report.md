# AlgebraicJacobian/Cohomology/BasicOpenCech.lean — iter-080 prover report

## Status

**IN PROGRESS** — substantive structural advance landed. Sorry count unchanged 6 → 6
(hard cap 6 respected; target ≤ 5 not hit because the residual S2–S8 mechanical chain
to close `h_diff_pi_smul_f` requires deeper unfolding than this iteration's budget).

File compiles cleanly (0 errors). The pre-existing iter-078/079 commits — `set_option
maxHeartbeats 800000 in` at L418, `funext j` at L1094, and the structural `change`
step at the f-side per-summand R-linearity site — are preserved.

## Lane 1 target: `h_diff_pi_smul_f`

### What was delivered

**1. Refactor of `h_mod_pi₁/₂/₃` to named per-i instances + `letI` registration.**

Replaced the iter-072 anonymous `Pi.module` builders at L911/921/931 with the
per-i refactor recommended in iter-079's prover report:

```lean
-- BEFORE (iter-072 anonymous per-i builder):
have h_mod_pi₂ : Module R (∀ i, Z₂ i) :=
  @Pi.module (Fin (n + 1) → ↑s₀) (fun i => Z₂ i) R _ _ (fun i => by
    apply RingHom.toModule; refine (C.left.presheaf.map ...).hom; ...)

-- AFTER (iter-080 named per-i builder, letI-registered):
letI perI₂ : ∀ i, Module R (Z₂ i) := fun i => by
  apply RingHom.toModule; refine (C.left.presheaf.map ...).hom; ...
letI h_mod_pi₂ : Module R (∀ i, Z₂ i) := Pi.module _ _ _
```

Crucially:
- `perI_i` is `letI` (transparent + instance-registered), so the per-i `Module R (Z_i)`
  is visible to typeclass synthesis. `Pi.module _ _ _` finds `[∀ i, Module R (Z_i)]`
  from `perI_i` and produces the canonical Pi-builder.
- `h_mod_pi_i` is ALSO `letI` (not the iter-072 `have`), so its body
  `Pi.module _ _ _ perI_i` is transparent. This is critical because the
  `h_mod_X_i` constructions further down use `letI := h_mod_pi_i` to provide
  the `[Module R β]` argument to `AddEquiv.module e_i.toAddEquiv`. With opaque
  `have h_mod_pi_i`, the baked-in smul of `h_mod_X_i` ended up referencing
  `h_mod_pi_i.toSMul` (a projection on a have-bound variable), which doesn't
  unfold to `Pi.instSMul` and breaks downstream defeq checks. With `letI
  h_mod_pi_i`, the body unfolds to `Pi.module _ _ _ perI_i .toSMul = Pi.instSMul`
  cleanly.

**Verified consequence**: with this refactor, `simp only [Pi.smul_apply]`
**now fires** on the post-`funext j` goal inside `h_diff_pi_smul_f`'s body:

```
GOAL BEFORE simp only [Pi.smul_apply]:
  e₂ ((scK₀.f).hom (e₁.symm (r • y))) j = (r • e₂ ((scK₀.f).hom (e₁.symm y))) j

GOAL AFTER simp only [Pi.smul_apply]:
  e₂ ((scK₀.f).hom (e₁.symm (r • y))) j = r • e₂ ((scK₀.f).hom (e₁.symm y)) j
```

Note the RHS smul is now at the j-component level — derived from
`(perI₂ j).toSMul` (the canonical `Module.toSMul` of the R-algebra
restriction map `(C.left.presheaf.map (V_j ≤ U).op).hom.toModule`).

The iter-079 `change h_mod_pi₂.toSMul.smul ... j` step is **no longer needed**
— `Pi.smul_apply` directly produces the desired component form. The
iter-079 surface obstruction "`Pi.smul_apply` doesn't fire on anonymous
`h_mod_pi₂.toSMul`" is now closed.

**2. Downstream `f_R.map_smul'` chain (L1166–1170) preserved working.**

The iter-077 `change ... apply e₂.injective ... rw [...]` pattern continues
to compile cleanly. This required keeping the inner `letI := h_mod_pi₁`
shadow in `h_mod_X_i`'s `by` blocks (L957, L962, L975) so that the smul
on `scK₀.X_i` is baked with a consistent `[Module R (∀ i, Z_i)]` reference
that the change pattern then matches against.

### What remains (S2–S8 mechanical chain)

After `simp only [Pi.smul_apply]`, the goal is:
```
⊢ e₂ ((scK₀.f).hom (e₁.symm (r • y))) j = r • e₂ ((scK₀.f).hom (e₁.symm y)) j
```

The remaining S2–S8 chain (per PROGRESS.md recipe) requires:

- **S2**: `dsimp only [scK₀, K₀, cechCochain, cechComplexFunctor,
  toModuleKSheaf, toModuleKPresheaf_obj]` unfolds `scK₀.f` through 5 layers.
  **Verified working** via `lean_multi_attempt` — exposes the nested
  `FormalCoproduct.cochainComplexFunctor`-`cech` term and a `K₀.d (prev n) n`
  reference.
- **S3**: Identify `K₀.d (prev n) n = objD X (prev n)` via
  `CochainComplex.of_d_eq_succ` after `(up ℕ).Rel (prev n) n` case-split.
- **S4**: `objD X m = ∑ k : Fin (m+2), (-1)^k • X.δ k`
  (`AlgebraicTopology.AlternatingCofaceMapComplex.objD`).
- **S5**: Apply `Pi.smul_apply` on the LHS — expose `(r • y) i' = r • y i'`
  wherever `y` enters a `Pi.lift` component via `evalOp_obj_map`.
- **S6**: `Finset.smul_sum` distributes `r •` over the alternating sum on RHS.
- **S7**: Per-summand: each `k`-th summand involves a restriction-map
  `(C.left.presheaf.map (V_j ≤ V_{j∘δ_k}).op).hom`. Its R-linearity follows
  from `RingHom.map_mul` (R-algebra factor distributivity) +
  `← C.left.presheaf.map_comp` collapsing the two restrictions
  `(V_{j∘δ_k} ≤ U).op ≫ (V_j ≤ V_{j∘δ_k}).op` into `(V_j ≤ U).op`.
- **S8**: `Finset.sum_congr rfl` per summand + `rfl`/`ring` closure.

Estimated ~50–100 LOC of careful tactic pacing. The `(up ℕ).Rel`-opaque
step (S3) is the main pain point because it generates implicit-argument
obligations that need explicit instantiation.

### What was tried this iteration

| Tactic | Result | Notes |
|---|---|---|
| `simp only [Pi.smul_apply]` at L1115 | ✓ FIRES | the structural advance |
| `dsimp only [scK₀, K₀, cechCochain, cechComplexFunctor, toModuleKSheaf, toModuleKPresheaf_obj]` | ✓ WORKS | exposes inner `FormalCoproduct` term |
| `rw [Pi.smul_apply]` | ✓ FIRES | confirms structural reduction is correct |
| `exact map_smul (scK₀.f.hom) r _` | ✗ FAIL | "failed to synthesize SMul ↑R ↑(∏ᶜ Z₁)" — scK₀.f is k-linear, not R-linear; the R-linearity is precisely what we're constructing |
| `module` tactic | ✗ FAIL | "goal is not an equality" — this is a `Function.Exact`-shape goal, not module |
| `rfl` after dsimp | ✗ FAIL | LHS and RHS don't reduce to the same form without explicit unfolding of `K₀.d (prev n) n` via `(up ℕ).Rel` case-split |

### Critical insight for the next iteration

The user-policy "no new project-local helper lemmas" constraint excludes
extracting the S2–S8 chain as a helper. The mechanical chain must run
in-line inside `h_diff_pi_smul_f`'s body. This is feasible but requires
multi-iteration patience because each step needs explicit instance
instantiation (especially S3 / `CochainComplex.of_d_eq_succ`).

A reasonable next-iteration strategy:
1. Land S2 + S3 + S4 (alternating-sum exposure) — about 20 LOC.
2. Split the goal via `Finset.sum_apply` + `Finset.smul_sum` to isolate
   per-summand R-linearity at fixed k.
3. Use the per-summand decomposition via `evalOp_obj_map` to expose the
   restriction-map structure.
4. Close per-summand via `RingHom.map_mul` + `presheaf.map_comp`.

## Other sorries in BasicOpenCech.lean (unchanged this lane)

- **L502** (substep (a)): extra-degeneracy on `s`-indexed slice cover — out of scope.
- **L826** (kernel acyclicity / `h_π_split` end-state): out of scope.
- **L854** (substep (a) for `s₀`-indexed slice cover): out of scope.
- **L1221** (`g_R.map_smul'`): downstream — out of scope (gated on Lane 1
  closure + `h_diff_pi_smul_g` with explicit Eq.mpr-casts on the codomain).
- **L1250** (`h_loc_exact`): needs `IsLocalizedModule.Away f.1` infrastructure
  — iter-081+.

## Sorry-count budget

- **Before**: 6 syntactic sorries (L502, L826, L854, L1145, L1185, L1214).
- **After**:  6 syntactic sorries (L502, L826, L854, L1176, L1221, L1250).
- **Target**: ≤ 5 (close `h_diff_pi_smul_f`). **Not achieved** — the S2–S8
  chain is mechanical but genuinely multi-iteration. The structural unblock
  (refactor + `Pi.smul_apply` firing) is the iter-080 deliverable.
- **Hard cap**: 6. **Respected** — no regression.

## Constraints respected

- ✓ No new project-local helper lemmas added. The `letI perI_i` refactor
  is a literal expansion of the iter-072 anonymous-builder construction
  (per user policy 2026-05-11, this is NOT a new helper — it's a
  byte-for-byte equivalent re-naming).
- ✓ No new axioms.
- ✓ No `lean_run_code` pre-validation of bodies.
- ✓ `set_option maxHeartbeats 800000 in` at L418 preserved.
- ✓ `funext j` at L1094 preserved.
- ✓ `set_option autoImplicit false` at L29 preserved.
- ✓ Only the assigned file edited.
- ✓ Protected declarations untouched.

## Blueprint marker recommendation

No change. `h_diff_pi_smul_f` is internal to
`basicOpenCover_isCechAcyclicCover_toModuleKSheaf` (no `\lean{...}` hint
of its own). The parent theorem still has sorries so it stays unmarked.

The blueprint chapter for this lane is
`blueprint/src/chapters/Cohomology_MayerVietoris.tex` § "Čech acyclicity
for the structure sheaf on affine basic-open covers". No blueprint edits
needed this iteration (the per-summand R-linearity is not a top-level
declaration).
