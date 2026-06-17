# Blueprint review — iter-049 (whole blueprint)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`) as you always do — per-chapter
completeness + correctness checklist, ill-formed Lean targets, thin proofs, broken `\uses`,
and unstarted-phase coverage gaps.

## Context for this iter (do NOT scope-limit your read — this only tells you what to weight)

The 01I8 route just CLOSED (iter-048: `isIso_fromTildeΓ_of_quasicoherent` landed axiom-clean;
`qcoh_iso_tilde_sections` is now unconditional for quasi-coherent `F`). This unblocks the
downstream Route-A cone. This iter I intend to dispatch provers to BUILD the following
declarations (they do NOT yet exist in Lean — these are build/scaffold objectives, so blueprint
readiness is the gate):

1. `lem:affine_cech_vanishing_qcoh` (`\lean{AlgebraicGeometry.affine_cech_vanishing_qcoh}`,
   chapter `Cohomology_CechHigherDirectImage.tex` ~line 6045) — 02KG seed. Target file:
   `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`.
2. `lem:affine_serre_vanishing` (`\lean{AlgebraicGeometry.affine_serre_vanishing}`, ~line 3206) —
   02KG top. Same file. (Built same lane, after the seed.)
3. `lem:cech_augmented_resolution` (`\lean{AlgebraicGeometry.cechAugmented_exact}`, ~line 6785) —
   P5a augmented-Čech resolution. Target file likely `CechHigherDirectImage.lean` (hosts the
   `CechNerve`/`CechComplex`). The decl does not yet exist anywhere.

For EACH of these three, I need your explicit verdict: is the blueprint block complete + correct
+ detailed enough to formalize (statement faithful to its Stacks source, proof sketch at
formalization depth, every `\uses` dep present and itself done/ready)? Flag any must-fix.

Note the consolidated chapter `Cohomology_CechHigherDirectImage.tex` carries
`% archon:covers` for AffineSerreVanishing.lean, CechHigherDirectImage.lean, QcohTildeSections.lean
and others — its single verdict gates all of them.

## Also flag (minor, already known — confirm or expand)

The iter-048 lean-vs-blueprint check found 3 minor stale-`\uses` imprecisions on
`lem:qcoh_isIso_fromTildeGamma` (lists `lem:isIso_fromTildeGamma_iff_mathlib` and
`lem:forget_reflectsIso_mathlib`, but the Lean proof uses `SpecModulesToSheafFullyFaithful` +
`Functor.IsCoverDense.iso_of_restrict_iso` instead). Note whether these need a writer fix or are
cosmetic.

Write your report to `task_results/blueprint-reviewer-iter049.md`.
