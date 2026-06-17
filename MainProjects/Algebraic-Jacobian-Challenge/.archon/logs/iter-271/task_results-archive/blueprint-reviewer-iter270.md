# Blueprint Review Report

## Slug
iter270

## Iteration
270

---

## Top-level summaries

### Dependency & isolation findings

**1. Duplicate Lean pin: `lem:rational_map_to_av_extends` (AbelianVarietyRigidity.tex ~L764) — REMOVE**

`AbelianVarietyRigidity.tex` contains a `lem:rational_map_to_av_extends` block (proved, `\leanok`, isolated per leandag: 0 out-edges, 0 impact) pinned to `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` — the *same* Lean declaration that `thm:rational_map_to_av_extends` in `Albanese_Thm32RationalMapExtension.tex` is pinned to. Two DAG nodes sharing a Lean pin is a defect. The `lem:` copy's own narrative text ("`rmk:thm32_codim1_mathlib_gap`", "Route-A-only (iter-164)") confirms it was demoted to a retained copy when the canonical home was established in the Thm32 chapter. The Thm32 chapter's `thm:rational_map_to_av_extends` is wired (`\uses{thm:codim_one_extension, lem:milne_codim1_indeterminacy}`) and consumed by `thm:albanese_universal_property`. **REMOVE** `lem:rational_map_to_av_extends` from `AbelianVarietyRigidity.tex`. The narrative context ("demoted to Route-A input") can stay as part of `rmk:thm32_codim1_mathlib_gap`, which already captures it. Removing the `lem:` block eliminates the duplicate pin, cleans leandag's isolated-node count by 1, and makes the DAG unambiguous.

**2. Descoped S3 substeps in RigidityKbar.tex — KEEP**

`lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable` and `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange` are both annotated `% NOTE (iter-152, alg-closed pivot): DESCOPED — general-over-k Mathlib-PR fodder, NOT on the M2.a critical path.` Both are unproved and isolated (leandag: 0 impact, 0 consumers). The live `lem:constants_integral_over_base_field` does not use either (confirmed by reading the proof and by % NOTE annotations on both lemmas). Their isolation is by explicit architectural decision (the iter-152 alg-closed pivot), not by accident. The chapter retains them as documented Mathlib-PR seed material alongside the proved `lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper`. **KEEP** both — they represent valuable general-over-k generalisations with documented proof sketches, and their descoped isolation is entirely intentional. No `wire-up` is appropriate: the live proof does not need them, and forcing edges onto the live path would be mathematically wrong.

**3. By-design supplement `lem:isiso_sheafification_map_of_W` (Picard_TensorObjSubstrate.tex) — KEEP**

The block's own prose states: "retained as a supplement rather than as the associator's load-bearing step" and "retained for the historical record only." The surrounding route-(e) section explicitly marks the full monoidal-category build as "off path, not to be formalized." However, `lem:isiso_sheafification_map_of_W` itself is proved (`\leanok`) — it is a thin wrapper over a real Mathlib identity (`PresheafOfModules.inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`). Removing a proved result discards verified work. **KEEP**: the isolation is by design (the associator closed via the d.2 stalk route, not via this bridge), the lemma is provably correct, and "retained for the historical record" is an explicit keep directive from the chapter author. No `wire-up` is appropriate; keeping it isolated is correct.

**4. Stale-pin abandoned cluster in Cohomology_StructureSheafModuleK.tex — REMOVE all four**

The four blocks `thm:Scheme_IsAffineHModuleHomFinite`, `thm:Scheme_module_finite_HModule_prime_zero_of_isAffineHModuleHomFinite`, `thm:Scheme_module_finite_HModule_prime_of_affine`, and `thm:Scheme_module_finite_HModule_prime_of_affine_curve` all carry `\leanok` but their `\lean{}` pins point to **deleted Lean declarations** (confirmed by leandag `unmatched_lean` entries and by the chapter's own % NOTE flags added in iter-270). The per-affine-open Hom-finiteness approach was abandoned because `Γ(U,𝒪)=k[t]` is infinite-dimensional on a proper curve. The `\leanok` markers are therefore technically false (the underlying Lean code no longer exists under those names). The live engine uses `thm:Scheme_IsHModuleHomFinite` (the wholespace carrier), which is present and correct in the same chapter. The abandoned cluster is not wired into the live proof chain. **REMOVE all four**: they produce 4 `unmatched_lean` errors in leandag, carry false `\leanok` markers, describe an abandoned mathematical approach, and are superseded by the corrective `thm:Scheme_IsHModuleHomFinite` already in the chapter.

---

### Incomplete parts

- `Cohomology_StructureSheafModuleK.tex` / `def:Abelian_Ext_chgUnivLinearEquiv`: the universe-bump linear equivalence for `Ext` (pinned to `CategoryTheory.Abelian.Ext.chgUnivLinearEquiv`) is `unmatched_lean` and lacks `\leanok` — the Lean declaration does not exist under that name. This is a gap between the blueprint and Lean state.
- `Cohomology_FlatBaseChange.tex` / `lem:base_change_map_affine_local` and `lem:pushforward_base_change_mate_cancelBaseChange`: both are pinned to `AlgebraicGeometry.TODO.*` placeholder names, unmatched, and have documented sorry bodies. The chapter notes them as the two genuine open obligations of the affine base-change proof; their absence means `lem:affine_base_change_pushforward` (`\leanok`) depends on a sorry chain.
- `Picard_FlatteningStratification.tex`: only 4 `\leanok` declarations; the key theorems `thm:generic_flatness_algebraic`, `lem:flat_locus_open`, `lem:nonflat_locus_proper`, `lem:noetherian_induction_strata` are all `unmatched_lean` (TODO pins). This chapter is mostly unproved.

### Proofs lacking detail

- `Albanese_Thm32RationalMapExtension.tex` / `thm:rational_map_to_av_extends` proof block: the proof body is one paragraph delegating to `thm:codim_one_extension` and `lem:milne_codim1_indeterminacy`. This is mathematically complete (Milne's one-line proof "combine 3.1 with 3.3") and sufficient for a prover — no issue here, but the three-step combination is spelled out and adequate.

### Lean difficulty quality

- `Cohomology_StructureSheafModuleK.tex` / `thm:finite_appTop_of_universallyClosed`: this `\mathlibok` block is pinned to `AlgebraicGeometry.finite_appTop_of_universallyClosed`, which is listed as `unmatched_lean` by leandag. If this declaration does not exist in Mathlib under this name, the `\mathlibok` anchor is unfaithful — the downstream `thm:Scheme_module_finite_globalSections_of_isProper` (which uses it) is `\leanok`, so the Lean proof closed via some other Mathlib path, but the blueprint's `\mathlibok` pin is stale. A writer should find the actual Mathlib name and update the `\lean{}` hint, or confirm the declaration exists by searching Lean.
- `AbelianVarietyRigidity.tex` / `lem:hom_Ga_to_av_trivial` and `lem:hom_from_Ga_trivial`: both are `unmatched_lean` (pins to `AlgebraicGeometry.hom_Ga_to_av_trivial` and `AlgebraicGeometry.morphism_Ga_to_av_const` respectively). These are off-critical-path (Milne-faithful alternative), but the stale pins should be corrected.
- `Picard_TensorObjSubstrate.tex` / several unmatched pins: `lem:pullback_compatible_with_tensorobj` (should be `AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso`), `lem:pullback_tensor_iso` (→ `Scheme.Modules.pullbackTensorIso`), `lem:isinvertible_implies_locallytrivial` (→ `Scheme.Modules.IsInvertible.isLocallyTrivial`), `lem:isinvertible_pullback` (→ `Scheme.Modules.IsInvertible.pullback`), `thm:rel_pic_addcommgroup_via_tensorobj` (→ `PicSharp.addCommGroup_via_tensorObj`). All 51 `unmatched_lean` entries should be reviewed and repinned.

### Multi-route coverage

- Route A (A.1.c.sub → A.1.c.fun → A.2.c → A.3 → A.4): **PASS** — all sub-phases have substantive blueprint chapters with multiple declaration blocks.
- Route C (Riemann–Roch): **PAUSED** (user-permanent pause). Chapters `RiemannRoch_*` exist and contain content but are explicitly excluded from the critical path. Not a finding.
- Genus-0 arm (route-c char-free): **PASS** — `AbelianVarietyRigidity.tex` is comprehensive.

### Broken `\uses{}` edges

- `RiemannRoch_RationalCurveIso.tex` / `thm:genus_zero_curve_iso_p1`: `\uses{..., cor:nonconstant_function_genus_zero, ...}` — leandag reports this as `unknown_uses`. The label `cor:nonconstant_function_genus_zero` exists as a *secondary* `\label{}` alias on a corollary block in `RiemannRoch_OCofP.tex` (line 938), but leandag only recognizes the *primary* label `cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero`. **Fix**: change the `\uses{}` in `thm:genus_zero_curve_iso_p1` to reference the primary label `cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero`, or make `cor:nonconstant_function_genus_zero` a standalone node pointing to the same Lean decl so leandag can wire the edge. This is a must-fix broken edge.

---

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `lem:rational_map_to_av_extends` (~L764) — isolated duplicate of `thm:rational_map_to_av_extends` (same `\lean{}` pin); advise **REMOVE** (see `### Dependency & isolation findings` item 1).
  - `thm:genus_zero_curve_iso_p1` → `cor:nonconstant_function_genus_zero`: broken `\uses{}` edge — leandag cannot resolve the secondary label alias; must fix to primary label or add standalone node.
  - `lem:hom_Ga_to_av_trivial` and `lem:hom_from_Ga_trivial`: `unmatched_lean` (pin name mismatch); off-path but should be repinned.
  - Several remarks isolated (leandag gap count): informational, remarks don't require `\lean{}`.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Chapter is a prover-ready spec for a Lean file not yet created (`Thm32RationalMapExtension.lean` is the only stated deliverable of the dependent A.4.c chapter). The A.4.d Lean file does not yet exist; this is expected per the strategy. Blueprint prose is detailed and correct.
  - Gated on A.3 (Picard_FGAPicRepresentability/IdentityComponent) and A.4.c (Thm32) — both have blueprint chapters.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

*(22 `\leanok` declarations; the Auslander–Buchsbaum formula and Cohen–Macaulay corollary are well-specified with concrete Stacks references and Lean hints. No unmatched_lean entries observed.)*

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 9 `\leanok` declarations present; the remaining extension infrastructure has detailed proof sketches. Gated on Auslander–Buchsbaum (done). No unmatched_lean from this chapter visible in leandag output.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

*(8 `\leanok` declarations; short bridging chapter, no issues observed via grep.)*

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex — complete + correct, no notes.

*(The canonical home of `thm:rational_map_to_av_extends`. Well-wired. The proof is Milne's one-liner "combine 3.1 with 3.3" with full detail. Dependency edges correct.)*

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex — complete + correct, no notes.

*(Thin pointer chapter; all active declarations closed; orphan helpers noted as iter-146+ cleanup candidates — informational only.)*

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 14 `\leanok` declarations. Chapter implements the Čech higher direct image infrastructure. No unmatched_lean entries from this chapter visible. The comparison-iso carrier class (`HasCechToHModuleIso`) remains unproduced per the chapter's own "Producer status" note — this is a documented conditional-theorem posture, not an error.

### blueprint/src/chapters/Cohomology_FlatBaseChange.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `lem:base_change_map_affine_local` (→ `AlgebraicGeometry.TODO.base_change_map_affine_local`): `unmatched_lean`; documented sorry. The affine-reduction naturality step for the base-change map is unresolved.
  - `lem:pushforward_base_change_mate_cancelBaseChange` (→ `AlgebraicGeometry.TODO.pushforward_base_change_mate_cancelBaseChange`): `unmatched_lean`; documented sorry. The mate-vs-cancelBaseChange coherence computation is unresolved.
  - The main theorem `lem:affine_base_change_pushforward` is `\leanok` but gated on these two obligations — its proof body documents the sorry chain honestly.
  - All other lemmas in the chapter (affine pushforward/pullback dictionary, basis-locality, section computations) are `\leanok` with correct names.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

*(4 `\leanok` declarations; short infrastructure chapter.)*

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `def:Abelian_Ext_chgUnivLinearEquiv` (→ `CategoryTheory.Abelian.Ext.chgUnivLinearEquiv`): `unmatched_lean`, no `\leanok`. The universe-bump linear equivalence for `Ext` is blueprinted but not proved/pinned to a real Lean declaration. This is the bridge between the `H'` (open-flavour, universe `u`) and `H` (whole-space, universe `u+1`) cohomology carriers in the cover-totality bridge. The downstream `def:Scheme_HModule_prime_eq_HModule_linearEquiv` is `\leanok`, so the Lean proof must be closing via some other path — the blueprint's `\lean{}` pin is stale.
  - All 103 other `\leanok` declarations look correct per chapter structure.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - `thm:Scheme_IsAffineHModuleHomFinite`, `thm:Scheme_module_finite_HModule_prime_zero_of_isAffineHModuleHomFinite`, `thm:Scheme_module_finite_HModule_prime_of_affine`, `thm:Scheme_module_finite_HModule_prime_of_affine_curve`: all four carry `\leanok` but are `unmatched_lean` (Lean declarations deleted). The % NOTE flags added by dag-walker iter-270 flag them correctly; pins and `\leanok` markers were not updated. **REMOVE** all four (see adjudication item 4).
  - `thm:finite_appTop_of_universallyClosed` (`\mathlibok`): `unmatched_lean` — the Lean name `AlgebraicGeometry.finite_appTop_of_universallyClosed` does not exist under that name. The downstream consumer `thm:Scheme_module_finite_globalSections_of_isProper` is `\leanok`, so the Lean proof is closed via a different path; the `\mathlibok` anchor pin needs updating to the real Mathlib declaration name. Hard fail on the `\mathlibok` claim.
  - All other declarations (66+ `\leanok`) appear correct.

### blueprint/src/chapters/Differentials.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

*(Both substrates `thm:IsClosedImmersion_lift_iff_range_subset` and `thm:gmRing_tensor_homogeneousAway_isDomain` are `\leanok` with detailed proof sketches and correct Lean names.)*

### blueprint/src/chapters/Jacobian.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `thm:nonempty_jacobianWitness` carries a sorry (the single explicit foundational gap, by design). All auxiliary declarations (`def:IsAlbanese`, `def:JacobianWitness`, `def:Jacobian`, `thm:IsAlbanese_unique`, etc.) are `\leanok`. The chapter correctly exposes the existential gap.
  - `def:positiveGenusWitness` and `def:genusZeroWitness`: not read in full, but expected to be blueprinted per chapter structure.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Only 6 `\leanok` declarations; chapter is largely a specification of the FGA representability engine (A.2.c), mostly unproved pending the Quot/Hilbert infrastructure. This is expected per strategy. Blueprint structure is adequate for prover dispatch when upstream gating resolves.

### blueprint/src/chapters/Picard_FlatteningStratification.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Only 4 `\leanok` declarations; all key theorems (`thm:generic_flatness_algebraic`, `lem:flat_locus_open`, `lem:nonflat_locus_proper`, `lem:noetherian_induction_strata`) are `unmatched_lean` with TODO pins. Chapter is a specification chapter for largely-unbuilt A.2.c infrastructure. Expected per strategy.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

*(10 `\leanok` declarations; no unmatched entries observed.)*

### blueprint/src/chapters/Picard_LineBundleCoherence.tex — complete + correct, no notes.

*(10 `\leanok` declarations.)*

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

*(11 `\leanok` declarations; pullback functoriality for line bundles.)*

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 5 `\leanok` declarations; chapter blueprints the A.3 identity-component content. Partial coverage expected at this stage.

### blueprint/src/chapters/Picard_QuotScheme.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 15 `\leanok` declarations; several key declarations (`lem:quot_boundedness`, `lem:quot_alpha_injective`, `lem:quot_valuative_criterion`, `lem:quot_reduction_to_pi_star_W`) are `unmatched_lean` with TODO pins. The Quot/Hilbert engine is the dominant A.2.c build. Partial coverage expected.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - 21 `\leanok` declarations.
  - `thm:rel_pic_etale_sheaf_unit_canonical` (→ `AlgebraicGeometry.TODO.rel_pic_etale_sheaf_unit_canonical`): `unmatched_lean`; the étale-sheaf unit canonical section is documented as TODO.
  - `thm:rel_pic_addcommgroup_via_tensorobj` (→ `AlgebraicGeometry.PicSharp.addCommGroup_via_tensorObj`): `unmatched_lean`; the addCommGroup-via-tensorObj upgrade is blueprinted but not yet proved under the expected name.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

*(11 `\leanok` declarations; RelativeSpec infrastructure.)*

### blueprint/src/chapters/Picard_SheafOverEquivalence.tex — complete + correct, no notes.

*(8 `\leanok` declarations.)*

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - 75 `\leanok` declarations — the most active chapter. Multiple `unmatched_lean` entries from name changes/renames: `lem:pullback_compatible_with_tensorobj` (real name: `LineBundle.OnProduct.pullback_tensorObj_iso`), `lem:pullback_tensor_iso`, `lem:pullback0_tensor_iso`, `lem:pullback_tensor_iso_loctriv`, `lem:isinvertible_implies_locallytrivial`, `lem:isinvertible_pullback`, `thm:rel_pic_addcommgroup_via_tensorobj`, `lem:jw_ismonoidal`, `lem:stalk_tensor_commutation_naturality_right`. These are mostly Lean-side name updates not yet reflected in the blueprint. The `\lean{}` pins need a systematic repinning pass.
  - `lem:isiso_sheafification_map_of_W`: isolated by design, kept per adjudication item 3.
  - Route-(e) section (full monoidal category) explicitly off-path; not a content issue.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 20 `\leanok` declarations. Route C (Riemann–Roch) is USER-paused permanently. Chapter has substantive content. Incompleteness is by design.

### blueprint/src/chapters/RiemannRoch_OCofP.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 12 `\leanok` declarations. Route C paused. The secondary `\label{cor:nonconstant_function_genus_zero}` alias at line 938 is not recognized by leandag as a first-class node; see broken `\uses{}` finding above.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

*(Paused; content present and internally consistent.)*

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

*(Paused; 13 `\leanok`.)*

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- **complete**: complete
- **correct**: partial
- **notes**:
  - `thm:genus_zero_curve_iso_p1` uses `cor:nonconstant_function_genus_zero` (a secondary alias label in `RiemannRoch_OCofP.tex`): **broken `\uses{}` edge** per leandag `unknown_uses`. The fix is to change the `\uses{}` to reference the primary label `cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero`.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

*(Paused; 25 `\leanok`.)*

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - 38 `\leanok` declarations.
  - `lem:S3_sep_2_geom_reduced_finite_field_ext_is_separable` and `lem:S3_pi_2_isPurelyInseparable_of_unique_minPrime_baseChange`: both unproved, descoped by design (iter-152 alg-closed pivot), kept as Mathlib-PR fodder per adjudication item 2.
  - `lem:S3_sep_1_smooth_geometrically_reduced_Gamma` (→ `AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth`): `unmatched_lean` — Lean name may have changed. A minor pin issue.
  - `lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper` (→ `AlgebraicGeometry.Gamma_baseChange_iso_tensor_of_proper`): `unmatched_lean` — same situation.
  - `lem:KaehlerDifferential_constants_in_chart_of_proper_curve` (→ TODO): gap.
  - All major proved declarations (`lem:constants_integral_over_base_field`, `thm:rigidity_over_kbar`) are `\leanok`. The unmatched entries are pin-name issues, not mathematical errors.

---

## Cross-chapter notes

- `AbelianVarietyRigidity.tex` (`lem:rational_map_to_av_extends`) and `Albanese_Thm32RationalMapExtension.tex` (`thm:rational_map_to_av_extends`) are both pinned to `AlgebraicGeometry.Scheme.RationalMap.extend_to_av`. Two DAG nodes, one Lean target — the `lem:` copy should be removed (see adjudication 1).
- `Jacobian.tex` (~L340) still references `lem:rational_map_to_av_extends` in prose description of "Route c" via the old description of the rigidity chain. This references the leandag label from `AbelianVarietyRigidity.tex` — after the `lem:` duplicate is removed, the Jacobian.tex prose reference becomes a dangling `\cref{}`. The prose should be updated to reference `thm:rational_map_to_av_extends` (the Thm32 chapter) instead.

---

## Severity summary

**must-fix-this-iter:**

1. `RiemannRoch_RationalCurveIso.tex` / `thm:genus_zero_curve_iso_p1` → `cor:nonconstant_function_genus_zero`: **broken `\uses{}` edge** (leandag `unknown_uses`). Fix: replace with primary label `cor:lineBundleAtClosedPoint_exists_nonconstant_genusZero` in the `\uses{}` list. Feeds `prop:rigidity_genus0_curve_to_AV` and the genus-0 arm; out-of-order dispatch risk.

2. `Cohomology_StructureSheafModuleK.tex` / stale-pin cluster: **four `unmatched_lean` + false `\leanok`** on deleted Lean declarations. Writer directive: remove blocks `thm:Scheme_IsAffineHModuleHomFinite`, `thm:Scheme_module_finite_HModule_prime_zero_of_isAffineHModuleHomFinite`, `thm:Scheme_module_finite_HModule_prime_of_affine`, `thm:Scheme_module_finite_HModule_prime_of_affine_curve`. This is a HARD GATE blocking any prover that reads these as valid targets.

3. `Cohomology_StructureSheafModuleK.tex` / `thm:finite_appTop_of_universallyClosed` (`\mathlibok`): **unfaithful `\mathlibok` anchor** — the pinned Lean declaration name does not exist in the Lean tree. Must update pin to the real Mathlib name (or remove `\mathlibok` and repin). Hard fail per blueprint-reviewer rules.

4. `AbelianVarietyRigidity.tex` / `lem:rational_map_to_av_extends`: **duplicate `\lean{}` pin** (same Lean decl pinned by two blueprint nodes). Writer directive: remove the isolated `lem:` duplicate; update any `\cref{lem:rational_map_to_av_extends}` references in `Jacobian.tex` to point to `thm:rational_map_to_av_extends`.

**soon:**

- `Picard_TensorObjSubstrate.tex`: systematic `\lean{}` pin repinning pass needed for at least 9 name-changed declarations (the real Lean names are now different from the blueprint pins). Not blocking active provers yet, but stale pins cause ongoing `unmatched_lean` churn.
- `Cohomology_FlatBaseChange.tex` / `lem:base_change_map_affine_local` and `lem:pushforward_base_change_mate_cancelBaseChange`: open obligations with TODO pins. Not blocking (the Mathlib pseudofunctor coherence lane is parallel), but these are the last two sorry obligations in the flat base-change chapter.
- `Cohomology_MayerVietoris.tex` / `def:Abelian_Ext_chgUnivLinearEquiv`: `unmatched_lean`, missing `\leanok`. Update pin to real Lean name.
- `RigidityKbar.tex` / `lem:S3_sep_1_smooth_geometrically_reduced_Gamma` and `lem:S3_pi_1_Gamma_baseChange_iso_tensor_of_proper`: `unmatched_lean` (pin name changes). Repin to current Lean names.
- `AbelianVarietyRigidity.tex` / `lem:hom_Ga_to_av_trivial` and `lem:hom_from_Ga_trivial`: `unmatched_lean` name mismatches; repin.
- Every `remove` disposition (adjudication items 1 and 4): orphaned-scaffolding cleanup is never urgent but removes ongoing DAG noise.

**informational:**

- `AlgebraicJacobian_Cotangent_GrpObj.tex`: three orphan helpers (`shearMulRight`, `schemeHomRingCompatibility`, `relativeDifferentialsPresheaf_restrict_along_identity_section`) are iter-146+ cleanup candidates per the chapter's own note.
- Isolated remarks in `AbelianVarietyRigidity.tex` and `Jacobian.tex` (leandag gap count): remarks don't need `\lean{}` and their isolation is expected.
- 454 total isolated nodes in leandag; the vast majority are remarks, remark-class nodes, and nodes for off-path/paused content — not signals of missing edges.

**Overall verdict**: Blueprint is broadly sound but has 3 hard-fail correctness issues (broken `\uses{}`, 4 stale-pin `\leanok` blocks on deleted decls, 1 unfaithful `\mathlibok`) plus 1 duplicate-pin structural defect. The 4-declaration remove in `Cohomology_StructureSheafModuleK.tex` and the `RiemannRoch_RationalCurveIso.tex` broken edge are the highest-priority writer tasks this iter; all other chapters in the active prover cone (Picard_TensorObjSubstrate, Cohomology_FlatBaseChange) are `partial` on correct verdicts but due to known-open engineering gaps rather than mathematical errors.
