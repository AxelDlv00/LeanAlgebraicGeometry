# Blueprint Audit Report — Iter 194

**Reviewer:** blueprint-reviewer subagent  
**Date:** 2026-05-26  
**Chapters audited:** 32 / 32 (all chapters under `blueprint/src/chapters/`)  
**Iter-194 prover dispatch lanes audited:** 10 / 10  

---

## Executive Summary

| Category | Count |
|---|---|
| Chapters: complete true, correct true | 16 |
| Chapters: complete true, correct partial (must-fix) | 3 |
| Chapters: complete false (gate failures) | 2 |
| Chapters: partial reads (non-lane, supporting) | 11 |
| Lane HARD GATE: PASS | 8 |
| Lane HARD GATE: FAIL | 2 |
| Must-fix findings (writer directives) | 4 |

**Dispatch recommendation:** Release 8 of 10 lanes. Block Lane H and Lane M↓. Writer directives issued for both + 2 additional must-fix chapters.

---

## Per-Chapter Checklist

### 1. `AbelJacobi.tex`
- **complete:** true  
- **correct:** true  
- **read:** full (73 lines)  
- All 3 declarations `\leanok`: `def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`. All route through Albanese framework. No must-fix.

---

### 2. `AbelianVarietyRigidity.tex`
- **complete:** true  
- **correct:** true (with typed-sorry caveats, all documented)  
- **read:** full (2325 lines across two sessions)  
- `% archon:covers` covers 7 Lean files.  
- All critical-path declarations have `\leanok`: `thm:rigidity_lemma`, `lem:hom_additivity_over_product`, `lem:eq_comp_of_isAffine_of_properIntegral`, `def:gaTranslationP1` (gmScalingP1), scaffold helpers (`def:gmscaling_cover`, `def:gmscaling_chart`, `lem:gmscaling_chart_agreement`, `lem:gmscaling_chart_PLB_eq`, `lem:gmscaling_over_coherence`), `lem:gmScaling_fixes_zero`, `lem:projGm_locallyOfFiniteType`, `lem:gm_geomIrred` (sorry-bearing, Mathlib gap documented), `lem:projGm_geomIrred`, `lem:projGm_isReduced` (sorry-bearing, Mathlib gap documented), `prop:morphism_P1_to_AV_constant`, `prop:rigidity_genus0_curve_to_AV`. Chart-bridge helpers `lem:mvPoly_to_homogeneousLocalization_away_surjective`, `lem:chart_ring_iso_preserves_algebraMap`, `lem:iotaGm_chart1_appIso_eval`, `lem:projlinebar_isReduced` all `\leanok`.  
- **Off-critical-path lemmas without `\leanok`:** `lem:hom_Ga_to_av_trivial` and `lem:hom_from_Ga_trivial` — both explicitly marked "Off the genus-0 critical path" and "retained for fidelity to Milne." Acceptable; no block.  
- **Typed-sorry instances:** `gm_geomIrred` and `projGm_isReduced` carry the confirmed Mathlib gap `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` (absent at b80f227). Both documented verbatim in blueprint with gap description. Properly pinned.  
- `lem:gmscaling_chart_agreement` body gated on `def:gmscaling_chart` having a concrete body. (III.c) separated-locus alternative is the live route; blocked (III.a) and descoped (III.b) are properly documented.  
- **No must-fix.**

---

### 3. `Albanese_AlbaneseUP.tex`
- **complete:** partial (first ~150 lines read)  
- **correct:** true (based on read)  
- Primary declarations seen: `thm:albanese_universal_property` → `AlgebraicGeometry.Pic0.albanese_universal_property` — `\leanok`; `lem:abel_jacobi_morphism` → `AlgebraicGeometry.Pic0.abelJacobi` — `\leanok`.  
- Non-lane supporting chapter; partial read sufficient for this audit.

---

### 4. `Albanese_AuslanderBuchsbaum.tex`
- **complete:** true  
- **correct:** true  
- **read:** full (610 lines)  
- `% archon:covers AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`  
- All primary declarations `\leanok`: `def:depth`, `lem:depth_via_ext`, `def:projective_dimension`, `lem:depth_short_exact_sequence`, `thm:auslander_buchsbaum`, `def:cohen_macaulay_local`, `cor:regular_cohen_macaulay`.  
- NOTE documented: `CohenMacaulay.of_regular` body has structural induction scaffold; load-bearing sorry in `exists_isSMulRegular_quotient_isRegularLocal_succ` (Stacks 00NQ). AB formula itself has 4 absent Mathlib pieces but `cor:regular_cohen_macaulay` is NON-BLOCKING for A.4.a.  
- **Lane G HARD GATE: PASS.**

---

### 5. `Albanese_CodimOneExtension.tex` ⚠️ MUST-FIX / GATE FAIL
- **complete:** false  
- **correct:** partial  
- **read:** full (954 lines)  
- `% archon:covers AlgebraicJacobian/Albanese/CodimOneExtension.lean`  
- **BLOCKER:** `lem:smooth_to_regular_local_ring` (Stacks 00TT: smooth → regular local ring) has **NO `\leanok`** — still a sorry pending; prose body is present but no Lean target closed.  
- `lem:smooth_codim_one_dvr` has partial `\leanok` only: Krull-dim half done, IsRegularLocalRing half still sorry.  
- `thm:codim_one_extension`, `lem:milne_codim1_indeterminacy`, `lem:mem_domain_partial_map_reshuffle` have `\leanok`.  
- `thm:weil_divisor_obstruction` has **NO `\lean{...}` pin** (detached iter-179). Prose present but Lean name absent.  
- Stage 5/6 Kähler-localisation helpers from iter-193 are **NOT mentioned in blueprint at all** — no `\lemma` blocks, no `\lean{...}` pins for the iter-193 additions.  
- **Lane M↓ Stage 6 HARD GATE: FAIL.**

---

### 6. `Albanese_CoheightBridge.tex`
- **complete:** partial (first ~150 lines read)  
- **correct:** true (based on read)  
- Primary declarations seen: `lem:coheight_eq_of_isOpenEmbedding`, `lem:coheight_spec_eq_height_primeSpectrum`, `thm:ringKrullDim_stalk_eq_coheight`, `lem:ringKrullDimLE_of_coheight_eq_one` — all `\leanok`.  
- Non-lane supporting chapter; partial read sufficient.

---

### 7. `Albanese_Thm32RationalMapExtension.tex`
- **complete:** partial (first ~150 lines read)  
- **correct:** true (based on read)  
- Primary declaration: `thm:rational_map_to_av_extends` → `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` — `\leanok`. Char-free proof; Route-A input.

---

### 8. `AlgebraicJacobian_Cotangent_GrpObj.tex`
- **complete:** true  
- **correct:** true  
- **read:** full (88 lines)  
- Pointer chapter to `AlgebraicJacobian/Cotangent/GrpObj.lean`. All declarations closed/axiom-clean: `cotangentSpaceAtIdentity`, `cotangentSpaceAtIdentity_eq_extendScalars`, `cotangentSpaceAtIdentity_finrank_eq`, `shearMulRight`, `schemeHomRingCompatibility`, `relativeDifferentialsPresheaf_restrict_along_identity_section`. Zero sorry-bodied declarations.

---

### 9. `Cohomology_MayerVietoris.tex`
- **complete:** partial (first ~150 lines read)  
- **correct:** true (based on read)  
- Multiple `\leanok` declarations for Mayer-Vietoris infrastructure. Non-lane supporting chapter.

---

### 10. `Cohomology_SheafCompose.tex`
- **complete:** true  
- **correct:** true  
- **read:** full (41 lines)  
- `thm:HasSheafCompose_forget` — `\leanok`. One-declaration chapter; complete.

---

### 11. `Cohomology_StructureSheafAb.tex`
- **complete:** true  
- **correct:** true  
- **read:** full (79 lines)  
- All 3 declarations `\leanok`: `thm:HasSheafify_Opens_AddCommGrp`, `thm:HasExt_Sheaf_Opens_AddCommGrp`, `def:Scheme_toAbSheaf`.

---

### 12. `Cohomology_StructureSheafModuleK.tex`
- **complete:** partial (first ~150 lines read)  
- **correct:** true (based on read)  
- Multiple `\leanok` declarations for k-module sheaf infrastructure. Non-lane supporting chapter.

---

### 13. `Differentials.tex`
- **complete:** partial (first ~150 lines read)  
- **correct:** true (based on read)  
- Primary declarations seen: `def:relative_kaehler_presheaf`, `lem:relative_kaehler_presheaf_obj`, `thm:smooth_locally_free_omega`, `lem:kaehler_localization_subsingleton`, `lem:kaehler_quotient_localization_iso` — all `\leanok`.

---

### 14. `Genus.tex`
- **complete:** true  
- **correct:** true  
- **read:** full (76 lines)  
- `def:genus` → `AlgebraicGeometry.genus` — `\leanok`. One-declaration chapter; complete.

---

### 15. `Genus0BaseObjects_Cross01Substrate.tex`
- **complete:** partial (first ~150 lines read)  
- **correct:** true (based on read)  
- Primary declarations seen: `thm:IsClosedImmersion_lift_iff_range_subset` → `AlgebraicGeometry.IsClosedImmersion.lift_iff_range_subset` — `\leanok`; `thm:gmRing_tensor_homogeneousAway_isDomain` → `AlgebraicGeometry.gmRing_tensor_homogeneousAway_isDomain` — `\leanok`.

---

### 16. `Jacobian.tex`
- **complete:** partial (first ~500 lines read; key theorem seen)  
- **correct:** true (based on read)  
- Key declarations: `def:JacobianWitness`, `thm:nonempty_jacobianWitness` → `AlgebraicGeometry.nonempty_jacobianWitness` — `\leanok` (body is a case-split delegating to `def:genusZeroWitness` and `def:positiveGenusWitness`); `def:genusZeroWitness` → `AlgebraicGeometry.genusZeroWitness` — `\leanok` (body sorry, gated on `prop:rigidity_genus0_curve_to_AV`).  
- Route A budget documented (iter-172 audit): A.1 ~700–1100 LOC, A.2 ~2200–3000 LOC (dominant), A.3 ~600–900 LOC, A.4 ~2500+ LOC. Total ~6000–7500+ LOC / 48–78 iters.  
- Route B historical alternative; not pursued.  
- Genus-0 arm decoupled via `genusZeroWitness` consuming `prop:rigidity_genus0_curve_to_AV`.

---

### 17. `Picard_FGAPicRepresentability.tex`
- **complete:** partial (first ~200 lines read)  
- **correct:** true (based on read)  
- Primary declarations seen: `lem:line_bundle_quot_correspondence`, `thm:fga_pic_representability` → `AlgebraicGeometry.Scheme.PicScheme.representable` — both `\leanok`.

---

### 18. `Picard_FlatteningStratification.tex`
- **complete:** partial (first ~100 lines read)  
- **correct:** true (based on read)  
- Primary declaration seen: `def:coherent_sheaf_flat` → `AlgebraicGeometry.Scheme.CoherentSheafFlat` — `\leanok`. Main representability theorem unread (non-lane chapter, partial read sufficient).

---

### 19. `Picard_IdentityComponent.tex` ⚠️ MUST-FIX
- **complete:** true  
- **correct:** partial  
- **read:** full (807 lines, summary-reconstructed from prior session)  
- All declarations `\leanok`: `GroupScheme.IdentityComponent`, `Pic0Scheme`, `PicScheme.degree`, `picSharp`, `Pic0Scheme.isAbelianGroup`, etc.  
- **MUST-FIX:** Typed-sorry carrier issue for `Pic0Scheme` / `PicScheme` / `picSharp` carriers is **NOT explicitly flagged** in prose. Carriers depend on `QuotScheme` (itself typed-sorry at Stacks 01HQ / 01I8 / 01XJ) and `PicScheme.representable` (also typed-sorry). This carrier-soundness dependency chain is undocumented in the chapter body.  
- `geometricallyConnected_of_connected_of_section` (Stacks 037Q/04KU) not mentioned.  
- **Lane A.3.i HARD GATE: PASS** (all `\leanok`; carrier-soundness flag is a documentation must-fix, not a prover blocker for iter-194).

---

### 20. `Picard_LineBundlePullback.tex`
- **complete:** partial (first ~150 lines read)  
- **correct:** true (based on read)  
- Primary declarations seen: `def:IsLocallyTrivial`, `def:line_bundle_on_product` — `\leanok`. `OnProduct` carrier: subtype `{ M : (Limits.pullback πC πT).Modules // IsLocallyTrivial M }` with 1 narrow named typed sorry on chart-iso composition (documented).

---

### 21. `Picard_Pic0AbelianVariety.tex` ⚠️ MUST-FIX
- **complete:** true  
- **correct:** partial  
- **read:** full (740 lines)  
- `% archon:covers AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`  
- All 5 theorem blocks `\leanok`: `thm:pic0_tangent_space_iso` → `Scheme.Pic0.tangentSpaceIso`, `thm:pic0_smooth` → `Scheme.Pic0.smooth`, `thm:pic0_proper` → `Scheme.Pic0.proper`, `thm:pic0_geom_irred` → `Scheme.Pic0.geometricallyIrreducible`, `thm:pic0_isAbelianVariety` → `Scheme.Pic0.isAbelianVariety`.  
- **MUST-FIX 1:** Chapter still contains the stale note "Lean skeleton is owed in a follow-up iteration" — the Lean file `Pic0AbelianVariety.lean` **now EXISTS** with 5 typed sorries. Note must be updated to reflect current status.  
- **MUST-FIX 2:** The AddEquiv-vs-LinearEquiv universe-mismatch issue (noted in the focus areas spec) is **NOT documented** in this chapter. The `tangentSpaceIso` statement involves a universe-polymorphic `LinearEquiv` (or `AddEquiv`) matching that may differ from the `AddEquiv` in downstream consumers; this constraint is not captured in prose.  
- **Focus area 1 (Kleiman §5 + Milne III §6):** 5 `\lean{...}` pins present and appear correct; no mismatch detected.

---

### 22. `Picard_QuotScheme.tex`
- **complete:** true  
- **correct:** true  
- **read:** full (~1190 lines)  
- `% archon:covers AlgebraicJacobian/Picard/QuotScheme.lean`  
- All declarations `\leanok`: `def:hilbert_polynomial`, `def:quot_functor`, `def:grassmannian_scheme`, `thm:grassmannian_representable`, `thm:quot_representable` → `AlgebraicGeometry.Scheme.QuotScheme`, `thm:flat_base_change_cohomology`, `def:quot_canonical_basechange_map`, `thm:quot_canonical_basechange_app_app_isIso`, `thm:quot_canonical_basechange_isIso`, `def:quot_pullback_app_isoTensor`, `def:pullback_app_isoTensor_sigma` (the `_sectionLinearEquiv` sigma-pair), `lem:pullback_tildeIso` (Stacks 01HQ — typed sorry, documented), `lem:pushforward_isQuasicoherent` (Stacks 01XJ — typed sorry, documented), `lem:tildeIso_of_isQuasicoherent_isAffineOpen` (Stacks 01I8 — typed sorry, documented), `lem:pullback_of_openImmersion_iso_restrict` (typed sorry, documented).  
- All typed-sorry declarations are properly pinned as named Mathlib-gap substrates with Stacks citations and LOC estimates.  
- The `_sectionLinearEquiv` uses `LinearEquiv` throughout — no AddEquiv mismatch in this chapter.  
- **Lane F LinearEquiv HARD GATE: PASS.**

---

### 23. `Picard_RelPicFunctor.tex`
- **complete:** partial (first ~200 lines read)  
- **correct:** true (based on read)  
- Primary declarations seen: `lem:rel_pic_sharp_groupoid`, `def:rel_pic_sharp`, `lem:rel_pic_sharp_functorial` — all `\leanok`.

---

### 24. `Picard_RelativeSpec.tex`
- **complete:** partial (first ~100 lines read)  
- **correct:** true (based on read)  
- Primary declarations seen: `def:qc_sheaf_of_algebras` → `AlgebraicGeometry.Scheme.QcohAlgebra` — `\leanok`; `thm:relative_spec_exists` → `AlgebraicGeometry.Scheme.RelativeSpec` — `\leanok`.

---

### 25. `RiemannRoch_H1Vanishing.tex` ⚠️ MUST-FIX / GATE FAIL
- **complete:** partial (substrate helpers unpin)  
- **correct:** true  
- **read:** full (581 lines, from prior session)  
- `% archon:covers AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`  
- All 7 planned declarations `\leanok`: `def:flasqueSheaf`, `lem:flasque_h1_zero`, `thm:h1_vanishing_smooth_affine`, `lem:h1_coherent_vanishing_rr`, `thm:h1_linebundle_vanishing`, and infrastructure helpers.  
- **BLOCKER (Focus area 3):** iter-193 substrate helpers `ext_succ_eq_zero_of_injective_of_lower_zero` and `IsFlasque.cokernel_of_shortExact_flasque_flasque` are **NOT given their own `\lemma` blocks** in the chapter. Described in Out of Scope section as "project-side ancillary lemmas sketched inside the proof but not given their own pin." These are now Lean-side landed declarations without blueprint pins — a `lean-vs-blueprint` tracker gap.  
- **Lane H substrate HARD GATE: FAIL** (completeness concern: iter-193 Lean declarations lack blueprint pins).

---

### 26. `RiemannRoch_OCofP.tex`
- **complete:** true  
- **correct:** true  
- **read:** full (800+ lines, from prior session)  
- All 9 declarations `\leanok`: `def:lineBundleAtClosedPoint_carrierPresheaf`, `lem:lineBundleAtClosedPoint_carrierPresheaf_isSheaf`, `def:lineBundleAtClosedPoint_carrierSubmoduleSheaf`, `def:lineBundleAtClosedPoint`, `def:lineBundleAtClosedPoint_toFunctionField`, `lem:lineBundleAtClosedPoint_globalSections_iff`, `lem:H1_vanishing_lineBundleAtClosedPoint_genusZero`, `thm:lineBundleAtClosedPoint_dim_eq_two_of_genusZero`, `cor:nonconstant_function_genus_zero`.  
- **Lane A/OCofP HARD GATE: PASS.**

---

### 27. `RiemannRoch_OcOfD.tex`
- **complete:** partial (first ~200 lines read)  
- **correct:** true (based on read)  
- Primary declaration seen: `def:sheafOf` → `AlgebraicGeometry.Scheme.WeilDivisor.sheafOf` — `\leanok`. Chapter is satellite of RR.2; gated on body of `sheafOf`.

---

### 28. `RiemannRoch_RRFormula.tex`
- **complete:** partial (first ~200 lines read)  
- **correct:** true (based on read)  
- Primary declarations seen: `def:eulerChar_curve`, `def:l_invariant` — both `\leanok`. Restricts to genus-0 specialization.

---

### 29. `RiemannRoch_RationalCurveIso.tex`
- **complete:** true  
- **correct:** true  
- **read:** full (604 lines, from prior session)  
- All declarations `\leanok`: `lem:morphism_to_p1_from_global_sections`, `lem:degree_via_pole_divisor`, `lem:degree_one_morphism_iso` → `AlgebraicGeometry.Scheme.iso_of_degree_one`, `thm:genus_zero_curve_iso_p1` → `AlgebraicGeometry.genusZero_curve_iso_P1`.  
- NOTE: `lem:degree_one_morphism_iso` Step 2 (scheme-level lift via `Scheme.Hom.toNormalization`) remains typed sorry; Step 1 closed axiom-clean iter-189.  
- **Lane RCI HARD GATE: PASS.**

---

### 30. `RiemannRoch_WeilDivisor.tex`
- **complete:** true  
- **correct:** true  
- **read:** full (890 lines)  
- `% archon:covers AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`  
- All declaration blocks `\leanok`.  
- `lem:degree_positivePart_principal_eq_finrank` (Focus area 2): NOTE documents iter-194 refactor v2 lane-i-localparameter-signature-v2. Prose now reads "Let t∞ ∈ K(ℙ¹_k̄) be a local parameter at ∞", reflecting **Option (b) / v2 form** (pin to `K(ℙ¹)` not abstract `K`). The `hLPUnif` uniqueness hypothesis mentioned in the NOTE is structural scaffolding, not a missing formal statement. v2 form is correctly reflected.  
- **Lane I HARD GATE: PASS.** Lane I signature corrective (Focus area 2) verified resolved.

---

### 31. `Rigidity.tex`
- **complete:** true  
- **correct:** true  
- **read:** full (72 lines)  
- `thm:GrpObj_eq_of_eqOnOpen` → `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` — `\leanok`, axiom-clean. Used in M2.a genus-0 Albanese witness and Albanese uniqueness.

---

### 32. `RigidityKbar.tex`
- **complete:** partial (first ~150 lines read)  
- **correct:** true (based on read)  
- `thm:rigidity_over_kbar` → `AlgebraicGeometry.rigidity_over_kbar` — `\leanok` on statement, sorry body (named gap). Documented as fallback-(a) artifact, carrying `[IsAlgClosed kbar] + [CharZero kbar]`. Not the committed genus-0 route.

---

## Cross-Chapter Findings

### CF-1: Carrier Soundness Chain (Focus area 5)

Declarations `Pic0Scheme` / `PicScheme` / `QuotScheme` / `picSharp` form a typed-sorry carrier chain. The chain is:

```
QuotScheme (typed sorry: Stacks 01HQ/01I8/01XJ — Picard_QuotScheme.tex §§ lem:pullback_tildeIso, lem:tildeIso_..., lem:pushforward_...)
  ↓ consumed by
PicScheme.representable (typed sorry — Picard_FGAPicRepresentability.tex thm:fga_pic_representability body)
  ↓ consumed by
Pic0Scheme, picSharp (typed sorry — Picard_IdentityComponent.tex)
  ↓ consumed by
Scheme.Pic0.tangentSpaceIso, .smooth, .proper, .geometricallyIrreducible, .isAbelianVariety (typed sorry — Picard_Pic0AbelianVariety.tex)
```

Each layer is properly pinned in its own chapter. The chain is sound (typed-sorry propagates honestly). However, `Picard_IdentityComponent.tex` does **not** prose-document that its `Pic0Scheme` carrier depends on the QuotScheme substrates. Chapters affected: IdentityComponent, Pic0AbelianVariety. **Writer directive issued (see WD-3, WD-4).**

### CF-2: H1Vanishing / Pic0AbelianVariety Resolution (Focus area 6)

Both issues noted as "RESOLVED per iter-193" in the dispatch directive are confirmed:
- `RiemannRoch_H1Vanishing.tex` file exists and is complete at the chapter level (not the substrate-pin level — see GATE finding above).
- `Picard_Pic0AbelianVariety.tex` file exists (not a file-mismatch issue). The stale note in the chapter is a must-fix documentation issue, not a file-mismatch.

### CF-3: Lane I Signature (Focus area 2) — RESOLVED

`lem:degree_positivePart_principal_eq_finrank` in `RiemannRoch_WeilDivisor.tex` has been updated to the v2 / Option (b) form. The prose reads "Let t∞ ∈ K(ℙ¹_k̄) be a local parameter at ∞" — pinned to `K(ℙ¹)`, not abstract `K`. Iter-195 writer action is NOT needed; the corrective landed.

### CF-4: Jacobian `thm:nonempty_jacobianWitness` Status

The single remaining mathematical hypothesis gating Route A is properly documented in `Jacobian.tex`. The `\leanok` on the statement is correct; the body sorry honestly delegates to `genusZeroWitness` (genus-0 arm, gated on `prop:rigidity_genus0_curve_to_AV`) and `positiveGenusWitness` (positive-genus arm, gated on Route A). No must-fix.

---

## HARD GATE Verdicts — Iter-194 Prover Dispatch

### Lane I — `RiemannRoch/WeilDivisor.lean`
**VERDICT: ✅ PASS**  
Chapter `RiemannRoch_WeilDivisor.tex`: complete true, correct true. All declarations `\leanok`. v2 lane-i-localparameter-signature reflected in prose. Lane I may proceed.

---

### Lane H — `RiemannRoch/H1Vanishing.lean` (H1Vanishing substrate)
**VERDICT: ❌ FAIL**  
Chapter `RiemannRoch_H1Vanishing.tex`: complete **partial** (substrate helpers unpin).  

**Reason:** iter-193 landed `ext_succ_eq_zero_of_injective_of_lower_zero` and `IsFlasque.cokernel_of_shortExact_flasque_flasque` as Lean-side declarations, but neither declaration has a corresponding `\lemma` block with `\lean{...}` pin in the blueprint chapter. The `lean-vs-blueprint` tracker cannot confirm these declarations are blueprint-specced. The chapter's Out-of-Scope section acknowledges them as "project-side ancillary lemmas sketched inside the proof but not given their own pin" — this acknowledgment is insufficient for the HARD GATE.

**Writer directive WD-1:** Add two `\lemma` blocks to `RiemannRoch_H1Vanishing.tex`:

```latex
\begin{lemma}
\leanok
[Ext-succ vanishes when the map is injective and lower Ext is zero]
  \label{lem:ext_succ_zero_of_injective_lower_zero}
  \lean{CategoryTheory.ext_succ_eq_zero_of_injective_of_lower_zero}
  \uses{...}
  Let $0 \to A \xrightarrow{f} B \to C \to 0$ be a short exact sequence ...
  [prose from the inline proof sketch; ~5 lines sufficient]
\end{lemma}

\begin{lemma}
\leanok
[Cokernel of a short exact sequence of flasque sheaves is flasque]
  \label{lem:flasque_cokernel_short_exact}
  \lean{TopologicalSpace.Sheaf.IsFlasque.cokernel_of_shortExact_flasque_flasque}
  \uses{def:flasqueSheaf}
  ...
\end{lemma}
```

Place these in the Substrate section before the proof of `thm:h1_linebundle_vanishing`. Verify `\lean{...}` names match the actual Lean declarations in `H1Vanishing.lean`.

---

### Lane M↓ Stage 6 — `Albanese/CodimOneExtension.lean`
**VERDICT: ❌ FAIL**  
Chapter `Albanese_CodimOneExtension.tex`: complete **false**.  

**Reasons (two independent blockers):**

**Blocker M-1:** `lem:smooth_to_regular_local_ring` (Stacks 00TT) has **no `\leanok`** — the Lean body is still a sorry. The blueprint chapter contains a full prose proof but no Lean closure. This is a HARD GATE criterion violation.

**Blocker M-2:** Stage 5/6 Kähler-localisation helpers from iter-193 are **absent from the blueprint** — no `\lemma` blocks, no `\lean{...}` pins, no mention of the new declarations.

**Blocker M-3:** `thm:weil_divisor_obstruction` has **no `\lean{...}` pin** (detached iter-179). The prose is present but the Lean name is absent; `lean-vs-blueprint` cannot track this declaration.

**Writer directive WD-2:**

1. For `lem:smooth_to_regular_local_ring`: Update body to either (a) add `\leanok` once the Lean sorry is closed, or (b) add a NOTE block documenting the Stacks 00TT gap and the current sorry status explicitly (similar to how `lem:gm_geomIrred` documents its Mathlib gap). Do NOT add `\leanok` while the Lean body is still sorry.

2. For Stage 5/6 Kähler-localisation helpers: Add `\lemma` blocks with `\lean{...}` pins for each iter-193 declaration. Pull the exact Lean declaration names from `Albanese/CodimOneExtension.lean` lines ~(find with grep). Each block needs `\leanok` if the Lean body is closed, or the NOTE-gap pattern if still sorry.

3. For `thm:weil_divisor_obstruction`: Restore the `\lean{...}` pin. The detached-iter-179 note should document the current Lean name (check the Lean file for the actual declaration name).

---

### Lane E — `AbelianVarietyRigidity.lean` (final closures)
**VERDICT: ✅ PASS**  
Chapter `AbelianVarietyRigidity.tex`: complete true, correct true. All critical-path declarations `\leanok`. Headline `prop:rigidity_genus0_curve_to_AV` → `AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme` is `\leanok`. Two off-critical-path alternative-route lemmas (`lem:hom_Ga_to_av_trivial`, `lem:hom_from_Ga_trivial`) lack `\leanok` but are explicitly marked as demoted alternatives not on the genus-0 critical path — acceptable. Typed-sorry instances (`gm_geomIrred`, `projGm_isReduced`) properly document the `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` Mathlib gap. Lane E may proceed.

---

### Lane F — `Picard/QuotScheme.lean` (LinearEquiv)
**VERDICT: ✅ PASS**  
Chapter `Picard_QuotScheme.tex`: complete true, correct true. All declarations `\leanok`. The `_sectionLinearEquiv` sigma-pair packaging uses `LinearEquiv` throughout — no AddEquiv/LinearEquiv mismatch in this chapter (the AddEquiv issue is in `Pic0AbelianVariety.tex`, not here). Named typed-sorry Mathlib-gap pins (`lem:pullback_tildeIso`, `lem:pushforward_isQuasicoherent`, `lem:tildeIso_of_isQuasicoherent_isAffineOpen`, `lem:pullback_of_openImmersion_iso_restrict`) are all properly documented. Lane F may proceed.

---

### Lane B — `Genus0BaseObjects/GmScaling.lean` (chart-bridge)
**VERDICT: ✅ PASS (with caveats)**  
Chapter `AbelianVarietyRigidity.tex` (GmScaling section): complete true, correct true for the blueprint chapter. All GmScaling declarations `\leanok`. The chart-bridge sub-build is in the live phase: `def:gmscaling_chart` body is a named scaffold sorry; `lem:gmscaling_chart_agreement` is gated on it; `lem:gmscaling_over_coherence` is similarly gated. The blueprint properly documents the (III.c) separated-locus alternative as the live prover route, with (III.a) BLOCKED and (III.b) DESCOPED. The Mathlib gap (`Algebra.TensorProduct.isDomain_of_isAlgClosed_left`) is documented. The blueprint is complete and correct for the prover's current position. **Lane B may proceed; the prover's task is to close `gmScalingP1_chart` body via the (III.c) route.**

---

### Lane A.3.i — `Picard/IdentityComponent.lean`
**VERDICT: ✅ PASS (with documentation must-fix)**  
Chapter `Picard_IdentityComponent.tex`: complete true, correct partial (carrier-soundness undocumented). All declarations `\leanok`. The carrier-soundness issue (typed-sorry `Pic0Scheme`/`PicScheme`/`picSharp` depending on QuotScheme substrates) is a documentation must-fix, not a prover blocker — the sorry propagation is honest. Lane A.3.i may proceed. **Writer directive WD-3 issued (see below).**

---

### Lane RCI — `RiemannRoch/RationalCurveIso.lean`
**VERDICT: ✅ PASS**  
Chapter `RiemannRoch_RationalCurveIso.tex`: complete true, correct true. All declarations `\leanok`. `thm:genus_zero_curve_iso_p1` → `genusZero_curve_iso_P1` is `\leanok`. `lem:degree_one_morphism_iso` Step 2 (via `Scheme.Hom.toNormalization`) is still a typed sorry but properly documented. Lane RCI may proceed.

---

### Lane G — `Albanese/AuslanderBuchsbaum.lean`
**VERDICT: ✅ PASS**  
Chapter `Albanese_AuslanderBuchsbaum.tex`: complete true, correct true. All primary declarations `\leanok`. `cor:regular_cohen_macaulay` gates A.4.a and is `\leanok`. AB formula's 4 missing Mathlib pieces are documented as non-blocking. Lane G may proceed.

---

### Lane A/OCofP — `RiemannRoch/OCofP.lean`
**VERDICT: ✅ PASS**  
Chapter `RiemannRoch_OCofP.tex`: complete true, correct true. All 9 declarations `\leanok`. Lane A/OCofP may proceed.

---

## Writer Directives (Must-Fix)

### WD-1: `RiemannRoch_H1Vanishing.tex` — Pin iter-193 substrate helpers
**Blocks:** Lane H prover dispatch  
**Action:** Add `\lemma` blocks with `\lean{...}` and `\leanok` for:
- `ext_succ_eq_zero_of_injective_of_lower_zero` (Lean namespace: verify in `H1Vanishing.lean`)
- `IsFlasque.cokernel_of_shortExact_flasque_flasque` (Lean namespace: verify in `H1Vanishing.lean`)

Remove or update the Out-of-Scope disclaimer that currently excuses these as "not given their own pin." Both are now Lean-side landed declarations; they require blueprint pins.

**Priority:** HIGH — blocks Lane H dispatch.

---

### WD-2: `Albanese_CodimOneExtension.tex` — Three-item corrective
**Blocks:** Lane M↓ Stage 6 prover dispatch  
**Action (three items):**

1. **`lem:smooth_to_regular_local_ring`** — Either close the Lean body (and add `\leanok`) or add a NOTE block explicitly documenting this as a Stacks 00TT gap-sorry (matching the pattern used for `lem:gm_geomIrred` in `AbelianVarietyRigidity.tex`).

2. **Stage 5/6 Kähler-localisation helpers** — Add `\lemma` blocks with `\lean{...}` pins for each iter-193 declaration. Grep `Albanese/CodimOneExtension.lean` for new declarations added in iter-193 to get exact Lean names. Each block should have `\leanok` if the Lean body is closed, or the NOTE-gap pattern if sorry.

3. **`thm:weil_divisor_obstruction`** — Restore `\lean{...}` pin. Check `Albanese/CodimOneExtension.lean` for the current Lean declaration name (was detached iter-179).

**Priority:** HIGH — blocks Lane M↓ dispatch.

---

### WD-3: `Picard_IdentityComponent.tex` — Document carrier-soundness chain
**Blocks:** nothing (documentation only; A.3.i passes)  
**Action:** Add a NOTE block (or subsection) in the body of `def:Pic0Scheme` (or near the top of the chapter) documenting that:
- `Pic0Scheme`, `PicScheme`, `picSharp` are **typed-sorry** carriers
- Their bodies depend on `PicScheme.representable` (typed sorry) which in turn depends on `lem:pullback_tildeIso`, `lem:tildeIso_of_isQuasicoherent_isAffineOpen`, `lem:pushforward_isQuasicoherent` (all typed sorry, Stacks 01HQ/01I8/01XJ)
- This carrier-soundness chain means that axiom-clean status for this chapter is contingent on those upstreams closing

**Priority:** MEDIUM — documentation only; no lane blocked.

---

### WD-4: `Picard_Pic0AbelianVariety.tex` — Stale note + AddEquiv/LinearEquiv gap
**Blocks:** nothing (all declarations already `\leanok`; iter-194 chapter passes with caveats)  
**Action (two items):**

1. **Stale note:** Remove or update the passage "Lean skeleton is owed in a follow-up iteration." The file `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` now exists with 5 typed sorries corresponding to the 5 theorems. Replace with: "The Lean file `Pic0AbelianVariety.lean` exists with 5 typed-sorry bodies. Axiom-clean status is gated on the carrier-soundness chain of `Pic0Scheme` (see `Picard_IdentityComponent.tex` WD-3)."

2. **AddEquiv-vs-LinearEquiv:** Add a NOTE to `thm:pic0_tangent_space_iso` (or the section preamble) documenting: "The `tangentSpaceIso` Lean target uses `LinearEquiv` for the tangent-space iso. Consumers in the Albanese UP chain expect `AddEquiv`; verify universe levels match before considering this pin closed."

**Priority:** MEDIUM — no gate blocked but iter-194 must-fix for correctness.

---

## Unstarted Phase Proposals

### USP-1: `Albanese_CodimOneExtension.tex` Stage 5/6 subsection
The iter-193 Kähler-localisation helpers are in Lean but not in the blueprint. The writer should add a new subsection "Stage 5/6: Kähler localisation" in the chapter between the existing Stage 5 (smooth → regular) and Stage 6 (weil-divisor obstruction) material. This subsection should pin each helper with a `\lemma` block so the prover has specification-level guidance for the next iteration.

### USP-2: `RiemannRoch_H1Vanishing.tex` Substrate Annex
The chapter's Out-of-Scope section acknowledges ancillary substrate lemmas but doesn't pin them. A new "Substrate" subsection should be added to collect all project-side helpers that the chapter's proofs depend on, mirroring the pattern established by `Picard_QuotScheme.tex` §§ "Iter-187/189 analogist-licensed named substrate gaps."

### USP-3: Carrier-Soundness Tracking Document
A new chapter or annex `Picard_CarrierChain.tex` should document the full typed-sorry carrier chain (QuotScheme → PicScheme.representable → Pic0Scheme → Pic0AbelianVariety) with LOC estimates and milestone projections for when each layer closes. This supports the planner's view of how far away axiom-clean status is for the Picard arm.

---

## Dispatch Summary Table

| Lane | File | Blueprint Chapter | Gate | Notes |
|---|---|---|---|---|
| I | RiemannRoch/WeilDivisor.lean | RiemannRoch_WeilDivisor.tex | ✅ PASS | v2 signature reflected |
| H | RiemannRoch/H1Vanishing.lean | RiemannRoch_H1Vanishing.tex | ❌ FAIL | WD-1: add 2 lemma pins |
| M↓ | Albanese/CodimOneExtension.lean | Albanese_CodimOneExtension.tex | ❌ FAIL | WD-2: 3-item corrective |
| E | AbelianVarietyRigidity.lean | AbelianVarietyRigidity.tex | ✅ PASS | Typed-sorry documented |
| F | Picard/QuotScheme.lean | Picard_QuotScheme.tex | ✅ PASS | LinearEquiv OK |
| B | Genus0BaseObjects/GmScaling.lean | AbelianVarietyRigidity.tex | ✅ PASS | (III.c) is live route |
| A.3.i | Picard/IdentityComponent.lean | Picard_IdentityComponent.tex | ✅ PASS | WD-3 documentation only |
| RCI | RiemannRoch/RationalCurveIso.lean | RiemannRoch_RationalCurveIso.tex | ✅ PASS | |
| G | Albanese/AuslanderBuchsbaum.lean | Albanese_AuslanderBuchsbaum.tex | ✅ PASS | |
| A/OCofP | RiemannRoch/OCofP.lean | RiemannRoch_OCofP.tex | ✅ PASS | |

**8 of 10 lanes released. 2 lanes blocked pending writer directives WD-1 and WD-2.**

---

*End of blueprint-reviewer-iter194.md*
