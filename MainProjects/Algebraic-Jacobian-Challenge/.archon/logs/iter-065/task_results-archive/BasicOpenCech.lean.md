# BasicOpenCech.lean — iter-065 prover round

## Summary

**No sorries fully closed.** Both target sorries (L662 component (i) and L720 substep (b2)+(c) for `s₀`) were decomposed into smaller, well-commented transient sorries with substantial new scaffolding. The file compiles cleanly with only the expected `declaration uses 'sorry'` warning.

**Sorry trajectory (file-local):** `4 → 16` (+12 transient sorries from decomposition).
  - L662 (`h_transport`): `1 → 3` (cochain-complex map `π`, split-surjection proof, exactness descent).
  - L720 (`h_K₀_exact`): `1 → 9` (`Module R` instances ×3, `R`-linear differential ×2, equality proofs ×2, `IsLocalizedModule.Away` instances ×3, localized exactness, final `exact_of_localized_span`).

**Sorry trajectory (project-wide):** `21 → 33` (+12 from this file; no other files touched).

## What was done (concrete code-level)

### L720 — `substep (b2)+(c) for s₀`: structured `exact_of_isLocalized_span` scaffolding (lines 730–790)

Replaced the monolithic `sorry` with an explicit 5-step proof skeleton:

1. **Install `Module Γ(C.left, U)` instances** on `scK₀.X₁`, `scK₀.X₂`, `scK₀.X₃` (`have h_mod_X₁/₂/₃ : Module R ... := sorry`). Each is a finite product of sections `Γ(C.left, V_x)` with `V_x ≤ U`; each factor is an `R`-algebra via restriction, so the product inherits pointwise `R`-module structure. Closing these requires either transporting the explicit product structure along `ModuleCat.piIsoPi` or unfolding `cechComplexFunctor` to expose the `Pi` type.

2. **Repackage the Čech differential as `R`-linear maps** (`let f_R : scK₀.X₁ →ₗ[R] scK₀.X₂ := sorry`, `let g_R := sorry`). The Čech differential is an alternating sum of restriction maps; each restriction map `Γ(C.left, V) → Γ(C.left, W)` (`W ≤ V ≤ U`) is an `R`-algebra homomorphism, hence `R`-linear. Constructing the explicit `LinearMap` bodies requires unfolding `alternatingCofaceMapComplex`.

3. **`IsLocalizedModule.Away` instances on canonical localization maps** (`have h_loc_X₁/₂/₃ (f : ↑s₀) : IsLocalizedModule.Away (f.1 : R) (LocalizedModule.mkLinearMap ...) := sorry`). Because `s₀` is finite, `Fin (i+1) → ↑s₀` is finite, so `IsLocalizedModule.pi` (`Mathlib/RingTheory/TensorProduct/IsBaseChangePi.lean` L93) gives that the product of localizations is the localization of the product. Each factor `Γ(C.left, V_x) → Γ(C.left, V_x ⊓ D(f))` is a localization away from `f`, so the product map is too.

4. **Localized exactness from slice-cover exactness** (`have h_loc_exact (f : ↑s₀) : Function.Exact ... := sorry`). By the universal property of `IsLocalizedModule.map` (`map_comp` + `IsLocalizedModule.ext`), the localized Čech differential equals the slice-cover Čech differential. `h_a₀_fun f` gives exactness of the latter, hence of the former.

5. **Apply `exact_of_localized_span`** (`exact exact_of_localized_span (↑s₀ : Set R) h_top f_R g_R h_loc_exact`). This lifts the per-`f` localized exactness to global exactness of `K₀`.

### L662 — `component (i)`: Čech refinement transport `s → s₀` scaffolding (lines 650–690)

Replaced the monolithic `sorry` with a 4-step proof skeleton:

1. **Construct the cochain-complex projection `π : K → K₀`** (`let π : HomologicalComplex.Hom K K₀ := sorry`). The inclusion `↑s₀ ↪ s` induces an injection `Fin (i+1) → ↑s₀ → Fin (i+1) → s` (postcomposition). By the universal property of categorical products, this gives a projection map `K.X i → K₀.X i` in `ModuleCat k`. Commutativity with the Čech differential follows because postcomposition with the inclusion commutes with skipping indices (face maps).

2. **Show `π_i` is a split surjection** (`have h_π_split (i : ℕ) : SplitEpi (π.f i) := sorry`). The splitting extends a function `Fin (i+1) → ↑s₀` to `Fin (i+1) → s` by choosing arbitrary values on the complement (possible because `s` is non-empty, as `Ideal.span s = ⊤`).

3. **Kernel acyclicity** (comment block, no new `have`). The kernel of `π` at degree `i` is the product of factors indexed by `x : Fin (i+1) → s` not in the image of `Fin (i+1) → ↑s₀`. This kernel complex is acyclic in positive degrees because it is a Čech complex of a cover that is a refinement of a cover with a terminal object (extra-degeneracy applies once `s` is reduced modulo `↑s₀`).

4. **Exactness descent** (`sorry`). From the short exact sequence of complexes `0 → ker(π) → K → K₀ → 0` and exactness of `K₀` at degree `n`, the long exact sequence in cohomology gives exactness of `K` at degree `n`.

### L444 / L690 — diagnosis

Both remain unchanged. The `extraDegeneracyCech` approach is blocked because `FormalCoproduct.extraDegeneracyCech` requires a terminal object `T` in the *ambient* category `Opens C.left.toTopCat`, where `⊤` is terminal, not `D(f)`. The slice cover of `D(f)` does not contain `⊤`, so `extraDegeneracyCech` does not apply directly. Closing these would require either (a) restricting to the subcategory `Opens D(f)` and building a custom Čech complex there, or (b) a different exactness argument for slice covers.

## Verification

- `lake env lean AlgebraicJacobian/Cohomology/BasicOpenCech.lean` succeeds with only the expected `declaration uses 'sorry'` warning (line 402).
- No new `axiom` declarations introduced.
- No other `.lean` files modified.
- Protected signatures unchanged.

## Blueprint markers

- `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` statement block: still carries 16 sorries, so `sync_leanok` will keep `\leanok` on the statement but not on the proof block.

## Iter-066 next-iteration recommendations

### Highest priority: close one or more of the new L720 sorries

The L720 decomposition makes each piece smaller and the trajectory unambiguous:

1. **`h_mod_X₁/₂/₃`** — construct `Module Γ(C.left, U)` instances. Two possible routes:
   - **Route A (explicit)**: Prove `K₀.X i = ∏ᶜ fun x => (toModuleKPresheaf C).obj (op (⨅ j, basicOpenCover ↑s₀ (x j)))` by unfolding `cechComplexFunctor`, then use `Pi.instModule` pointwise.
   - **Route B (isomorphism transport)**: Use `ModuleCat.piIsoPi` to get an isomorphism between `K₀.X i` and the explicit product, then transport the `Module` instance along the underlying linear equivalence.

2. **`f_R` / `g_R`** — construct `Γ(C.left, U)`-linear versions of the Čech differential. The differential is `∑ (-1)^k • δ_k` where each `δ_k` is a product of restriction maps. Each restriction map is `R`-linear, so the alternating sum is too. Unfolding `alternatingCofaceMapComplex` exposes the explicit formula.

3. **`h_loc_X₁/₂/₃`** — apply `IsLocalizedModule.pi`. Each factor `Γ(C.left, V_x) → Γ(C.left, V_x ⊓ D(f))` is `IsLocalizedModule.Away f.1` (by `IsAffineOpen.isLocalization_of_eq_basicOpen` / iter-059). The product map is the canonical `Pi.map` of these factor maps.

4. **`h_loc_exact`** — use `IsLocalizedModule.map_exact` after proving the localized differential equals the slice-cover differential via `IsLocalizedModule.ext`.

### Secondary priority: L662 `π` construction

The cochain-complex projection `π : K → K₀` is the key missing piece. It can be built explicitly using `Pi.lift` and postcomposition with the inclusion `↑s₀ ↪ s`. The commutativity with the Čech differential follows from naturality of the face maps with respect to the index set.

### Lower priority: L444 / L690

These require a new approach because `extraDegeneracyCech` is inapplicable. One possibility: build the augmented Čech simplicial object for the slice cover directly in the subcategory `Opens D(f)` and prove acyclicity there, then transport back. This is a significant piece of infrastructure.
