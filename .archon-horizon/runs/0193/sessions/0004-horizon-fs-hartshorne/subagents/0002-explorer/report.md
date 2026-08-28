The bounded port is independently compilable.

Current [Chapter1CurveStalks.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter1CurveStalks.lean:41) passes focused Lean checking. The entire file also compiles with only:

```lean
import Mathlib.AlgebraicGeometry.Morphisms.Smooth
import Mathlib.RingTheory.Unramified.LocalStructure
```

The essential principal-order cone is:

- Five Dedekind algebra lemmas at lines 41–110.
- `smoothCurve_exists_dedekind_affineOpen` at line 214.
- `affineOpen_stalk_isDiscreteValuationRing` at line 244.
- `smoothCurve_stalk_isDiscreteValuationRing` at line 266.
- `smoothCurve_stalk_isDedekindDomain` at line 275.

These require only a field base, relative-dimension-one smoothness, integrality, and a non-generic point. Properness, algebraic closedness, finite type, and quasi-compactness are unnecessary at this stage.

The specialization and finite-closed-set lemmas in the same file form the next cone needed for finite support. Only `ordZ_support_finite` later needs `LocallyOfFiniteType` and `QuasiCompact`.

I also kernel-checked the next declaration, the order valuation adapted from AJCR `ClosedPoint.lean:95–104`, using this module alone. It compiles. Thus the next coherent advance is:

1. Define the stalk order valuation.
2. Package its integer-valued unit restriction as `ordZ`.
3. Prove finite support and construct the principal `PointDivisor`.

The valuation-ring wrappers are useful source-facing results but are not dependencies of principal divisors. The AJCR transcendence declarations can remain out of scope.
