# Iter-041 objectives

## Dispatched (1 prover lane, mathlib-build)

### `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` — two ready keystone-equalizer leaves
- **`qcoh_section_equalizer`** (`lem:qcoh_section_equalizer`) — degree-0/1 sheaf-axiom equalizer
  `0→Γ(W,F)→∏ⱼΓ(W∩D(gⱼ),F)→∏ⱼₖΓ(W∩D(gⱼgₖ),F)` (`Function.Exact` + injectivity) from the sheaf condition
  of `(Spec R).Modules`, stated for a general open `W` + finite covering family. No deps. Template: P3
  `CechAcyclic` section-Čech gluing specialized to degree 0/1.
- **`tile_section_localization`** (`lem:tile_section_localization`) — per element `g`,
  `IsLocalizedModule(powers f)` of `Γ(D(g),F)→Γ(D(gf),F)` via B4 + `section_isLocalizedModule_of_presentation`
  + `restrict_obj`. Localization ON THE TILE (non-circularity hinge). All deps DONE.
- Mode: mathlib-build (no sorry; both decls do not yet exist → scaffold+build).
- HARD GATE: cleared this iter (blueprint-reviewer `keystone-rereview`).

## NOT dispatched (gated / not ready)
- `qcoh_section_kernel_comparison`, keystone `qcoh_section_isLocalizedModule` — `\uses` the two leaves; next iter.
- `qcoh_isIso_fromTildeGamma` (Route B assembly), 02KG tops, P5a, P5b — downstream of the keystone.
- `QcohRestrictBasicOpen.lean` (B-chain leaves DONE, 0 sorries), `TildeExactness.lean` (dormant),
  `CechHigherDirectImage.lean` (frozen P5b), `CechAcyclic.affine` (dead/superseded).

## Subagent dispatches this iter
- blueprint-clean `b3b4` — purify B3/B4 prose fixes.
- mathlib-analogist `keystone-descent` — CONFIRMED keystone circularity; gave the equalizer route
  (`analogies/keystone-descent.md`).
- progress-critic `routeb` — CONVERGING.
- strategy-critic `keystone` — CHALLENGE (keystone descent circular; format DRIFTED). Both addressed.
- blueprint-reviewer `iter041` — HARD GATE must-fix (keystone descent unjustified).
- blueprint-writer `keystone-equalizer` — re-routed keystone to the sheaf-axiom equalizer, +4 sub-lemmas.
- blueprint-clean `keystone` — purify the re-route.
- blueprint-reviewer `keystone-rereview` (scoped fast path) — HARD GATE CLEARS.
