# AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean — iter-194 Lane RCI helper (a) substrate

**Result**: HARD BAR MET (≥1 axiom-clean closure on helper (a) substrate). Two new axiom-clean substrate helpers landed (`algebraMap_bijective_of_finrank_one` + `phi_left_functionField_algEquiv_of_finrank_one`). Helper (a) body advanced with explicit `LocallyQuasiFinite.of_fiberToSpecResidueField` reduction, exposing the per-fibre Mathlib gap surface. Inline Step 1 of `iso_of_degree_one` refactored to consume the new substrate.

**Build state**: GREEN (`lake build AlgebraicJacobian.RiemannRoch.RationalCurveIso` succeeds, 8331 jobs).

**Sorries**: 3 (unchanged count vs entering iter-194 prover phase):
- L521 `Hom.poleDivisor_degree_eq_finrank` `?hLPUnif` (iter-194 refactor v2 typed sorry; not closed this iter).
- L798 helper (d) `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` (Mathlib `IsNormalScheme` gap; not closed this iter).
- L866 helper (a) `phi_left_locallyQuasiFinite_of_finrank_one` (now reduced to per-fibre LQF via `LocallyQuasiFinite.of_fiberToSpecResidueField`; per-fibre case remains the gap surface).

**Axioms verified (`lean_verify`)**:
- `algebraMap_bijective_of_finrank_one`: `propext, Classical.choice, Quot.sound` — **kernel only, AXIOM CLEAN**.
- `phi_left_functionField_algEquiv_of_finrank_one`: `propext, Classical.choice, Quot.sound` — **kernel only, AXIOM CLEAN**.
- `phi_left_locallyQuasiFinite_of_finrank_one`: includes `sorryAx` (per-fibre sorry remains).
- `iso_of_degree_one`: includes `sorryAx` (propagates from helpers (a) + (d)).

## Lane RCI substrate landings (lines 707–767)

### Substrate 1: `algebraMap_bijective_of_finrank_one` (L737-744) — **AXIOM CLEAN**
**Signature**:
```lean
private theorem algebraMap_bijective_of_finrank_one
    {K L : Type*} [Field K] [Field L] [Algebra K L]
    (h : Module.finrank K L = 1) :
    Function.Bijective (algebraMap K L)
```
**Closure**: two-line chain `Subalgebra.bot_eq_top_of_finrank_eq_one` + `Algebra.bijective_algebraMap_iff`. Pure algebra fact, generic in `K`/`L`. Reusable across the project (e.g. CodimOneExtension or AbelianVarietyRigidity may consume similar).

### Substrate 2: `phi_left_functionField_algEquiv_of_finrank_one` (L756-767) — **AXIOM CLEAN**
**Signature**:
```lean
private noncomputable def phi_left_functionField_algEquiv_of_finrank_one
    {kbar : Type u} [Field kbar]
    {C C' : Over (Spec (.of kbar))}
    [IsIntegral C.left] [IsIntegral C'.left]
    [Algebra C'.left.functionField C.left.functionField]
    (hφ_deg :
      Module.finrank C'.left.functionField C.left.functionField = 1) :
    C'.left.functionField ≃+* C.left.functionField
```
**Closure**: one-line `RingEquiv.ofBijective (algebraMap _ _) (algebraMap_bijective_of_finrank_one hφ_deg)`. Standalone reusable building block; consumed by inline Step 1 of `iso_of_degree_one` (refactor below).

### Helper (a) body advance (L838-866) — partial structural progress
**Closure**: `refine LocallyQuasiFinite.of_fiberToSpecResidueField (f := φ.left) (fun x => ?_); sorry`.

The Mathlib reduction `LocallyQuasiFinite.of_fiberToSpecResidueField` (Mathlib `Morphisms/QuasiFinite.lean:210`) reduces the closure to a per-point fibrewise LQF statement. The per-fibre case (smooth-dim-1 ⟹ fibre 0-dim) remains the explicit Mathlib gap surface, captured per docstring update. The substrate helpers above feed the *generic*-fibre case (the generic fibre is essentially `Spec K(C) → Spec K(C')` from an algebra iso, hence iso ⟹ LQF); the *non-generic*-fibre case is the un-substantiated Mathlib gap.

### Inline Step 1 refactor of `iso_of_degree_one` (L912-916)
**Old (iter-193)**: 16 LOC inlining `Subalgebra.bot_eq_top_of_finrank_eq_one + Algebra.surjective_algebraMap_iff + RingHom.injective + RingEquiv.ofBijective`.

**New (iter-194)**: 4 LOC consuming the new substrate `phi_left_functionField_algEquiv_of_finrank_one`. The function-field algebra iso `_ψ : K(C') ≃+* K(C)` is now extracted via the substrate helper.

## Per-target attempt log

### helper (a) `phi_left_locallyQuasiFinite_of_finrank_one` (L850, body L862-866)
#### Attempt 1 (iter-194 substrate-landing)
- **Approach**: extract two axiom-clean substrate helpers (`algebraMap_bijective` + `functionField_algEquiv`); reduce body via `LocallyQuasiFinite.of_fiberToSpecResidueField` to per-fibre case.
- **Result**: PARTIAL — substrate landed axiom-clean (HARD BAR met). Body reduced; per-fibre case sorry'd.
- **Key insight**: `Algebra.bijective_algebraMap_iff` (Mathlib `Algebra/Subalgebra/Lattice.lean`) directly gives bijectivity from `⊤ = ⊥`, which `Subalgebra.bot_eq_top_of_finrank_eq_one` provides.
- **Next step**: per-fibre LQF closure requires "smooth-dim-1 ⟹ 0-dim fibre" wrapper, a Mathlib gap.

### helper (d) `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` (L770, body L798)
#### Attempt 1 (iter-194 push-beyond)
- **Approach**: investigate whether the function-field algebra iso substrate enables (d) closure.
- **Result**: FAILED — (d) needs `IsIso φ.left.fromNormalization` which requires the normalisation scheme to coincide with `C'.left`. This is the "smooth ⟹ normal ⟹ integral closure of structure sheaf is itself" chain, NOT directly accessible from the function-field iso (fromNormalization is constructed scheme-theoretically via affine integral closures, not via the global function field).
- **Dead end**: no clean route to (d) via the new substrate. Would need to either invent `IsNormalScheme` project-side, or reach into `Scheme.Hom.normalizationDiagram` and compute affine integral closures explicitly.

### `?hLPUnif` typed sorry at L521 (`Hom.poleDivisor_degree_eq_finrank`)
#### Attempt 1 (iter-194 push-beyond)
- **Approach**: investigate the uniformiser proof for `(localParameterAtInfty kbar).val = X 0 / X 1`.
- **Result**: FAILED — the goal `∃ Y₀, RationalMap.order Y₀ t = 1 ∧ uniqueness` requires:
  (i) constructing the prime divisor at `∞ ∈ ℙ¹` (an instance of `(ProjectiveLineBar kbar).left.PrimeDivisor`),
  (ii) computing the DVR valuation `Ring.ordFrac` on `X 0 / X 1`,
  (iii) uniqueness via "X 0 has unique zero of order 1 on ℙ¹".
- **Dead end**: deep computation requiring substrate (i) — constructing prime divisors of `ProjectiveLineBar` is itself a Mathlib gap on the project side (no existing `PrimeDivisor`-builder for closed points of `ProjectiveLineBar`).

## Negative-result search log
- Searched `lean_leansearch "smooth morphism between curves is locally quasi-finite"` — no direct lemma; only general LQF + smoothness API.
- Searched `lean_leansearch "non-constant morphism integral curves is dominant"` — only `IsDominant` class, no concrete lemma for our setup.
- Confirmed `IsField.localization_map_bijective` (Mathlib) — applies only to localisations at non-zero submonoids, not directly to algebraMap K → K(C) where K = K(C') is itself a field.
- Confirmed `LocallyQuasiFinite.of_injective` (Mathlib `Morphisms/QuasiFinite.lean:321`) — would require `Function.Injective f.base`, which under finrank = 1 is the iso conclusion (circular).
- `Smooth.of_smooth_fiberToSpecResidueField` (Mathlib `Morphisms/SmoothFiber.lean:34`) — requires `Flat f`, which φ.left need not be a priori (and is not derivable cleanly from the given hypotheses).

## Net iter-194 contribution
- 2 axiom-clean substrate helpers landed (HARD BAR met).
- 1 partial structural advance on helper (a) body (reduction via `of_fiberToSpecResidueField`).
- 1 inline refactor of `iso_of_degree_one` Step 1 consuming new substrate (cleaner downstream).
- 3 → 3 sorries (no count change; per-fibre case now isolated).

## Blueprint markers
- The 3 pinned declarations (`morphismToP1OfGlobalSections`, `morphism_degree_via_pole_divisor`, `iso_of_degree_one`) retain `\lean{...}` cross-references; `\leanok` is `sync_leanok` deterministic.
- New private substrate helpers `algebraMap_bijective_of_finrank_one` + `phi_left_functionField_algEquiv_of_finrank_one` are not blueprint-pinned (file-private substrate, not a public lemma).
- No blueprint edits required for the substrate landing — the substrate is implementation detail of helper (a).

## iter-195+ candidate work
1. **Helper (a)**: per-fibre LQF closure. Either via project-side "smooth-curve fibre 0-dim" lemma, or via switching to a different reduction route (e.g. `LocallyQuasiFinite.of_finite_preimage_singleton` requires "every preimage of singleton is finite", which is the same difficulty).
2. **Helper (d)**: project-side `IsNormalScheme` substrate, then "smooth-curve sections are Dedekind" link.
3. **?hLPUnif** at L521: construct `(ProjectiveLineBar kbar).left.PrimeDivisor` at ∞ ∈ ℙ¹, then compute order via `Ring.ordFrac`.
4. **Mathlib-analogist consult** on (1)+(2): the iter-200 mandatory sweep is the right venue per PROGRESS.md.
