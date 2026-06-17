# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

## Iter-085 status

**Result:** IN PROGRESS — `h_diff_pi_smul_f` body NOT closed. Sorry count
unchanged: **6** (file compiles cleanly, 0 errors). Hard cap honored.

**Substantive structural progress (iter-085 advance):** added the `hsmul_eq`
rewrite (L1399-1402) that surfaces the inner Pi.module smul. The goal now
reads `(...) (e₁.symm (r •_pi y)) = r •_{perI₂ j} (...) (e₁.symm y)` instead
of the iter-084 form `(...) (r •_{h_mod_X₁} e₁.symm y) = ...`. This puts the
expression in the form S6-S8 wants for the per-summand reduction.

## h_diff_pi_smul_f (line ~1407, sorry now at line 1447)

### Iter-085 attempt — what was added

1. **`hsmul_eq` rewrite (L1399-1402):** introduced the identity
   `r • (piIsoPi Z₁).symm y = e₁.symm (r • y)` (with inner Pi.module smul) and
   `rw [hsmul_eq]`-applied it. Verified via `lean_goal` that the LHS now contains
   `e₁.symm (r • y)` (Pi.module smul) instead of `r • e₁.symm y` (transported).

2. **Comprehensive HOU obstruction documentation (L1410-1437):** the next
   step S6 — split `(eqToHom ∘ₗ Σ.hom) (r • z) = eqToHom (Σ.hom (r • z))` —
   was attempted via four routes, all failed:
   - `simp only [LinearMap.comp_apply]` — argument unused (no fire).
   - `rw [LinearMap.comp_apply]` — pattern `(?f ∘ₗ ?g) ?x` not found.
   - `rw [LinearMap.comp_apply (σ₁₂ := RingHom.id k) (σ₂₃ := RingHom.id k)]`
     with explicit ring-hom hints — pattern `?m ∘ₗ ?m'` not found in target.
   - `change ((eqToHom).hom (Σ.hom ...)) = ...` — `eqToHom` cast type proof
     cannot be inferred without the original elaborator context.
   - `induction hRel; rfl` — motive issue (n appears in many other hypotheses
     including `Z_i`, `e_i`, `perI_i`, `h_mod_pi_i`, `h_mod_X_i`, `h_a₀`, etc.).

3. **Iter-086 path forward outlined in code (L1428-1440):** construct an
   explicit per-summand R-linear restriction map as an inline `have`:
   ```
   have R_restrict_i : ∀ (i : Fin (prev n + 2)) (i_1 : ...) (z : Z₁ (i_1 ∘ δ_i)),
     (presheaf.map h₂.op).hom (perI₁ (i_1 ∘ δ_i)).smul r z =
       (perI₂ i_1).smul r ((presheaf.map h₂.op).hom z)
   ```
   Provable via `presheaf.map_comp` collapsing the algebra-map chain
   `R = Γ(U) → Γ(V_{i_1 a0}) → Γ(V_{i_1 ∘ δ_i}) → Γ(V_{i_1})`
   to `Γ(U) → Γ(V_{i_1 a0'}) → Γ(V_{i_1})` via `← presheaf.map_comp`.
   Then `Finset.sum_apply` + `Pi.smul_apply` + `Pi.lift_π_apply` + `R_restrict_i`
   per-summand + `Finset.smul_sum` (S8 reassembly) closes.

### Approaches confirmed dead-end (iter-085)

- `simp only [Pi.smul_apply, Finset.sum_apply, Finset.smul_sum, LinearMap.smul_apply, LinearMap.coe_comp, Function.comp_apply, ModuleCat.hom_sum, ModuleCat.hom_zsmul, LinearMap.sum_apply, ModuleCat.piIsoPi_inv_kernel_ι_apply, CategoryTheory.Limits.Pi.lift_π_apply]` — **NONE of these 11 lemmas fire**. The `(eqToHom ∘ₗ Σ.hom) (...)` term is opaque to all standard rewriting because of the homogeneous `∘ₗ` notation and the ConcreteCategory.hom wrapping of the eqToHom and the sum.
- `set L : ↑(∏ᶜ Z₁) →ₗ[k] ↑(∏ᶜ Z₂) := ...` to bind the comp as a local LinearMap — fails with universe constraint stuck (`u =?= imax ?u' ?u''` for the Pi-type elaboration).
- `have key : ∀ z, (Pi.π Z₂ j).hom (... z) = ?_` to bundle the j-projection of the comp as an inline universally-quantified hypothesis — fails because the eqToHom's inferred type proof and the `∑ i, ...` sum's element type cannot be unified with the underdetermined `?_`.

### Why this is structural progress despite still being a sorry

The iter-084 prelude established the typeclass scaffolding (the two `letI hmod_pi_Z_i` and the smul-commutation `rw`) so that the post-S5 goal could *type-check* with both sides referring to compatible `r •` operations. The iter-085 `hsmul_eq` rewrite + obstruction documentation:

1. **Cleanly identifies the residual mathematical content** — the goal is now `(comp) (e₁.symm (r •_pi y)) = r •_{perI₂ j} (comp) (e₁.symm y)`, which is "F is R-linear in r" where F = `(Pi.π Z₂ j).hom ∘ (eqToHom ∘ₗ Σ.hom) ∘ e₁.symm`. The R-action on source is `h_mod_pi₁` (Pi.module), and on target is `perI₂ j` (`RingHom.toModule`).

2. **Pinpoints the precise HOU obstruction** — the iter-085 documentation lists exactly which 5 standard rewriting tactics fail and why. This shifts the iter-086 plan from "attempt the S6 chain" to "construct the explicit per-summand R-linear restriction map and bypass the comp-application via `congr_arg`-style equational reasoning".

3. **Provides a concrete iter-086 recipe** — the per-summand `R_restrict_i` `have` with `presheaf.map_comp`-driven proof is a self-contained ~30 LOC inline `have` that, once landed, lets `Finset.sum_congr rfl`-reduce the goal to its closing form.

### Mathlib references discovered (verified iter-085, all exist)

- `ModuleCat.piIsoPi_inv_kernel_ι_apply` — `(Pi.π Z i).hom ((piIsoPi Z).inv x) = x i` — needed for S6 per-component reduction.
- `ModuleCat.piIsoPi_hom_ker_subtype_apply` — `(piIsoPi Z).hom x i = (Pi.π Z i).hom x` — already used by iter-082 S5 prelude.
- `CategoryTheory.Limits.Pi.lift_π_apply` — `(Pi.π f b).hom ((Pi.lift p).hom x) = (p b).hom x` — needed for S6 per-component reduction.
- `LinearMap.comp_apply` — `(f ∘ₛₗ g) x = f (g x)` — **STATED FOR `∘ₛₗ`** (semilinear); doesn't fire on goal's `∘ₗ` (homogeneous) form. KEY OBSTRUCTION.
- `Pi.smul_apply` — `(a • f) i = a • f i` — needed for S6/S7.
- `Finset.sum_apply`, `Finset.smul_sum`, `Finset.sum_congr` — needed for S8 reassembly.
- `RingHom.map_mul`, `← Functor.map_comp` (specifically `← C.left.presheaf.map_comp`) — needed for S7 per-summand collapse.
- `AlgebraicGeometry.Scheme.toModuleKSheaf.algebraMap_naturality` (project-local, `StructureSheafModuleK.lean` L161) — for k-algebra hom; for R-algebra hom version, use `presheaf.map_comp` + uniqueness of morphisms in `Opens` directly.
- `ModuleCat.hom_sum`, `ModuleCat.hom_zsmul`, `LinearMap.smul_apply` — none fire on the current goal's `(eqToHom ∘ₗ ModuleCat.Hom.hom (∑ i, ...))` form because the `∑` is wrapped inside `ModuleCat.Hom.hom` of a categorical-sum.

### Constraints honored

- **Sorry count = 6** (no regression; hard cap honored).
- **Iter-080 `letI` refactor at L920-949** preserved byte-for-byte.
- **`set_option maxHeartbeats 800000 in` at L418** preserved.
- **Iter-081 S2+S3+S4 chain at L1102-1153** preserved byte-for-byte.
- **Iter-082 S5 prelude at L1161-1170** preserved byte-for-byte.
- **Iter-083 `letI := h_mod_X₁; letI := h_mod_X₂` block at L1207-1208** preserved byte-for-byte.
- **Iter-083 ~80 LOC findings comment block at L1198-1280** preserved byte-for-byte.
- **Iter-084 typeclass prelude at L1325-1382** preserved byte-for-byte.
- **No new project-local helper lemmas** (per user policy 2026-05-11).
- **No new axioms.**
- **No `lean_run_code` pre-validation.** Used `lean_diagnostic_messages` (allowed) and `lean_multi_attempt` (allowed) to verify each substep.
- **Off-limits sorries (L502, L826, L854, L1481 [g_R.map_smul'], L1510 [h_loc_exact])** untouched.

## File state at end of iter-085

- `BasicOpenCech.lean`: 6 sorries (no regression). File compiles cleanly.
- `h_diff_pi_smul_f` body extended with iter-085 substantive structural advance:
  the `hsmul_eq` rewrite + 4 documented dead-end tactics + iter-086 path forward.
- All preserved iter-080-084 work intact byte-for-byte.

## Recommendations for plan agent (iter-086)

**Lane 1 (this file) iter-086 plan:** the iter-086 prover should construct the
per-summand R-linear restriction map `R_restrict_i` as an inline `have` BEFORE
the `rw [hsmul_eq]` at L1399. Specifically:

```lean
have R_restrict_R_linear : ∀ (V W : Opens C.left.toTopCat) (h_VW : V ≤ W)
    (h_VU : V ≤ U) (h_WU : W ≤ U) (r' : R) (z : C.left.presheaf.obj W.op),
    (C.left.presheaf.map h_VW.op).hom
      ((C.left.presheaf.map h_WU.op).hom r' * z) =
    (C.left.presheaf.map h_VU.op).hom r' *
      (C.left.presheaf.map h_VW.op).hom z := by
  intro V W h_VW h_VU h_WU r' z
  rw [(C.left.presheaf.map h_VW.op).hom.map_mul,
      ← ConcreteCategory.comp_apply, ← C.left.presheaf.map_comp,
      show ((h_WU.op : W.op ⟶ U.op) ≫ (h_VW.op : V.op ⟶ W.op)) =
        (h_VU.op : V.op ⟶ U.op) from rfl]  -- uniqueness of morphisms in Opens
```

This is provable in ~10 LOC and is the KEY for S7. After this, the iter-086
chain proceeds with `Finset.sum_apply` + `Pi.smul_apply` + `Pi.lift_π_apply` +
`R_restrict_R_linear` (per-summand) + `Finset.smul_sum` (S8 reassembly). The
HOU mismatch on `LinearMap.comp_apply` from iter-085 can be bypassed by using
`congr_arg (Pi.π Z₂ j).hom` to pull the j-projection inside, then leveraging
`(eqToHom ⋯).hom`'s identity-after-substituting-hRel character via `eqToHom_app`
or a focused `change`.

**Iter-086 estimated complexity:** ~50-80 LOC inline. The `R_restrict_R_linear`
helper is ~10 LOC; the per-summand reduction with reassembly is the bulk.

**Critical path note:** the iter-086 prover should NOT attempt to use
`LinearMap.comp_apply` directly on the current goal form. Instead, work
backwards: start with the closed-form RHS `r •_{perI₂ j} (Pi.π Z₂ j).hom (...)`
and rewrite using `Finset.smul_sum` + per-summand `R_restrict_R_linear` + `←`
the same chain to match the LHS. This is the "S8 → S7 → S6" reverse direction.
