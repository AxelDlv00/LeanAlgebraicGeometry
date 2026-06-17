# Lean ↔ Blueprint Checker — `Differentials.lean` ↔ `Differentials.tex` (iter-126, Archon canonical)

Per-file bidirectional verification of the post-excise `Differentials`
file pair.

## File pair (one .lean, one .tex)

- **Lean file**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean` (144 lines after the iter-126 M1 excise, down from 572 lines pre-excise). Retained declarations: `relativeDifferentialsPresheaf`, `relativeDifferentialsPresheaf_obj_kaehler`, `kaehler_localization_subsingleton`, `kaehler_quotient_localization_iso` (the M1.d Mathlib-PR candidate), `smooth_locally_free_omega`. The M1 bridge theorem + the M1.b `appLE_isLocalization` helper + 5 support helpers were excised this iter.
- **Blueprint chapter**: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Differentials.tex` (rewritten this iter to reflect the post-excise state; the bridge theorem block, `lem:appLE_isLocalization` block, and `rem:m1_parked_iter125` were all deleted; the section heading and intro paragraph were rewritten).

## What to check

### (A) Lean → blueprint
- The five retained Lean declarations (`relativeDifferentialsPresheaf`,
  `relativeDifferentialsPresheaf_obj_kaehler`,
  `kaehler_localization_subsingleton`,
  `kaehler_quotient_localization_iso`, `smooth_locally_free_omega`)
  should each have an unbroken `\lean{...}` ↔ declaration link in
  the blueprint.
- The post-excise blueprint should NOT name any of the deleted
  declarations (`appLE_unitSubmonoid`, `appLE_colimRingHom`,
  `appLE_colimAlgebra`, `appLE_colimRingHom_comp_φV`,
  `isUnit_appLE_unitSubmonoid_in_colim`, `appLE_isLocalization`,
  `relativeDifferentialsPresheaf_equiv_kaehler_appLE`) in any
  `\lean{...}` macro. Flag any survivors as must-fix.
- The retained `kaehler_quotient_localization_iso` is the M1.d
  Mathlib-PR candidate (per `analogies/relative-differentials-presheaf-bridge.md`);
  the blueprint should describe it as such, not as a load-bearing
  bridge dependency.

### (B) Blueprint → Lean
- Is the blueprint clear that the M1 bridge has been excised, and
  why? The iter-126 plan-phase `refactor-m1-excise-iter126` report
  documented: zero in-tree consumers of the excised declarations
  outside `Differentials.lean` itself, kernel-only axioms on
  retained decls, full `lake build` green post-excise.
- The blueprint should NOT carry forward "parked from iter-125"
  framing for `appLE_isLocalization` (the lemma is gone, not
  parked); flag any stale "parked" prose.
- Verify the `\uses{}` graph on retained blocks does not point at
  deleted labels.

### Out of scope
- The retained declarations all closed in prior iters (iter-120
  closed `smooth_locally_free_omega`; iter-122 introduced the M1.c
  + M1.d helpers; the entire file has zero remaining sorries).

## Output

Write your report to `.archon/task_results/lean-vs-blueprint-checker-differentials-iter126.md`.
Bidirectional findings + severity (must-fix / major / minor) per
your descriptor.
