# Refactor report — tilde-import (iter-034)

## Status: DONE — EXIT 0

## Change made
Added one line to `AlgebraicJacobian.lean` between `CechToCohomology` and `AffineSerreVanishing`:

```
import AlgebraicJacobian.Cohomology.TildeExactness
```

## Final import order in `AlgebraicJacobian.lean`

```
import AlgebraicJacobian.Cohomology.HigherDirectImage
import AlgebraicJacobian.Cohomology.HigherDirectImagePresheaf
import AlgebraicJacobian.Cohomology.CechHigherDirectImage
import AlgebraicJacobian.Cohomology.CechAcyclic
import AlgebraicJacobian.Cohomology.AcyclicResolution
import AlgebraicJacobian.Cohomology.PresheafCech
import AlgebraicJacobian.Cohomology.FreePresheafComplex
import AlgebraicJacobian.Cohomology.CechBridge
import AlgebraicJacobian.Cohomology.AbsoluteCohomology
import AlgebraicJacobian.Cohomology.CechToCohomology
import AlgebraicJacobian.Cohomology.TildeExactness      ← inserted here
import AlgebraicJacobian.Cohomology.AffineSerreVanishing
import AlgebraicJacobian.Cohomology.QcohTildeSections
```

## Build output (tail)
```
✔ [8329/8331] Built AlgebraicJacobian.Cohomology.TildeExactness (1.9s)
✔ [8330/8331] Built AlgebraicJacobian (3.3s)
Build completed successfully (8331 jobs).
EXIT: 0
```

No errors. Only pre-existing style warnings (longLine, show-vs-change) from other files; none from TildeExactness.lean.

## Files modified
- `AlgebraicJacobian.lean` — one line inserted (line 11)

No proofs touched, no sorries introduced.
