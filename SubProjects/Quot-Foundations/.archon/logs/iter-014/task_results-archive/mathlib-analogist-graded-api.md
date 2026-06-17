# Mathlib Analogist Report

## Mode
api-alignment

## Slug
graded-api

## Iteration
014

## Question
For the graded-module side of the Stacks 00K1 inductive step
(`AlgebraicGeometry.gradedModule_hilbertSeries_rational`): (1) does Mathlib supply the
graded quotient `M/xM`, graded kernel `K = ker(x⋆)`, regrading over `R/(x)`, and graded
`Module.Finite` transfer; (2) what is the Mathlib-aligned shape; (3) is there a route
that avoids the graded quotient/kernel entirely, using only the degreewise `finrank`
identity?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| D1 graded quotient `M/xM` (Decomposition) | NEEDS_MATHLIB_GAP_FILL | informational |
| D2 graded kernel `K = ker(x⋆)` | NEEDS_MATHLIB_GAP_FILL | informational |
| D3 regrading `C,K` over `R/(x)` | NEEDS_MATHLIB_GAP_FILL | informational |
| D4 graded `Module.Finite` transfer | NEEDS_MATHLIB_GAP_FILL (low effort) | informational |
| D5 degreewise SES / `finrank` identity | PROCEED (pure linear algebra) | informational |
| Q3 avoidance route collapses build? | **NO** | informational |

## Answer to Q1 — what Mathlib has

**Correction to iter-012 (one point):** a homogeneous-submodule scaffold now exists.
- `Submodule.IsHomogeneous ℳ p` — `RingTheory/GradedAlgebra/Homogeneous/Submodule.lean:52`
- `HomogeneousSubmodule 𝒜 ℳ` — `…/Homogeneous/Submodule.lean:64` (bundled; SetLike/PartialOrder/ext only)
- `HomogeneousIdeal := HomogeneousSubmodule 𝒜 𝒜`, `Ideal.IsHomogeneous` — `…/Homogeneous/Ideal.lean:64,71`
- `HomogeneousSubsemiring` — `…/Homogeneous/Subsemiring.lean:38`
- `Ideal.homogeneous_span` (`(x)` is homogeneous) — `…/Homogeneous/Ideal.lean:159`
- `SetLike.IsHomogeneousElem(.graded_smul)` — `Algebra/GradedMulAction.lean:136`
- `LinearMap.finrank_range_add_finrank_ker`; `Submodule.finrank_quotient_add_finrank` — `LinearAlgebra/Dimension/RankNullity.lean:208`
- `Submodule.FG.restrictScalars_of_surjective` — `RingTheory/Finiteness/Ideal.lean:48`
- Converse extraction only: `Polynomial.existsUnique_hilbertPoly`.

**Confirmation to iter-012 (the core gaps):** Mathlib has **none** of the five needed
constructions. No `DirectSum.Decomposition` on a `HomogeneousSubmodule`; **no
`GradedRing`/Decomposition on any quotient ring `A ⧸ I`** (the whole
`RingTheory/GradedAlgebra/` directory has zero `⧸`); no Decomposition on a quotient
module; no graded kernel of a degree-shifting endo; no regrading; no graded
`Module.Finite` transfer; no graded Hilbert series / Hilbert-Serre.

## Answer to Q2 — Mathlib-aligned shape

Mirror `HomogeneousIdeal`/`GradedRing`: express each grading as an **unbundled
`DirectSum.Decomposition` instance** on a family `ℕ → Submodule …`, plus
`SetLike.GradedSMul` for the action. The bundled `HomogeneousSubmodule`/`HomogeneousIdeal`
structures are the right *inputs*; the missing pieces are the induced-grading instances on
the derived objects. Build two reusable, PR-quality lemmas in
`…/Homogeneous/Submodule.lean`:
- **G1** induced grading on a homogeneous submodule (`fun n => p ⊓ ℳ n`),
- **G2** induced grading on the quotient by a homogeneous submodule (`fun n => (ℳ n).map p.mkQ`).
`K` reuses the existing `HomogeneousSubmodule` scaffold (it is one); `C = M/xM` uses G2 with
`xM` homogeneous via `SetLike.IsHomogeneousElem.graded_smul`.

## Answer to Q3 — avoidance route is NOT a build-collapser

The degreewise identity `dim Mₙ₊₁ − dim Mₙ = dim Cₙ₊₁ − dim Kₙ` **is** pure linear
algebra (rank–nullity on `xₙ : Mₙ → Mₙ₊₁`) and needs no graded object — adopt it (D5).
But it only supplies the `hdiff` input of the already-finished `IsRatHilb.ofDiffEq`,
which was never the obstruction. `ofDiffEq` *also* needs `IsRatHilb hC d` and
`IsRatHilb hK d`, whose only source is the inductive hypothesis applied to `C` and `K`;
the IH quantifies over f.g. graded modules over an `(r−1)`-generated ring, so `C`, `K`
must carry `DirectSum.Decomposition` (D1, D2), an `R/(x)`-module structure (D3), and
`Module.Finite` (D4). Free-resolution / graded-dévissage reformulations are strictly
harder (Hilbert syzygy, graded primes — both also absent). So D1–D4 remain required.

## Informational

All five decisions are NEEDS_MATHLIB_GAP_FILL or PROCEED — the gap is genuinely upstream,
not a project misdesign, and the project has **not** shipped a parallel API (the
graded-module side is unbuilt). No ALIGN_WITH_MATHLIB / must-fix items.

Recommended next-iter mathlib-build lane (lowest-risk-first): **G1** (grading on
homogeneous submodule) → **G2** (grading on quotient by homogeneous submodule) → **G5**
(`Module.Finite` via `restrictScalars_of_surjective`) → **G3** (`GradedRing` on `R ⧸ I`,
the heaviest piece; alt: graded-subalgebra + `RestrictScalars`) → **G4** (regrade
`C,K` over `R/(x)`) → assembly into the existing `IsRatHilb` toolkit. The D5 linear-algebra
identity can be landed independently at any point. Full shapes + citations in the
persistent file.

## Persistent file
- `analogies/quot-graded-module-api.md` — ranked findings, per-decision shapes, and the
  G1–G5 build plan captured for the next-iter build lane.

Overall verdict: Mathlib supplies the *homogeneous-submodule scaffold* and all
linear-algebra/finiteness inputs but **none** of the graded quotient/kernel/regrading/
finite-transfer constructions; the avoidance route does not collapse the build (it only
discharges the trivial degreewise identity), so a focused G1–G5 gap-fill is required and
should mirror Mathlib's `HomogeneousIdeal`/`Decomposition` idiom.
