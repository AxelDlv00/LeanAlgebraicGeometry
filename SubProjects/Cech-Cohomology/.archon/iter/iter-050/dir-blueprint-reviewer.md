# Blueprint-reviewer directive — iter-050 (whole-blueprint audit; gate-clear for the prover lanes)

Audit the whole blueprint per your standard per-chapter checklist. This iter's prover dispatch gates on
your verdict for ONE chapter in particular:

`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (consolidated; `% archon:covers` both
`CechAcyclic.lean` and `CechHigherDirectImage.lean`, among others).

Two regions matter for the gate this iter:
1. **The 02KG residual chain (Route 1, critical path).** Three blueprint-writer passes this iter rewrote
   `lem:affine_cech_vanishing_qcoh` to the change-of-base-to-`R_f` argument and added the residual
   `lem:affine_cech_vanishing_tilde_subcover` (pinned to `sectionCech_homology_exact_of_localizationAway`,
   to be built in `CechAcyclic.lean`), proved by the **route-B change-of-ring** recipe (re-instantiate the
   polymorphic `SectionCechModule.dDiff_exact` over `R_f`, ladder via `AwayComparison`). Plus
   `lem:affine_cover_span_localizationAway`, `lem:cechCohomology_isZero_of_iso`,
   `lem:away_comparison_isLocalizedModule`. Confirm: statements faithful, proofs detailed enough to
   formalize, `\uses{}` complete and resolving, no leftover route-A infra, no `\leanok`-needs.
2. **`lem:cech_augmented_resolution` (Route 2, P5a).** Unchanged this iter (rewritten + cleared iter-049 to
   the stalk-at-prime contracting-homotopy argument). Re-confirm it remains complete + correct so the
   `cechAugmented_exact` prover lane stays gate-cleared.

Report per-chapter `complete`/`correct` verdicts and any must-fix-this-iter findings. The planner will add
`CechAcyclic.lean` (the residual) and `CechHigherDirectImage.lean` (`cechAugmented_exact`) to this iter's
prover objectives ONLY if this chapter clears `complete + correct` with no must-fix touching either region.
