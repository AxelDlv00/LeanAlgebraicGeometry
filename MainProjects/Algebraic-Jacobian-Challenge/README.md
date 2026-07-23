# AlgebraicJacobian

A Lean 4 formalization of the Jacobian of a smooth, proper, geometrically
integral curve over a field.  The project follows the Picard-scheme route: it
constructs the relative Picard functor, represents it through the
Grassmannian/Quot/flattening-stratification machinery, identifies its identity
component as an abelian variety of dimension equal to the genus, and proves the
Albanese universal property.

The formalization is advanced but incomplete.  The live Horizon roadmap now
separates the completed infrastructure from the remaining flat-base-change,
Serre-finiteness, Quot, Picard, Picard-identity-component, and Albanese cones.

## Layout

- `AlgebraicJacobian/Cohomology/`: sheaf cohomology, the finite-cover Cech
  complex, higher direct images, and flat base change.
- `AlgebraicJacobian/Picard/`: line bundles, relative Spec, the relative Picard
  functor, Grassmannians, Quot schemes, flattening stratification, and Picard
  identity components.
- `AlgebraicJacobian/Albanese/`: rigidity and extension of rational maps, plus
  the Albanese factorization.
- `AlgebraicJacobian/RiemannRoch/`: divisor and adelic Riemann--Roch
  infrastructure.
- `blueprint/src/chapters/`: the mathematical blueprint.
- `hgraph/`: the generated statement/declaration dependency graph.
- [`../../references/summary.md`](../../references/summary.md): shared source
  bibliography and retrieval notes.

## Build

The project uses Lean `v4.31.0` and Mathlib `v4.31.0`.

```bash
lake exe cache get
lake build
```

This project is part of an Archon Horizon workspace.  Roadmap, task, inbox, and
cross-project state live at the workspace root and are accessed through the
`horizon` CLI.
