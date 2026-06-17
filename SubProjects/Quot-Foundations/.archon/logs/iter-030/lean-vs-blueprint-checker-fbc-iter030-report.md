# Lean ↔ Blueprint Check Report

## Slug
fbc-iter030

## Iteration
030

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

---

## Sorry count (pre-check)

Actual sorry keywords in the Lean file (4 total, all authorized):
| Line | Declaration |
|------|-------------|
| 1461 | `base_change_mate_fstar_reindex_legs` |
| 1833 | `base_change_mate_gstar_transpose` |
| 2014 | `affineBaseChange_pushforward_iso` |
| 2036 | `flatBaseChange_pushforward_isIso` |

Lines 237, 845, 1757–1758, 1822, 1854, 1856, 1926–1927, 1998 contain the string "sorry" only inside comments. No extra sorry keywords exist.

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`)
- **Lean target exists**: yes (lines 1–79)
- **Signature matches**: yes — `(comm : g' ≫ f = f' ≫ g) (F : X.Modules) → (pull g).obj ((push f).obj F) → (push f').obj ((pull g').obj F)` matches the informal "canonical morphism g*(f_*F) → f'_*((g')^*F)"
- **Proof follows sketch**: yes (def built from adjunction counit)
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (chapter: `lem:modules_isIso_iff_stalk`)
- **Lean target exists**: yes (line 102)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (chapter: `lem:modules_isIso_of_isBasis`)
- **Lean target exists**: yes (line 128)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (chapter: `lem:modules_isIso_iff_affineOpens`)
- **Lean target exists**: yes (line 164)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (chapter: `lem:globalSectionsIso_hom_comp_specMap_appTop`)
- **Lean target exists**: yes (line 268)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (chapter: `lem:gammaPushforwardIso`)
- **Lean target exists**: yes (line 288)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (chapter: `lem:gammaPushforwardTildeIso`)
- **Lean target exists**: yes (line 313)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (chapter: `lem:gammaPushforwardIsoAt`)
- **Lean target exists**: yes (line 331)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (chapter: `lem:fromTildeGamma_app_isIso_of_localized`)
- **Lean target exists**: yes (line 367)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (chapter: `lem:pushforward_spec_tilde_iso_conditional`)
- **Lean target exists**: yes (line 431)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (chapter: `lem:powers_restrictScalars`)
- **Lean target exists**: yes (line 455)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (chapter: `lem:tildeRestriction_isLocalizedModule`)
- **Lean target exists**: yes (line 483)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (chapter: `lem:pushforward_spec_tilde_iso`)
- **Lean target exists**: yes (line 538)
- **Signature matches**: yes — `Spec.map φ ⋙ push` adjunct iso for tilde of a module
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry; one of the two affine tilde dictionaries fully closed

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (chapter: `lem:gammaPushforwardNatIso`)
- **Lean target exists**: yes (line 667)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (chapter: `lem:pullback_spec_tilde_iso`)
- **Lean target exists**: yes (line 689)
- **Signature matches**: yes — the companion pullback tilde dictionary
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry; both tilde dictionaries now fully proved

### `\lean{AlgebraicGeometry.pullbackSpecIso}` (chapter: `lem:pullbackSpecIso`, `\mathlibok`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: `\mathlibok` correct

### `\lean{TensorProduct.AlgebraTensorModule.cancelBaseChange}` (or `Algebra.IsPushout.cancelBaseChange`) (chapter: `lem:cancelBaseChange_mathlib`, `\mathlibok`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: `\mathlibok` correct

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (chapter: `lem:pullback_fst_snd_specMap_tensor`)
- **Lean target exists**: yes (line 709)
- **Signature matches**: yes — identifies pullback.fst/snd over Spec-of-tensor square with inclusion maps
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry; the one Mathlib-absent step the blueprint calls out

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (chapter: `lem:base_change_mate_domain_read`)
- **Lean target exists**: yes (line 737)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (chapter: `lem:pullbackIsoEquivalenceOfIso`)
- **Lean target exists**: yes (line 753)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (chapter: `lem:pullback_isEquivalence_of_iso`)
- **Lean target exists**: yes (line 762, instance)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (chapter: `lem:base_change_mate_codomain_read`)
- **Lean target exists**: yes (line 773)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (chapter: `lem:base_change_mate_regroupEquiv`)
- **Lean target exists**: yes (line 856)
- **Signature matches**: yes — native R'-linear isomorphism (A⊗_R R')⊗_A M ≅ R'⊗_R M
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{CategoryTheory.unit_conjugateEquiv}` (or similar) (chapter: `lem:unit_conjugateEquiv`, `\mathlibok`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: `\mathlibok` correct

### `\lean{CategoryTheory.Adjunction.comp_unit_app}` (chapter: `lem:comp_unit_app`, `\mathlibok`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: `\mathlibok` correct

### `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (chapter: `lem:base_change_mate_unit_value`)
- **Lean target exists**: yes (line 987)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry; uses `set_option maxHeartbeats 4000000` — not a red flag, elaboration-heavy proof

### `\lean{AlgebraicGeometry.base_change_mate_inner_value}` (chapter: `def:base_change_mate_inner_value`)
- **Lean target exists**: yes (line 1102)
- **Signature matches**: yes — the inner pushforward comparison morphism θ_in
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}` (chapter: `lem:pullbackPushforward_unit_comp`)
- **Lean target exists**: yes (line 1144)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}` (chapter: `lem:gammaMap_pushforwardComp_hom_eq_id`)
- **Lean target exists**: yes (line 1174)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id}` (chapter: `lem:gammaMap_pushforwardComp_inv_eq_id`)
- **Lean target exists**: yes (line 1182)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.gammaMap_pushforwardCongr_hom}` (chapter: `lem:gammaMap_pushforwardCongr_hom`)
- **Lean target exists**: yes (line 1193)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs}` (chapter: `lem:base_change_mate_codomain_read_legs`)
- **Lean target exists**: yes (line 1210)
- **Signature matches**: yes — leg-parametrized variant carrying pullback cone legs as free variables, avoiding the motive-not-type-correct wall
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry; the blueprint note correctly records why the leg-parametrized form was needed

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_unitExpand}` (chapter: `lem:base_change_mate_fstar_reindex_legs_unitExpand`)
- **Lean target exists**: yes (line 1273)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_gammaDistribute}` (chapter: `lem:base_change_mate_fstar_reindex_legs_gammaDistribute`)
- **Lean target exists**: yes (line 1304)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

---

### ⚠ `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distribute}` (chapter: `lem:base_change_mate_fstar_reindex_legs_link_distribute`)
- **Lean target exists**: **NO** — no declaration with this name exists anywhere in FlatBaseChange.lean
- **Signature matches**: N/A (declaration absent)
- **Proof follows sketch**: N/A
- **notes**: `\lean{}` pin is DANGLING. Blueprint block has no `\leanok` (correctly marking it unformalized). The mathematical content (distributing the composed-adjunction unit through the `Γ`-image functor into a three-factor product) is partially covered by the fused helper `base_change_mate_fstar_reindex_legs_link_distributeCollapse` (lines 1333–1367), but under a DIFFERENT name and fused with L2 content — no standalone `_link_distribute` theorem was built.

### ⚠ `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_collapseComp}` (chapter: `lem:base_change_mate_fstar_reindex_legs_link_collapseComp`)
- **Lean target exists**: **NO**
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: `\lean{}` pin is DANGLING. Blueprint block has no `\leanok`. The mathematical content (collapsing the two transparent `pushforwardComp` factors in the distributed form) is fused into `link_distributeCollapse` together with L1 — no standalone `_link_collapseComp` theorem was built.

### ⚠ `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_cancelEUnit}` (chapter: `lem:base_change_mate_fstar_reindex_legs_link_cancelEUnit`)
- **Lean target exists**: **NO**
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: `\lean{}` pin is DANGLING. Blueprint block has no `\leanok`. The blueprint describes canceling the `e`-unit (factor 2) of the distributed form against the codomain read — the ATOMIC version `base_change_mate_inner_eCancel_eUnit` (line 1538) exists, but the LEGS-CONTEXT wrapper `_legs_link_cancelEUnit` was not built.

### ⚠ `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_cancelPullbackComp}` (chapter: `lem:base_change_mate_fstar_reindex_legs_link_cancelPullbackComp`)
- **Lean target exists**: **NO**
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: `\lean{}` pin is DANGLING. Blueprint block has no `\leanok`. The blueprint describes canceling the `pullbackComp.hom` factor (factor 3) against the codomain read — the ATOMIC version `base_change_mate_inner_eCancel_pullbackComp` (line 1567) exists, but the LEGS-CONTEXT wrapper `_legs_link_cancelPullbackComp` was not built.

### ⚠ `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_survivor}` (chapter: `lem:base_change_mate_fstar_reindex_legs_link_survivor`)
- **Lean target exists**: **NO**
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: `\lean{}` pin is DANGLING. Blueprint block has no `\leanok`. The blueprint describes evaluating the surviving (factor 1) via Seam 1 + `base_change_mate_inner_value` — no Lean declaration `_legs_link_survivor` exists. This is the final step that would close the `_legs` sorry; it remains entirely unbuilt.

---

### Narrative nodes (three blocks pinning `_legs` as subsuming theorem)

#### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (chapter: `lem:base_change_mate_inner_unitReduce`)
- **Lean target exists**: yes (`_legs` at line 1381, with authorized sorry@1461)
- **Signature matches**: yes (narrative node documents a sub-step incorporated into `_legs`)
- **Proof follows sketch**: N/A (narrative)
- **notes**: pattern is established project convention for documenting sub-steps of a composite proof without requiring standalone declarations

#### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (chapter: `lem:base_change_mate_inner_eCancel`)
- **Lean target exists**: yes
- **Signature matches**: yes (narrative)
- **Proof follows sketch**: N/A
- **notes**: same pattern

#### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (chapter: `lem:base_change_mate_inner_eCancel_assemble`)
- **Lean target exists**: yes
- **Signature matches**: yes (narrative)
- **Proof follows sketch**: N/A
- **notes**: same pattern

---

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (chapter: `lem:base_change_mate_fstar_reindex_legs`)
- **Lean target exists**: yes (lines 1381–1461)
- **Signature matches**: yes — cone legs as free variables, parametrized form
- **Proof follows sketch**: partial — proof uses `link_distributeCollapse` (the fused L1+L2 helper, iter-030 addition) in term-mode splice via `refine (congrArg … link_distributeCollapse …).trans ?_`; residual eCancel telescoping (L3+L4+L5 content) remains as authorized `sorry`@1461
- **notes**: authorized sorry; `\leanok` on statement block CORRECT (formalized, sorry present); no `\leanok` on proof block CORRECT (proof not closed)

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (chapter: `lem:base_change_mate_fstar_reindex`)
- **Lean target exists**: yes (line 1475)
- **Signature matches**: yes — the non-legs form with concrete `pullback.fst/snd`
- **Proof follows sketch**: yes (`exact base_change_mate_fstar_reindex_legs ...`)
- **notes**: no inline sorry; transitively sorry-backed through `_legs`; `\leanok` markers consistent

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_eUnit}` (chapter: `lem:base_change_mate_inner_eCancel_eUnit`)
- **Lean target exists**: yes (line 1538)
- **Signature matches**: yes — cancels `η^e` (the e-unit) against the codomain read factor
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry; these three eCancel atoms are the building blocks for L3–L5 of the link decomposition

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pushforwardComp}` (chapter: `lem:base_change_mate_inner_eCancel_pushforwardComp`)
- **Lean target exists**: yes (line 1550)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pullbackComp}` (chapter: `lem:base_change_mate_inner_eCancel_pullbackComp`)
- **Lean target exists**: yes (line 1567)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.base_change_mate_gstar_generator_close}` (chapter: `lem:base_change_mate_gstar_generator_close`)
- **Lean target exists**: yes (line 1585)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.base_change_mate_inner_value_eq}` (chapter: `lem:base_change_mate_inner_value_eq`)
- **Lean target exists**: yes (line 1624)
- **Signature matches**: yes
- **Proof follows sketch**: yes (delegates to `base_change_mate_fstar_reindex`)
- **notes**: no inline sorry; transitively sorry-backed through `_legs`

### `\lean{AlgebraicGeometry.base_change_mate_gstar_counit_transport}` (chapter: `lem:base_change_mate_gstar_counit_transport`)
- **Lean target exists**: yes (line 1652)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (chapter: `lem:base_change_mate_gstar_transpose`)
- **Lean target exists**: yes (lines 1702–1833)
- **Signature matches**: yes — the g*-transpose crux relating the section-level base-change map to the regrouping isomorphism
- **Proof follows sketch**: partial — proof reaches authorized `sorry`@1833; extensive tactic work present, sorry is the crux of the gstar calculation
- **notes**: authorized sorry; `\leanok` on statement block CORRECT; no `\leanok` on proof block CORRECT

### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (chapter: `lem:base_change_mate_section_identity`)
- **Lean target exists**: yes (line 1862)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: no inline sorry; transitively sorry-backed through `gstar_transpose`

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (chapter: `lem:base_change_mate_generator_trace`)
- **Lean target exists**: yes (line 1891)
- **Signature matches**: yes — `IsIso` corollary of section identity (not the literal generator formula; blueprint `% NOTE:` correctly records this)
- **Proof follows sketch**: yes
- **notes**: no inline sorry; transitively sorry-backed through `gstar_transpose`

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (chapter: `lem:pushforward_base_change_mate_cancelBaseChange`)
- **Lean target exists**: yes (line 1932)
- **Signature matches**: partial — Lean formalizes the `IsIso(Γ(α))` corollary form rather than the literal equality `Θ_tgt ∘ Γ(α) ∘ Θ_src⁻¹ = cancelBaseChange⁻¹`; blueprint `% NOTE:` at line 2843 explicitly acknowledges and justifies this deviation
- **Proof follows sketch**: yes (the `% NOTE:` explains the deviation is deliberate and the `IsIso` form is what the affine close consumes)
- **notes**: no inline sorry; transitively sorry-backed through `gstar_transpose`; the signature deviation is intentional and documented, not a mismatch

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (chapter: `lem:base_change_map_affine_local`)
- **Lean target exists**: yes (line 1971)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: axiom-clean, no sorry

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`)
- **Lean target exists**: yes (lines 1983–2014)
- **Signature matches**: yes — affine base change isomorphism g*(f_*F) ≅ f'_*((g')^*F) when f is affine
- **Proof follows sketch**: partial — reaches authorized `sorry`@2014
- **notes**: authorized sorry; `\leanok` on statement block CORRECT; no `\leanok` on proof block CORRECT

### `\lean{LinearMap.tensorEqLocusEquiv}` (chapter: `lem:flat_preserves_equalizer_mathlib`, `\mathlibok`)
- **Lean target exists**: yes (Mathlib)
- **Signature matches**: yes — flat base change commutes with finite equalizers
- **Proof follows sketch**: N/A (Mathlib)
- **notes**: `\mathlibok` correct

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`)
- **Lean target exists**: yes (lines 2016–2036)
- **Signature matches**: yes — the main theorem: flat g, qcqs f, quasi-coherent F → g*(f_*F) ≅ f'_*((g')^*F)
- **Proof follows sketch**: partial — reaches authorized `sorry`@2036
- **notes**: authorized sorry; `\leanok` on statement block CORRECT; no `\leanok` on proof block CORRECT

---

## Red flags

### Dangling `\lean{}` pins

Five blueprint blocks name Lean declarations that do not exist:

1. **`lem:base_change_mate_fstar_reindex_legs_link_distribute`** → `AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distribute` — NO such declaration. None of the five have `\leanok`, so no false claim of completion is made, but the `\lean{}` pins are forward-references that the prover must honor in a future iteration.

2. **`lem:base_change_mate_fstar_reindex_legs_link_collapseComp`** → `…_link_collapseComp` — MISSING.

3. **`lem:base_change_mate_fstar_reindex_legs_link_cancelEUnit`** → `…_link_cancelEUnit` — MISSING. The atomic `base_change_mate_inner_eCancel_eUnit` (line 1538) exists but the legs-context wrapper does not.

4. **`lem:base_change_mate_fstar_reindex_legs_link_cancelPullbackComp`** → `…_link_cancelPullbackComp` — MISSING. The atomic `base_change_mate_inner_eCancel_pullbackComp` (line 1567) exists but the legs-context wrapper does not.

5. **`lem:base_change_mate_fstar_reindex_legs_link_survivor`** → `…_link_survivor` — MISSING. This is the final step that would close the `_legs` sorry; entirely absent from the Lean file.

**Impact**: The `\lean{}` system cannot resolve these five pins. blueprint-doctor will report them as broken `\lean{}` references. No false `\leanok` is involved, so this does not inflate the "formalized" count.

### Blueprint ↔ Lean name mismatch: `link_distributeCollapse` vs `link_distribute` + `link_collapseComp`

The prover built `AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distributeCollapse` (lines 1333–1367), which:
- Is axiom-clean, compiles, has no sorry
- Fuses the mathematical content of blueprint L1 (`distribute`) and L2 (`collapseComp`) into a single lemma
- Is referenced from `_legs` via term-mode splice: `refine (congrArg … link_distributeCollapse …).trans ?_`
- Is NOT referenced by ANY blueprint `\lean{}` block

The blueprint pins `_link_distribute` and `_link_collapseComp` separately; the Lean has `_link_distributeCollapse` fused. The planner must choose one reconciliation path:

- **Path A (split)**: break `link_distributeCollapse` into two standalone declarations matching the blueprint names, then update `_legs` to use them.
- **Path B (merge)**: update the blueprint to replace `lem:base_change_mate_fstar_reindex_legs_link_distribute` and `lem:base_change_mate_fstar_reindex_legs_link_collapseComp` with a single `lem:base_change_mate_fstar_reindex_legs_link_distributeCollapse` pinned to the existing Lean declaration.

Neither is obviously superior. Path B is lower-risk (avoids touching proved Lean code), but requires the plan agent to update blueprint structure.

### No unauthorized sorries, no false `\leanok`

- Exactly 4 sorry keywords at lines 1461, 1833, 2014, 2036 — all authorized.
- Every `\leanok` on a statement block corresponds to a declaration that exists in the Lean file.
- No proof block carries `\leanok` for a sorry-bearing declaration.
- No `:= sorry` on a declaration the blueprint claims is substantive (all four sorry bodies are authorized and the blueprint blocks for them are correctly unmarked at the proof level).

### No placeholder or excuse-comment bodies

- No `:= True`, `:= rfl` on non-trivial claims.
- The comments at lines 1757–1758 and 1822 mentioning "sorry-backed" are honest STATUS NOTES explaining why `base_change_mate_gstar_transpose` is not yet used in inline proofs — these are informational, not excuse-comments. They describe the state accurately and do not claim the affected code is correct.
- No `-- TODO replace with real def` or `-- temporary` annotations.

### No axiom declarations

`grep -n "^axiom"` returns nothing in the Lean file. No unauthorized axioms.

---

## Unreferenced declarations (informational)

### Substantive (flagged)

- **`AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distributeCollapse`** (lines 1333–1367, theorem, no sorry, axiom-clean): Fuses blueprint L1+L2. No blueprint block pins this name. This is not a silent helper — it has a non-trivial three-factor statement and is directly spliced into the `_legs` proof. The blueprint should either reference it or be updated to replace L1+L2 with a single fused block. **See "Blueprint ↔ Lean name mismatch" above.**

### Acceptable helpers (not flagged)

All other declarations in the file (approximately 45 substantive declarations, 2 instances, several `@[simp]` lemmas that are clearly internal tools) map to blueprint `\lean{}` blocks. The file is well-covered.

---

## Blueprint adequacy for this file

- **Coverage**: 45/46 substantive Lean declarations have a corresponding `\lean{}` block. The one exception is `link_distributeCollapse` (flagged above). Coverage ratio is high.
- **Proof-sketch depth**: **adequate for the formalized portions**. The blueprint's decomposition of `_legs` into the five L1–L5 links is DETAILED and CORRECT as a mathematical decomposition — it correctly identifies the five reduction steps. The prover's inability to close them is not a blueprint-depth failure; it is a Lean elaboration difficulty (the `rw`/`simp`/`erw` failures on the `X.Modules` instance diamond, documented in the `link_distributeCollapse` comment). The eCancel atoms (L3–L5 content) ARE proved as standalone lemmas; the wall is assembling them in the legs-context form.
- **Hint precision**: **precise**. Every `\lean{...}` pin for existing declarations names the correct fully-qualified Lean declaration. The five dangling pins are FUTURE OBLIGATIONS, not mis-aimed hints — they name what should be built.
- **Generality**: **matches need**. No parallel API was required; the legs-parametrized form (codomain_read_legs) correctly anticipated the dependent-type wall.
- **Recommended chapter-side actions**:
  - Reconcile the L1+L2 mismatch: either (a) split `link_distributeCollapse` and update `_legs` [Path A], or (b) replace `lem:..._link_distribute` + `lem:..._link_collapseComp` with a single fused block `lem:..._link_distributeCollapse` pinning the existing Lean declaration [Path B — recommended, lower-risk].
  - For L3–L5 (`link_cancelEUnit`, `link_cancelPullbackComp`, `link_survivor`): the existing ATOMIC eCancel lemmas at lines 1538–1577 could be recognized as the L3+L4 atoms in the blueprint, with `link_survivor` remaining the genuine open obligation. Consider whether separate legs-wrapper blocks are needed or whether the atomic form already constitutes the blueprint's intent.

---

## Severity summary

### must-fix-this-iter
*None.*
- No placeholder bodies on blueprint-claimed declarations.
- No signature mismatches on existing (non-dangling) declarations.
- No excuse-comments.
- No unauthorized axioms.
- No unauthorized sorries.
- No false `\leanok` on proof blocks.

### major
1. **Five dangling `\lean{}` pins** — `_link_distribute`, `_link_collapseComp`, `_link_cancelEUnit`, `_link_cancelPullbackComp`, `_link_survivor`: blueprint names declarations that do not exist in Lean. None have `\leanok`, so no false claim of completion, but blueprint-doctor will flag all five as broken pins. The planner must reconcile these next iteration (either split the fused helper or rewrite the blueprint blocks).
2. **One unreferenced substantive Lean declaration** — `link_distributeCollapse` (axiom-clean, no sorry, directly used in `_legs`): the Lean file has a real theorem that no blueprint block references. This is a Lean→blueprint gap the plan agent must close.

### minor
- The `pushforward_base_change_mate_cancelBaseChange` signature deviation (IsIso form vs literal equality) is intentional and documented via `% NOTE:` in the blueprint — not a mismatch, but worth confirming the downstream `base_change_map_affine_local` genuinely consumes the `IsIso` form rather than the equality.

---

**Overall verdict**: All ~45 formalized declarations are signature-correct and sorry-clean (4 authorized sorries accounted for exactly); the two **major** findings are the blueprint↔Lean name mismatch for the L1+L2 fused helper and the five dangling `\lean{}` pins for L1–L5, which the planner must reconcile in iter-031 before `_legs` can be closed.
