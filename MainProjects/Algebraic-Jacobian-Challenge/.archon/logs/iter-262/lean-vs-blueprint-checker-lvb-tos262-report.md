# Lean ↔ Blueprint Check Report

## Slug
lvb-tos262

## Iteration
262

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (2692 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (> 4000 lines, focused on `sec:tensorobj_pullback_monoidality` and D3′ sub-lemmas)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: `def:scheme_modules_tensorobj`)
- **Lean target exists**: yes
- **Signature matches**: yes — sheafification of `PresheafOfModules.Monoidal.tensorObj`, per blueprint definition
- **Proof follows sketch**: yes (no sorry; cheap sheafify-then-lift body)
- **notes**: Blueprint `\leanok` on statement; proof block `\leanok` both present. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: `lem:scheme_modules_tensorobj_functoriality`)
- **Lean target exists**: yes
- **Signature matches**: yes — pair of morphisms → morphism on tensorObj
- **Proof follows sketch**: yes (no sorry; `sheafification.map` of tensorHom)
- **notes**: Blueprint correctly notes unitors/associator/braiding are NOT outputs of this lemma.

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (chapter: `def:scheme_modules_isinvertible`)
- **Lean target exists**: yes
- **Signature matches**: yes — `∃ N, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: N/A (Prop definition)
- **notes**: Correct. Blueprint `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (chapter: `lem:tensorobj_restrict_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)` for open immersion `f`
- **Proof follows sketch**: yes — 4-step composite (restrictFunctorIsoPullback, sheafificationCompPullback, strip sheafification, H1∘H2)
- **notes**: No sorry. Blueprint `\leanok` on statement and proof blocks. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_isLocallyTrivial}` (chapter: `lem:tensorobj_preserves_locally_trivial`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — common affine open → restrict to W → tensorObj_restrict_iso + tensorObjIsoOfIso + tensorObj_unit_iso
- **notes**: No sorry. Consistent with blueprint.

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: `lem:tensorobj_inverse_invertible`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(hL : IsLocallyTrivial L) → ∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)`
- **Proof follows sketch**: partial — body is `:= sorry`
- **notes**: Blueprint marks this lemma as "infrastructure-blocked" (no `\leanok` on proof block). The sorry is expected and correctly characterized. Cross-file gated on `DualInverse.lean` (C-bridge `dual_isLocallyTrivial` + A-bridge `homOfLocalCompat`). **No red flag** — the sorry is correctly authorized by the blueprint.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (chapter: `lem:tensorobj_assoc_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes — unconditional, no flatness hypothesis
- **Proof follows sketch**: yes — sheafification transport via `W_whisker{Right,Left}_of_W` + `isIso_sheafification_map_of_W`
- **notes**: No sorry. Blueprint `\leanok` on statement and proof. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor}` and `tensorObj_right_unitor` (chapter: `lem:tensorobj_unit_iso`)
- **Lean target exists**: yes (both)
- **Signature matches**: yes
- **Proof follows sketch**: yes — cheap `mapIso` pattern on presheaf unitors + sheafification counit
- **notes**: No sorry. Blueprint `\leanok` marked. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (chapter: `lem:tensorobj_comm_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — cheap `mapIso` on presheaf braiding
- **notes**: No sorry. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.PicGroup}` and `\lean{AlgebraicGeometry.Scheme.Modules.picCommGroup}` (chapter: `lem:tensorobj_isoclass_commgroup`)
- **Lean target exists**: yes (both)
- **Signature matches**: yes — `PicGroup X : Type _` as quotient of `IsInvertible` objects; `picCommGroup` provides `CommGroup (PicGroup X)` instance
- **Proof follows sketch**: yes — each group axiom fed by a single existence-of-isomorphism (no pentagon/triangle)
- **notes**: No sorry (iter-238 DONE). Blueprint `\leanok` on both statement and proof blocks. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafPushforwardLaxMonoidal}` (chapter: `lem:presheaf_pushforward_laxmonoidal`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(PresheafOfModules.pushforward φ).LaxMonoidal` instance
- **Proof follows sketch**: yes — `Functor.LaxMonoidal.comp` of `pushforward₀` (strong) and `restrictScalars φ'` (lax)
- **notes**: No sorry. Blueprint `\leanok` present.

### `\lean{AlgebraicGeometry.Scheme.Modules.presheafPullbackOplaxMonoidal}` (chapter: `lem:presheaf_pullback_oplaxmonoidal`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(PresheafOfModules.pullback φ).OplaxMonoidal` instance via `leftAdjointOplaxMonoidal`
- **Proof follows sketch**: yes — doctrinal adjunction transfer
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap}` (chapter: `lem:pullback_tensor_map`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(pullback f).obj (tensorObj M N) ⟶ tensorObj ((pullback f).obj M) ((pullback f).obj N)`
- **Proof follows sketch**: yes — four-fold composite: sheafificationCompPullback ≫ a_Y.map δ ≫ sheafifyTensorUnitIso ≫ a_Y.map (tensorHom of pullbackValIsos)
- **notes**: No sorry. Blueprint `\leanok` on statement and proof. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.isIso_pullbackTensorMap_of_isIso_sheafifyDelta}` (chapter: `lem:isiso_pullbacktensormap_of_sheafifydelta`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — three of four factors unconditionally iso; sole conditional = `a_Y.map δ`
- **notes**: No sorry. Blueprint `\leanok`. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.unitToPushforwardObjUnit_comp}` (chapter: `lem:unitToPushforwardObjUnit_comp`)
- **Lean target exists**: yes
- **Signature matches**: yes — `upu(h≫f) = upu f ≫ (pushforward f).map (upu h) ≫ (pushforwardComp h f).hom.app 𝒪_Z`
- **Proof follows sketch**: yes — definitional/`rfl` after `ext` chain (sectionwise ring-map functoriality)
- **notes**: No sorry.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackObjUnitToUnit_comp}` (chapter: `lem:pullbackObjUnitToUnit_comp`)
- **Lean target exists**: yes
- **Signature matches**: yes — `pbu(h≫f) = (pullbackComp h f).inv.app 𝒪 ≫ (pullback h).map (pbu f) ≫ pbu h`
- **Proof follows sketch**: yes — adjunction-mate transport from the pushforward-side coherence
- **notes**: No sorry. ~80 lines of mate calculus. Consistent with blueprint.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackUnitIso}` (chapter: `lem:pullback_unit_iso`)
- **Lean target exists**: yes
- **Signature matches**: yes — `(pullback f).obj 𝒪_X ≅ 𝒪_Y`
- **Proof follows sketch**: yes — unconditional (always-Final `Opens.map f.base`, `isIso_pbu_of_final`)
- **notes**: No sorry. The elaborate chart-chase in the blueprint proof sketch is superseded by the unconditional finality argument; the blueprint's text acknowledges this.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso}` (D2′; chapter: `lem:pullback_tensor_iso_unit`)
- **Lean target exists**: yes
- **Signature matches**: yes — `IsIso (pullbackTensorMap f 𝒪_X 𝒪_X)`
- **Proof follows sketch**: yes — chains `pullbackEtaUnitSquare → isIso_sheafifyEta_of_unitSquare → isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta`
- **notes**: No sorry (iter-250 DONE, axiom-clean). Blueprint `\leanok` on statement and proof. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}` (D1′; chapter: `lem:pullback_tensor_map_natural`)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes — four-square paste (S1 NatTrans, S2 δ_natural via mapin255 ascription, S3 sheafifyTensorUnitIso_hom_natural, S4 pullbackValIso_hom_natural + bifunctoriality)
- **notes**: No sorry (iter-255 DONE). Blueprint `\leanok`. Consistent.

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` (D3′; chapter: `lem:pullback_tensor_map_basechange`)
- **Lean target exists**: yes
- **Signature matches**: yes — `pullbackTensorMap (h≫f) M N = (pullbackComp h f).inv.app (tensorObj M N) ≫ (pullback h).map (pullbackTensorMap f M N) ≫ pullbackTensorMap h (f^*M) (f^*N) ≫ (tensorObjIsoOfIso (pullbackComp h f).app M ...).hom`
- **Proof follows sketch**: partial — proof scaffold open to the 4-vs-10 factor paste; `:= sorry` at line 2683
- **notes**: Blueprint `\leanok` on STATEMENT block (declaration exists with sorry); NO `\leanok` on proof block. Correct state per blueprint marker rules. The sorry is authorized. Gated on Sq1 (`sheafificationCompPullback_comp`) and Sq4 (`pullbackValIso` composition coherence).

### Remaining blueprint-pinned lemmas (all `\leanok` and no sorry)
`sheafifyTensorUnitIso_hom_natural`, `pullbackValIso_hom_natural`, `pullbackLanDecomposition`, `presheafUnit_comp_map_eta`, `isIso_sheafifyEta_of_unitSquare`, `pullbackEtaUnitSquare`, `compHomEquivFactor`, `sheafificationCompPullback_eq_leftAdjointUniq`, `leftAdjointUniqUnitEta`, `epsilonPresheafToSheafUnit` — all exist, no sorry, signatures match blueprint descriptions. Consistent.

---

## Red flags

None found.

### Placeholder / suspect bodies
- `exists_tensorObj_inverse` at line ~700: body is `:= sorry`. This is **authorized** — the blueprint explicitly marks this as "infrastructure-blocked" with no `\leanok` on the proof block, and the Lean file's docstring accurately describes the two open bridges (C-bridge `dual_isLocallyTrivial`, A-bridge `homOfLocalCompat`). Not a red flag.
- `sheafificationCompPullback_comp` (private, ~line 2471): body ends in `sorry` (line 2565). This is the Sq1 sub-lemma, R0-peel completed in iter-262, tail remaining. **Not a red flag** — this private lemma is not `\lean{...}`-pinned; its sorry is expected and accurately characterized in the Lean proof comments.
- `pullbackTensorMap_restrict` at line 2588: body ends in `sorry` (line 2683). **Not a red flag** — authorized by the blueprint's absent proof-block `\leanok`.

### Excuse-comments
None found. The lengthy `-- ROADMAP` and `-- ITER-*` comments accurately describe proof structure and do not excuse wrong code. They are genuinely informative proof-development notes.

### Axioms / Classical.choice on non-trivial claims
No unauthorized `axiom` declarations found. `Classical.choice` appears only inside `picInv` (well-defined by `IsInvertible.inverse_unique`) and `exists_tensorObj_inverse` (which is marked `sorry` anyway) — both authorized.

---

## Unreferenced declarations (informational)

The following substantive declarations in the Lean file have no `\lean{...}` pin in the blueprint. All are private sub-helpers or off-path infrastructure and appropriately unlisted.

- `sheaf_unit_comp_pushforward_pullbackComp_inv` (private, **new iter-262**): the R0-peel building block for Sq1. Axiom-clean, no sorry. Correctly unlisted (it's a private helper inside `sheafificationCompPullback_comp`'s proof).
- `sheafificationCompPullback_comp` (private): Sq1 for D3′. Has sorry (tail remaining). Described in blueprint's D3′ proof prose ("Sq1: the composition coherence of `sheafificationCompPullback`") but not individually `\lean{...}`-pinned — appropriate for a private sub-lemma.
- `pullbackComp_δ` (private): Sq2b for D3′. No sorry (iter-259 DONE). Described in blueprint prose as "Sq2b: monoidality of `pullbackComp`". Correctly unlisted.
- `pushforwardComp_lax_μ` (private): Sq2b residual. No sorry (iter-261 DONE). Correctly unlisted.
- `toRingCatSheafHom_comp_hom_reconcile` (private): Sq2 ring-map reconciliation. No sorry. Blueprint description correctly notes this is definitional (`rfl`). Correctly unlisted.
- `restrictIsoUnitOfLE`, `dualIsoOfIso`, `tensorObj_middleFour`, `picSetoid`, `picMul`, `picInv` — supporting helper definitions for the Picard group carrier. Correctly unlisted (implementation details).
- Private helpers `restrictScalars_μ_app`, `forget₂_restrictScalars_μ_hom_tmul`, `restrictScalars_μ_app_tmul`, `pushforward_map_restrictScalars_μ_app_tmul`, `pushforward_μ_eq`: sub-steps for `pushforwardComp_lax_μ` / Sq2b. Correctly unlisted.
- `W_of_isIso_sheafification`, `isIso_sheafify_tensorHom_pullbackValIso`, `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta`, `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta`, `sheafifyUnitIso`, `pullbackObjUnitToUnitIso`, `pullbackObjUnitToUnitIso_hom`, `isIso_pbu_of_final`, `pullbackSheafifyUnitEtaTriangle`, `sheafifyTensorUnitIso`, `sheafifyTensorUnitIso_hom_eq`, `sheafifyTensorUnitIso_hom_eq'`, `pullbackValIso`, `pullback0`, `pullback0Adjunction`, `extendScalars`, `extendScalarsAdjunction`, `pullbackLanDecomposition`, etc. — all correctly unlisted as infrastructure / off-path / private helpers.

No unreferenced substantive declaration was found that should be `\lean{...}`-pinned.

---

## Blueprint adequacy for this file

- **Coverage**: 30/30 `\lean{...}`-pinned declarations have a corresponding Lean declaration. 0 substantive declarations are missing a blueprint reference (private sub-helpers are appropriately exempt). Coverage is complete.

- **Proof-sketch depth**: **adequate** for the main critical-path content. The following specific checks are requested by the directive:

  **Sq1 (`sheafificationCompPullback_comp`) — the primary directive focus:**

  The blueprint's D3′ proof (§`lem:pullback_tensor_map_basechange`) describes Sq1 as follows:
  > "Sq1 (the S1 connecting iso): The composition coherence of `sheafificationCompPullback` across `h∘f` is Mathlib-absent; it is established as a project sub-lemma by the adjunction-mate calculus, exactly mirroring the unit companion `lem:pullbackObjUnitToUnit_comp`: both `sheafificationCompPullback` isos are `leftAdjointUniq` of composite adjunctions (`sheafification_comp_pullback_eq_leftadjointuniq`), and transposing the whole identity under `A_{h∘f}` yields the concrete unit-level identity."

  **No analogous overclaim to the Sq2b iter-260 false "definitional" claim is present.** Specifically:
  - The Sq2b iter-260 overclaim was that the μ-residual (`pushforwardComp_lax_μ`) was "rfl/short ext" — empirically false (it required genuine `ModuleCat.restrictScalars_μ_tmul` content).
  - The Sq1 prose does NOT claim the coherence is trivial, definitional, or an `rfl`. It correctly says "Mathlib-absent, a project sub-lemma" proved by "adjunction-mate calculus."
  - The blueprint's description "exactly mirroring the unit companion" is accurate: the Lean implementation follows the same approach (transpose under `A_{h≫f}`, use `homEquiv_leftAdjointUniq_hom_app`, peel R0 via `sheaf_unit_comp_pushforward_pullbackComp_inv`, then R1/R5 tail mirroring `pullbackObjUnitToUnit_comp` L969-996).

  **Current iter-262 state:** R0 fully peeled (new axiom-clean helper `sheaf_unit_comp_pushforward_pullbackComp_inv` + `conv_rhs` distribution + `have key` + `erw [reassoc_of% key]`). Remaining = R1/R5 collapse tail (analog of `hinner`/`hcomp'` + final erw chain of the unit companion). The blueprint sketch is adequate to guide this tail (it correctly names the building blocks: `homEquiv_leftAdjointUniq_hom_app`, `pushforwardComp.hom.naturality`, `comp_unit_app`/`unit_naturality`). **No must-fix on the blueprint side.**

  **D3′-outer (`pullbackTensorMap_restrict`):** The blueprint proof block correctly describes the four-square paste structure (Sq1/Sq2b/Sq3/Sq4), describes why the unit-analog mate-calculus does not transfer (not an adjunction transpose), and says the proof "pastes the four squares directly." The Lean scaffold at lines 2680-2683 has opened the goal to the explicit 4-vs-10 factor paste and will consume Sq1 + Sq4 when those close. Blueprint description matches the Lean state.

- **Hint precision**: **precise**. All `\lean{...}` hints name the correct fully-qualified declarations.

- **Generality**: **matches need**. No parallel API was written to cover a gap in the blueprint's generality specification.

- **Recommended chapter-side actions**: None required. The blueprint accurately characterizes the current state, including:
  - Sq1 as "exactly mirroring the unit companion" (correct, no overclaim)
  - D3′ as "paste of four composition-coherence squares" (correct)
  - `pullbackTensorMap_restrict` as having `\leanok` on statement (correct: declaration exists with sorry) and no `\leanok` on proof (correct: sorry present)

---

## Severity summary

- **must-fix-this-iter**: 0 findings
- **major**: 0 findings
- **minor**: 0 findings

---

**Overall verdict:** The Lean file follows the blueprint faithfully across all 30 `\lean{...}`-pinned declarations. The Sq1 blueprint prose ("exactly mirroring the unit companion") is an accurate description without the analogous overclaim; the remaining Sq1 tail (R1/R5 collapse) is correctly characterized. The blueprint is adequate to guide the remaining D3′ work. 3 sorries total — 2 authorized by the blueprint (D3′-outer, dual-inverse) and 1 in-progress private sub-lemma (Sq1). **30 declarations checked, 0 red flags.**
