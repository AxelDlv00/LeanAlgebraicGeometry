# Iter 021 — Objectives detail

## Lane 1 — GF (`Picard/FlatteningStratification.lean`) [prove]
- **Target:** close `exists_localizationAway_finite_mvPolynomial` finiteness leaf @754, then verify the
  `genericFlatnessAlgebraic` B/𝔭 cascade @1810.
- **Gate:** PASSED (blueprint-reviewer iter021 — GF prose adequate; `complete:false` was `\leanok`-only).
- **Recipe:** `analogies/gf-generic-rank-ses.md` §"L4 finiteness leaf … iter-021 close recipe".
  Witness `g := g0·g1` (g0-only is false-typed); single-call clearing via
  `IsIntegral.exists_multiple_integral_of_isLocalization`; finiteness via
  `Algebra.finite_adjoin_of_finite_of_isIntegral`. ν/ψ/b/φ/hsquare scaffolding transfers verbatim g0→g.
- **Success bar:** @754 axiom-clean. Partial: @754 closed even if @1810 needs one more node.
- **Out of scope:** GF-geo @1898.

## Lane 2 — FBC (`Cohomology/FlatBaseChange.lean`) [prove]
- **Target:** prove `base_change_mate_gstar_transpose` @1525 (Seam 3, first attempt at the new live crux).
- **Gate:** PASSED (blueprint-reviewer iter021 — complete+correct, 3-step recipe, deps leanok/mathlibok).
- **Recipe:** blueprint `lem:base_change_mate_gstar_transpose`: counit split via `Adjunction.homEquiv_counit`
  → conjugate by domain_read/codomain_read → identify with `regroupEquiv.inv` on generators.
- **Success bar:** @1525 axiom-clean ⟹ cascades to section_identity/generator_trace/cancelBaseChange.
- **Do NOT:** re-route through the dead `fstar_reindex` apparatus (leave its @1421 dead sorry in place).

## Not dispatched (refactor / gated)
- QUOT — file-split refactor DONE this iter (no prover lane). 4 protected stubs gated on QUOT-defs builds.
- GF-geo, FBC-B, affine reduction — gated on this iter's frontier closes.
