# Lean ↔ Blueprint Check Report

## Slug
snap-iter058

## Iteration
058

## Files audited
- Lean: `AlgebraicJacobian/Picard/SectionGradedRing.lean`
- Blueprint: `blueprint/src/chapters/Picard_SectionGradedRing.tex`

---

## Per-declaration (directive-named first)

### `\lean{AlgebraicGeometry.Scheme.Modules.relTensorActL}` (chapter: `def:relTensorActL`, blueprint line 473)
- **Lean target exists**: yes — `SectionGradedRing.lean:552`
- **Signature matches**: yes — `relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q`, matching the blueprint's "left-action natural transformation from the triple presheaf to the ℤ-tensor presheaf"
- **Proof follows sketch**: yes — blueprint says "Naturality checked on elementary tensors by ⊗-induction"; Lean uses `TensorProduct.ext'` (⊗-induction) with the single key step `PresheafOfModules.map_smul P f s m` at line 577. Mathematical content matches exactly.
- **notes**: axiom-clean; `\leanok` marker set correctly.

---

### `relTensorActR` — **no blueprint block, no `\lean{}` pin**
- **Lean target exists**: yes — `SectionGradedRing.lean:594` (`noncomputable def relTensorActR`)
- **Signature matches**: N/A (no blueprint claim to compare against)
- **Proof follows sketch**: N/A
- **notes**: Substantive declaration — the right-action natural transformation `relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q` (component `actRmap`, `m ⊗ s ⊗ n ↦ m ⊗ (s · n)`). Axiom-clean; naturality proved by the same ⊗-induction + `PresheafOfModules.map_smul Q f s n` pattern as `relTensorActL`. The blueprint has a `def:relTensorActL` block but **no parallel `def:relTensorActR` block**. The declaration also appears in no `\lean{}` pin anywhere in the chapter. **Blueprint coverage gap.**

---

### `relTensorProj` — **no blueprint block, no `\lean{}` pin; one `sorry`**
- **Lean target exists**: yes — `SectionGradedRing.lean:632` (`noncomputable def relTensorProj`)
- **Signature matches**: N/A (no blueprint claim to compare against)
- **Proof follows sketch**: N/A — `naturality` field contains `sorry` at line 658
- **notes**: Substantive declaration — the projection natural transformation `relTensorDomainPresheaf P Q ⟶ (toPresheaf R₀).obj (P ⊗_p Q)` (component `projL`). The sorry is documented at length in the Lean file (lines 639–657): the blocker is a `CommRingCat`-vs-`RingCat` (`forget₂`) carrier mismatch when trying to reconcile the relative-tensor base ring `R(V) = (X.sheaf.obj ⋙ forget₂ CommRingCat RingCat).obj V` used by the presheaf monoidal structure's apex restriction against the `CommRingCat` carrier `X.sheaf.obj.obj V` that `projL` is built over. The `app U` component typechecks (defeq coercion accepted by `ofHom`) but the naturality square requires an explicit `restrictScalars`/`forget₂`-carrier bridge lemma. **Blueprint coverage gap** (no dedicated block or `\lean{}` hint) and **blueprint adequacy gap** (see below).

---

### `objRestrict_id` — private helper, no blueprint block expected
- **Lean target exists**: yes — `SectionGradedRing.lean:461` (`private lemma objRestrict_id`)
- **Signature matches**: N/A — private infrastructure; identity law for `objRestrict P (𝟙 U) = LinearMap.id`
- **Proof follows sketch**: N/A
- **notes**: `private` declaration introduced this iter to resolve the carrier-gap issue for `relTensorActL/R.naturality`. Axiom-clean. Acceptable as an unlisted helper.

---

### `objRestrict_comp` — private helper, no blueprint block expected
- **Lean target exists**: yes — `SectionGradedRing.lean:469` (`private lemma objRestrict_comp`)
- **Signature matches**: N/A — private infrastructure; composition law for `objRestrict P (f ≫ g) = ...`
- **Proof follows sketch**: N/A
- **notes**: Companion to `objRestrict_id`. Axiom-clean. Acceptable as an unlisted helper.

---

## Remaining `\lean{}` blocks (summary)

### Mathlib-backed blocks (`\mathlibok`) — no Lean file check needed
- `PresheafOfModules.monoidalCategory` (line 63) — Mathlib, no obligation.
- `PresheafOfModules.sheafification` (line 86) — Mathlib, no obligation.
- `SheafOfModules.unit` (line 104) — Mathlib, no obligation.
- `TensorProduct.liftAddHom` (line 538) — Mathlib, no obligation.
- `CategoryTheory.Limits.evaluationJointlyReflectsColimits` (line 710) — Mathlib, no obligation.
- `PresheafOfModules.Monoidal.tensorObj_obj` (line 725) — Mathlib, no obligation.
- `DirectSum.GCommSemiring` (line 1142) — Mathlib, no obligation.
- `DirectSum.Gmodule` (line 1157) — Mathlib, no obligation.

### Formalized project blocks (`\leanok`) — pass
- `def:monoidalPresheaf` / `MonoidalPresheaf` — exists (`private abbrev`, line 79), sorry-free. ✓
- `def:schemeModuleSheafification` / `sheafification` — exists (public `def`, line 70), sorry-free. ✓
- `def:unitModule` / `unitModule` — exists (`private abbrev`, line 94), sorry-free. ✓
- `def:sheafTensorObj` / `tensorObj` — exists (public, line 86), sorry-free. ✓
- `def:sheafTensorPow` / `tensorPow` — exists (public, line 100), sorry-free. ✓
- `lem:tensorPow_zero` / `tensorPow_zero` — exists (`private`, line 104), sorry-free. ✓
- `lem:tensorPow_succ` / `tensorPow_succ` — exists (`private`, line 106), sorry-free. ✓
- `def:sheafModuleTwist` / `moduleTensorPow` — exists (public, line 112), sorry-free. ✓
- `lem:moduleTensorPow_zero` / `moduleTensorPow_zero` — exists (`private`, line 115), sorry-free. ✓
- `def:sheafificationCounitIso` / `sheafificationCounitIso` — exists (`private`, line 131), sorry-free. ✓
- `def:tensorObjUnitIso` / `tensorObjUnitIso` — exists (`private`, line 140), sorry-free. ✓
- `def:tensorObjRightUnitor` / `tensorObjRightUnitor` — exists (`private`, line 151), sorry-free. ✓
- `def:tensorBraiding` / `tensorBraiding` — exists (`private`, line 164), sorry-free. ✓
- `lem:isIso_sheafification_map_iff` — exists (public, line 218), sorry-free. ✓
- `lem:localIso_toPresheaf_map_unit` — exists (public, line 243), sorry-free. ✓
- `lem:isIso_sheafification_map_unit` — exists (public, line 255), sorry-free. ✓
- `def:relTensorDomainPresheaf` — exists (public, line 484), sorry-free. ✓
- `def:relTensorTriplePresheaf` — exists (public, line 515), sorry-free. ✓
- `def:sectionMul` / `sectionsMul` — exists (public, line 188), sorry-free. ✓

### Deferred blocks (no `\leanok`, correctly absent from Lean file)
- `lem:snap_ztensor_whisker_localIso` (blueprint line 508) — has `% NOTE: Lean decl name pending`; no Lean declaration. Status correct; the Lean route (stalkwise-iso of ℤ-tensor whiskering) is documented as the approach, with the stalk theory for abelian presheaves still to build.
- `lem:relativeTensor_as_coequalizer` → `relativeTensorCoequalizerIso` (line 630) — absent, no `\leanok`. Correctly deferred pending `relTensorProj.naturality` (the blocker documented in the Lean file).
- `lem:isIso_sheafification_whiskerRight_unit` (line 743) — absent, no `\leanok`. Correctly deferred.
- `cor:sheafTensorObjAssoc` → `tensorObjAssoc` (line 858) — absent, no `\leanok`. Correctly deferred (rides on `isIso_sheafification_whiskerRight_unit`).
- `lem:sheafTensorPow_add` → `tensorPowAdd` (line 937) — absent, no `\leanok`. Correctly deferred (rides on associator).
- `lem:sectionMul_coherent` → `sectionsMul_assoc_unit` (line 1095) — absent, no `\leanok`. Correctly deferred.
- `lem:sectionGradedRing_gcommSemiring` → `AlgebraicGeometry.sectionGradedRing_gcommSemiring` (line 1172) — absent, no `\leanok`. Correctly deferred.
- `lem:sectionGradedModule_gmodule` → `AlgebraicGeometry.sectionGradedModule_gmodule` (line 1231) — absent, no `\leanok`. Correctly deferred.

### `lem:relativeTensor_objectwise_coequalizer` — missing `\leanok` (sync_leanok miss)
- **Lean target exists**: yes — all 21 pinned declarations in `RelativeTensorCoequalizer.*` exist in the Lean file (lines 287–420), all axiom-clean.
- **Signature matches**: yes — the multi-pin block lists every declaration in the namespace; each matches its prose description.
- **Proof follows sketch**: yes — the proof sketch in the blueprint (existence via `TensorProduct.liftAddHom`, uniqueness via epi-cancellation on `piMor`) matches the Lean proof of `isColimitCofork`.
- **notes**: The block has **no `\leanok` marker** despite all 21 pinned declarations being sorry-free. This is a `sync_leanok` miss, likely a multi-pin-block handling gap (the step that looks up each `\lean{...}` declaration may have checked only the first pin `isColimitCofork` and not propagated `\leanok` back to the statement environment). The review agent should note this for the next `sync_leanok` run or add a manual note; it is not an agent-settable marker.

---

## Red flags

### Placeholder / suspect bodies
- `relTensorProj` at line 632: `naturality` field has `:= by ... sorry` at line 658. The sorry is the SOLE sorry in the file. The declaration is **not** claimed as formalized by any blueprint `\leanok` (no `def:relTensorProj` block exists), and the surrounding comment (lines 639–657) thoroughly documents the carrier-transport blocker. Per the checker rules, this is **not** a must-fix violation (no blueprint claim of formalization), but it is the critical path blocker for `relativeTensorCoequalizerIso`.

### Excuse-comments
- Lines 639–713, 716–797, 798–913: Three large block comments in `relTensorProj.naturality` diagnose the blocker in detail. These are diagnostic handoff notes, not "wrong code justified by comment." The code they annotate is explicitly marked `sorry`; there is no false claim of completeness.

### Private declarations with public `\lean{}` pins
- `unitModule`, `tensorPow_zero`, `tensorPow_succ`, `moduleTensorPow_zero`, `sheafificationCounitIso`, `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`, `MonoidalPresheaf` — all declared `private` in the Lean file but pinned by their public fully-qualified names in the blueprint.
- In Lean 4, `private` declarations have mangled internal names; `sync_leanok`'s `lake env lean`-based name lookup will fail for these pins. That `\leanok` is already set on all of them suggests either (a) `sync_leanok` sets `\leanok` from sorry-count rather than name lookup alone, or (b) the markers were set before the `private` keyword was added and have not been re-evaluated since. The mathematical content is correct (all are sorry-free), but the naming creates a potential `sync_leanok` blind spot for future sorry introductions.

### Axioms / Classical.choice
- None found.

---

## Unreferenced declarations (informational)

**Substantive (should appear in blueprint):**
- `relTensorActR` (line 594, `noncomputable def`) — the right-action natural transformation; direct parallel of `relTensorActL` but absent from the blueprint. Should have a `def:relTensorActR` block.
- `relTensorProj` (line 632, `noncomputable def`) — the projection natural transformation; direct companion of `relTensorActL/R` and the final piece of the coequalizer cofork. Should have a `def:relTensorProj` block.

**Private helpers (acceptable):**
- `objRestrict` (line 448) — carrier-aligned restriction map; load-bearing for the `naturality` proofs.
- `objRestrict_apply` (line 456) — simp lemma for `objRestrict`.
- `objRestrict_id`, `objRestrict_comp` (lines 461, 469) — identity/comp laws for `objRestrict`.
- `opensTopology` (line 205) — private abbreviation for the Grothendieck topology; purely local alias.

---

## Blueprint adequacy for this file

- **Coverage**: 20/22 substantive project Lean declarations have a corresponding `\lean{}` block (the 2 missing are `relTensorActR` and `relTensorProj`). 8 Mathlib-backed declarations are correctly flagged `\mathlibok`. Unreferenced declarations: 2 substantive (flagged above) + 5 private helpers (acceptable).

- **Proof-sketch depth**: **under-specified** for one block.
  - `def:relTensorActL` proof sketch ("Naturality checked by ⊗-induction") is adequate — the Lean proof follows it exactly.
  - `lem:relativeTensor_as_coequalizer` step 2 (naturality of `a_L, a_R, π`) says naturality follows from "compatibility of the module action with the restriction maps" — adequate for `relTensorActL/R`, but **silent on the `CommRingCat`-vs-`RingCat` carrier-transport obstacle** that blocks `relTensorProj.naturality`. The blueprint says "naturality of π in U is the compatibility of the module action with the restriction maps of P, O_X, Q: the relative tensor is functorial in U" — this describes the mathematical content but gives no hint that the Lean codomain type `(toPresheaf R₀).obj (P ⊗_p Q)` uses a `RingCat`-carrier apex restriction that doesn't match the `CommRingCat`-carrier `projL` is built over. A prover following the blueprint sketch would not anticipate this obstacle; the Lean file ended up with a documented sorry and a 280-line diagnostic comment.

- **Hint precision**: **loose** for `relTensorActR` and `relTensorProj` (no `\lean{}` hints at all). **Precise** for all pinned declarations that exist.

- **Generality**: matches need — the chapter is scoped to the presheaf-level coequalizer data, which is exactly what the Lean file builds.

- **Recommended chapter-side actions** (for blueprint-writing subagent):
  1. Add `def:relTensorActR` block (parallel to `def:relTensorActL`): right-action transformation `relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q`, component `m ⊗ (s ⊗ n) ↦ m ⊗ (s · n)`; pin `\lean{AlgebraicGeometry.Scheme.Modules.relTensorActR}`; naturality by ⊗-induction + `PresheafOfModules.map_smul Q`.
  2. Add `def:relTensorProj` block: projection transformation `relTensorDomainPresheaf P Q ⟶ (toPresheaf R₀).obj (P ⊗_p Q)`, component the canonical quotient `projL`; pin `\lean{AlgebraicGeometry.Scheme.Modules.relTensorProj}`; add a proof-sketch note that the naturality square requires bridging the `CommRingCat`-carrier `projL` against the `RingCat`-carrier apex restriction of `toPresheaf`, and that the path is a `restrictScalars`/`forget₂` transport lemma (or proving naturality at the `ModuleCat`-presheaf level before forgetting to `Ab`).
  3. Expand `lem:relativeTensor_as_coequalizer` step-2 proof sketch to explicitly call out the carrier-transport requirement for the projection row, naming the `forget₂ CommRingCat RingCat` coercion as the source of friction.
  4. Investigate `lem:relativeTensor_objectwise_coequalizer`'s missing `\leanok` — all 21 pinned declarations are sorry-free; if `sync_leanok` isn't setting it, the issue may be a multi-pin-block handling gap.

---

## Severity summary

| Finding | Severity |
|---|---|
| `relTensorActR` has no blueprint block (`def:relTensorActR` missing) | **major** |
| `relTensorProj` has no blueprint block (`def:relTensorProj` missing) | **major** |
| Blueprint step-2 proof sketch for `lem:relativeTensor_as_coequalizer` is under-specified for the `CommRingCat`-vs-`RingCat` carrier obstacle in `relTensorProj.naturality` | **major** |
| `lem:relativeTensor_objectwise_coequalizer` missing `\leanok` despite all 21 pinned declarations being sorry-free (sync_leanok multi-pin miss) | **major** |
| Private declarations (`unitModule`, `sheafificationCounitIso`, etc.) have public-name `\lean{}` pins — potential sync_leanok blind spot | **minor** |
| `relTensorProj.naturality` has `sorry` (not a must-fix: no `\leanok` claim; documented blocker) | informational |

**Overall verdict**: The Lean file and blueprint are broadly consistent for all 20 formalized declarations; the 8 `\mathlibok` pins are correct; 8 deferred blocks are correctly absent. The two primary gaps are (a) missing blueprint blocks for `relTensorActR` and `relTensorProj` (both axiom-clean resp. sorry-blocked in Lean but invisible to the blueprint), and (b) a `sync_leanok` miss on `lem:relativeTensor_objectwise_coequalizer`. The single sorry in the file (`relTensorProj.naturality`) is thoroughly documented and does not violate any blueprint claim of formalization. — 22 project declarations checked (+ 8 Mathlib-backed), 1 sorry, 4 major findings.
