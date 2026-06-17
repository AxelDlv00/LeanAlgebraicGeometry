# Lean ↔ Blueprint Check Report

## Slug
ts251

## Iteration
251

## Files audited
- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
- Also audited (covered by same chapter): `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`

---

## Per-declaration (D1′ lane focus)

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}` (`lem:pullback_tensor_map_natural`)
- **Lean target exists**: yes — `TensorObjSubstrate.lean:1960`
- **Signature matches**: yes — naturality square `(pullback f).map (tensorObj_functoriality a b) ≫ pullbackTensorMap f M' N' = pullbackTensorMap f M N ≫ tensorObj_functoriality ((pullback f).map a) ((pullback f).map b)` matches the blueprint commutative square exactly.
- **Proof follows sketch**: partial — proof has `:= by simp only [...]; sorry` at line 1983. The `\leanok` in the blueprint is on the **statement block only** (declaration exists), NOT on the proof block. No `\leanok` on the proof block is consistent with this partial state.
- **notes**: The Lean proof comment (L1962–1983) spells out the 4-square paste structure correctly matching the blueprint's description; the sorry is the residual from the 3rd square (`sheafifyTensorUnitIso_hom_natural`).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (`def:scheme_modules_tensorobj`)
- **Lean target exists**: yes — line 151
- **Signature matches**: yes
- **Proof follows sketch**: yes — body is fully defined (sheafification of `PresheafOfModules.Monoidal.tensorObj`), no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (`lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes — line 166
- **Signature matches**: yes
- **Proof follows sketch**: yes — body fully defined, no sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap}` (`lem:pullback_tensor_map`)
- **Lean target exists**: yes — line 1203
- **Signature matches**: yes — `(pullback f).obj (tensorObj M N) ⟶ tensorObj (pullback f).obj M) ((pullback f).obj N)`
- **Proof follows sketch**: yes — four-fold composite as described in blueprint. No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_of_isIso_sheafifyDelta}` (`lem:isiso_pullbacktensormap_of_sheafifydelta`)
- **Lean target exists**: yes — line 1340
- **Signature matches**: yes
- **Proof follows sketch**: yes — axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso}` (`lem:pullback_tensor_iso_unit`, D2′)
- **Lean target exists**: yes — line 1844
- **Signature matches**: yes
- **Proof follows sketch**: yes — chains `isIso_sheafifyEta_of_unitSquare` and `pullbackEtaUnitSquare` exactly as blueprint describes. Axiom-clean (D2′ closed iter-250). ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackEtaUnitSquare}` (`lem:eta_bridge_unit_square`)
- **Lean target exists**: yes — line 1743
- **Signature matches**: yes
- **Proof follows sketch**: yes — axiom-clean (iter-250 close). ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` (`lem:pullback_unit_iso`)
- **Lean target exists**: yes — line 1043
- **Signature matches**: yes
- **Proof follows sketch**: yes — axiom-clean. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (`lem:dual_restrict_iso`)
- **Lean target exists**: yes — `DualInverse.lean:228`
- **Signature matches**: yes — `(dual M).restrict f ≅ dual (M.restrict f)` for open immersion
- **Proof follows sketch**: partial — Steps 1–3 + H1 in place, one `sorry` at the Step-4 presheaf residual `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`. Blueprint `\leanok` on statement block only; no `\leanok` on proof block. Correct status.

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (`lem:dual_isLocallyTrivial`)
- **Lean target exists**: yes — `DualInverse.lean:330`
- **Signature matches**: yes
- **Proof follows sketch**: structurally yes (three-step chain `dual_restrict_iso ≪≫ dualIsoOfIso.symm ≪≫ dual_unit_iso`). The proof itself has no explicit `sorry`, but it depends transitively on `dual_restrict_iso`'s sorry. Blueprint has no `\leanok` on proof block. Correct status.

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (`lem:sheafofmodules_hom_of_local_compat`)
- **Lean target exists**: yes — `DualInverse.lean:411`
- **Signature matches**: yes — open cover gluing of local module morphisms.
- **Proof follows sketch**: sorry (A-bridge unstarted). Blueprint `\leanok` on statement block only. Correct status.

### Blueprint-pinned but NOT in Lean (correctly unformalized — no `\leanok` on statement blocks):

| Blueprint label | `\lean{}` pin | Status |
|----------------|--------------|--------|
| `lem:pullback_tensor_iso` | `pullbackTensorIso` | Off-path (abandoned general route, `% NOTE: ABANDONED` in blueprint). Not in Lean. No `\leanok`. ✓ |
| `lem:pullback0_tensor_iso` | `pullback0TensorIso` | Off-path (abandoned). Not in Lean. No `\leanok`. ✓ |
| `lem:pullback_tensor_map_basechange` | `pullbackTensorMap_restrict` (D3′) | Not started. Not in Lean. No `\leanok`. ✓ |
| `lem:pullback_tensor_iso_loctriv` | `pullbackTensorIsoOfLocallyTrivial` (D4′) | Not started. Not in Lean. No `\leanok`. ✓ |
| `lem:isinvertible_pullback` | `IsInvertible.pullback` | Not started. Not in Lean. No `\leanok`. ✓ |
| `lem:isinvertible_implies_locallytrivial` | `IsInvertible.isLocallyTrivial` | Not started. Not in Lean. No `\leanok`. ✓ |

---

## Red flags

### Stale docstring (module header)

`TensorObjSubstrate.lean:43`: The `## Status (current)` module header says "There is now ONE tracked typed-`sorry` residual: the deferred `⊗`-inverse lane (`exists_tensorObj_inverse`, ~L699)." After iter-251's D1′ additions, the file now has **three** proof `sorry`s (lines 705, 1954, 1983). The header was accurate at iter-250 but was not updated this iter.

This is an internally stale documentation comment, NOT an excuse comment — it describes a previous state without claiming the new sorries don't exist. **Minor.**

### Open sorry in helper `sheafifyTensorUnitIso_hom_natural`

`TensorObjSubstrate.lean:1954`: `sheafifyTensorUnitIso_hom_natural` has a `sorry` with a detailed blocker comment (L1939–1952):

> "RESIDUAL BLOCKER: `whisker_exchange[_assoc]`, `comp_whiskerRight`, `whiskerLeft_comp` all fail to fire (rw/simp) — the goal's `▷`/`◁` come from the file's local `MonoidalCategoryStruct` (forget₂ carrier) whose projections are defeq-but-not-syntactic to `MonoidalCategory.toMonoidalCategoryStruct`'s, so the Mathlib whisker lemmas don't unify."

This declaration is NOT blueprint-pinned (project-local helper), so the sorry is not a blueprint-claim violation. The comment is an accurate technical description, not a misleading excuse. The stated next step ("re-state the whiskers via the canonical instance — a second carrier-normalisation") is sound.

---

## Unreferenced declarations (informational)

The following declarations in `TensorObjSubstrate.lean` have no `\lean{...}` blueprint reference. All are correctly project-local helpers — none have names suggesting they should be top-level blueprint lemmas:

- `pullbackValIso_hom_natural` (line 1879) — CLOSED helper for D1′; naturality of `pullbackValIso` in module argument. Helper for `pullbackTensorMap_natural`. Correct to leave unreferenced.
- `sheafifyTensorUnitIso_hom_eq` (line 1853) — `private`, `:= by rfl`; carrier normalisation bridge stripping the `letI instMS` cast in `sheafifyTensorUnitIso`. Correct as a private helper.
- `sheafifyTensorUnitIso_hom_natural` (line 1914) — partial (one sorry); naturality of `sheafifyTensorUnitIso` (the 4th naturality square of D1′). Correct to leave unreferenced as a project-local helper.
- `sheafifyTensorUnitIso` (line 1061) — private; reconciles `a(P⊗Q)` with `a((aP).val⊗(aQ).val)`. Blueprint mentions it by name in prose but has no `\lean{}` pin.
- `restrictIsoUnitOfLE` (line 384) — helper for `tensorObj_isLocallyTrivial`. Acceptable.
- `tensorObj_middleFour` (line 728) — `private` helper for `IsInvertible.tensorObj`. Acceptable.
- `picMul`, `picInv`, `picSetoid` — sub-components of `PicGroup`/`picCommGroup`; the blueprint `\lean{}` pin on `def:pic_carrier` is `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup, AlgebraicGeometry.Scheme.Modules.picCommGroup}` which covers the main constructor and group instance.
- Various `pullbackObjUnitToUnit_comp`-related helpers (e.g., `isIso_pbu_of_final`, `pullbackObjUnitToUnitIso`) — correctly project-local supplements to `pullbackUnitIso`.

---

## Blueprint adequacy for this file

- **Coverage**: 14/14 blueprint-pinned `\lean{...}` declarations in the chapter (across the main file and DualInverse.lean) have corresponding Lean declarations — either fully proved, partially proved (sorry), or not yet started (no `\leanok`). No `\lean{}` hints reference nonexistent or renamed declarations. All off-path pins are correctly unmarked.

- **Proof-sketch depth for D1′ specifically**: **under-specified**. The proof sketch for `lem:pullback_tensor_map_natural` (lines 3323–3337) describes the 4-square paste correctly but does not mention the carrier-normalisation technique needed for the 4th square (`sheafifyTensorUnitIso` naturality). Specifically:
  - The blueprint says the proof is "the pasting of naturality squares" and that "`sheafifyTensorUnitIso` [is a] natural transformation."
  - The Lean prover discovered that Mathlib whisker lemmas (`whisker_exchange`, `comp_whiskerRight`, `whiskerLeft_comp`) fail to fire on the goal because the `▷`/`◁` projections come from the file-local `MonoidalCategoryStruct (forget₂ carrier)` rather than `MonoidalCategory.toMonoidalCategoryStruct`. This requires a second carrier normalisation rewrite (analogous to the closed `sheafifyTensorUnitIso_hom_eq`) before the whisker calculus can proceed.
  - This Lean-specific obstacle is not described anywhere in the blueprint.

- **Hint precision**: **precise**. All `\lean{...}` names match the declared identifiers exactly. No renamed or nonexistent targets.

- **Generality**: matches need — no parallel API written to cover blueprint gaps.

- **Recommended chapter-side actions**:
  - **Major**: Add a note to the proof of `lem:pullback_tensor_map_natural` (or in a sub-lemma block for `sheafifyTensorUnitIso_hom_natural`) flagging the carrier-normalisation technique. The key point: after calling `sheafifyTensorUnitIso_hom_eq` to rewrite the hom into its two `a.map` whisker factors on the `⋙ forget₂` carrier, the Lean whisker lemmas fire. This is the analogue of the `sheafifyTensorUnitIso_hom_eq` device already used in the `tensorObj_assoc_iso` proof; it is a mechanical fix once the idiom is understood, but the prover needs to know to look for it.

---

## Severity summary

### Minor
- `TensorObjSubstrate.lean:43`: Stale module docstring says "ONE tracked typed-`sorry` residual"; the file now has three proof `sorry`s after iter-251's D1′ additions. Informational; no mathematical content affected.

### Major
- Blueprint proof sketch for `lem:pullback_tensor_map_natural` does not describe the carrier-normalisation step (`sheafifyTensorUnitIso_hom_eq`-style rewrite) needed to make the whisker calculus fire in `sheafifyTensorUnitIso_hom_natural`. The prover was able to structure the proof and identify the exact blocker without this guidance, but the remaining sorry cannot be closed without knowing this technique. A one-sentence note in the blueprint proof (or a new sub-lemma block for `sheafifyTensorUnitIso_hom_natural`) would guide closure.

### No must-fix-this-iter findings.

---

**Overall verdict**: D1′ target `pullbackTensorMap_natural` has the correct signature and `\leanok`-only-on-statement-block status; the two new helpers are correctly project-local. The sole actionable finding is a **major** blueprint under-specification: the carrier-normalisation technique for `sheafifyTensorUnitIso_hom_natural` (the 4th naturality square) is not blueprinted, leaving the prover without guidance to close the remaining sorry. — 14 declarations checked, 1 major (blueprint adequacy), 1 minor (stale docstring).
