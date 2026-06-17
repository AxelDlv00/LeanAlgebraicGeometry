# lean-vs-blueprint-checker directive — QcohRestrictBasicOpen (iter-035)

Verify ONE Lean file against its blueprint chapter, bidirectionally.

## Lean file (absolute path)
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean

## Blueprint chapter (absolute path)
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

The relevant blueprint blocks are (search the chapter):
- `lem:modules_restrict_basicOpen` (`\lean{AlgebraicGeometry.modulesRestrictBasicOpen,
  AlgebraicGeometry.modulesRestrictBasicOpenIso}`) — this iter's two NAMED targets, both now in Lean.
- `lem:tilde_restrict_basicOpen` (`\lean{AlgebraicGeometry.tilde_restrict_basicOpen}`) — NOT in Lean
  (prover left it absent, blocked on absent Mathlib tilde base-change compatibility).
- `lem:presentation_restrict_basicOpen` — also NOT in Lean (blocked transitively).

## What to check
1. Lean → blueprint: do `modulesRestrictBasicOpen` / `modulesRestrictBasicOpenIso` faithfully realize
   the lemma statement (restriction of F to D(f) transported to an O_{Spec R_f}-module + comparison
   iso, functorial)? Any signature mismatch, fake/placeholder, or vacuous statement?
2. blueprint → Lean: is the chapter prose detailed enough to have guided this formalization? Are the
   two unbuilt blocks (`tilde_restrict_basicOpen`, `presentation_restrict_basicOpen`) honestly marked
   as not-yet-formalized (no false `\leanok`/`\mathlibok`)?
3. The helper decls `specBasicOpen`, `specAwayToSpec`, `specAwayToSpec_eq` have NO blueprint block.
   Note this as coverage debt (they are real Lean decls invisible to the DAG).
4. Note that the file has NO `% archon:covers` line pointing the chapter at it (the chapter's covers
   list omits QcohRestrictBasicOpen.lean) — flag as a structural coverage gap if relevant.

Report must-fix-this-iter findings explicitly (they block downstream work).
