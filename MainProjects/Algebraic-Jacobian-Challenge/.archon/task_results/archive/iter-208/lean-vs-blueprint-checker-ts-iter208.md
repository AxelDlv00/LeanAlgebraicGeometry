# Lean ↔ Blueprint Check Report

## Slug
ts-iter208

## Iteration
208

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)
- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.Modules.tensorObj` at L199
- **Signature matches**: yes — `{X : Scheme.{u}} (M N : X.Modules) : X.Modules`, lifting `PresheafOfModules.Monoidal.tensorObj` through sheafification; matches blueprint exactly
- **Proof follows sketch**: N/A (definition) — body is substantive (no sorry); uses `PresheafOfModules.sheafification` and `PresheafOfModules.Monoidal.tensorObj` as the blueprint specifies
- **notes**: `\leanok` on statement block at blueprint L182 is legitimate (substantive body present)

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes — L215
- **Signature matches**: yes — `{M M' N N' : X.Modules} (f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N'`; body is substantive via `PresheafOfModules.sheafification.map (tensorHom ...)`
- **Proof follows sketch**: yes — the blueprint says "inherited from `PresheafOfModules.Monoidal.tensorObj` under sheafification"; the Lean body does exactly that
- **notes**: Blueprint calls it a `lemma`; Lean defines it as a `def`. Minor category discrepancy only — mathematically the same content. `\leanok` on statement block at blueprint L220 is legitimate.

---

### `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` (chapter: `lem:restrictscalars_laxmonoidal`)
- **Lean target exists**: yes — `PresheafOfModules.restrictScalarsLaxMonoidal` instance at L147, with helpers `restrictScalarsLaxε` (L114) and `restrictScalarsLaxμ` (L130)
- **Signature matches**: yes — `(α : R ⋙ forget₂ CommRingCat RingCat ⟶ S ⋙ forget₂ CommRingCat RingCat) : (PresheafOfModules.restrictScalars α).LaxMonoidal`; matches the blueprint's statement
- **Proof follows sketch**: yes — sectionwise lift of `ModuleCat.restrictScalars`'s lax-monoidal structure, exactly as the blueprint describes
- **notes**: The `% NOTE:` in the blueprint (lines 339–345) correctly marks this as off the critical path for `lem:tensorobj_restrict_iso`. The Lean corroborates this: none of the later declarations in the file depend on `restrictScalarsLaxMonoidal`. `\leanok` on statement block at blueprint L334 is legitimate.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (chapter: `lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes — L330
- **Signature matches**: yes — `{X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] (M N : X.Modules) : (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`; matches blueprint statement
- **Proof follows sketch**: partial — Steps 1–3 are formalized and green (L335–399); Step 4 is a named `sorry` (L399). The blueprint's Step 3 + closing paragraph are **disproven** (see Must-fix §1 below).
- **notes**: `\leanok` on statement block at blueprint L401 is **legitimate**: the declaration exists with a sorry body; per the marker vocabulary, statement-block `\leanok` requires only "at least a sorry present." There is no `\leanok` in the proof block — correct, since the proof is not closed.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (chapter: `lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes — `tensorObj_isLocallyTrivial` (lemma) at L412
- **Signature matches**: yes — `{M N : X.Modules} (hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N) : LineBundle.IsLocallyTrivial (tensorObj M N)`
- **Proof follows sketch**: yes (structurally) — common affine open, restrict both trivialisations via `restrictIsoUnitOfLE`, transport through `tensorObj_restrict_iso` + `tensorObjIsoOfIso` + `tensorObj_unit_iso`. The body depends on `tensorObj_restrict_iso` which has a sorry, so this is transitively sorry, but the proof structure is correct.
- **notes**: `\leanok` on statement block at blueprint L544 is legitimate. Body has no explicit `sorry`; the transitive dependency on `tensorObj_restrict_iso`'s sorry is expected and does not affect the statement marker.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: `lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes — L438
- **Signature matches**: yes — `{L : X.Modules} (hL : LineBundle.IsLocallyTrivial L) : ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)`; matches blueprint (dual + contraction iso)
- **Proof follows sketch**: N/A — body is `:= sorry` (L442)
- **notes**: Blueprint claims a substantive proof (dual of a rank-one module is rank-one; contraction is an isomorphism affine-locally). This is a **placeholder sorry** on a substantive claim. `\leanok` on statement block at blueprint L650 is legitimate (declaration exists). See Red Flags below.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (chapter: `lem:tensorobj_lift_onproduct`)
- **Lean target exists**: yes — `tensorObjOnProduct` at L450
- **Signature matches**: yes — `(L L' : LineBundle.OnProduct πC πT) : LineBundle.OnProduct πC πT`, using `tensorObj_isLocallyTrivial`
- **Proof follows sketch**: partial — the Lean only provides the closure operation on the subtype; the blueprint's `% NOTE:` (lines 699–703) correctly flags that unit-membership, dual/inverse, and the associativity/unit/commutativity existence-of-iso facts are **not** delivered by `tensorObjOnProduct`. The Lean is consistent with this NOTE.
- **notes**: `\leanok` on statement block at blueprint L686 is legitimate.

---

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (chapter: `thm:rel_pic_addcommgroup_via_tensorobj`)
- **Lean target exists**: yes — L478
- **Signature matches**: yes — `(πC : C ⟶ S) (πT : T ⟶ S) : AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))`; matches blueprint
- **Proof follows sketch**: N/A — body is `:= sorry` (L481)
- **notes**: Blueprint claims a substantive construction (group law assembled from four existence-of-iso lemmas via `QuotientAddGroup`). This is a **placeholder sorry** on a substantive claim. `\leanok` on statement block at blueprint L797 is legitimate (declaration exists). See Red Flags below.

---

## Red Flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse` at L438–442: body is `:= sorry`. Blueprint (`lem:tensorobj_inverse_invertible`) claims a substantive proof (dual is rank-one locally; contraction is an iso affine-locally). Placeholder on a substantive claim — expected at this iteration (iter-202 scaffold, blocked on `tensorObj_restrict_iso`), but remains an open sorry.

- `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` at L478–481: body is `:= sorry`. Blueprint (`thm:rel_pic_addcommgroup_via_tensorobj`) claims a full `AddCommGroup` construction. Placeholder on a substantive claim — expected at this iteration, blocked on the four iso lemmas upstream.

- `AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso` at L330–399: proof body has `sorry` at L399 (Step 4 residual). Statement-level placeholder is legitimate per marker vocabulary; proof-level sorry is expected and acknowledged.

### Excuse-comments
None found that are actively misleading. The in-code comment at L358–398 is an accurate corrected analysis (iter-208 findings), not an excuse for wrong code. This is appropriate workflow documentation.

### Axioms / Classical.choice on non-trivial claims
None found.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` reference in the blueprint. All appear to be legitimate helpers:

| Declaration | Line | Status |
|---|---|---|
| `PresheafOfModules.restrictScalarsLaxε` | L114 | Helper for `restrictScalarsLaxMonoidal`; legitimately unreferenced |
| `PresheafOfModules.restrictScalarsLaxμ` | L130 | Helper for `restrictScalarsLaxMonoidal`; legitimately unreferenced |
| `AlgebraicGeometry.Scheme.Modules.tensorObjIsoOfIso` | L250 | Helper feeding `tensorObj_isLocallyTrivial`; not pinned but clearly named. Minor: could be promoted to a blueprint block as a supporting tool. |
| `AlgebraicGeometry.Scheme.Modules.tensorObj_unit_iso` | L266 | Helper feeding `tensorObj_isLocallyTrivial`; supports the unit-law step. Minor: same as above. |
| `AlgebraicGeometry.Scheme.Modules.restrictIsoUnitOfLE` | L284 | Helper for refining trivialisations; feeds `tensorObj_isLocallyTrivial`. Substantive (full proof, no sorry). Blueprint mentions the idea in the proof of `lem:tensorobj_preserves_locally_trivial` but doesn't pin a separate declaration. Minor: could be promoted. |

None of these are suspicious. `tensorObjIsoOfIso`, `tensorObj_unit_iso`, and `restrictIsoUnitOfLE` are each substantive enough to warrant mention in the blueprint's proof sketches but are not critical path omissions.

---

## Blueprint adequacy for this file

- **Coverage**: 8/8 blueprint-pinned Lean declarations have a corresponding `\lean{...}` block. 5 unreferenced helper declarations (all helpers — acceptable). Coverage is complete for pinned declarations.

- **Proof-sketch depth**: **under-specified** for `lem:tensorobj_restrict_iso`. The proof block Step 3 prose and the LOC estimates section both describe the disproven sectionwise-unfolding route; the `% NOTE:` flags the problem but the main prose has not been rewritten to the H1/H2 decomposition. A prover reading the chapter would be misled into attempting the nonexistent sectionwise formula.

  Additionally, the following secondary locations in the chapter repeat the disproven claim:
  1. **API survey section intro** (blueprint lines ~155–177): "The sole project-side ingredient is a bounded sectionwise unfolding of `PresheafOfModules.pullback φ` along the open immersion"
  2. **LOC estimates, Piece 2** (blueprint lines ~963–990): "the restriction-compatibility isomorphism `tensorObj_restrict_iso` — the single genuinely-hard ingredient — via the open-immersion sectionwise base change... The sole project-side ingredient is a bounded sectionwise unfolding of `PresheafOfModules.pullback φ`... Estimate: approximately 30–60 LOC"

- **Hint precision**: precise — all `\lean{...}` names resolve to declarations with matching signatures.

- **Generality**: matches need — no parallel API written to cover gaps.

- **Recommended chapter-side actions**:
  1. **(must-fix)** Rewrite Step 3 of the `lem:tensorobj_restrict_iso` proof block to the H1/H2 decomposition described in the Lean comment (L358–398) and in `informal/tensorObj_restrict_iso.md`. Remove the "sectionwise unfolding ~30–60 LOC" claim and replace with the accurate route: H1 = presheaf-level `pushforward β ≅ pullback φ` via `leftAdjointUniq`; H2 = strong-monoidal `restrictScalars` along ring iso. Update the LOC estimate to ~200–300 LOC across 4 absent ingredients.
  2. **(must-fix)** Rewrite the closing "30–60 line helper" paragraph in the proof (blueprint lines ~529–539) to describe the H1/H2 route and acknowledge the `mathlib-build` scale.
  3. **(major)** Update the **API survey section intro** (~lines 155–177) and the **LOC estimates Piece 2** (~lines 963–990) to remove the disproven sectionwise-unfolding claim and replace with the corrected H1/H2 analysis.
  4. **(minor)** Consider adding `\lean{...}` blocks for `tensorObjIsoOfIso`, `tensorObj_unit_iso`, and `restrictIsoUnitOfLE` as supporting helpers with short statements, so the blueprint's dependency chain is complete.

---

## `\leanok` legitimacy check on `lem:tensorobj_restrict_iso`

**Confirmed legitimate.** The Lean declaration `AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso` at L330 exists with a `sorry` body (L399). Per the marker vocabulary in CLAUDE.md: "statement block: declaration is formalized (at least a `sorry` present)." The `\leanok` appears in the *statement* block of `lem:tensorobj_restrict_iso` in the blueprint (line ~401), not in the proof block. There is no `\leanok` in the proof block — correct, because the proof is not closed. The `sync_leanok` mechanism would correctly place `\leanok` in the statement block (declaration exists with at least a sorry) and withhold it from the proof block (sorry present). No marker error.

---

## Severity summary

### Must-fix-this-iter

1. **Blueprint adequacy failure — disproven proof route still in main prose (Step 3 + closing paragraph).** The proof block of `lem:tensorobj_restrict_iso` asserts a "sectionwise unfolding of `PresheafOfModules.pullback φ`" route (~30–60 LOC) that the iter-208 prover proved is impossible (the functor is the opaque abstract left adjoint with no sectionwise formula). The `% NOTE:` at lines 429–444 flags this, but the main proof prose — Step 3 (lines 489–517) and the closing paragraph (lines 529–539) — has NOT been rewritten. A prover picking up this file is directed into a dead end. Per checker instructions: "blueprint prose still asserts a disproven proof route despite the NOTE" is a must-fix. The blueprint-writing subagent must rewrite Step 3 + closing paragraph to the H1/H2 decomposition.

### Major

2. **Secondary occurrences of disproven sectionwise claim.** Two additional sections of the chapter — the API survey intro (~lines 155–177) and the LOC estimates Piece 2 (~lines 963–990) — still describe the sectionwise-unfolding route as valid and estimate 30–60 LOC for it. These are not in the `% NOTE:`-annotated proof block and will mislead future readers. Both must be updated by the blueprint-writing subagent in the same rewrite pass.

### Minor

3. `tensorObj_functoriality` is declared as `def` in Lean (L215) but described as a `lemma` in the blueprint — no semantic mismatch, minor category inconsistency.

4. Three substantive helper declarations (`tensorObjIsoOfIso`, `tensorObj_unit_iso`, `restrictIsoUnitOfLE`) are unreferenced by `\lean{...}` pins in the blueprint; worth promoting to informal mention or lightweight `\lean{...}` blocks.

---

**Overall verdict**: The Lean file faithfully implements the blueprint-pinned declarations (all 8 `\lean{...}` targets exist with correct signatures; 3 expected sorry bodies); the critical must-fix is on the **blueprint side** — Step 3 of the `lem:tensorobj_restrict_iso` proof block and two secondary sections still assert the disproven sectionwise-unfolding route that the iter-208 prover refuted, blocking any further prover attempt on this lemma.

**8 declarations checked, 3 red flags** (2 placeholder sorries on substantive claims [expected, iteration-staged], 1 transitively-sorry proof [expected]).
