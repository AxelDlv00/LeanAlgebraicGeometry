# Iter-036 objectives

## Dispatched (1 prover lane)

### `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` — [prover-mode: mathlib-build]
- **Target (to-build):** `AlgebraicGeometry.qcoh_section_isLocalizedModule` — the Route B keystone.
  For `X = Spec R`, qcoh `F`, `f ∈ R`: `IsLocalizedModule (Submonoid.powers f) (ρ_f : Γ(X,F)→Γ(D(f),F))`.
- **Blueprint:** `chapters/Cohomology_CechHigherDirectImage.tex`, `lem:qcoh_section_isLocalizedModule`
  (§ Route B). Gate PASS (blueprint-reviewer `routeb`). Route record `analogies/o1i8-route.md`.
- **Recipe:** finite standard cover (`exists_finite_basicOpen_subcover`) → per-`D(gⱼ)` `F|_{D(gⱼ)}≅~Mⱼ`
  via tilde RIGHT-exactness (NOT left-exact sections — circularity) → free-piece section-localization
  (`free_isQuasicoherent`) → span-cover descent (`isLocalizedModule_of_span_cover`); patch sections via
  `sectionCech_affine_vanishing`.
- **Deps (DONE):** `isLocalizedModule_of_span_cover`, `exists_finite_basicOpen_subcover`,
  `free_isQuasicoherent` (this file); `sectionCech_affine_vanishing` (`CechAcyclic.lean`).

## Subagents dispatched this phase
- mathlib-analogist `o1i8-route` (api-alignment) — prior partial run; → Route B (`analogies/o1i8-route.md`).
- progress-critic `iter036` — CHURNING (TildeExactness) / UNCLEAR (QcohRestrictBasicOpen); corrective = pivot.
- blueprint-reviewer `iter036` (stale, pre-rewrite) + `routeb` (fast-path, GATE PASS).
- strategy-critic `iter036` — SOUND; format must-fix (fixed) + soundness clarification (recorded).
- blueprint-writer `route-b` — prior partial run; rewrote chapter to Route B.

## Not dispatched (deliberate)
- `TildeExactness.lean`, `QcohRestrictBasicOpen.lean` — Route P, demoted to dormant fallback.
- 02KG tops, P5a `cech_augmented_resolution` — FALSE-ready, gated on unconditional `qcoh_iso_tilde_sections`.
