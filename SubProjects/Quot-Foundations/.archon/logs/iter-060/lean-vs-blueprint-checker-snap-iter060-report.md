# Lean ↔ Blueprint Check Report

## Slug
snap-iter060

## Iteration
060

## Files audited
- Lean: `AlgebraicJacobian/Picard/SectionGradedRing.lean`
- Blueprint: `blueprint/src/chapters/Picard_SectionGradedRing.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.MonoidalPresheaf}` (chapter: `def:monoidalPresheaf`)
- **Lean target exists**: yes — `private abbrev MonoidalPresheaf` at line 79
- **Signature matches**: yes — `PresheafOfModules (X.sheaf.obj ⋙ forget₂ CommRingCat RingCat)`, matching the prose description of the monoidal-form presentation
- **Proof follows sketch**: N/A (abbrev, no proof body)
- **notes**: `private` — see "Private declarations" note in Unreferenced section

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafification}` (chapter: `def:schemeModuleSheafification`)
- **Lean target exists**: yes — `noncomputable def sheafification` at line 70
- **Signature matches**: yes — `X.PresheafOfModules ⥤ X.Modules`, instantiated at `𝟙 X.ringCatSheaf.obj`
- **Proof follows sketch**: N/A (def, body matches prose)
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.unitModule}` (chapter: `def:unitModule`)
- **Lean target exists**: yes — `private noncomputable abbrev unitModule` at line 94
- **Signature matches**: yes — `SheafOfModules.unit X.ringCatSheaf`
- **Proof follows sketch**: N/A
- **notes**: `private` — see "Private declarations" note

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:sheafTensorObj`)
- **Lean target exists**: yes — `noncomputable def tensorObj` at line 86
- **Signature matches**: yes — sheafification of the objectwise presheaf-monoidal tensor, `F ⊗ G := (F.toPresheaf ⊗ G.toPresheaf)^#`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow}` (chapter: `def:sheafTensorPow`)
- **Lean target exists**: yes — `noncomputable def tensorPow` at line 100
- **Signature matches**: yes — `L : X.Modules → ℕ → X.Modules`, base case `unitModule X`, successor `tensorObj (tensorPow L m) L`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow_zero}` / `tensorPow_succ` (chapter: `lem:tensorPow_zero` / `lem:tensorPow_succ`)
- **Lean target exists**: yes — `@[simp] private lemma` at lines 104, 106
- **Signature matches**: yes — `rfl` base/step cases
- **Proof follows sketch**: yes — definitional
- **notes**: `private @[simp]` — blueprint pins these lemmas with `\lean{}`, which is fine internally

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow}` (chapter: `def:sheafModuleTwist`)
- **Lean target exists**: yes — `noncomputable def moduleTensorPow` at line 112
- **Signature matches**: yes — `F ⊗ L^{⊗m}`
- **Proof follows sketch**: N/A
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow_zero}` (chapter: `lem:moduleTensorPow_zero`)
- **Lean target exists**: yes — `@[simp] private lemma` at line 115
- **Signature matches**: yes
- **Proof follows sketch**: yes — `rfl`
- **notes**: `private`

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCounitIso}` (chapter: `def:sheafificationCounitIso`)
- **Lean target exists**: yes — `private noncomputable def sheafificationCounitIso` at line 131
- **Signature matches**: yes — `sheafification.obj ((toPresheafOfModules X).obj G) ≅ G` via `asIso` of the counit
- **Proof follows sketch**: yes — counit of the sheafification adjunction, invertible by full-faithfulness of the right adjoint
- **notes**: `private`

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjUnitIso}` (chapter: `def:tensorObjUnitIso`)
- **Lean target exists**: yes — `private noncomputable def tensorObjUnitIso` at line 140
- **Signature matches**: yes — `tensorObj (unitModule X) G ≅ G`, sheafified left-unitor composed with counit iso
- **Proof follows sketch**: yes
- **notes**: `private`

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjRightUnitor}` (chapter: `def:tensorObjRightUnitor`)
- **Lean target exists**: yes — `private noncomputable def tensorObjRightUnitor` at line 151
- **Signature matches**: yes — `tensorObj G (unitModule X) ≅ G`
- **Proof follows sketch**: yes
- **notes**: `private`

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorBraiding}` (chapter: `def:tensorBraiding`)
- **Lean target exists**: yes — `private noncomputable def tensorBraiding` at line 164
- **Signature matches**: yes — `tensorObj F G ≅ tensorObj G F`
- **Proof follows sketch**: yes
- **notes**: `private`

### `\lean{AlgebraicGeometry.Scheme.Modules.sectionsMul}` (chapter: `def:sectionMul`)
- **Lean target exists**: yes — `noncomputable def sectionsMul` at line 188
- **Signature matches**: yes — `(P ⊗_p Q)(⊤) ⟶ (tensorObj F G).val.obj (op ⊤)` via the sheafification-unit component at `⊤`
- **Proof follows sketch**: N/A (def body matches: unit component of adjunction)
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_map_iff}` (chapter: `lem:isIso_sheafification_map_iff`)
- **Lean target exists**: yes — `lemma isIso_sheafification_map_iff` at line 218
- **Signature matches**: yes — `IsIso (sheafification.map f) ↔ (opensTopology X).W ((toPresheaf X.ringCatSheaf.obj).map f)`
- **Proof follows sketch**: yes — uses `PresheafOfModules.inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` to convert, matching the blueprint's localization-criterion argument
- **notes**: clean; blueprint proof block correctly has `\leanok`

### `\lean{AlgebraicGeometry.Scheme.Modules.localIso_toPresheaf_map_unit}` (chapter: `lem:localIso_toPresheaf_map_unit`)
- **Lean target exists**: yes — `lemma localIso_toPresheaf_map_unit` at line 243
- **Signature matches**: yes — `(opensTopology X).W (toPresheaf.map (adj.unit.app P))`
- **Proof follows sketch**: yes — `toPresheaf_map_sheafificationAdjunction_unit_app` + `W_toSheafify`, matching the blueprint's "underlying abelian map of the unit is the abelian sheafification unit" argument
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_map_unit}` (chapter: `lem:isIso_sheafification_map_unit`)
- **Lean target exists**: yes — `lemma isIso_sheafification_map_unit` at line 255
- **Signature matches**: yes
- **Proof follows sketch**: yes — feeds `localIso_toPresheaf_map_unit` through `isIso_sheafification_map_iff`
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.relTensorDomainPresheaf}` (chapter: `def:relTensorDomainPresheaf`)
- **Lean target exists**: yes — `noncomputable def relTensorDomainPresheaf` at line 484
- **Signature matches**: yes — `(Opens X)ᵒᵖ ⥤ Ab`, `obj U = P.obj U ⊗[ℤ] Q.obj U`, restriction = `TensorProduct.map`
- **Proof follows sketch**: yes — map-id and map-comp verified by `⊗`-induction
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.relTensorTriplePresheaf}` (chapter: `def:relTensorTriplePresheaf`)
- **Lean target exists**: yes — `noncomputable def relTensorTriplePresheaf` at line 515
- **Signature matches**: yes — `P.obj U ⊗[ℤ] (X.sheaf.obj.obj U ⊗[ℤ] Q.obj U)` with ring restriction in the middle factor
- **Proof follows sketch**: yes — functoriality by `⊗`-induction
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.relTensorActL}` (chapter: `def:relTensorActL`)
- **Lean target exists**: yes — `noncomputable def relTensorActL` at line 552
- **Signature matches**: yes — `relTensorTriplePresheaf P Q ⟶ relTensorDomainPresheaf P Q`, component = `actLmap`
- **Proof follows sketch**: yes — naturality proved via `key` (ℤ-linear square using `TensorProduct.ext'` + `PresheafOfModules.map_smul`), then transported to Ab via `LinearMap.congr_fun` + `simpa`. Matches blueprint's "restriction of s·m equals (s|_V)·(m|_V)" argument.
- **notes**: `objRestrict` helper (private, lines 448–474) is the load-bearing ingredient that fixes the carrier-gap (`↥(P.obj U)` vs `↥((P.presheaf).obj U)`) documented in the handoff notes. Blueprint does not mention `objRestrict` — this is a fine-grained technical helper, not mathematical content.

### `\lean{AlgebraicGeometry.Scheme.Modules.relTensorActR}` (chapter: `def:relTensorActR`)
- **Lean target exists**: yes — `noncomputable def relTensorActR` at line 594
- **Signature matches**: yes — parallel to `relTensorActL`, component = `actRmap`, `m ⊗ (s ⊗ n) ↦ m ⊗ (s·n)`
- **Proof follows sketch**: yes — same structure as `relTensorActL`
- **notes**: clean

### `\lean{AlgebraicGeometry.Scheme.Modules.relTensorProj}` (chapter: `def:relTensorProj`) — **iter-060 closure**
- **Lean target exists**: yes — `noncomputable def relTensorProj` at line 632
- **Signature matches**: yes — `relTensorDomainPresheaf P Q ⟶ (PresheafOfModules.toPresheaf X.ringCatSheaf.obj).obj (tensorObj (C := MonoidalPresheaf X) P Q)`, component = `projL`; the apex is identified with `(toPresheaf).obj (P ⊗_p Q)` whose objectwise value is `P(U) ⊗_{O_X(U)} Q(U)` via `PresheafOfModules.Monoidal.tensorObj_obj`
- **Proof follows sketch**: yes — naturality via `TensorProduct.ext'` with `rfl` on the elementary-tensor key (both sides send `m ⊗ₜ n` to `(P.map f m) ⊗ₜ[R(V)] (Q.map f n)` definitionally, since the restriction formula for the presheaf monoidal tensor is `⊗`-on-the-nose), then `LinearMap.congr_fun` + `simpa` transport to Ab. Blueprint's "both composites sending m ⊗ n to (m|_V) ⊗_{O_X(V)} (n|_V), agree by ⊗-induction" is exactly this.
- **notes**: **NEWLY CLOSED this iter.** The `rfl` on elementary tensors is the mathematical heart; the surrounding plumbing (`AddCommGrpCat.hom_ext` + `LinearMap.congr_fun`) is carrier bookkeeping resolved by `objRestrict`. Blueprint `\leanok` correctly set at line 550. Formatting quirk: `\leanok` appears on a standalone line with a blank above it (line 550 vs `\begin{definition}` at line 548 with a blank line in between) — non-standard but correct.

### `\lean{AlgebraicGeometry.Scheme.Modules.RelativeTensorCoequalizer.*}` (chapter: `lem:relativeTensor_objectwise_coequalizer`)
- **Lean target exists**: yes — all 22 pinned declarations exist in `namespace RelativeTensorCoequalizer` (lines 280–422)
- **Signature matches**: yes — `isColimitCofork`, `actN/actM/actLmap/actRmap`, `projL`, `aL/aR/piMor`, `cofork`, `descHom/descMor/descFac`, simp lemmas, `piMor_epi`/`coeq_condition` all match blueprint prose
- **Proof follows sketch**: yes — existence via `TensorProduct.liftAddHom`, uniqueness via `cancel_epi (piMor S M N)`, matching blueprint proof steps exactly
- **notes**: **MAJOR gap: `\leanok` absent from this block** (see Red Flags). All 22 declarations are axiom-clean and the proof is closed.

### Deferred declarations (no Lean body — project discipline: absent not sorry-backed)
These blueprint blocks have no `\leanok` and no corresponding Lean declaration, consistently with the project's "mathlib-build discipline":
- `lem:relativeTensor_as_coequalizer` → `relativeTensorCoequalizerIso` (next-iter target)
- `lem:snap_ztensor_whisker_localIso` → pending (no `\lean{}` pin)
- `lem:isIso_sheafification_whiskerRight_unit` → `isIso_sheafification_whiskerRight_unit`
- `cor:sheafTensorObjAssoc` → `tensorObjAssoc`
- `lem:sheafTensorPow_add` → `tensorPowAdd`
- `lem:sectionMul_coherent` → `sectionsMul_assoc_unit`
- `lem:sectionGradedRing_gcommSemiring` → `sectionGradedRing_gcommSemiring`
- `lem:sectionGradedModule_gmodule` → `sectionGradedModule_gmodule`

All correctly unmarked. No sorries introduced.

---

## Red Flags

### Placeholder / suspect bodies
None. The Lean file contains **zero `sorry`** and **zero `axiom`** declarations. Every deferred item is absent from the file entirely.

### Excuse-comments
The large `/- … -/` block comment blocks (lines 668–805) are **handoff notes**, not excuse-comments. They document:
- The resolved carrier-gap blocker and its solution (`objRestrict`)
- The recipe for the next iteration (`relativeTensorCoequalizerIso`)
- Historical failed attempts (for future provers' benefit)

These are project-discipline documentation, not "this is wrong but works for now" disclaimers. No red flag.

### Missing `\leanok` markers (major blueprint-side gap)
`lem:relativeTensor_objectwise_coequalizer` (blueprint lines 648–721): **Neither the statement block nor the proof block carries `\leanok`**, even though all 22 referenced declarations exist axiom-clean:
- All of `RelativeTensorCoequalizer.{actN, actM, actLmap, actRmap, projL, projL_surjective, projL_comp_act, aL, aR, piMor, piMor_epi, coeq_condition, cofork, descHom, descMor, descFac, isColimitCofork, actLmap_tmul, actRmap_tmul, projL_tmul, piMor_apply, descHom_tmul}` are present and axiom-clean.
- Root cause: `sync_leanok` appears to not handle multi-declaration `\lean{…, …, …}` blocks. With 22 comma-separated names in the `\lean{}` field, the deterministic sync pass likely only checks the first or none.
- Impact: Plan agents reading the blueprint will treat this closed work as unformalized.

---

## Unreferenced declarations (informational)

### Private helpers (not debt)
| Declaration | Lines | Notes |
|---|---|---|
| `objRestrict` | 448–458 | Carrier-gap fix: `↥(P.obj U)` carriers for `TensorProduct.map` unification. Load-bearing for all three natural transformations' proofs. No blueprint entry needed — pure technical plumbing. |
| `objRestrict_apply`, `objRestrict_id`, `objRestrict_comp` | 456–475 | Supporting simp lemmas for `objRestrict`. |
| `opensTopology` | 205–207 | Notation abbrev for `Opens.grothendieckTopology`. |

### Private declarations referenced by blueprint
The following are `private` in Lean but carry `\lean{}` pins in the blueprint: `MonoidalPresheaf`, `unitModule`, `tensorPow_zero`, `tensorPow_succ`, `moduleTensorPow_zero`, `sheafificationCounitIso`, `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`.

Since `private` prevents access by qualified name from outside the module, `lean_verify` and external tooling cannot resolve these names. Within the project this is understood — these declarations are internal infrastructure exposed in the blueprint for reference only. Not a semantic error, but the project should be aware that `sync_leanok` may fail to verify `private` declarations by name.

---

## Blueprint adequacy for this file

### Coverage
- **Closed declarations**: 24/24 closed Lean declarations have a `\lean{}` block in the chapter (including the 9 that are `private`).
- **Deferred declarations**: 8 blueprint blocks reference declarations absent from the Lean file — all correctly unmarked, all either gated on `relativeTensorCoequalizerIso` or further downstream.
- **Unreferenced in blueprint**: 4 private helpers (`objRestrict` + 3 supporting lemmas) — all pure technical plumbing, no blueprint debt.

### Proof-sketch depth
**Adequate** for formalized content; **adequate** for the next step (`relativeTensorCoequalizerIso`).

- The proofs of `relTensorActL/ActR/relTensorProj` are verified complete; the blueprint sketches (module semilinearity + `⊗`-induction) correctly anticipate the structure.
- The 3-step proof sketch for `lem:relativeTensor_as_coequalizer` (blueprint lines 754–810) is actionable: (1) apply `isColimitCofork` objectwise, (2) promote via `evaluationJointlyReflectsColimits`, (3) identify apex via `PresheafOfModules.Monoidal.tensorObj_obj`. All three building blocks (`relTensorActL`, `relTensorActR`, `relTensorProj`) are now in place.
- The Lean file's handoff note (lines 668–721) gives a more detailed recipe that aligns with and expands the blueprint sketch — this is fine since it's in a comment block, not introducing mathematical content the blueprint doesn't cover.

### One gap: `lem:snap_ztensor_whisker_localIso` (blueprint lines 603–629)
This lemma has `% NOTE: Lean decl name pending` with no `\lean{}` pin. It is an intermediate step in the `isIso_sheafification_whiskerRight_unit` proof chain (whiskered ℤ-tensor of a stalkwise iso is a local iso). Since it is downstream of `relativeTensorCoequalizerIso`, it does not block the next iteration's target. The blueprint-writing subagent should add a `\lean{}` pin when the declaration lands.

### Hint precision
**Precise** for all formalized blocks. The `\lean{}` pins name the exact Lean identifiers. The 22-declaration multi-pin for `lem:relativeTensor_objectwise_coequalizer` is accurate but hits the `sync_leanok` multi-name limitation.

### Generality
Matches need. No parallel APIs were introduced to work around blueprint under-generality.

### Recommended chapter-side actions
1. **[urgent, review-agent]** Add `\leanok` manually to the statement and proof blocks of `lem:relativeTensor_objectwise_coequalizer` (lines 648 and 690) — `sync_leanok` cannot handle the 22-name multi-declaration `\lean{}` field.
2. **[when ready]** Add `\lean{AlgebraicGeometry.Scheme.Modules.snap_ztensor_whisker_localIso}` (or whatever name lands) to `lem:snap_ztensor_whisker_localIso` (line 603) once the declaration is formalized.
3. **[optional, cosmetic]** Normalize `def:relTensorProj` to `\begin{definition}\leanok` on one line (currently blank line separates them — correct but non-standard).

---

## Severity summary

| Finding | Severity |
|---|---|
| Missing `\leanok` on `lem:relativeTensor_objectwise_coequalizer` (statement + proof) — `sync_leanok` multi-name gap; plan agents misread this as unformalized | **major** |
| `lem:snap_ztensor_whisker_localIso` has no `\lean{}` pin (pending decl name) | **minor** |
| 9 `private` declarations carry `\lean{}` blueprint pins — `sync_leanok` / external tools cannot resolve them by name | **minor** |
| `def:relTensorProj`: `\leanok` on standalone line (blank above it) — cosmetic, parses correctly | **minor** |

**Overall verdict:** The Lean file is fully clean — 0 sorries, 0 axioms, all 24 closed declarations match their blueprint `\lean{}` pins with faithful signatures and proof content; `relTensorProj.naturality` is correctly closed via `TensorProduct.ext'`+`rfl` on elementary tensors (blueprint sketch confirmed). The one actionable finding is a **major** blueprint-side gap: `lem:relativeTensor_objectwise_coequalizer` is missing `\leanok` despite all 22 referenced declarations being axiom-clean, and the review agent must add it manually. The chapter is adequate to guide formalization of `relativeTensorCoequalizerIso` (step-2 promotion).
