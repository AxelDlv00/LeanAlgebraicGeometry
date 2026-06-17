# Lean ↔ Blueprint Check Report

## Slug
ts-iter247

## Iteration
247

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (1553 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (~5200 lines)

---

## Per-declaration (all `\lean{...}` pins in this chapter)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)
- **Lean target exists**: yes — `noncomputable def tensorObj` at L138
- **Signature matches**: yes — `(M N : X.Modules) : X.Modules`; body lifts `PresheafOfModules.Monoidal.tensorObj` through `sheafification`, matching blueprint exactly
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` present in blueprint statement. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes — `noncomputable def tensorObj_functoriality` at L153
- **Signature matches**: yes — `(f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N'`
- **Proof follows sketch**: yes — inherits morphism action from `PresheafOfModules.Monoidal.tensorObj` under sheafification
- **notes**: `\leanok` present in both statement and proof blocks. Axiom-clean.

### `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` (chapter: `lem:restrictscalars_laxmonoidal`)
- **Lean target exists**: yes — in `PresheafInternalHom.lean` (imported); blueprint chapter covers TensorObjSubstrate sub-files
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Blueprint says "off critical path"; `\leanok` present in statement and proof.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (chapter: `lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes — `noncomputable def tensorObj_restrict_iso` at L423
- **Signature matches**: yes — `[IsOpenImmersion f] (M N : X.Modules)`, no flatness hypothesis, matches blueprint exactly
- **Proof follows sketch**: yes — 4-step composite (Steps 1-4 as described), H1 via `pushforwardPushforwardAdj` + `leftAdjointUniq`, H2 via `restrictScalarsMonoidalOfBijective`
- **notes**: `\leanok` present. Axiom-clean (iter-217 close, current status confirmed).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (chapter: `lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes — `lemma tensorObj_isLocallyTrivial` at L513
- **Signature matches**: yes — `(hM : LineBundle.IsLocallyTrivial M) (hN : ...)`, returns `LineBundle.IsLocallyTrivial (tensorObj M N)`
- **Proof follows sketch**: yes — picks common affine cover, restricts trivialisations via `restrictIsoUnitOfLE`, chains `tensorObj_restrict_iso` + `tensorObjIsoOfIso` + `tensorObj_unit_iso`
- **notes**: `\leanok` present. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (chapter: `lem:tensorobj_assoc_iso`)
- **Lean target exists**: yes — `noncomputable def tensorObj_assoc_iso` at L318
- **Signature matches**: yes — unconditional `{M N P : X.Modules}`, no locally-trivial hypothesis, matching blueprint's claim
- **Proof follows sketch**: yes — 3-step composite as described: whiskered unit localizer facts (`W_whiskerRight_of_W`, `W_whiskerLeft_of_W`) + sheafification localization (`isIso_sheafification_map_of_W`) + presheaf associator `mapIso`
- **notes**: `\leanok` present in statement. Proof block has a **broken `\uses{..., \leanok lem:islocallyinjective_whiskerleft_via_stalk}`** — see Red Flags §1 below. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, tensorObj_right_unitor}` (chapter: `lem:tensorobj_unit_iso`)
- **Lean target exists**: yes — both `noncomputable def tensorObj_left_unitor` (L269) and `tensorObj_right_unitor` (L279)
- **Signature matches**: yes
- **Proof follows sketch**: yes — cheap `mapIso` pattern as described
- **notes**: Blueprint statement block has **NO `\leanok`** even though both declarations are sorry-free. Likely a `sync_leanok` miss (minor).

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (chapter: `lem:tensorobj_comm_iso`)
- **Lean target exists**: yes — `noncomputable def tensorObj_braiding` at L289
- **Signature matches**: yes — `(M N : X.Modules) : tensorObj M N ≅ tensorObj N M`
- **Proof follows sketch**: yes — `mapIso` on `BraidedCategory.braiding`
- **notes**: `\leanok` in both statement and proof. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: `lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes — `lemma exists_tensorObj_inverse` at L670
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L)`, returns `∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit ...)`
- **Proof follows sketch**: N/A — body is `sorry`; blueprint correctly marks as "Infrastructure-blocked", no `\leanok` in statement
- **notes**: Pre-existing sorry (L692). Blueprint is honest. Two bridges (C: `dual_isLocallyTrivial`, A: descent morphism) remain. No excuse-comment issues.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (chapter: `lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes — but in `RelPicFunctor.lean` (moved iter-247 to break import cycle), not in `TensorObjSubstrate.lean`
- **Signature matches**: yes — same namespace, sorry-free
- **Proof follows sketch**: yes
- **notes**: `\leanok` in statement and proof. The blueprint chapter `archon:covers` list only includes `TensorObjSubstrate.*` files, not `RelPicFunctor.lean`. Technically the declaration moved out of the covered scope, but the Lean name is valid. Minor discrepancy.

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafPushforwardLaxMonoidal}` (chapter: `lem:presheaf_pushforward_laxmonoidal`)
- **Lean target exists**: yes — `noncomputable instance presheafPushforwardLaxMonoidal` at L1101
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` in both. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafPullbackOplaxMonoidal}` (chapter: `lem:presheaf_pullback_oplaxmonoidal`)
- **Lean target exists**: yes — `noncomputable instance presheafPullbackOplaxMonoidal` at L1123
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `\leanok` in both. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap}` (chapter: `lem:pullback_tensor_map`)
- **Lean target exists**: yes — `noncomputable def pullbackTensorMap` at L1190
- **Signature matches**: yes — `(f : Y ⟶ X) (M N : X.Modules)`, map only (no iso claim)
- **Proof follows sketch**: yes — 4-piece composite via `sheafificationCompPullback`, `δ`, `sheafifyTensorUnitIso`, `pullbackValIso` tensorHom
- **notes**: `\leanok` present. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_of_isIso_sheafifyDelta}` (chapter: `lem:isiso_pullbacktensormap_of_sheafifydelta`)
- **Lean target exists**: yes — `lemma isIso_pullbackTensorMap_of_isIso_sheafifyDelta` at L1327
- **Signature matches**: yes — takes `h : IsIso (a_Y.map δ ...)`, concludes `IsIso (pullbackTensorMap f M N)`
- **Proof follows sketch**: yes — identifies 4 factors, 3 unconditionally iso, 1 conditional
- **notes**: `\leanok` in both. Axiom-clean. This is the "reduction brick" for D2'/D4'.

### `\lean{AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp}` (chapter: `lem:unitToPushforwardObjUnit_comp`)
- **Lean target exists**: yes — `lemma unitToPushforwardObjUnit_comp` at L846
- **Signature matches**: yes
- **Proof follows sketch**: yes — sectionwise `rfl` after `ext`-chain
- **notes**: `\leanok` in both. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` (chapter: `lem:pullbackObjUnitToUnit_comp`)
- **Lean target exists**: yes — `lemma pullbackObjUnitToUnit_comp` at L887
- **Signature matches**: yes — adjunction-mate transport of the pushforward-side coherence
- **Proof follows sketch**: yes — uses `conjugateEquiv_pullbackComp_inv`, `unit_conjugateEquiv`, etc.
- **notes**: `\leanok` in both. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` (chapter: `lem:pullback_unit_iso`)
- **Lean target exists**: yes — `noncomputable def pullbackUnitIso` at L1030
- **Signature matches**: yes — `(f : Y ⟶ X) : (Scheme.Modules.pullback f).obj (SheafOfModules.unit X.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf`
- **Proof follows sketch**: yes — `Opens.map f.base` always `Final` via `final_of_representablyFlat`, so `pullbackObjUnitToUnit` is unconditionally iso
- **notes**: `\leanok` in both. Axiom-clean. The iter-241 resolution (chart-chase not needed) matches the blueprint's prose note.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}` (chapter: `lem:pullback_tensor_map_natural`, D1')
- **Lean target exists**: **NO** — `pullbackTensorMap_natural` does not exist in the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: D1' forward target. Blueprint has **no `\leanok`** in statement — honest representation. `\lean{...}` pin names the intended future declaration.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso}` (chapter: `lem:pullback_tensor_iso_unit`, D2')
- **Lean target exists**: **NO** — `pullbackTensorMap_unit_isIso` does not exist in the Lean file. The closest Lean declarations are the **conditional** lemmas `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` (L1428) and `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` (L1379), both axiom-clean but conditioned on the η-bridge hypothesis.
- **Signature matches**: partial — the blueprint pins the unconditional version; the Lean has a conditional version with hypothesis `h : IsIso (a_Y.map (η (pullback φ')))`
- **Proof follows sketch**: partial — the blueprint proof narrative correctly describes the δ-wrapping → η-bridge route and the square equation that closes the η-bridge; the Lean has formalized the δ-wrapping half and the IsIso-plumbing half, but NOT the square equation itself
- **notes**: D2' NOT yet closed. Blueprint has **no `\leanok`** in statement — correctly represents the open status. The two new iter-247 declarations (`presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`) are the project-local supplements toward D2'.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` (chapter: `lem:pullback_tensor_map_basechange`, D3')
- **Lean target exists**: **NO** — does not exist in Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: D3' forward target. Blueprint has **no `\leanok`** — honest. `\lean{...}` pin names the intended future declaration.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorIsoOfLocallyTrivial}` (chapter: `lem:pullback_tensor_iso_loctriv`, D4')
- **Lean target exists**: **NO** — does not exist in Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: D4' forward target. Blueprint has **no `\leanok`** — honest. `\lean{...}` pin names the intended future declaration.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso_invertible}` (chapter: `lem:tensorobj_assoc_iso_invertible`)
- **Lean target exists**: yes — `noncomputable def tensorObj_assoc_iso_invertible` at L706
- **Signature matches**: yes — `(_hM : IsInvertible M) (_hN : ...) (_hP : ...)`, returns the associator iso (hypotheses unused, delegating to unconditional `tensorObj_assoc_iso`)
- **Proof follows sketch**: yes — one-liner `tensorObj_assoc_iso`
- **notes**: `\leanok` in statement and proof. The proof blocks for `IsInvertible.tensorObj` and `IsInvertible.inverse_unique` that USE this label have broken `\uses{..., \leanok lem:tensorobj_assoc_iso_invertible, ...}` — see Red Flags §2 and §3 below. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup}` (chapter: `def:pic_carrier`)
- **Lean target exists**: yes — `def PicGroup` at L764
- **Signature matches**: yes — `(X : Scheme.{u}) : Type _`
- **notes**: `\leanok` in statement. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.picCommGroup}` (chapter: `thm:pic_commgroup`)
- **Lean target exists**: yes — `noncomputable instance picCommGroup` at L798
- **Signature matches**: yes — `(X : Scheme.{u}) : CommGroup (PicGroup X)`
- **Proof follows sketch**: yes — each group axiom fed a single existence-of-isomorphism, no coherence
- **notes**: `\leanok` in statement. Axiom-clean. The `\uses{..., lem:tensorobj_assoc_iso_invertible}` correctly lists that label, BUT the same proof blocks have the `\uses{\leanok ...}` syntax errors (see Red Flags §2 and §3) that create spurious graph gaps.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict}` (chapter: `lem:isiso_of_isiso_restrict`)
- **Lean target exists**: yes — `lemma isIso_of_isIso_restrict` at L544
- **Signature matches**: yes
- **notes**: `\leanok` in blueprint. Axiom-clean.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackLanDecomposition}` (chapter: `lem:pullback_lan_decomposition`, D1 off-path)
- **Lean target exists**: yes — `noncomputable def pullbackLanDecomposition` at L1283
- **Signature matches**: yes
- **notes**: Correctly marked as off-path. `\leanok` in statement. Axiom-clean.

---

## Red Flags

### Blueprint syntax errors: `\leanok` inside `\uses{}` braces — three cases

#### §1. `lem:tensorobj_assoc_iso` proof block (line ~1464)
```latex
\begin{proof}
  \uses{def:scheme_modules_tensorobj,
  \leanok
        lem:islocallyinjective_whiskerleft_via_stalk}
```
The `\leanok` command is accidentally placed INSIDE the `\uses{...}` braces, causing the blueprint dependency parser to treat the string `\leanok\n        lem:islocallyinjective_whiskerleft_via_stalk` as a single (invalid) label. Blueprint-doctor correctly flags this.

**Intended targets**: `def:scheme_modules_tensorobj`, `lem:islocallyinjective_whiskerleft_via_stalk`
- `lem:islocallyinjective_whiskerleft_via_stalk` IS a valid label (defined at line ~2223)
- Fix: move `\leanok` OUTSIDE the `\uses{}` block to a separate line

#### §2. `IsInvertible.tensorObj` proof block (line ~3862)
```latex
\begin{proof}
  \uses{def:scheme_modules_isinvertible, lem:tensorobj_assoc_iso_invertible,
  \leanok
        lem:tensorobj_comm_iso, lem:tensorobj_unit_iso}
```
Same error: `\leanok\n        lem:tensorobj_comm_iso` is treated as a single invalid label.

**Intended targets**: `def:scheme_modules_isinvertible`, `lem:tensorobj_assoc_iso_invertible`, `lem:tensorobj_comm_iso`, `lem:tensorobj_unit_iso`
- `lem:tensorobj_comm_iso` IS a valid label (defined at line ~1593)
- Fix: move `\leanok` outside `\uses{}` braces

#### §3. `IsInvertible.inverse_unique` proof block (line ~3970)
```latex
\begin{proof}
  \uses{def:scheme_modules_isinvertible, lem:tensorobj_unit_iso,
  \leanok
        lem:tensorobj_assoc_iso_invertible, lem:tensorobj_comm_iso}
```
Same error: `\leanok\n        lem:tensorobj_assoc_iso_invertible` is treated as a single invalid label.

**Intended targets**: `def:scheme_modules_isinvertible`, `lem:tensorobj_unit_iso`, `lem:tensorobj_assoc_iso_invertible`, `lem:tensorobj_comm_iso`
- `lem:tensorobj_assoc_iso_invertible` IS a valid label (defined at line ~3747)
- Fix: move `\leanok` outside `\uses{}` braces

**All three are LaTeX syntax bugs in proof environments — the underlying labels are valid; the links are simply broken by the misplaced `\leanok` command.**

---

## Unreferenced declarations (informational)

The following declarations are in the Lean file but have NO `\lean{...}` pin in the blueprint chapter. Most are helpers or project-local supplements. The two new iter-247 declarations are notable:

### Notable unreferenced (candidate for blueprint pins or notes):
1. **`presheafUnit_comp_map_eta`** (L1495) — axiom-clean, iter-247 new. Presheaf-side mate identity `adj.unit.app 𝟙_ ≫ pushforward.map(η F) = LaxMonoidal.ε(pushforward φ')`. This is the "driver" that certifies `presheafPullbackOplaxMonoidal`/`presheafPushforwardLaxMonoidal` are `Adjunction.IsMonoidal`-compatible. The blueprint's D2' proof narrative describes the need for this identity (it is the pushforward-side analog of `pullbackObjUnitToUnit_comp` mentioned there) but does not yet have a corresponding `\lean{...}` block.
2. **`isIso_sheafifyEta_of_unitSquare`** (L1518) — axiom-clean, iter-247 new. Given the commuting square `(pullbackValIso f 𝒪_X).inv ≫ a_Y.map(η F) ≫ sheafifyUnitIso.hom = pullbackObjUnitToUnit f.toRingCatSheafHom`, the η-bridge `IsIso(a_Y.map(η F))` follows. This is exactly the "IsIso plumbing" step described in the blueprint's D2' proof (last paragraph, lines ~3364-3370). No `\lean{...}` pin exists.

### Helpers (expected unreferenced):
- `restrictIsoUnitOfLE` (L371), `dualIsoOfIso` (L205), `tensorObjIsoOfIso` (L240), `tensorObj_unit_iso` (L256), `homMk` (L585), `toPresheaf_map_homMk` (L593): helper utilities, no blueprint pin required
- `tensorObj_middleFour` (L715): `private` helper, correctly unreferenced
- `picSetoid`, `picMul`, `picInv` (L757-791): components of `picCommGroup`, blueprint handles them at `def:pic_carrier`/`thm:pic_commgroup` level
- `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` (L1379), `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` (L1428): sub-steps toward D2'; these could be pinned once D2' closes, but are currently project-local staging lemmas
- `sheafifyUnitIso` (L1478): sub-step toward D2'; useful building block
- `pullbackObjUnitToUnitIso`, `pullbackObjUnitToUnitIso_hom` (L1013-1023): project-local helpers
- `isIso_pbu_of_final` (L1005): `private` helper
- `sheafifyTensorUnitIso` (L1048): `private` helper
- `isIso_sheafify_tensorHom_pullbackValIso` (L1304): `private` helper
- `W_of_isIso_sheafification` (L1353): `private` helper
- `pullbackValIso` (L1173): sub-step
- `unitToPushforwardObjUnit_comp` (L846): already referenced by blueprint (`lem:unitToPushforwardObjUnit_comp`, line 3151, has `\lean{...}` pin — OK)
- `pullback0`, `extendScalars`, `pullback0Adjunction`, `extendScalarsAdjunction` (L1252-1275): off-path (D1 Lan decomposition, correctly blueprinted as such)

---

## Blueprint adequacy for this file

- **Coverage**: Of the roughly 32 non-private top-level declarations in TensorObjSubstrate.lean, 20 have corresponding `\lean{...}` blocks in the chapter (some via sub-file imports). The 2 new iter-247 declarations (`presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`) are not yet pinned. Unreferenced declarations: ~10 are genuinely helper-only (private or sub-step); 2 are substantive new supplements that should be noted (see above).

- **Proof-sketch depth**: **adequate** for the already-closed declarations. The D2' (`lem:pullback_tensor_iso_unit`) proof sketch is detailed enough to guide formalization — it correctly describes the δ-wrapping via `left_unitality_hom`, the η-bridge identification with `pullbackObjUnitToUnit φ` through `pullbackValIso` and `sheafifyUnitIso`, and the "unit-side analog of `pullbackObjUnitToUnit_comp`" character of the square equation. The blueprint's description at lines ~3354-3370 maps cleanly to the Lean proof structure at L1379-1419 and L1518-1544.

- **Hint precision**: **precise** for closed declarations, **forward-planning** for D1'–D4'. The forward `\lean{...}` pins for D1'–D4' name non-existent declarations (as intended for unformalized targets). Since no `\leanok` accompanies them, this is acceptable forward planning, not a misleading claim.

- **Generality**: **matches need** — the substrate is correctly framed as an existence-of-isomorphism construction rather than a full monoidal category, exactly as the consumer requires.

- **Recommended chapter-side actions**:
  1. **Fix the three `\uses{\leanok ...}` syntax errors** (Red Flags §1–§3): move `\leanok` outside the `\uses{...}` braces in the proof environments of `lem:tensorobj_assoc_iso`, `IsInvertible.tensorObj`'s proof, and `IsInvertible.inverse_unique`'s proof. These are line-level LaTeX fixes that restore the three valid dependency edges and silence the blueprint-doctor warnings.
  2. **Add `\leanok` to `lem:tensorobj_unit_iso` statement block**: `tensorObj_left_unitor` and `tensorObj_right_unitor` are both sorry-free; `sync_leanok` should have added this but appears to have missed it.
  3. **Add `\lean{...}` pins (or `% NOTE:` annotations) for the two new iter-247 supplements** once D2' closes unconditionally: `presheafUnit_comp_map_eta` and `isIso_sheafifyEta_of_unitSquare` are substantive project-local building blocks that the blueprint narrative describes implicitly but does not yet reference.
  4. **Update `archon:covers` header** to note `RelPicFunctor.lean` for `tensorObjOnProduct` (it moved there per iter-247 import-cycle fix), or note the move in a `% NOTE:` comment.

---

## Severity summary

- **must-fix-this-iter**: NONE. No placeholder bodies, wrong types, or excuse-comments. The three broken `\uses{\leanok ...}` are blueprint-side LaTeX syntax errors (not Lean errors); they do not block any Lean proof work. The open sorries (`exists_tensorObj_inverse`) and the unformalized D1'–D4' targets are all correctly represented as unformalized (no `\leanok`).

- **major**: NONE. The blueprint correctly does not claim D2'/D3'/D4' are closed. The `\lean{...}` pins for forward targets name expected future declaration names, which is standard practice when no `\leanok` accompanies them.

- **minor**:
  1. Three `\uses{\leanok ...}` syntax errors in proof environments break the dependency graph for three edges in the blueprint. Fix is mechanical (move `\leanok` one line). All three intended targets ARE valid labels.
  2. `lem:tensorobj_unit_iso`: missing `\leanok` in statement despite both `tensorObj_left_unitor` and `tensorObj_right_unitor` being sorry-free. `sync_leanok` should address this.
  3. The two new axiom-clean iter-247 declarations (`presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`) lack blueprint `\lean{...}` pins; they implement the η-bridge components described in the D2' blueprint sketch but are not yet formally linked.
  4. `tensorObjOnProduct` moved to `RelPicFunctor.lean` (import-cycle fix); the chapter `archon:covers` list does not include that file.

**Overall verdict**: The chapter is substantially correct and honest — all formalized declarations match their blueprint descriptions, the open sorries and unformalized D1'–D4' targets are correctly represented without `\leanok`, and the two new iter-247 supplement declarations (`presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`) are axiom-clean implementations of exactly what the blueprint's D2' proof sketch describes. The only actionable issues are three LaTeX syntax bugs in `\uses{}` blocks and minor `\leanok` bookkeeping; none block Lean proof work.
