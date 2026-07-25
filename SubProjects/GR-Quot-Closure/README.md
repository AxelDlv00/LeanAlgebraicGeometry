# AlgebraicJacobian — Grassmannian-quotient representability (GR-quot closure subproject)

<!-- archon:readme -->

## Project

A formalization in Lean 4 + Mathlib of the **representability of the relative Grassmannian**
— the Čech-independent (H⁰) leg that constructs the rank-`d` Grassmannian `Grass(V, d)` of
quotients of a locally free sheaf as a scheme, glued from affine charts via the `GL_d`
cocycle, and proves it represents the rank-`d`-quotient functor.

This project was **extracted** from `Algebraic-Jacobian-Challenge` as one work package in the
decomposition of the dependency cone of `thm:fga_pic_representability`. All Lean names, file
paths and blueprint labels are unchanged from the parent, so proofs merge back cleanly.

**Status: complete and sorry-free** — the deliverable was merged back into
`MainProjects/Algebraic-Jacobian-Challenge` on 2026-06-22. The headline results are
`Grassmannian.represents` (representability of the rank-`d`-quotient functor),
`tautologicalQuotient_epi`, and the SNAP section graded ring / graded module lane, all
axiom-clean. The χ-semantic nodes (`QuotFunctor`, Hilbert polynomial) were removed from this
leg as out of its H⁰ scope — they need the higher-cohomology engine and remain open in the
parent tree.

## References

The shared workspace-root [`references/`](../../references/) library (indexed by
`references/manifest.yaml`) backs the blueprint.

## Structure

- `AlgebraicJacobian/Picard/GrassmannianCells.lean` — affine charts, cocycle, `Grassmannian` scheme, separatedness, properness
- `AlgebraicJacobian/Picard/GlueDescent.lean` — effective descent for `SheafOfModules` over `Scheme.GlueData`
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean` — tautological quotient, `represents`, representability endgame
- `AlgebraicJacobian/Picard/QuotScheme.lean` — QUOT support/localization and quasi-coherent-descent infrastructure
- `AlgebraicJacobian/Picard/SectionGradedRing.lean` — H⁰ section graded ring `Γ_*(X,L)` (SNAP)
- `AlgebraicJacobian/Picard/GradedHilbertSerre.lean` — graded Hilbert–Serre rationality engine
- `AlgebraicJacobian/Picard/RelativeSpec.lean` — relative Spec (existence, universal property, affine base)
- `blueprint/` — leanblueprint source (build with `leanblueprint pdf` and `leanblueprint web`)
- `archon-protected.yaml` — declarations agents must not modify

## How to build

```bash
lake exe cache get   # download Mathlib olean cache
lake build           # compile the project
```
