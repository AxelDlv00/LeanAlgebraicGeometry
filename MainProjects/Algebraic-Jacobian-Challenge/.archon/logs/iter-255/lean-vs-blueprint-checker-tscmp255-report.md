# Lean ↔ Blueprint Check Report

## Slug
tscmp255

## Iteration
255

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (2121 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (333 KB, ~4900 lines)

---

## Per-declaration (focused: `pullbackTensorMap_natural`)

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}` (blueprint: `lem:pullback_tensor_map_natural`)

- **Lean target exists**: yes — `lemma pullbackTensorMap_natural` at Lean line 2004, fully qualified as `AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural`, exactly matching the `\lean{...}` pin.
- **Signature matches**: yes. Blueprint states: for `f : Y → X` and morphisms `a : M → M'`, `b : N → N'` in `X.Modules`, the square
  ```
  f^*(M ⊗ N) --δ_sheaf--> f^*M ⊗ f^*N
       |                         |
   f^*(a⊗b)               f^*a ⊗ f^*b
       |                         |
  f^*(M'⊗ N') --δ_sheaf--> f^*M' ⊗ f^*N'
  ```
  commutes. The Lean signature is:
  ```
  (Scheme.Modules.pullback f).map (tensorObj_functoriality a b) ≫ pullbackTensorMap f M' N'
    = pullbackTensorMap f M N ≫
      tensorObj_functoriality ((Scheme.Modules.pullback f).map a) ((Scheme.Modules.pullback f).map b)
  ```
  Left-vertical + bottom = right-hand side; top + right-vertical = left-hand side. Perfect match.
- **Proof follows sketch**: yes. The blueprint proof sketch identifies four naturality squares to paste. The Lean proof (lines 2025–2112) faithfully implements each:
  - **S1** (naturality of `sheafificationCompPullback`): `erw [(SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).hom.naturality_assoc]` — matches blueprint "the sheafification is a natural iso."
  - **S2** (δ naturality, the delicate step): The blueprint explicitly describes the "canonical form re-establishing" trick — ascribe the ring-hom φ' at the canonical `⋙ forget₂` spelling inside `δ_natural` so the registered `MonoidalCategory` instance synthesizes. The Lean proof uses exactly this: `erw [← Functor.OplaxMonoidal.δ_natural (F := PresheafOfModules.pullback (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶ ... from (Hom.toRingCatSheafHom f).hom)) a.val b.val]`. The blueprint's description of this technique (prose paragraph "Square 2: naturality of the oplax comparison δ") is a structural device — only the presentation changes — which is accurate.
  - **S3** (naturality of `sheafifyTensorUnitIso`): `erw [reassoc_of% (sheafifyTensorUnitIso_hom_natural ...)]` — the helper `sheafifyTensorUnitIso_hom_natural` is separately blueprint-pinned as `lem:sheafify_tensor_unit_iso_natural`, and its `\leanok` matches.
  - **S4** (naturality of `pullbackValIso` + bifunctoriality): `hleg` lemma + `tensorHom_comp_tensorHom` closing — matches blueprint "the bifunctoriality of `⊗_Y`" + `pullbackValIso` naturality (pinned as `lem:pullback_val_iso_natural`).
- **Notes**: `\leanok` appears in the blueprint on both the statement block (blueprint line 3302) and the proof block (blueprint line 3329), consistent with the Lean proof being sorry-free. The proof has a `set_option maxHeartbeats 3200000` at line 1999 (the 4-square diagram chase is heartbeat-heavy) — this is a performance annotation, not a mathematical compromise.

### All other `\lean{...}`-pinned declarations in TensorObjSubstrate.lean

The file has ~40 `\lean{...}`-pinned declarations. All checked declarations that are present in `TensorObjSubstrate.lean` are sorry-free and match their blueprint statements:

| Blueprint label | `\lean{...}` name | Status |
|---|---|---|
| `def:scheme_modules_tensorobj` | `tensorObj` | No sorry, body matches blueprint (sheafification of presheaf ⊗) |
| `lem:scheme_modules_tensorobj_functoriality` | `tensorObj_functoriality` | No sorry |
| `lem:tensorobj_restrict_iso` | `tensorObj_restrict_iso` | No sorry; blueprint 4-step proof (H1∘H2) matches |
| `lem:tensorobj_preserves_locally_trivial` | `tensorObj_isLocallyTrivial` | No sorry |
| `lem:tensorobj_assoc_iso` | `tensorObj_assoc_iso` | No sorry; unconditional (iter-238 route (d)) |
| `lem:tensorobj_unit_iso` | `tensorObj_left_unitor`, `tensorObj_right_unitor` | No sorry |
| `lem:tensorobj_comm_iso` | `tensorObj_braiding` | No sorry |
| `lem:tensorobj_inverse_invertible` | `exists_tensorObj_inverse` | **`:= sorry`** — pre-authorized open obligation (see Red flags) |
| `def:scheme_modules_isinvertible` | `IsInvertible` | No sorry (Prop def) |
| `lem:tensorobj_assoc_iso_invertible` | `tensorObj_assoc_iso_invertible` | No sorry |
| `lem:isinvertible_tensor` | `IsInvertible.tensorObj` | No sorry |
| `lem:isinvertible_unit` | `isInvertible_unit` | No sorry |
| `lem:isinvertible_inverse_welldef` | `IsInvertible.inverse_unique` | No sorry |
| `def:pic_carrier` | `PicGroup` | No sorry (Quotient def) |
| `thm:pic_commgroup` | `picCommGroup` | No sorry |
| `lem:unitToPushforwardObjUnit_comp` | `unitToPushforwardObjUnit_comp` | No sorry |
| `lem:pullbackObjUnitToUnit_comp` | `pullbackObjUnitToUnit_comp` | No sorry |
| `lem:pullback_unit_iso` | `pullbackUnitIso` | No sorry |
| `lem:presheaf_pushforward_laxmonoidal` | `presheafPushforwardLaxMonoidal` | No sorry |
| `lem:presheaf_pullback_oplaxmonoidal` | `presheafPullbackOplaxMonoidal` | No sorry |
| `lem:pullback_tensor_map` | `pullbackTensorMap` | No sorry |
| `lem:isiso_pullbacktensormap_of_sheafifydelta` | `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` | No sorry |
| `lem:pullback_lan_decomposition` | `pullbackLanDecomposition` | No sorry (off-path, retained) |
| `lem:sheafify_tensor_unit_iso_natural` | `sheafifyTensorUnitIso_hom_natural` | No sorry |
| `lem:pullback_val_iso_natural` | `pullbackValIso_hom_natural` | No sorry |
| `lem:pullback_tensor_map_natural` | `pullbackTensorMap_natural` | **No sorry** ← directive target |
| `lem:pullback_tensor_iso_unit` | `pullbackTensorMap_unit_isIso` | No sorry |
| `lem:presheaf_unit_comp_map_eta` | `presheafUnit_comp_map_eta` | No sorry |
| `lem:isiso_sheafifyeta_of_unitsquare` | `isIso_sheafifyEta_of_unitSquare` | No sorry |
| `lem:eta_bridge_unit_square` | `pullbackEtaUnitSquare` | No sorry |
| `lem:comp_homequiv_factor_sheafify_pullback` | `compHomEquivFactor` | No sorry |
| `lem:sheafification_comp_pullback_eq_leftadjointuniq` | `sheafificationCompPullback_eq_leftAdjointUniq` | No sorry |
| `lem:leftadjointuniq_app_unit_eta` | `leftAdjointUniqUnitEta` | No sorry |
| `lem:epsilon_presheaf_to_sheaf_unit` | `epsilonPresheafToSheafUnit` | No sorry |

---

## Red flags

### Placeholder / suspect bodies

- **`exists_tensorObj_inverse` at line 712**: body is `:= sorry`. Blueprint `lem:tensorobj_inverse_invertible` has no `\leanok` on the proof block, explicitly acknowledging this is open. The body comment accurately describes the two remaining bridges (C: `dual_isLocallyTrivial`, A: SheafOfModules morphism descent) and the forbidden route. This is a **pre-authorized open obligation**, not a red flag in the sentinel sense: it is the ONE known open sorry and is correctly tracked.

### Excuse-comments

None. The comments in the file are informational (proof strategies, dead-end warnings, iteration history), not excusing wrong or incomplete code.

### Axioms / Classical.choice on non-trivial claims

No `axiom` declarations. `Classical.choice` appears only in `picInv` (choosing the canonical tensor inverse from the existential) — consistent with the blueprint's design ("the inverse is read off the existential carried by `IsInvertible`").

---

## Unreferenced declarations (informational)

The following Lean declarations have no direct `\lean{...}` pin in the blueprint. All are either private helpers or sub-results absorbed into larger pinned declarations:

- `tensorObj_unit_iso` — not separately pinned; the blueprint's `lem:tensorobj_unit_iso` pins only `tensorObj_left_unitor` and `tensorObj_right_unitor`. This is the special case `𝒪 ⊗ 𝒪 ≅ 𝒪`, used internally by `isInvertible_unit` and the group law. Minor: a blueprint pin for this would be helpful since it's named and referenced in `\uses{}` by other blocks.
- `pullbackValIso` — referenced in prose and used by `pullbackTensorMap` (pinned), but not itself `\lean{...}`-pinned. The blueprint prose describes it as "the per-object form of `sheafificationCompPullback`... the bridge used to reconcile the right-hand side." Acceptable helper.
- `dualIsoOfIso`, `restrictIsoUnitOfLE`, `tensorObjIsoOfIso` — helpers for the dual/trivialisation infrastructure. Acceptable.
- `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta`, `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` — intermediate D2′ steps. Not separately pinned; they decompose the D2′ proof (blueprint `lem:pullback_tensor_iso_unit`). Acceptable; the chain is: these two → `pullbackTensorMap_unit_isIso` (pinned).
- `sheafifyUnitIso` — small iso helper; referenced by name in blueprint prose but not pinned. Acceptable.
- `restrictScalarsId_map` — technical propositional rewrite; no blueprint pin needed.
- `pullbackSheafifyUnitEtaTriangle` — substep (ii) of the D2′ `(∗∗)` close; absorbed into `pullbackEtaUnitSquare` (pinned). Acceptable.
- `isIso_pbu_of_final`, `pullbackObjUnitToUnitIso`, `pullbackObjUnitToUnitIso_hom` — technical helpers for the `pullbackUnitIso` TC-resolution fix. Acceptable.
- `sheafifyTensorUnitIso` (private), `sheafifyTensorUnitIso_hom_eq` (private), `sheafifyTensorUnitIso_hom_eq'` (private) — internal decomposition lemmas for `sheafifyTensorUnitIso_hom_natural` (pinned). Acceptable.
- `picSetoid` — used to define `PicGroup`/`picCommGroup` (both pinned). Acceptable.
- `picMul`, `picInv` — auxiliary `def`s for the `picCommGroup` instance (which is pinned). Acceptable.
- `tensorObj_middleFour` (private) — helper for `IsInvertible.tensorObj`. Acceptable.
- `W_of_isIso_sheafification` (private), `isIso_sheafify_tensorHom_pullbackValIso` (private) — internal technical helpers. Acceptable.
- `pushforward₀IsRightAdjoint`, `restrictScalarsIsRightAdjoint` (private in `PullbackLanDecomposition`) — helpers for `pullbackLanDecomposition` (pinned). Acceptable.
- `pullback0`, `extendScalars`, `pullback0Adjunction`, `extendScalarsAdjunction` — off-path D1 infrastructure. Blueprint `lem:pullback_lan_decomposition` pins only `pullbackLanDecomposition`, not these building blocks; noted as off-path in both the Lean file and the blueprint.

---

## Blueprint adequacy for this file (focused on `pullbackTensorMap_natural`)

- **Coverage**: The blueprint chapter has `\lean{...}` pins for 34+ declarations in this file. The unreferenced declarations are genuine helpers or sub-results. Coverage is good.
- **Proof-sketch depth for `lem:pullback_tensor_map_natural`**: **adequate**. The blueprint identifies all four naturality squares, explicitly names the delicate Square 2 canonical-form trick ("one ascribes the defining ring map φ' explicitly to the canonical composite-functor source"), and cross-references the two helper lemmas that close Squares 3 and 4. This level of detail was sufficient to guide the Lean proof.
- **Hint precision**: **precise**. The `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}` pin resolves to exactly the declared lemma with no ambiguity. All helper lemmas referenced in the proof sketch (`sheafifyTensorUnitIso_hom_natural`, `pullbackValIso_hom_natural`) are individually `\lean{...}`-pinned.
- **Generality**: **matches need**. The statement covers arbitrary `f : Y ⟶ X` and arbitrary morphisms `a`, `b`, which is exactly what downstream consumers need.
- **Recommended chapter-side actions**: None for `pullbackTensorMap_natural`. One **minor** improvement: add a `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_unit_iso}` pin to the chapter (it is referenced by name in the `\uses{}` fields of several blocks but not yet `\lean{...}`-tagged).

---

## Severity summary

- **must-fix-this-iter**: 0 findings.
- **major**: 0 findings.
- **minor**:
  - `tensorObj_unit_iso` lacks a blueprint `\lean{...}` pin despite being a named, substantive declaration that other blocks reference via `\uses{}`. This does not affect correctness; the declaration is sorry-free and matches its implied statement.
  - `pullbackValIso` is used by the pinned `pullbackTensorMap` but not separately pinned; the blueprint prose describes it accurately.

**Overall verdict**: `pullbackTensorMap_natural` is correctly formalized — name, signature, and proof-structure all match the blueprint; no sorries, no axioms, no excuse-comments; the blueprint proof sketch adequately guided the formalization. The one pre-authorized sorry (`exists_tensorObj_inverse`) is a known open obligation correctly tracked by both the Lean file and the blueprint. 2 minor documentation gaps, 0 blocking findings.
