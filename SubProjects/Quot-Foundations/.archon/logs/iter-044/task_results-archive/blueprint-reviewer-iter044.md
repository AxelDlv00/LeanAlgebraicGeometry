# Blueprint reviewer — iter-044 full audit

**Date:** 2026-06-09  
**Chapters audited:** 6 (complete set)  
**blueprint-doctor:** 0 broken refs, 0 orphan chapters, 0 malformed refs, 473 labels  
**leandag isolated:** 0 isolated nodes

---

## Executive summary

| Chapter | complete | correct | must-fix this iter |
|---|---|---|---|
| Cohomology_RegroupHelper | ✓ | ✓ | — |
| Picard_RelativeSpec | ✓ | ✓ | — |
| **Cohomology_FlatBaseChange** (HARD-GATE) | ✓ | ✓ | **YES — false `\leanok` on keystone** |
| Picard_FlatteningStratification | ✓ | ✓ | — (flag: false `\leanok` on `thm:generic_flatness`) |
| Picard_GrassmannianCells | ✓ | ✓ | — |
| **Picard_QuotScheme** (HARD-GATE) | ✓ | ✓ | — |

Hard-gate FBC: the proof sketch and `\uses` chain for the keystone and all three legs are coherent and formalizable; one **must-fix** is a stale `\leanok` that misrepresents the Lean sorry-status.

Hard-gate QUOT: the gap2 Piece A chain (L1–L6 + 2 Mathlib anchors + bridge block) is mathematically complete, all signatures realistic, all `\uses` accurate. No must-fix.

---

## Infrastructure checks

### blueprint-doctor (`archon blueprint-doctor --json`)
- `orphan_chapters: []` — all 6 chapters are included in `content.tex`
- `broken_refs: []` — no `\cref`/`\label` mismatches
- `malformed_refs: []`
- `axiom_decls: []`
- `covers_problems: []`
- 473 labels defined

### leandag
- `leandag show isolated` → empty (no isolated declaration nodes)

---

## Per-chapter audit

### 1. Cohomology_RegroupHelper.tex (77 lines)

**complete: true, correct: true**

- Single lemma `lem:base_change_regroup_linearEquiv` — `\leanok`
- `\uses{lem:isPushout_cancelBaseChange_mathlib}` — `\mathlibok` anchor is present and correct
- No issues.

---

### 2. Picard_RelativeSpec.tex

**complete: true, correct: true**

- Covers: `def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `def:relspec_structure_morphism`, `thm:relative_spec_univ`, `thm:relative_spec_affine_base`
- All `\leanok`; Mathlib-backed bodies (iter-179 encoding updates noted in inline comments)
- `\uses` chains are accurate
- No issues.

---

### 3. Cohomology_FlatBaseChange.tex ★ HARD-GATE ★

**complete: true, correct: true — but see MUST-FIX below**

#### Affine infrastructure (lines 1–1950)

All of the following blocks are `\leanok` and their `\uses` chains are internally consistent:

- Locality lemmas: `lem:modules_isIso_iff_stalk`, `lem:modules_isIso_of_isBasis`, `lem:modules_isIso_iff_affineOpens`
- Affine dictionary: `lem:globalSectionsIso_hom_comp_specMap_appTop`, `lem:gammaPushforwardIso`, `lem:gammaPushforwardTildeIso`, `lem:gammaPushforwardIsoAt`, `lem:tildeRestriction_isLocalizedModule`, `lem:powers_restrictScalars`, `lem:pushforward_spec_tilde_iso`, `lem:gammaPushforwardNatIso`, `lem:pullback_spec_tilde_iso`
- Mathlib conjugate-calculus anchors (all `\mathlibok`): `lem:unit_conjugateEquiv_mathlib`, `lem:comp_unit_app_mathlib`, `lem:conjugateEquiv_pullbackComp_inv_mathlib`, `lem:conjugateIsoEquiv_mathlib`, `lem:iterated_mateEquiv_conjugateEquiv_mathlib`, `lem:leftAdjointCompIso_mathlib`, `lem:conjugateEquiv_leftAdjointCompIso_inv_mathlib`, `lem:unit_conjugateEquiv_symm_mathlib`, `lem:conjugateEquiv_counit_symm_mathlib`, `lem:conjugateEquiv_comp_mathlib`, **`lem:conjugateEquiv_symm_comp_mathlib`**
- conj-0: `lem:pullbackComp_inv_eq_leftAdjointCompIso_inv`, `lem:pullbackComp_eq_leftAdjointCompIso` — both `\leanok`
- Gamma-collapse: `lem:gammaMap_pushforwardComp_hom_eq_id`, `lem:gammaMap_pushforwardComp_inv_eq_id`, `lem:gammaMap_pushforwardCongr_hom` — all `\leanok`

#### The conjugate route: conj-1a/1b, conj-2b/2c/2d, keystone (lines 1972–2320)

**conj-1a** `lem:base_change_mate_codomain_read_legs_conj` — `\leanok` ✓  
**conj-1b** `lem:base_change_mate_codomain_read_legs_conj_eq` — `\leanok` ✓  
**conj-2b** `lem:base_change_mate_reindex_conj_pullbackLeg` — `\leanok` ✓ (Lean: axiom-clean)  
**conj-2c** `lem:base_change_mate_reindex_conj_pushforwardCollapse` — `\leanok` ✓ (Lean: axiom-clean)  
**conj-2d** `lem:base_change_mate_reindex_conj_crossLayer` — `\leanok` ✓ (Lean: axiom-clean)

**keystone (conj-2a)** `lem:base_change_mate_fstar_reindex_legs_conj`:
- Blueprint: `\leanok` (**INCORRECT — see must-fix below**)
- `\uses`: `{lem:base_change_mate_codomain_read_legs_conj, lem:conjugateIsoEquiv_mathlib, lem:iterated_mateEquiv_conjugateEquiv_mathlib, lem:conjugateEquiv_comp_mathlib, lem:conjugateEquiv_symm_comp_mathlib, lem:base_change_mate_reindex_conj_pullbackLeg, lem:base_change_mate_reindex_conj_pushforwardCollapse, lem:base_change_mate_reindex_conj_crossLayer, def:base_change_mate_inner_value}` — **all present and correct**
- Proof sketch: peel one adjunction-pair / functor-layer at a time via `conjugateEquiv_symm_comp`, discharge each factor by the three isolated legs, reassociation by the conjugate simp set. This is the correct Mathlib idiom (mirrors `leftAdjointCompNatTrans₀₂₃_eq_conjugateEquiv_symm` in `CompositionIso.lean`). **Mathematically faithful and formalizable.**
- Lean file (`FlatBaseChange.lean` line 1848): **`sorry` present** — the `(pushforwardComp g' (Spec φ)).hom` collapse under the `Γ`-map is not closed (discrimination-tree pattern not matching); the keystone is NOT axiom-clean.

Wrappers tainted by the sorry:
- `lem:base_change_mate_fstar_reindex_legs` (line 2273 blueprint `\leanok`, Lean line 1897 calls the sorry-containing keystone via `▸ base_change_mate_fstar_reindex_legs_conj`) — also NOT axiom-clean
- `lem:base_change_mate_fstar_reindex` (line 2328 blueprint `\leanok`, wraps `_legs`) — also NOT axiom-clean

#### MUST-FIX (hard-gate FBC, this iter)

> Remove `\leanok` from `lem:base_change_mate_fstar_reindex_legs_conj` (FlatBaseChange.tex line ~2215), `lem:base_change_mate_fstar_reindex_legs` (line ~2273), and `lem:base_change_mate_fstar_reindex` (line ~2328). The Lean source has `sorry` in the keystone; these three blueprint nodes must NOT be `\leanok`.

The proof sketch, `\uses` chain, and Mathlib anchors for the keystone are all sound. The prover should proceed with the `conjugateEquiv_symm_comp` route as documented; only the annotations need to be corrected to reflect current sorry-status.

---

### 4. Picard_FlatteningStratification.tex

**complete: true, correct: true (non-hard-gate chapter; GF-geo BLOCKED)**

- `thm:generic_flatness_algebraic` — `\leanok` ✓ (axiom-clean per Lean file)
- Full dévissage chain (L1–L5b) — all `\leanok` ✓
- `lem:gf_qcoh_fintype_finite_sections` (G1) — correctly NOT `\leanok` (mathlib-build target this iter); `\uses{lem:qcoh_section_localization_basicOpen}` is correct
- `lem:gf_flat_locality_assembly` (G3) — correctly NOT `\leanok` (stub-level)
- `thm:generic_flatness` — **blueprint has `\leanok` (line 1601) but Lean file has `sorry` at line 2264** (GF-geo is BLOCKED anyway; this is a stale marker but not blocking)

**Non-blocking flag:** Remove `\leanok` from `thm:generic_flatness` in FlatteningStratification.tex once G1/G3 are closed.

---

### 5. Picard_GrassmannianCells.tex

**complete: true, correct: true**

The chapter is complete through properness. All key declarations:

- `def:gr_the_glue_data` — `\leanok` ✓
- `def:gr_glued_scheme` (Gr(r,d) over ℤ) — `\leanok` ✓
- `lem:gr_separated` — `\leanok` ✓ (via `diagonalRingMap_surjective` argument; `\uses` accurate)
- `lem:gr_isProper_of_valuativeExistence` — `\leanok` ✓
- E1–E4 existence steps (`lem:gr_existence_chart_factorization`, `lem:gr_existence_minimal_valuation`, `lem:gr_existence_factor_through_valuation_ring`, `lem:gr_existence_lift`) — all `\leanok` ✓
- `lem:gr_proper` (line 2667) — `\leanok` ✓ (complete properness over ℤ, axiom-clean)

No issues.

---

### 6. Picard_QuotScheme.tex ★ HARD-GATE ★

**complete: true, correct: true — gap2 Piece A chain is sound**

#### Pre-existing infrastructure (correct)

All gap-1 infrastructure `\leanok`:
- `lem:modules_restrict_linear`, `lem:modules_restrict_basicOpen_linear`, `lem:fromSpec_image_top_section_coherence`, `lem:section_localization_hfr_aux_general`, `lem:isLocalizedModule_tilde_restrict`, `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ` — all ✓
- Supporting infrastructure (lines 4200–4450): `lem:isLocalizedModule_ringEquiv_semilinear`, `def:gamma_image_ring_equiv`, `lem:gamma_pullback_image_iso`, `lem:gamma_pullback_image_iso_hom_semilinear`, `lem:gamma_pullback_image_iso_hom_naturality` — all `\leanok` ✓

#### Bridge block `lem:isLocalizedModule_basicOpen_of_hP1` (new, line 2572)

- Correctly NOT `\leanok`
- `\uses{lem:section_localization_hfr_aux_general, lem:fromSpec_image_top_section_coherence, lem:modules_restrict_basicOpen_linear, lem:isLocalizedModule_ringEquiv_semilinear, def:gamma_image_ring_equiv}` — all present and `\leanok` ✓
- Proof sketch: instantiate `section_localization_hfr_aux_general` at `j = fromSpec`, transport via `gammaImageRingEquiv` iso and `isLocalizedModule_ringEquiv_semilinear`. Mechanically correct and formalizable.
- **No issues.**

#### Gap2 Piece A chain: L1 → L6 → `lem:qcoh_pullback_fromSpec`

**All 6 blocks + output lemma correctly NOT `\leanok`** (new targets):

| Block | Label | `\uses` complete? | Formalizable? |
|---|---|---|---|
| L1 | `def:over_restrict_unit_iso_inv` | ✓ (`def:over_restrict_equiv`, `lem:isIso_unitToPushforwardObjUnit_of_isIso`) | ✓ |
| L2 | `def:over_restrict_presentation_inv` | ✓ (L1, `lem:over_restrict_pullback_iso`, `lem:presentation_map_mathlib`) | ✓ |
| L3 | `def:presentation_pullback_iota_preimage` | ✓ (`def:presentation_pullback_iota_of_quasicoherentData`, `lem:presentation_map_mathlib`, `lem:modules_pullback_mathlib`) | ✓ |
| L4 | `lem:isQuasicoherent_over_preimage` | ✓ (L2, L3, `lem:presentation_isQuasicoherent_mathlib`) | ✓ |
| L5 | `lem:coversTop_preimage` | ✓ (`lem:isQuasicoherent_quasicoherentData_mathlib`) | ✓ |
| L6 | `lem:isQuasicoherent_pullback_of_isOpenImmersion` | ✓ (L4, L5, `lem:isQuasicoherent_quasicoherentData_mathlib`, `lem:isQuasicoherent_of_coversTop_mathlib`) | ✓ |
| output | `lem:qcoh_pullback_fromSpec` | ✓ (L6) | ✓ |

**Mathlib anchors** cited in the chain:
- `lem:presentation_isQuasicoherent_mathlib` (`SheafOfModules.Presentation.isQuasicoherent`) — `\mathlibok` ✓
- `lem:isQuasicoherent_of_coversTop_mathlib` (`SheafOfModules.IsQuasicoherent.of_coversTop`) — `\mathlibok` ✓
- `lem:isQuasicoherent_quasicoherentData_mathlib` (`SheafOfModules.QuasicoherentData`) — `\mathlibok` ✓
- `lem:modules_pullback_mathlib` (`AlgebraicGeometry.Scheme.Modules.pullback`) — `\mathlibok` ✓
- `lem:presentation_map_mathlib` (`SheafOfModules.Presentation.map`) — `\mathlibok` ✓

All of `def:over_restrict_equiv` (line 3410), `lem:over_restrict_pullback_iso` (line 3575), `lem:isIso_unitToPushforwardObjUnit_of_isIso` (line 3611), `def:presentation_pullback_iota_of_quasicoherentData` (line 3697) are defined in the chapter.

**Chain mathematical completeness assessment:**
The route is logically complete:
1. Quasi-coherence data for `M` gives a cover `{q.Xᵢ}` on `X` (L5 + `isQuasicoherent_quasicoherentData_mathlib`)
2. The preimage family `{Wᵢ = g⁻¹(q.Xᵢ)}` covers `Y` (L5)
3. On each `Wᵢ`, the geometric pullback `(Wᵢ.ι* ) N` has a presentation (L3, via pseudofunctoriality of pullback)
4. Back-transport this to a presentation of the abstract slice `N.over Wᵢ` (L2 via L1)
5. A presentation implies quasi-coherence (L4 via `presentation_isQuasicoherent_mathlib`)
6. Local-to-global criterion closes (`isQuasicoherent_of_coversTop_mathlib`) — L6

This is exactly "pullback along an open immersion preserves quasi-coherence." The chain is mathematically complete with no gaps.

**No must-fix for the QuotScheme hard-gate.**

---

## Must-fix this iter summary

### FBC hard-gate (Cohomology_FlatBaseChange.tex) — **1 must-fix**

The `\leanok` annotations on the following three nodes misrepresent the current Lean sorry-status and must be corrected before the FBC-A1 prover lane can treat any of these as closed:

1. **`lem:base_change_mate_fstar_reindex_legs_conj`** (line ~2215) — root sorry at `FlatBaseChange.lean:1848`; remove `\leanok`
2. **`lem:base_change_mate_fstar_reindex_legs`** (line ~2273) — wrapper that calls the keystone; remove `\leanok`
3. **`lem:base_change_mate_fstar_reindex`** (line ~2328) — wrapper of wrapper; remove `\leanok`

The proof sketch for (1) is **sound and formalizable** — the `conjugateEquiv_symm_comp` route is the correct Mathlib idiom, the three legs (conj-2b/2c/2d) are axiom-clean, the `\uses` chain is complete, and the remaining gap is narrowly identified (the `.hom`-collapse of `(pushforwardComp g' (Spec φ)).hom` under `Γ.map`). No changes to the proof sketch or `\uses` are needed.

---

## Non-blocking flags

### Picard_FlatteningStratification.tex

- `thm:generic_flatness` has `\leanok` (line 1601) but the Lean file has `sorry` at line 2264 (the GF-geo geometric bridge step is not closed). GF-geo is BLOCKED pending gap2; clean up the `\leanok` once G1/G3 are closed.

---

## Unstarted-phase proposals

The blueprint has no chapter or blocks drafted for the **SNAP** phase (the next milestone after gap2 closes). STRATEGY marks SNAP as "NEXT (needs blueprint first)." No blueprint chapter for SNAP exists in `blueprint/src/chapters/` — the chapter has not been started. Blueprint scaffolding for SNAP should be proposed to unblock the SNAP prover lane once gap2 closes.
