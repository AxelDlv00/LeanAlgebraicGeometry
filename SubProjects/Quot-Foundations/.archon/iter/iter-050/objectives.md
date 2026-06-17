# Iter 050 — Objectives detail

## Lane 1: GF `FlatteningStratification.lean` [mathlib-build] — CRITICAL PATH
Scaffold+build, in order: seam-1a `gf_localGenerators_restrict` (make-or-break) → assembly
`gf_finiteType_affine_finite_cover_generated` → G1 `gf_qcoh_fintype_finite_sections` → G3
`gf_flat_locality_assembly` → close `genericFlatness` @~2435.
- 1a route: transport `σ.π` along `overRestrictPullbackIso` (QuotScheme ~L990) through epi-preserving
  geometric `Scheme.Modules.pullback U.ι` + `restrictFunctorIsoPullback`. DO-NOT-RETRY: pushforward-epi
  (right adjoint), freeFunctorCompPullbackIso w/o Over.map Finality.
- 1b/1c DONE iter-049; assembly is mechanical given 1a.
- G1 needs X.Modules↔Spec transport (gap1 opaque-immersion) + locality half (DONE iter-045).
- G3 anchors: Module.flat_of_localized_maximal, flat_iff_of_isLocalization, Flat.of_free, IsLocalization.flat,
  Flat.trans.

## Lane 2: GR-quot `GrassmannianQuot.lean` (NEW) [mathlib-build] — ACTIVE‖
- Scaffold file + root import (AlgebraicJacobian.lean). Imports: GrassmannianCells + QuotScheme.
- chartQuotientMap (def:gr_chart_quotient) — PROCEED-now, build axiom-clean.
- represents-sig (thm:grassmannian_universal_property) — sorry body.
- Scheme.Modules.glue (def:scheme_modules_glue) — Archon-original; chart-restriction via open-immersion
  pullback equivalence + locality-of-sections descent; attempt as far as possible.
- universalQuotient/tautologicalQuotient/functor — ride on glue, scaffold w/ sorry. Reuse existing
  SheafOfModules.IsLocallyFreeOfRank (QuotScheme.lean:253); do NOT redefine.

## Blueprint state going in
- Picard_FlatteningStratification.tex: PASS (seam-1c prose generalised this iter).
- Picard_GrassmannianQuot.tex: PASS after fast-path (glue construction path added; loc-free duplicate removed).
- Picard_SectionGradedRing.tex: PASS (Analogue-1 re-route; crux + assoc cor added) — for iter-051.

## Deferred
- SNAP tensorPowAdd → iter-051 (Analogue 1, scout coequalizer first).
- 10 private SNAP lean_aux helpers: blueprint-reviewer ruled no action needed.
- QUOT P2/annihilator → after GF-G1 iter (import race).
