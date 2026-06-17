# Lean ↔ Blueprint Check Report

## Slug
fbc-iter034

## Iteration
034

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (2117 lines)
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (3781 lines)

---

## Per-declaration

Entries are grouped by status. Mathlib-anchored blocks (`\mathlibok`) are listed collectively; they require no audit beyond confirming the pin name is plausible.

### Mathlib anchors — all `\mathlibok`, not in this file

| Blueprint label | `\lean{}` pin | Status |
|---|---|---|
| `lem:pullbackSpecIso_mathlib` | `AlgebraicGeometry.pullbackSpecIso` | `\mathlibok` ✓ |
| `lem:cancelBaseChange_mathlib` | `TensorProduct.AlgebraTensorModule.cancelBaseChange` | `\mathlibok` ✓ |
| `lem:isPushout_cancelBaseChange_mathlib` | `Algebra.IsPushout.cancelBaseChange` | `\mathlibok` ✓ |
| `lem:unit_conjugateEquiv_mathlib` | `CategoryTheory.Adjunction.unit_conjugateEquiv` | `\mathlibok` ✓ |
| `lem:comp_unit_app_mathlib` | `CategoryTheory.Adjunction.comp_unit_app` | `\mathlibok` ✓ |
| `lem:conjugateEquiv_pullbackComp_inv_mathlib` | `AlgebraicGeometry.conjugateEquiv_pullbackComp_inv` (or equiv.) | `\mathlibok` ✓ |
| `lem:conjugateIsoEquiv_mathlib` | `CategoryTheory.conjugateIsoEquiv` | `\mathlibok` ✓ |
| `lem:iterated_mateEquiv_mathlib` | `CategoryTheory.iterated_mateEquiv_conjugateEquiv` | `\mathlibok` ✓ |
| `lem:leftAdjointCompIso_mathlib` | `CategoryTheory.Adjunction.leftAdjointCompIso` | `\mathlibok` ✓ |
| `lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib` | `CategoryTheory.conjugateEquiv_leftAdjointCompIso_inv` | `\mathlibok` ✓ |
| `lem:unit_conjugateEquiv_symm_mathlib` | `CategoryTheory.Adjunction.unit_conjugateEquiv_symm` | `\mathlibok` ✓ |
| `lem:flat_preserves_equalizer_mathlib` | `LinearMap.tensorEqLocusEquiv` | `\mathlibok` ✓ |
| `lem:sheaf_equalizer_products_mathlib` | `TopCat.Presheaf.isSheaf_iff_isSheafEqualizerProducts` | `\mathlibok` ✓ |

---

### Clean entries — declaration exists, no sorry, proof body matches blueprint sketch

#### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (chapter: `def:pushforward_base_change_map`) — `\leanok` ✓
- **Lean target exists**: yes (line 79)
- **Signature matches**: yes — canonical map `g^*(f_* F) → f'_*((g')^* F)` for a cartesian square
- **Proof follows sketch**: yes — `adjunction.homEquiv` plus `IsPullback` hypothesis, matches blueprint
- **notes**: clean

#### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (chapter: `lem:modules_isIso_iff_stalk`) — `\leanok` ✓
- **Lean target exists**: yes (line 102)
- **Signature matches**: yes — stalk-local iso criterion
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (chapter: `lem:modules_isIso_of_isBasis`) — `\leanok` ✓
- **Lean target exists**: yes (line 128)
- **Signature matches**: yes — basis-open locality
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (chapter: `lem:modules_isIso_iff_affineOpens`) — `\leanok` ✓
- **Lean target exists**: yes (line 164)
- **Signature matches**: yes — affine-open locality criterion
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (chapter: `lem:globalSectionsIso_hom_comp_specMap_appTop`) — `\leanok` ✓
- **Lean target exists**: yes (line 268)
- **Signature matches**: yes — ring-level equation for global sections iso
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (chapter: `lem:gammaPushforwardIso`) — `\leanok` ✓
- **Lean target exists**: yes (line 288)
- **Signature matches**: yes — Γ(pushforward) ≅ restrictScalars
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (chapter: `lem:gammaPushforwardTildeIso`) — `\leanok` ✓
- **Lean target exists**: yes (line 313)
- **Signature matches**: yes — tilde specialization
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (chapter: `lem:gammaPushforwardIsoAt`) — `\leanok` ✓
- **Lean target exists**: yes (line 331)
- **Signature matches**: yes — arbitrary-open version
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (chapter: `lem:fromTildeGamma_app_isIso_of_localized`) — `\leanok` ✓
- **Lean target exists**: yes (line 367)
- **Signature matches**: yes — counit iso from localization hypothesis
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (chapter: `lem:pushforward_spec_tilde_iso_conditional`) — `\leanok` ✓
- **Lean target exists**: yes (line 431)
- **Signature matches**: yes — conditional affine pushforward iso
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (chapter: `lem:powers_restrictScalars`) — `\leanok` ✓
- **Lean target exists**: yes (line 455)
- **Signature matches**: yes — ring-change converse for localized modules
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (chapter: `lem:tildeRestriction_isLocalizedModule`) — `\leanok` ✓
- **Lean target exists**: yes (line 483)
- **Signature matches**: yes — tilde restriction is localization
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (chapter: `lem:pushforward_spec_tilde_iso`) — `\leanok` ✓
- **Lean target exists**: yes (line 538)
- **Signature matches**: yes — unconditional `(Spec φ)_* M~ ≅ tilde(restrictScalars φ M)`, axiom-clean
- **Proof follows sketch**: yes
- **notes**: clean; the proof assembles the conditional version using `tildeRestriction_isLocalizedModule` + `powers_restrictScalars`, matching blueprint's decomposition.

#### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (chapter: `lem:gammaPushforwardNatIso`) — `\leanok` ✓
- **Lean target exists**: yes (line 667)
- **Signature matches**: yes — natural iso packaging
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (chapter: `lem:pullback_spec_tilde_iso`) — `\leanok` ✓
- **Lean target exists**: yes (line 689)
- **Signature matches**: yes — affine pullback of tilde = tilde(extendScalars)
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (chapter: `lem:pullback_fst_snd_specMap_tensor`) — `\leanok` ✓
- **Lean target exists**: yes (line 709)
- **Signature matches**: yes — pullback legs as Spec of tensor inclusions
- **Proof follows sketch**: yes
- **notes**: clean; blueprint notes this is the "single Mathlib-absent step" in the proof chain. The Lean proof confirms it.

#### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (chapter: `lem:base_change_mate_domain_read`) — `\leanok` ✓
- **Lean target exists**: yes (line 737)
- **Signature matches**: yes — domain read Θ_src : Γ(g^*(f_* M~)) ≅ R' ⊗_R M
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (chapter: `lem:pullbackIsoEquivalenceOfIso`) — `\leanok` ✓
- **Lean target exists**: yes (line 753)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (chapter: `lem:pullback_isEquivalence_of_iso`) — `\leanok` ✓
- **Lean target exists**: yes (line 762, instance)
- **Signature matches**: yes
- **Proof follows sketch**: N/A (instance derivation)
- **notes**: clean

#### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (chapter: `lem:base_change_mate_codomain_read`) — `\leanok` ✓
- **Lean target exists**: yes (line 773)
- **Signature matches**: yes — codomain read Θ_tgt : Γ(f'_*(g')^* M~) ≅ (A ⊗_R R') ⊗_A M
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (chapter: `lem:base_change_mate_regroupEquiv`) — `\leanok` ✓
- **Lean target exists**: yes (line 856)
- **Signature matches**: yes — regrouping iso (A⊗_R R')⊗_A M ≅ R'⊗_R M, axiom-clean
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}` (chapter: `lem:pullbackPushforward_unit_comp`) — `\leanok` ✓
- **Lean target exists**: yes (line 1144)
- **Signature matches**: yes — pseudofunctoriality of pullback–pushforward unit
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}` (chapter: `lem:gammaMap_pushforwardComp_hom_eq_id`) — `\leanok` ✓
- **Lean target exists**: yes (line 1218)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id}` (chapter: `lem:gammaMap_pushforwardComp_inv_eq_id`) — `\leanok` ✓
- **Lean target exists**: yes (line 1226)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.gammaMap_pushforwardCongr_hom}` (chapter: `lem:gammaMap_pushforwardCongr_hom`) — `\leanok` ✓
- **Lean target exists**: yes (line 1237)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs}` (chapter: `lem:base_change_mate_codomain_read_legs`) — `\leanok` ✓
- **Lean target exists**: yes (line 1254)
- **Signature matches**: yes — variable-legs codomain read
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_unitExpand}` (chapter: `lem:base_change_mate_fstar_reindex_legs_unitExpand`) — `\leanok` ✓
- **Lean target exists**: yes (line 1317)
- **Signature matches**: yes — iii-1 unit expansion
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_gammaDistribute}` (chapter: `lem:base_change_mate_fstar_reindex_legs_gammaDistribute`) — `\leanok` ✓
- **Lean target exists**: yes (line 1348)
- **Signature matches**: yes — iii-2 distribution
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_distributeCollapse}` (chapter: `lem:base_change_mate_fstar_reindex_legs_link_distributeCollapse`) — `\leanok` ✓
- **Lean target exists**: yes (line 1377)
- **Signature matches**: yes — iii, links 1+3 fused
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_eUnit}` (chapter: `lem:base_change_mate_inner_eCancel_eUnit`) — `\leanok` ✓
- **Lean target exists**: yes (line 1616)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pushforwardComp}` (chapter: `lem:base_change_mate_inner_eCancel_pushforwardComp`) — `\leanok` ✓
- **Lean target exists**: yes (line 1628)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel_pullbackComp}` (chapter: `lem:base_change_mate_inner_eCancel_pullbackComp`) — `\leanok` ✓
- **Lean target exists**: yes (line 1645)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.base_change_mate_gstar_generator_close}` (chapter: `lem:base_change_mate_gstar_generator_close`) — `\leanok` ✓
- **Lean target exists**: yes (line 1663)
- **Signature matches**: yes — B-step, generator close
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.base_change_mate_gstar_counit_transport}` (chapter: `lem:base_change_mate_gstar_counit_transport`) — `\leanok` ✓
- **Lean target exists**: yes (line 1740)
- **Signature matches**: yes — C-step, no sorry, axiom-clean
- **Proof follows sketch**: yes
- **notes**: clean

#### `\lean{AlgebraicGeometry.base_change_mate_inner_value}` (chapter: `def:base_change_mate_inner_value`) — `\leanok` ✓
- **Lean target exists**: yes (line 1102)
- **Signature matches**: yes — definition of inner comparison value ρ
- **Proof follows sketch**: N/A (definition)
- **notes**: clean

#### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (chapter: `lem:base_change_map_affine_local`) — `\leanok` ✓
- **Lean target exists**: yes (line 2049)
- **Signature matches**: yes — locality criterion application
- **Proof follows sketch**: yes
- **notes**: clean

---

### Sorry-backed entries — statement `\leanok` ✓, proof body has sorry directly or transitively

#### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (chapter: `lem:base_change_mate_fstar_reindex_legs`) — `\leanok` (statement) ✓
- **Lean target exists**: yes (line 1425)
- **Signature matches**: yes — the conjugate-component identity Θ_src⁻¹ ≫ Γ(θ_legs) ≫ Θ_tgt = ρ over the variable-legs square
- **Proof follows sketch**: **no** — proof ends at `sorry` (line 1539) with comment "direct-on-sections term-mode splicing bottoms out here". The blueprint's proof sketch for this block (the conjugate-route recipe via `conj-0`/`conj-1`) is the planned iter-035 approach and is not yet implemented.
- **notes**: **PRIMARY BLOCKER**. This sorry propagates downstream through `base_change_mate_fstar_reindex` → `base_change_mate_inner_value_eq` → `base_change_mate_section_identity` → `base_change_mate_generator_trace` → `pushforward_base_change_mate_cancelBaseChange` → `affineBaseChange_pushforward_iso`.

#### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (chapter: `lem:base_change_mate_fstar_reindex`) — `\leanok` (statement) ✓
- **Lean target exists**: yes (line 1553)
- **Signature matches**: yes — instantiation of `_legs`
- **Proof follows sketch**: partial — proof compiles (no inline sorry) but is transitively sorry-backed via `base_change_mate_fstar_reindex_legs`
- **notes**: sorry-backed by propagation; correct to carry `\leanok` on statement only

#### `\lean{AlgebraicGeometry.base_change_mate_inner_value_eq}` (chapter: `lem:base_change_mate_inner_value_eq`) — `\leanok` (statement) ✓
- **Lean target exists**: yes (line 1702)
- **Signature matches**: yes — A-step: ρ = inner value
- **Proof follows sketch**: partial — no inline sorry, but transitively sorry-backed via `base_change_mate_fstar_reindex`
- **notes**: correct `\leanok` state

#### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (chapter: `lem:base_change_mate_gstar_transpose`) — `\leanok` (statement) ✓
- **Lean target exists**: yes (line 1788)
- **Signature matches**: yes — Seam 3 / "REMAINING CRUX": the g^*-transpose identity (Θ_src⁻¹ ≫ Γ(θ) ≫ Θ_tgt = regroup⁻¹)
- **Proof follows sketch**: **no** — proof ends at `sorry` (line 1911) with comment "REMAINING CRUX". The blueprint proof sketch invokes the full conjugate calculus chain (conj-0 → conj-1 → ...); none of it is complete.
- **notes**: **SECOND INDEPENDENT BLOCKER**. Its sorry propagates through `base_change_mate_section_identity` and the downstream chain independently.

#### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (chapter: `lem:base_change_mate_section_identity`) — `\leanok` (statement) ✓
- **Lean target exists**: yes (line 1940)
- **Signature matches**: yes — the full section-level base-change identity
- **Proof follows sketch**: partial — proof body dispatches to `base_change_mate_gstar_transpose`; sorry-backed
- **notes**: correct `\leanok` state

#### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (chapter: `lem:base_change_mate_generator_trace`) — `\leanok` ✓
- **Lean target exists**: yes (line 1969)
- **Signature matches**: yes — IsIso(Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt) corollary
- **Proof follows sketch**: partial — sorry-backed transitively
- **notes**: correct `\leanok` state

#### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (chapter: `lem:pushforward_base_change_mate_cancelBaseChange`) — `\leanok` ✓
- **Lean target exists**: yes (line 2010)
- **Signature matches**: yes — IsIso(Γ(α)) for the affine case
- **Proof follows sketch**: partial — sorry-backed transitively
- **notes**: correct `\leanok` state

#### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (chapter: `lem:affine_base_change_pushforward`) — `\leanok` (statement) ✓
- **Lean target exists**: yes (line 2061)
- **Signature matches**: yes — `IsAffineHom f` → `IsIso (pushforwardBaseChangeMap ...)`, the affine base-change theorem
- **Proof follows sketch**: **no** — proof ends at `sorry` (line 2092) with comment "WHAT REMAINS HERE (the AFFINE REDUCTION)". The proof body has the locality setup but the final `apply pushforward_base_change_mate_cancelBaseChange` step is `sorry`-bridged.
- **notes**: **THIRD DIRECT SORRY**. Requires `pushforward_base_change_mate_cancelBaseChange` to be sorry-free, which requires `base_change_mate_fstar_reindex_legs` and `base_change_mate_gstar_transpose` to be solved first.

#### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (chapter: `thm:flat_base_change_pushforward`) — `\leanok` (statement) ✓
- **Lean target exists**: yes (line 2101)
- **Signature matches**: yes — the main theorem: `IsFlat g → IsQcqs f → IsIso (pushforwardBaseChangeMap ...)`
- **Proof follows sketch**: **no** — proof is `sorry` (line 2114) with comment "proof strategy deferred". The blueprint proof sketch requires the Mayer–Vietoris chain (lemmas in `FlatBaseChangeGlobal.lean`) and `affineBaseChange_pushforward_iso`.
- **notes**: **FOURTH DIRECT SORRY**. This theorem's sorry is partly independent: even once `affineBaseChange_pushforward_iso` is closed, the global-to-affine reduction machinery lives in a separate file and is not yet formalized.

---

### Stale blueprint pins — `\lean{}` points to non-existent declarations

#### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_cancelEUnit}` (chapter: `lem:base_change_mate_fstar_reindex_legs_link_cancelEUnit`, line 1844)
- **Lean target exists**: **no** — no declaration with this name exists anywhere in the project
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint carries `% NOTE: superseded by the conjugate-side re-encoding (Open Q2). This direct-on-sections link no longer feeds the live _legs proof. Lean pin retained pending the iter-035 refactor.` No `\leanok` on this block (correctly absent after `sync_leanok`). Stale pin is explicit and intentional.

#### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_cancelPullbackComp}` (chapter: `lem:base_change_mate_fstar_reindex_legs_link_cancelPullbackComp`, line 1885)
- **Lean target exists**: **no**
- **notes**: Same situation as above — blueprint annotates as superseded, no `\leanok`.

#### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_link_survivor}` (chapter: `lem:base_change_mate_fstar_reindex_legs_link_survivor`, line 1922)
- **Lean target exists**: **no**
- **notes**: Same situation — superseded, no `\leanok`.

---

### Narrative-scaffold blueprint nodes (no dedicated Lean declaration, intentional)

| Blueprint label | `\lean{}` pin | Reason |
|---|---|---|
| `lem:base_change_mate_inner_unitReduce` | `AlgebraicGeometry.base_change_mate_fstar_reindex_legs` | intentional reuse of `_legs` pin for narrative node |
| `lem:base_change_mate_inner_eCancel` | `AlgebraicGeometry.base_change_mate_fstar_reindex_legs` | same |
| `lem:base_change_mate_inner_eCancel_assemble` | `AlgebraicGeometry.base_change_mate_fstar_reindex_legs` | same |

These nodes describe proof-structure steps with no standalone Lean declaration; the blueprint explicitly reuses the `_legs` pin. This is acceptable scaffold documentation, not a gap.

---

### Blueprint entries for other Lean files (not this file's concern)

The last quarter of the chapter (lines ~3267–3563) contains blueprint entries for the global flat base change infrastructure. These pin declarations that live (or will live) in `FlatBaseChangeGlobal.lean` and `RegroupHelper.lean`, not in `FlatBaseChange.lean`:

- `AlgebraicGeometry.Scheme.exists_finite_affineCover_inter_isQuasiCompact` (`lem:finite_affine_cover_qcqs`, `\leanok`) — in `FlatBaseChangeGlobal.lean`
- `AlgebraicGeometry.Modules.gammaIsLimitSheafConditionFork` (`lem:gamma_finite_equalizer`, `\leanok`) — same
- `AlgebraicGeometry.Modules.exists_finite_affineCover_isLimit_sheafConditionFork` (`lem:gamma_finite_equalizer_cover`, `\leanok`) — same
- Seven FBC-B build-ahead blocks (`gammaCoverRestrictScalars`, `gammaCoverResMapsALinear`, `gammaEqLocusIso`, `baseChange_sheafConditionFork_tensorIso`, `flatBaseChange_pushforward_isIso_of_isSeparated`, `flatBaseChange_pushforward_mayerVietoris`, `flatBaseChange_isIso_iff_gammaTensorComparison`) — **no** `\leanok` (future obligations, not yet formalized)

None of these are concerns for `FlatBaseChange.lean`. They are correctly in-blueprint with appropriate `\leanok` states.

---

## Red flags

### Placeholder / suspect bodies

- **`base_change_mate_fstar_reindex_legs`** (line 1539): body ends in `sorry` with explicit inline comment "direct-on-sections term-mode splicing bottoms out here". Blueprint claims a substantive chain-equality proof. **PRIMARY BLOCKER.**

- **`base_change_mate_gstar_transpose`** (line 1911): body ends in `sorry` with inline comment "REMAINING CRUX". Blueprint claims the full g^*-transpose identity as a substantive result. **SECOND INDEPENDENT BLOCKER.**

- **`affineBaseChange_pushforward_iso`** (line 2092): body ends in `sorry` at the affine-reduction step with inline comment "WHAT REMAINS HERE (the AFFINE REDUCTION)". Blueprint claims the full affine base change theorem.

- **`flatBaseChange_pushforward_isIso`** (line 2114): entire proof body is `sorry` with comment "proof strategy deferred". Blueprint marks this as the main theorem (`\leanok` on statement, no `\leanok` on proof, correctly).

### Transitive sorry propagation chain

The following declarations have no inline sorry but are sorry-backed transitively. Their `\leanok` state on the statement block is correct (they exist and type-check), but they should not be considered proved:

```
base_change_mate_fstar_reindex_legs (sorry L1539)
  └── base_change_mate_fstar_reindex
        └── base_change_mate_inner_value_eq
              └── (base_change_mate_gstar_transpose (sorry L1911))
                    └── base_change_mate_section_identity
                          ├── base_change_mate_generator_trace
                          │     └── pushforward_base_change_mate_cancelBaseChange
                          │           └── affineBaseChange_pushforward_iso (sorry L2092)
                          │                 └── flatBaseChange_pushforward_isIso (sorry L2114)
                          └── (direct path via base_change_mate_gstar_transpose)
```

This chain is correctly reflected in the blueprint: none of the downstream entries carry `\leanok` on proof blocks; only statement `\leanok` is present, and that is accurate.

### Excuse-comments

No excuse-comments of the "TODO: replace with real def" type were found. The sorry comments are honest progress markers ("bottoms out here", "REMAINING CRUX", "WHAT REMAINS HERE"), not excuses for wrong definitions.

### Axioms / `Classical.choice` on non-trivial claims

No unauthorized axioms found. `pushforward_spec_tilde_iso` is documented as axiom-clean; `base_change_mate_regroupEquiv` and `base_change_mate_gstar_counit_transport` are axiom-clean.

---

## Unreferenced declarations (informational)

The following declarations appear in `FlatBaseChange.lean` but have no dedicated `\lean{...}` blueprint block:

1. **`pullbackComp_inv_eq_leftAdjointCompIso_inv`** (line 1181) — NEW iter-034, labeled "conj-0". This is the first building block of the iter-035 conjugate-route pivot: it identifies `pullbackComp.inv` with `leftAdjointCompIso.inv`. It proves `pullbackComp (f := f) (g := g) = leftAdjointCompIso (adj₁ := pushforwardAdjunction g) (adj₂ := pushforwardAdjunction f) (adj₃ := pushforwardAdjunction (g ≫ f))`. **Should have a blueprint block.** This is a non-trivial result (uses `Adjunction.ext`, `pullbackComp`, and `leftAdjointCompIso`) that the plan agent should register as the iter-035 conj-0 building block.

2. **`pullbackComp_eq_leftAdjointCompIso`** (line 1198) — NEW iter-034, labeled "conj-0'". Iso-level form of conj-0. **Should have a blueprint block.** Same reasoning.

3. **`base_change_mate_unit_value`** (line 987, `set_option maxHeartbeats 4000000`) — Seam 1 result: the algebraic unit value computation. This is the foundation of Seam 1 and should have a dedicated `\lean{...}` block in the blueprint. It may be covered by a narrative block that reuses another pin; if so this is acceptable.

Items 1 and 2 are the most important: they are the new iter-034 declarations introduced as the "conjugate-route foundation" with no blueprint registration, which breaks traceability for the iter-035 plan.

---

## Blueprint adequacy for this file

- **Coverage**: approximately 48 declarations in `FlatBaseChange.lean` (not counting private helpers and internal `have`s). The blueprint chapter covers ~43 of these with dedicated `\lean{...}` blocks. The 5 uncovered declarations are: `pullbackComp_inv_eq_leftAdjointCompIso_inv`, `pullbackComp_eq_leftAdjointCompIso` (new iter-034, should be added), `pullback_isEquivalence_of_iso` (instance, covered implicitly), `base_change_mate_unit_value` (check for coverage by narrative block), and a handful of small helpers. Coverage is adequate except for the two new conj-0/conj-0' declarations.

- **Proof-sketch depth**: **adequate for most blocks; under-specified for the four remaining sorried blocks.** The blueprint's proof sketches for `base_change_mate_fstar_reindex_legs` and `base_change_mate_gstar_transpose` describe the intended conjugate-route approach (iter-035 plan) in outline but do not give the full term-mode detail needed to close the sorry. This is acceptable for a work-in-progress chapter but should be expanded when the conj-1 step is planned.

- **Hint precision**: **precise** for all formalized blocks. The `\lean{...}` names match the actual Lean declarations exactly, with correct namespace `AlgebraicGeometry`. No wrong-predicate mismatches found.

- **Generality**: **matches need** — the blueprint correctly targets the right level of generality throughout. No parallel-API problem found.

- **Recommended chapter-side actions**:
  1. Add a `\begin{lemma}...\end{lemma}` block with `\lean{AlgebraicGeometry.pullbackComp_inv_eq_leftAdjointCompIso_inv}` for conj-0 (the `pullbackComp.inv = leftAdjointCompIso.inv` identification).
  2. Add a `\begin{lemma}...\end{lemma}` block with `\lean{AlgebraicGeometry.pullbackComp_eq_leftAdjointCompIso}` for conj-0' (the iso-level form).
  3. Expand the proof sketch for `lem:base_change_mate_fstar_reindex_legs` to describe the conj-1 step (the conjugateIsoEquiv component-decomposition) when the iter-035 plan is drafted.
  4. Clean up the three stale `\lean{}` pins (`_link_cancelEUnit`, `_link_cancelPullbackComp`, `_link_survivor`) once their blueprint blocks are superseded by the conjugate-route reformulation — remove those three blocks from the chapter or replace them with `% NOTE: removed — superseded by conj-route`.

---

## Severity summary

### must-fix-this-iter

1. **`base_change_mate_fstar_reindex_legs` (line 1539, sorry)**: Proof of the conjugate-legs identity ends in `sorry`. Blueprint calls this a substantive chain-equality result. This is the primary blocker; its sorry propagates to 5+ downstream declarations including the main theorem.

2. **`base_change_mate_gstar_transpose` (line 1911, sorry)**: Proof of the g^*-transpose crux ends in `sorry`. Blueprint identifies this as "REMAINING CRUX". Independent second blocker; its sorry propagates to `base_change_mate_section_identity` and the downstream chain.

3. **`affineBaseChange_pushforward_iso` (line 2092, sorry)**: Affine base-change theorem proof ends in `sorry` at the affine-reduction step. Blueprint presents this as a closed theorem. Blocked by items 1 and 2.

4. **`flatBaseChange_pushforward_isIso` (line 2114, sorry)**: The main theorem proof is entirely `sorry`. Blocked by item 3 and additionally by `FlatBaseChangeGlobal.lean` infrastructure not yet formalized.

### major

5. **Three stale blueprint `\lean{}` pins** (`_link_cancelEUnit`, `_link_cancelPullbackComp`, `_link_survivor`) pointing to non-existent Lean declarations. Blueprint itself acknowledges these as "superseded" with "Lean pin retained pending iter-035 refactor". They are intentionally stale but create dangling references that will confuse `blueprint-doctor` and the dependency graph. **Clean up next iter.**

6. **Two new iter-034 declarations without blueprint blocks** (`pullbackComp_inv_eq_leftAdjointCompIso_inv` and `pullbackComp_eq_leftAdjointCompIso`, lines 1181 and 1198). These conj-0/conj-0' building blocks have no `\lean{}` registration in the chapter, breaking blueprint traceability for the iter-035 conjugate-route plan.

### minor

7. The `base_change_mate_unit_value` declaration (Seam 1 foundation, line 987, `set_option maxHeartbeats 4000000`) has no dedicated blueprint block confirmed by explicit `\lean{}` pin. If it is covered only by narrative reuse of another pin, the coverage should be made explicit.

8. Several downstream sorry-backed declarations (`base_change_mate_fstar_reindex`, `base_change_mate_inner_value_eq`, `base_change_mate_section_identity`, `base_change_mate_generator_trace`, `pushforward_base_change_mate_cancelBaseChange`) correctly carry `\leanok` only on their statement blocks. The propagation chain is correctly reflected in the blueprint. No action required; noted for completeness.

**Overall verdict**: The file is internally consistent with the blueprint's `\leanok` state — statement-level coverage is accurate, no wrong signatures, no unauthorized axioms — but four direct sorries in the critical path (`_fstar_reindex_legs`, `_gstar_transpose`, `affineBaseChange_pushforward_iso`, `flatBaseChange_pushforward_isIso`) block the affine and global flat base-change theorems, and two new iter-034 conj-0/conj-0' building blocks lack blueprint registration. The sorries are the key open obligations for iter-035.
