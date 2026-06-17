# Blueprint Review Directive — iter-050

Perform your standard WHOLE-blueprint audit (read every chapter under
`blueprint/src/chapters/`; the cross-chapter view is the point). Produce your
per-chapter completeness + correctness checklist and the HARD-GATE verdict.

## Context for this iter (not a scope limiter — you still read everything)

The consolidated chapter `Cohomology_CechHigherDirectImage.tex` (it declares
`% archon:covers` for many files including `CechAcyclic.lean`,
`CechHigherDirectImage.lean`, `AffineSerreVanishing.lean`) had its **02KG region
rewritten this iter** (≈ lines 6054–6270). Specifically:

- The `lem:affine_cech_vanishing_qcoh` proof was corrected to the change-of-base
  to `R_f` argument (Stacks 02KG "Write U = Spec(A)" + `lemma-cech-cohomology-
  quasi-coherent-trivial`).
- The residual leaf `lem:affine_cech_vanishing_tilde_subcover` was **pivoted from
  route A (change-of-space sheaf iso) to route B (change-of-ring)**: route-A blocks
  `lem:tilde_section_changeOfBase` and `lem:section_cech_changeOfBase_iso` were
  DELETED; a project-local anchor `lem:away_comparison_isLocalizedModule` was added;
  the residual now pins `\lean{AlgebraicGeometry.sectionCech_homology_exact_of_localizationAway}`
  (a new public theorem to be built in `CechAcyclic.lean`) and its proof was rewritten
  to instantiate the polymorphic `SectionCechModule.dDiff_exact` over `R_f =
  Localization.Away f` and transfer positive-degree exactness back via the degreewise
  `M_{gσ} ≅ (M_f)_{gσ}` AddEquiv ladder.
- New coverage-debt anchor blocks added: `lem:cechCohomology_isZero_of_iso`,
  `lem:affine_cover_span_localizationAway`, `lem:iSup_basicOpen_eq_top_iff_span`
  (Mathlib anchor, `\mathlibok`).

## What the plan agent needs from your verdict

I am about to dispatch provers on TWO files this iter, BOTH covered by
`Cohomology_CechHigherDirectImage.tex`:

1. **`CechAcyclic.lean`** — build the new public theorem
   `sectionCech_homology_exact_of_localizationAway`, pinned by
   `lem:affine_cech_vanishing_tilde_subcover` (the just-rewritten route-B residual).
   I need confirmation this block's statement + proof sketch are complete and correct
   (route-B argument well-formed: polymorphic `dDiff_exact` over `R_f`, the
   `M_{gσ} ≅ (M_f)_{gσ}` ladder, the `gσ ∈ √(f)` invertibility witness, IsZero homology
   wrap), all `\uses{}` resolve to done/present nodes, and the `\lean{}` pin is well-formed.

2. **`CechHigherDirectImage.lean`** — build `cechAugmented_exact`, pinned by
   `lem:cech_augmented_resolution`. This block was NOT edited this iter (it was cleared
   by your iter-049 verdict). Re-confirm it still clears (stalk-at-prime contracting-
   homotopy proof, `\uses{}` intact).

For each, give the explicit `complete:` / `correct:` axes and flag any must-fix-this-iter
items. Also report whether the deleted route-A blocks left any dangling `\uses{}` (the
writer claims `unknown_uses: 0`).

Write your report to `task_results/blueprint-reviewer-iter050.md`.
