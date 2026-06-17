# Blueprint-reviewer directive — iter-028 (whole-blueprint audit)

Audit the WHOLE blueprint per your standard per-chapter checklist (completeness + correctness + Lean-target
well-formedness + adequate-for-prover detail). Three chapters were substantially edited this iter and feed
live prover lanes the planner intends to dispatch THIS iter — your verdict on these gates their dispatch:

1. `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` — Seam-A routing reconciliation. The chapter now
   states Seam A `inner_value_eq` is realised THROUGH `base_change_mate_fstar_reindex_legs` (leg
   substitution → unit expansion → four-factor Γ-distribution → eCancel telescoping → Seam 1 → ρ), not
   inline at the literal projection legs (which is mathematically obstructed). New single closeable target:
   `lem:base_change_mate_inner_eCancel_assemble`. Confirm the routing narrative is internally consistent
   (no residual "superseded/dead-code" claim that contradicts the live `inner_value_eq → fstar_reindex →
   _legs → inner_eCancel_assemble` chain) and that `inner_eCancel_assemble` is stated precisely enough to
   formalize.
2. `blueprint/src/chapters/Picard_QuotScheme.tex` — G1-core (`lem:qcoh_affine_section_localization`) rewritten
   to **Route F** (module analogue of `isLocalization_basicOpen_of_qcqs`: 3-field `IsLocalizedModule`
   constructor via `compact_open_induction_on` + sheaf gluing — no equalizer, no flat-descent). Plus the new
   G1-assemble subsection (4 bridge nodes) and 12 `\mathlibok` Mathlib anchors. Confirm the Route-F proof is
   complete and correct, that step 1 (finite basic-open tilde cover from `QuasicoherentData`) is the
   identified manual core, and that gap1 (`lem:qcoh_affine_isIso_fromTildeΓ`) correctly feeds G1-core into
   the new reduction node WITHOUT re-pointing its `\lean{}`.
3. `blueprint/src/chapters/Picard_GrassmannianCells.tex` — new "Scheme-level glue-data layer" section (11
   bridge blocks + 4 Mathlib anchors) + expanded `def:gr_glued_scheme` construction paragraph naming
   `Scheme.GlueData` and the t'/t_fac/cocycle field map. Confirm `def:gr_glued_scheme` is now prover-ready.

For each chapter give the explicit `complete: yes/no`, `correct: yes/no`, and any must-fix-this-iter finding.
Per your standard output, also flag any unstarted-phase blueprint proposals and any cross-chapter issues a
whole-blueprint view surfaces. Be concrete about which (if any) of the three chapters above is NOT yet
gate-ready so the planner can defer just that lane.
