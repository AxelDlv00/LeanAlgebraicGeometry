# AlgebraicJacobian/Cohomology/BasicOpenCech.lean — iter-082

## Status

- File compiles cleanly (no errors).
- Sorry count: **6** (unchanged from iter-081 entry; budget hard cap 6).
- Sorry locations (post-edit):
  - L502 — substep (a) extra-degeneracy on `s`-indexed slice cover (dead-end, out of scope).
  - L826 — slice/refinement transport (dead-end, out of scope).
  - L854 — substep (a) for `s₀` (dead-end, out of scope).
  - **L1240** — `h_diff_pi_smul_f` (this lane's target; advanced from L1196 with S5 prelude inline).
  - L1285 — `g_R.map_smul'` (gated downstream, out of scope).
  - L1314 — `h_loc_exact` (gated downstream, out of scope).

## h_diff_pi_smul_f (L1240) — Lane 1 work

### Attempt 1 (this iter): S5 prelude — push `j`-projection past `piIsoPi Z₂`

- **Approach:**
  1. Re-fold `limit.isoLimitCone ⟨productCone, productConeIsLimit⟩` (which the iter-081 `simp` exposed) into the `ModuleCat.piIsoPi Z_i` API form via two `rw [show ... = ... from rfl]` steps. This is a syntactic re-association — no semantic change.
  2. Bridge the `(piIsoPi Z₂).toLinearEquiv x` form (which doesn't match piIsoPi simp lemmas) to `(ConcreteCategory.hom (piIsoPi Z₂).hom) x` via a `show` step.
  3. Apply `ModuleCat.piIsoPi_hom_ker_subtype_apply` twice (once per side) to push the `j`-projection past the iso, replacing `(piIsoPi Z₂).hom z j` with `(Pi.π Z₂ j).hom z`.
- **Result:** RESOLVED for S5 prelude. Goal at L1240 is now in shape:
  ```
  (Pi.π Z₂ j).hom ((eqToHom_hom ∘ₗ Σ_hom) ((piIsoPi Z₁).inv (r • y)))
    = r • (Pi.π Z₂ j).hom ((eqToHom_hom ∘ₗ Σ_hom) ((piIsoPi Z₁).inv y))
  ```
  with the `j`-projection now adjacent to the differential, ready for per-summand R-linearity work S6–S8.
- **Sorry count delta:** unchanged (6 → 6); structural advance documented in body comments at L1167–1196.

### Attempt 2 (this iter): split `(eqToHom_hom ∘ₗ Σ_hom) z` into `eqToHom_hom (Σ_hom z)`

- **Approach:** Use `LinearMap.comp_apply` (Mathlib `Algebra/Module/LinearMap/Defs` L501) to split the LinearMap composition.
- **Result:** FAILED. The Mathlib `LinearMap.comp_apply` is stated for `(f ∘ₛₗ g) x` (semilinear notation), while our goal has the homogeneous `∘ₗ` notation. Higher-order unification doesn't bridge them despite definitional equality.
- **Workarounds tried (all FAILED):**
  - `simp only [LinearMap.coe_comp, Function.comp_apply]` — no progress; the `(... ∘ₗ ...) z` form has no explicit `⇑(... ∘ₗ ...)` coercion to rewrite.
  - `simp only [LinearMap.comp_apply]` — same `∘ₛₗ` vs `∘ₗ` pattern issue.
  - `rfl` — sides not defeq (the smul on Z₂ at j is via `perI₂ j` while the LHS goes through the differential, so the equality is non-trivial).
  - `dsimp only []` — no progress.
  - `change` to explicitly unfolded form — fails because `eqToHom`'s implicit type proof (`eqToHom ⋯` in the goal) is not directly displayable in surface syntax.
- **Dead-end warning for next iteration:** Do NOT spend cycles on `LinearMap.comp_apply` rewrites against the homogeneous `∘ₗ` notation — the unification fails. The path forward must either (a) introduce a named `let M : ↑(∏ᶜ Z₁) →ₗ[k] ↑(∏ᶜ Z₂) := eqToHom_hom ∘ₗ Σ_hom` abbreviation BEFORE the iter-081 simp so the comp lives behind a definition (then `M` itself can be promoted to R-linear via per-summand reasoning); or (b) take the per-summand approach DIRECTLY without splitting the comp first (use `Pi.lift_apply` and `Finset.sum_apply` / `Finset.smul_sum` from a different angle).

### Mathlib lemmas verified relevant (via `lean_loogle`)

- `ModuleCat.piIsoPi_hom_ker_subtype_apply`: `(piIsoPi Z).hom x i = (Pi.π Z i) x` (key lemma for S5).
- `ModuleCat.piIsoPi_inv_kernel_ι_apply`: `(Pi.π Z i) ((piIsoPi Z).inv x) = x i` (needed for S7 inner projection).
- `ModuleCat.Iso.toLinearEquiv_apply`: `i.toLinearEquiv x = i.hom x` (rfl bridge between LinearEquiv and Iso application).
- `LinearMap.comp_apply`: `f.comp g x = f (g x)` — verified to NOT fire as `rw` due to `∘ₛₗ` pattern (despite the goal having `∘ₗ`, which is `LinearMap.comp` with `RingHom.id`).

### Next-iteration recipe (iter-083+)

After S5 prelude (already executed), the goal at the L1240 sorry is:
```
(Pi.π Z₂ j).hom ((eqToHom_hom ∘ₗ Σ_hom) ((piIsoPi Z₁).inv (r • y)))
  = r • (Pi.π Z₂ j).hom ((eqToHom_hom ∘ₗ Σ_hom) ((piIsoPi Z₁).inv y))
```
where the inner sum is `∑ i : Fin (prev n + 2), (-1)^i • Pi.lift (fun j' => Pi.π Z₁ (j'∘δ_i.toOrderHom) ≫ (toModuleKPresheaf C).map φ.op)`.

**Recommended next-iteration strategy (path (a) above):** Refactor the iter-081 `simp [..., dif_pos hRel]` chain to NOT collapse the comp into a syntactic `∘ₗ`. Instead, use `dsimp only` + targeted rewrites that expose the alternating sum WITHOUT the `eqToHom_hom ∘ₗ` outer wrapper. Alternative: introduce `let M : ↑(∏ᶜ Z₁) ⟶ ↑(∏ᶜ Z₂) := eqToHom _ ≫ Σ` (categorical comp inside ModuleCat, not LinearMap.comp), then evaluate at the j-component via `Pi.π_eq_lift`-style unfolds.

**Alternative path (b):** Per-summand R-linearity. After the S5 prelude:
1. `LinearMap.coe_sum`, `Finset.sum_apply` to commute `Pi.π Z₂ j` past the sum (HARD because the `eqToHom_hom ∘ₗ` wrapping prevents direct sum-distribution).
2. `LinearMap.coe_smul`, `Finset.smul_sum` for the `r • Σ` distribution.
3. `apply Finset.sum_congr rfl; intro i _` for per-summand reduction.
4. Each summand: `Pi.lift_apply` + `Pi.π Z₁ k ((piIsoPi Z₁).inv z) = z k` (via `piIsoPi_inv_kernel_ι_apply`) to extract the projection. Then RingHom.map_mul + ← presheaf.map_comp to identify both sides per-summand.

The per-summand argument is ~30 LOC but each rewrite shifts the deeply-nested type structure; expect 3–5 iterations of focused work to land it.

## Hard constraints (verified preserved)

- `set_option maxHeartbeats 800000 in` at L418 — preserved byte-for-byte.
- iter-080 `letI perI_n` + `letI h_mod_pi_n` block at L920–949 — preserved byte-for-byte.
- iter-081 S2+S3+S4 chain at L1102–1153 — preserved byte-for-byte (intro/funext/simp only Pi.smul_apply/have hRel/dsimp/full simp).
- No new project-local helper lemmas introduced.
- No new axioms.
- No `lean_run_code` pre-validation used (only `lean_diagnostic_messages` + `lean_multi_attempt`).
- Sorry-count budget: 6 → 6 (within hard cap 6; partial-credit fallback per PROGRESS.md L81).

## Blueprint marker

`h_diff_pi_smul_f` is internal to `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` and not a top-level declaration with its own blueprint label. No blueprint marker change required this iter.
