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

Two of the committed route's own engines are substantially built.  The rigidified
pushforward gate is **discharged**: `Adelic.instHasRigidPushforwardOfCurve` is a real
instance for every curve satisfying the challenge hypotheses, and it measures axiom-clean
at the synthesis site, as do the three extraction theorems that now synthesise it rather
than assuming it.  The finite Galois
quotient has Speiser descent, the affine quotient, and `Γ`-stable affine covers proved;
what remains there is gluing.  Both are stated with proofs and Lean pins in the
blueprint's FGA chapter, §"The Milne–Kollár route".  Neither route is hypothesis-free:
the quotient route needs quasi-projectivity of the Abel-map slice, the committed route
needs every finite Galois orbit to lie in an affine open, and the same Hironaka example
defeats both if its hypothesis is dropped.  The difference is that the orbit condition is
available for the schemes this route quotients.

It is developed alongside `Algebraic-Jacobian-Challenge-Rebuild`, which attacks the
same theorem by a separate curve-specialized strategy.

## State (measured 2026-07-27)

- **185 modules, 131,165 lines**; **26 `sorry`** over 11 modules, the rest locally
  sorry-free; a warm `lake build AlgebraicJacobian` **green** at 8,744 jobs.  These
  counts move whenever a module lands, so re-measure rather than quoting them:

  ```bash
  find AlgebraicJacobian -name '*.lean' | wc -l          # modules on disk
  find AlgebraicJacobian -name '*.lean' -exec cat {} + | wc -l
  lake build AlgebraicJacobian 2>&1 | grep -c 'declaration uses .sorry'
  ```
- **Rootedness is worth measuring, not assuming.**  A module that nothing imports
  compiles green and is invisible *both* to the root build and to the axiom probe,
  with nothing warning about it — `import AlgebraicJacobian` never reaches it, so no
  `#print axioms` line for it can even be written.  The check is the second
  measurement in [`scripts/axiom-frontier.lean`](scripts/axiom-frontier.lean)'s
  header.  Modules land here from several parallel efforts, so the unrooted set is
  routinely non-empty for a short while: a module not yet committed to the workspace
  ledger must **not** be rooted, since a clean checkout would then fail to build.  That
  grace period ends at the commit — once a module is in the ledger, leaving it unrooted
  means the build does not check it.
- **Locally sorry-free is not axiom-clean.**  Two `sorry`-bodied *instances* leak
  through typeclass synthesis: `instHasPicScheme`
  (`Picard/FGAPicRepresentability.lean`, the sole producer of `HasPicScheme`) and
  `pullback_preservesFiniteLimits`
  (`Cohomology/CechHigherDirectImageUnconditional.lean`).  A theorem that merely
  *quantifies over* such a gate reports clean axioms, because the hypothesis is
  discharged by the caller; the leak appears at any call site that must
  synthesise the instance.  Run
  [`scripts/axiom-frontier.lean`](scripts/axiom-frontier.lean) (`lake env lean
  scripts/axiom-frontier.lean`, 107 declarations: 70 clean and 37 carrying `sorryAx`,
  measured 2026-07-28 with the root build green at 8,744 jobs) before believing any
  completeness claim — it measures the frontier rather than inferring it.  Count by
  output *entry*, not by output line:
  Lean wraps a long axiom list across several lines, so a per-line filter
  misclassifies exactly the declarations with the longest lists.  The header carries
  the recipe.
- **A clean axiom set answers one question only:** is a `sorry` reachable from this
  proof term.  Six separate things it cannot see have each been found in this
  tree — a `sorry`-bodied instance reached only through synthesis; an *unproved*
  named hypothesis in the statement; a *false* named hypothesis in the statement,
  which makes the theorem vacuously true and perfectly clean; an
  *un-instantiable instance binder*, where the obligation sits in square brackets
  and nothing in the project constructs it for the ambient object actually used
  (an instance for a more structured cousin — `Over (Spec k)` rather than a bare
  `Scheme` — does not count, and is worse than none, because the grep succeeds);
  an *unrooted module*, which no axiom check reaches at all, per the bullet
  above; and an *instance diamond*, where two non-definitionally-equal instances can
  supply the same binder, so a file can prove correct-looking theorems about a
  definition pinned to the wrong one.  The first five are each measured by the probe;
  the sixth defeats the probe *and* an instantiability check, because the binders do
  synthesise — the tell is a cross-file identity that ought to be `rfl` and is not.
  Read the probe's section headers, not just its output lines.
- **Only two of the tree's `sorry` carriers are instances**, and that is the whole of
  the synthesis-leak surface, because an instance is the only carrier a consumer can
  reach without naming it.  The probe's §2 lists all 26 carriers by module (the two
  instances plus 24 theorems and definitions), so the claim is checkable rather than
  folklore; note that two of those 24 hold their `sorry` in a *field*, which a grep
  for `:= sorry` misses.  Re-derive rather than trust the number:

  ```bash
  lake build AlgebraicJacobian 2>&1 | grep 'declaration uses' | sort -u
  ```
- 66 modules still open with a bare `import Mathlib`; this is the
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

The decision is also *bounded*, which is worth stating because the leaf's falsity
invites the reading that nothing here is reachable.  Over an algebraically closed
field the rational point is a theorem — `hasRationalPoint_of_curve_of_isAlgClosed`,
axiom-clean — and `picardJacobianWitnessOfIsAlgClosed` builds the same witness with
four open obligations rather than five.  What the owner decides is therefore what
the project claims over an *arbitrary* base field, not whether the construction runs
at all.  The distinction matters for reading the frontier: over `k̄` every remaining
obligation is a true statement awaiting a proof, whereas the general-field witness
rests on an inconsistent hypothesis and its consequences are vacuously true — a
state no axiom check can distinguish from an honest one (trap (c) above).

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
  `Pic0.proper` upstream, plus three named leaves stated there.  98 modules are
  reachable from it.  Each of the three leaves carries a *companion* stating what the
  landed development already reaches — `hasRationalPoint_of_curve_of_isAlgClosed`,
  `finrank_tangentSpace_pic0_eq_genus`, `isAlbanese_pic0_of_isAlgClosed` — so each
  leaf's remaining distance is compiler-checked rather than described in prose.  The
  first of the three is a genuine discharge and measures clean; the other two record a
  distance and carry `sorryAx`, and the probe's §0 says which is which and why.
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
