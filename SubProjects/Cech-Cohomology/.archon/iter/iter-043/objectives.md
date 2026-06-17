# Iter-043 objectives

## Lane 1 (only) — `QcohTildeSections.lean` — Sub-lemma B + assemble tile lemma [prover-mode: mathlib-build]

**Target:** build **Sub-lemma B `tile_section_comparison`** (the last tile ingredient), then assemble
`tile_section_localization`. Sub-lemma A (`tile_image_opens_identities`) and the base-ring descent are
already DONE — do not rebuild them.

**Sub-lemma B (the genuine cost, ~100–150 LOC):** a natural `R_g`-linear (hence, via `IsScalarTower R R_g`,
`R`-compatible) iso `Γ_{R_g}(V, tile) ≅ Γ_R((specBasicOpen g).ι ''ᵁ V, F)` intertwining restriction maps.
Build from `restrict_obj`/`restrict_map` (rfl ONLY at the local-ring `SheafOfModules` `Γ(M,-)` level) + the
`restrictScalars` bookkeeping of the global-ring functor `modulesSpecToSheaf` via
`StructureSheaf.globalSectionsIso` (verified to exist) for both `R` and `R_g`, then naturality in `V` +
restriction compatibility via Sub-lemma A's opens identities.

**Dead-end (kernel-confirmed iter-042, do NOT repeat):** carriers are NOT the same type (`ModuleCat R_g` vs
`ModuleCat R`); the naive "defeq + rfl scalar coherence" route is unsound. `lean_run_code`/LSP rfl successes
are stale-`.olean` lies — confirm only with `lake env lean`.

**Mode rationale:** `mathlib-build` — no sorry; build Sub-lemma B, then assemble. If Sub-lemma B stalls on a
concrete term-mode wall, leave partial progress + a precise decomposition + the actual error description
(next iter dispatches a mathlib-analogist with that error state). Do NOT paper with a sorry.

**Blueprint:** `chapters/Cohomology_CechHigherDirectImage.tex` — `lem:tile_section_comparison`,
`lem:tile_section_localization` (HARD-GATE-CLEARED, blueprint-reviewer `iter043`). Route:
`analogies/keystone-descent.md`.

## Not dispatched this iter (rationale in plan.md)
- No parallel P5a lane: the only "ready" off-keystone frontier node (`cechAugmented_exact`) is in fact gated
  on 01I8 (corrected its `\uses{}` this iter); the other two named P5a blocks already exist + are proven.
- strategy-critic skipped (STRATEGY substantively unchanged; route twice-validated).
