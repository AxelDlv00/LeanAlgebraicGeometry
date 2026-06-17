# lean-vs-blueprint-checker directive — iter-040, QcohRestrictBasicOpen

Bidirectionally verify ONE Lean file against its blueprint chapter.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

This chapter blueprints the Route B B-chain. The relevant labels for this file's new decls:
- `lem:restrict_over_compat` ↔ `overBasicOpenIsoRestrict` (B3 object iso)
- `lem:presentation_modulesRestrictBasicOpen` ↔ `presentationModulesRestrictBasicOpen` (B4)
- `def:modules_over_basicOpen_equivalence` ↔ `modulesOverBasicOpenEquivalence` (engine, prior iter)

## What to check
1. Lean → blueprint: do the four new decls this iter
   (`overBasicOpenIsoRestrict`, `presentationModulesRestrictBasicOpen`,
   `restrictBasicOpenUnitIso`, `pullbackObjUnitToUnit_isIso_basicOpen`)
   have honest, non-placeholder statements matching the chapter's claims? Signatures match the
   `\lean{}` pins?
2. blueprint → Lean: is the chapter detailed enough to have guided these proofs? Any `\uses{}` that
   under-declares the real dependency (B2 `presentationOverBasicOpen`, the engine, the affine
   restriction)?
3. Are the two new helper decls (`restrictBasicOpenUnitIso`, `pullbackObjUnitToUnit_isIso_basicOpen`)
   covered by a blueprint block or at least folded into a `\uses{}`/`\lean{}`? (They currently show
   as DAG-unmatched.)

Report red flags + adequacy gaps with severity.
