# Lean ↔ Blueprint Check Report

## Slug
snap-iter052

## Iteration
052

## Files audited
- Lean: `AlgebraicJacobian/Picard/SectionGradedRing.lean`
- Blueprint: `blueprint/src/chapters/Picard_SectionGradedRing.tex`

---

## Per-declaration

### Mathlib-backed blocks (no Archon obligation)

| Blueprint label | `\lean{...}` | Marker |
|---|---|---|
| `lem:presheafModule_monoidal_mathlib` | `PresheafOfModules.monoidalCategory` | `\mathlibok` |
| `lem:presheafModule_sheafification_mathlib` | `PresheafOfModules.sheafification` | `\mathlibok` |
| `lem:moduleUnit_mathlib` | `SheafOfModules.unit` | `\mathlibok` |
| `lem:directSum_gcommSemiring_mathlib` | `DirectSum.GCommSemiring` | `\mathlibok` |
| `lem:directSum_gmodule_mathlib` | `DirectSum.Gmodule` | `\mathlibok` |

All five are Mathlib-backed and correctly flagged `\mathlibok`. No Lean-file content to check.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafification}` (def:schemeModuleSheafification)
- **Lean target exists**: yes — `noncomputable def sheafification` at line 66, public
- **Signature matches**: yes — `X.PresheafOfModules ⥤ X.Modules`, specialised to `𝟙 X.ringCatSheaf.obj`; matches blueprint prose exactly
- **Proof follows sketch**: N/A (definition, no proof body)
- **Blueprint marker**: `\leanok` present
- **Notes**: The un-privating (no longer `private`) done this iter is the change being confirmed. The `\lean{...}` pin `AlgebraicGeometry.Scheme.Modules.sheafification` now resolves to the public non-private declaration. Match confirmed.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.MonoidalPresheaf}` (def:monoidalPresheaf)
- **Lean target exists**: yes — `private abbrev MonoidalPresheaf` at line 75
- **Signature matches**: yes — `PresheafOfModules (X.sheaf.obj ⋙ forget₂ CommRingCat RingCat)`, which is definitionally `X.PresheafOfModules`
- **Proof follows sketch**: N/A
- **Blueprint marker**: `\leanok` present
- **Notes**: Declaration is `private`. In Lean 4, private declarations acquire an internal hashed name; `sync_leanok` apparently resolved it (hence `\leanok`). Minor convention inconsistency (private declared as if public-facing in blueprint), but not a correctness error.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.unitModule}` (def:unitModule)
- **Lean target exists**: yes — `private noncomputable abbrev unitModule` at line 90
- **Signature matches**: yes — `SheafOfModules.unit X.ringCatSheaf`
- **Proof follows sketch**: N/A
- **Blueprint marker**: `\leanok` present
- **Notes**: Same privacy observation as `MonoidalPresheaf` above.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (def:sheafTensorObj)
- **Lean target exists**: yes — `noncomputable def tensorObj` at line 82
- **Signature matches**: yes — takes `F G : X.Modules`, returns `X.Modules` as sheafification of the objectwise presheaf tensor product; matches Stacks 01CA and blueprint prose
- **Proof follows sketch**: N/A
- **Blueprint marker**: `\leanok` present
- **Notes**: Clean match.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow}` (def:sheafTensorPow)
- **Lean target exists**: yes — `noncomputable def tensorPow` at line 96
- **Signature matches**: yes — `L : X.Modules → ℕ → X.Modules`, recursive: `| 0 => unitModule X`, `| m+1 => tensorObj (tensorPow L m) L`
- **Proof follows sketch**: N/A
- **Blueprint marker**: `\leanok` present
- **Notes**: Clean match.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow_zero}` (lem:tensorPow_zero)
- **Lean target exists**: yes — `private lemma tensorPow_zero` at line 100, `@[simp]`
- **Signature matches**: yes — `tensorPow L 0 = unitModule X`, proved by `rfl`
- **Proof follows sketch**: yes — definitional equality
- **Blueprint marker**: `\leanok` present
- **Notes**: Private simp lemma; privacy is fine for a simp-tagged auxiliary.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow_succ}` (lem:tensorPow_succ)
- **Lean target exists**: yes — `private lemma tensorPow_succ` at line 102, `@[simp]`
- **Signature matches**: yes — `tensorPow L (m + 1) = tensorObj (tensorPow L m) L`, proved by `rfl`
- **Proof follows sketch**: yes — definitional equality
- **Blueprint marker**: `\leanok` present
- **Notes**: Clean match.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow}` (def:sheafModuleTwist)
- **Lean target exists**: yes — `noncomputable def moduleTensorPow` at line 108
- **Signature matches**: yes — `F L : X.Modules → ℕ → X.Modules`, body `tensorObj F (tensorPow L m)`
- **Proof follows sketch**: N/A
- **Blueprint marker**: `\leanok` present
- **Notes**: Clean match.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow_zero}` (lem:moduleTensorPow_zero)
- **Lean target exists**: yes — `private lemma moduleTensorPow_zero` at line 111, `@[simp]`
- **Signature matches**: yes — `moduleTensorPow F L 0 = tensorObj F (unitModule X)`, by `rfl`
- **Proof follows sketch**: yes
- **Blueprint marker**: `\leanok` present
- **Notes**: Private simp lemma; fine.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCounitIso}` (def:sheafificationCounitIso)
- **Lean target exists**: yes — `private noncomputable def sheafificationCounitIso` at line 127
- **Signature matches**: yes — `sheafification.obj ((toPresheafOfModules X).obj G) ≅ G`, built from `asIso` of the adjunction counit
- **Proof follows sketch**: yes — counit of adjunction is iso because right adjoint is fully faithful
- **Blueprint marker**: `\leanok` present
- **Notes**: Private with `\leanok`; see note under `MonoidalPresheaf`. No content error.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjUnitIso}` (def:tensorObjUnitIso)
- **Lean target exists**: yes — `private noncomputable def tensorObjUnitIso` at line 136
- **Signature matches**: yes — `tensorObj (unitModule X) G ≅ G`, via presheaf left unitor then counit iso
- **Proof follows sketch**: yes — blueprint: "sheafifying the presheaf left unitor … composed with the counit isomorphism"
- **Blueprint marker**: `\leanok` present
- **Notes**: Private. Content correct.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjRightUnitor}` (def:tensorObjRightUnitor)
- **Lean target exists**: yes — `private noncomputable def tensorObjRightUnitor` at line 147
- **Signature matches**: yes — `tensorObj G (unitModule X) ≅ G`, via presheaf right unitor then counit iso
- **Proof follows sketch**: yes
- **Blueprint marker**: `\leanok` present
- **Notes**: Private. Content correct.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorBraiding}` (def:tensorBraiding)
- **Lean target exists**: yes — `private noncomputable def tensorBraiding` at line 160
- **Signature matches**: yes — `tensorObj F G ≅ tensorObj G F`, via presheaf braiding through sheafification
- **Proof follows sketch**: yes
- **Blueprint marker**: `\leanok` present
- **Notes**: Private. Content correct.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.sectionsMul}` (def:sectionMul)
- **Lean target exists**: yes — `noncomputable def sectionsMul` at line 184
- **Signature matches**: yes — `(preshTensorProd F G)(X) ⟶ (tensorObj F G).val.obj ⊤`, the sheafification-unit application at the top open; matches blueprint's "pair of global sections → elementary tensor → sheafification unit → global section of tensor product"
- **Proof follows sketch**: N/A (definition)
- **Blueprint marker**: `\leanok` present
- **Notes**: Clean match.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_whiskerRight_unit}` (lem:isIso_sheafification_whiskerRight_unit)
- **Lean target exists**: **NO** — no declaration with this name in the Lean file; the name appears only in block comments as "the crux"
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Blueprint marker**: **No `\leanok`** (blueprint correctly shows it as unformalized)
- **Notes**: The blueprint's proof block (lines 386–449) is fully written out, describing the localization-criterion strategy and the coequalizer route. The Lean file's block comment (lines 256–341) explains that the remaining gap is the single abelian fact `J.W(toPresheaf.map(η_P)) → J.W(toPresheaf.map(η_P ▷ Q))` (the relative-⊗ whiskering of a J.W morphism), and that all three identified Mathlib routes (coequalizer presentation, closed monoidal structure, stalk theory) are blocked on absent Mathlib bricks. Blueprint accurately shows this as open.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjAssoc}` (cor:sheafTensorObjAssoc)
- **Lean target exists**: **NO** — not present in the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Blueprint marker**: **No `\leanok`** (blueprint correctly shows it as unformalized)
- **Notes**: Blueprint proof explicitly uses `lem:isIso_sheafification_whiskerRight_unit` as a dependency (line 488). Correctly deferred alongside the crux.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPowAdd}` (lem:sheafTensorPow_add)
- **Lean target exists**: **NO** — not present in the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Blueprint marker**: **No `\leanok`** (blueprint correctly shows it as unformalized)
- **Notes**: Blueprint proof uses `cor:sheafTensorObjAssoc` (which uses the crux). Correctly deferred.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.sectionsMul_assoc_unit}` (lem:sectionMul_coherent)
- **Lean target exists**: **NO** — not present in the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Blueprint marker**: **No `\leanok`**
- **Notes**: Depends on `lem:sheafTensorPow_add`. Correctly deferred.

---

### `\lean{AlgebraicGeometry.sectionGradedRing_gcommSemiring}` (lem:sectionGradedRing_gcommSemiring)
- **Lean target exists**: **NO** — note also that the namespace is `AlgebraicGeometry` (not `AlgebraicGeometry.Scheme.Modules`); either intentional (will live outside the Modules namespace) or an unresolved naming decision
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Blueprint marker**: **No `\leanok`**
- **Notes**: Depends on `lem:sheafTensorPow_add` and `lem:sectionMul_coherent`. Correctly deferred. Namespace discrepancy (`AlgebraicGeometry` vs `AlgebraicGeometry.Scheme.Modules`) should be resolved when formalized.

---

### `\lean{AlgebraicGeometry.sectionGradedModule_gmodule}` (lem:sectionGradedModule_gmodule)
- **Lean target exists**: **NO**
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Blueprint marker**: **No `\leanok`**
- **Notes**: Same namespace discrepancy note as `sectionGradedRing_gcommSemiring`. Correctly deferred.

---

## Red flags

No red flags found:
- No `:= sorry` anywhere in the Lean file.
- No excuse-comments (`-- TODO replace with real def`, `-- temporary`, `-- placeholder`, `-- wrong but works for now`).
- No `axiom` declarations.
- No weakened-wrong definitions.

The long block comment (lines 256–341) is not an excuse-comment: it is a technical explanation of the Mathlib gap and the proof-engineering status, appropriate for a deferred handoff. The absent declarations (`tensorObjAssoc`, `tensorPowAdd`, etc.) are correctly absent rather than sorry-filled, consistent with the project's "mathlib-build" discipline.

---

## Unreferenced declarations (informational)

Three public lemmas in the Lean file have **no `\lean{...}` blueprint reference**:

| Lean declaration | Lines | Status in Lean file | Connection to blueprint |
|---|---|---|---|
| `isIso_sheafification_map_iff` | 214–229 | Proven, axiom-clean | Materialises the first paragraph of the `lem:isIso_sheafification_whiskerRight_unit` proof ("localization criterion": `IsIso(sheafification.map f) ↔ J.W(toPresheaf.map f)`) |
| `localIso_toPresheaf_map_unit` | 239–243 | Proven, axiom-clean | Materialises the "η_P ∈ J.W" ingredient in the same proof (underlying abelian map of the module-sheafification unit is definitionally `toSheafify`, which is in J.W) |
| `isIso_sheafification_map_unit` | 251–254 | Proven, axiom-clean | The un-whiskered m=0 special case of the crux; called out in the block comment as "the m=0 launching pad" |

**Confirmation of reduction-chain status.** All three are genuine, axiom-clean reduction steps toward `lem:isIso_sheafification_whiskerRight_unit`, exactly as described in the Lean file's block comment (lines 299–311). The crux is now
```
(isIso_sheafification_map_iff _).mpr (?_ : J.W (toPresheaf.map (η_P ▷ Q)))
```
and these three lemmas build the non-whiskered half (`isIso_sheafification_map_iff` provides the iff, `localIso_toPresheaf_map_unit` proves η_P ∈ J.W, `isIso_sheafification_map_unit` closes the un-whiskered instance). The remaining gap — that tensoring a J.W morphism by Q stays in J.W (relative tensor vs. abelian tensor) — is the single open abelian brick.

These are **not** private helpers: all three are `public lemma` with full docstrings, and at least `isIso_sheafification_map_iff` is general enough to be independently reusable. They should have `\lean{...}` references in the blueprint chapter.

One private abbrev also lacks a blueprint reference:
- `opensTopology` (line 201) — local notation for the Grothendieck topology on `X`; pure convenience abbreviation, no blueprint entry needed.

---

## Blueprint adequacy for this file

- **Coverage**: 19 of the 22 non-Mathlib blueprint declarations have a corresponding `\lean{...}` block. Of the 18 Lean declarations in this file, 15 have blueprint `\lean{...}` references. Three public lemmas (`isIso_sheafification_map_iff`, `localIso_toPresheaf_map_unit`, `isIso_sheafification_map_unit`) lack blueprint entries (major gap; see above). Two private abbreviations (`MonoidalPresheaf`, `opensTopology`) are helpers; `MonoidalPresheaf` has a blueprint block, `opensTopology` does not — this is fine.

- **Proof-sketch depth**: **adequate** for the formalized portion. The proof block of `lem:isIso_sheafification_whiskerRight_unit` is detailed (lines 386–449) and describes both the localization-criterion reduction and the coequalizer route, which is exactly what the Lean file implements (minus the final Mathlib brick). For the deferred declarations (`tensorObjAssoc`, `tensorPowAdd`, `sectionsMul_assoc_unit`), the proofs are fully written, so a prover will have sufficient guidance when the missing brick arrives.

- **Hint precision**: **precise**. Every `\lean{...}` hint that points to a formalized declaration resolves to the correct Lean name. The two namespace-level hints (`AlgebraicGeometry.sectionGradedRing_gcommSemiring`, `AlgebraicGeometry.sectionGradedModule_gmodule`) are consistent with each other but use a different namespace from the rest of the file's declarations; this is a minor forward-looking consistency note, not an error.

- **Generality**: **matches need**. The blueprint's level of generality (working over a general scheme `X`) matches what the Lean file formalizes.

- **Recommended chapter-side actions**:
  1. **Add three new blueprint blocks** for `isIso_sheafification_map_iff`, `localIso_toPresheaf_map_unit`, and `isIso_sheafification_map_unit` — each a `\begin{lemma}` block with `\lean{AlgebraicGeometry.Scheme.Modules.<name>}`, placed between `def:tensorBraiding` and `lem:isIso_sheafification_whiskerRight_unit`. Proof sketches can be brief (one sentence each). This closes the coverage debt without changing the open/closed status of the crux.
  2. **Confirm namespace for graded-ring/module assembly**: `AlgebraicGeometry.sectionGradedRing_gcommSemiring` vs. `AlgebraicGeometry.Scheme.Modules.*` — document the intended namespace before formalization.

---

## Severity summary

### must-fix-this-iter
*None.*

- No placeholder/sorry bodies on substantive declarations.
- No signature mismatches.
- No excuse-comments.
- No unauthorised axioms.
- Blueprint adequacy is not a failure: the chapter is detailed enough for a prover to work from it (the open declarations are open because Mathlib is missing, not because the chapter is unclear).
- No weakened-wrong definitions.

### major
1. **Coverage debt: `isIso_sheafification_map_iff`** — public lemma, no `\lean{...}` blueprint reference. It is a genuine substantive reduction step (the localization criterion) used in the crux proof, extracted as a named lemma. Blueprint should add a block for it.
2. **Coverage debt: `localIso_toPresheaf_map_unit`** — public lemma, no `\lean{...}` blueprint reference. Proves η_P ∈ J.W, the key abelian ingredient of the crux proof.
3. **Coverage debt: `isIso_sheafification_map_unit`** — public lemma, no `\lean{...}` blueprint reference. The un-whiskered special case (m=0 launching pad), explicitly named in the Lean comment as a key partial result.

### minor
4. **Private declarations with `\leanok`**: `MonoidalPresheaf`, `unitModule`, `sheafificationCounitIso`, `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding` are `private` in Lean 4 (their externally accessible name differs from the user-facing name). `sync_leanok` has set `\leanok` on all of them, which suggests the tool handles private declarations correctly. No content error, but the convention of giving `\lean{...}` references to private declarations is slightly unusual. No action needed unless `sync_leanok` proves unreliable for these.

---

**Overall verdict**: The formalized declarations (15 out of 18) faithfully match their blueprint targets with no placeholder bodies, signature mismatches, or excuse-comments; the three open-crux-dependent declarations (`tensorObjAssoc`, `tensorPowAdd`, etc.) are correctly marked unformalized; the blueprint accurately reflects the single remaining Mathlib-absent gap; the three new reduction-chain lemmas lack `\lean{...}` blueprint references and should be added as blueprint blocks (major, 3 findings; 0 red flags).
