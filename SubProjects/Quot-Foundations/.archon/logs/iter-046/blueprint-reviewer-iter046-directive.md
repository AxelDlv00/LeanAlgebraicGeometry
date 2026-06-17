# Blueprint review — iter-046 (whole blueprint)

Audit the ENTIRE blueprint (`blueprint/src/chapters/*.tex`). Per-chapter checklist
(complete? correct? Lean targets well-formed?) + cross-chapter view.

Focus this iter (do NOT scope-limit — still review all chapters):
- `Picard_QuotScheme.tex` — gates QuotScheme.lean AND GradedHilbertSerre.lean (consolidated `covers:`).
  The active prover lane builds `lem:modules_annihilator_ideal` (`\lean{...Scheme.Modules.annihilator_ideal}`,
  the full annihilator characterization). Verify that block + its deps (`def:modules_annihilator`,
  `lem:modules_annihilator_ideal_le`, `lem:annihilator_localization_eq_map`,
  `lem:qcoh_section_localization_basicOpen`) are complete + correct enough to formalize.
- `Picard_FlatteningStratification.tex` — G1 (`lem:gf_qcoh_fintype_finite_sections`) is about to be
  effort-broken into "locality reduction" (DONE) + "finite-type base case". Flag whether the chapter's
  current G1 block adequately distinguishes them and whether the base-case math is stated.
- Coverage debt: 4 Lean helpers lack blueprint blocks (`keystoneAdjR`, `keystoneBeta` in FlatBaseChange;
  `finite_localizedModule_of_isLocalizedModule`, `gf_finite_sections_of_basicOpen_finite_cover` in
  Flattening). The planner is adding blocks this iter — flag any you still see missing/wrong.

Report per-chapter complete/correct verdicts + any must-fix-this-iter findings + unstarted-phase proposals.
