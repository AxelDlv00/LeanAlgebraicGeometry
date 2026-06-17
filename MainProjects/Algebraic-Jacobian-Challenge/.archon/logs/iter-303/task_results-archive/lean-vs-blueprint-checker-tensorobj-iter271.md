# Lean ↔ Blueprint Check Report

## Slug
tensorobj-iter271

## Iteration
271

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (2911 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (>6000 lines)

---

## Per-declaration (selected `\lean{}` pins resolved to this file)

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)
- **Lean target exists**: yes (line 166)
- **Signature matches**: yes
- **Proof follows sketch**: yes (sheafification of `PresheafOfModules.Monoidal.tensorObj`)
- **notes**: fully defined, no sorry; blueprint `\leanok` on both statement and proof blocks ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes (line 181)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: fully defined, no sorry ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (chapter: `lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes (line 451)
- **Signature matches**: yes
- **Proof follows sketch**: yes (4-step composite: `restrictFunctorIsoPullback` → `sheafificationCompPullback` → strip outer sheafification → H1∘H2)
- **notes**: axiom-clean, no sorry; blueprint `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (chapter: `lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes (line 541)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (chapter: `lem:tensorobj_assoc_iso`)
- **Lean target exists**: yes (line 346)
- **Signature matches**: yes — unconditional, no flatness hypothesis
- **Proof follows sketch**: yes (route (d): W-whisker localizer + presheaf associator under sheafification)
- **notes**: axiom-clean, unconditional as blueprint states ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor}` / `tensorObj_right_unitor` (chapter: `lem:tensorobj_unit_iso`)
- **Lean target exists**: yes (lines 297, 307)
- **Signature matches**: yes
- **notes**: axiom-clean ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (chapter: `lem:tensorobj_comm_iso`)
- **Lean target exists**: yes (line 317)
- **Signature matches**: yes
- **notes**: axiom-clean ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: `lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes (line 698)
- **Signature matches**: yes
- **Proof follows sketch**: N/A — body is `sorry`
- **notes**: Blueprint carries `\leanok` on **statement block only** (correct: declaration present, sorry in body). Blueprint **proof block has NO `\leanok`** (correct: proof not closed). Blueprint prose accurately describes the blocked C-bridge (`dual_isLocallyTrivial`) and A-bridge (`homOfLocalCompat`) as the two remaining steps. No mismatch. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (chapter: `def:scheme_modules_isinvertible`)
- **Lean target exists**: yes (line 194)
- **Signature matches**: yes — existential tensor-inverse predicate, designated unit `SheafOfModules.unit`
- **notes**: axiom-clean ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup}` / `picCommGroup` (chapter: `def:pic_carrier` / `thm:pic_commgroup`)
- **Lean target exists**: yes (lines 792, 826)
- **Signature matches**: yes — quotient of `⊗`-invertible modules by isomorphism; `CommGroup` instance
- **notes**: axiom-clean (uses only `Classical.choice`/`Quot.sound`/`propext`) ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap}` (chapter: `lem:pullback_tensor_map`)
- **Lean target exists**: yes (line 1218)
- **Signature matches**: yes — comparison map `f^*(M⊗N) ⟶ f^*M ⊗ f^*N` (not asserted iso in general)
- **notes**: axiom-clean, no sorry ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}` (chapter: `lem:pullback_tensor_map_natural`)
- **Lean target exists**: yes (line 2051)
- **Signature matches**: yes
- **Proof follows sketch**: yes — 4-square paste (S1 NatTrans naturality, S2 `δ_natural`, S3 `sheafifyTensorUnitIso_hom_natural`, S4 `pullbackValIso_hom_natural`)
- **notes**: CLOSED axiom-clean (iter-255); blueprint `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` (chapter: `lem:pullback_unit_iso`)
- **Lean target exists**: yes (line 1058)
- **Signature matches**: yes
- **notes**: CLOSED axiom-clean (iter-241) ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso}` (chapter: `lem:pullback_tensor_iso_unit`)
- **Lean target exists**: yes (line 1895)
- **Signature matches**: yes
- **notes**: CLOSED axiom-clean (iter-250) ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp}` (chapter: `lem:unitToPushforwardObjUnit_comp`)
- **Lean target exists**: yes (line 874)
- **Signature matches**: yes
- **notes**: axiom-clean (`rfl` sectionwise) ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` (chapter: `lem:pullbackObjUnitToUnit_comp`)
- **Lean target exists**: yes (line 915)
- **Signature matches**: yes — composition coherence of `pullbackObjUnitToUnit` via mate transport
- **notes**: axiom-clean (iter-240) ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` (chapter: `lem:pullback_tensor_map_basechange`)
- **Lean target exists**: yes (line 2807)
- **Signature matches**: yes — composition coherence `δ_sheaf^{h∘f} = pullbackComp.inv ≫ h^*(δ^f) ≫ δ^h ≫ tensorObjIsoOfIso`
- **Proof follows sketch**: partial — proof opened to paste-ready form (simp/rw to expose 4-square goal); **sorry at end** (line 2902)
- **notes**: Blueprint carries `\leanok` on **statement block only** (correct). Blueprint **proof block has NO `\leanok`** (correct: proof not closed). Residual = Sq1 `sheafificationCompPullback_comp` + Sq4 `pullbackValIso` coherence. ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_eq_leftAdjointUniq}` (chapter: `lem:sheafification_comp_pullback_eq_leftadjointuniq`)
- **Lean target exists**: yes (line 1603)
- **Signature matches**: yes
- **notes**: CLOSED axiom-clean; blueprint `\leanok` on both blocks ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.leftAdjointUniqUnitEta}` (chapter: `lem:leftadjointuniq_app_unit_eta`)
- **Lean target exists**: yes (line 1623)
- **notes**: CLOSED axiom-clean ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.leftAdjointUniqUnitEta_app}` (chapter: `lem:leftadjointuniq_app_unit_eta_general`)
- **Lean target exists**: yes (line 1668)
- **notes**: CLOSED axiom-clean; the P-general form of the step-1 brick ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.epsilonPresheafToSheafUnit}` (chapter: `lem:epsilon_presheaf_to_sheaf_unit`)
- **Lean target exists**: yes (line 1718)
- **notes**: CLOSED axiom-clean ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackLanDecomposition}` (chapter: `lem:pullback_lan_decomposition`)
- **Lean target exists**: yes (line 1311)
- **notes**: axiom-clean; marked OFF-PATH (abandoned general route) ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafPushforwardLaxMonoidal}` (chapter: `lem:presheaf_pushforward_laxmonoidal`)
- **Lean target exists**: yes (line 1129)
- **notes**: axiom-clean; instance form ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafPullbackOplaxMonoidal}` (chapter: `lem:presheaf_pullback_oplaxmonoidal`)
- **Lean target exists**: yes (line 1151)
- **notes**: axiom-clean ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_restrict}` (chapter: `lem:isiso_of_isiso_restrict`)
- **Lean target exists**: yes (line 572)
- **notes**: axiom-clean B-connector ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.homMk}` (chapter: `def:scheme_modules_homMk`)
- **Lean target exists**: yes (line 613)
- **notes**: axiom-clean ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.dual}` (chapter: `lem:internal_hom_isSheaf`)
- **Lean target exists**: yes (line 222)
- **notes**: axiom-clean ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.dualIsoOfIso}` (chapter: `lem:dual_of_iso`)
- **Lean target exists**: yes (line 233)
- **notes**: axiom-clean ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso_invertible}` (chapter: `lem:tensorobj_assoc_iso_invertible`)
- **Lean target exists**: yes (line 734)
- **notes**: trivial delegation to unconditional `tensorObj_assoc_iso` ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.tensorObj}` (chapter: `lem:isinvertible_tensor`)
- **Lean target exists**: yes (line 756)
- **notes**: axiom-clean ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.isInvertible_unit}` (chapter: `lem:isinvertible_unit`)
- **Lean target exists**: yes (line 766)
- **notes**: axiom-clean ✓

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible.inverse_unique}` (chapter: `lem:isinvertible_inverse_welldef`)
- **Lean target exists**: yes (line 773)
- **notes**: axiom-clean ✓

---

## Red flags

### Placeholder / suspect bodies
- `exists_tensorObj_inverse` at line 720: body is `:= sorry`. Blueprint statement block has `\leanok` (correct — "at least sorry present"); blueprint proof block has **no `\leanok`** (correct — proof not closed). The blueprint explicitly documents this as infrastructure-blocked (pending C-bridge `dual_isLocallyTrivial` and A-bridge `homOfLocalCompat`). **Not a violation** — the `\leanok` marker is only on the statement, not the proof.
- `sheafificationCompPullback_comp_tail` at line 2674: body has `sorry` as its last tactic. This is a **private** lemma with NO `\lean{}` pin in the blueprint; it is described in the proof prose of `pullbackTensorMap_restrict`. No blueprint-side completion claim. **Not a violation**.
- `pullbackTensorMap_restrict` at line 2902: body ends with `sorry`. Blueprint statement has `\leanok` (correct); blueprint proof has **no `\leanok`** (correct). **Not a violation**.

### Excuse-comments
None that falsely characterize state. All sorry-body comments accurately describe what remains and why.

### Axioms / Classical.choice on non-trivial claims
No unauthorized `axiom` declarations found. `Classical.choice` appears only in `picInv` (choosing the inverse witness from `IsInvertible`'s existential), which is exactly what the blueprint authorizes.

---

## Unreferenced declarations (informational)

The following declarations in `TensorObjSubstrate.lean` have no `\lean{}` pins in the blueprint. Most are appropriate private helpers:

**Private sub-lemmas (appropriate, not pinned):**
- `sheafificationCompPullback_comp` (line 2687) — private; mentioned as sub-lemma in blueprint prose of `pullbackTensorMap_restrict` proof. Fine.
- `sheafificationCompPullback_comp_tail` (line 2536) — private; described in blueprint prose. Fine.
- `sheaf_unit_comp_pushforward_pullbackComp_inv` (line 2482) — private building block.
- `forget_map_pushforward_map` (line 2511) — private bridge (`rfl`).
- `sheafifyTensorUnitIso` (line 1076) — private monoidal-unit reconciliation iso.
- `sheafifyUnitIso` (line ~1504) — private codomain-identification helper.
- `pullbackObjUnitToUnitIso` / `pullbackObjUnitToUnitIso_hom` (lines 1041, 1048) — private bundled-iso helpers.
- `isIso_pbu_of_final` (line 1033) — private TC-isolation helper.
- `isIso_sheafify_tensorHom_pullbackValIso` (line 1332) — private.
- `W_of_isIso_sheafification` (line 1381) — private converse of `isIso_sheafification_map_of_W`.
- `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` (line 1407) — private D2' δ-wrapping.
- `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` (line 1456) — private D2' assembly.
- `toRingCatSheafHom_comp_hom_reconcile` (line 2165) — private ring-map reconciliation.
- `restrictScalars_μ_app`, `forget₂_restrictScalars_μ_hom_tmul`, etc. — private Sq2b helpers.
- `picSetoid` (line 785) — foundational for `PicGroup`; might benefit from blueprint mention but not critical.
- Various `pullback₀`/`extendScalars` D1 helpers (lines 1265–1318) — marked off-path.

**Notable omission (minor):**
- `pullbackValIso` (line 1201) — the per-object form of `sheafificationCompPullback`. Not `\lean{}`-pinned but is a building block referenced in the blueprint prose.

---

## Blueprint adequacy for this file

- **Coverage**: ~35/35 substantive `\lean{}`-pinned declarations in this file have corresponding blueprint entries. Helper-only declarations: ~20 (acceptable). Absent-from-Lean entries: 7, all annotated with `% NOTE:`. TODO-namespace placeholders: 2, annotated.
- **Proof-sketch depth**: **adequate** for still-open declarations. Specifically:
  - `sheafificationCompPullback_comp_tail`: The blueprint (§`lem:pullback_tensor_map_basechange` proof, lines ~4150–4260) provides a 5-step assembly (a)–(e) with explicit intermediate goals, names the binding obligation (`forget ∘ pushforward^sheaf = pushforward^pre ∘ forget`, isolated as `forget_map_pushforward_map`), names the recovery lemma (`leftAdjointUniqUnitEta_app` for steps (c)), and explicitly identifies the circularity trap (do NOT re-transpose the LHS). The iter-271 step (i) distribution and `hwr` device are reflected in the Lean tactic comments. This level of detail is **sufficient to guide the remaining ~40-60 LOC mate-calculus close**.
  - `pullbackTensorMap_restrict`: 4-square structure (Sq1/Sq2b/Sq3/Sq4) described with individual proof obligations. Sq4 dependency on Sq1 noted explicitly.
  - `exists_tensorObj_inverse`: infrastructure-blocked state accurately described.
- **Hint precision**: **precise**. All `\lean{}` pins name exact qualified identifiers.
- **Generality**: **matches need**. No under-specification found.
- **Recommended chapter-side actions**: none — all gaps are expected (pending formalization).

---

## Iter-271 specific check (directive points)

### Does the blueprint mark any still-open declaration as complete?

**No.** The three sorry-bearing declarations have `\leanok` only on their **statement blocks** (meaning "declaration formalized, at least sorry present" per the marker vocabulary in `CLAUDE.md`). None of their **proof blocks** carry `\leanok`. Specifically:
- `exists_tensorObj_inverse`: statement `\leanok` ✓; proof block no `\leanok` ✓.
- `pullbackTensorMap_restrict`: statement `\leanok` ✓; proof block no `\leanok` ✓.
- `sheafificationCompPullback_comp_tail`: not `\lean{}`-pinned at all; no completion claim.

### Is the chapter prose detailed enough to guide the remaining mate-calculus close?

**Yes.** The blueprint's description of `sheafificationCompPullback_comp_tail` at §`lem:pullback_tensor_map_basechange` proof (lines ~4150–4260) is the most detailed blueprint prose in the chapter: it gives the 5-step assembly with explicit naming, identifies the binding obligation precisely, warns against the circularity trap, and documents the iter-271 step (i) distribution as committed. The `conjugateEquiv_whiskerRight` device (`hwr`) is reflected in the Lean tactic at line 2667. The remaining residual (`homEquiv.injective` transposition → `hwr` + `unit_conjugateEquiv` + `conjugateEquiv_comp`) is explicitly named in both the Lean tactic comment (lines 2660–2666) and corresponds to the blueprint's step (c)–(e) description. The prose is adequate.

### Every `\lean{...}` in the chapter resolves to a real declaration?

**Yes, with expected exceptions (all annotated):** All 7 absent targets carry `% NOTE: \lean{} pin target absent from Lean source as of iter-271 (verified by grep)` annotations. No stale renames found. The `AlgebraicGeometry.TODO.*` namespace stubs (2 entries) are annotated as "TODO placeholder per DAG integrity rule 1" and do not correspond to real declarations by design.

**One minor relocation note:** `tensorObjOnProduct` (blueprint `\lean{}` at line 1787) lives in `RelPicFunctor.lean`, not `TensorObjSubstrate.lean`. This was an iter-247 import-cycle fix documented in TensorObjSubstrate.lean's module docstring (line 107). The blueprint proof block has `\leanok` (correct, since the declaration compiles there). The `sync_leanok` resolves by name across all files. Not a pin defect.

### Any declaration the chapter promises that's missing from the Lean file?

**No new missing declarations beyond the 7 expected future targets annotated in the blueprint.** All `\lean{}`-pinned declarations for completed/in-progress work exist in the Lean source (either in `TensorObjSubstrate.lean` or its imported sub-files).

---

## Severity summary

- **must-fix-this-iter**: none
- **major**: none
- **minor**: `tensorObjOnProduct` relocated to `RelPicFunctor.lean` but still blueprint-pinned in the TensorObjSubstrate chapter — documented in module docstring, sync_leanok handles correctly; no action needed.

**Overall verdict**: The Lean file and blueprint chapter are fully consistent for iter-271 — all three sorry-bearing declarations are correctly reflected as statement-`\leanok`-only (proof not closed), the `% NOTE:` annotations accurately catalog 7 forward-reference targets, and the proof prose for the remaining `sheafificationCompPullback_comp_tail` mate-calculus work is sufficiently detailed to guide the ~40-60 LOC close. No must-fix findings. 3 declarations checked with active sorries; 0 blueprint-marked-complete but sorry-carrying declarations found.
