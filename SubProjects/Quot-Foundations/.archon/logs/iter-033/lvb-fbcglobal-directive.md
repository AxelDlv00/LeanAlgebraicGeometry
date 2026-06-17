# lean-vs-blueprint-checker — FlatBaseChangeGlobal (iter-033)

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex
(this chapter declares `% archon:covers ... FlatBaseChangeGlobal.lean`)

This is a NEW file this iter (FBC-B lane). It contains 3 declarations:
`Scheme.exists_finite_affineCover_inter_isQuasiCompact`,
`Modules.gammaIsLimitSheafConditionFork`,
`Modules.exists_finite_affineCover_isLimit_sheafConditionFork`.
Check bidirectionally: (a) do the Lean signatures match the blueprint `\lean{}` pins
(lem:finite_affine_cover_qcqs and the H⁰-as-equalizer blocks), are the statements faithful and the
proofs non-placeholder; (b) is the blueprint detailed enough to have guided this formalization, or
are blocks too thin / mis-pinned. Report any unmatched Lean decls (coverage debt).
