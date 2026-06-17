# Blueprint-reviewer directive — iter-040 (whole-blueprint audit; HARD GATE for QUOT lane)

Audit the WHOLE blueprint (`blueprint/src/chapters/*.tex`) per your standard per-chapter
completeness + correctness checklist. Do not scope-limit — the cross-chapter view is the point.

## Focus this iter (but review all chapters)
`blueprint/src/chapters/Picard_QuotScheme.tex` received a substantial writer round this iter:
- The `lem:section_localization_descent` proof sketch was RE-ROUTED from the general-U cover form
  (`lem:section_localization_descent_of_cover`) to the new basic-open form
  (`lem:section_localization_descent_of_basicOpen_cover`) — verify the sketch now coherently routes
  through the instantiable form and the `\uses{}` chains (lemma + proof blocks) are consistent.
- A new "section-transport producer" subsection was added: TOP lemma
  `lem:section_localization_hfr_basicOpen` + four sub-lemmas
  `lem:pullback_composite_immersion_isIso_fromTildeΓ`, `lem:composite_immersion_range_basicOpen`,
  `lem:gamma_image_iso_semilinear_top`, `lem:flocus_section_scalar_tower`. Verify each has a well-formed
  statement, an informal proof of finite (non-∞) effort, a `\lean{}` pin (these decls are NOT yet in
  Lean — confirm they're flagged as planned-not-yet-built, not falsely `\leanok`), and an accurate
  `\uses{}` reflecting the dependency on the already-built feeders.
- Three feeder coverage blocks (`lem:section_localization_descent_of_basicOpen_cover`,
  `lem:isLocalizedModule_powers_transport`, `lem:isIso_fromTildeΓ_of_iso`) and five engine coverage
  blocks (`lem:res_comp`, `lem:iSup_basicOpen_subtype_eq_top`, `lem:descent_overlap_agree`,
  `lem:descent_surj`, `lem:descent_smul_eq_zero`) were added — verify they match their Lean signatures.

`blueprint/src/chapters/Picard_GrassmannianCells.tex` received 6 terse coverage blocks
(`lem:gr_det_one_updateCol`, `def:gr_liftToBaseOfMemRange`, `lem:gr_algebraMap_comp_liftToBaseOfMemRange`,
`lem:gr_rotMid`, `lem:gr_transitionInvImageMatrix`, `lem:gr_transitionInvPair`) — sanity-check only.

## HARD GATE question I must answer from your report
Is `Picard_QuotScheme.tex` `complete: true` AND `correct: true` with NO must-fix-this-iter finding? A
`mathlib-build` prover will be dispatched on the section-transport producer (sub-gap (a),
`lem:pullback_composite_immersion_isIso_fromTildeΓ`) THIS iter only if the chapter clears the gate.
Give an explicit per-chapter `complete`/`correct` verdict for at least Picard_QuotScheme and
Picard_GrassmannianCells, plus your usual whole-blueprint findings and any unstarted-phase proposals.
