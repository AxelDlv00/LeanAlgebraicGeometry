# Directive: blueprint-clean — purify iter-041 B3/B4 planner edits

## Scope
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` only.

## Context
The plan agent edited three blocks this iter to fix a prose/signature mismatch flagged by the
lean-vs-blueprint checker and to clear coverage debt:
- `lem:restrict_over_compat` (B3b) — statement + proof prose rewritten so it describes the ACTUAL
  Lean decl `overBasicOpenIsoRestrict` (the B3b intermediate iso
  `engine.inverse.obj(F.over D(g)) ≅ F.restrict ι`), not the over-claimed full B3c iso.
- `lem:presentation_modulesRestrictBasicOpen` (B4) — `\lean{}` now bundles the two helper decls
  `restrictBasicOpenUnitIso`, `pullbackObjUnitToUnit_isIso_basicOpen` (coverage-debt clearance);
  `\uses` gained `def:modules_over_basicOpen_equivalence`; proof prose rewritten to describe the
  B3c affine transport (`restrictFunctor (basicOpenIsoSpecAway g).inv` + the unit iso).

## Task
Strip any Lean-syntax leakage / project-history verbosity I introduced, keeping the math intact:
- The rewritten B4 proof prose mentions several raw Lean identifiers
  (`restrictFunctorIsoPullback`, `pullbackObjUnitToUnit`, `basicOpenIsoSpecAway`, `restrictFunctor`).
  Where these are named-construction anchors that carry genuine mathematical content, keep a clean
  mathematical phrasing; strip any that are pure Lean-API plumbing not needed to understand the math.
- Verify the B3b statement reads as mathematics (the displayed iso is fine); remove any leftover
  implementation-note phrasing.
- Do NOT touch `\leanok`/`\mathlibok` markers. Do NOT alter `\lean{}`/`\uses{}` targets (the planner
  set them deliberately for DAG coverage). Do NOT touch other blocks (the keystone
  `lem:qcoh_section_isLocalizedModule` block is intentionally unchanged this iter).
- If a `% SOURCE QUOTE` is missing where one is needed, you may insert it (these blocks are
  project-bespoke categorical plumbing, so absence is acceptable; do not fabricate a citation).
