# Algebraic Jacobian Challenge

A Lean 4 formalization of the Jacobian of a smooth, proper, geometrically
irreducible curve over a field.  The project takes the Picard-scheme route: build
the relative Picard functor, represent it, identify its identity component as an
abelian variety of dimension the genus, and derive the Albanese universal
property.  The first and last legs are substantially built; representability is
the open frontier.

Representability is being built by the **Milne–Kollár route** — construct
`Pic^r` over a separably closed field from the loci where `h⁰ = 1`, glue,
descend to `k` by a finite Galois quotient, assemble the degrees by a coproduct.
The plan of record is [`informal/pic-representability-campaign.md`](informal/pic-representability-campaign.md).
The Grothendieck/Kleiman quotient route via the Quot scheme is **not** the path
being built: its descent step needs a quasi-projectivity hypothesis that is not
expressible at the pinned Mathlib revision and without which the lemma is false.
Its substrate (Grassmannians, graded algebra, flattening stratification) is
sorry-free and is consumed by the committed route, so it is retained.

It is developed alongside `Algebraic-Jacobian-Challenge-Rebuild`, which attacks the
same theorem by a separate curve-specialized strategy.

## State (measured 2026-07-27)

- **173 modules, 125,285 lines**, all of them reachable from
  [`AlgebraicJacobian.lean`](AlgebraicJacobian.lean).  **26 `sorry`** remain,
  spread over 11 modules; the rest are locally sorry-free.  Rootedness is worth
  measuring, not assuming: a module nothing imports compiles green and is invisible
  both to the root build and to the axiom probe.
- A warm `lake build AlgebraicJacobian` is **green**: 8,732 jobs, exit 0.
- **Locally sorry-free is not axiom-clean.**  Two `sorry`-bodied *instances* leak
  through typeclass synthesis: `instHasPicScheme`
  (`Picard/FGAPicRepresentability.lean`, the sole producer of `HasPicScheme`) and
  `pullback_preservesFiniteLimits`
  (`Cohomology/CechHigherDirectImageUnconditional.lean`).  A theorem that merely
  *quantifies over* such a gate reports clean axioms, because the hypothesis is
  discharged by the caller; the leak appears at any call site that must
  synthesise the instance.  Run
  [`scripts/axiom-frontier.lean`](scripts/axiom-frontier.lean) (`lake env lean
  scripts/axiom-frontier.lean`, ~8s warm, 66 declarations) before believing any
  completeness claim — it measures the frontier rather than inferring it.
- **A clean axiom set answers one question only:** is a `sorry` reachable from this
  proof term.  Three separate things it cannot see have each been measured in this
  tree — a `sorry`-bodied instance reached only through synthesis; an *unproved*
  named hypothesis in the statement; and a *false* named hypothesis in the
  statement, which makes the theorem vacuously true and perfectly clean.  Read the
  probe's section headers, not just its output lines.
- 66 of the 173 modules still open with a bare `import Mathlib`; this is the
  dominant build cost and is being converted bottom-up with the helpers in
  `scripts/`.

## Open decision

Whether to represent the plain relative Picard functor while carrying a
`k`-rational-point hypothesis — strictly weaker than the challenge statement,
since such a curve need not have a rational point — or to étale-sheafify and drop
the hypothesis, is an open decision for the project owner (roadmap
`AJC.picrep.rational-point`).  Both branches are recorded in the blueprint's FGA
chapter and at the Lean leaf `hasRationalPoint_of_curve`
(`AlgebraicJacobian/Jacobian.lean`); neither is assumed.

This is now the *whole* of that gap.  The leaf used to assert geometric integrality
as well, which obscured the fact that only one of the two is a decision: geometric
integrality of a smooth geometrically irreducible curve is a theorem
(`geometricallyIntegral_of_curve`, via `Smooth ⇒ GeometricallyReduced` in
[`AlgebraicJacobian/Curve/GeometricallyReduced.lean`](AlgebraicJacobian/Curve/GeometricallyReduced.lean)),
and it is now proved rather than assumed.  The rational point is a genuine
mathematical gap: the statement is *false* in general, so the leaf must be replaced
by whichever branch the owner picks, never proved.

Cones closed: `AJC.substrate`, `AJC.linebundle`, `AJC.grquot`, `AJC.cech`.
Cones open: `AJC.fbc` (flat base change, three leaves), `AJC.rr`, `AJC.picrep`
(Picard representability), `AJC.pic0av` (Pic⁰ is an abelian variety),
`AJC.albanese`.  Run `horizon roadmap list --focus AJC.jacobian` for the live tree
— the roadmap, not this file, is the authority on status.

## Navigation

- [`AlgebraicJacobian.lean`](AlgebraicJacobian.lean): project import root.
- [`AlgebraicJacobian/Jacobian.lean`](AlgebraicJacobian/Jacobian.lean): the final
  Jacobian witness interface and assembly point.  The witness is built from
  `Pic⁰_{C/k}` and depends on five stated obligations: `Pic0.smooth` and
  `Pic0.proper` upstream, plus three named leaves stated there.  97 of the 173
  modules are reachable from it.
- [`scripts/axiom-frontier.lean`](scripts/axiom-frontier.lean): the axiom-frontier
  probe, and the two reachability measurements in its header (headline cone, and
  whether every module on disk is rooted at all).
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
