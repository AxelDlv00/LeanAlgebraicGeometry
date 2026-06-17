# blueprint-reviewer directive — iter-048 (HARD GATE for the Route-B assembly lane)

You audit the WHOLE blueprint as usual (per-chapter checklist + cross-chapter view). This directive
only names where the planner's attention is this iter so you can confirm the gate.

## Context this iter
iter-047's prover landed the Route-B keystone `qcoh_section_isLocalizedModule` and its corollary
`qcoh_section_kernel_comparison`, both axiom-clean. This iter (iter-048) a `fix-deps` writer round +
clean pass reconciled the blueprint chapter `Cohomology_CechHigherDirectImage.tex` with that Lean:
- authored `lem:isLocalizedModule_of_exact` (abstract left-exact-ladder kernel comparison;
  Archon-original);
- authored `lem:overlap_section_localization` (per-overlap localization; bundles the two bookkeeping
  privates `overlap_target_eq`, `presheaf_map_comp₂_apply`);
- flipped the `\uses` edge so the keystone `\uses lem:isLocalizedModule_of_exact` and the corollary
  `qcoh_section_kernel_comparison \uses lem:qcoh_section_isLocalizedModule` (the prior inversion that
  lean-vs-blueprint-checker `qts` flagged is now corrected);
- moved the equalizer→ladder→kernel chase into the keystone proof; reduced the corollary proof to a
  one-liner.

## What the planner needs from your verdict (the gate)
The next prover lane builds the NEW Lean decl `AlgebraicGeometry.isIso_fromTildeΓ_of_quasicoherent`
(blueprint node `lem:qcoh_isIso_fromTildeGamma`, the frontier-ready Route-B assembly that consumes the
keystone). Confirm specifically whether `Cohomology_CechHigherDirectImage.tex` is **complete +
correct** with **no must-fix-this-iter finding** touching:
- `lem:qcoh_isIso_fromTildeGamma` (the assembly target — is its statement faithful and its proof
  sketch detailed enough to formalize? all 5 `\uses` deps present/done?);
- the reconciled `lem:qcoh_section_isLocalizedModule` / `lem:qcoh_section_kernel_comparison` /
  `lem:isLocalizedModule_of_exact` / `lem:overlap_section_localization` blocks (is the `\uses`
  direction now acyclic and faithful to the Lean? are the new nodes well-formed?).

Report per-chapter as always; the planner reads your checklist to gate the assembly lane.
