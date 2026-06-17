# Lean ↔ Blueprint Checker Directive

## Slug
differentials-review121

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean

## Blueprint chapter
blueprint/src/chapters/Differentials.tex

## Known issues

The Lean file was NOT touched in iter-121 (no prover dispatch this
iter). The blueprint chapter `Differentials.tex` was significantly
rewritten this iter: the iter-121 plan agent edited it inline (LaTeX
syntax fix, broken-ref fixes, new `\sec{Bridge: ...}` section with
the M1 milestone theorem `thm:relativeDifferentialsPresheaf_iso_kaehler_appLE`
plus three auxiliary lemmas), and a blueprint-writer subagent
(`differentials-iter121`) then expanded the M1.b cofinality proof
skeleton and renamed two "out-of-scope" section headings.

Your job is the bidirectional check between the (unchanged) Lean and
the (rewritten) blueprint. The chapter introduces three new
`\lean{...}`-tagged declarations not yet present in the Lean tree:

- `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_iso_kaehler_appLE}`
- `\lean{AlgebraicGeometry.IsAffineOpen.appLE_isLocalization}` (or
  `AlgebraicGeometry.Scheme.appLE_isLocalization` per chapter prose)
- `\lean{AlgebraicGeometry.Scheme.kaehler_localization_subsingleton}`
- `\lean{AlgebraicGeometry.Scheme.kaehler_quotient_localization_iso}`

For these, the expected verdict is **"declaration does not yet
exist"** — the iter-122 plan-phase will dispatch a refactor subagent
to introduce them with `sorry` bodies. Report this as informational
(not a placeholder/red-flag finding), since the chapter is the
forward design and the Lean file is the trailing edge per the
explicit iter-121 deferral.

Pre-known mathlib-analogist findings that are NOT must-fix for THIS
check (they are proposal-stage advisories for iter-122's refactor):

- Naming: `_iso_` should be `_equiv_` (analogist verdict
  ALIGN_WITH_MATHLIB).
- Namespace: `IsAffineOpen.appLE_isLocalization`, not
  `Scheme.appLE_isLocalization`.
- M1.c (`kaehler_localization_subsingleton`) is NOT a Mathlib gap —
  Mathlib already supplies it via `FormallyUnramified.of_isLocalization`
  + `subsingleton_kaehlerDifferential`. Blueprint claim that it is a
  gap is incorrect.
- M1.b cofinality framing: blueprint-writer used `Functor.Final` colim
  comparison; analogist recommended `IsLocalization.of_le` with cocone
  universality instead.

Re-flag any of these only if you find a NEW way they manifest. The
issues are already documented in
`task_results/mathlib-analogist-bridge-iter121.md` and `analogies/relative-differentials-presheaf-bridge.md`.

Focus the bidirectional check on: (a) the **existing** Lean
declarations (`smooth_locally_free_omega`, `relativeDifferentialsPresheaf`,
`relativeDifferentialsPresheaf_obj_kaehler`, etc.) vs. the unchanged
parts of the blueprint, and (b) the chapter's prose vs. the
**existing** Lean — i.e. is the blueprint accurate about what is
already in the file? The new M1 forward-design section is
intentionally pre-Lean; do not score it as a Lean-side defect.
