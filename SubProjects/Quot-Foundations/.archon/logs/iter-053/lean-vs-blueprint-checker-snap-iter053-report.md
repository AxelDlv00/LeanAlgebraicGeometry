# Lean ↔ Blueprint Check Report

## Slug
snap-iter053

## Iteration
053

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/SectionGradedRing.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_SectionGradedRing.tex`

---

## Per-declaration

### `\lean{PresheafOfModules.monoidalCategory}` (lem:presheafModule_monoidal_mathlib)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes (`\mathlibok`)
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: none

### `\lean{PresheafOfModules.sheafification}` (lem:presheafModule_sheafification_mathlib)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes (`\mathlibok`)
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: none

### `\lean{SheafOfModules.unit}` (lem:moduleUnit_mathlib)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes (`\mathlibok`)
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: none

### `\lean{AlgebraicGeometry.Scheme.Modules.MonoidalPresheaf}` (def:monoidalPresheaf)
- **Lean target exists**: yes (line 79, `private abbrev`)
- **Signature matches**: yes — category of presheaves of modules over `X.sheaf.obj ⋙ forget₂ CommRingCat RingCat`, definitionally `X.PresheafOfModules` in monoidal form
- **Proof follows sketch**: N/A (definition by construction)
- **notes**: Declaration is `private`. The blueprint `\lean{...}` hint names the fully-qualified public name `AlgebraicGeometry.Scheme.Modules.MonoidalPresheaf`, but `private` abbrevs are not externally accessible by that name in Lean 4. Pre-existing pattern across several declarations in this file; `\leanok` already set.

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafification}` (def:schemeModuleSheafification)
- **Lean target exists**: yes (line 70)
- **Signature matches**: yes — `X.PresheafOfModules ⥤ X.Modules` specialised to `𝟙 X.ringCatSheaf.obj`
- **Proof follows sketch**: N/A (one-liner def)
- **notes**: none

### `\lean{AlgebraicGeometry.Scheme.Modules.unitModule}` (def:unitModule)
- **Lean target exists**: yes (line 94, `private noncomputable abbrev`)
- **Signature matches**: yes — `SheafOfModules.unit X.ringCatSheaf`
- **Proof follows sketch**: N/A
- **notes**: `private`; same pre-existing naming caveat as `MonoidalPresheaf`.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (def:sheafTensorObj)
- **Lean target exists**: yes (line 86)
- **Signature matches**: yes — sheafification of the objectwise tensor presheaf, `F ⊗ G := (F.toPresheaf ⊗ G.toPresheaf)^#`
- **Proof follows sketch**: N/A
- **notes**: none

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow}` (def:sheafTensorPow)
- **Lean target exists**: yes (line 100)
- **Signature matches**: yes — recursive: `L^0 = unitModule X`, `L^(m+1) = tensorObj (L^m) L`
- **Proof follows sketch**: N/A
- **notes**: none

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow_zero}` (lem:tensorPow_zero)
- **Lean target exists**: yes (line 104, `private @[simp] lemma`)
- **Signature matches**: yes — `tensorPow L 0 = unitModule X`, holds by `rfl`
- **Proof follows sketch**: yes
- **notes**: `private`; same naming caveat.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPow_succ}` (lem:tensorPow_succ)
- **Lean target exists**: yes (line 106, `private @[simp] lemma`)
- **Signature matches**: yes — `tensorPow L (m+1) = tensorObj (tensorPow L m) L`, holds by `rfl`
- **Proof follows sketch**: yes
- **notes**: `private`; same naming caveat.

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow}` (def:sheafModuleTwist)
- **Lean target exists**: yes (line 112)
- **Signature matches**: yes — `moduleTensorPow F L m := tensorObj F (tensorPow L m)`
- **Proof follows sketch**: N/A
- **notes**: none

### `\lean{AlgebraicGeometry.Scheme.Modules.moduleTensorPow_zero}` (lem:moduleTensorPow_zero)
- **Lean target exists**: yes (line 115, `private @[simp] lemma`)
- **Signature matches**: yes — `moduleTensorPow F L 0 = tensorObj F (unitModule X)`, by `rfl`
- **Proof follows sketch**: yes
- **notes**: `private`; same naming caveat.

### `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCounitIso}` (def:sheafificationCounitIso)
- **Lean target exists**: yes (line 131, `private noncomputable def`)
- **Signature matches**: yes — `sheafification.obj ((toPresheafOfModules X).obj G) ≅ G` via the reflective counit
- **Proof follows sketch**: yes — uses `asIso` of the adjunction counit
- **notes**: `private`; same naming caveat.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjUnitIso}` (def:tensorObjUnitIso)
- **Lean target exists**: yes (line 140, `private noncomputable def`)
- **Signature matches**: yes — `tensorObj (unitModule X) G ≅ G` via presheaf left-unitor then counit-iso
- **Proof follows sketch**: yes — matches blueprint's "sheafifying the presheaf left unitor … composed with `sheafificationCounitIso`"
- **notes**: `private`; same naming caveat.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjRightUnitor}` (def:tensorObjRightUnitor)
- **Lean target exists**: yes (line 151, `private noncomputable def`)
- **Signature matches**: yes — `tensorObj G (unitModule X) ≅ G`
- **Proof follows sketch**: yes
- **notes**: `private`; same naming caveat.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorBraiding}` (def:tensorBraiding)
- **Lean target exists**: yes (line 164, `private noncomputable def`)
- **Signature matches**: yes — `tensorObj F G ≅ tensorObj G F` via `sheafification.mapIso` of the presheaf braiding
- **Proof follows sketch**: yes
- **notes**: `private`; same naming caveat.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_map_iff}` (lem:isIso_sheafification_map_iff)
- **Lean target exists**: yes (line 218)
- **Signature matches**: yes — `IsIso (sheafification.map f) ↔ (opensTopology X).W ((toPresheaf X.ringCatSheaf.obj).map f)`
- **Proof follows sketch**: yes — uses `PresheafOfModules.inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`; both directions of the iff are established
- **notes**: Blueprint proof says "localization criterion for a reflective adjunction"; Lean proof matches.

### `\lean{AlgebraicGeometry.Scheme.Modules.localIso_toPresheaf_map_unit}` (lem:localIso_toPresheaf_map_unit)
- **Lean target exists**: yes (line 243)
- **Signature matches**: yes — unit's underlying abelian map is `toSheafify`, which lies in `J.W`
- **Proof follows sketch**: yes — `rw [PresheafOfModules.toPresheaf_map_sheafificationAdjunction_unit_app]; exact W_toSheafify _`
- **notes**: Blueprint says "the forgetful functor carries the module sheafification unit to the abelian associated-sheaf unit"; Lean confirms exactly this.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_map_unit}` (lem:isIso_sheafification_map_unit)
- **Lean target exists**: yes (line 255)
- **Signature matches**: yes — `IsIso (sheafification.map (sheafificationAdjunction.unit.app P))`
- **Proof follows sketch**: yes — single-line: `(isIso_sheafification_map_iff _).mpr (localIso_toPresheaf_map_unit P)`
- **notes**: none

### `\lean{AlgebraicGeometry.Scheme.Modules.relativeTensorCoequalizerIso}` (lem:relativeTensor_as_coequalizer)
- **Lean target exists**: **no** — declaration `relativeTensorCoequalizerIso` is absent from the file. What exists is `namespace RelativeTensorCoequalizer` containing 22 declarations that build the **objectwise** version (`isColimitCofork` for a single `S`, `M`, `N`) but not the presheaf-level iso.
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: partial — the objectwise half of the proof sketch ("Over each open U the module is the coequalizer") is completely formalized in `RelativeTensorCoequalizer.isColimitCofork`; the presheaf-level assembly ("colimits of abelian-group presheaves are computed objectwise") is deferred per the handoff note.
- **notes**: Blueprint correctly has no `\leanok` here. The 22 `RelativeTensorCoequalizer` declarations are genuine, axiom-clean infra (see Red flags section for confirmation they are not fake). Coverage debt: the blueprint `\lean{...}` hint names the wrong/future declaration; it should either be updated to `RelativeTensorCoequalizer.isColimitCofork` or a new sub-lemma block should be added. See Blueprint adequacy section.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_sheafification_whiskerRight_unit}` (lem:isIso_sheafification_whiskerRight_unit)
- **Lean target exists**: no (documented as deferred in the handoff note; no `\leanok` in blueprint)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Honest absence; blueprint correctly marks this unformalized.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjAssoc}` (cor:sheafTensorObjAssoc)
- **Lean target exists**: no (blocked on `isIso_sheafification_whiskerRight_unit`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Honest absence; blueprint correctly marks this unformalized.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorPowAdd}` (lem:sheafTensorPow_add)
- **Lean target exists**: no (blocked on `tensorObjAssoc`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Honest absence; blocked dependency chain fully documented in handoff note.

### `\lean{AlgebraicGeometry.Scheme.Modules.sectionsMul}` (def:sectionMul)
- **Lean target exists**: yes (line 188)
- **Signature matches**: yes — morphism from `(P ⊗_p Q).obj (op ⊤)` to `(tensorObj F G).val.obj (op ⊤)` via the sheafification unit component at top; domain equals `Γ(X,F) ⊗_{Γ(X,O_X)} Γ(X,G)` by the objectwise formula, codomain is `Γ(X, F ⊗ G)`. Bilinearity is encoded in the `⟶` type in `ModuleCat`.
- **Proof follows sketch**: yes — blueprint says "composing with the global-sections component of the sheafification unit"; Lean uses `(sheafificationAdjunction.unit.app _).app (op ⊤)`
- **notes**: none

### `\lean{AlgebraicGeometry.Scheme.Modules.sectionsMul_assoc_unit}` (lem:sectionMul_coherent)
- **Lean target exists**: no (blocked on `tensorPowAdd`)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Honest absence.

### `\lean{DirectSum.GCommSemiring}` (lem:directSum_gcommSemiring_mathlib)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes (`\mathlibok`)
- **notes**: none

### `\lean{DirectSum.Gmodule}` (lem:directSum_gmodule_mathlib)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes (`\mathlibok`)
- **notes**: none

### `\lean{AlgebraicGeometry.sectionGradedRing_gcommSemiring}` (lem:sectionGradedRing_gcommSemiring)
- **Lean target exists**: no (blocked on `tensorPowAdd` and `sectionsMul_assoc_unit`)
- **Signature matches**: N/A
- **notes**: Honest absence.

### `\lean{AlgebraicGeometry.sectionGradedModule_gmodule}` (lem:sectionGradedModule_gmodule)
- **Lean target exists**: no (blocked on `sectionGradedRing_gcommSemiring`)
- **Signature matches**: N/A
- **notes**: Honest absence.

---

## Red flags

### Placeholder / suspect bodies

**None found.** All 22 `RelativeTensorCoequalizer` declarations have genuine proof bodies:
- `actN`/`actM`/`actRmap`/`actLmap`: real `TensorProduct.lift`/`.map` constructions
- `projL`: built from `TensorProduct.liftAddHom`
- `projL_surjective`: induction on `TensorProduct.induction_on`
- `projL_comp_act`: `TensorProduct.ext'` + explicit `smul_tmul'`/`tmul_smul` computation
- `piMor_epi`: `ConcreteCategory.epi_of_surjective` applied to `projL_surjective`
- `descHom`: real `TensorProduct.liftAddHom` construction with key balance condition check
- `descFac`/`isColimitCofork`: explicit factorization proof + epi-cancellation uniqueness

No `:= sorry`, no `:= True`, no `Classical.choice _` on substantive claims.

The file's own handoff note confirms: "Everything here is axiom-clean." This checker independently confirms the 22 declarations are genuine infra.

### Excuse-comments

None. The extensive handoff note (lines 422–537) is an honest engineering log documenting deferred work and blocked dependencies; it does not excuse wrong or incomplete code.

### Axioms / Classical.choice on non-trivial claims

None in the project-local declarations.

---

## Unreferenced declarations (informational)

All 22 `RelativeTensorCoequalizer` declarations have no `\lean{...}` blueprint reference:

| Declaration | Mathematical role | Blueprint-worthy? |
|---|---|---|
| `RelativeTensorCoequalizer.actN` | S-action map `S ⊗[ℤ] N → N` | helper |
| `RelativeTensorCoequalizer.actM` | S-action map `M ⊗[ℤ] S → M` | helper |
| `RelativeTensorCoequalizer.actRmap` | right-action `M ⊗[ℤ](S ⊗[ℤ] N) → M ⊗[ℤ] N` | helper |
| `RelativeTensorCoequalizer.actLmap` | left-action `M ⊗[ℤ](S ⊗[ℤ] N) → M ⊗[ℤ] N` | helper |
| `RelativeTensorCoequalizer.actRmap_tmul` | `@[simp]` computation lemma | helper |
| `RelativeTensorCoequalizer.actLmap_tmul` | `@[simp]` computation lemma | helper |
| `RelativeTensorCoequalizer.projL` | projection `M ⊗[ℤ] N → M ⊗[S] N` | helper |
| `RelativeTensorCoequalizer.projL_tmul` | `@[simp]` computation lemma | helper |
| `RelativeTensorCoequalizer.projL_surjective` | surjectivity of `projL` | helper |
| `RelativeTensorCoequalizer.projL_comp_act` | coequalizing condition | helper |
| `RelativeTensorCoequalizer.aL` | `actLmap` as `AddCommGrpCat` morphism | helper |
| `RelativeTensorCoequalizer.aR` | `actRmap` as `AddCommGrpCat` morphism | helper |
| `RelativeTensorCoequalizer.piMor` | projection as `AddCommGrpCat` morphism | helper |
| `RelativeTensorCoequalizer.piMor_apply` | `@[simp]` computation lemma | helper |
| `RelativeTensorCoequalizer.piMor_epi` | `Epi (piMor S M N)` instance | helper |
| `RelativeTensorCoequalizer.coeq_condition` | `aL ≫ piMor = aR ≫ piMor` | helper |
| `RelativeTensorCoequalizer.cofork` | the cofork object in `AddCommGrpCat` | helper |
| `RelativeTensorCoequalizer.descHom` | universal descent map `M ⊗[S] N →+ s.pt` | helper |
| `RelativeTensorCoequalizer.descHom_tmul` | `@[simp]` computation lemma | helper |
| `RelativeTensorCoequalizer.descMor` | `descHom` as `AddCommGrpCat` morphism | helper |
| `RelativeTensorCoequalizer.descFac` | factorization: `cofork.π ≫ descMor = s.π` | helper |
| **`RelativeTensorCoequalizer.isColimitCofork`** | **headline: `M ⊗[S] N` is the coequalizer in `AddCommGrpCat`** | **should be blueprinted** |

One additional unreferenced declaration in the main namespace:
- `opensTopology` (line 205, private): local helper abbreviation for `Opens.grothendieckTopology`. Pure convenience, not blueprint-worthy.

---

## Blueprint adequacy for this file

- **Coverage**: 17/25 project-local Lean declarations have a `\lean{...}` block. The 22 `RelativeTensorCoequalizer` declarations are all unblueprinted (acceptable for most helpers, but not for the headline `isColimitCofork`). 6 blueprint declarations are formalized but absent from the Lean file (honest open work). The `\lean{...}` hint for `lem:relativeTensor_as_coequalizer` names `relativeTensorCoequalizerIso`, which does not exist; it currently refers to a non-existent target.

- **Proof-sketch depth**: **adequate for what is formalized**; the blueprint proof of `lem:relativeTensor_as_coequalizer` is a two-paragraph sketch that describes the objectwise construction and the presheaf-level assembly. The objectwise half is completely formalized by `isColimitCofork`; the presheaf assembly half is deferred. The sketch gave the prover enough guidance.

- **Hint precision**: **one hint is wrong/premature**: `\lean{AlgebraicGeometry.Scheme.Modules.relativeTensorCoequalizerIso}` in `lem:relativeTensor_as_coequalizer` names a declaration that does not exist. It should instead point to the objectwise result `RelativeTensorCoequalizer.isColimitCofork` once a sub-lemma block is added, or remain absent until `relativeTensorCoequalizerIso` is built. The hint's current state will prevent `sync_leanok` from marking the lemma once it is closed; it is not actively harmful today (the lemma is correctly unmarked), but it is an incorrect pointer.

- **Generality**: matches need — the chapter correctly anticipates both objectwise and presheaf levels.

- **Recommended chapter-side actions**:
  1. **Add an objectwise sub-lemma block** for `RelativeTensorCoequalizer.isColimitCofork` inside the proof of `lem:relativeTensor_as_coequalizer` (or as a stand-alone lemma `lem:relativeTensorCoequalizer_objectwise`). This is the Lean-absent mathematical core completed this iter.
  2. **Update `\lean{...}` hint** in `lem:relativeTensor_as_coequalizer` once `relativeTensorCoequalizerIso` is built (next iter). For now the current pointer is premature but not blocking.

---

## Severity summary

- **must-fix-this-iter**: None. No sorries, no fake proofs, no wrong signatures on formalized declarations, no axioms on substantive claims.

- **major**:
  1. **Blueprint hint names non-existent declaration**: `\lean{AlgebraicGeometry.Scheme.Modules.relativeTensorCoequalizerIso}` in `lem:relativeTensor_as_coequalizer` — declaration absent from the file. Not blocking today (no `\leanok` to misfire), but the hint is incorrect and will confuse `sync_leanok` once the lemma is closed.
  2. **22 `RelativeTensorCoequalizer` declarations unblueprinted**: The headline `isColimitCofork` warrants at minimum one `\lean{...}` sub-lemma block in the blueprint. Blueprint-writing subagent should add it.

- **minor**:
  1. Several pre-existing blueprint-referenced declarations are `private` in Lean (`MonoidalPresheaf`, `unitModule`, `tensorPow_zero`, `tensorPow_succ`, `moduleTensorPow_zero`, `sheafificationCounitIso`, `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`). The fully-qualified names in `\lean{...}` hints don't resolve externally in Lean 4. Pre-existing; `\leanok` already set; low risk for current tooling.

**Overall verdict**: The 22 `RelativeTensorCoequalizer` declarations are genuine, axiom-clean objectwise infra for the relative-tensor coequalizer — no red flags — but the blueprint has a coverage gap: the headline result `isColimitCofork` is unblueprinted, and the `\lean{...}` hint for `lem:relativeTensor_as_coequalizer` names a presheaf-level declaration that does not yet exist.
