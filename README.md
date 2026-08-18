# LeanAlgebraicGeometry-Horizon

Lean 4 and Mathlib formalizations in algebraic geometry, coordinated with
[Archon Horizon](https://github.com/frenzymath/Archon-Horizon). The main objective is the
Algebraic Jacobian challenge: construct the Jacobian of a smooth proper geometrically integral
curve and verify its universal, geometric, functorial, and base-change properties.

The [live dashboard](https://axeldlv00.github.io/LeanAlgebraicGeometry/) shows current tasks,
commits, sessions, roadmap state, and declaration graphs.

## Main Projects

| Project | Role |
| --- | --- |
| `Algebraic-Jacobian-Challenge-Rebuild` | Primary route. Builds `Pic^0` from the etale-sheafified Picard functor, proves representability, and packages the Jacobian data. |
| `Algebraic-Jacobian-Challenge` | Companion route and source of reusable Picard, descent, cohomology, and geometric infrastructure. |

Supporting and historical extractions live under `SubProjects/`; they are not independent
workspace roadmap targets.

## Current Focus

The rebuild follows the reviewer-driven Phase 0-8 route recorded in
[`roadmap.md`](roadmap.md). Phases 0-6 are complete. Phase 7, finite-Galois descent of the
separably closed `Pic^0` representative, is active. Phase 8 will construct the final
`JacobianData` and discharge the protected challenge statements.

Each main project has its own detailed overview:

- [`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md`](MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md)
- [`MainProjects/Algebraic-Jacobian-Challenge/README.md`](MainProjects/Algebraic-Jacobian-Challenge/README.md)

## Layout

| Path | Contents |
| --- | --- |
| `MainProjects/` | The two registered Algebraic Jacobian projects. |
| `SubProjects/` | Supporting and historical formalizations. |
| `references/` | Mathematical references and retrieval metadata. |
| `.archon-horizon/` | Tasks, roadmap items, inbox, run records, graphs, and the workspace ledger. |
| `config.yaml` | Workspace, project, build, and agent configuration. |

## Working Locally

The workspace uses Lean and Mathlib `v4.31.0`. Build the project relevant to the task:

```bash
cd MainProjects/Algebraic-Jacobian-Challenge-Rebuild
lake build AlgebraicJacobian
```

From the workspace root, Horizon provides the live coordination views:

```bash
horizon ps
horizon roadmap list --focus AJCR.review-plan
horizon task list
horizon search "Picard representability"
```

Keep changes scoped to the active task, preserve protected theorem statements, and record
coherent verified progress in the Horizon workspace ledger. Lean implementation notes and failed
approaches belong in task, roadmap, graph, or inbox records; mathematical blueprints should remain
timeless.

## License

Apache 2.0. See [`LICENSE`](LICENSE).

Author: Axel Delaval, AI4MATH@PKU
