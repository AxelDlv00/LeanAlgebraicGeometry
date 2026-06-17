## Lean file

/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean

## Blueprint chapter

/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Scope

Verify bidirectionally for the two declarations added this iter:
- `AlgebraicGeometry.isIso_fromTildeΓ_of_quasicoherent` — blueprinted as
  `lem:qcoh_isIso_fromTildeGamma` (label at line ~5210, `\lean{}` at ~5213).
- `AlgebraicGeometry.isIso_fromTildeΓ_app_basicOpen` — private helper, now bundled into
  the `\lean{}` of `lem:qcoh_isIso_fromTildeGamma`.

Check: (a) the Lean statement of `isIso_fromTildeΓ_of_quasicoherent` matches the blueprint
lemma statement (quasi-coherent F on Spec R ⟹ IsIso fromTildeΓ); (b) the `\lean{}` pin is
correct; (c) the blueprint proof sketch (check on basis of distinguished opens, reflect through
fully faithful modulesSpecToSheaf, cover-dense basic-open subsite) matches what the Lean proof
actually does; (d) whether the blueprint `\uses{}` for this lemma reflects the real Lean
dependencies (notably the keystone `qcoh_section_isLocalizedModule`). Report any must-fix.
