# Blueprint Reviewer Directive

## Slug
iter003

## Scope
Whole blueprint (all chapters under `blueprint/src/chapters/`). Do NOT scope-limit —
the cross-chapter view is the point.

## Context for this review
The project proves a single protected target,
`AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`),
via the acyclic-resolution route (Route A). Phases P1 (`pushPullMap_comp`) and P2
(`CechNerve`) closed in iter-002; the file now has 2 sorries left
(`CechAcyclic.affine` = P3, and the protected target = P5).

This iter the plan agent intends to:
1. **Send a prover at a NEW file `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`**
   (currently does not exist — will be scaffolded this iter from chapter
   `Cohomology_AcyclicResolution.tex`). So the HARD GATE for that chapter is the
   priority of this review: report whether `Cohomology_AcyclicResolution.tex` is
   `complete: true` AND `correct: true`, and flag every must-fix.
2. Decompose P3 (`lem:cech_acyclic_affine` in `Cohomology_CechHigherDirectImage.tex`)
   via the effort-breaker.

## Known live findings to confirm / re-assess (from iter-002)
- **`Cohomology_AcyclicResolution.tex`, `lem:homology_long_exact_sequence`**: the
  `\mathlibok` anchor names only `CategoryTheory.ShortComplex.ShortExact.homology_exact₃`
  (exactness at ONE position) but the block states the FULL long exact sequence
  (exactness at all positions + connecting map δ). The plan agent has VERIFIED that
  Mathlib provides `homology_exact₁`, `homology_exact₂`, `homology_exact₃` and
  `ShortComplex.ShortExact.δ` (all in `Mathlib/Algebra/Homology/HomologySequence.lean`).
  Assess whether this anchor faithfully covers what the chapter's proofs consume.
- **`Cohomology_CechHigherDirectImage.tex`, `lem:push_pull_comp`**: the `\begin{proof}`
  sketch describes a `conjugateEquiv_comp` / "pullback-side injectivity" route that was
  found INFEASIBLE in Lean (kernel `whnf` blow-up). The lemma IS proved, via a different
  route (`pushPullMap_eq_raw` → `rawPushPullMap_comp` which `subst`s the over-triangles,
  then `pushPull_unit_comp` + `pushPull_pentagon`). A `% NOTE:` was added by review.
  Flag that the proof sketch is now misleading and needs rewriting.
- **1-to-1 debt in `Cohomology_CechHigherDirectImage.tex`**: new Lean declarations
  `pushPullFunctor`, `coverCechNerveOver`, `coverCechNerveOverAug`, `cechNerveCosimplicial`
  (and pre-existing helpers `rawPushPullMap`, `rawPushPullMap_comp`, `pushPull_pentagon`,
  `pushPull_unit_comp`) have NO blueprint blocks. Note which deserve explicit `def`/`lem`
  blocks.

## What I need from you
- Per-chapter checklist (complete? correct? proof-sketch depth? Lean targets well-formed?).
- An explicit `complete + correct` (or not) verdict for `Cohomology_AcyclicResolution.tex`
  with every must-fix-this-iter item named — this is the P4 gate.
- Your `## Unstarted-phase blueprint proposals` section if any strategy phase has no
  blueprint coverage.
- Whether any Lean target signature in the blueprint is false-as-stated (especially the
  P3 `lem:cech_acyclic_affine`: its blueprint statement is the standard-cover localisation
  argument, while the Lean signature is `CechAcyclic.affine` over a general `X.OpenCover`
  of an affine `X` with affine `f` — assess whether the blueprint statement faithfully
  supports the Lean signature, or whether there is a standard-cover-vs-general-cover gap).
