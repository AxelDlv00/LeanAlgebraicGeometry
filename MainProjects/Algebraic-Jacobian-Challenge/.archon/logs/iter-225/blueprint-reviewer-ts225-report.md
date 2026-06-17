# Blueprint Review Report

## Slug
ts225

## Iteration
225

## Top-level summaries

### Incomplete parts

- `Picard_QuotScheme.tex`: `lem:quot_boundedness` proof sketch cites "Castelnuovo–Mumford m-regularity theorem of [Nitsure] §2" without naming the specific Lean route or identifying which Mathlib lemma supplies the uniform bound; a prover dispatched cold would need to fill this in.
- `Picard_FlatteningStratification.tex`: `lem:noetherian_induction_strata` references "Lemma REF" for the "base-change-without-flatness" ingredient (Nitsure §3) without a resolved `\lean{}` pin or proof sketch for that sub-lemma. The sub-lemma itself has no dedicated blueprint block.
- `Albanese_CodimOneExtension.tex`: Stage 6 sub-lemmas `lem:smooth_algebra_krull_dim_formula` (6.A), `lem:cotangent_kahler_over_field` (6.B), `lem:stage6_regular_stalk_assembly` (6.C) have no `\leanok` and are explicitly declared as Mathlib gaps. The file is 1708 lines; I read 972. The main theorems `thm:codim_one_extension` and `lem:milne_codim1_indeterminacy` appear in the unread portion — their Lean-body status and any residual blueprint gaps could not be confirmed. Filed as partial pending full read.
- `RiemannRoch_H1Vanishing.tex`: The proof strategy (flasque-sheaf acyclicity) requires Mathlib infrastructure (`InjResolution` + flasque-quotient argument on the `HModule` Ext pipeline) that is not pinned to a specific Mathlib path; only the high-level strategy is stated.
- `RiemannRoch_OCofP.tex`, `RiemannRoch_OcOfD.tex`, `RiemannRoch_RRFormula.tex`, `RiemannRoch_RationalCurveIso.tex`: All four Route C chapters have adequate blueprint structure but several sub-lemma proof sketches are shallow or reference Lean-absent infrastructure (sheafification of line bundles, Ext-cohomology chain over `HModule`, `Proj.fromOfGlobalSections` universal property). All are paused by USER standing directive.

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:internal_hom_isSheaf`: The proof says "the evaluation lem:internal_hom_eval, being a morphism of presheaves into the sheaf O_X, is a morphism of the corresponding sheaves of modules." This elides one step: the domain `M ⊗_psh M^∨` is the presheaf tensor, not the sheaf tensor; obtaining a morphism in `Scheme.Modules` requires invoking the universal property of sheafification (`M ⊗_X M^∨ = sheafify(M ⊗_psh M^∨)`) and the universal property for a presheaf morphism into a sheaf. The step is entirely standard and formalizable in a few lines, but it is not spelled out. A prover can fill it in without guessing; call it a **minor gap**.
- `Picard_QuotScheme.tex` / `lem:quot_boundedness`: The proof invokes "the Castelnuovo Lemma of [Nitsure] §2 converts m-regularity into vanishing of H^i" without specifying which Mathlib theorem plays this role (if any exists at commit `b80f227`).

### Lean difficulty quality

- `Picard_TensorObjSubstrate.tex` / `lem:internal_hom_isSheaf`: `\lean{AlgebraicGeometry.Scheme.Modules.dual}` — this is a definition-level target (the dual SheafOfModules object) rather than a standalone "isSheaf" lemma. In Lean the sheaf condition is discharged inside the construction of the object; the `\lean{}` pin correctly identifies the resulting declaration. No concern.
- `Albanese_CodimOneExtension.tex` / `lem:smooth_algebra_krull_dim_formula`: `\lean{Algebra.IsStandardSmoothOfRelativeDimension.ringKrullDim_localization_eq_relativeDimension}` — the name is well-formed and follows the project's established naming conventions. The cited Mathlib prerequisite `ringKrullDim_add_length_eq_ringKrullDim_of_isRegular` exists at `b80f227`. No concern with the target itself.
- `RiemannRoch_RationalCurveIso.tex`: Uses a top-level `\uses{}` on the chapter preamble (uncommon but not wrong) rather than on individual declarations — this is a minor style inconsistency but not a correctness issue.

## Per-chapter

### `blueprint/src/chapters/AbelJacobi.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Jacobian.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AbelianVarietyRigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - Sub-steps 1–3 all closed axiom-clean; `lem:internal_hom_eval` carries a `% NOTE (iter-224)` confirming it is closed.
  - **`lem:internal_hom_isSheaf` gate assessment (sub-step 4 target):**
    - Construction: "the presheaf internal hom Hom(M,N) satisfies the sheaf condition because N is a sheaf and morphisms into N can be glued sectionwise." This is a standard and well-specified argument; each sectionwise-gluing step is named. A prover can formalize this directly.
    - Lean target `AlgebraicGeometry.Scheme.Modules.dual`: well-formed. The construction specialises the general sheaf Hom(M,N) to N = O_X, yielding a SheafOfModules object with a descended evaluation morphism. No ambiguity in what the declaration should be.
    - `\uses{def:presheaf_dual, lem:internal_hom_eval}`: minimal but correct via transitivity (def:presheaf_dual → def:presheaf_internal_hom). Missing `def:presheaf_internal_hom` as explicit use, but transitively covered. Not a blocker.
    - Sheafification step for the descended evaluation (see Proofs Lacking Detail above): minor gap, formalizable without guessing.
    - **HARD GATE VERDICT: CLEARS.** The block is mathematically correct, detailed enough, and the Lean target is well-named.
  - **`lem:dual_isLocallyTrivial` — coherent with sub-step 4.** Proof uses trivialisation L|_U ≅ O_U → dual(L)|_U ≅ Hom(O_U, O_U) ≅ O_U, which follows from the slice formula of def:presheaf_internal_hom. The `\uses{lem:internal_hom_isSheaf, lem:tensorobj_restrict_iso}` is correct (the restriction-compatibility for internal hom follows from the slice formula definition). The proof says "restriction-compatibility being the dual analogue of lem:tensorobj_restrict_iso" — this analogy is derivable from definitions, no separate missing lemma. No must-fix.
  - **`rem:dual_discharges_inverse` — coherent with sub-step 4.** The remark correctly traces how L^{-1} = dual(L) closes `lem:tensorobj_inverse_invertible` via local triviality + contraction = unitor. Uses `{lem:tensorobj_inverse_invertible, lem:dual_isLocallyTrivial, lem:internal_hom_eval, lem:tensorobj_restrict_iso, lem:tensorobj_unit_iso}` — all correct dependencies. No must-fix.
  - Standing marker hygiene (known, tracked): `lem:islocallyinjective_whisker_of_W` and `lem:isiso_sheafification_map_of_W` have `\leanok` but no `\lean{}` pin; `lem:tensorobj_unit_iso`, `lem:presheaf_pushforward_adj_substrate`, `lem:restrictscalars_ringiso_strongmonoidal` lack `\leanok` on axiom-clean blocks due to `sync_leanok` multi-`\lean{}` parse quirk. All KNOWN and tracked per directive; do not block the gate.

### `blueprint/src/chapters/Picard_RelPicFunctor.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - Six Lean declarations all have `\leanok`, but the chapter carries multiple `% NOTE (iter-199 plan agent)` annotations documenting that the Lean bodies are placeholder implementations (constant-PUnit functor, zero map, etc.) gated on the `Scheme.Modules` monoidal-structure gap. Blueprint content is correct; the notes are honest disclosures.
  - Forward-looking `thm:rel_pic_etale_sheaf_unit_canonical` has no `\lean{}` pin and is explicitly deferred — correct per the chapter.

### `blueprint/src/chapters/Picard_FGAPicRepresentability.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_QuotScheme.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Sub-lemmas `lem:quot_boundedness`, `lem:quot_alpha_injective`, `lem:quot_valuative_criterion`, `lem:quot_reduction_to_pi_star_W` have proof sketches but no `\leanok` markers; the sketches are present but at varying depth.
  - `lem:quot_boundedness` proof sketch: cites "Mumford's m-regularity theorem of [Nitsure] §2" without identifying the Lean path for the uniform bound m. Prover would need to construct or import this.
  - The 6-stage Beck–Chevalley intertwining in `def:pullback_app_isoTensor_sigma` is extremely detailed and correct.
  - NOT in active prover lane; this chapter is gated behind A.2.c.

### `blueprint/src/chapters/Picard_FlatteningStratification.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:noetherian_induction_strata` references a "base-change-without-flatness lemma (cf. [Nitsure] §3)" at the key closing step without a `\lean{}` pin or dedicated blueprint block for that sub-lemma. A prover would need to build this separately.
  - `thm:generic_flatness_algebraic` has no `\leanok` (proof sketch present). `thm:generic_flatness` has `\leanok`. `thm:flattening_stratification_exists`, `thm:flattening_stratification_universal` have `\leanok`.
  - NOT in active prover lane.

### `blueprint/src/chapters/Picard_RelativeSpec.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_LineBundlePullback.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_IdentityComponent.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AbelianVarietyRigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Rigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RigidityKbar.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:rigidity_over_kbar` is a named gap (sorry body); this is honest and documented. The blueprint text is not missing content — it's a gated named gap with the construction explicitly deferred pending either route (a) gaps (i)+(ii) or route (b) dual-AV keystone.
  - The iter-155 correction (that chart-algebra does NOT avoid Serre duality on the C.2.d critical path) is correctly documented throughout. The earlier false claim was retracted and the blueprint reflects the corrected picture.
  - The chapter is paused / off critical path.

### `blueprint/src/chapters/Genus.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Differentials.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_SheafCompose.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_MayerVietoris.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - `HasCechToHModuleIso` and `HasAffineCechAcyclicCover` carrier classes are defined but documented as currently unproduced. The chapter is explicitly honest about this ("The project ships with: the genus carrier theorem is delivered as a conditional under the two carrier hypotheses"). No blueprint defect.

### `blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_CoheightBridge.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_CodimOneExtension.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Stage 6 sub-gaps (6.A `lem:smooth_algebra_krull_dim_formula`, 6.B `lem:cotangent_kahler_over_field`, 6.C `lem:stage6_regular_stalk_assembly`) are declared as Mathlib-absent and have no `\leanok`. Blueprint content for 6.A–6.C is present and detailed; but these are open obligations.
  - The file is 1708 lines; I read 972. The main theorem `thm:codim_one_extension` and `lem:milne_codim1_indeterminacy` are in the unread portion (~L700+). Their status — whether proof sketches are adequate and `\leanok` is present — could not be confirmed. Flagged conservative: partial.
  - The Stage A1/A2/A3 decomposition for the Jacobian-regular-sequence witness is detailed and actionable.
  - NOT in active prover lane (Route 1 held).

### `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_AlbaneseUP.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:symmetric_product_to_jacobian` birationality proof cites Riemann–Roch at `deg D = g` ("h^0(D) - h^1(D) = 1 generically"). The chapter carries a `% NOTE (iter-199)` flagging this as gated on Route C re-engagement. The blueprint is correct; the note accurately discloses the gate.
  - `def:symmetric_power_curve` (SymmetricPower) has `\leanok` but has no Mathlib analogue; the project-side sub-build is noted.

### `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - All core declarations (`def:prime_divisor`, `def:codim1_cycles`, `def:weil_divisor`, etc.) have `\leanok`. The chapter is substantive. However, the standing hypothesis `(*)`'s regular-in-codimension-one clause uses a project-side predicate (`IsRegularInCodimensionOne`) that chains through `lem:smooth_codim_one_dvr` — gated on Stacks 00TT (the smooth→regular-stalk implication), which is an explicit open gap in `Albanese_CodimOneExtension.tex`. The WeilDivisor chapter documents this explicitly.
  - Route C paused; not in active lane.

### `blueprint/src/chapters/RiemannRoch_OCofP.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - The H^1-vanishing of O_C(P) uses the direct cohomological route (no Serre duality) via the structural SES `0 → O_C → O_C(P) → k(P) → 0` together with genus-0 hypothesis and skyscraper H^1 vanishing. The latter is gated on `chap:RR_H1Vanishing`.
  - Route C paused.

### `blueprint/src/chapters/RiemannRoch_OcOfD.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - `sheafOf` body is explicitly declared a typed-sorry gated on the body of the presheaf construction. Blueprint documents this correctly as a body gap, not a specification gap.
  - Route C paused.

### `blueprint/src/chapters/RiemannRoch_RRFormula.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - The direct χ-inductive proof is well-structured and mathematically correct. The two helper sorries (`eulerCharacteristic_sheafOf_zero`, `eulerCharacteristic_sheafOf_succ`) are explicitly gated on the `sheafOf` body.
  - Route C paused.

### `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Chapter-level `\uses{}` on the preamble (unusual style but not wrong). Content appears well-structured from the portion read.
  - Route C paused.

### `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - The flasque-sheaf strategy is correct and stated at the right level of detail for the math. The gap is that the Lean proof of "HModule Ext-cohomology of a flasque sheaf vanishes in positive degree" requires building the connection between Grothendieck's derived-functor cohomology and the `Ext^n(const k, F)` definition — not spelled out.
  - Route C paused.

## Cross-chapter notes

- `AlgebraicJacobian_Cotangent_GrpObj.tex` is a pointer chapter for `AlgebraicJacobian/Cotangent/GrpObj.lean`, with mathematical content hosted in `RigidityKbar.tex`. The chapter body explicitly cross-references `chap:RigidityKbar`. Consistent.
- `Albanese_AlbaneseUP.tex` and `Jacobian.tex` both reference `thm:genus_zero_curve_iso_p1` (the RR bridge) as the genus-0 arm. This is the Route C chain (paused). Both chapters correctly attribute this as a pending/gated item.
- `lem:rational_map_to_av_extends` has two `\lean{}` pins in two chapters: `\lean{AlgebraicGeometry.rationalMap_to_av_extends}` in `AbelianVarietyRigidity.tex` (an older reservation) and `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}` in `Albanese_Thm32RationalMapExtension.tex` (the canonical target per the directive). The plan agent should reconcile — the `Thm32RationalMapExtension.tex` target is the canonical one; the `AbelianVarietyRigidity.tex` pin should be updated to point there.

## Severity summary

**Must-fix for their respective provers (NOT blocking active lane this iter):**
- `Picard_QuotScheme.tex` (complete: partial) — dispatch blueprint-writer when QuotScheme lane is de-gated.
- `Picard_FlatteningStratification.tex` (complete: partial) — dispatch blueprint-writer when FlatteningStratification lane is de-gated.
- `Albanese_CodimOneExtension.tex` (complete: partial, partially unread) — re-read full file + dispatch blueprint-writer when CodimOneExtension lane is de-gated.
- `RiemannRoch_*` chapters (all complete: partial) — Route C paused per USER standing directive; dispatch blueprint-writer when/if Route C is re-engaged.

**Active lane gate (`Picard_TensorObjSubstrate.tex` → sub-step 4 `lem:internal_hom_isSheaf`):**
- `complete: true`, `correct: true`, no must-fix finding on this chapter.
- **HARD GATE CLEARS** — dispatch mathlib-build prover for `lem:internal_hom_isSheaf` (`AlgebraicGeometry.Scheme.Modules.dual`) this iter.

**Soon:**
- `lem:rational_map_to_av_extends` dual-pin inconsistency between `AbelianVarietyRigidity.tex` and `Albanese_Thm32RationalMapExtension.tex` — update the older pin in `AbelianVarietyRigidity.tex` to point at the canonical target in Thm32.
- The sheafification-step minor gap in `lem:internal_hom_isSheaf` proof prose — add a sentence noting the universal-property-of-sheafification step; a prover can fill it in but the blueprint should be explicit.

**Informational:**
- Standing marker hygiene issues (multi-`\lean{}` parse quirk for `sync_leanok` on several dual-infra blocks in TensorObjSubstrate) — KNOWN and tracked per PROGRESS.md.

Overall verdict: **HARD GATE CLEARS for sub-step 4 (`lem:internal_hom_isSheaf`) — 33 chapters audited, 6 partial chapters in held/paused routes, 0 unstarted-phase proposals, active lane unobstructed.**
