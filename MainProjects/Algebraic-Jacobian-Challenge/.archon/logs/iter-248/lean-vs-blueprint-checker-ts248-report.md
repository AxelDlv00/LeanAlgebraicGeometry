# Lean ↔ Blueprint Check Report

## Slug
ts248

## Iteration
248

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (1691 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (5580+ lines)

---

## Per-declaration (freshly-landed, per directive focus)

### `\lean{AlgebraicGeometry.Scheme.Modules.compHomEquivFactor}` (chapter: `lem:comp_homequiv_factor_sheafify_pullback`, L3590)
- **Lean target exists**: yes (L1554)
- **Signature matches**: yes — blueprint states `A.homEquiv g = adj₁.homEquiv(adj₂.homEquiv g)` for composable adjunctions; Lean has `(adj₁.comp adj₂).homEquiv c e g = adj₁.homEquiv c (R₂.obj e) (adj₂.homEquiv (L₁.obj c) e g)`. Exact match in type structure.
- **Proof follows sketch**: yes — blueprint says "follows from `Adjunction.comp_unit_app` + standard naturality"; Lean uses `simp [homEquiv_unit, comp_unit_app, Functor.comp_map, Functor.map_comp]` followed by `Category.assoc`. Precise match.
- **Blueprint marker**: `\begin{lemma}\leanok` (statement L3587) + proof `\leanok` (L3610). Both correct (no sorry, axiom-clean).
- **Notes**: axiom-clean, correct, no issues.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.leftAdjointUniqUnitEta}` (chapter: `lem:leftadjointuniq_app_unit_eta`, L3629)
- **Lean target exists**: yes (L1595)
- **Signature matches**: yes — blueprint says: `A.homEquiv g = B.unit.app 1ᵖ = presheafAdj.unit.app 1ᵖ ≫ (pushforward φ').map(toSheafify_Y(F.obj 1ᵖ))`. Lean signature has `((sheafificationAdjunction 𝟙_X).comp (pullbackPushforwardAdjunction_sheaf φ)).homEquiv _ _ ((sheafificationCompPullback φ).hom.app 𝟙ᵖ) = (pullbackPushforwardAdjunction φ').unit.app 𝟙ᵖ ≫ (pushforward φ').map ((sheafificationAdjunction 𝟙_Y).unit.app …)`. The blueprint's `toSheafify_Y(F.obj 1ᵖ)` is `(sheafificationAdjunction 1_Y).unit.app (F.obj 1ᵖ)` — the sheafification unit equals `toSheafify`, so these are the same.
- **Proof follows sketch**: yes — uses `homEquiv_leftAdjointUniq_hom_app A B` (★ step 4) and `Adjunction.comp_unit_app` on `B` for the expansion, exactly as the blueprint describes.
- **Blueprint marker**: `\begin{lemma}\leanok` (statement L3626) + proof `\leanok` (L3650). Both correct (no sorry, axiom-clean).
- **Notes**: axiom-clean, correct, no issues.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackEtaUnitSquare}` (chapter: `lem:eta_bridge_unit_square`, L3471)
- **Lean target exists**: yes (L1641)
- **Signature matches**: yes — both state `(pullbackValIso f 𝒪_X).inv ≫ a_Y.map(η (pullback φ')) ≫ sheafifyUnitIso.hom = pullbackObjUnitToUnit φ`.
- **Proof follows sketch**: partial — proof transposes across `pullbackPushforwardAdjunction φ` (correct), rewrites by `pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit` (step 1) and `homEquiv_unit` (step 1 continued), then lands `sorry` at L1672 for the remaining seven-step telescope `(∗∗)`. The steps already closed (`compHomEquivFactor`, `leftAdjointUniqUnitEta`, `presheafUnit_comp_map_eta`) are correctly referenced in the in-file comment. The sorry is the known `(∗∗)` residual (step 7, ε-reconciliation).
- **Blueprint marker**: `\begin{lemma}\leanok` (statement L3468) = exists; proof block has no `\leanok` (proof not yet closed). **Correct** — `sync_leanok` correctly omits `\leanok` from the proof block given the open sorry.
- **Notes**: one known/intentional sorry at L1672 (directive confirms this). Not flagged as must-fix.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso}` (chapter: `lem:pullback_tensor_iso_unit`, L3334)
- **Lean target exists**: yes (L1678)
- **Signature matches**: yes — `IsIso (pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf) (SheafOfModules.unit X.ringCatSheaf))` for arbitrary `f : Y ⟶ X`. Exact match with blueprint statement.
- **Proof follows sketch**: yes — proof body `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta f (isIso_sheafifyEta_of_unitSquare f (pullbackEtaUnitSquare f))` chains exactly the three sub-lemmas the blueprint proof outline specifies: δ-wrapping, IsIso plumbing, unit square. Carries sorryAx transitively through `pullbackEtaUnitSquare` (known/intentional).
- **Blueprint marker**: `\begin{lemma}\n\n\leanok` at L3331 (statement block = correct, declaration exists). The proof block shows `\leanok` at L3349 **placed inside the `\uses{...}` argument**, not as a standalone proof marker.

  **Observation (minor)**: The `\leanok` at L3349 is syntactically embedded inside the `\uses{}` argument list:
  ```latex
  \begin{proof}
    \uses{lem:pullback_tensor_map, lem:isiso_pullbacktensormap_of_sheafifydelta,
    \leanok
          lem:isiso_sheafifyeta_of_unitsquare, lem:eta_bridge_unit_square}
  ```
  This is non-standard placement. LeanBlueprint's `sync_leanok` normally places `\leanok` as a standalone command *before* the proof body, not inside a `\uses{}` argument. Given the proof carries sorryAx transitively (making it not sorry-free), a correctly-placed proof `\leanok` would have been **incorrect**; PlasTeX may simply not parse it as a valid proof marker in that position. This is likely a relic of manual editing. Since the sorryAx is known/intentional per the directive, this is classified as **minor** (formatting anomaly, no mathematical content impact).

---

## Other `\lean{...}` pins — chapter-wide scan (directive item c)

Checked all 50+ pins in the chapter against the Lean files. Findings:

### Declarations present and correctly marked
- `Scheme.Modules.tensorObj` (L309): exists L138 ✓
- `Scheme.Modules.tensorObj_functoriality` (L348): exists L153 ✓
- `PresheafOfModules.restrictScalarsLaxMonoidal` (L488): in `PresheafInternalHom.lean` ✓
- `Scheme.Modules.tensorObj_restrict_iso` (L560): exists L423 ✓
- `Scheme.Modules.tensorObj_isLocallyTrivial` (L876): exists L513 ✓
- `Scheme.Modules.tensorObj_assoc_iso` (L1439): exists L318 ✓
- `Scheme.Modules.tensorObj_left_unitor` / `tensorObj_right_unitor` (L1562): exist L269/L279 ✓
- `Scheme.Modules.tensorObj_braiding` (L1594): exists L289 ✓
- `Scheme.Modules.exists_tensorObj_inverse` (L1619): exists L670, known sorry ✓
- `Scheme.Modules.IsInvertible` (L2308): exists L166 ✓
- `Scheme.Modules.PicGroup` / `picCommGroup` (L2376): exists L764/L798 ✓
- `Scheme.Modules.presheafPushforwardLaxMonoidal` (L2717): exists L1101 ✓
- `Scheme.Modules.presheafPullbackOplaxMonoidal` (L2755): exists L1123 ✓
- `Scheme.Modules.pullbackLanDecomposition` (L2939): exists L1283 ✓
- `Scheme.Modules.pullbackTensorMap` (L3046): exists L1190 ✓
- `Scheme.Modules.isIso_pullbackTensorMap_of_isIso_sheafifyDelta` (L3094): exists L1327 ✓
- `Scheme.Modules.unitToPushforwardObjUnit_comp` (L3151): exists L846 ✓
- `Scheme.Modules.pullbackObjUnitToUnit_comp` (L3191): exists L887 ✓
- `Scheme.Modules.pullbackUnitIso` (L3243): exists L1030 ✓
- `Scheme.Modules.presheafUnit_comp_map_eta` (L3406): exists L1495 ✓
- `Scheme.Modules.isIso_sheafifyEta_of_unitSquare` (L3437): exists L1518 ✓
- `Scheme.Modules.isIso_of_isIso_restrict` (L5478): exists L544 ✓
- `Scheme.Modules.homMk` (L5517): exists L585 ✓
- `Scheme.Modules.overSliceSheafEquiv` (L5255): exists in `Vestigial.lean` L715 ✓
- `Scheme.Modules.dualIsoOfIso` (L5233): exists L205 ✓

### Blueprint pins pointing at absent (unformalized) declarations — correctly have NO `\leanok`
All of the following are referenced in the blueprint with `\lean{...}` pins but have no corresponding definition/lemma in the Lean files. **Crucially, none have `\leanok` markers on their statement blocks**, so `sync_leanok` state is correct.

- `Scheme.Modules.pullbackTensorMap_natural` (L3291) — absent, no `\leanok` ✓
- `Scheme.Modules.pullbackTensorIso` (L2801) — absent, no `\leanok` ✓
- `Scheme.Modules.pullback0TensorIso` (L2989) — absent, no `\leanok` ✓
- `Scheme.Modules.pullbackTensorMap_restrict` (L3711) — absent, no `\leanok` ✓
- `Scheme.Modules.pullbackTensorIsoOfLocallyTrivial` (L3756) — absent, no `\leanok` ✓
- `Scheme.Modules.IsInvertible.isLocallyTrivial` (L3854) — absent, no `\leanok` ✓
- `Scheme.Modules.IsInvertible.pullback` (L3960) — absent, no `\leanok` ✓
- `Scheme.Modules.dual_restrict_iso` (L5319) — absent, no `\leanok` ✓
- `Scheme.Modules.dual_isLocallyTrivial` (L5417) — absent, no `\leanok` ✓
- `Scheme.Modules.homOfLocalCompat` (L5536) — absent, no `\leanok` ✓

### Unreferenced Lean declaration: `sheafificationCompPullback_eq_leftAdjointUniq`
- **Lean**: exists at L1575, proven by `rfl`, axiom-clean.
- **Blueprint**: NO `\lean{...}` pin.
- This is a **confirmed known issue** per directive (review agent already recommended the plan agent add a `\lean{...}` pin). Confirming only.

### Epsilion reconciliation (`epsilonPresheafToSheafUnit`):
- Blueprint `lem:epsilon_presheaf_to_sheaf_unit` / `\lean{AlgebraicGeometry.Scheme.Modules.epsilonPresheafToSheafUnit}` (L3668): absent from Lean files; blueprint has a `% NOTE:` (L3669–3677) flagging the statement as ill-typed at the sheaf level. **No `\leanok`** on the statement block. Correctly marked as unformalized. This is explicitly covered in the directive as a known issue.

---

## Red flags

### Excuse-comments
None found beyond the known-intentional body comments inside `pullbackEtaUnitSquare` and `exists_tensorObj_inverse` (both pre-acknowledged in the directive).

### Axioms / Classical.choice
None unauthorized. The `sorry` at L1672 and L692 are the only sorry-sites; both pre-authorized by the directive.

### Placeholder bodies
None beyond the two pre-authorized sorries.

---

## Unreferenced declarations (informational)

Declarations in `TensorObjSubstrate.lean` with no `\lean{...}` blueprint pin:

| Declaration | Line | Note |
|---|---|---|
| `sheafificationCompPullback_eq_leftAdjointUniq` | L1575 | Linchpin lemma, axiom-clean (`rfl`). **Should have a pin** — known gap, already flagged. |
| `IsInvertible.tensorObj` | L728 | Has pin at L4161 ✓ (already covered above) |
| `IsInvertible.inverse_unique` | L745 | Has pin at L4265 ✓ |
| `picSetoid` | L757 | Internal helper for `PicGroup`; covered by the `PicGroup`/`picCommGroup` pin |
| `picMul`, `picInv` | L769, L778 | Internal group-operation helpers; covered by `picCommGroup` pin |
| `tensorObj_assoc_iso_invertible` | L706 | Has pin at L4077 ✓ |
| `isInvertible_unit` | L738 | Has pin at L4221 ✓ |
| Various `private` helpers | multiple | Private; correctly absent from blueprint |
| `pullbackValIso` | L1173 | Internal helper for `pullbackTensorMap`; no direct pin, functions as stepping-stone |
| `sheafifyTensorUnitIso` | L1478 | `private`, internal helper for `pullbackTensorMap`; correctly absent |
| `W_of_isIso_sheafification` | L1353 | `private`, correctness-helper for δ-wrapping; correctly absent |
| `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` | L1379 | Intermediate D2' step; could benefit from a pin (it is the δ-wrapping half of D2') but is acceptably described in prose |
| `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` | L1428 | D2' assembly step; similar |
| `sheafifyUnitIso` | L1478 | Codomain identification helper for η-bridge; correctly internal |
| `unitToPushforwardObjUnit_comp` | L846 | Has pin at L3151 ✓ |
| `pullbackObjUnitToUnit_comp` | L887 | Has pin at L3191 ✓ |
| `pullback0`, `extendScalars`, `pullbackLanDecomposition` | L1252–L1288 | `pullbackLanDecomposition` has pin at L2939 ✓; `pullback0`/`extendScalars` are internal helpers for D1 |
| `compHomEquivFactor`, `leftAdjointUniqUnitEta`, `pullbackEtaUnitSquare`, `pullbackTensorMap_unit_isIso`, `presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare` | various | All pinned ✓ |
| `restrictIsoUnitOfLE` | L371 | Helper; no blueprint pin; acceptable |

**Notable**: `sheafificationCompPullback_eq_leftAdjointUniq` (L1575) is the only substantive unpinned declaration that should have a blueprint entry.

---

## Blueprint adequacy for this file

- **Coverage**: The chapter's `\lean{...}` pins cover all major public API declarations in the file. Internal/private helpers are correctly absent from the blueprint. The D2' subsection (§"The unit square") is particularly well-specified with a numbered 7-step proof sketch, explicit naming of each intermediate lemma, and clear separation between closed and open sub-steps.
- **Proof-sketch depth**: **adequate** for the four freshly-landed declarations. The 7-step telescope for `pullbackEtaUnitSquare` is detailed enough to guide formalization: each step is named, the adjunction layer it lives in is specified, and the Mathlib lemmas invoked are identified. The remaining sorry (step 7, ε-reconciliation) is explicitly diagnosed in the blueprint's `% NOTE:` annotation at L3669–3677, with the precise obstacle (no `Functor.LaxMonoidal` instance on the sheaf pushforward) and the required reformulation.
- **Hint precision**: **precise**. The `\lean{...}` names for the four new declarations match the Lean identifiers exactly. The blueprint's description of adjunctions A and B matches the Lean `set` bindings exactly.
- **Generality**: **matches need**. The D2' and telescope lemmas are stated at the right level of generality (arbitrary scheme morphism `f : Y ⟶ X`).
- **Recommended chapter-side actions**:
  1. Add `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_eq_leftAdjointUniq}` pin to the blueprint — this is the linchpin that `leftAdjointUniqUnitEta` rests on and has no statement block. (Already flagged; confirming recommendation.)
  2. Fix the misplaced `\leanok` at blueprint L3349: move it out of `\uses{...}` to a standalone position after the `\uses{...}` block, or leave it absent (proof carries sorryAx; should not have a proof-block `\leanok`). Minor formatting fix; no mathematical impact.
  3. Restate `lem:epsilon_presheaf_to_sheaf_unit` at the `.val`/presheaf level (the `% NOTE:` at L3669 already records this; needs to be acted on when step 7 is discharged).

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**:
  1. `sheafificationCompPullback_eq_leftAdjointUniq` (L1575) lacks a `\lean{...}` blueprint pin. Axiom-clean, proven by `rfl`; the plan agent should add the pin. (Already flagged; confirming.)
  2. `\leanok` at blueprint L3349 is syntactically inside the `\uses{}` argument of `pullbackTensorMap_unit_isIso`'s proof block (non-standard placement; the proof carries sorryAx so a proof-block `\leanok` would be incorrect if parsed). Cosmetic/formatting issue; does not affect mathematical correctness.

**Overall verdict**: The four freshly-landed declarations `compHomEquivFactor`, `leftAdjointUniqUnitEta`, `pullbackEtaUnitSquare`, and `pullbackTensorMap_unit_isIso` all have signatures exactly matching their blueprint blocks and proofs/statements correctly reflecting the D2′ telescope prose; no must-fix or major issues found; 2 minor items (unpinned linchpin lemma, misplaced proof-block `\leanok`).
