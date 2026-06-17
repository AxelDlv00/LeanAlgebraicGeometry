# Cohomology/BasicOpenCech.lean — iter-064 prover round

## Summary

**Mode**: Good / Acceptable (per the iter-064 success ladder). The single substep (b)+(c) sorry was decomposed into three clearly-labelled transient sorries with substantial new scaffolding:

1. **`h_transport` — Čech-cohomology refinement transport `s → s₀`** (component i)
2. **`h_a₀` — extra-degeneracy on the `s₀`-indexed slice cover** (component ii, substep a for `s₀`)
3. **`h_K₀_exact` — finite product-localisation commutation + `exact_of_isLocalized_span` on `s₀`** (component ii, substeps b2+c)

- **Sorry trajectory (file-local)**: `2 → 4`. The original single sorry at L633 was replaced by a structured proof block with 3 new sorries.
- **Sorry trajectory (project-wide)**: `11 → 13` (the other iter-064 objective `Differentials.lean` added 7 sorries in a new file; net project-wide change is `11 + 7 + 2 = 20` total sorries, but only `+2` came from `BasicOpenCech.lean`).
- **File LOC**: 643 → ~720 (+~77 LOC of new scaffolding, comments, and proof structure).
- **No new axioms** introduced.
- **No protected signatures modified**.
- **No other `.lean` file modified**: this round is contained to `BasicOpenCech.lean`.

## What was done (concrete code-level)

### Extracted `s₀` and introduced `K` / `K₀` shorthand (lines 636–640)

```lean
obtain ⟨s₀, h_sub, h_top⟩ := hs_fin
let K := cechCochain C (toModuleKSheaf C) (basicOpenCover s)
let K₀ := cechCochain C (toModuleKSheaf C)
  (basicOpenCover (C := C) (U := U) (↑s₀ : Set Γ(C.left, U)))
```

This brings the finite subspanning set `s₀` into scope with its two properties (`↑s₀ ⊆ s` and `Ideal.span ↑s₀ = ⊤`), and introduces readable names for the two Čech cochain complexes.

### Component (i): Čech refinement transport `s → s₀` (lines 641–663)

Stated `h_transport` as a bidirectional `Function.Exact` equivalence between `K` and `K₀`:

```lean
have h_transport : Function.Exact
    ⇑(ConcreteCategory.hom (HomologicalComplex.sc K n).f)
    ⇑(ConcreteCategory.hom (HomologicalComplex.sc K n).g) ↔
  Function.Exact
    ⇑(ConcreteCategory.hom (HomologicalComplex.sc K₀ n).f)
    ⇑(ConcreteCategory.hom (HomologicalComplex.sc K₀ n).g) := by
  sorry  -- iter-064+ component (i): Čech refinement transport `s → s₀`
```

The comment block explains the intended proof route: the inclusion `↑s₀ ↪ s` induces a cochain-complex map `K → K₀` (precomposition of multi-indices). Exactness transports because both covers generate the same sieve on `U` (`⨆ basicOpenCover s = U = ⨆ basicOpenCover ↑s₀`). Closing this requires either a direct homological-algebra argument or a sheaf-theoretic reduction to the fact that Čech cohomology depends only on the generated sieve.

### Component (ii): `exact_of_isLocalized_span` on `s₀` (lines 664–721)

Structured the proof of `Function.Exact (K₀.sc n).f (K₀.sc n).g` into three substeps:

**Substep (a) for `s₀`** (`h_a₀`, lines 682–690): The `s₀`-indexed slice cover at `f ∈ ↑s₀` contains `D(f)` at index `f`, so the augmented Čech complex contracts by the same extra-degeneracy argument as the original `h_a`. Converted to `Function.Exact` form as `h_a₀_fun` (lines 691–702) using the same `rw [← ...]` chain as `h_a_fun`.

**Substep (b2) for `s₀`** (inside `h_K₀_exact` sorry comment, lines 703–720): Because `s₀` is finite, `Fin (i+1) → ↑s₀` is finite, so product-localisation commutation holds:
```
LocalizedModule (powers f) (∏ᶜ_x Γ(V_x)) ≅ ∏ᶜ_x Γ(V_x ⊓ D(f))
```
This gives `IsLocalizedModule.Away f.1` instances on the cochain-complex maps of `K₀`, viewed as `Γ(C.left, U)`-linear maps. Transporting `h_a₀_fun f` across this identification via `IsLocalizedModule.map_exact` yields exactness of the localised differential of `K₀` at `f`.

**Substep (c) for `s₀`** (same sorry block): With the per-`f` localised exactness in hand, `exact_of_isLocalized_span ↑s₀ h_top ...` closes global exactness of `K₀`.

### Goal closure (line 723)

```lean
exact h_transport.mpr h_K₀_exact
```

The original goal `Function.Exact (K.sc n).f (K.sc n).g` is closed by the transport equivalence plus exactness of `K₀`.

## Sorry inventory (post iter-064)

- **L444** (substep (a)): `(s-indexed slice cover).ExactAt n` via `FormalCoproduct.extraDegeneracyCech` + `ExtraDegeneracy.homotopyEquiv` + op-passage. **Unchanged from iter-061**.
- **L662** (component i): `Function.Exact (K.sc n).f (K.sc n).g ↔ Function.Exact (K₀.sc n).f (K₀.sc n).g`. **NEW iter-064**.
- **L690** (substep (a) for `s₀`): `(↑s₀-indexed slice cover).ExactAt n` via extra-degeneracy. **NEW iter-064**.
- **L720** (substep (b2)+(c) for `s₀`): finite product-localisation commutation + `IsLocalizedModule.Away` instances + `exact_of_isLocalized_span` on `↑s₀`. **NEW iter-064**.

All four sorries are inside `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`.

## Verification

- `lean_diagnostic_messages` on the whole file: 1 warning (`declaration uses 'sorry'`, line 402, expected). 0 errors.
- File-local sorry count: 4 (lines 444, 662, 690, 720).
- Project-wide sorry count: 20 (3 `AbelJacobi.lean` + 7 `Differentials.lean` + 4 `BasicOpenCech.lean` + 5 `Jacobian.lean` + 1 `Picard/Functor.lean`).
- File LOC: ~720 (+~77 from 643).
- `lake env lean AlgebraicJacobian/Cohomology/BasicOpenCech.lean` succeeds with only the expected `declaration uses 'sorry'` warning.
- No new `axiom` declarations.
- Protected signatures unchanged.
- Iter-053–063 declarations untouched.

## Iter-065 next-iteration recommendation

The iter-064 scaffolding decomposes the remaining work into three parallel attack surfaces:

### 1. **Component (i) — Čech refinement transport `s → s₀`** (L662)

This is the most self-contained piece. Two natural routes:

- **Route A (direct)**: Construct the cochain-complex map `K → K₀` explicitly using `CategoryTheory.Limits.Pi.map` and the inclusion `↑s₀ ↪ s`. Prove it is a quasi-isomorphism by showing the kernel is acyclic in positive degrees. Mathlib's `HomologicalComplex.Hom` and `ShortComplex.exact_iff_of_iso` might help.
- **Route B (sieve-theoretic)**: Prove a general lemma that Čech cohomology of the structure sheaf on an affine scheme depends only on the sieve generated by the cover. Since `s` and `s₀` generate the same sieve (both span `⊤`), the cohomologies agree. This is more abstract but avoids explicit cochain-complex manipulation.

### 2. **Substep (a) for `s₀`** (L690)

This is a near-verbatim copy of the original substep (a) at L444, but with the slice cover indexed by `↑s₀` instead of `s`. The leverage chain is identical:
1. `FormalCoproduct.extraDegeneracyCech` with `i₀ := f` (since `f ∈ ↑s₀`).
2. `SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv`.
3. Op-passage via `CochainComplex.opEquivalence` to cochain-level exactness.

If the original substep (a) is closed in iter-065, the `s₀`-indexed version can likely be closed by the same proof with minimal changes.

### 3. **Substep (b2)+(c) for `s₀`** (L720)

This is the finite-spanning local-to-global assembly. The steps are:
1. Install `Module Γ(C.left, U)` instances on `K₀.X i` for `i = n, n+1, n+2`. This is straightforward because `s₀` is finite: each factor `Γ(V_x)` is a `Γ(C.left, U)`-algebra via restriction, and the finite product inherits the pointwise module structure.
2. For each `f ∈ ↑s₀` and each cochain factor index `i`, construct the `IsLocalizedModule.Away f.1` instance on the map `K₀.X i → slice_K₀(f).X i`. This uses the finite product-localisation commutation (which holds because `Fin(i+1) → ↑s₀` is finite). Mathlib's `ModuleCat.piIsoPi` and `IsLocalizedModule` functoriality should provide the building blocks.
3. Use `IsLocalizedModule.map_exact` to transport `h_a₀_fun f` to exactness of the localised differential.
4. Apply `exact_of_isLocalized_span (↑s₀ : Set _) h_top ...`.

**Mathlib leverage to explore**:
- `IsLocalizedModule` of finite products: search for `IsLocalizedModule.pi` or similar.
- `ModuleCat.piIsoPi` for the product-level isomorphism in `ModuleCat k`.
- `exact_of_isLocalized_span` (`Mathlib/RingTheory/LocalProperties/Exactness.lean` L173).
- `IsLocalizedModule.map_exact` (`Mathlib/Algebra/Module/LocalizedModule/Exact.lean` L56).

### Strategic note

The three attack surfaces are largely independent. A future iteration could:
- Close substep (a) for `s₀` in parallel with the original substep (a).
- Attack component (i) with a dedicated prover session focused on Čech refinement.
- Attack substep (b2)+(c) for `s₀` with a session focused on finite product localisation.

The iter-064 decomposition makes each piece smaller and the trajectory unambiguous. The ultimate goal (closing `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`) now requires closing 4 sorries instead of 2, but each sorry is significantly more focused than the original monolithic substep (b)+(c) assembly.

## Blueprint markers ready

- Theorem statement `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` with `\lean{Scheme.basicOpenCover_isCechAcyclicCover_toModuleKSheaf}`: Lean declaration is present (with `sorry` body), so the deterministic `sync_leanok` phase should keep `\leanok` on the **statement** block.
- The proof block remains unmarked (no `\leanok`) because the body still carries 4 sorries.
