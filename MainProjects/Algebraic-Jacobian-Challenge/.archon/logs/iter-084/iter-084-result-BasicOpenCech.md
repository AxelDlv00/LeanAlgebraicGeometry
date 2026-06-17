# AlgebraicJacobian/Cohomology/BasicOpenCech.lean

## Status (iter-084)

- **Sorries**: 6 (L502, L826, L854, L1383, L1428, L1457) — net 6 → 6 (no regression, hard cap = 6 maintained).
- **File compiles**: yes, 0 errors. Only style warnings remain (pre-existing — `simp` flexibility, long lines, `show` vs `change`).
- **Axioms (`basicOpenCover_isCechAcyclicCover_toModuleKSheaf`)**: `propext`, `sorryAx`, `Classical.choice`, `Quot.sound` — all standard. **No new axioms introduced**.

## h_diff_pi_smul_f (formerly L1323, now ending at L1383)

### Iter-084 advance: BOTH iter-083 typeclass barriers cleared

Two `letI`s + one explicit `rw` inserted between the iter-083 letI block (L1207–1208) and the sorry. After these, the remaining work is **genuine R-linearity content**, not typeclass scaffolding.

#### Attempt 1 — Path (c) bundling at the goal level

- **Approach**: Bundle the per-summand R-linearity as a genuine R-linear map `Φ_j : ↑(∏ᶜ Z₁) →ₗ[R] ↑(Z₂ j)` via `LinearMap.mk` with explicit `map_smul'`. Apply `Φ_j.map_smul r (e₁.symm y)` to close the main equation.

- **Result**: **PARTIAL** — the two iter-083 typeclass barriers are fully resolved; the residual is the substantive per-summand R-linearity (`Φ_j.map_smul'` content).

- **Key insights** (preserved as in-code comments at L1325–1382):
  1. **Iter-083 Finding (1) resolved**: the HSMul source-type ascription barrier (`failed to synthesize HSMul ↑R ↑(∏ᶜ Z₁) ?m`) is resolved by binding the R-module instance under the **literal `↑(∏ᶜ Z_i)` form** (not just `↑scK₀.X_i`). The `letI hmod_pi_Z₁ : Module ↑R ↑(∏ᶜ Z₁) := h_mod_X₁` and `letI hmod_pi_Z₂ : Module ↑R ↑(∏ᶜ Z₂) := h_mod_X₂` instances make typeclass synthesis succeed (verified live via `lean_multi_attempt`).
  2. **Iter-083 Finding (2) resolved**: `e₁.symm (r • y) = r • e₁.symm y` (with `r •` on RHS using `hmod_pi_Z₁`) is closable in one step via `show e₁.symm (r • y) = e₁.symm (r • e₁ (e₁.symm y)); rw [LinearEquiv.apply_symm_apply]`. Mechanism: the smul on `↑(∏ᶜ Z₁)` from `h_mod_X₁ = e₁.toAddEquiv.module R` is defined as `r • z := e₁.symm (r •_pi e₁ z)` (`Equiv.smul_def`); substituting `z = e₁.symm y` and collapsing via `e₁.apply_symm_apply` gives the desired identity. Verified live: zero diagnostics on this proof block.
  3. **Goal shape after the rw**: BOTH sides have form `(Pi.π Z₂ j).hom ((eqToHom ∘ₗ Σ.hom) <argument>)` where `<argument>` is `r • e₁.symm y` (LHS) or `e₁.symm y` (RHS, with outer `r •`). The residual is genuine R-linearity of `z ↦ (Pi.π Z₂ j).hom ((eqToHom ∘ₗ Σ.hom) z)`.

- **Remaining work** (deferred to iter-085+): per-summand decomposition (~50–80 LOC):
  1. `LinearMap.coe_comp` + `Function.comp_apply` to split the comp.
  2. `Finset.sum_apply` + `Pi.smul_apply` (with `perI₁`) to distribute the sum across smul.
  3. Per summand at fixed `i`: use `Pi.lift_π` + `Pi.π Z₁ k (e₁.symm z) = z k` to reduce the j-th component of `Σ.hom (r • z)` to `restr ((r • z)(j∘δ_i))` = `restr ((presheaf.map …).hom r * z (j∘δ_i))`.
  4. `RingHom.map_mul` to split the product; `← C.left.presheaf.map_comp` to collapse the algebra-map chain to `(presheaf.map (V_j ≤ U).op).hom r`, matching `perI₂ j`'s definition.
  5. `Finset.smul_sum` on RHS + `Finset.sum_congr rfl` to reassemble.

- **Dead-end warning**: 
  - `letI : Module ↑R ↑scK₀.X₁ := h_mod_X₁` (typed at `↑scK₀.X_i`) is **insufficient** for the HSMul synthesis when the outer source is `↑(∏ᶜ Z_i)` (iter-083 Finding 1). MUST bind at the literal `↑(∏ᶜ Z_i)` type. The two are defeq via `dsimp`, but typeclass search is syntactic.
  - `simp [Equiv.smul_def]` on the side condition — does NOT fire (`simp` argument unused). Use the explicit `show ... rw [LinearEquiv.apply_symm_apply]` instead.
  - Naive `rw [map_smul]` on the LHS — fails at the `MulActionHomClass` synthesis (e₁ is `≃ₗ[k]`, not `≃ₗ[R]`).

### Verification

- `lean_diagnostic_messages` (post-edit): 0 errors, only warnings (pre-existing style issues).
- `lean_verify` on `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`: standard axioms only (`propext`, `sorryAx`, `Classical.choice`, `Quot.sound`).
- Sorry count: 6 (L502, L826, L854, L1383, L1428, L1457). Hard cap = 6 respected.

## Other sorries (out of scope per PROGRESS.md)

| Line | Declaration | Status | Owner |
|---|---|---|---|
| L502 | augmented Čech simplicial object substep | dead-end | gated on user-supplied hypothesis |
| L826 | `h_π_split` analogue | dead-end | gated on user-supplied hypothesis |
| L854 | extra-degeneracy on s₀-indexed slice cover | dead-end | gated on user-supplied hypothesis |
| **L1383** | **h_diff_pi_smul_f (this lane's target)** | **iter-084 structural advance; residual = genuine R-linearity** | **iter-085+** |
| L1428 | `g_R.map_smul'` | gated on Lane 1 + h_diff_pi_smul_g restatement with Eq.mpr | iter-085+ |
| L1457 | `h_loc_exact` | needs `IsLocalizedModule.Away f.1` infrastructure | iter-085+ |

## Blueprint markers

- `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` remains unproved (6 sorries inside); no marker change.
- `\leanok` for `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` is managed deterministically by the `sync_leanok` phase — leave to the script.
- Blueprint chapter `blueprint/src/chapters/AlgebraicJacobian_Cohomology_BasicOpenCech.tex` was assigned in the prover prompt but does NOT exist; per the bootstrap rule, I should flag this — however the canonical existing chapter for this content is `blueprint/src/chapters/Cohomology_MayerVietoris.tex` (per PROGRESS.md L126), which contains the Čech-acyclicity proof body. The plan agent should clarify whether a new `AlgebraicJacobian_Cohomology_BasicOpenCech.tex` chapter is needed or whether the existing `Cohomology_MayerVietoris.tex` content suffices.

## Next session recipe

Pick up at L1383 with the post-rw goal already in the form `Foo (r • e₁.symm y) = r • Foo (e₁.symm y)`. The two `letI hmod_pi_Z₁/Z₂` and the smul-commutation rw above the sorry give clean R-module synthesis. Now:

1. `generalize hz : (ModuleCat.piIsoPi Z₁).toLinearEquiv.symm y = z` (or define a local `Φ_j` LinearMap).
2. Distribute the j-projection past `eqToHom ∘ₗ Σ.hom` via `LinearMap.coe_comp` + `Function.comp_apply` + `Finset.sum_apply`.
3. Per-summand at fixed `i`: identify the summand via `Pi.lift_π` + `Pi.π Z₁ k (e₁.symm z) = z k`.
4. `Pi.smul_apply` + `RingHom.map_mul` + `← presheaf.map_comp` to close the per-summand step.
5. `Finset.smul_sum` + `Finset.sum_congr rfl` to reassemble.
