# Blueprint Review Report

## Slug
iter036

## Iteration
036

## Top-level summaries

### Incomplete parts

- `Cohomology_CechHigherDirectImage.tex` header: `% archon:covers AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` is absent. The chapter contains 3 blueprint blocks for that file (`lem:modules_restrict_basicOpen`, `lem:tilde_restrict_basicOpen`, `lem:presentation_restrict_basicOpen`) and a NOTE at line 4019 explicitly requesting the header. Without it, `sync_leanok` cannot see the file's declarations and the `\leanok` for `lem:modules_restrict_basicOpen` (done, axiom-clean) never propagates.

- `Cohomology_CechHigherDirectImage.tex` / 8 isolated `lean_aux` helpers: `stalkMapₗ`, `stalkMapₗ_eq`, `stalkMapₗ_injective`, `tilde_germ_algebraMap_smul` (TildeExactness.lean, iter-035); `specBasicOpen`, `specAwayToSpec`, `specAwayToSpec_eq` (QcohRestrictBasicOpen.lean, iter-035); plus `AlgebraicGeometry.CechAcyclic.affine` (CechAcyclic.lean, pre-existing, UNPROVED — one of the two `with_sorry` in the leandag summary). None have blueprint entries.

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:tilde_preserves_kernels`, sub-step **(B) Stalkwise isomorphism → isomorphism of sheaves**: The NOTE (lines 4431–4435) says "use the jointly-reflecting stalk family on a sheaf (e.g. `JointlyReflectIsomorphisms` / `Sheaf.forget ⋙ stalkFunctor x` preserving finite limits), via `Scheme.Modules.toPresheaf` (faithful, `ReflectsIsomorphisms`, `PreservesLimits`)." No specific Mathlib lemma names are provided for the jointly-reflecting assembly.

  **Critical update needed:** The planner has confirmed that `SheafOfModules.toSheaf` exists in Mathlib and has `PreservesFiniteLimits` + `ReflectsIsomorphisms`. This is directly relevant to (B): if `SheafOfModules.toSheaf` reflects isomorphisms (Mathlib), then proving `PreservesFiniteLimits (~ ⋙ SheafOfModules.toSheaf)` at the abelian-sheaf level would be a cleaner path than the presheaf route. The current sketch does **not** hardcode "SheafOfModules.toSheaf does not exist" as an obstruction, but it also does not mention this Mathlib availability, leaving the prover to discover it independently. A writer pass is required before the TildeExactness prover can be dispatched cleanly.

  The existing structure is: (A) `tilde_stalkFunctor_map_toStalk` **done** (axiom-clean iter-034); (C) `tildePreservesFiniteLimits_of_toPresheaf` **done** (axiom-clean iter-034, reduces `PreservesFiniteLimits (~)` to `PreservesFiniteLimits (~ ⋙ Scheme.Modules.toPresheaf)`). Remaining: prove `PreservesFiniteLimits (~ ⋙ Scheme.Modules.toPresheaf)` from the stalkwise flatness — the sketch hints at the strategy but does not name the key Mathlib primitives (`Limits.preservesLimitsOfShape_of_evaluation`, `pointwise exactness from flat localization`, or equivalent).

### Dependency & isolation findings

All 8 isolated nodes are `lean_aux` type (uncovered Lean helpers). Dispositions:

**TildeExactness.lean helpers (iter-035, all proved, effort 0):**

- `lean:AlgebraicGeometry.stalkMapₗ` — **wire-up**: add blueprint entry in `lem:tilde_preserves_kernels` block or as a sub-lemma. Expected `\uses{lem:tilde_preserves_kernels}` (realizes sub-step A, the R_p-linear structure of germ map). Also `\uses{def:qcoh_sections_localized}` (tilde stalk = localization identification).
- `lean:AlgebraicGeometry.stalkMapₗ_eq` — **wire-up**: sub-entry of `stalkMapₗ` block or a sibling helper. Expected `\uses{stalkMapₗ entry}`.
- `lean:AlgebraicGeometry.stalkMapₗ_injective` — **wire-up**: realizes `tilde_toStalk_map_injective` (already listed in `lem:tilde_preserves_kernels`'s `\lean{}`). Expected `\uses{stalkMapₗ_eq entry}` and flatness of localization (Mathlib).
- `lean:AlgebraicGeometry.tilde_germ_algebraMap_smul` — **wire-up**: germ `algebraMap`-smul compatibility. Expected `\uses{lem:tilde_preserves_kernels}` (sub-step A bridge).

**QcohRestrictBasicOpen.lean helpers (iter-035, all proved, effort 0):**

- `lean:AlgebraicGeometry.specBasicOpen` — **wire-up**: the open immersion `D(f) → Spec R` as a scheme map. Expected `\uses{def:standard_affine_cover}` (D(f) is the standard basic open).
- `lean:AlgebraicGeometry.specAwayToSpec` — **wire-up**: the Spec-of-localization map `Spec R_f → Spec R`. Expected `\uses{lem:modules_restrict_basicOpen}` (transports modules along this map). Memory `p01i8-p1a-l1-done.md` names `specAwayToSpec_eq` as a feeder for `modulesRestrictBasicOpen`.
- `lean:AlgebraicGeometry.specAwayToSpec_eq` — **wire-up**: `= Spec.map algebraMap`. Expected `\uses{specAwayToSpec entry}` once that gets a blueprint entry.

**CechAcyclic.lean helper (pre-existing, UNPROVED, effort ∞):**

- `lean:AlgebraicGeometry.CechAcyclic.affine` — **investigate before deciding**: this is one of the two `with_sorry` declarations in the build. It is isolated and unproved. If it is dead scaffolding, **remove**; if it is a needed sub-step, **wire-up** with `\uses{lem:cech_acyclic_affine}` (the affine Čech vanishing). Planner should read `AlgebraicJacobian/Cohomology/CechAcyclic.lean` to determine which. Flag to the prover who dispatches CechAcyclic continuation work.

## Per-chapter

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Intentionally thin (1 block: `def:higher_direct_image` with `\leanok`). The `[HasInjectiveResolutions X.Modules]` explicit hypothesis is correctly recorded and matches the Lean decl. The chapter is a pointer to the main chapter; its stub state is by design.

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  1. **Missing `% archon:covers` header for `QcohRestrictBasicOpen.lean`** (must-fix). The file has 3 blueprint blocks and a NOTE at line 4019 requesting the header; it is currently absent from the `% archon:covers` list. Root-barrel import also needed for `sync_leanok` to pick up `lem:modules_restrict_basicOpen`'s `\leanok`.
  2. **8 isolated lean_aux helpers without blueprint entries** (must-fix; see Dependency & isolation findings for full disposition list).
  3. **Stale NOTE on `def:affine_cover_system`** (lines 3725–3736): the iter-034 "MUST-FIX before the qcoh seed lane" note describes a covering-condition bug in `affineCoverSystem.Cov` that was **fixed in iter-035** (confirmed axiom-clean; memory `p02kg-cov-fixed-p1a-open.md`). The prose (correct) and the Lean target (fixed) are aligned. The NOTE should be pruned by the next writer pass — it is factually false as a description of the current Lean state and will confuse provers reading the block.
  4. **`lem:tilde_preserves_kernels` sub-step (B) under-specified** (must-fix for TildeExactness prover dispatch): see "Proofs lacking detail" above. Requires a writer pass to name specific Mathlib lemmas for the jointly-reflecting stalk assembly and/or to incorporate `SheafOfModules.toSheaf.{PreservesFiniteLimits, ReflectsIsomorphisms}` from Mathlib.
  5. **`lem:modules_restrict_basicOpen` NOTE** (line 4014–4020): correctly records the formalization status and requests two planner actions (root import + covers header). The NOTE is accurate and actionable — not stale.
  6. **`lem:toSheaf_preservesFiniteColimits` (line 3511)**: the block correctly states "Mathlib supplies [limit preservation for toSheaf] but not [colimit preservation]." This is consistent with the planner's finding that `SheafOfModules.toSheaf` has `PreservesFiniteLimits` in Mathlib. The block is correct.
  7. **Blueprint-doctor**: clean — no `malformed_refs`, no orphan chapters, no broken `\ref`/`\uses`, no undefined macros.

## Severity summary

### must-fix-this-iter

1. **Missing `% archon:covers AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`** in `Cohomology_CechHigherDirectImage.tex` — blocks sync_leanok from propagating `\leanok` for lem:modules_restrict_basicOpen (axiom-clean iter-035); chapter coverage formally incomplete.
   → Dispatch blueprint-writer: add the `% archon:covers` line to the chapter header.

2. **8 isolated lean_aux helpers** (TildeExactness: `stalkMapₗ`, `stalkMapₗ_eq`, `stalkMapₗ_injective`, `tilde_germ_algebraMap_smul`; QcohRestrictBasicOpen: `specBasicOpen`, `specAwayToSpec`, `specAwayToSpec_eq`; CechAcyclic: `CechAcyclic.affine`) — wire-up (or remove for `CechAcyclic.affine` if dead). TildeExactness and QcohRestrictBasicOpen are active prover lanes; missing edges create out-of-order dispatch risk.
   → Planner: author blueprint entries for the 7 proved helpers using the `\uses{}` parents above; investigate and resolve `CechAcyclic.affine`.

3. **`lem:tilde_preserves_kernels` sub-step (B) under-specified** — the jointly-reflecting stalk assembly does not name Mathlib lemmas and does not reflect the newly-confirmed availability of `SheafOfModules.toSheaf.{PreservesFiniteLimits, ReflectsIsomorphisms}`. TildeExactness is an active prover lane; this blocks clean dispatch.
   → Dispatch blueprint-writer for `Cohomology_CechHigherDirectImage.tex` to tighten sub-step (B): either (a) name specific Mathlib lemmas for the presheaf pointwise-limit route (`Scheme.Modules.toPresheaf` path: `Limits.preservesLimitsOfShape_of_evaluation` / `localization flatness → objectwise exactness → PreservesFiniteLimits of ~ ⋙ Scheme.Modules.toPresheaf`), OR (b) pivot to the sheaf-level route using `SheafOfModules.toSheaf.{PreservesFiniteLimits, ReflectsIsomorphisms}` directly. Either path must be spelled out at the Lean lemma level.

### soon

4. **Stale NOTE on `def:affine_cover_system`** (lines 3725–3736): describes an iter-034 bug that was resolved in iter-035. Factually false description of current Lean state — confusing to provers. Prune it in the next writer pass touching that block.

Overall verdict: `Cohomology_CechHigherDirectImage.tex` is `partial/partial` due to the missing QcohRestrictBasicOpen covers header, 8 uncovered lean_aux helpers (including one unproved orphan), and the under-specified sub-step (B) of `lem:tilde_preserves_kernels`; 3 must-fix findings require a writer pass and planner actions before the TildeExactness prover dispatches. No unstarted phases — all strategy phases have adequate blueprint coverage.
