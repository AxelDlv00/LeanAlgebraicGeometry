# Lean ↔ Blueprint Check Report

## Slug
snap-iter055

## Iteration
055

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/SectionGradedRing.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_SectionGradedRing.tex`

---

## Per-declaration

### `\lean{PresheafOfModules.monoidalCategory}` (chapter: `lem:presheafModule_monoidal_mathlib`, `\mathlibok`)
- **Lean target exists**: N/A — Mathlib-provided, not a project declaration.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly marks `\mathlibok`, no project obligation.

### `\lean{PresheafOfModules.sheafification}` (chapter: `lem:presheafModule_sheafification_mathlib`, `\mathlibok`)
- **Lean target exists**: N/A — Mathlib-provided.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A

### `\lean{SheafOfModules.unit}` (chapter: `lem:moduleUnit_mathlib`, `\mathlibok`)
- **Lean target exists**: N/A — Mathlib-provided.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.Scheme.Modules.MonoidalPresheaf}` (chapter: `def:monoidalPresheaf`, `\leanok`)
- **Lean target exists**: yes — `private abbrev MonoidalPresheaf` at line 79.
- **Signature matches**: yes — defined as `PresheafOfModules (X.sheaf.obj ⋙ forget₂ CommRingCat RingCat)`, matching the blueprint prose (the presheaf of modules form needed by the Mathlib monoidal instance).
- **Proof follows sketch**: N/A (definition)
- **notes**: Declaration is `private`. Blueprint `\lean{...}` names it with full qualification, but `private` means external code cannot access it by name. Content is correct; visibility mismatch is minor.

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafification}` (chapter: `def:schemeModuleSheafification`, `\leanok`)
- **Lean target exists**: yes — `noncomputable def sheafification` at line 70.
- **Signature matches**: yes — `X.PresheafOfModules ⥤ X.Modules`, specialised to `𝟙 X.ringCatSheaf.obj`, matching blueprint.
- **Proof follows sketch**: N/A (definition body is direct application of Mathlib functor)

### `\lean{AlgebraicGeometry.Scheme.Modules.unitModule}` (chapter: `def:unitModule`, `\leanok`)
- **Lean target exists**: yes — `private noncomputable abbrev unitModule` at line 94.
- **Signature matches**: yes — `SheafOfModules.unit X.ringCatSheaf`, matching blueprint's "unit module = structure sheaf as module over itself".
- **Proof follows sketch**: N/A
- **notes**: `private abbrev` — same visibility note as `MonoidalPresheaf`.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:sheafTensorObj`, `\leanok`)
- **Lean target exists**: yes — `noncomputable def tensorObj` at line 86.
- **Signature matches**: yes — `F G : X.Modules → X.Modules`, sheafification of presheaf-level tensor. Matches `def:sheafTensorObj` exactly.
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow}` (chapter: `def:sheafTensorPow`, `\leanok`)
- **Lean target exists**: yes — `noncomputable def tensorPow` at line 100.
- **Signature matches**: yes — `L : X.Modules → ℕ → X.Modules`, recursive definition with `tensorPow L 0 = unitModule X` and `tensorPow L (m+1) = tensorObj (tensorPow L m) L`. Matches blueprint exactly.
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow_zero}` (chapter: `lem:tensorPow_zero`, `\leanok`)
- **Lean target exists**: yes — `@[simp] private lemma tensorPow_zero` at line 104.
- **Signature matches**: yes — `tensorPow L 0 = unitModule X`. Matches blueprint.
- **Proof follows sketch**: yes (rfl, base clause of recursion)
- **notes**: `private` lemma referenced from blueprint with full qualified name.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow_succ}` (chapter: `lem:tensorPow_succ`, `\leanok`)
- **Lean target exists**: yes — `@[simp] private lemma tensorPow_succ` at line 106.
- **Signature matches**: yes — `tensorPow L (m+1) = tensorObj (tensorPow L m) L`. Matches blueprint.
- **Proof follows sketch**: yes (rfl)
- **notes**: `private` lemma — same visibility note.

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow}` (chapter: `def:sheafModuleTwist`, `\leanok`)
- **Lean target exists**: yes — `noncomputable def moduleTensorPow` at line 112.
- **Signature matches**: yes — `F L : X.Modules → ℕ → X.Modules`, `tensorObj F (tensorPow L m)`. Matches "m-twist F(m) = F ⊗ L^{⊗m}".
- **Proof follows sketch**: N/A

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow_zero}` (chapter: `lem:moduleTensorPow_zero`, `\leanok`)
- **Lean target exists**: yes — `@[simp] private lemma moduleTensorPow_zero` at line 115.
- **Signature matches**: yes — `moduleTensorPow F L 0 = tensorObj F (unitModule X)`. Matches blueprint.
- **Proof follows sketch**: yes (rfl)
- **notes**: `private` lemma — same visibility note.

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCounitIso}` (chapter: `def:sheafificationCounitIso`, `\leanok`)
- **Lean target exists**: yes — `private noncomputable def sheafificationCounitIso` at line 131.
- **Signature matches**: yes — `G : X.Modules → sheafification.obj ((toPresheafOfModules X).obj G) ≅ G`. Matches blueprint's "counit isomorphism (G)^# ≅ G".
- **Proof follows sketch**: yes (uses `asIso` of adjunction counit, which is invertible by full faithfulness of the right adjoint)
- **notes**: `private` def — same visibility note.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjUnitIso}` (chapter: `def:tensorObjUnitIso`, `\leanok`)
- **Lean target exists**: yes — `private noncomputable def tensorObjUnitIso` at line 140.
- **Signature matches**: yes — `G : X.Modules → tensorObj (unitModule X) G ≅ G`. Matches "left-unitor 1_X ⊗ G ≅ G".
- **Proof follows sketch**: yes (presheaf left unitor through sheafification.mapIso + counit iso)
- **notes**: `private` — same visibility note.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjRightUnitor}` (chapter: `def:tensorObjRightUnitor`, `\leanok`)
- **Lean target exists**: yes — `private noncomputable def tensorObjRightUnitor` at line 151.
- **Signature matches**: yes — `G : X.Modules → tensorObj G (unitModule X) ≅ G`. Matches "right-unitor G ⊗ 1_X ≅ G".
- **Proof follows sketch**: yes
- **notes**: `private` — same visibility note.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorBraiding}` (chapter: `def:tensorBraiding`, `\leanok`)
- **Lean target exists**: yes — `private noncomputable def tensorBraiding` at line 164.
- **Signature matches**: yes — `F G : X.Modules → tensorObj F G ≅ tensorObj G F`. Matches "braiding F ⊗ G ≅ G ⊗ F".
- **Proof follows sketch**: yes (presheaf braiding through sheafification.mapIso)
- **notes**: `private` — same visibility note.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_map_iff}` (chapter: `lem:isIso_sheafification_map_iff`, `\leanok`)
- **Lean target exists**: yes — `lemma isIso_sheafification_map_iff` at line 218.
- **Signature matches**: yes — `{P Q : X.PresheafOfModules} (f : P ⟶ Q) : IsIso (sheafification.map f) ↔ (opensTopology X).W ((toPresheaf X.ringCatSheaf.obj).map f)`. Matches "sheafification of f is iso iff underlying abelian morphism is in J.W".
- **Proof follows sketch**: yes (uses `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`)

### `\lean{AlgebraicGeometry.Scheme.Modules.localIso_toPresheaf_map_unit}` (chapter: `lem:localIso_toPresheaf_map_unit`, `\leanok`)
- **Lean target exists**: yes — `lemma localIso_toPresheaf_map_unit` at line 243.
- **Signature matches**: yes — unit map of module sheafification has underlying abelian morphism in J.W. Matches blueprint.
- **Proof follows sketch**: yes (via `toPresheaf_map_sheafificationAdjunction_unit_app` + `W_toSheafify`)

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_map_unit}` (chapter: `lem:isIso_sheafification_map_unit`, `\leanok`)
- **Lean target exists**: yes — `lemma isIso_sheafification_map_unit` at line 255.
- **Signature matches**: yes — `IsIso (sheafification.map (adjunction.unit.app P))`. Matches "sheafification inverts the localization unit".
- **Proof follows sketch**: yes

### `\lean{TensorProduct.liftAddHom}` (chapter: `lem:tensorProduct_liftAddHom_mathlib`, `\mathlibok`)
- **Lean target exists**: N/A — Mathlib-provided.
- **Signature matches**: N/A

### `\lean{AlgebraicGeometry.Scheme.Modules.RelativeTensorCoequalizer.isColimitCofork}` (and all `RelativeTensorCoequalizer.*`) (chapter: `lem:relativeTensor_objectwise_coequalizer`, `\leanok`)
- **Lean target exists**: yes — all 21 declarations listed in the `\lean{...}` block are present in `namespace RelativeTensorCoequalizer`.
- **Signature matches**: yes — `isColimitCofork` proves `M ⊗[S] N` is the coequalizer in `AddCommGrpCat` of `aL` and `aR`, matching blueprint exactly.
- **Proof follows sketch**: yes — uses `TensorProduct.liftAddHom` for descent (existence) and `cancel_epi (piMor)` for uniqueness, exactly as the blueprint proof prescribes.
- **notes**: The blueprint's `\lean{...}` block is thorough, listing all helpers plus the main colimit result. No discrepancy.

### `\lean{AlgebraicGeometry.Scheme.Modules.sectionsMul}` (chapter: `def:sectionMul`, `\leanok`)
- **Lean target exists**: yes — `noncomputable def sectionsMul` at line 188.
- **Signature matches**: partial. Blueprint states domain is `Γ(X,F) ⊗_{Γ(X,𝒪_X)} Γ(X,G)`; Lean type shows the isomorphic-but-distinct form `(presheaf tensor product)(X)`. The docstring in the Lean file explains this is definitionally equal by the objectwise formula. Mathematical content matches; Lean presentation is more concrete.
- **Proof follows sketch**: N/A (definition — pure sheafification-unit naturality, axiom-clean as stated)

### `\lean{AlgebraicGeometry.Scheme.Modules.relativeTensorCoequalizerIso}` (chapter: `lem:relativeTensor_as_coequalizer`, NO `\leanok`)
- **Lean target exists**: no — absent from Lean file by design (deferred, no sorry).
- **Signature matches**: N/A (not yet formalized)
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly does NOT mark `\leanok`. Lean handoff note documents this as the next iter task. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_whiskerRight_unit}` (chapter: `lem:isIso_sheafification_whiskerRight_unit`, NO `\leanok`)
- **Lean target exists**: no — absent by design.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint correctly has no `\leanok`. Lean handoff details exactly what is missing. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjAssoc}` (chapter: `cor:sheafTensorObjAssoc`, NO `\leanok`)
- **Lean target exists**: no — absent by design.
- **notes**: Depends on `isIso_sheafification_whiskerRight_unit`. Correctly deferred.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPowAdd}` (chapter: `lem:sheafTensorPow_add`, NO `\leanok`)
- **Lean target exists**: no — absent by design.
- **notes**: Depends on `tensorObjAssoc`. Correctly deferred. Lean handoff documents what remains (associator is the single missing ingredient).

### `\lean{AlgebraicGeometry.Scheme.Modules.sectionsMul_assoc_unit}` (chapter: `lem:sectionMul_coherent`, NO `\leanok`)
- **Lean target exists**: no — absent by design.
- **notes**: Depends on `tensorPowAdd`. Correctly deferred.

### `\lean{AlgebraicGeometry.sectionGradedRing_gcommSemiring}` (chapter: `lem:sectionGradedRing_gcommSemiring`, NO `\leanok`)
- **Lean target exists**: no — absent by design.
- **notes**: Depends on `tensorPowAdd` and `sectionsMul_assoc_unit`. Correctly deferred.

### `\lean{AlgebraicGeometry.sectionGradedModule_gmodule}` (chapter: `lem:sectionGradedModule_gmodule`, NO `\leanok`)
- **Lean target exists**: no — absent by design.
- **notes**: Depends on the same chain. Correctly deferred.

---

## Red flags

No placeholder (`:= sorry`) bodies, no `axiom` declarations, no excuse-comments, no weakened-wrong definitions were found. The handoff note inside the Lean file explicitly states deferred items are "left absent rather than backed by a sorry", which is correct mathlib-build discipline.

---

## Unreferenced declarations (informational)

The following Lean declarations in this file have **no** `\lean{...}` reference in the blueprint chapter:

| Declaration | Nature |
|---|---|
| `opensTopology` (private abbrev, line 205) | Helper, private, one-line adapter. Acceptable. |
| `relTensorDomainPresheaf` (noncomputable def, line 450) | **Substantive new declaration** — the objectwise `ℤ`-tensor presheaf `U ↦ Γ(U,P) ⊗_ℤ Γ(U,Q)` as a functor into `Ab`. Introduced this iter as Step 1 of the presheaf promotion. No blueprint block exists for it. |

`relTensorDomainPresheaf` is the most notable uncovered declaration. It is a substantive infrastructure def, not a trivial helper. The blueprint's proof sketch for `lem:relativeTensor_as_coequalizer` describes the three-step promotion argument but does not give `relTensorDomainPresheaf` its own block or `\lean{...}` tag.

---

## Blueprint adequacy for this file

- **Coverage**: 22/22 `\leanok`-marked Lean declarations have corresponding `\lean{...}` blueprint blocks. 7 blueprint blocks lack `\leanok` (correctly marking absent-but-planned declarations). 1 substantive Lean declaration (`relTensorDomainPresheaf`) is unreferenced.
- **Proof-sketch depth**: **adequate** for the formalized part. The `isColimitCofork` proof sketch in `lem:relativeTensor_objectwise_coequalizer` (existence via `liftAddHom`, uniqueness via surjectivity of `piMor`) is precisely what the Lean proof does. The `isIso_sheafification_map_iff` and sibling lemma sketches are accurate. The deferred items (`lem:relativeTensor_as_coequalizer`, `lem:isIso_sheafification_whiskerRight_unit`, etc.) have detailed proof sketches describing the exact route — the blueprint correctly anticipates what the formalization will need, though those proofs are not yet done.
- **Hint precision**: **precise** for all formalized items. The `\lean{...}` tags match the Lean declaration names exactly, including the long list of `RelativeTensorCoequalizer.*` helpers.
- **Generality**: **matches need** — the blueprint and Lean file agree on working over a general scheme `X` and using natural categories (`X.Modules`, `X.PresheafOfModules`).
- **Recommended chapter-side actions**:
  1. Add a blueprint block (with `\lean{AlgebraicGeometry.Scheme.Modules.relTensorDomainPresheaf}`) documenting `relTensorDomainPresheaf` as Step 1 of the presheaf promotion. It is introduced in the Lean file with an `/-! ... -/` comment that describes its role; the blueprint should mirror this as a named definition block (perhaps as a sub-item of `lem:relativeTensor_as_coequalizer` or a new `def:relTensorDomainPresheaf`).
  2. (Minor) Consider whether `private` declarations that the blueprint references with `\lean{...}` should be promoted to non-private, or the blueprint should note their private status.

---

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - 9 declarations referenced by `\lean{...}` in the blueprint are `private` in the Lean file (`MonoidalPresheaf`, `unitModule`, `sheafificationCounitIso`, `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`, `tensorPow_zero`, `tensorPow_succ`, `moduleTensorPow_zero`). The `\lean{...}` navigation links cannot be resolved externally. If navigation/blueprint-rendering uses name lookup, these links are broken.
  - `relTensorDomainPresheaf` (new iter-055 declaration) lacks a blueprint block — coverage debt for the next blueprint update.
  - `sectionsMul` domain type in Lean is the presentationally-different-but-definitionally-equal presheaf form rather than the explicit relative tensor; worth a blueprint prose note.

**Overall verdict**: The file is clean and axiom-free; all formalized declarations faithfully match their blueprint blocks; absent declarations are correctly deferred (no sorries); the only actionable items are minor blueprint-presentation issues (private declarations referenced by `\lean{...}` tags) and one missing blueprint block for the new `relTensorDomainPresheaf` definition.
