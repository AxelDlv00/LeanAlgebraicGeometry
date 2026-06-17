# Iteration 069 — BasicOpenCech.lean task results

## Closed sorries

### `h_mod_X₁ / h_mod_X₂ / h_mod_X₃` (Module R instances on scK₀.Xᵢ)

**Location:** `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` lines 889–906, 907–922, 923–940

**What was proved:** For `R := Γ(C.left, U)`, installed `Module R` instances on the three objects of the short complex `scK₀ = HomologicalComplex.sc K₀ n`:
- `scK₀.X₁ = K₀.X ((ComplexShape.up ℕ).prev n)`  
- `scK₀.X₂ = K₀.X n`  
- `scK₀.X₃ = K₀.X (n + 1)`

Each object is a finite categorical product `∏ᶜ Z` in `ModuleCat k`, indexed by functions `Fin (m) → ↑s₀` (with `m = prev n + 1`, `n + 1`, `n + 2` respectively).  The factor `Z i` is `ModuleCat.of k (C.left.presheaf.obj (op (∏ᶜ basicOpenCover ↑s₀ ∘ i)))`.

**Proof strategy:**
1. `dsimp [scK₀, K₀, cechCochain, cechComplexFunctor, toModuleKSheaf, toModuleKPresheaf_obj]` to unfold the Čech complex construction and expose the product.
2. Define `Z` as the family of module factors and obtain the `k`-linear equivalence `e := (ModuleCat.piIsoPi Z).toLinearEquiv` between the categorical product and the concrete product.
3. Construct a pointwise `Module R` instance on each factor using `RingHom.toModule` applied to the restriction map `(C.left.presheaf.map (homOfLE h).op).hom`, where `h` proves that the open `∏ᶜ basicOpenCover ↑s₀ ∘ i` is contained in `U`.
   - The containment is proved as a transitivity chain: `∏ᶜ ... ≤ basicOpenCover ↑s₀ (i a0)` (using `(Pi.π _ a0).le` in the poset category) and `basicOpenCover ↑s₀ (i a0) ≤ U` (using `Scheme.basicOpen_le`).
4. Assemble the pointwise instances into `Pi.module` on `∀ i, Z i`.
5. Transport the module structure back across `e` using `e.toAddEquiv.module R`, and close with `convert` to handle any remaining definitional mismatches between `∏ᶜ Z` and the unfolded goal type.

**Key lemmas used:**
- `ModuleCat.piIsoPi` (categorical product ≅ concrete product in `ModuleCat`)
- `CategoryTheory.Iso.toLinearEquiv`
- `Pi.module` + `RingHom.toModule`
- `Pi.π _ a0` in a poset category gives `∏ᶜ f ≤ f a0` via `.le`
- `Scheme.basicOpen_le`
- `AddEquiv.module` (to transport the scalar multiplication while preserving the existing additive group structure)

## Remaining sorries in the file

After iter-069, the following sorries remain in `BasicOpenCech.lean`:

1. **Line 495** — substep (a) infrastructure: augmented Čech simplicial object with a terminal vertex (extra-degeneracy argument for the original cover `s`).
2. **Line 819** — exactness of the kernel complex in positive degrees (step 3 of the `h_transport` proof).
3. **Line 847** — substep (a) for `s₀`: extra-degeneracy on the `s₀`-indexed slice cover.
4. **Lines 949–971** — repackaging Čech differentials as `R`-linear maps and proving localization / exactness properties for `exact_of_isLocalized_span`.

## Net change

- **Before:** 15 syntactic sorries
- **After:** 12 syntactic sorries
- **Closed:** 3 (`h_mod_X₁`, `h_mod_X₂`, `h_mod_X₃`)
