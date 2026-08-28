Reconnaissance is complete. The highest-value open frontier is the affine spectrum definition:

- Blueprint: [`blueprint/src/ch02-schemes.tex:129`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/blueprint/src/ch02-schemes.tex:129), label `def:II-2-spectrum`.
- HGraph: node `6beefff2b210`, state `ready`, `lean_status: linked`, 2 direct uses, 14 downstream unlocks.
- Its six listed Lean bindings are all present, compile, and contain no `sorry`:
  - `Hartshorne.AffineSpectrum`
  - `Hartshorne.spectrumZeroLocus`
  - `Hartshorne.spectrumBasicOpen`
  - `Hartshorne.spectrumBasicOpen_isTopologicalBasis`
  - `Hartshorne.affineSpec`
  - `Hartshorne.affineStructureSheaf`
- The likely smallest closure is adding `\leanok` to that existing blueprint block. This is metadata-only and would promote the node from `linked` to verified/closed, unlocking spectrum sections, schemes/subschemes, Proj, affine equivalence, quasi-coherent sheaves, fibred products, and related nodes.

The main substantive Hartshorne curves gap is `cor:II-6-10` (“Principal divisors have degree zero”), at [`blueprint/src/ch02-schemes.tex:915`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/blueprint/src/ch02-schemes.tex:915). `HartshorneLib/Chapter4DegreeClass.lean` currently defines `PrincipalDivisorsHaveDegreeZero` as an explicit hypothesis and builds the degree map on divisor classes from it; no proof theorem exists yet. Principal divisor construction and divisor-class APIs are complete and sorry-free. This is mathematically central but has zero graph unlocks and would require genuine geometric formalization.

Curves-only filtering instead surfaces empty nodes such as `Involution` and `Linear systems` (4 unlocks each), but there is no existing Lean API making them near-term closure targets. Recent commits confirm the current direction: principal divisors, divisor classes, and degree descent were intentionally isolated with principal-degree-zero left as explicit geometric input.
