# Lean ↔ Blueprint Check Report

## Slug
flat-iter053

## Iteration
053

## Files audited
- Lean: `AlgebraicJacobian/Picard/FlatteningStratification.lean` (2929 lines)
- Blueprint: `blueprint/src/chapters/Picard_FlatteningStratification.tex` (2189 lines)

---

## Per-declaration check

### iter-053 targets

#### `\lean{AlgebraicGeometry.gf_localizedModule_baseChange_tensor_comm}` (B1.0, `lem:gf_localizedModule_baseChange_tensor_comm`)
- **Lean target exists**: yes — `noncomputable def gf_localizedModule_baseChange_tensor_comm` at line 2766
- **Signature matches**: yes — blueprint states `LocalizedModule T (N ⊗[R] K) ≃ₗ[R] (LocalizedModule T N) ⊗[R] K` with hypotheses `[CommRing R] [CommRing B] [Algebra R B] [AddCommGroup N] [Module R N] [Module B N] [IsScalarTower R B N] (T : Submonoid B) (K : Type*) [AddCommGroup K] [Module R K]`; Lean matches verbatim.
- **Proof follows sketch**: yes — blueprint says "uses `T⁻¹M ⊗[R] N = T⁻¹(M ⊗[R] N)` (i.e. `IsLocalizedModule.rTensor`) + uniqueness of localizations (`IsLocalizedModule.iso`)"; Lean body is `(IsLocalizedModule.iso T (TensorProduct.AlgebraTensorModule.rTensor R K (LocalizedModule.mkLinearMap T N))).restrictScalars R`. Mathematical content matches precisely.
- **notes**: axiom-clean, no sorry, `\leanok` in blueprint (statement block). **PASS — iter-053 primary deliverable.**

#### `\lean{AlgebraicGeometry.gf_flat_localizedModule_sameBase}` (B1, `lem:gf_flat_localizedModule_sameBase`)
- **Lean target exists**: yes — `theorem gf_flat_localizedModule_sameBase` at line 2791
- **Signature matches**: yes — blueprint states: `R → B → N` tower, `T : Submonoid B`, `[Module.Flat R N] → Module.Flat R (LocalizedModule T N)`; Lean matches exactly.
- **Proof follows sketch**: yes — blueprint sketch: "flatness via `iff_lTensor_injectiveₛ`; `IsLocalizedModule.map_lTensor` gives the B1.0 commutation; flatness of `N` + exactness of localization give injection". Lean proof at lines 2795–2803: `rw [Module.Flat.iff_lTensor_injectiveₛ]`, uses `IsLocalizedModule.map_lTensor`, `IsLocalizedModule.map_injective`, `Module.Flat.lTensor_preserves_injective_linearMap`. Blueprint note `"cf. gf_localizedModule_baseChange_tensor_comm"` — Lean uses `IsLocalizedModule.map_lTensor` (the Mathlib equivalent of the commutation) rather than the custom B1.0 iso directly; mathematically equivalent and acceptable.
- **notes**: axiom-clean, no sorry, `\leanok` in blueprint (statement block). **PASS — iter-053 primary deliverable.**

---

### G3 sub-results (verified this iter)

#### `\lean{AlgebraicGeometry.gf_patch_free_imp_flat}` (G3.1, `lem:gf_patch_free_imp_flat`)
- **Lean target exists**: yes — `theorem gf_patch_free_imp_flat` at line 2719
- **Signature matches**: yes — `[Module.Free R M] : Module.Flat R M`
- **Proof follows sketch**: yes — one-liner `Module.Flat.of_free`, as specified
- **notes**: `\leanok` in blueprint. PASS.

#### `\lean{AlgebraicGeometry.gf_stalk_flat_over_base}` (G3.2, `lem:gf_stalk_flat_over_base`)
- **Lean target exists**: no — declaration is entirely absent from the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint has `\lean{...}` hint but NO `\leanok`. This is an EXPECTED OPEN GAP: blueprint prose correctly explains the stalks (`F_x`, `O_{S,p(x)}`) are not yet formalized in Mathlib's `SheafOfModules` API. No `\leanok` marker, consistent with declaration being absent. Not a regression — pre-existing open.

#### `\lean{AlgebraicGeometry.gf_flat_base_local_on_source}` (G3.3, `lem:gf_flat_base_local_on_source`)
- **Lean target exists**: yes — `theorem gf_flat_base_local_on_source` at line 2732
- **Signature matches**: yes — `∀ (Q : Ideal B) [Q.IsMaximal], Module.Flat R (LocalizedModule Q.primeCompl N)` → `Module.Flat R N`; matches blueprint
- **Proof follows sketch**: yes — `Module.flat_of_isLocalized_maximal` as specified
- **notes**: `\leanok` in blueprint. PASS.

#### `\lean{AlgebraicGeometry.gf_stalk_flat_localBase}` (G3.4, `lem:gf_stalk_flat_localBase`)
- **Lean target exists**: yes — `theorem gf_stalk_flat_localBase` at line 2746
- **Signature matches**: yes — `(S : Submonoid R) [IsLocalization S R'] [Module.Flat R' N] : Module.Flat R N`
- **Proof follows sketch**: yes — blueprint says "compose `IsLocalization.flat` with `Module.Flat.trans`"; Lean body does exactly that.
- **notes**: `\leanok` in blueprint. Blueprint `\uses{lem:gf_stalk_flat_over_base}` describes geometric assembly context, not Lean proof dependency — the Lean proof takes flatness over `R'` as a hypothesis rather than calling G3.2. Acceptable: `\uses` tracks the mathematical dependency chain, not Lean tactic dependencies. Minor.

---

### G1 machinery (previously verified; confirmed consistent)

All G1 declarations were checked in prior iterations and have `\leanok` in the blueprint. This iter's full Lean re-read confirms they remain present and their signatures are unchanged:

| Blueprint label | Lean name | Line | Status |
|---|---|---|---|
| `lem:gf_finite_sections_of_basicOpen_finite_cover` | `gf_finite_sections_of_basicOpen_finite_cover` | ~1900s | `\leanok`, PASS |
| `lem:finite_localizedModule_transfer` | `finite_localizedModule_of_isLocalizedModule` | ~1900s | `\leanok`, PASS |
| `lem:gf_affine_qcoh_Gamma_epi` | `gf_affine_qcoh_Gamma_epi` | ~2100s | `\leanok`, PASS |
| `lem:gf_qcoh_finite_sections_globally_generated` | `gf_qcoh_finite_sections_globally_generated` | ~2100s | `\leanok`, PASS |
| `lem:gf_qcoh_sections_free_epi` | `gf_qcoh_finite_sections_of_free_epi` | ~2100s | `\leanok`, PASS |
| `lem:gf_affine_finite_standard_subcover` | `gf_affine_finite_standard_subcover` | ~2200s | `\leanok`, PASS |
| `lem:gf_finite_gen_iff_free_epi` | `gf_finite_gen_iff_free_epi` | ~2200s | `\leanok`, PASS |
| `lem:genSections_map` | `SheafOfModules.GeneratingSections.map` | ~2300s | `\leanok`, PASS |
| `lem:genSections_map_I` | `SheafOfModules.GeneratingSections.map_I` | ~2300s | `\leanok`, PASS |
| `lem:genSections_map_isFiniteType` | `SheafOfModules.GeneratingSections.map_isFiniteType` | ~2300s | `\leanok`, PASS |
| `lem:gf_localGenerators_restrict` | `gf_localGenerators_restrict` | ~2400s | `\leanok`, PASS |
| `lem:gf_finiteType_affine_finite_cover_generated` | `gf_finiteType_affine_finite_cover_generated` | ~2500s | `\leanok`, PASS |
| `lem:module_finite_of_ringEquiv_semilinear` | `module_finite_of_ringEquiv_semilinear` | ~2600s | `\leanok`, PASS |
| `lem:gf_qcoh_finite_sections_of_genSections` | `gf_qcoh_finite_sections_of_genSections` | ~2620s | `\leanok`, PASS |
| `lem:gf_qcoh_fintype_finite_sections` | `gf_qcoh_fintype_finite_sections` | 2674 | `\leanok`, PASS |

---

### Algebraic core (L1–L5, previously verified; confirmed consistent)

All dévissage chain lemmas, transport helpers, Nagata normalization (public declarations), polynomial core, and `genericFlatnessAlgebraic` are in the Lean file with matching signatures. `\leanok` markers in the blueprint are consistent with axiom-clean Lean declarations.

| Blueprint label | Lean name | Status |
|---|---|---|
| `thm:generic_flatness_algebraic` | `GenericFreeness.genericFlatnessAlgebraic` | `\leanok`, PASS |
| `lem:gf_finite_module` | `GenericFreeness.exists_free_localizationAway_of_finite` | `\leanok`, PASS |
| `lem:gf_torsion_base` | `GenericFreeness.exists_flat_localizationAway_of_finite` | `\leanok`, PASS |
| `lem:gf_splice_shortExact` | `GenericFreeness.exists_free_localizationAway_of_moduleFinite` | `\leanok`, PASS |
| `lem:gf_splice_shortExact_free_transport` | `GenericFreeness.exists_free_localizationAway_of_shortExact` | `\leanok`, PASS |
| `lem:gf_generic_rank_ses` | `GenericFreeness.gf_generic_rank_ses` | `\leanok`, PASS |
| `lem:gf_torsion_annihilator` | `GenericFreeness.gf_torsion_annihilator` | `\leanok`, PASS |
| `lem:gf_nagata_monic_lastVar` | `GenericFreeness.gf_nagata_monic_lastVar` | `\leanok`, PASS |
| `lem:gf_mvPolynomial_quotient_finite_monic` | `GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar` | `\leanok`, PASS |
| `lem:gf_torsion_reindex` | `GenericFreeness.gf_torsion_reindex` | `\leanok`, PASS |
| `lem:gf_away_tower_descent` | `GenericFreeness.free_localizationAway_of_away_tower` | `\leanok`, PASS |
| `lem:gf_polynomial_core` | `GenericFreeness.exists_free_localizationAway_polynomial` | `\leanok`, PASS |
| transport helpers (3) | `pullbackModuleAddEquiv`, `finite_of_pullbackModuleAddEquiv`, `pullback_isScalarTower` | `\leanok`, PASS |
| `lem:gf_finite_of_quotient_ringequiv` | `GenericFreeness.finite_of_quotientRingEquiv` | `\leanok`, PASS |
| `lem:gf_islocalizedmodule_restrictscalars` | `GenericFreeness.isLocalizedModule_restrictScalars` | `\leanok`, PASS |
| `lem:gf_isLocalization_lift_injective` | `GenericFreeness.isLocalization_lift_injective` | `\leanok`, PASS |
| `lem:gf_clear_one_denominator` | `GenericFreeness.gf_clear_one_denominator` | `\leanok`, PASS |

---

### Open/future targets (expected; no regression)

#### `\lean{AlgebraicGeometry.gf_section_localization_flat_descent}` (B2, `lem:gf_section_localization_flat_descent`)
- **Lean target exists**: no
- **notes**: No `\leanok` in blueprint, consistent with directive. B2 is a known open gap (requires `isLocalizedModule_basicOpen` from QuotScheme across two charts). Not a regression.

#### `\lean{AlgebraicGeometry.gf_flat_locality_assembly}` (G3, `lem:gf_flat_locality_assembly`)
- **Lean target exists**: no
- **notes**: No `\leanok` in blueprint. Requires B2 + geometric cross-chart plumbing. Expected gap.

#### `\lean{AlgebraicGeometry.genericFlatness}` (`thm:generic_flatness`)
- **Lean target exists**: yes — `theorem genericFlatness` at line 2818
- **Signature matches**: yes — `{S X : Scheme.{u}} [IsIntegral S] [IsLocallyNoetherian S] (p : X ⟶ S) [LocallyOfFiniteType p] [QuasiCompact p] (F : X.Modules) [F.IsQuasicoherent] [F.IsFiniteType]` with output `∃ (V : S.Opens), (V : Set S).Nonempty ∧ ...`
- **Proof follows sketch**: no — proof body is a `sorry` at line 2926; detailed comments at lines 2843–2925 explain the geometric gap (G3 plumbing, G1 already closed).
- **notes**: Blueprint `\leanok` is on the **statement block** (meaning "declaration is formalized with at least a sorry"), which is correct per the AGENTS.md convention. The proof block has no `\leanok`. Consistent with known open status. No action required this iter.

---

## Red flags

### Placeholder / suspect bodies

- `genericFlatness` at line 2926: body terminates in `:= sorry`. Blueprint proof block has no `\leanok`. **This is expected and documented** — detailed inline comments explain the geometric gap remaining. Not a new regression; classified as documented open.

### Pre-existing: private declarations pinned by public `\lean{...}` names

The following 11 `\lean{...}` hints in the Nagata normalization section of the blueprint reference **`private`** Lean 4 declarations, which receive name-mangled identifiers and are inaccessible by the blueprint-given names:

| Blueprint block | `\lean{...}` hint | Lean declaration | Private? |
|---|---|---|---|
| `def:gf_nagata_T1` | `GenericFreeness.T1` | `private def T1` | yes |
| `lem:gf_t1_comp_t1_neg` | `GenericFreeness.t1_comp_t1_neg` | `private lemma t1_comp_t1_neg` | yes |
| `def:gf_nagata_T` | `GenericFreeness.T` | `private def T` | yes |
| `lem:gf_lt_up` | `GenericFreeness.lt_up` | `private def lt_up` | yes |
| `lem:gf_sum_r_mul_ne` | `GenericFreeness.sum_r_mul_ne` | `private lemma sum_r_mul_ne` | yes |
| `lem:gf_degreeOf_zero_t` | `GenericFreeness.degreeOf_zero_t` | `private lemma degreeOf_zero_t` | yes |
| `lem:gf_degreeOf_t_ne_of_ne` | `GenericFreeness.degreeOf_t_ne_of_ne` | `private lemma degreeOf_t_ne_of_ne` | yes |
| `lem:gf_leadingCoeff_finSuccEquiv_t` | `GenericFreeness.leadingCoeff_finSuccEquiv_t` | `private lemma leadingCoeff_finSuccEquiv_t` | yes |
| `lem:gf_T_leadingcoeff_eq` | `GenericFreeness.T_leadingcoeff_eq` | `private lemma T_leadingcoeff_eq` | yes |
| `lem:gf_finSuccEquiv_map_comm` | `GenericFreeness.finSuccEquiv_map_comm` | `private lemma finSuccEquiv_map_comm` | yes |
| `lem:gf_finSuccEquiv_rename_succ` | `GenericFreeness.finSuccEquiv_rename_succ` | `private lemma finSuccEquiv_rename_succ` | yes |

All 11 have `\leanok` in the blueprint (placed by `sync_leanok` which operates at file/sorry-count level). The `\lean{...}` names would fail name-resolution tools (blueprint-doctor, `lean_verify`). **Pre-existing from prior iterations; not introduced in iter-053.**

---

## Unreferenced declarations (informational)

Declarations in the Lean file with no corresponding `\lean{...}` blueprint block, identified during full read:

- `gf_patch_free_imp_flat` context comment at lines 2701–2712 and associated namespace comment sections: these are comment infrastructure, not declarations, so not flagged.
- No substantive unreferenced public declarations were identified beyond what the blueprint already covers. The file is well-blueprinted for its public API.

---

## Blueprint adequacy for this file

- **Coverage**: All public Lean declarations in the file have a corresponding `\lean{...}` block in the chapter. Private Nagata normalization helpers are pinned by blueprinted names but are inaccessible by those names (pre-existing issue). Coverage for public API: 100%.
- **Proof-sketch depth**: **adequate** for iter-053 targets. B1.0's sketch ("localization is base change: `T⁻¹M ⊗[R] N = T⁻¹(M ⊗[R] N)`, transport via uniqueness") directly guided the Lean proof. B1's sketch ("flatness via `iff_lTensor_injectiveₛ`, commutation via B1.0/`map_lTensor`, exactness of localization") directly guided the Lean proof. G3.1/G3.3/G3.4 sketches are one-liners matching Mathlib combinators — adequate. G3.2 sketch is detailed but the Lean formalization requires Mathlib stalk API not yet available; the blueprint correctly notes this.
- **Hint precision**: **precise** for iter-053 targets and all G3 sub-results. The `\lean{...}` names exactly match the declared Lean identifiers, and the informal types match the Lean signatures.
- **Generality**: **matches need** for iter-053 deliverables. B1.0 is stated over an arbitrary `R`-module `K` (not just submodules), which is the exact generality B1's proof needs.
- **Recommended chapter-side actions**:
  1. **(pre-existing, major)** The 11 private-declaration `\lean{...}` hints should either be removed (blueprint uses prose only for these helpers, no `\lean{...}` pin) or the Lean declarations should be made non-private (promoted to protected or public within the namespace). If removed, the blueprint blocks keep their content but drop the `\lean{...}` line; `\leanok` would then need re-evaluation by `sync_leanok`. This change is cosmetic for mathematical content but important for toolchain integrity.
  2. **(informational)** G3.2 `lem:gf_stalk_flat_over_base` could add a `% NOTE: requires SheafOfModules.stalk API, not yet in Mathlib` annotation to explain why it has no `\leanok` despite a detailed proof sketch.

---

## Severity summary

**must-fix-this-iter**: **none** — B1.0 and B1 are clean; no fake/placeholder bodies for declared-substantive claims; no wrong-type signatures; no unauthorized axioms.

**major** (pre-existing, carry-forward): The 11 private-declaration `\lean{...}` hints pre-exist iter-053 and are not new regressions. Blueprint-doctor likely already flags these. Should be addressed in a dedicated cleanup iter (not blocking iter-053 work).

**minor**: G3.4 blueprint `\uses{lem:gf_stalk_flat_over_base}` documents a geometric application chain while the Lean proof is algebraically standalone; the `\uses` is not wrong but slightly overstates the proof dependency. No action required.

**Overall verdict**: iter-053 deliverables B1.0 (`gf_localizedModule_baseChange_tensor_comm`) and B1 (`gf_flat_localizedModule_sameBase`) are axiom-clean, signatures match the blueprint exactly, and proofs follow the blueprint sketches faithfully. No must-fix findings. The only open items are the known geometric gaps (G3.2/G3-assembly/genericFlatness body) and pre-existing private-name blueprint hints, neither of which is iter-053 scope.
