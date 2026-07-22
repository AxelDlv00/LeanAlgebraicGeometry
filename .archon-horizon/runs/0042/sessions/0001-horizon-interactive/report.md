## Progress

The direct representability route is materially advanced but not complete.

- `5a630006a` proves the previously missing chart-read saturation theorem in [DivSchemeHighWindowTransitionSaturation.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivSchemeHighWindowTransitionSaturation.lean:424).
- `14ee351ed` proves Koszul-boundary base-change compatibility and reduces fibrewise exactness to an explicit finrank inequality in [DivSchemeHighWindowKoszul.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivSchemeHighWindowKoszul.lean:203).
- The chart quotient theorem [flat_shifted_highWindow_chart_quotient_of_saturation](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivSchemeHighWindowTransitionQuotient.lean:232) now has its saturation input proved. Its remaining input is finite-stage quotient flatness.
- Roadmap entries `AJCR.w4-rep`, `datum`, `dat-d`, and `ddr` were updated and remain correctly `active`.

Verification passed:

- Saturation build: 8,831 jobs.
- Koszul build: 8,590 jobs.
- Relevant source files are committed and clean.

## Why I Stopped

The remaining statement is not merely technical. For every residue field and every high-window multiplication map, one must prove

```text
ker(multiplication) = range(Koszul boundary).
```

Only `range ⊆ ker` and multiplication surjectivity are currently proved. The missing reverse inclusion is precisely a relative Gotzmann/first-syzygy theorem, equivalently the unproved finrank lower bound at [DivSchemeHighWindowKoszul.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivSchemeHighWindowKoszul.lean:296).

Choosing the actual global kernel does not bypass this: [DivSchemeHighWindowSyzygy.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivSchemeHighWindowSyzygy.lean:254) proves that its fibre-base-change law is equivalent to the desired quotient flatness, so that argument would be circular.

The old Jacobian flattening theorem changes the base to locally closed rank strata and its Quot endpoint is still sorry-backed. The redesign theorem proves flatness only for the `RZ`-linear reading range, not the larger chart ideal. Neither is a drop-in completion.

Therefore representability is not yet fully formalized. The next substantive task is proving that relative first-syzygy rank estimate, or deliberately porting the full flattening-stratification route.
