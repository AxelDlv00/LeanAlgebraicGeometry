# Lean Scaffolder Report — p3b-skeleton

## Status: GREEN BUILD

`lake build` completed successfully (8323 jobs). `AlgebraicJacobian.Cohomology.PresheafCech`
compiled in 3.7 s. Zero errors. Pre-existing warnings in `AcyclicResolution.lean` (unused
section variables, `show` vs `change`) are unchanged from the baseline — they are not
caused by this iteration.

## File created

**`AlgebraicJacobian/Cohomology/PresheafCech.lean`**

Contents:
- Copyright header matching sibling files (© 2026 Christian Merten, Apache 2.0).
- `import Mathlib` + `import AlgebraicJacobian.Cohomology.CechHigherDirectImage`.
- `universe u`, `open CategoryTheory Limits`, `namespace AlgebraicGeometry`.
- Module docstring listing the five declarations to be built with their `\lean{...}` names.
- A single large `/- Planner strategy ... -/` block comment with the full five-step
  roadmap (see "Roadmap injected" below). No declarations, no `sorry`.

## Import wiring

Added to `AlgebraicJacobian.lean`:
```
import AlgebraicJacobian.Cohomology.PresheafCech
```

## Roadmap injected

The `/- Planner strategy -/` block covers:

**Step 1 — `sectionCechComplex`**
Type: `CochainComplex (ModuleCat (O_X(U))) ℕ`, degree `p` = product over `(i₀,…,iₚ)`
multi-indices of `F(U_{i₀} ⊓ … ⊓ U_{iₚ} ⊓ U)`, alternating restriction differential.
DISTINCT from the relative `CechComplex` in `CechHigherDirectImage.lean`.
Hooks: `PresheafOfModules.evaluation`, `CochainComplex.of`.

**Step 2 — `cechFreePresheafComplex`**
Type: `ChainComplex X.PresheafOfModules ℕ`, degree `p` =
`⨁_{I} (PresheafOfModules.free _).obj (yoneda.obj (U_{I(0)} ⊓ … ⊓ U_{I(p)}))`.
DO NOT introduce a bespoke `j_!`; use `free ∘ yoneda` throughout.
Differentials = `(free _).map` of representable index-dropping maps (inclusions of opens).
Hooks: `PresheafOfModules.free`, `PresheafOfModules.freeAdjunction`, `yoneda`.

**Step 3 — `cechComplex_hom_identification`**
Type: natural iso `Hom_{PMod}(K(𝒰)_•, F) ≅ Č•(𝒰, F, U)` as cochain complexes.
Strategy: `freeAdjunction.homEquiv` + `yonedaEquiv` + `evaluation` term-by-term;
verify differentials intertwine; assemble with `HomologicalComplex.Hom.isoOfComponents`.

**Step 4 — `cechFreeComplex_quasiIso`**
Type: `K(𝒰)_• → O_𝒰[0]` is a quasi-isomorphism.
Strategy: homology is objectwise in `PresheafOfModules`; sectionwise contracting homotopy
`h(s)_{i₀,…,iₚ} = (i₀ = i_fix) · s_{i₁,…,iₚ}`; assemble via `HomologicalComplex.Homotopy`
and `HomotopyEquiv.toQuasiIso`. Do NOT use `ExtraDegeneracy`.

**Step 5 — `injective_cech_acyclic`**
Type: for injective `I : X.Modules` and open cover `𝒰`, `Ȟ^p(𝒰, I) = 0` for `p > 0`.
Part (a): `I` injective in `X.Modules` ⟹ `toPresheafOfModules.obj I` injective in
`X.PresheafOfModules` via `Injective.injective_of_adjoint` applied to
`PresheafOfModules.sheafificationAdjunction` (sheafification is exact ⟹
`PreservesMonomorphisms`).
Part (b): `Hom_{PMod}(-, I_pshf)` exact (by injectivity) carries the resolution (step 4)
to an exact complex identified with `Č•(𝒰, I, U)` (step 3), giving vanishing. Bypasses
decisions 4–5 entirely.

## Verified Mathlib hooks (LSP-confirmed per analogies/p3b-presheafcech.md)

- `PresheafOfModules`
- `PresheafOfModules.free`
- `PresheafOfModules.freeAdjunction`
- `PresheafOfModules.evaluation`
- `PresheafOfModules.sheafificationAdjunction`
- `CategoryTheory.Injective.injective_of_adjoint`
- `yoneda`

## Uncovered declarations

None — all five declarations listed in the module docstring correspond to blueprint
entries already added to `Cohomology_CechHigherDirectImage.tex` §"Presheaf-level Čech
machinery" (`def:cech_free_presheaf_complex`, `def:section_cech_complex`,
`lem:cech_complex_hom_identification`, `lem:cech_free_complex_quasi_iso`,
`lem:injective_cech_acyclic`).
