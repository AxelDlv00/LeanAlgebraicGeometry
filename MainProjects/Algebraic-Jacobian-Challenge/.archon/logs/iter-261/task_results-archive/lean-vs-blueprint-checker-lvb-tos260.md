# Lean ↔ Blueprint Check Report

## Slug
lvb-tos260

## Iteration
260

## Files audited
- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: `lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes (line 693)
- **Signature matches**: yes — `{L : X.Modules} (hL : LineBundle.IsLocallyTrivial L) : ∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: N/A (body is `:= sorry`; blueprint marks this as open with a documented two-bridge decomposition — C-bridge `dual_isLocallyTrivial` and A-bridge SheafOfModules descent)
- **notes**: `\leanok` is on the statement block (line 1614), consistent with sorry body present. The sorry is a known, documented open obligation. Blueprint adequately describes the C-bridge (dual commutes with restriction) and A-bridge (sheaf gluing + `homMk` promotion) as the two remaining steps.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` (chapter: `lem:pullback_tensor_map_basechange`)
- **Lean target exists**: yes (line 2449)
- **Signature matches**: yes — `(h : Z ⟶ Y) (f : Y ⟶ X) (M N : X.Modules) : pullbackTensorMap (h ≫ f) M N = (pullbackComp h f).inv.app (tensorObj M N) ≫ (pullback h).map (pullbackTensorMap f M N) ≫ pullbackTensorMap h ((pullback f).obj M) ((pullback f).obj N) ≫ (tensorObjIsoOfIso (pullbackComp h f).app M ((pullbackComp h f).app N)).hom`
- **Proof follows sketch**: partial — see Red flags / Blueprint adequacy below
- **notes**: `\leanok` is on the statement block (line 3862); proof block has no `\leanok`, consistent with the sorry body. The sorry is documented. The blueprint proof section describes Sq1–Sq4, but the status of Sq2b is now stale (see Major finding #2 below).

All other `\lean{...}`-tagged declarations in this file (tensorObj, tensorObj_functoriality, tensorObj_restrict_iso, tensorObj_isLocallyTrivial, tensorObj_assoc_iso, tensorObj_left_unitor, tensorObj_right_unitor, tensorObj_braiding, isInvertible_unit, IsInvertible.tensorObj, IsInvertible.inverse_unique, picCommGroup, PicGroup, pullbackTensorMap, isIso_pullbackTensorMap_of_isIso_sheafifyDelta, pullbackObjUnitToUnit_comp, pullbackTensorMap_natural, sheafifyTensorUnitIso_hom_natural, pullbackValIso_hom_natural, pullbackTensorMap_unit_isIso, presheafUnit_comp_map_eta, isIso_sheafifyEta_of_unitSquare, pullbackEtaUnitSquare, compHomEquivFactor, sheafificationCompPullback_eq_leftAdjointUniq, leftAdjointUniqUnitEta, epsilonPresheafToSheafUnit, unitToPushforwardObjUnit_comp, pullbackUnitIso, IsInvertible, isIso_of_isIso_restrict, homMk, presheafPushforwardLaxMonoidal, presheafPullbackOplaxMonoidal, pullbackLanDecomposition) were all checked in prior iterations and carry `\leanok` on both statement and proof blocks where appropriate. No new issues on those.

---

## Red flags

### Placeholder / suspect bodies
- `exists_tensorObj_inverse` at line 693: body is `:= sorry`. Blueprint marks this as an open obligation (sorry is declared and expected). **Not a placeholder violation** — the blueprint prose explicitly names this as infrastructure-blocked with a documented route.
- `pullbackTensorMap_restrict` at line 2449: body is `:= sorry`. Same — explicitly declared open with documented sub-lemma obligations. **Not a placeholder violation.**

### Excuse-comments
None. The sorry bodies carry accurate technical comments explaining what remains to be built, consistent with the blueprint.

### Axioms / Classical.choice on non-trivial claims
None introduced by `pushforwardComp_lax_μ` or `pullbackComp_δ`. Both private lemmas are axiom-clean (no sorry, no axiom declarations).

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no corresponding `\lean{...}` reference in the blueprint. All are `private` helpers; none are flagged as requiring blueprint promotion:

- `restrictScalars_μ_app` (private, line 2134) — rfl helper for Sq2b close
- `forget₂_restrictScalars_μ_hom_tmul` (private, line 2152) — pure-tensor collapse for Sq2b
- `restrictScalars_μ_app_tmul` (private, line 2168) — pure-tensor collapse for Sq2b
- `pushforward_map_restrictScalars_μ_app_tmul` (private, line 2186) — outer leg for Sq2b
- `pushforward_μ_eq` (private, line 2213) — rfl reduction for Sq2b
- `pushforwardComp_lax_μ` (private, line 2246) — the Sq2b residual, now CLOSED
- `pullbackComp_δ` (private, line 2307) — the Sq2b mate-calculus body, now CLOSED
- `toRingCatSheafHom_comp_hom_reconcile` (private, line 2121) — ring-map reconcile, rfl
- `isIso_pbu_of_final` (private, line 1028) — pbu isolation helper
- `tensorObj_middleFour` (private, line 738) — group-law helper
- `W_of_isIso_sheafification` (private, line 1376) — D2′ converse lemma

All of these are appropriate private helpers; the blueprint is not required to reference them.

---

## Blueprint adequacy for this file

### Coverage
The blueprint `\lean{...}` references all substantive public declarations. The private helpers (listed above) are internal and appropriately unreferenced.

### Proof-sketch depth
Adequate for the remaining open obligations (`exists_tensorObj_inverse`, `pullbackTensorMap_restrict` Sq1/Sq4). **One major adequacy issue**: the Sq2b proof description (see finding #1 below) is stale and no longer reflects the committed proof.

### Hint precision
Precise for all `\lean{...}`-tagged declarations. `pushforwardComp_lax_μ` has no `\lean{...}` tag (private), but is referenced by name in the proof text of `lem:pullback_tensor_map_basechange`.

### Generality
Matches the Lean file.

### Recommended chapter-side actions

1. **[MAJOR — immediate]** Correct the Sq2b proof description (blueprint lines ~4027–4035): replace the three named Mathlib primitives (`ModuleCat.restrictScalarsComp`, `ModuleCat.extendScalarsComp`, `ModuleCat.homEquiv_extendScalarsComp`) with the actual route: sectionwise (`hom_ext`) + pure-tensor (`tensor_ext`) reduction, `pushforward_μ_eq` (rfl foundation), `restrictScalars_μ_app` (rfl), and `ModuleCat.restrictScalars_μ_tmul` via the atom helpers `forget₂_restrictScalars_μ_hom_tmul` (inner leg) and `pushforward_map_restrictScalars_μ_app_tmul` (outer leg).

2. **[MAJOR — immediate]** Update the "genuinely missing ingredients" summary (blueprint lines ~4074–4085): remove Sq2b from the list of missing ingredients. The current text reads "The genuinely missing ingredients are therefore the Mathlib-absent monoidality Sq2b (pullbackComp) together with the composition coherences Sq1 (sheafificationCompPullback) and Sq4 (pullbackValIso)." After iter-260/261, Sq2b (`pullbackComp_δ` + `pushforwardComp_lax_μ`) is axiom-clean. The text should read: only Sq1 and Sq4 remain open.

---

## Severity summary

### Major findings

**Major #1 — stale Sq2b proof description (blueprint → Lean)**

Blueprint prose (lines ~4027–4035) describes `pushforwardComp_lax_μ` as proved by "a genuine `ModuleCat` change-of-rings calculation assembled from the Mathlib primitives `ModuleCat.restrictScalarsComp`, `ModuleCat.extendScalarsComp`, and `ModuleCat.homEquiv_extendScalarsComp`."

The **committed proof** (Lean lines 2246–2291) uses:
- `pushforward_μ_eq` — a `rfl` lemma; reduces `μ (pushforward φ)` to `μ (restrictScalars φ')`
- `restrictScalars_μ_app` — a `rfl` lemma (sectionwise form)
- `forget₂_restrictScalars_μ_hom_tmul` — pure-tensor collapse via `ModuleCat.restrictScalars_μ_tmul` (inner leg)
- `pushforward_map_restrictScalars_μ_app_tmul` — pure-tensor collapse via `ModuleCat.restrictScalars_μ_tmul` (outer leg, reindexed by `pushforward_map_app_apply`)

None of `ModuleCat.restrictScalarsComp`, `ModuleCat.extendScalarsComp`, or `ModuleCat.homEquiv_extendScalarsComp` appear in the proof. The proof does not use extension of scalars at all; it is a pure sectionwise + pure-tensor collapse on the `restrictScalars` μ. The blueprint both overstates the difficulty (by implying an extendScalarsComp construction is needed) and names primitives the proof does not use.

The declaration is already closed so this is not blocking, but it is stale and misleading to any reader trying to understand the proof structure.

**Major #2 — stale "Sq2b still missing" status (blueprint → Lean)**

Blueprint lines ~4074–4085 list "monoidality Sq2b" as one of three remaining genuinely missing ingredients for `pullbackTensorMap_restrict`. As of iter-259/261, Sq2b is **axiom-clean**: `pullbackComp_δ` (mate-calculus, ~90 lines) and its sole residual `pushforwardComp_lax_μ` are both proved with no sorry and no axioms. Only Sq1 (`SheafOfModules.sheafificationCompPullback` composition coherence) and Sq4 (`pullbackValIso` composition coherence) remain open.

A prover dispatched to work on `pullbackTensorMap_restrict` reading this passage would wrongly believe Sq2b needs work. The passage should be updated to reflect that only Sq1 and Sq4 are open.

### Overall verdict

Two major blueprint-prose inaccuracies: (1) wrong Mathlib primitives named for the committed `pushforwardComp_lax_μ` proof, (2) Sq2b listed as still missing when it is axiom-clean. Neither blocks downstream provers immediately (the closed declarations are done; the open obligations are `exists_tensorObj_inverse` and `pullbackTensorMap_restrict` Sq1/Sq4 which are correctly documented). No must-fix-this-iter issues found; 2 declarations with sorry bodies (`exists_tensorObj_inverse`, `pullbackTensorMap_restrict`) are known open obligations, not placeholder violations.
