# Directive — lean-auditor (iter-064)

## Files to audit
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean (modified this iter; ~190 LOC added, a decl-relocation, 2 sorries remaining at L1973 and L2156)

## Focus
- Honesty of the 2 remaining sorries (documented? laundered?).
- The two `set_option maxHeartbeats 1600000` additions — justified or masking a problem?
- The relocated comparison cluster (namespace re-balancing around L1347–1600) — any duplicate/dead decls left behind.
- New decls: `tripleOverlapSections`, `baseChange_bridge*` family, `bundleTransition_cocycle_transport`, `pullbackFreeIso_inv_congr_hom`/`pullbackCongr_hom_app_free`/`pullbackFreeIso_inv_congr`, `Scheme.Modules.glueLift`, `tautologicalQuotientComponent` — genuine content, no `opaque`/`axiom`/`native_decide`, no vacuous statements.
- Stale comments/docstrings contradicting the current code.
