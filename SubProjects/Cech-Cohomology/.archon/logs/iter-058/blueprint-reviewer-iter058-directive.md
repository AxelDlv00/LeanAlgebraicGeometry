# Blueprint-reviewer directive — iter-058

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`), per your standard per-chapter
completeness + correctness checklist. Do not limit scope — the cross-chapter view is the point.

## Context for the HARD GATE (which chapters gate which prover lanes this iter)

This iter's prover lanes (the files I intend to send provers to) and their de-facto chapter
(`Cohomology_CechHigherDirectImage.tex` is the consolidated chapter for all `Cohomology/*.lean`):

1. `AffineSerreVanishing.lean` — Need#2 consumer. Targets the block
   `lem:affine_serre_vanishing_general_open` (its `\lean{}` was repointed off the `_TODO` placeholder
   to `AlgebraicGeometry.affine_serre_vanishing_general_open` this iter) + its supporting
   `lem:affine_cech_vanishing_general_seed` (repointed to the now-built
   `AlgebraicGeometry.sectionCech_homology_exact_of_affineOpen`). Confirm these two blocks are
   complete + correct and ready to formalize against.

2. `CechSectionIdentification.lean` — Sub-brick A Stub 1. This iter an effort-breaker split
   `lem:coproduct_distrib_fibrePower` into `lem:widePullback_overX_eq_prod`,
   `lem:coproduct_distrib_fibrePower_zero`, `lem:prod_coproduct_distrib`,
   `lem:coproduct_fibrePower_reindex`, and a reduced assembly. Confirm the decomposed chain is
   complete + correct so a prover can formalize the small leaves. Also: the Stubs 5/6 blocks
   (`lem:cechSection_complex_iso`, `lem:cechSection_contractible`) — their Lean was re-signed this
   iter to the augmented `D'_aug` target to match the corrected blueprint; verify the blueprint and
   Lean now agree (augmented form).

## Not a prover lane this iter (decomposed-only, no prover)

3. `OpenImmersionPushforward.lean` — Need#1 jShriekOU transport. This iter a blueprint-writer
   decomposed `lem:modules_isoSpec_ext_transport`'s hardest step into 5 build-target sub-lemmas
   (`lem:jshriek_transport_along_iso`, `lem:pushforward_commutes_free`,
   `lem:pushforward_commutes_sheafify`, `lem:yoneda_transport_along_homeo`,
   `lem:pushforward_iso_preserves_qcoh`) + a Mathlib anchor. Assess whether this decomposition is
   complete + correct enough to dispatch a prover NEXT iter; flag any must-fix.

## Coverage debt

13 prover-created helpers were given blueprint entries this iter (CechAcyclic change-of-ring chain,
the `coverArrowOver*` coproduct leaf, the pushforward-transport internals bundled into
`lem:modules_isoSpec_ext_transport`). Confirm coverage is now complete (no unmatched substantive
Lean decls) and the new `\uses{}` edges are accurate.

Report your per-chapter verdict (complete / correct, must-fix items) so I can apply the HARD GATE.
