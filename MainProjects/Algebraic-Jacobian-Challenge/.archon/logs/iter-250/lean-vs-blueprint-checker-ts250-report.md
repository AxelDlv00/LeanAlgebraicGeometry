# Lean ↔ Blueprint Check Report

## Slug
ts250

## Iteration
250

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackEtaUnitSquare}` (chapter: `lem:eta_bridge_unit_square`)

- **Lean target exists**: yes (line 1743)
- **Signature matches**: yes
  - Blueprint: `(pullbackValIso f 𝒪_X).inv ; a_Y.map(η F) ; sheafifyUnitIso.hom = pullbackObjUnitToUnit φ`
  - Lean: `(pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).inv ≫ (PresheafOfModules.sheafification …).map (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')) ≫ sheafifyUnitIso.hom = SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom`
  - Exact match (the `letI φ'` binding is a standard definitional-unfolding idiom, not a discrepancy).
- **Proof follows sketch**: yes
  - Blueprint proof (6 steps): transpose via `homEquiv.injective`, apply `homEquiv_naturality_left/right`, use `compHomEquivFactor` (step 3), `leftAdjointUniqUnitEta` (step 4), Y-side triangle fold (step 5/substep ii = `pullbackSheafifyUnitEtaTriangle`), close (∗∗) via `presheafUnit_comp_map_eta` + `epsilonPresheafToSheafUnit` (step 6).
  - Lean proof at lines 1756–1838 follows this route precisely, including the syntactic `restrictScalarsId_map` strip as a technical side-step documented in both the Lean comment and the blueprint proof.
  - The proof requires `set_option maxHeartbeats 3200000` due to elaboration cost of the mate-calculus telescope; this is documented and expected.
- **Notes**: no `sorry`; axiom-clean (uses only `propext`/`Classical.choice`/`Quot.sound` at the kernel level per file-header report).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso}` (chapter: `lem:pullback_tensor_iso_unit`)

- **Lean target exists**: yes (line 1844)
- **Signature matches**: yes
  - Blueprint: `IsIso (δ_{(𝒪,𝒪)} : f^*(𝒪_X ⊗ 𝒪_X) → f^*𝒪_X ⊗ f^*𝒪_X)`
  - Lean: `IsIso (pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf) (SheafOfModules.unit X.ringCatSheaf))`
  - Exact match.
- **Proof follows sketch**: yes
  - Blueprint proof: apply `isIso_pullbackTensorMap_of_isIso_sheafifyDelta`, reduce to `IsIso(a_Y.map(η F))` via `left_unitality_hom` + δ-wrapping, then apply `isIso_sheafifyEta_of_unitSquare` fed by `pullbackEtaUnitSquare`.
  - Lean proof (lines 1844–1848): `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta f (isIso_sheafifyEta_of_unitSquare f (pullbackEtaUnitSquare f))` — a three-line term that chains exactly these three blueprinted lemmas.
- **Notes**: no `sorry`; axiom-clean per file-header.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.epsilonPresheafToSheafUnit}` (chapter: `lem:epsilon_presheaf_to_sheaf_unit`)

- **Lean target exists**: yes (line 1664)
- **Signature matches**: yes
  - Blueprint: `ε(pushforward φ') = (unitToPushforwardObjUnit φ).val` as morphisms of underlying presheaves; sectionwise both act as `φ.hom.app`.
  - Lean: `Functor.LaxMonoidal.ε (PresheafOfModules.pushforward φ') = (SheafOfModules.unitToPushforwardObjUnit f.toRingCatSheafHom).val`
  - Exact match.
- **Proof follows sketch**: yes
  - Blueprint: proved sectionwise, both sides act as `φ.hom.app X`.
  - Lean proof (lines 1670–1687): `apply PresheafOfModules.hom_ext; intro X₀; apply ModuleCat.hom_ext; ext r; …; erw [SheafOfModules.unitToPushforwardObjUnit_val_app_apply, ModuleCat.restrictScalars_η]; rfl` — sectionwise proof by `ext` exactly as blueprinted.
- **Notes**: no `sorry`. Uses `set_option backward.isDefEq.respectTransparency false` and `set_option maxHeartbeats 1600000` — both documented in the Lean comment (the transparency flag addresses a specific `CommRing` instance synthesis issue on the `restrictScalars (f).obj 𝟙_` carrier; not a red flag). Uses `letI` to supply the `CommRing` instance, documented clearly.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafUnit_comp_map_eta}` (chapter: `lem:presheaf_unit_comp_map_eta`)

- **Lean target exists**: yes (line 1508)
- **Signature matches**: yes
  - Blueprint: `presheafAdj.unit.app 𝟙^p ; (pushforward φ').map(η F) = ε(pushforward φ')`
  - Lean: `(PresheafOfModules.pullbackPushforwardAdjunction φ').unit.app (𝟙_ …) ≫ (PresheafOfModules.pushforward φ').map (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')) = Functor.LaxMonoidal.ε (PresheafOfModules.pushforward φ')`
  - Exact match.
- **Proof follows sketch**: yes
  - Blueprint: Mathlib's `Adjunction.unit_app_unit_comp_map_η` instantiated at `pullbackPushforwardAdjunction φ'`.
  - Lean (line 1522): `exact Adjunction.unit_app_unit_comp_map_η (PresheafOfModules.pullbackPushforwardAdjunction φ')` — one-line term proof, exactly as blueprinted.
- **Notes**: no `sorry`.

---

## Red flags

*(None found.)*

No placeholder bodies, no excuse-comments, no unauthorized axioms in the four checked declarations or their two unlisted helpers.

---

## Unreferenced declarations (informational)

### `restrictScalarsId_map` (line 1650) — no blueprint `\lean{...}` pin

A purely syntactic helper lemma: `(PresheafOfModules.restrictScalars (𝟙 R)).map g = g := rfl`. Its role is to strip `restrictScalars (𝟙)` wrappers syntactically during the `pullbackEtaUnitSquare` proof, avoiding the catastrophic whnf that `show`/`rfl` triggers on sheafification-laden composites. The blueprint's proof for `lem:eta_bridge_unit_square` mentions this stripping step in prose ("Strip the two `restrictScalars (𝟙)` wrappers SYNTACTICALLY") but does not give the lemma a `\lean{...}` tag.

**Is a pin warranted?** No — the lemma is a purely technical, one-line computational helper analogous to other un-pinned private helpers in this file (e.g., `isIso_pbu_of_final`, `isIso_sheafify_tensorHom_pullbackValIso`). The mathematical content is subsumed by the equation it helps prove. Acceptable as-is.

### `pullbackSheafifyUnitEtaTriangle` (line 1700) — no blueprint `\lean{...}` pin

The Y-side sheafification right-triangle for the oplax unit comparison: `sheafificationAdjunction.unit.app (F.obj 𝟙^p) ≫ (a_Y.map(η F)).val ≫ sheafifyUnitIso.hom.val = η F`. This is substep (ii) of the `lem:eta_bridge_unit_square` proof, extracted as a standalone lemma to avoid blowing up elaboration cost inside the main telescope (`set_option maxHeartbeats 1600000`). The blueprint's proof for `lem:eta_bridge_unit_square` describes this substep in the step-5 bullet (fold the Y-side triangle) but does not give it a `\lean{...}` tag.

**Is a pin warranted?** It is borderline: the lemma is self-contained and non-trivial (not `rfl`; uses `right_triangle_components` and `Category.comp_id`). However, it is essentially a technical extraction of one substep from a named proof, and its mathematical content is fully captured in the `lem:eta_bridge_unit_square` proof sketch. A `\lean{...}` pin would be a nice addition for transparency but is not required. Acceptable without a pin.

---

## Blueprint adequacy for this file

- **Coverage**: The four new `\lean{...}`-pinned declarations all have dedicated `\begin{lemma}...\end{lemma}` blocks in the blueprint. The two unlisted helpers (`restrictScalarsId_map`, `pullbackSheafifyUnitEtaTriangle`) are consciously project-local. The three pre-existing declarations verified axiom-clean this iter (`isIso_sheafifyEta_of_unitSquare`, `compHomEquivFactor`, `leftAdjointUniqUnitEta`) also have `\lean{...}` blocks. Coverage is 4/4 for this iter's targets.

- **Proof-sketch depth**: **adequate** for all four new declarations. Each blueprint proof block contains the concrete lemma names and proof steps needed to reproduce the formalization. The seven-step telescope for `lem:eta_bridge_unit_square` maps step-by-step to the Lean proof.

- **Hint precision**: **precise**. Each `\lean{...}` tag names the exact Lean declaration; informal statements are at the right level of specificity (naming `a_Y.map(η F)`, `sheafifyUnitIso`, `pullbackValIso`, etc.).

- **Generality**: **matches need**. All declarations are stated for a general scheme morphism `f : Y ⟶ X`; no unnecessary over- or under-generalization.

- **One minor adequacy issue** (see Severity summary): The **D2′ overview paragraph** (blueprint around line 2670–2680) describes D2′ as using "Mathlib monoidal-unit coherences `δ_comp_η_tensorHom` / `δ_comp_tensorHom_η`" — this is a stale description from the pre-iter-246 route. The actual proof route (used in Lean and correctly described in the per-lemma `\begin{proof}` block for `lem:pullback_tensor_iso_unit`) goes through `W_of_isIso_sheafification` + `W_whiskerRight_of_W` + the δ-wrapping lemma `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta`. The per-lemma proof sketch is correct; the stale text is only in the overview itemized list.

- **Recommended chapter-side actions**:
  - Update the D2′ overview bullet (lines 2670–2680) to remove the reference to `δ_comp_η_tensorHom` / `δ_comp_tensorHom_η` and replace with the actual route: "via `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` (the δ-wrapping reduction using `W_of_isIso_sheafification` + `W_whiskerRight_of_W`) and the unit square `lem:eta_bridge_unit_square`."

---

## Severity summary

- **must-fix-this-iter**: none
- **major**: none
- **minor** (1):
  - Blueprint D2′ overview paragraph (lines ~2670–2680) contains stale Mathlib lemma names (`δ_comp_η_tensorHom` / `δ_comp_tensorHom_η`) that do not match the actual proof route. The per-lemma `\begin{proof}` block is correct; only the overview is stale. No formalization is misled by this (the proof is complete and axiom-clean), but the overview is misleading to a future reader.

**Overall verdict**: The Lean file faithfully implements the blueprint at all four new `\lean{...}`-pinned declarations; the two project-local helpers without blueprint pins are appropriately scoped; one minor stale prose passage in the D2′ overview should be updated in a future blueprint-writing pass.
