# Directive — lean-vs-blueprint-checker (iter-064)

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex

## Context (this iter's prover work)
Closed this iter (claimed axiom-clean): `baseChange_bridge_gammaSpec`, `baseChange_bridge_left/right/transition`, `baseChange_bridge`, `bundleTransition_cocycle_transport`, `bundleTransition_cocycle` (C2, `lem:gr_bundleCocycle_mul`), `universalQuotient` (`def:gr_universal_quotient_sheaf`). New unpinned helpers: `tripleOverlapSections`, 3 `pullbackCongr` cast-collapse lemmas, `Scheme.Modules.glueLift`, `tautologicalQuotientComponent`. Remaining sorries: `tautologicalQuotient` (1 inline, overlap condition) and `represents`.

Check bidirectionally: do the closed Lean statements faithfully match their blueprint blocks (esp. `lem:gr_baseChange_bridge*`, `lem:gr_bundleCocycle_transport`, `lem:gr_bundleCocycle_mul`)? Do all `\lean{}` pins resolve? Statement-level `\leanok` on the sorried `def:tautological_quotient`/`thm` blocks is the documented "declaration formalized" semantics — not laundering.
