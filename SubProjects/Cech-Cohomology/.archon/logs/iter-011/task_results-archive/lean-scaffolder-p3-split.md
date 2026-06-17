# Lean Scaffolder Report — p3-split

## Status: SUCCESS

Build: **GREEN** (8322 jobs, 0 errors; `lake build` via LSP).

---

## Task 1 — `AlgebraicJacobian/Cohomology/CechAcyclic.lean` created

New file created at `AlgebraicJacobian/Cohomology/CechAcyclic.lean`.

### Final compiling signature of `CechAcyclic.affine`

```lean
theorem CechAcyclic.affine {R : CommRingCat.{u}} {S : Scheme.{u}}
    (f : Spec R ⟶ S) [IsAffineHom f]
    {ι : Type u} [Finite ι] (s : ι → R) (hs : Ideal.span (Set.range s) = ⊤)
    (F : (Spec R).Modules) (hF : F.IsQuasicoherent) (p : ℕ) (hp : 1 ≤ p) :
    IsZero ((CechComplex f ((Scheme.affineOpenCoverOfSpanRangeEqTop s hs).openCover) F).homology p) := by
  sorry
```

This matches the directive's locked design exactly. Notes on resolution:

- `affineOpenCoverOfSpanRangeEqTop {R : CommRingCat} {ι : Type*} (s : ι → R) (hs : ...) : (Spec R).AffineOpenCover` — confirmed in `Mathlib/AlgebraicGeometry/Cover/Open.lean:203`.
- `AffineOpenCover.openCover` — confirmed at `Open.lean:128`; declared `@[simps! I₀ X f]`, so `openCover.I₀ = ι` by reduction. The `[Finite ι]` hypothesis yields `Finite (... .openCover.I₀)` via definitional equality; no `haveI` bridge was needed.
- `CechComplex` has no `[Finite 𝒰.I₀]` constraint in its definition, so the application elaborates without any instance annotation.
- `[IsAffine (Spec R)]` dropped (automatically satisfied; no explicit instance needed in re-signed version).
- `[IsAffineHom f]` retained (a map from `Spec R` is not automatically affine for arbitrary codomain).

### Strategy comment injected

A `/- Planner strategy (P3, see analogies/p3-localisation.md): -/` block above the theorem describes the L1/L2/L3 route (away-localisation identification, `exact_of_isLocalized_span`, contracting homotopy on `M_{s_r}`), with the explicit warning against routing through simplicial `ExtraDegeneracy`.

### Imports

```
import Mathlib
import AlgebraicJacobian.Cohomology.CechHigherDirectImage
```

---

## Task 2 — `CechHigherDirectImage.lean` trimmed and updated

### Old `CechAcyclic.affine` removed

The theorem block (doc comment lines 747–763 + theorem body 764–774) and the following blank line were deleted. `CechComplex` (line 737) is untouched.

### `cech_computes_higherDirectImage` doc comment updated

The stale spectral-sequence proof narrative replaced with the Route-A paragraph:

> Route A: reduce to `S` affine; the augmented Čech complex is a termwise `f_*`-acyclic resolution of `F` (each term is a product of pushforwards over affine intersections, acyclic by `CechAcyclic.affine` via the P3b bridge), so the P4 acyclic-resolution lemma (`rightDerivedIsoOfAcyclicResolution`) gives `Hⁱ(f_* C•) ≅ Rⁱ f_* F`.

The proof body comment was similarly updated to Route-A language. The **signature** of `cech_computes_higherDirectImage` is unchanged (frozen, as required).

---

## Task 3 — Import wiring

`AlgebraicJacobian.lean` now contains:

```lean
import AlgebraicJacobian.Cohomology.HigherDirectImage
import AlgebraicJacobian.Cohomology.CechHigherDirectImage
import AlgebraicJacobian.Cohomology.CechAcyclic
import AlgebraicJacobian.Cohomology.AcyclicResolution
```

---

## Build output (key lines)

```
⚠ [8320/8322] Built AlgebraicJacobian.Cohomology.CechAcyclic (4.4s)
warning: AlgebraicJacobian/Cohomology/CechAcyclic.lean:74:8: declaration uses `sorry`
ℹ [8321/8322] Built AlgebraicJacobian (3.6s)
✔ [8322/8322] Ran AlgebraicJacobian/AlgebraicJacobian:default
Build completed successfully (8322 jobs).
```

All other warnings are pre-existing linter warnings (line length, maxHeartbeats) from `CechHigherDirectImage.lean`; none are new.

---

## Uncovered declarations

None. `CechAcyclic.affine` is already pinned by `lem:cech_acyclic_affine` in the blueprint.

---

## Deviations from directive

None. The signature, imports, comment structure, and build requirement all match exactly as specified.
