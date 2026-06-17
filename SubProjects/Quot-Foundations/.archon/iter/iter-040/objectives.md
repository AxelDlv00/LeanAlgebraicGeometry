# Iter 040 — Objectives

## Dispatched (1 prover lane)

### QUOT gap1 section-transport producer — `Picard/QuotScheme.lean` [mathlib-build]
Build the geometric producer chain bottom-up, axiom-clean, then assemble keystone + gap1.
Blueprint: `chapters/Picard_QuotScheme.tex`, subsection "Section-transport producer for the basic-open Hfr".
- (a) `lem:pullback_composite_immersion_isIso_fromTildeΓ` — composite open immersion `j` + `pullbackComp`
  iso + P1 transport via `isIso_fromTildeΓ_of_iso`. (critical first piece)
- (b) `lem:composite_immersion_range_basicOpen` — `j.opensRange=D(s)`, `j ''ᵁ D(f')=D(f)⊓D(s)`,
  `σ f' = algebraMap R R_s f`.
- (c) `lem:gamma_image_iso_semilinear_top` — upgrade `D(f')`-semilinearity to the ⊤-level σ.
- (d) `lem:flocus_section_scalar_tower` — `A`-module + `IsScalarTower R A` on the f-locus sections.
- TOP `lem:section_localization_hfr_basicOpen` — assemble (a)+(b)+(c)+(d) + DONE engines/combiner ⟹
  basic-open `Hfr`.
- Then (if reached): `lem:section_localization_descent` (instantiate `_of_basicOpen_cover` at the cover)
  ⟹ gap1 `lem:qcoh_affine_isIso_fromTildeΓ`.

## Prepared, NOT dispatched (iter-041)

- **FBC-A1 `_legs_conj`** [fine-grained] — Fallback B (layer-by-layer conjugate transport;
  `analogies/fbc-legs-conj-injective-route.md`; blueprint sketch updated). FINAL in-loop round.

## Plan-cycle subagent outputs (this iter)
- blueprint-writer `quot-producer` — producer decomposition + must-fix re-route + 13 coverage blocks.
- blueprint-writer `gr-coverage` — 6 GR coverage blocks.
- blueprint-reviewer `iter040` — HARD GATE PASS (Picard_QuotScheme).
- progress-critic `iter040` — FBC STUCK / QUOT CONVERGING (OVER_BUDGET).
- strategy-critic `iter040` — FBC CHALLENGE (sequencing) / QUOT,GF,GR SOUND.
- mathlib-analogist `fbc-fork` — ALIGN → Fallback B.
