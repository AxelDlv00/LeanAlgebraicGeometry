# LeanAlgebraicGeometry-Horizon

LeanAG Horizon is a multi-project Lean 4 and Mathlib workspace for formalizing algebraic
geometry with [Archon Horizon](https://github.com/frenzymath/Archon-Horizon). Its central goal is
the algebraic-geometry version of the [Algebraic Jacobian challenge](https://leanprover.zulipchat.com/#narrow/channel/583336-Autoformalization/topic/Jacobian.20challenge/near/587802685),
proposed by Christian Merten after Kevin Buzzard's differential-geometry challenge.

> [!IMPORTANT]
> The workspace develops **two live routes** to the Algebraic Jacobian challenge. Follow the
> project named by the active task rather than treating either route as reference-only.
>
> - `MainProjects/Algebraic-Jacobian-Challenge` continues the ambitious Picard-scheme route through
>   Grassmannians, Quot schemes, flattening stratification, `Pic^0`, and the Albanese property.
> - `MainProjects/Algebraic-Jacobian-Challenge-Rebuild` develops a cleaner curve-specialized route
>   from protected target statements.

The two projects share mathematical sources and supporting subprojects while keeping independent
Lean roots, blueprints, and roadmaps. The rebuild is listed first in the workspace manifest as the
default project; explicitly scoped tasks may and do advance the ambitious original route.

The [live dashboard](https://axeldlv00.github.io/LeanAlgebraicGeometry/) is the best view of current
tasks, commits, session logs, blueprint graphs, and declaration-level progress. A static snapshot
is published approximately every 30 minutes; GitHub Pages deployment and caching can add a few
minutes before a new snapshot is visible.

## Repository Layout

| Path | Role |
| --- | --- |
| `MainProjects/Algebraic-Jacobian-Challenge-Rebuild` | Cleaner curve-specialized AJC route and workspace default. |
| `MainProjects/Algebraic-Jacobian-Challenge` | Ambitious Picard-scheme/Quot AJC route, maintained by scoped tasks. |
| `SubProjects/` | Supporting, extracted, and related-paper formalizations available to the active project. |
| `references/` | Shared mathematical sources and retrieval notes. |
| `.archon-horizon/` | Workspace state: tasks, roadmap, inbox, run metadata, graphs, and ledger. |
| `config.yaml` | Ordered workspace manifest. The rebuild is listed first because it is the primary project. |

Each route has its own overview:

- [`MainProjects/Algebraic-Jacobian-Challenge/README.md`](MainProjects/Algebraic-Jacobian-Challenge/README.md)
- [`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md`](MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md)

## Project Map

The workspace currently registers these projects, in priority order:

| Project | Purpose |
| --- | --- |
| **`Algebraic-Jacobian-Challenge-Rebuild`** | Cleaner curve-specialized route; default project in the workspace manifest. |
| `Algebraic-Jacobian-Challenge` | Ambitious Picard-scheme, Quot, `Pic^0`, and Albanese route. |
| `Line-Bundle-Comparison-Iso` | Extracted line-bundle pullback, tensor, and dual comparison infrastructure. |
| `Albanese` | Albanese universal property, rigidity, and rational-map-extension infrastructure. |
| `Cech-Cohomology` | Čech computation of higher direct images and its cohomological substrate. |
| `GR-Quot-Closure` | Relative Grassmannian and quotient-representability infrastructure. |
| `MR0555258-Compactifying-Picard` | Compactifying the Picard scheme (D'Souza), under `SubProjects/RelatedPapersFormalisation/`. |
| `Picard-IdentityComponent` | Extracted Picard identity-component and `Pic^0` development. |

These member projects remain useful sources of proved APIs, mathematical designs, and failure
memory for both main routes.

## Working in a Main Project

The workspace currently uses Lean and Mathlib `v4.31.0`. Build the project named by the task. For
the ambitious Picard-scheme route:

```bash
cd MainProjects/Algebraic-Jacobian-Challenge
lake build
```

The rebuild uses the shared workspace package directory at `.lake-packages`, so member projects
can reuse the same Mathlib checkout while retaining independent build directories.

For workspace-wide exploration, run commands from the repository root:

```bash
horizon dashboard
horizon graph -p Algebraic-Jacobian-Challenge frontier
horizon search "Jacobian Picard representability"
```

The first command starts the local dashboard. The graph command shows the ranked proof frontier
for the active project, and search queries declarations across the workspace and Mathlib.

## Methodology

[Archon Horizon](https://github.com/frenzymath/Archon-Horizon) coordinates long-running
formalization while keeping mathematical and operational state explicit:

- **Horizon sessions** implement and verify Lean proofs against concrete tasks.
- **Fresh-context reviewers** such as Ground, work-reviewer, and janitor are dispatched at review
  and maintenance checkpoints rather than acting as a permanent second driver.
- **Blueprint graphs (`hgraph`)** track declaration dependencies, proof status, comments, and the
  ranked frontier for each project.
- **Roadmap, tasks, and inbox** record strategy, scoped work, cross-session handoffs, and durable
  failure memory.
- **The workspace ledger** records coherent commits and powers the public dashboard's progress
  and session views.

The mathematical blueprint is kept separate from implementation journals. Lean-specific progress
and failed approaches belong in graph comments, tasks, or the inbox, while the blueprint remains a
timeless account of the mathematics.

## Contributing

Contributions are welcome, but keep the two routes and task scope explicit:

- **AJC proofs and infrastructure:** change only the main project named by the task; share reusable
  inputs through the supporting projects when appropriate.
- **Protected statements:** do not alter the signatures in the rebuild's `Challenge.lean` or files
  covered by `archon-protected.yaml` without prior agreement. Contributions should discharge those
  statements, not weaken or reshape them silently.
- **Issues and discussions:** include the declaration name and file path, and state whether the
  question concerns the statement, naming, proof strategy, or intended use.
- **Large changes:** check the live dashboard or open an issue first so work does not duplicate an
  active Horizon task.
- **Supporting work:** a focused subproject under `SubProjects/` is appropriate when a reusable
  dependency needs to be developed independently, but its intended consumer should be the active
  rebuild.

Clear, stable, mathematical declaration names and warning-free builds are expected. Using the
`horizon` CLI is recommended so contributions remain aligned with the workspace manifest,
blueprint graph, and ledger conventions.

## License

This repository is distributed under the [Apache License 2.0](LICENSE).

Author: Axel Delaval, AI4MATH@PKU
