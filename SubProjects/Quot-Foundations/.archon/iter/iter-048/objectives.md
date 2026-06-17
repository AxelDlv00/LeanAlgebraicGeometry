# Iter 048 — Objectives

## Prover lane (1)
1. `Picard/SectionGradedRing.lean` [mathlib-build] — build `sectionsMul` (`def:sectionMul`, the
   `Γ(X,𝒪)`-bilinear `Γ(F)⊗Γ(G)→Γ(F⊗G)` via the sheafification unit at the top open); mark the 10 layer-1
   helpers `private`. Associator-independent; `tensorPowAdd`/`sectionMul_coherent` OUT OF SCOPE.

## Blueprint decomposition landed this iter (prover-ready iter-049, pending gate-confirm)
- GF seam-1 → `lem:gf_localGenerators_restrict` (1a), `lem:gf_affine_finite_standard_subcover` (1b, start),
  `lem:gf_finite_gen_iff_free_epi` (1c) + assembled `lem:gf_finiteType_affine_finite_cover_generated`.
- GF free-epi pin: new `lem:gf_qcoh_sections_free_epi` pins `gf_qcoh_finite_sections_of_free_epi`.
- GF G3 `lem:gf_flat_locality_assembly` proof expanded (concrete flat-locality names stripped by clean →
  re-inject as hints at dispatch).
- SNAP `lem:sheafTensorPow_add` rewritten to Analogue-4 bespoke line-bundle local-iso route.

## Deferred (documented)
- GR-quot scaffold → iter-049 (new chapter + file).
- STRATEGY format: 14.8 KB, target ≤12 KB — finish trim iter-049.
- P2 rank-`r`; QUOT annihilator finite-type specialisation (after G1); FBC un-park ≈iter-050.

## Subagents this iter
blueprint-reviewer/iter048, progress-critic/iter048, strategy-critic/iter048, mathlib-analogist/snap-assoc
(read-only); blueprint-writer/gf-fix, blueprint-writer/snap-assoc-bp, blueprint-clean/iter048 (write).
