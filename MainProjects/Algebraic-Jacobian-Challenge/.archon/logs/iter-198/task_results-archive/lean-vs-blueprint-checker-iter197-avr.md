# Lean ↔ Blueprint Check Report

## Slug
iter197-avr

## Iteration
197

## Files audited
- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean` (1067 lines)
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex` (2992 lines)

---

## Per-declaration (iter-197 new helpers)

### `\lean{AlgebraicGeometry.Proj.basicOpenIsoSpec_inv_app_top}` (chapter: `lem:basicOpenIsoSpec_inv_app_top`)
- **Lean target exists**: yes — `lemma Proj.basicOpenIsoSpec_inv_app_top` at lines 234–253
- **Signature matches**: yes — both say the inverse of the canonical iso `basicOpenIsoSpec`, evaluated at `⊤`, equals `topIso.hom ≫ basicOpenIsoAway.inv ≫ (ΓSpecIso _).inv`
- **Proof follows sketch**: yes — blueprint says "invert via `Iso.inv_hom_id_assoc` cancellation on each factor in turn"; Lean uses `cancel_mono (appTop β.hom)` then two rounds of `Iso.inv_hom_id_assoc`. Mathematically equivalent.
- **notes**: Proof is complete (no sorry). Blueprint statement block has `\leanok`; proof block does NOT have `\leanok` despite proof being closed. Expected to be added by `sync_leanok`.

### `\lean{AlgebraicGeometry.Proj.awayι_app_basicOpen}` (chapter: `lem:awayi_app_basicOpen`)
- **Lean target exists**: yes — `lemma Proj.awayι_app_basicOpen` at lines 268–282
- **Signature matches**: yes — both say `(Proj.awayι 𝒜 f).app (Proj.basicOpen 𝒜 f) = basicOpenIsoAway.inv ≫ (ΓSpecIso _).inv ≫ (Spec _).presheaf.map (eqToHom (opensRange_awayι)).op`
- **Proof follows sketch**: yes — blueprint's 4-step proof (factor via `awayι_eq_specMap_fromSpec`, apply `Scheme.Hom.comp_app`, evaluate `fromSpec.app` via `Scheme.Opens.ι_app_self`, collapse eqToHom cascade) is implemented by the Lean `change → rw [comp_app, ι_app_self, app_eq _, basicOpenIsoSpec_inv_app_top] → aesop_cat` chain.
- **notes**: Proof complete; `\uses{lem:basicOpenIsoSpec_inv_app_top}` is correctly present and the Lean proof indeed calls `Proj.basicOpenIsoSpec_inv_app_top`. Blueprint statement block has `\leanok`; proof block has no `\leanok` (sync_leanok concern, not a blocking issue).

### `\lean{AlgebraicGeometry.Proj.awayι_appIso_top_inv}` (chapter: `lem:awayi_appIso_top_inv_apply_isLocElem`)
- **Lean target exists**: yes — `lemma Proj.awayι_appIso_top_inv` at lines 294–321
- **Signature matches**: yes (morphism-level) — both say `((Proj.awayι 𝒜 f f_deg hm).appIso ⊤).inv = (ΓSpecIso _).hom ≫ basicOpenIsoAway.hom ≫ (Proj 𝒜).presheaf.map (eqToHom (...)).op`. The `\lean{...}` pin was correctly updated in iter-197 from the old `_apply_isLocElem` name to `awayι_appIso_top_inv`.
- **Proof follows sketch**: yes — blueprint's Steps 1+2 (compute `.hom` via `appIso_hom`, flip via `Iso.comp_hom_eq_id`) match Lean's `Eq.symm; (Iso.comp_hom_eq_id _).mp; rw [appIso_hom, app_eq, awayι_app_basicOpen]; simp+slice+rw to collapse eqToHoms`.
- **notes**: Proof is complete (no sorry). **MAJOR SYNC GAP**: the statement block has **no** `\leanok` and the proof block has **no** `\leanok`, despite both the declaration and its proof being fully closed axiom-clean in Lean. The `\lean{...}` pin rename from the old name to `awayι_appIso_top_inv` likely prevented `sync_leanok` from matching on the previous label string. The label `lem:awayi_appIso_top_inv_apply_isLocElem` and its display text ("Point-value evaluation…") now misrepresent the actual content (morphism-level, not point-value), but the blueprint NOTE at line 1771–1775 acknowledges this. No `\uses{}` edges are broken: the label was not renamed, only the `\lean{...}` pin.

### `\lean{AlgebraicGeometry.iotaGm_chart1_appIso_eval}` (chapter: `lem:iotaGm_chart1_appIso_eval`)
- **Lean target exists**: yes — `private lemma iotaGm_chart1_appIso_eval` at lines 542–646
- **Signature matches**: yes — both describe the morphism-level equation `iotaGm_chart1_section ≫ gmScalingP1_chart kbar 1 = Spec.map(algMap) ≫ Spec.map(iso) ≫ Proj.awayι X_1`
- **Proof follows sketch**: partial — the blueprint stages 1–8 skeleton is largely reflected in the Lean code (all structural steps present); the residual `sorry` at line 646 is the exact `Proj.appIso` evaluation step the blueprint acknowledges as the pending residual.
- **notes**: `\leanok` is present on both statement and proof blocks (consistent with sorry being present). This consumer was **NOT** touched in iter-197; its sorry remains. The blueprint note at line 1884 (in the "Consumer dispatch" paragraph) says "The same recipe also closes the residual sorry inside `lem:iotaGm_chart1_appIso_eval`" — this is now a future-tense prediction that should be updated since the helpers are in scope but substitution was not applied.

---

## Red flags

### Placeholder / suspect bodies
- `kbarChart1Ring_specMap_fac` at line 438: `:= sorry` — expected (iter-197 partial structural advance; the blueprint acknowledges this as the current residual). The remaining sorry targets `onePt.left.app(D₊(X_1))` evaluation, which is substantive new content.
- `iotaGm_chart1_appIso_eval` at line 646: `:= sorry` — expected (known STUCK residual, unchanged iter-197).
- `genusZero_curve_iso_P1` at line 1008: `:= sorry` — expected (Riemann–Roch bridge; documented long-pole).

### Excuse-comments
None new. The iter-197 inline comments (lines 416–438) accurately narrate structural status without excusing wrong code — they correctly describe steps 1+2 as landed and step 4 as out of scope for this iteration.

---

## Blueprint adequacy for this file

### Directive questions answered

**Q1 — Bidirectional check: Lean → blueprint and blueprint → Lean:**

All three new helpers have matching `\lean{...}` pins:
- `lem:basicOpenIsoSpec_inv_app_top` → `AlgebraicGeometry.Proj.basicOpenIsoSpec_inv_app_top` ✓
- `lem:awayi_app_basicOpen` → `AlgebraicGeometry.Proj.awayι_app_basicOpen` ✓
- `lem:awayi_appIso_top_inv_apply_isLocElem` → `AlgebraicGeometry.Proj.awayι_appIso_top_inv` ✓ (renamed, pin updated)

Blueprint → Lean rename (`lem:awayi_appIso_top_inv_apply_isLocElem`): The prover built the morphism-level form (`awayι_appIso_top_inv`) instead of the blueprint's originally-named point-value form (`_apply_isLocElem`). The blueprint correctly updated its `\lean{...}` pin and added a NOTE. The label name, however, is stale (still says "point-value"); this is a cosmetic mismatch worth a future clean-up.

**Q2 — Are iter-196/197 "Status" notes describing the `Proj.appIso` blocker now stale?**

The "Consumer dispatch (iter-196 prover)" paragraph at blueprint lines 1858–1888 is **partially stale**. It describes a 3-step closure strategy for `kbarChart1Ring_specMap_fac`. Iter-197's actual result: step 1 (`rw [Proj.awayι_appIso_top_inv]`) was applied (substituting the morphism-level form), but the residual was NOT the ring-map identity the blueprint predicted — instead, the new residual is `onePt.left.app(D₊(X_1))` evaluation (`Proj.fromOfGlobalSections.app`), which requires substantive project-side reasoning (~50–100 LOC). The paragraph needs updating to reflect: helpers in scope, step 1 applied, residual shifted to `onePt.left.app(D₊(X_1))` evaluation.

**Q3 — `iotaGm_chart1_appIso_eval` (consumer #2): does its blueprint entry need a note?**

Yes: a **minor** update is warranted. The blueprint's consumer-dispatch prediction at line 1884 says the recipe "also closes" this sorry, but iter-197 did not apply the helper substitution to `iotaGm_chart1_appIso_eval`. The helpers are now in scope; a note clarifying "helpers landed iter-197, substitution not yet applied" would accurately track the state.

**Q4 — `\uses{}` chain integrity after rename:**

**No broken edges.** The rename affected only the `\lean{...}` pin, not the `\label{...}` (`lem:awayi_appIso_top_inv_apply_isLocElem` is unchanged). All `\uses{}` edges that reference this label still resolve correctly:
- `lem:awayi_app_basicOpen \uses lem:basicOpenIsoSpec_inv_app_top` ✓
- `lem:awayi_appIso_top_inv_apply_isLocElem \uses lem:awayi_app_basicOpen` ✓
- No external `\uses{lem:awayi_appIso_top_inv_apply_isLocElem}` found that would now be dangling.

**Coverage:**
- 5 public non-trivial helpers have `\lean{...}` blueprint entries: `awayι_preimage_basicOpen_self`, `awayι_eq_specMap_fromSpec`, `basicOpenIsoSpec_inv_app_top`, `awayι_app_basicOpen`, `awayι_appIso_top_inv`. All match. ✓
- 12 private helpers (`iotaGm_r_1_*`, `kbarChart1Ring*`, `iotaGm_*`, `morphism_P1_to_grpScheme_const_aux`) correctly have no blueprint `\lean{}` pin.
- `iotaGm_chart1_appIso_eval` is `private` but has a `\lean{...}` blueprint entry — pre-existing situation, not iter-197-introduced.

**Proof-sketch depth**: adequate for the three new helpers (blueprint provides LOC estimates and step-by-step recipes). The "Consumer dispatch" paragraph is now under-specified (predicted 3-step closure that only partially applied), which is a **major** blueprint adequacy issue.

**Hint precision**: precise for the three new helpers (morphism-level form correctly pinned). Minor: the label title of `lem:awayi_appIso_top_inv_apply_isLocElem` still says "point-value" though the content is morphism-level.

**Generality**: matches need — all three new helpers are stated for a general graded ring `𝒜`, matching what the Lean file implements.

---

## Unreferenced declarations (informational)

All 12 private helpers are unreferenced from blueprint `\lean{...}` blocks. None of them have names that suggest they should be blueprint-tracked:
- `iotaGm_r_1_range_subset`, `iotaGm_r_1`, `iotaGm_r_1_fac`: sub-task building blocks
- `kbarChart1Ring`, `kbarChart1Ring_specMap_fac`, `iotaGm_r_1_eq_specMap`: internal chain
- `iotaGm_inner_lift_compat`, `iotaGm_chart1_section`: pullback construction helpers
- `iotaGm_chart1_composition_isOpenImmersion`, `iotaGm_range_isOpen`, `iotaGm_isDominant`: dominance chain helpers
- `morphism_P1_to_grpScheme_const_aux`: pointed helper for the main theorem

`kbarChart1Ring_specMap_fac` is mentioned in the "Consumer dispatch" prose but intentionally has no `\lean{...}` pin (private).

---

## Severity summary

**must-fix-this-iter**: None. No placeholder bodies on blueprint-claimed substantive declarations, no signature mismatches, no excuse-comments on real definitions, no unauthorized axioms. The three sorrys are at pre-acknowledged positions (`kbarChart1Ring_specMap_fac`, `iotaGm_chart1_appIso_eval`, `genusZero_curve_iso_P1`).

**major**:
1. `lem:awayi_appIso_top_inv_apply_isLocElem` statement and proof blocks have **no `\leanok`** despite the Lean declaration `Proj.awayι_appIso_top_inv` being fully closed and axiom-clean. The `\lean{...}` rename in iter-197 likely prevented `sync_leanok` from recognizing the match. Review agent should force a `sync_leanok` re-scan or add the markers manually.
2. "Consumer dispatch" paragraph (blueprint lines 1858–1888) is stale: its 3-step closure prediction for `kbarChart1Ring_specMap_fac` partially failed (step 1 applied but residual is `onePt.left.app(D₊(X_1))`, not a clean ring-map identity). The blueprint should be updated to describe the actual iter-197 residual.

**minor**:
1. `lem:awayi_appIso_top_inv_apply_isLocElem` display title ("Point-value evaluation") is stale — the actual content is morphism-level. The blueprint NOTE acknowledges this but the label text itself has not been updated.
2. Helpers 1 and 2 (`basicOpenIsoSpec_inv_app_top`, `awayι_app_basicOpen`) have `\leanok` on statement blocks but not on proof blocks, despite both proofs being closed. `sync_leanok` should add them; low-priority.
3. Blueprint note at line 1884 ("The same recipe also closes the residual sorry inside `lem:iotaGm_chart1_appIso_eval`") should be updated to note that helpers are in scope (iter-197) but substitution not yet applied.

**Overall verdict**: Three new iter-197 helpers land with correct blueprint pins and complete proofs; the `\uses{}` chain is intact; one `sync_leanok` gap (missing `\leanok` for the renamed third helper) requires review-agent attention; the consumer-dispatch paragraph needs a status update to reflect the new `onePt.left.app(D₊(X_1))` residual that emerged after helper substitution — 5 declarations checked, 0 critical red flags, 2 major sync/stale-prose findings.
