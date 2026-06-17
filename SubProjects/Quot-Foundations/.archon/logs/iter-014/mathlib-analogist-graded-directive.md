# Mathlib-analogist directive — graded-module quotient/kernel/regrading API

## Mode: api-alignment

## Context (project setting)
In `AlgebraicJacobian/Picard/QuotScheme.lean` we are proving graded Hilbert–Serre rationality
(`lem:gradedHilbertSerre_rational`, Lean target `AlgebraicGeometry.gradedModule_hilbertSeries_rational`,
Stacks 00K1). The power-series half is DONE (the `IsRatHilb` toolkit + `IsRatHilb.ofDiffEq`, all
axiom-clean). The remaining obstruction is the GRADED-MODULE side of the Stacks 00K1 inductive step,
which Mathlib does not package. We are about to design+build that API project-side and want the
Mathlib-aligned shape BEFORE writing it (to avoid a parallel API).

## What we need to build (the infrastructure)
Setting: a graded ring `R = ⨁ₙ Rₙ` with `R₀` a field κ, generated in degree 1; a finitely
generated graded `R`-module `M = ⨁ₙ Mₙ` with finite-dimensional components; and `x ∈ R₁`.
We need, as GRADED objects (each carrying `DirectSum.Decomposition`):
1. The graded quotient `M / xM` (cokernel of `x⋆ : M → M(1)`), with its grading.
2. The graded kernel `K = ker(x⋆ : M → M(1))`, with its grading.
3. Regrading: `M/xM` and `K` are annihilated by `x`, hence f.g. graded modules over `R/(x)` — the
   transfer of the graded-module structure along `R ↠ R/(x)`.
4. `Module.Finite` transfer through (1)-(3) as graded objects (so the IH over `R/(x)` applies).
5. The degreewise SES `0 → Kₙ → Mₙ →[x] M_{n+1} → C_{n+1} → 0` of finite-dim κ-vector spaces,
   from which `finrank M_{n+1} − finrank Mₙ = finrank C_{n+1} − finrank Kₙ`.

## What we already know about Mathlib's state (verify + extend)
- `Mathlib/Algebra/Module/GradedModule.lean`: `GradedModule` is NOT a class; the graded-module
  structure is `DirectSum.Decomposition ℳ` + `SetLike.GradedSMul 𝒜 ℳ`.
- The iter-012 prover reported: NO graded quotient `M/xM` carrying a `DirectSum.Decomposition`,
  NO graded kernel of a degree-shifting endo, NO regrading over `R/(x)`, NO `Module.Finite` transfer
  through these as graded objects. Please CONFIRM or CORRECT this against current Mathlib.

## Questions
1. Does Mathlib have ANY of (1)-(5) — graded submodule/quotient API, `DirectSum.Decomposition` on a
   quotient/kernel, regrading along a graded surjection, graded-`Module.Finite` transfer? Give exact
   declaration names if so.
2. What is the Mathlib-aligned SHAPE for these defs (predicate vs structure; reuse
   `HomogeneousSubmodule`/`SetLike.GradedSMul`/`DirectSum.Decomposition`; bundled vs unbundled)?
   Is there a `HomogeneousIdeal`/`HomogeneousSubmodule` analogue we should mirror?
3. Is there a route that AVOIDS the graded quotient/kernel entirely — e.g. working with the ungraded
   `finrank` identity per degree and the existing `Submodule.finrank_quotient_add_finrank`, deriving
   the degreewise SES without ever constructing `M/xM` as a graded object? If such a route exists it
   could collapse the whole sub-build; assess its viability.

Produce `analogies/quot-graded-module-api.md` with the ranked findings + a concrete build plan (or
the avoidance route if viable). This sets up a next-iter mathlib-build lane; precision on shapes and
exact Mathlib names matters more than speed.
