# AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Summary
- **Declarations added (3, all axiom-clean):**
  - `AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map` (line ~131) — stalk-local
    iso criterion for `Scheme.Modules` morphisms.
  - `AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis` (line ~157) — basis-local iso
    criterion (iso on sections over a basis of opens ⇒ iso).
  - `AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens` (line ~193) — affine-open
    locality criterion (iso ⟺ iso on every affine open's sections).
- **Wired in:** `affineBaseChange_pushforward_iso`'s first reduction now uses
  `Modules.isIso_iff_isIso_app_affineOpens` (reduces to affine opens, where the tilde
  dictionary lives) instead of the cruder all-opens `Hom.isIso_iff_isIso_app`.
- **Declarations blocked (2, unchanged sorries):** `affineBaseChange_pushforward_iso`,
  `flatBaseChange_pushforward_isIso` — both block on the Mathlib-absent tilde
  pushforward/pullback dictionary (see below).
- **Sorry count (this file): 2 → 2** (the two engine theorems; 3 new axiom-clean lemmas added).
- Full `lake env lean` compile: exit 0, only the two documented `sorry` warnings.
- `#print axioms` for all 3 new lemmas: `{propext, Classical.choice, Quot.sound}`.

## `Modules.isIso_iff_isIso_stalkFunctor_map` (RESOLVED — axiom-clean)
- **Approach:** Forward via `Functor.map_isIso`; backward by packaging the underlying
  `Ab`-presheaves as `TopCat.Sheaf`, applying `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso`,
  then `TopCat.Sheaf.forget … |>.map_isIso` + `toPresheaf` reflects isos
  (`isIso_iff_of_reflects_iso`). Mirrors the second half of the existing
  `Picard/TensorObjSubstrate.lean::isIso_of_isIso_restrict` (which my file cannot import).

## `Modules.isIso_of_isIso_app_of_isBasis` (RESOLVED — axiom-clean)
- **Approach:** Reduce to the stalk criterion above. For each `x`, prove the `Ab`-stalk map
  bijective via `ConcreteCategory.isIso_iff_bijective`:
  - injective ← `TopCat.Presheaf.stalkFunctor_map_injective_of_isBasis` + `bijective_of_isIso`;
  - surjective ← `TopCat.Presheaf.germ_exist_of_isBasis` lifts a germ to a section over a
    basic open, where `α.app` is onto; then `stalkFunctor_map_germ_apply`.
- **Gotcha:** `((toPresheaf X).map φ).app (op U)` is *defeq* (not syntactically equal) to
  `φ.app U`; `M.presheaf` vs `(toPresheaf X).obj M` likewise. The `stalkFunctor_map_germ_apply`
  rewrite needs `erw` (then a trailing `rfl`) to bridge this; plain `rw` fails to match.

## `Modules.isIso_iff_isIso_app_affineOpens` (RESOLVED — axiom-clean)
- **Approach:** `isIso_of_isIso_app_of_isBasis` with `B := Subtype.val : X.affineOpens → X.Opens`;
  the basis hypothesis is `Scheme.isBasis_affineOpens X` modulo `Subtype.range_val`.

## `affineBaseChange_pushforward_iso` (NOT CLOSED — documented sorry, line ~174)
- **Progress:** first reduction upgraded to the affine-open criterion (above). The remaining
  per-affine-open goal `IsIso ((pushforwardBaseChangeMap …).app U)` is unchanged in difficulty.
- **Blocker (precise):** the **tilde pushforward/pullback dictionary** is Mathlib-ABSENT
  (confirmed high-confidence by a 4-agent API sweep this iter + direct read of
  `Mathlib/AlgebraicGeometry/Modules/Tilde.lean`). Needed, ~350–450 LOC:
  1. `pushforward (Spec.map φ)` of a `tilde`-module ≅ `ModuleCat.restrictScalars φ`
     (transport through `tilde.functor` / `moduleSpecΓFunctor` / `SpecModulesToSheafFullyFaithful`).
  2. `pullback (Spec.map φ)` of a `tilde`-module ≅ base change `- ⊗[R] R'`
     (`ModuleCat.extendScalars`; dual via `pullbackPushforwardAdjunction`).
  3. Identify the fibre product `X' = Spec(R' ⊗_R A)` and the section-level base-change map
     with the cancellation iso.
  Once (1)+(2)+(3) exist, the per-affine-open goal closes by
  `TensorProduct.AlgebraTensorModule.cancelBaseChange` (verified present & axiom-clean:
  `(R'⊗[R]A)⊗[A]M ≃ₗ R'⊗[R]M`, `Mathlib/LinearAlgebra/TensorProduct/Tower.lean`).
- **Do NOT retry:** `TopCat.Sheaf.isIso_iff_isIso_basis` — loogle reported it but it is
  ABSENT in the pinned Mathlib (use the stalk route, as done here).

## `flatBaseChange_pushforward_isIso` (NOT CLOSED — documented sorry, line ~207)
- **Blocker:** the affine lemma above PLUS Čech-cohomology / affine-cover infrastructure for
  `SheafOfModules` (Mathlib-absent). Flatness exactness is available
  (`Module.Flat.lTensor_exact` / `rTensor_exact`). Deep, multi-lane; deferred per planner.

## Next step (handoff to planner)
The locality half of `affineBaseChange_pushforward_iso` is now DONE (the 3 lemmas above).
The remaining single blocker is the tilde pushforward/pullback dictionary — a clean
`mathlib-build` sub-lane, ideally its own file (e.g. `Cohomology/TildeDictionary.lean`):
- `pushforward_spec_iso : Scheme.Modules.pushforward (Spec.map φ) ⋙ moduleSpecΓ ≅ … restrictScalars φ`
- `pullback_spec_iso  : Scheme.Modules.pullback (Spec.map φ) of tilde ≅ extendScalars φ`
Then `affineBaseChange_pushforward_iso` closes via `cancelBaseChange`.

## Blueprint
The 3 new lemmas are project-local Mathlib supplements (locality criteria), not currently
in `Cohomology_FlatBaseChange.tex`. They support the `lem:affine_base_change_pushforward`
proof. Suggest the plan agent add a short "locality of isomorphisms" supplement subsection
referencing them (optional — they are infrastructure, not headline blueprint targets).
The two engine theorems remain unproved; their blueprint `\leanok` proof status is handled
by the deterministic `sync_leanok` pass.
