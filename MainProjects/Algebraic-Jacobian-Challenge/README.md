# Algebraic Jacobian Challenge

A Lean 4 formalization of the Jacobian of a smooth, proper, geometrically
irreducible curve over a field.  The project takes the Picard-scheme route: build
the relative Picard functor, represent it through the
Grassmannian/Quot/flattening-stratification machinery, identify its identity
component as an abelian variety of dimension the genus, and derive the Albanese
universal property.  The first and last legs are substantially built; the
representability leg is the open frontier.

It is developed alongside `Algebraic-Jacobian-Challenge-Rebuild`, which attacks the
same theorem by a separate curve-specialized strategy.

## State (measured 2026-07-27)

- **164 modules, 121,662 lines.**  Exactly **24 `sorry`** remain, spread over 11
  modules; the other **153 modules are sorry-free**.
- A warm `lake build` is **green**: 8,723 jobs, and 162 warning heads across 28
  files, of which 24 are `declaration uses sorry`.
- **86 of the 164 modules still open with a bare `import Mathlib`**, and 132 of the
  164 inherit one transitively.  This is the dominant build cost; it is being
  converted bottom-up from the import-DAG sources using the helpers in `scripts/`.

Cones closed: `AJC.substrate`, `AJC.linebundle`, `AJC.grquot`, `AJC.cech`.
Cones open: `AJC.fbc` (flat base change, three leaves), `AJC.rr`, `AJC.picrep`
(Picard representability), `AJC.pic0av` (Pic⁰ is an abelian variety),
`AJC.albanese`.  Run `horizon roadmap list --focus AJC.jacobian` for the live tree
— the roadmap, not this file, is the authority on status.

## Navigation

- [`AlgebraicJacobian.lean`](AlgebraicJacobian.lean): project import root.
- [`AlgebraicJacobian/Jacobian.lean`](AlgebraicJacobian/Jacobian.lean): the final
  Jacobian witness interface and assembly point.
- [`blueprint/web/index.html`](blueprint/web/index.html): generated mathematical blueprint.
- [`analogies/README.md`](analogies/README.md): index to the historical design notes.
- [`../Algebraic-Jacobian-Challenge-Rebuild/README.md`](../Algebraic-Jacobian-Challenge-Rebuild/README.md):
  the alternative Rebuild route.

## Layout

- `AlgebraicJacobian/Cohomology/`: sheaf cohomology, the finite-cover Čech
  complex, higher direct images, and flat base change.
- `AlgebraicJacobian/Picard/`: line bundles, relative Spec, the relative Picard
  functor, Grassmannians, Quot schemes, flattening stratification, and Picard
  identity components.
- `AlgebraicJacobian/Albanese/`: rigidity and extension of rational maps, plus the
  Albanese factorization.
- `AlgebraicJacobian/RiemannRoch/`: divisor and adelic Riemann–Roch infrastructure.
- `blueprint/src/chapters/`: the mathematical blueprint.
- `hgraph/`: the generated statement/declaration dependency graph.
- `scripts/`: import-minimization and budget-trimming helpers (`min-imports.sh`,
  `deumbrella.sh`, `deumbrella-wave.sh`, `trim-budgets.sh`).  They drive
  `lake env lean`, never `lake build`, so they do not invalidate the build tree.
- `informal/`, `memory/`, `analogies/`: campaign plans, durable notes, and
  historical design notes.  See each directory's own index.
- [`../../references/summary.md`](../../references/summary.md): shared source
  bibliography and retrieval notes.

## Build

Lean and Mathlib are both pinned at `v4.31.0`.

```bash
lake exe cache get
lake build
```

For faithful checks, prefer the configured module target.  `lake env lean <file>`
does not apply every option from the lakefile's `[leanOptions]` — in particular
`maxSynthPendingDepth` — so a direct-file-only instance-synthesis failure can be an
option mismatch rather than a source regression.  Files that rely on that option
carry a local `set_option` so direct-file, LSP, and module checks agree.

This project is part of an Archon Horizon workspace.  Roadmap, task, inbox, and
cross-project state live at the workspace root and are reached through the
`horizon` CLI.
