The portable core compiles unchanged in Hartshorne with only:

```lean
import Mathlib.AlgebraicGeometry.Morphisms.Smooth
import Mathlib.RingTheory.Unramified.Dedekind
import Mathlib.RingTheory.Unramified.LocalStructure
```

Exact theorem bodies are in [DedekindSections.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/DedekindSections.lean:47) lines 47–124 and [StalksDVR.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Curve/StalksDVR.lean:51) lines 51–101 and 153–189.

Minimal dependency chain for smooth stalk valuation rings:

- `IsDedekindDomainDvr.of_formallyUnramified_of_finiteType`
- `IsDedekindDomain.of_formallyUnramified_of_finiteType`
- `MvPolynomial.isPrincipalIdealRing_fin_one`
- `MvPolynomial.isDedekindDomain_fin_one`
- `Algebra.IsStandardSmoothOfRelativeDimension.isDedekindDomain`
- `AlgebraicGeometry.IsAffineOpen.valuationRing_stalk`
- `AlgebraicGeometry.SmoothOfRelativeDimension.exists_isDedekindDomain_section`
- `AlgebraicGeometry.SmoothOfRelativeDimension.valuationRing_stalk`

Adding the two `specializes_eq_genericPoint_or_eq` declarations gives the natural ten-theorem curve-behavior slice.

`StalksDVR.lean` has exactly two cross-file dependencies: `.isDedekindDomain` at lines 170–171 and `.exists_transcendental` at lines 218–219. The transcendence branch additionally requires `Mathlib.RingTheory.Flat.TorsionFree`.

Caveats: the exported smooth stalk theorem proves `ValuationRing`, not a named DVR result; the DVR is constructed only inside its non-generic affine branch. Both audited source files are currently untracked. No files were modified.
