# Refactor Report — root-imports (iter-030)

## Task 1 — root file updated

`AlgebraicJacobian.lean` now contains both new lines after `CechToCohomology`:

```lean
import AlgebraicJacobian.Cohomology.CechToCohomology
import AlgebraicJacobian.Cohomology.AffineSerreVanishing
import AlgebraicJacobian.Cohomology.QcohTildeSections
```

`lake env lean AlgebraicJacobian.lean` → EXIT 0.

## Task 2 — QcohTildeSections import narrowed

`import Mathlib` replaced with:

```lean
import Mathlib.AlgebraicGeometry.Modules.Tilde
```

`lake env lean AlgebraicJacobian/Cohomology/QcohTildeSections.lean` → EXIT 0 with no missing identifiers; `Mathlib.AlgebraicGeometry.Modules.Tilde` alone suffices for all 4 declarations (`asIso`, `IsIso`, `moduleSpecΓFunctor`, `isIso_fromTildeΓ_of_presentation`).

## Build confirmation

`lake build AlgebraicJacobian.Cohomology.AffineSerreVanishing AlgebraicJacobian.Cohomology.QcohTildeSections` → EXIT 0, 8326 jobs, both targets built successfully (2.1 s and 3.5 s respectively). No errors, only pre-existing style warnings in unrelated files.

## Changes made

| File | Change |
|------|--------|
| `AlgebraicJacobian.lean` | Added 2 import lines (AffineSerreVanishing, QcohTildeSections) |
| `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` | Replaced `import Mathlib` with `import Mathlib.AlgebraicGeometry.Modules.Tilde` |

No declaration bodies, proof terms, or other files were touched.
