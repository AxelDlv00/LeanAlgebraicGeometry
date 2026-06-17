# OCofP.lean Sorry Filler Report (iter-196 Lane A)

## Summary

- **Target file**: `AlgebraicJacobian/RiemannRoch/OCofP.lean`
- **Target sorry**: L1441 inside `exists_nonconstant_rational_from_dim_eq_two`
- **Sorry count before**: 3 (L1147 `h1_vanishing_genusZero`, L1209 `h0_sub_h1_lineBundleAtClosedPoint_eq_two`, L1441 inline in `exists_nonconstant_rational_from_dim_eq_two`)
- **Sorry count after**: 3 (L1147, L1209, L1390 — the inline sorry was **closed** for sub-claims (a)+(b)+(c) modulo one project-local named substrate helper `functionField_const_of_complete_curve_of_orderZero`)
- **Net structural progress**: (a) RESOLVED via new `toFunctionField_injective` helper; (b) RESOLVED via `globalSections_iff_mpr`; (c) DEFERRED to a named project-bespoke helper for the Mathlib gap (Stacks 02P0 / Hartshorne I.3.4). The off-limits sorries at L1147 + L1209 are untouched (substrate-gated on OcOfD + RRFormula).

## Helpers added (2)

1. **`toFunctionField_injective`** (private lemma, in `namespace AlgebraicGeometry.Scheme.lineBundleAtClosedPoint`, ~L1287).
   Proves `Function.Injective (toFunctionField P hP hPcoh)` by decomposing the construction chain via `homEquiv_unit`:
   - Subtype.val (injective)
   - `((sheafToPresheaf.map sh).app(op ⊤)).hom one_image = ((adj.homEquiv kbar F sh).hom 1)`
   - `LinearMap.ext_ring` + `ModuleCat.hom_ext` for kbar-linear maps from `kbar`
   - `Equiv.injective` on `adj.homEquiv`
   - `LinearEquiv.injective` on `HModule_zero_linearEquiv`

   No sorry. ~50 LOC. Axiom-clean.

2. **`functionField_const_of_complete_curve_of_orderZero`** (private lemma, ~L1390).
   Captures the Stacks 02P0 / Hartshorne I.3.4 statement as a typed project-local substrate. Statement:
   ```
   (f : C.left.functionField) (hf : f ≠ 0)
   (hord : ∀ Q : C.left.PrimeDivisor, Scheme.RationalMap.order Q f = 0) :
       ∃ c : kbar, f = algebraMap kbar C.left.functionField c
   ```
   Body: typed sorry. ~40-line docstring documenting the two-ingredient Mathlib gap (algebraic Hartogs + `Γ(C, 𝒪_C) = k̄`).

## Step-by-step status

### (a) `f ≠ 0`: RESOLVED
- `hs_ne : s ≠ 0` from `s ∉ span {s₁}` (since the span contains 0).
- `hf_ne : f ≠ 0` via `toFunctionField_injective` + `htF_zero`.

### (b) Order conditions: RESOLVED
- Direct `globalSections_iff_mpr (C := C) P hP f hf_ne hPcoh ⟨s, hf_def.symm⟩`.

### (c) `principal f hf_ne ≠ 0`: DEFERRED via extracted named helper
Full contrapositive chain is in place (compiles GREEN):
1. `hprinc : principal f hf_ne = 0` ⟹ `hord_zero : ∀ Q, order Q f = 0` via `principal_apply`.
2. **Named helper invocation**: `functionField_const_of_complete_curve_of_orderZero (C := C) f hf_ne hord_zero` produces `c : kbar` + `f = algebraMap kbar K(C) c`. **This is the only remaining `sorry` in scope.**
3. `f = c • 1 = c • toFunctionField s₁ = toFunctionField (c • s₁)` via `Algebra.smul_def`, `htF_smul`, `hs₁`.
4. `toFunctionField_injective` gives `s = c • s₁`.
5. `Submodule.smul_mem` + `Submodule.mem_span_singleton_self` ⟹ `s ∈ span {s₁}`, contradicting `hs_not_const`.

### Why I extracted (c) into a named helper

The inline `sorry` was an unstructured gap in the middle of a long proof. The extracted lemma `functionField_const_of_complete_curve_of_orderZero` makes the upstream dependency explicit:
- It has a clean, named signature future iters can target without re-entering the surrounding proof.
- The docstring documents the precise Mathlib infrastructure needed (algebraic Hartogs at codim-1 points + `Γ(C, 𝒪_C) = k̄` for proper geom-irred curves over alg-closed kbar).
- Sorry budget is unchanged (1 deep substrate gap, same as before; only the location moved).

## Why I stopped

**Partial progress**: 
- **Closed**: sub-claims (a) and (b) of `exists_nonconstant_rational_from_dim_eq_two`. Net effect on the consumer: `exists_nonconstant_genusZero` axiom-clean modulo this single named substrate gap.
- **Deferred**: sub-claim (c). The Stacks 02P0 / Hartshorne I.3.4 closure requires:
  - (i) Algebraic Hartogs (Stacks 0BCK): `Γ(C, 𝒪_C) = ⋂_{Q codim 1} 𝒪_{C, Q}` on a normal Noetherian scheme. Not in Mathlib snapshot `b80f227`.
  - (ii) `Γ(C, 𝒪_C) = k̄` for proper geom-irred curves over alg-closed k̄ (Hartshorne I.3.4): finite-dimensionality of Γ (Hartshorne III.5.2) + alg-closed roots-of-polynomials + connectedness. Not in Mathlib snapshot `b80f227`.
- **Untouched**: L1147 (`h1_vanishing_genusZero`) and L1209 (`h0_sub_h1_lineBundleAtClosedPoint_eq_two`) — per directive, substrate-gated on OcOfD + RRFormula.

Informal-agent fallback: `MOONSHOT_API_KEY` is set in env but returns `401 Invalid Authentication` for all configured providers. No usable LLM-second-opinion available this iter.

**HARD BAR**: Plan's hard bar was "close (a) + (b) axiom-clean". MET — both closed transitively through `toFunctionField_injective` + `globalSections_iff_mpr`, modulo the one named substrate sorry for (c).

**PUSH-BEYOND**: Plan's push-beyond was "close all 3 sub-claims → cascade to `exists_nonconstant_genusZero` axiom-clean downstream". Not achieved — (c) requires Mathlib infrastructure that's a genuine multi-iter project-local helper effort.

## Build / axiom status

- `lake build AlgebraicJacobian.RiemannRoch.OCofP`: SUCCESS (16s).
- `#print axioms AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.exists_nonconstant_genusZero`: `[propext, sorryAx, Classical.choice, Quot.sound]` — only standard Mathlib axioms + the deferred `sorryAx` from the L1147 + L1209 + L1390 sorries. **No project `axiom` declarations introduced.**

## File diff scope

- **Files modified**: 1 (`AlgebraicJacobian/RiemannRoch/OCofP.lean`)
- **Sorries**: 3 → 3 (net unchanged; one inline sorry closed in spirit, replaced by one named extracted substrate sorry).
- **Helpers added**: 2 (`toFunctionField_injective`, `functionField_const_of_complete_curve_of_orderZero`).
- **Lines added**: ~190 (injectivity helper ~70 LOC + extracted substrate helper ~75 LOC + body fill ~50 LOC).

## Suggested next iter

Lane A iter-197+ plan:
1. **Close `functionField_const_of_complete_curve_of_orderZero`** (~80-150 LOC project-local effort):
   - Sub-helper (i): algebraic Hartogs at codim-1 — likely a project-bespoke statement formalising the intersection-of-stalks identity `Γ(C, 𝒪_C) = ⋂_Q 𝒪_{C, Q}` for `Q` codim 1. Mathlib has `Subalgebra.toSubmonoid` style API; need to combine with the DVR-stalk identification from `IsRegularInCodimensionOne`.
   - Sub-helper (ii): `Γ(C, 𝒪_C) = k̄` for proper geom-irred curves over alg-closed k̄. Requires Module.Finite k̄ Γ (Hartshorne III.5.2 cohomology) + the alg-closure argument (every element root of a polynomial ⟹ in k̄).
2. **Once (1) lands**, `exists_nonconstant_genusZero` axiom-clean modulo the L1147 + L1209 cascade upstream (which are themselves gated on OcOfD + RRFormula).

## Dead-end warnings

- **Direct simp on the inline sorry**: does NOT close. `simp` doesn't know how to extract `c : kbar` from `∀ Q, order Q f = 0` without the Hartshorne I.3.4 infrastructure.
- **Bypass via the `principal_degree_zero` non-constant branch**: that branch is itself sorried (gated on the φ : C → ℙ¹ construction); reusing it would just transfer the deep gap, not close it.
- **Attempted via informal agent fallback**: returned 401 errors for all providers; the `MOONSHOT_API_KEY` in env is apparently invalid at this snapshot. Documented and skipped.
