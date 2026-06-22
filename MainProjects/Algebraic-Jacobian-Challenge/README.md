# AlgebraicJacobian

<!-- archon:readme -->

## Project

A formalization in Lean 4 + Mathlib of the **Jacobian of a smooth, proper, geometrically
irreducible curve** over a field. By a smooth curve we mean a geometrically irreducible, smooth
scheme of relative dimension one over a field. The project supplies the missing definitions
(`genus`, `Jacobian`, the Abel–Jacobi map `ofCurve`) and theorems (the Jacobian is smooth of
relative dimension equal to the genus, proper, geometrically irreducible, and is the Albanese
variety of the curve, characterized by the universal property `exists_unique_ofCurve_comp`).
This is an AI challenge inspired by Kevin Buzzard's analogous formalization for Riemann
surfaces.

## References

See [`references/summary.md`](references/summary.md) for a description of each source.

## Structure

- `AlgebraicJacobian/Genus.lean` — definition of `genus`
- `AlgebraicJacobian/Jacobian.lean` — definition of `Jacobian` and its abelian-variety structure
- `AlgebraicJacobian/AbelJacobi.lean` — the Abel–Jacobi map and the universal property
- `AlgebraicJacobian/Cohomology/` — relative cohomology `Rⁱf_*` engine; the Čech
  development (Čech nerve, relative Čech complex, acyclic resolution, and the
  comparison `cech_computes_higherDirectImage`) was merged in from the
  `Cech-Cohomology` subproject (2026-06-18)
- `AlgebraicJacobian/Picard/` — relative Picard substrate (relative Spec, Quot scheme,
  flattening stratification, `Pic⁰`). The **Grassmannian/Quot representability**
  development (`Grassmannian.represents`, the section graded ring/module lane
  `Γ_*(X,L)` through `GCommSemiring`, graded Hilbert–Serre, Grassmannian cell
  charts, glue-descent, and the tautological-quotient epi) was merged in from the
  `GR-quot_closure` subproject (union merge, 2026-06-22; files `GrassmannianCells`,
  `GlueDescent`, `GrassmannianQuot`, `GradedHilbertSerre`, `SectionGradedRing`, all
  sorry-free)
- `blueprint/` — leanblueprint source (build with `leanblueprint pdf` and `leanblueprint web`)
- `references/` — original challenge file and informal sources backing the formalization
- `archon-protected.yaml` — declarations agents must not modify
- `.archon/` — agent state (not committed)

## How to build

```bash
lake exe cache get   # download Mathlib olean cache
lake build           # compile the project
```

## How to run the formalization loop

```bash
archon loop .
```

This launches the plan → prove → review loop and opens a dashboard.
