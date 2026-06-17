# Blueprint-reviewer directive — iter-043 (full-blueprint audit)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`) per your standard per-chapter checklist
(completeness + correctness + Lean-target well-formedness). Do not scope-limit — the cross-chapter view
is the point.

## Project context (one paragraph)
Goal: prove `AlgebraicGeometry.cech_computes_higherDirectImage` (Čech computes higher direct images) and
its cone, axiom-clean. The current critical path is the **01I8 keystone** (`F ≅ ~(ΓF)` on affines, via the
sheaf-axiom equalizer route in `Cohomology_CechHigherDirectImage.tex`). Downstream phases **P5a vanishing
inputs** and **P5b comparison assembly** are not yet started.

## What I most need from you
1. **Re-confirm the HARD GATE on `Cohomology_CechHigherDirectImage.tex`** for the active prover lane — the
   blocks `lem:tile_section_comparison` (Sub-lemma B, the genuine ~100–150 LOC natural section-comparison
   iso, to be built this iter), `lem:tile_section_localization`, and the chain feeding the keystone. Is the
   Sub-lemma B sketch detailed/correct enough to formalize directly?
2. **P5a / P5b readiness.** Phases P5a (vanishing inputs: `lem:cech_augmented_resolution`,
   `lem:cech_free_eval_prepend_homotopy`, the `Hⁿ(f⁻¹V,G)` Ext-bridge, open-immersion/affine vanishing)
   and P5b (the final Route-A comparison assembly of the protected goal) are the next phases after the
   keystone. Use your **`## Unstarted-phase blueprint proposals`** section to report: which of these phases
   have NO adequate blueprint coverage, and a concrete chapter outline for each. I want to know whether a
   parallel scaffold lane on P5a is feasible NEXT iter (i.e. is its blueprint complete + correct enough that
   a prover could create the stub declarations), or whether a blueprint-writer/dag-walker pass is needed
   first.
3. Any other chapter that is `partial | false` and feeds (or will soon feed) a prover lane.

## Notes
- Per-chapter, give the `complete: true|false` / `correct: true|false` verdict and must-fix-this-iter flags.
- The keystone route was re-routed iter-041 (span-cover descent → sheaf-axiom equalizer); the tile sketch
  was rewritten iter-042 (the old `restrict_obj`-rfl recipe was unsound). Both already cleared scoped
  reviews; I want the full-blueprint confirmation plus the unstarted-phase map.
