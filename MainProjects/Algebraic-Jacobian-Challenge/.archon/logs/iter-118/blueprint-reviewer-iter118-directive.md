# Blueprint Reviewer Directive

## Slug
iter118

## Iter
118

## Strategy snapshot (one paragraph)

The project formalizes nine protected declarations (`genus`,
`Jacobian` + 4 instances, `Jacobian.ofCurve` + `comp_ofCurve` +
`exists_unique_ofCurve_comp`) for Christian Merten's challenge. After
the iter-117 aggressive trim the project ships with **exactly two**
inline sorries:

1. `AlgebraicJacobian/Differentials.lean:74` `smooth_iff_locally_free_omega`
   — **iter-118 in-flight refactor**: the iff is mathematically false
   in the converse direction (counterexample: `Spec k → Spec k[t]`
   via `t ↦ 0` is l.f.p., `Ω = 0` locally free of rank 0, but not
   smooth — closed immersion of a non-open point, not flat). Iter-118
   demotes the iff to a forward implication
   (`SmoothOfRelativeDimension n f → ∀ x, ∃ U, Ω(U) free of rank n`).
   Blueprint chapter `Differentials.tex` is being updated to match,
   and to correct two/three [verified]-tagged Mathlib names that
   were wrong (`isSmoothOfRelativeDimension_iff` → `smoothOfRelativeDimension_iff`;
   `IsStandardSmoothOfRelativeDimension.basis_kaehlerDifferential` is
   a non-existent name — replace with the `IsStandardSmooth.free_kaehlerDifferential`
   instance route).
2. `AlgebraicJacobian/Jacobian.lean:179` `nonempty_jacobianWitness`
   — the single foundational existence hypothesis. Closure is
   project-external (Mathlib gap; documented in `Jacobian.tex`).

## Concerns / hot spots (the planner's view)

1. **`Differentials.tex`** — was iter-117-rewritten to track the
   presheaf-form refactor, but the iff statement in the proof block
   reflects a mathematically false equivalence. Iter-118 will refactor.
   Please re-audit AFTER assuming the iter-118 plan agent will have
   the chapter rewritten to forward-only by the end of this iter.
2. **`Jacobian.tex`** — iter-117 `lean-vs-blueprint-checker` flagged
   3 major items: (a) `thm:IsAlbanese_unique` Lean statement is
   strictly weaker than blueprint prose (Lean returns unique morphism;
   prose says unique iso — Lean proof computes the iso but discards
   it); (b) `JacobianWitness` structure has no `\structure` /
   `\def` block; (c) `IsAlbanese.{ofCurve, comp_ofCurve,
   exists_unique_ofCurve_comp}` are unreferenced in blueprint despite
   feeding the protected `AbelJacobi.Jacobian.ofCurve` family.
   Iter-118 will dispatch a blueprint-writer for these.
3. **Off-disk chapters** — `Modules_Monoidal.tex`,
   `Picard_{Functor,FunctorAb,LineBundle}.tex` exist on disk but
   the corresponding `.lean` files were deleted in iter-117. They
   are not currently `\input`-ed from `content.tex`. Please flag
   if they should be deleted from disk in this iter, or whether
   they are fine being out-of-tree historical content.

## Files / paths

- Active blueprint root: `blueprint/src/content.tex` (lists the
  9 actively imported chapters).
- All chapters: `blueprint/src/chapters/*.tex`.
- Active Lean files:
  - `AlgebraicJacobian/Genus.lean`
  - `AlgebraicJacobian/Jacobian.lean`
  - `AlgebraicJacobian/AbelJacobi.lean`
  - `AlgebraicJacobian/Rigidity.lean`
  - `AlgebraicJacobian/Differentials.lean`
  - `AlgebraicJacobian/Cohomology/SheafCompose.lean`
  - `AlgebraicJacobian/Cohomology/StructureSheafAb.lean`
  - `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
  - `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`
  - `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`

## Output

Whole-blueprint audit. Per-chapter `complete: bool` and
`correct: bool` plus must-fix-this-iter items. Hard-gate findings
should be flagged explicitly so the iter-118 plan agent can decide
whether to defer the `Differentials.lean` prover lane.
