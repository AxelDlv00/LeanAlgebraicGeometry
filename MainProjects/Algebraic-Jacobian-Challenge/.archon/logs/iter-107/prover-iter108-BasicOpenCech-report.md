# AlgebraicJacobian/Cohomology/BasicOpenCech.lean — iter-108 prover

## Outcome: PARTIAL (no new sorries; geometric scaffolding committed at L1783)

Sorry count: **6** (L1120 [PAUSED], L1212, L1536, L1564, L1754, L1802 — the
former L1783 sorry slot, displaced by ~18 LOC of partial-proof setup).
File compiles. No new axioms.

## `h_loc_exact` at L1783 (now L1802 after partial-proof inline)

### Attempt 1 — geometric setup for the analogist Q1 recipe
- **Approach.** Followed the iter-108 PROGRESS.md recipe (analogist Q1 ALIGN, from
  `analogies/finite-product-localisation-and-cech-r-linearity.md`). The recipe is:
  1. Per-coord `IsLocalization.Away (f.1|V_x) Γ(V_x ⊓ D(f.1))`
     via `IsAffineOpen.isLocalization_of_eq_basicOpen` + `Scheme.basicOpen_res`.
  2. `IsLocalization` → `IsLocalizedModule` via
     `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`.
  3. `IsLocalizedModule.pi` (Mathlib `IsBaseChangePi:93`) for the finite product
     `Fin (n+1) → ↑s₀`.
  4. `IsLocalizedModule.iso` + `Function.Exact.iff_of_ladder_linearEquiv` transport
     `h_a₀_fun f` (slice-cover exactness) to the goal.
- **Result.** PARTIAL. Committed ~18 LOC of partial setup at L1781–L1802:
  - `h_V_le_U (x)`: per-coord `V_x = ∏ᶜ basicOpenCover ↑s₀ (x a) ≤ U`
    via `(Pi.π _ ⟨0, by omega⟩).le.trans (basicOpen_le _ _)`.
  - `h_slice_eq (x)`: slice-cover coord open equals basic open via
    `Scheme.basicOpen_res`: `V_x ⊓ D(f.1) = D(f.1|V_x)`.
  - Trailing `sorry` for Steps 1c, 2, 3, 4 (deferred — ~120 LOC of glue).
- **Key Mathlib lemmas verified [verified] this iter:**
  - `Function.Exact.iff_of_ladder_linearEquiv` (correct name for Step 4 transport).
  - `LinearEquiv.conj_exact_iff_exact` (alternative one-iso variant).
  - `IsLocalizedModule.map_iso_commute` (commutes `LocalizedModule.map` with
    `IsLocalizedModule.iso`).
  - `Submonoid.map_powers` (for `algebraMapSubmonoid (powers f.1) = powers (f.1|V_x)`).
  - `IsLocalizedModule.map_exact` exists in Mathlib at
    `Mathlib.Algebra.Module.LocalizedModule.Exact` but is **circular** in this
    context (requires `Function.Exact f_R g_R` = `h_K₀_exact`).
- **Next step (iter-109).** Lift the trailing sorry by writing Steps 1c-4 inline:
  1. Bind `letI := ((C.left.presheaf.map (homOfLE (h_V_le_U x)).op).hom).toAlgebra`
     to install `Algebra R Γ(V_x)`. Use `IsScalarTower R Γ(V_x) Γ(V_x ⊓ D(f.1))`
     bookkeeping (parallel to the existing iter-072 pattern at L1717-L1725).
  2. Apply `hU.isLocalization_of_eq_basicOpen (f.1|V_x) _ (h_slice_eq x)` (after
     translating the algebraMap so f.1|V_x is the image in Γ(V_x)). This gives
     `IsLocalization.Away (f.1|V_x) Γ(V_x ⊓ D(f.1))`.
  3. Use `Submonoid.map_powers` to rewrite `algebraMapSubmonoid Γ(V_x) (powers f.1)
     = powers (f.1|V_x)`; then `IsLocalization.iff_of_eq` (if exists) or
     `IsLocalization.of_submonoid_eq` to switch submonoid.
  4. By `instIsLocalizedModuleToLinearMap...`, the algebra map
     `Γ(V_x) →ₗ[R] Γ(V_x ⊓ D(f.1))` is `IsLocalizedModule (powers f.1)`.
  5. By `IsLocalizedModule.pi`, the product `LinearMap.pi (per-coord restriction
     ∘ₗ Pi.proj)` is `IsLocalizedModule (powers f.1)`.
  6. Repackage `scK₀.X₁ = ∏ᶜ Z₁` and the K₀-to-slice restriction map as
     `LinearMap.pi`-form (use `ModuleCat.piIsoPi` = `e₁` already in scope).
  7. Identify the slice-cover.X_n with `∏ᶜ (Z_int : Fin (n+1) → ↑s₀ → ModuleCat k)`
     where `Z_int x = Γ(V_x ⊓ D(f.1))` (via `Scheme.cechCochain` + the slice
     cover's degree-`n` factor unfolding).
  8. By `IsLocalizedModule.iso`, get `e_loc_i : LocalizedModule (powers f.1) scK₀.X_i
     ≃ₗ[R] slice_cover.X_i (R-linearly viewed)`.
  9. Apply `Function.Exact.iff_of_ladder_linearEquiv` with the three e_loc_i and
     the commutation diagram `slice_cover.f at coord ∘ e_loc_1 = e_loc_2 ∘
     (LocalizedModule.map (powers f.1) f_R)`. The commutation is by uniqueness
     of `IsLocalizedModule.map` (via `IsLocalizedModule.linearMap_ext`).
 10. Use `h_a₀_fun f` (function-level slice-cover exactness already in scope)
     for the LHS of the iff.

### Architectural dead-ends ruled out
- **`LocalizedModule.map_exact` direct application** — CIRCULAR per analogist;
  requires `Function.Exact f_R g_R` = unlocalized K₀ exactness, which is exactly
  `h_K₀_exact` (the outer goal we are trying to prove). Confirmed by signature
  check: `LocalizedModule.map_exact S g h : Function.Exact g h → Function.Exact
  (LocalizedModule.map S g) (LocalizedModule.map S h)`. Dead end documented in
  `analogies/finite-product-localisation-and-cech-r-linearity.md`.
- **Reuse of `h_loc_X_i` directly without slice-cover bridge** — `h_loc_X_i f`
  is `IsLocalizedModule.Away (f.1) (LocalizedModule.mkLinearMap ...)` which is
  trivial (`localizedModuleIsLocalizedModule`); it contributes no slice-cover
  identification information.

### Estimated LOC for iter-109 closure
Following the analogist's 80-120 LOC estimate. The geometric setup (`h_V_le_U`,
`h_slice_eq`) is ~10 LOC and lands cleanly this iter. The remaining ~100-110 LOC
includes (i) per-coord `IsLocalization.Away` + `IsLocalizedModule` adapter
(~30-40 LOC, dominated by the `algebraMapSubmonoid` bookkeeping), (ii)
`IsLocalizedModule.pi` invocation + `ModuleCat.piIsoPi` repackaging (~25-35 LOC),
(iii) slice-cover identification + R-linear bridging (~15-25 LOC), (iv)
`Function.Exact.iff_of_ladder_linearEquiv` setup + commutation diagram closure
via `IsLocalizedModule.linearMap_ext` (~25-35 LOC).

### Step 2 STRETCH (L1120) — NOT attempted
Per PROGRESS.md, Step 2 (Path B on `cechCofaceMap_pi_smul` L1120) was OPTIONAL
and gated on Step 1 closing cleanly. Step 1 did not close, so Step 2 was
correctly skipped. The L1120 lane stays PAUSED as planned.

## Final `lean_diagnostic_messages` (severity=error)
```
[]
```
(No errors. Build completed successfully.)

## Sorry locations (verified post iter-108 prover)
- L1120 (`cechCofaceMap_pi_smul` — PAUSED iter-107+ scaffold, preserved byte-for-byte).
- L1212 (substep (a) augmented Čech — deferred).
- L1536 (`K→K₀` transport — deferred).
- L1564 (substep (a) for s₀ — deferred).
- L1754 (`g_R.map_smul'` — gated on L1120 closure).
- L1802 (former L1783 `h_loc_exact` — partial scaffolding committed; trailing sorry
  after `h_V_le_U` + `h_slice_eq` setup. Recipe deferred to iter-109.)

**Total: 6 syntactic sorries. Hard cap maintained. No new axioms.**
