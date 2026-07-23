# LeanAlgebraicGeometry-Horizon

LeanAG Horizon is a multi-project Lean 4 and Mathlib workspace for formalizing algebraic
geometry with [Archon Horizon](https://github.com/frenzymath/Archon-Horizon). Its central goal is
the algebraic-geometry version of the [Algebraic Jacobian challenge](https://leanprover.zulipchat.com/#narrow/channel/583336-Autoformalization/topic/Jacobian.20challenge/near/587802685),
proposed by Christian Merten after Kevin Buzzard's differential-geometry challenge.

> [!IMPORTANT]
> **`MainProjects/Algebraic-Jacobian-Challenge-Rebuild` is the current Algebraic Jacobian
> Challenge project and the project actively being worked on.** All ongoing AJC formalization,
> integration, and new contributions should target the rebuild unless a task explicitly says
> otherwise. `MainProjects/Algebraic-Jacobian-Challenge` is the legacy implementation: it is kept
> for historical context and occasional reference, but it is not the current development target.

The rebuild starts from a protected, reviewable statement file and develops a cleaner,
mathlib-idiomatic proof stack from scratch. It targets the Jacobian of a smooth, proper,
geometrically irreducible curve, its Abel-Jacobi map and Albanese universal property, together
with the extended functoriality and field-base-change statements. Current work is concentrated in
the rebuild's Picard and representability pipeline on the path to those headline declarations.

The [live dashboard](https://axeldlv00.github.io/LeanAlgebraicGeometry/) is the best view of current
tasks, commits, session logs, blueprint graphs, and declaration-level progress. A static snapshot
is published approximately every 30 minutes; GitHub Pages deployment and caching can add a few
minutes before a new snapshot is visible.

## Repository Layout

| Path | Role |
| --- | --- |
| `MainProjects/Algebraic-Jacobian-Challenge-Rebuild` | **Current and active AJC formalization. New work belongs here.** |
| `MainProjects/Algebraic-Jacobian-Challenge` | Legacy implementation retained for reference; not the active target. |
| `SubProjects/` | Supporting, extracted, and related-paper formalizations available to the active project. |
| `references/` | Shared mathematical sources and retrieval notes. |
| `.archon-horizon/` | Workspace state: tasks, roadmap, inbox, run metadata, graphs, and ledger. |
| `config.yaml` | Ordered workspace manifest. The rebuild is listed first because it is the primary project. |

The active rebuild has its own overview in
[`MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md`](MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md).
Its protected target signatures live in
[`AlgebraicJacobian/Challenge.lean`](MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean).

## Project Map

The workspace currently registers these projects, in priority order:

| Project | Purpose |
| --- | --- |
| **`Algebraic-Jacobian-Challenge-Rebuild`** | **Primary project under active development: the from-scratch Jacobian formalization and extended challenge.** |
| `Algebraic-Jacobian-Challenge` | Legacy AJC development used only as reference when needed. |
| `Line-Bundle-Comparison-Iso` | Extracted line-bundle pullback, tensor, and dual comparison infrastructure. |
| `Albanese` | Albanese universal property, rigidity, and rational-map-extension infrastructure. |
| `Cech-Cohomology` | Čech computation of higher direct images and its cohomological substrate. |
| `GR-Quot-Closure` | Relative Grassmannian and quotient-representability infrastructure. |
| `MR0555258-Compactifying-Picard` | Formalization work related to compactifying the Picard scheme. |
| `Picard-IdentityComponent` | Extracted Picard identity-component and `Pic^0` development. |

These member projects remain useful sources of proved APIs, mathematical designs, and failure
memory. They do not change the default integration target: current AJC work goes into the rebuild.

## Working in the Active Project

The workspace currently uses Lean and Mathlib `v4.31.0`. To build the active project:

```bash
cd MainProjects/Algebraic-Jacobian-Challenge-Rebuild
lake build
```

The rebuild uses the shared workspace package directory at `.lake-packages`, so member projects
can reuse the same Mathlib checkout while retaining independent build directories.

For workspace-wide exploration, run commands from the repository root:

```bash
horizon dashboard
horizon graph -p Algebraic-Jacobian-Challenge-Rebuild frontier
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

Contributions are welcome, but please use the active/legacy distinction consistently:

- **AJC proofs and infrastructure:** target
  `MainProjects/Algebraic-Jacobian-Challenge-Rebuild` by default. Do not add new AJC development to
  the legacy project unless an issue or task explicitly requests legacy maintenance.
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
