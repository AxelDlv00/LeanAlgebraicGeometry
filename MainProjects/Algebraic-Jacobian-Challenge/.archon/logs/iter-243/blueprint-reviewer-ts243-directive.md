# blueprint-reviewer directive — iter-243

Audit the WHOLE blueprint (per-chapter completeness + correctness checklist), as usual. Two chapters were
edited this iter and are the gate-critical ones for this iter's prover dispatch — give them your sharpest
read, but do NOT restrict to them (the cross-chapter view is the point):

1. `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` — section `sec:tensorobj_pullback_monoidality`
   was re-routed (Lane A pivot). The general `pullbackTensorIso` (`lem:pullback_tensor_iso`) is now a
   DESCOPED documentary remark with NO `\lean{}` pin (confirmed Mathlib-scale, off every project path). The
   substrate target `lem:isinvertible_pullback` (`IsInvertible.pullback`) now routes through the
   local-trivialization path: new bricks `lem:pullback_tensor_map` (the sheaf-level comparison MAP `δ_sheaf`),
   `lem:isinvertible_implies_locallytrivial` (forward bridge `IsInvertible⇒IsLocallyTrivial`,
   Stacks `lemma-invertible-is-locally-free-rank-1`), plus the two newly-pinned presheaf instances
   `lem:presheaf_pushforward_laxmonoidal` / `lem:presheaf_pullback_oplaxmonoidal`. CHECK: is the
   `lem:isinvertible_pullback` proof sketch now complete + correct + well-formulated for a prover (clear
   recipe for `δ_sheaf`-iso-on-the-invertible-pair via the trivialising cover + `isIso_of_isIso_restrict`);
   are the new `\lean{}` targets well-formed; is the descoped `lem:pullback_tensor_iso` cleanly off-path?

2. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — the two affine-close obligations were extracted
   into named sub-lemma blocks `lem:base_change_map_affine_local` (affine reduction) and
   `lem:pushforward_base_change_mate_cancelBaseChange` (the adjoint-mate↔`cancelBaseChange` crux); plus a new
   `\lean{}` pin `lem:gammaPushforwardNatIso`. CHECK: are the two obligation blocks well-posed and faithful to
   the existing `lem:affine_base_change_pushforward` proof prose they were extracted from.

For each chapter, report `complete:` and `correct:` verdicts and any must-fix-this-iter findings. I will use
your per-chapter verdict as the HARD GATE for dispatching provers to `Picard/TensorObjSubstrate.lean` and
`Cohomology/FlatBaseChange.lean` this iter. Also surface any unstarted-phase blueprint proposals as usual.
