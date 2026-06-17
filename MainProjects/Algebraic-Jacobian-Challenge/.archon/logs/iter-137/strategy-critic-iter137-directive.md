# Strategy Critic Directive

## Slug
iter137

## Project goal

Formalize the nine protected declarations of Christian Merten's
Jacobian challenge (`references/challenge.lean`): `genus`,
`Jacobian` (with its `GrpObj` instance, `SmoothOfRelativeDimension`
with relative dim = genus, `IsProper`, `GeometricallyIrreducible`),
and the Abel–Jacobi triple (`Jacobian.ofCurve`, `comp_ofCurve`,
`exists_unique_ofCurve_comp`). The protected
`nonempty_jacobianWitness` quantifies over an **arbitrary** curve
`C : Over (Spec (.of k))` with `[SmoothOfRelativeDimension 1 C.hom]`
— no genus parameter, no $k$-rational-point hypothesis. End-state
is **zero inline `sorry` in the project**, no named axioms.

## Strategy under review

[The current STRATEGY.md verbatim is at
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md` —
read it directly. It is ~578 lines; per dispatcher_notes, treat that
file as the authoritative subject of your review.]

## References index

The project's `references/summary.md`:

```
| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

Only one reference. Re-read it directly if you need to verify
that any protected declaration's signature matches what the
strategy claims.

## Blueprint summary

Chapter titles and one-line topic:

- `AbelJacobi.tex` — The Abel–Jacobi map (protected statements
  transit through `nonempty_jacobianWitness`).
- `AlgebraicJacobian_Cotangent_GrpObj.tex` — Pointer chapter for
  `Cotangent/GrpObj.lean` (cotangent space at the identity, piece (i)).
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris LES for sheaf
  cohomology with `k`-module coefficients (consumed by `Genus.lean`).
- `Cohomology_SheafCompose.tex` — Sheaf condition along the
  structure-sheaf forget composite (project-internal infrastructure).
- `Cohomology_StructureSheafAb.tex` — Structure sheaf as a sheaf of
  abelian groups, sheafification + Ext.
- `Cohomology_StructureSheafModuleK.tex` — Sheaves of `k`-modules:
  sheafification, Ext, structure sheaf as a sheaf of `k`-modules.
- `Differentials.tex` — Relative cotangent presheaf (project's home-
  grown sheaf-level Ω; built on Mathlib `PresheafOfModules.relativeDifferentials'`).
- `Genus.tex` — Genus via `Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`.
- `Jacobian.tex` — The Jacobian as an abelian variety
  (`JacobianWitness` carrier; `nonempty_jacobianWitness` glue
  decomposes via `by_cases h : genus C = 0` into M2.b
  `genusZeroWitness` + M3 `positiveGenusWitness`).
- `Rigidity.tex` — Mumford rigidity, scheme-level form
  (Rigidity.lean closed iter-125).
- `RigidityKbar.tex` — Rigidity over `k`: morphisms from a genus-0
  curve to a group scheme are constant. **THIS IS THE LARGEST OPEN
  CHAPTER** — § Piece (i.a) closed iter-128–132, Piece (i.b)
  in-flight iter-134–138+, Pieces (ii)+(iii)+(iv) future scaffolding.

## Stability note for this iter

STRATEGY.md is **substantively unchanged** since iter-136 plan phase,
which absorbed 3 edits (CHALLENGE 1 over-k qualitative-defense framing
tightening + CHALLENGE 2 piece-(ii) `Differential.ContainConstants`
alignment row + gap-inventory extension). Since you have no
iter-by-iter exposure, you are auditing the strategy fresh; if
you re-issue a CHALLENGE on a route that iter-136 absorbed,
the planner will either (a) update STRATEGY.md again, or (b) record
an explicit rebuttal in `iter/iter-137/plan.md` citing the iter-136
absorption.

A stable strategy that you challenged last iter and the planner
already absorbed means the challenge has been responded to — the
planner needs your fresh read to confirm the absorption is sound.

## What we ask of you

Apply your standard checklist verbatim: goal-alignment, mathematical
soundness, alternative routes, sunk-cost reasoning, prerequisite
assumptions, effort estimates. Render per-route verdicts and a
must-fix list.

Pay close attention to:

- **Route 4 (piece (i.b)) sequencing trio** — iter-134 closed Step 1
  (shear iso), iter-136 closed Step 3 (section restriction). Iter-137
  will dispatch on Step 2 (`relativeDifferentialsPresheaf_basechange_along_proj_two`,
  load-bearing NEEDS_MATHLIB_GAP_FILL, ~150–300 LOC). Is the strategy's
  decomposition of (i.b) sound? Does the iter-137 dispatch on Step 2
  vs Main (Compose) match the dependency order the strategy claims?

- **Piece (i.b) → (i.c) handoff** — the strategy claims a chart-
  localisation identification (~100–200 LOC) is pushed from (i.b)
  into (i.c). Is this push-down honest? Does the strategy adequately
  separate (i.b)'s sheaf-level closure from (i.c)'s consumer-side
  identification, or is there a hidden coupling?

- **The qualitative defense of over-k re-framed iter-136**. Ground
  (ii) is honestly named as switching-cost-flavored; ground (iv) is
  scope-narrowed to route-validation. Are these honest framings, or
  are they still smuggling positive evidence the over-k route is
  actually right vs over-`k̄`?

- **The `Differential.ContainConstants` alignment row scheduled iter-139/140**.
  Is this row honest, or does it cover for a deeper issue with the
  piece-(ii) decomposition?

- **The piece (iii) provisional commitment** (~800–1500 LOC scheme-
  level absolute Frobenius). Strategy retains this as committed but
  provisional pending an iter-135–138 mathlib-analogist on the no-
  Frobenius / higher-Kähler-vanishing alternative. Is this provisional
  hedging honest, or is it deferring a decision the strategy should
  make now?

Render your usual report into
`.archon/task_results/strategy-critic-iter137.md`.
