# refactor directive — slug cleanup070

Two file-local cleanups. NO new proofs; NO declaration renames/re-signs; comment + dead-code edits only.

## Target 1: `AlgebraicJacobian/Cohomology/CechAcyclic.lean` — delete the dead superseded stub

Delete `theorem CechAcyclic.affine` (declared near line 75, body `sorry` at line 110) TOGETHER with
its docstring and the immediately attached multi-paragraph planning-comment block that narrates its
L1/L3 decomposition (the comment block between the section header and the theorem, and the in-body
comment down to the `sorry`). This declaration is superseded by
`AlgebraicGeometry.affine_cech_vanishing_qcoh` (AffineSerreVanishing.lean) and is referenced by NO
code (only by prose comments in other files, which you must NOT touch). Everything else in the file
is LIVE — in particular the entire `CombinatorialCech` supplement (`combDifferential`, `combHomotopy`,
`Dependent.depDiff/depHomotopy/depHomotopy_spec/depDiff_exact`) and all `SectionCech*` material: keep
byte-identical. If a leading doc-comment paragraph mixes live engine documentation with the dead
stub's narrative, trim only the dead-stub narrative.

## Target 2: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean` — stale planning comments

The open-immersion arc is fully closed (0 sorries, axiom-clean). Three stale comment regions
(lean-auditor iter-066) still describe closed work as open:
- ~lines 877–896 and ~956–966: call closed cases "remaining"/"handed off" and misdescribe `hacyc` as
  a Serre-vanishing argument — the shipped proof is the adjoint-preserves-injectives route
  (`restrictAdjunction` → `Injective.injective_of_adjoint` → `IsRightAcyclic.ofInjective`). Rewrite to
  a short, accurate description of the shipped proof.
- ~lines 605–623: an iter-065 historical planning block — delete or compress to ≤3 lines of accurate
  documentation.
Comment-only edits in this file; do not alter any code token.

## Verification (mandatory)

`lake build AlgebraicJacobian` must succeed afterwards (CechAcyclic is imported by
CechSectionIdentification and others — confirm the deletion breaks no import site). Report the
project inline-sorry count change (expected 5 → 4: the deleted stub's `sorry`).
