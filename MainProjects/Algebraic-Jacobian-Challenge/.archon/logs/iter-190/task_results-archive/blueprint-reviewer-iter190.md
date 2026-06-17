# Blueprint Review Report

## Slug
iter190

## Iteration
190

---

## Executive Summary

Whole-blueprint audit complete. 30 chapters read. Three **MUST-FIX** findings block prover dispatch on `Picard/QuotScheme.lean`, `RiemannRoch/RationalCurveIso.lean`, and `RiemannRoch/RRFormula.lean`. Five other candidate files receive PASS or CONDITIONAL PASS. Two unstarted-phase proposals (`chap:RR_H1Vanishing`, Pic0AbelianVariety A.3.iii-vii) identified.

---

## HARD GATE Verdicts

| Lean file | complete | correct | must-fix | Verdict |
|-----------|----------|---------|----------|---------|
| `RiemannRoch/OCofP.lean` | ✓ | ✓ | none | **PASS** |
| `RiemannRoch/RationalCurveIso.lean` | ✗ | ✗ | Pin 2 conflict unresolved (see below) | **FAIL** |
| `Picard/QuotScheme.lean` | ✗ | ✓ | 2 missing blocks (see below) | **FAIL** |
| `Albanese/AuslanderBuchsbaum.lean` | ✓ | ✓ | none | **PASS** |
| `Picard/IdentityComponent.lean` | ✓ | ✓ | none | **PASS** |
| `Genus0BaseObjects/Cross01Substrate.lean` | partial | ✓ | Substrate 2 not yet leanok (dispatch permitted) | **CONDITIONAL PASS** |
| `AbelianVarietyRigidity.lean` | ✓ | ✓ | Mathlib gaps honestly documented; no action needed this iter | **CONDITIONAL PASS** |
| `RiemannRoch/RRFormula.lean` | ✗ | ✗ | Broken `\cref{chap:RR_H1Vanishing}` (chapter does not exist) | **FAIL** |

---

## HARD GATE Detail

### FAIL: `RiemannRoch/RationalCurveIso.lean`

**Must-fix:** `lem:degree_via_pole_divisor` — Pin 2 (`Hom.poleDivisor_degree_eq_finrank`) is mathematically false as stated.

- The chapter's `% NOTE (iter-189 review)` (lines 219–229) correctly documents the structural conflict: `Hom.poleDivisor` is defined as a principal divisor (degree 0 by construction), but the RHS `Module.finrank k (H.evaluation_space)` is positive for a non-constant map.
- The conflict is documented but **no corrective action has been taken**: there is no revised declaration block using `positivePart`, no renamed theorem, no updated `\lean{...}` pin.
- The chapter block for `lem:degree_via_pole_divisor` still references `Hom.poleDivisor_degree_eq_finrank` without qualification.

**Required fix (either option):**
- **(a) Pivot statement:** Add a new block pinning a revised declaration `Hom.positivePart_degree_eq_finrank` (or similar) that correctly uses the positive part of the divisor. Update the `\lean{...}` pin and `\uses{}`.
- **(b) Document refactor explicitly:** Replace the current block with a `% NOTE:` annotation + `sorry`-bodied typed-sorry declaration that honestly represents the corrective shape, with a clear description of what the iter-190 prover must prove. Either way, `Hom.poleDivisor_degree_eq_finrank` in its current form must not remain the canonical pin for a lemma claiming equality with `finrank`.

Until one of (a) or (b) is done, prover dispatch on `RationalCurveIso.lean` risks a prover investing effort trying to close a false statement.

---

### FAIL: `Picard/QuotScheme.lean`

**Must-fix:** Two iter-189 landed private theorems lack blueprint blocks.

1. **`tildeIso_of_isQuasicoherent_isAffineOpen`** — line 616 in `QuotScheme.lean`, `private theorem`, Stacks 01I8 substrate. Chapter has no `\lean{...}` block for this declaration.
2. **`pullback_of_openImmersion_iso_restrict`** — line 643 in `QuotScheme.lean`, `private theorem`, transport substrate. Chapter has no `\lean{...}` block for this declaration.

The chapter has the iter-189 plan-phase `def:pullback_app_isoTensor_sigma` block (present and correctly pinning the Σ-pair helper). The two missing blocks are for the private helper theorems that underpin the main chain. Even for private declarations that are not blueprint-visible as top-level theorems, the iter-190 prover objective requires chapter coverage of any sorry that is part of the current proof obligation.

**Required fix:** Plan-phase must add `\lean{...}` blocks (or `% archon:private` annotated sketch blocks) for both declarations before prover dispatch.

---

### FAIL: `RiemannRoch/RRFormula.lean`

**Must-fix:** Broken `\cref{chap:RR_H1Vanishing}` cross-reference.

- The block for `lem:H1_skyscraperSheaf_finrank_eq_zero` references `\cref{chap:RR_H1Vanishing}` as the source for the H¹ vanishing argument.
- The chapter file `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex` does **not exist**. This is a dangling cross-reference that `blueprint-doctor` has already flagged.
- The `lem:H0_skyscraperSheaf_finrank_eq_one` and `lem:H1_skyscraperSheaf_finrank_eq_zero` blocks (iter-189 split) are otherwise correctly structured and both have `\leanok`.

**Required fix:** Write `RiemannRoch_H1Vanishing.tex` (see Unstarted-phase proposals below) OR, as a minimal fix, replace the `\cref{}` with inline prose and remove the dangling reference. Writing the chapter is strongly preferred because the H¹ vanishing argument is a STRATEGY.md sub-phase.

---

### CONDITIONAL PASS: `Genus0BaseObjects/Cross01Substrate.lean`

- Substrate 1 — `thm:IsClosedImmersion_lift_iff_range_subset`: block present, `\leanok`, axiom-clean (iter-189 landed).
- Substrate 2 — `thm:gmRing_tensor_homogeneousAway_isDomain`: block present, **no `\leanok`** marker. Chapter is correct (the block description matches what the declaration should prove), but the proof obligation is still open.

Dispatch is permitted because the chapter is structurally complete and honest. The iter-190 prover on `Cross01Substrate.lean` should target Substrate 2.

---

### CONDITIONAL PASS: `AbelianVarietyRigidity.lean`

- All critical-path declarations are leanok: `thm:rigidity_lemma`, `lem:hom_additivity_over_product`, `def:gaTranslationP1`, full chart scaffold (`lem:pullback_map_fst_proj`, `lem:pullback_map_snd_proj`, `def:gmscaling_cover`, `def:gmscaling_chart`, `lem:gmscaling_chart_agreement`, `lem:gmscaling_chart_PLB_eq`, `lem:gmscaling_over_coherence`), `lem:gmScaling_fixes_zero`, `lem:projGm_locallyOfFiniteType`, `lem:projGm_geomIrred`, `prop:morphism_P1_to_AV_constant`, `prop:rigidity_genus0_curve_to_AV`.
- Two Mathlib-gap typed sorries documented: `lem:gm_geomIrred` and `lem:projGm_isReduced` both carry `\leanok` with honest `% NOTE:` annotations that `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` is absent from Mathlib at commit `b80f227`. These are correctly typed-sorry pins, not false claims.
- Off-critical-path declarations (`lem:hom_Ga_to_av_trivial`, `lem:hom_from_Ga_trivial`, `lem:rational_map_to_av_extends`) correctly lack `\leanok`. Their absence does not block the committed critical-path dispatch.

No must-fix items for prover dispatch on the post-Lane-E-refactor `AbelianVarietyRigidity.lean`.

---

### PASS: `RiemannRoch/OCofP.lean`

All blocks leanok:
- `def:carrierPresheaf` — leanok
- `def:carrierSubmoduleSheaf` — leanok (reflects iter-188 `⊓ trivAtBot` carrier-refinement wrapper)
- `def:lineBundleAtClosedPoint_carrierSubmoduleSheaf` — leanok (iter-188/189 plan-phase addition; correctly pinned)
- `thm:carrierPresheaf_isSheaf` (Case B closed) — leanok, axiom-clean via direct irreducibility argument
- `def:lineBundleAtClosedPoint` — leanok

Chapter prose accurately reflects the landed implementation. No structural issues.

---

### PASS: `Albanese/AuslanderBuchsbaum.lean`

All public declarations leanok. The private lemma `isDomain_of_regularLocal` (line 1300 in Lean) is correctly absent from the blueprint — private helpers do not require chapter blocks under the current discipline. The lone Stacks 00NQ named sorry is accurately captured in the chapter's `thm:isDomain_of_regularLocal` discussion. The `\lean{...}` pins for all public declarations are present.

---

### PASS: `Picard/IdentityComponent.lean`

10 declaration blocks, all leanok. Chapter is clean and complete.

---

## Per-Chapter Checklist

| Chapter file | complete | correct | Notes |
|---|---|---|---|
| `AbelJacobi.tex` | ✓ | ✓ | `def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp` all leanok |
| `AbelianVarietyRigidity.tex` | ✓ | ✓ | See CONDITIONAL PASS above; Mathlib gaps honestly documented |
| `Albanese_AlbaneseUP.tex` | ✓ | ✓ | `thm:albanese_universal_property` leanok (sorry body) |
| `Albanese_AuslanderBuchsbaum.tex` | ✓ | ✓ | See PASS above |
| `Albanese_CodimOneExtension.tex` | ✓ | ✓ | `def:indeterminacy_locus` leanok |
| `Albanese_CoheightBridge.tex` | ✓ | ✓ | Coheight bridge declarations leanok |
| `Albanese_Thm32RationalMapExtension.tex` | partial | ✓ | `thm:rational_map_to_av_extends` leanok (typed sorry); target Lean file `Thm32RationalMapExtension.lean` not yet created — not a blocker |
| `AlgebraicJacobian_Cotangent_GrpObj.tex` | ✓ | ✓ | All declarations leanok, zero sorry-bodied |
| `Cohomology_MayerVietoris.tex` | ✓ | ✓ | Multiple leanok declarations |
| `Cohomology_SheafCompose.tex` | ✓ | ✓ | `thm:HasSheafCompose_forget` leanok |
| `Cohomology_StructureSheafAb.tex` | ✓ | ✓ | 3 leanok blocks |
| `Cohomology_StructureSheafModuleK.tex` | ✓ | ✓ | Multiple leanok blocks |
| `Differentials.tex` | ✓ | ✓ | `def:relative_kaehler_presheaf`, `lem:relative_kaehler_presheaf_obj`, `thm:smooth_locally_free_omega` all leanok |
| `Genus.tex` | ✓ | ✓ | `def:genus` leanok |
| `Genus0BaseObjects_Cross01Substrate.tex` | partial | ✓ | See CONDITIONAL PASS above; Substrate 2 not yet leanok |
| `Jacobian.tex` | ✓ | ✓ | All major declarations leanok: `def:IsAlbanese`, `def:Jacobian`, `thm:Jacobian_grpObj`, `thm:Jacobian_smooth_genus`, `thm:Jacobian_proper`, `thm:Jacobian_geomIrred` |
| `Picard_FGAPicRepresentability.tex` | ✓ | ✓ | `lem:line_bundle_quot_correspondence` leanok |
| `Picard_FlatteningStratification.tex` | partial | ✓ | `def:coherent_sheaf_flat` leanok; generic flatness theorem status not fully confirmed from excerpt |
| `Picard_IdentityComponent.tex` | ✓ | ✓ | See PASS above |
| `Picard_LineBundlePullback.tex` | ✓ | ✓ | `def:line_bundle_on_product` leanok |
| `Picard_QuotScheme.tex` | ✗ | ✓ | See FAIL above — 2 missing blocks for iter-189 private theorems |
| `Picard_RelPicFunctor.tex` | partial | ✓ | `thm:rel_pic_etale_sheaf_group_structure` has no `\leanok` and no `\lean{...}` pin yet (math-only); 5 other blocks leanok |
| `Picard_RelativeSpec.tex` | ✓ | ✓ | `def:qc_sheaf_of_algebras` leanok, `thm:relative_spec_exists` leanok |
| `Picard_RelPicFunctor.tex` | partial | ✓ | See above |
| `RiemannRoch_OCofP.tex` | ✓ | ✓ | See PASS above |
| `RiemannRoch_OcOfD.tex` | ✓ | ✓ | `def:sheafOf`, `lem:sheafOf_zero`, `lem:sheafOf_singlePoint`, `lem:sheafOf_ses_single_add` all leanok |
| `RiemannRoch_RRFormula.tex` | ✗ | ✗ | See FAIL above — broken `\cref{chap:RR_H1Vanishing}` |
| `RiemannRoch_RationalCurveIso.tex` | ✗ | ✗ | See FAIL above — Pin 2 structural conflict unresolved |
| `RiemannRoch_WeilDivisor.tex` | ✓ | ✓ | `def:prime_divisor`, `def:codim1_cycles` leanok; chapter well-populated |
| `Rigidity.tex` | ✓ | ✓ | `thm:GrpObj_eq_of_eqOnOpen` leanok, axiom-clean Mathlib wrapper |
| `RigidityKbar.tex` | ✓ | ✓ | `thm:rigidity_over_kbar` leanok (sorry body); `[CharZero kbar]` + `[IsAlgClosed kbar]` hypotheses documented; correctly off the committed critical path |

---

## Unstarted-Phase Blueprint Proposals

### 1. `chap:RR_H1Vanishing` — Riemann-Roch H¹ Vanishing

**Priority: HIGH** — required to resolve the broken cross-reference in `RiemannRoch_RRFormula.tex` and to cover STRATEGY.md sub-phase `Genus-0 RR.2.H¹`.

**Proposed one-paragraph outline:**

This chapter should cover the vanishing result `H¹(C, L) = 0` for a line bundle `L` of degree ≥ 1 on a smooth projective curve `C` of genus 0. The argument proceeds via Serre duality: `H¹(C, L) ≅ H⁰(C, K_C ⊗ L⁻¹)^∨` where `K_C` is the canonical sheaf; for genus 0, `deg(K_C) = -2`, so `deg(K_C ⊗ L⁻¹) = -2 - deg(L) < 0` whenever `deg(L) ≥ 1`, and a line bundle of negative degree on a connected proper curve has no nonzero global sections. The chapter should pin: `lem:H1_vanishing_pos_degree` (the main result, used by `lem:H1_skyscraperSheaf_finrank_eq_zero` in `RiemannRoch_RRFormula.tex`), `lem:serre_duality_curve` (Serre duality as applied to curves — likely available from Mathlib via `AlgebraicGeometry.Curve.SerreDuality` or analogues), and `lem:line_bundle_neg_degree_no_sections`. The `\lean{...}` pins can point to new declarations in `RiemannRoch/H1Vanishing.lean` (a new file that the plan agent should create as a target). Sources: Hartshorne IV.1 (Riemann-Roch), Serre duality standard references.

---

### 2. Pic⁰AbelianVariety — A.3.iii-vii Sub-phases

**Priority: MEDIUM** — the five sub-phases (tangent space isomorphism, smoothness, properness, geometric irreducibility of Pic⁰, structure as abelian variety) have no dedicated blueprint chapter beyond `Picard_IdentityComponent.tex` which covers only A.3.i-ii (identity component construction and group object structure).

**Proposed one-paragraph outline:**

A new chapter `Picard_Pic0AbelianVariety.tex` should cover the remaining sub-phases needed to establish that Pic⁰(C/k) is an abelian variety for a smooth projective genus-`g` curve `C`. Sub-phase A.3.iii: the cotangent space of Pic⁰ at the identity is canonically `H⁰(C, Ω¹_C)^∨` — this requires a `lem:pic0_tangent_space_iso` declaration. Sub-phase A.3.iv: smoothness of Pic⁰ follows from flatness of the Poincaré line bundle combined with the tangent space computation — pin `lem:pic0_smooth`. Sub-phase A.3.v: properness of Pic⁰ over `k` (valuative criterion for the Picard scheme in the curve case) — pin `thm:pic0_proper`. Sub-phase A.3.vi: geometric irreducibility — Pic⁰ is connected (identity component) and geometrically irreducible as a variety over an algebraically closed field — pin `lem:pic0_geom_irred`. Sub-phase A.3.vii: assembling the above to conclude `thm:pic0_abelian_variety` (Pic⁰(C) is an abelian variety of dimension `g`). Sources: Milne *Abelian Varieties* §I.3–I.4; Bosch-Lütkebohmert-Raynaud *Néron Models* §8.4; FGA Explained §9.

---

## Top-Level Summaries

### Incomplete Parts

The following chapters have known open proof obligations (no `\leanok`) or structural incompleteness:

- `Genus0BaseObjects_Cross01Substrate.tex` — Substrate 2 (`thm:gmRing_tensor_homogeneousAway_isDomain`) open
- `Picard_QuotScheme.tex` — 2 missing blocks for iter-189 private theorems
- `RiemannRoch_RRFormula.tex` — depends on non-existent H1Vanishing chapter
- `RiemannRoch_RationalCurveIso.tex` — Pin 2 conflict unresolved
- `Albanese_Thm32RationalMapExtension.tex` — target Lean file not yet created
- `Picard_RelPicFunctor.tex` — `thm:rel_pic_etale_sheaf_group_structure` not yet pinned
- `AbelianVarietyRigidity.tex` — 2 Mathlib-gap typed sorries (`gm_geomIrred`, `projGm_isReduced`) honestly documented; 3 off-path declarations without `\leanok`

### Citation Discipline

No citation discipline violations observed. All chapters that reference specific mathematical results use `% SOURCE:` / `\textit{Source: ...}` annotations where expected. The two Mathlib-gap declarations in `AbelianVarietyRigidity.tex` carry proper `% NOTE:` annotations citing the specific absent lemma (`Algebra.TensorProduct.isDomain_of_isAlgClosed_left`) and the Mathlib commit hash (`b80f227`).

### Multi-Route Coverage

The blueprint currently covers:
- **Route A** (positive-genus via Picard/FGA): Picard representability, identity component, QuotScheme substrate — substantially covered
- **Route C** (genus-0 rigidity): `AbelianVarietyRigidity.tex` (post Lane-E refactor) — complete through `prop:rigidity_genus0_curve_to_AV`
- **RR sub-phases**: OCofP and OcOfD complete; WeilDivisor complete; RRFormula BLOCKED on H1Vanishing chapter
- **Albanese construction**: CodimOneExtension, AuslanderBuchsbaum, CoheightBridge all complete; AlbaneseUP and Thm32 are typed-sorry scaffolds

No chapter covers sub-phases A.3.iii-vii of the Pic⁰ abelian variety proof — see Unstarted-phase proposals.

---

## Severity Summary

| Severity | Finding | Blocking |
|----------|---------|---------|
| MUST-FIX | `RiemannRoch/RationalCurveIso.lean` — Pin 2 (`Hom.poleDivisor_degree_eq_finrank`) mathematically false as stated; chapter documents conflict but provides no corrective action | Blocks prover dispatch |
| MUST-FIX | `Picard/QuotScheme.lean` — 2 missing blocks (`tildeIso_of_isQuasicoherent_isAffineOpen`, `pullback_of_openImmersion_iso_restrict`) for iter-189 landed private theorems | Blocks prover dispatch |
| MUST-FIX | `RiemannRoch/RRFormula.lean` — broken `\cref{chap:RR_H1Vanishing}` (chapter does not exist); `blueprint-doctor` flagged | Blocks prover dispatch (gated) |
| WARN | `AbelianVarietyRigidity.tex` — `gm_geomIrred` and `projGm_isReduced` are Mathlib-gap typed sorries; Mathlib contribution needed | Does not block iter-190 dispatch; but blocks eventual axiom-clean close |
| WARN | `Genus0BaseObjects_Cross01Substrate.tex` — Substrate 2 (`gmRing_tensor_homogeneousAway_isDomain`) not yet leanok | Does not block dispatch; is the iter-190 proof target |
| WARN | `Picard_RelPicFunctor.tex` — `thm:rel_pic_etale_sheaf_group_structure` has no `\lean{...}` pin | Not on iter-190 dispatch candidate list |
| INFO | `Albanese_Thm32RationalMapExtension.tex` — target Lean file `Thm32RationalMapExtension.lean` not yet created | Not blocking any iter-190 file |
| INFO | No chapter exists for Pic⁰ abelian variety sub-phases A.3.iii-vii | Strategic gap; see Unstarted-phase proposals |
| INFO | No chapter exists for `chap:RR_H1Vanishing` (Genus-0 RR.2.H¹ sub-phase) | Strategic gap; currently causes a MUST-FIX in RRFormula |
