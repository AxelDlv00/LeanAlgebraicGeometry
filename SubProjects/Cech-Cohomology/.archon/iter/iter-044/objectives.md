# Iter-044 objectives

## Prover lane (1)
- **`AlgebraicJacobian/Cohomology/QcohTildeSections.lean`** [mathlib-build] — close the single residual
  structure-sheaf ring identity that is all that remains of Sub-lemma B `tile_section_comparison`, then
  assemble `tile_section_localization`.
  - Target residual: `(ringCatSheaf.map …).hom (algebraMap R Γ(W,𝒪) r) = ((basicOpenIsoSpecAway g).inv.appIso
    ⊤).inv.hom (algebraMap R_g Γ(⊤,𝒪_{R_g}) (algebraMap R R_g r))`.
  - Closure routes: (A) ΓSpec naturality of `specAwayToSpec g = Spec.map (algebraMap R R_g)`; (B)
    `IsLocalization.Away` uniqueness via `StructureSheaf.IsLocalization.to_basicOpen`.
  - REQUIRED first step: validate the in-file "PROVEN tactic prefix" with `lean_goal`/`lean_multi_attempt`
    (it was never compiled — lean-auditor `iter043`).
  - Blueprint: `chapters/Cohomology_CechHigherDirectImage.tex` — `lem:tile_section_comparison` (refreshed +
    HARD-GATE-CLEARED iter-044), bridges `lem:modulesSpecToSheaf_smul_eq` / `lem:modulesRestrictBasicOpen_smul_eq`.

## Subagents dispatched this phase
- blueprint-writer `tile-residual` → COMPLETE (rewrote tile_section_comparison sketch + added 2 bridge blocks).
- blueprint-clean `tile-residual` → COMPLETE (stripped 2 Lean-leakage comments).
- blueprint-reviewer `iter044` → HARD GATE CLEARS (chapter complete+correct, 0 must-fix).
- progress-critic `routeb` → CHURNING (dispatch=OK); corrective = blueprint expansion, applied this iter.

## Skipped
- strategy-critic (rationale in plan.md — STRATEGY changed only by a factual risk-cell estimate refresh
  within the unchanged route; no live challenge).

## Deferred / next iter
- `qcoh_section_kernel_comparison` → keystone `qcoh_section_isLocalizedModule` → Route B assembly, once the
  tile lemma lands.
- If the ring identity stalls: mathlib-analogist (api-alignment) on `ΓSpecIso`/`globalSectionsIso` + revise
  01I8 `Iters left` (SLIPPING: estimated ~2, elapsed 3).
- Low-priority cleanup: deprecated `Sheaf.val` in the 2 bridge lemmas; dormant `lem:qcoh_localized_sections`.
