# Lean Audit Report

## Slug

iter167

## Iteration

167

## Scope

- files audited: 16 (root `AlgebraicJacobian.lean` + 15 under `AlgebraicJacobian/`)
- files skipped (per directive): 0

Files (in audit order):

1. `AlgebraicJacobian.lean`
2. `AlgebraicJacobian/AbelianVarietyRigidity.lean` *(Lane B modified iter-167)*
3. `AlgebraicJacobian/Genus0BaseObjects.lean` *(Lane A modified iter-167)*
4. `AlgebraicJacobian/AbelJacobi.lean`
5. `AlgebraicJacobian/Genus.lean`
6. `AlgebraicJacobian/Jacobian.lean`
7. `AlgebraicJacobian/Rigidity.lean`
8. `AlgebraicJacobian/RigidityKbar.lean`
9. `AlgebraicJacobian/Differentials.lean`
10. `AlgebraicJacobian/Cotangent/GrpObj.lean`
11. `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`
12. `AlgebraicJacobian/Cohomology/SheafCompose.lean`
13. `AlgebraicJacobian/Cohomology/StructureSheafAb.lean`
14. `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean`
15. `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean`
16. `AlgebraicJacobian/Cohomology/MayerVietorisCover.lean`

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import manifest, 13 submodule imports in dependency-consistent order. Unchanged this iter.

### AlgebraicJacobian/AbelianVarietyRigidity.lean *(Lane B modified iter-167)*
- **outdated comments**: 1 minor flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none **(5 iter-166 TODOs CLEANED UP this iter)**
- **notes**:
  - **Iter-166 TODO sweep CONFIRMED COMPLETE.** A `Grep` for `TODO|FIXME|XXX|HACK|temporary|placeholder|will fix later|stand-in` over this file returns zero hits. The five `-- TODO:` excuse-comments inside `morphism_P1_to_grpScheme_const_aux` at L943/947/952/1028/1034 of iter-166 have all been dropped — the directive's expectation is met.
  - **Iter-167 helper refactor verified sound.** `morphism_P1_to_grpScheme_const_aux` (L958–L1074) has zero inline `sorry`s. Four of the five iter-166 internal sorries (product `GeometricallyIrreducible`, product `LocallyOfFiniteType`, product `IsReduced`, `IsReduced ProjectiveLineBar.left`) are now discharged by `infer_instance` from Lane A's exported instances (`projGm_geomIrred`, `projGm_locallyOfFiniteType`, `projGm_isReduced`, `projectiveLineBar_isReduced`). The fifth (dominance of `ι`) is hoisted to a named top-level `private lemma iotaGm_isDominant` (L931–L934) with body `sorry`. Honest separation of concerns; consumer hygiene improved.
  - **iter-167 new declaration `iotaGm_isDominant` (L931–L934)**: `private lemma`, single-`sorry` body, docstring (L924–L930) discloses gating on Lane A's `gmScalingP1` body. Signature is concrete (no laundering): `IsDominant (lift (toUnit Gm ≫ onePt) (𝟙 Gm) ≫ gmScalingP1 kbar).left`. Hypothesis-correct (`[IsAlgClosed kbar]`).
  - **iter-167 helper docstring (L908–L957)** accurately describes the post-refactor state: "body fully refactored — all five in-line product/Proj `sorry`s have been eliminated. Four of them … ship from Lane A … and resolve by `infer_instance` in scope. The fifth — dominance of the canonical `Gm ↪ ℙ¹` map — is exposed as the named top-level bridge `iotaGm_isDominant`." Matches code. **NOT** outdated.
  - **Pre-existing axiom-clean rigidity chain unchanged**: `rigidity_snd_lift`, `snd_left_isClosedMap`, `morphism_eq_of_eqAt_closedPoints`, `eq_comp_of_isAffine_of_properIntegral`, `isIntegral_of_retract`, `rigidity_eqAt_closedPoint_of_proper_into_affine`, `rigidity_eqOn_saturated_open_to_affine`, `rigidity_eqOn_dense_open`, `rigidity_core`, `rigidity_lemma`, `hom_additive_decomp_of_rigidity`, `av_regularMap_isHom_of_zero` — all carry the iter-162 `sorry`-free bodies; collapse hypothesis `_hf` consistently threaded; load-bearing hypotheses not laundered.
  - **L1093 `morphism_P1_to_grpScheme_const`**: body `sorry`-free, propagates `sorryAx` through the helper (now reduced to `iotaGm_isDominant` + Lane A scaffold sorries). **L1090 status block updated**: still says "Status (iter-166)"; technically out of date by one iter — pointed out under **outdated comments** below as a minor finding.
  - **L1135 `genusZero_curve_iso_P1`**: full body `sorry` (RR bridge), unchanged from iter-166.
  - **L1160 `rigidity_genus0_curve_to_grpScheme`**: body `sorry`-free, propagates `sorryAx` through `genusZero_curve_iso_P1` + `morphism_P1_to_grpScheme_const`. **L1156 status block updated**: also still says "Status (iter-166)"; same minor staleness.
  - **L36** module docstring still says of `morphism_P1_to_grpScheme_const`: "(Still a scaffold `sorry` pending the concrete ℙ¹/𝔾ₘ/σ_× infra.)" — accurate at the chain level (the function's body propagates sorryAx through the helper's `iotaGm_isDominant` and Lane A's `gmScalingP1` body, all of which trace back to "concrete ℙ¹/𝔾ₘ/σ_× infra"). Not stale.
  - **Outdated comment (minor) — L1090, L1156**: two declaration docstrings open with "Status (iter-166):", but the relevant residual sorry-set changed materially this iter (iter-166 left the five product/dominance helper sorries inline; iter-167 hoisted them to Lane A + `iotaGm_isDominant`). Should be bumped to "Status (iter-167):". Flagged as **major** under outdated comments (not must-fix — content is correct, only the iter tag is stale).

### AlgebraicJacobian/Genus0BaseObjects.lean *(Lane A modified iter-167)*
- **outdated comments**: none
- **suspect definitions**: 3 flagged (the 3 new scaffold-sorry instances — see notes)
- **dead-end proofs**: none
- **bad practices**: 1 minor (see notes)
- **excuse-comments**: none
- **notes**:
  - **Iter-167 NEW axiom-clean instances**:
    * **L395–L398 `gmRing_isDomain`**: full body via `IsLocalization.isDomain_localization` + `powers_le_nonZeroDivisors_of_noZeroDivisors` + `MvPolynomial.X_ne_zero`. Pure ring theory. Axiom-clean. **Sound.**
    * **L404–L407 `gm_irreducibleSpace`**: full body via `change … ; infer_instance` — relies on `Spec` of a domain being irreducible (`PrimeSpectrum.irreducibleSpace`) and `gmRing_isDomain`. Axiom-clean **conditional** on `gmRing_isDomain` (itself axiom-clean). **Sound.**
    * **L500–L504 `projGm_locallyOfFiniteType`**: full body via `change` to `pullback.fst _ _ ≫ ProjectiveLineBar.hom`, then `infer_instance`. Resolves through Mathlib's `LocallyOfFiniteType` composition + base-change stability + `Gm`'s `LocallyOfFinitePresentation` (sound: L377–L381 full body) + `ProjectiveLineBar`'s LOFT (derivable from `IsProper`, L127). Axiom-clean. **Sound.**
    * **L542–L546 `projGm_geomIrred`**: full body via `change …; exact GeometricallyIrreducible.comp _ _`. The proof itself is sorry-free, BUT it propagates `sorryAx` through `gm_geomIrred` (sorry-bearing) and `projectiveLineBar_geomIrred` (pre-existing sorry, L175). The docstring honestly discloses this: "Axiom-clean given the individual GI scaffolds." Sound shape, propagation accurately accounted.
  - **Iter-167 NEW scaffold-sorry instances** (the three flagged under "suspect definitions"):
    * **L506–L522 `projectiveLineBar_isReduced`**: bare `sorry` body. **Docstring HONEST**: "Project-side scaffold sorry (Mathlib does not ship `IsReduced (Proj 𝒜)` for a domain graded ring; would close via `IsReduced.of_openCover` over `Proj.affineOpenCover` once `HomogeneousLocalization.Away` is bridged to `IsDomain` for the standard ℕ-grading on `MvPolynomial (Fin 2) k̄`)." Strategy enumerated (3 numbered steps). Names the actual Mathlib gap (`HomogeneousLocalization.Away` lacks the `IsDomain` bridge for the standard ℕ-grading), not an excuse. Acceptable scaffold.
    * **L524–L532 `gm_geomIrred`**: bare `by sorry`. Docstring: "Scaffold (Mathlib gap: the direct `GeometricallyIrreducible` consequence of `IrreducibleSpace + Spec(domain over alg closed)` is not bridged; the analogist's recipe would require base-change reduction via `IsAlgClosed`-fixed bridges that are absent at scheme level)." Names the gap, not an excuse. Acceptable scaffold.
    * **L548–L564 `projGm_isReduced`**: bare `by sorry` (after one comment line). Docstring: "Project-side scaffold sorry (Mathlib gap: the `Smooth → GeometricallyReduced` bridge is missing at scheme level…)." Two alternative routes outlined; the inline `-- Strategy:` comment also names the blocker. Acceptable scaffold.
    * **All three scaffold sorries are honest acknowledgments of confirmed Mathlib gaps.** None smuggle in excuses.
  - **Pre-existing instances unchanged**:
    * `projectiveLineBar_isProper` (L127–L170): full body, sound (per iter-166 verification).
    * `projectiveLineBar_geomIrred` (L175), `projectiveLineBar_smoothOfRelDim` (L182): bare `sorry`, plan-allowed scaffolds, unchanged.
    * `ProjectiveLineBar.{zeroPt,onePt,inftyPt}` (L268, L274, L280): point-soundness verified iter-166; signatures unchanged.
    * `ga_grpObj` (L335), `gm_grpObj` (L420): bare `sorry`, honest scaffold disclosures.
    * `gmScalingP1` (L457), `gmScalingP1_collapse_at_zero` (L472): bare `sorry`, honest scaffold disclosures. **Live consumer of `gmScalingP1` body**: `iotaGm_isDominant` in AVR L931 — recorded in the iter-167 helper docstring.
  - **Bad practice (minor) — L59**: `set_option linter.style.setOption false`. The file sets this lint suppressor but does not subsequently set any other `linter.*` option that would justify silencing the warning. Either an unused leftover from earlier scaffolding, or a guard against a future option set. Minor cleanup candidate; not regressive.
  - **L6 `import Mathlib`**: broad import, same precedent as `Genus.lean:6` and `Cotangent/ChartAlgebra.lean:6`. Compile-time cost only; not regressive.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three projection wrappers (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) over `jacobianWitness C` fields. Sorry-free locally; propagation comes from `nonempty_jacobianWitness` upstream. Unchanged.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. Honest definition. Sorry-free.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 1 flagged (unchanged from iter-166)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L237–L263 stale narrative inside `genusZeroWitness.isAlbaneseFor` (UNCHANGED from iter-166).** The 26-line block (three numbered "blockers" — IMPORT CYCLE, CHAR-`p` LOGICAL GAP, BASE-CHANGE FUNCTOR MISSING — labelled as gating `rigidity_over_kbar` use here) describes the *abandoned* route (a). Per project memory and the `AbelianVarietyRigidity.lean` route-(c) commitment landed iters 157–162, the replacement headline `rigidity_genus0_curve_to_grpScheme` (in upstream `AlgebraicJacobian/AbelianVarietyRigidity.lean`) now exists and is the natural keystone for this `key : f = toUnit C ≫ η[A]` sorry. **Re-flag** as iter-166 still applies: re-write this block to a one-liner pointing to `rigidity_genus0_curve_to_grpScheme` and noting the (acceptable) sorryAx propagation through the iter-167 helper-residuals + RR bridge.
  - L265 `key := by sorry`: load-bearing scaffold sorry. Once route (c) closes (`gmScalingP1` body + RR bridge), this is the wire-up site.
  - L303 `positiveGenusWitness := sorry`: positive-genus arm; off-critical-path per docstring.
  - L329–L334 `nonempty_jacobianWitness`: `by_cases` delegation to the two arms; no inline sorry.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen`: closed. "Hypothesis history" block (L44–L79) is honest design documentation. Unchanged.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 1 flagged (UNCHANGED from iter-166)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L9–L89 module-level narrative + `rigidity_over_kbar` docstring (UNCHANGED from iter-166).** Still treats the declaration as "the M2.a sub-step keystone … gated on the shared cotangent-vanishing Mathlib pile, iter-129+" — a closure plan abandoned since iter-156. Per project memory, the file is now the **fallback route (a) artifact**, superseded by `AbelianVarietyRigidity.rigidity_genus0_curve_to_grpScheme` (route (c), `[CharZero]` dropped). The whole module docstring + scaffold note + `Encoding choice` block describe an active closure plan that does not exist. **Re-flag** as iter-166: rewrite the module docstring to a 3-line fallback-artifact disclosure; the declaration body can stay `sorry` indefinitely without harming the project (it has no live consumer).

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `relativeDifferentialsPresheaf`, `kaehler_localization_subsingleton`, `kaehler_quotient_localization_iso`, `smooth_locally_free_omega`: all sorry-free, well-documented including the L116–L123 honest converse-direction counterexample disclosure. Unchanged.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 4 flagged (UNCHANGED from iter-166)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L297–L326 "Piece (i.b)" narrative (UNCHANGED from iter-166).** Names 3 sub-pieces and the declaration `mulRight_globalises_cotangent` — both of the latter two excised iter-145 (L552–L560, L624–L629 EXCISE markers). The narrative reads as if these declarations are still scheduled to land; should be trimmed to what survives (`shearMulRight` + `section_snd_eq_identity_struct` + `relativeDifferentialsPresheaf_restrict_along_identity_section` + `isIso_of_app_iso_module`).
  - **L465–L525 "iter-138 PARTIAL skeleton" block (UNCHANGED from iter-166).** 60 lines describing now-excised declarations' "three remaining concrete sub-goals" — severely outdated; describes work that is no longer relevant.
  - **L552–L560, L624–L629 "iter-145 EXCISE" stubs (UNCHANGED from iter-166).** Defensible as historical markers but bloat the file.
  - All other declarations sound: `cotangentSpaceAtIdentity`, `cotangentSpaceAtIdentity_eq_extendScalars`, `cotangentSpaceAtIdentity_finrank_eq`, `shearMulRight`, `section_snd_eq_identity_struct`, `relativeDifferentialsPresheaf_restrict_along_identity_section`, `isIso_of_app_iso_module`, `schemeHomRingCompatibility` — all closed, no sorry. Unchanged.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 1 flagged (UNCHANGED from iter-166)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L36–L79 module docstring (UNCHANGED from iter-166).** Describes the iter-144 chart-algebra pivot for piece (ii) of the M2.body-pile — pivot whose downstream consumer (rigidity_over_kbar in `RigidityKbar.lean`) is now off-path per the iter-156 route-(c) decision. The remaining declarations (`algebra_isPushout_of_affine_product`, `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`, `df_zero_factors_through_constant_on_chart`, `constants_integral_over_base_field`, `Scheme.Over.ext_of_diff_zero`) are still sound and structurally reusable; the docstring's "route (c) supersedes piece (ii)" framing is the iter-156 verdict and remains correct, but the chapter is silent on whether anything currently uses these declarations. Not actively misleading, but cosmetic stale narrative — same severity as iter-166.
  - L25 single-line comment: `-- iter-145 \`: True := sorry\` placeholders and is intentionally omitted` — backwards-looking historical note in an import block. Not an excuse-comment (no live `sorry` it gates).
  - All declarations have full bodies, no live sorries.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Single 5-line instance, closed honestly.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three declarations closed; documentation matches code.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations have full bodies, no sorries. Long iter-N narrative blocks are accurate.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations sound. Iter-034 Mathlib gap-fill `chgUnivLinearEquiv` plus the iter-016 → iter-026 MV LES infrastructure all closed.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations closed; iter-028 → iter-053 2-affine-cover MV + acyclicity carriers consistent.

## Must-fix-this-iter

**Iter-167 lane checks:**

**Concern (1): "5 iter-166 TODO excuse-comments dropped from `morphism_P1_to_grpScheme_const_aux`".** VERIFIED: `Grep` for `TODO|FIXME|XXX|HACK|temporary|placeholder|will fix later|stand-in` over `AbelianVarietyRigidity.lean` returns ZERO hits. The five iter-166 `-- TODO:` lines (L943/947/952/1028/1034) are gone. No new TODOs introduced by Lane A in `Genus0BaseObjects.lean` either. **PASS.**

**Concern (2): "3 new scaffold-sorry instances in `Genus0BaseObjects.lean` — docstring accounting honest vs. smuggled excuses".** VERIFIED per the per-file checklist above:

| Instance | Line | Docstring discloses Mathlib gap? |
|----------|------|----------------------------------|
| `projectiveLineBar_isReduced` | L506–L522 | YES — names `HomogeneousLocalization.Away`-is-domain bridge gap, lays out the 3-step closure strategy. |
| `gm_geomIrred` | L524–L532 | YES — names the missing scheme-level base-change-reduction bridge under `IsAlgClosed`. |
| `projGm_isReduced` | L548–L564 | YES — names the missing `Smooth → GeometricallyReduced` scheme-level bridge, outlines the chart-local alternative. |

All three docstrings give actual Mathlib-gap citations, not excuses. No smuggling. **PASS.**

**Concern (3): "outdated docstrings on `morphism_P1_to_grpScheme_const_aux` and `iotaGm_isDominant`".** VERIFIED: both docstrings accurately describe iter-167 state. The helper docstring at L908–L957 explicitly mentions the four `inferInstance` discharges via Lane A + the one remaining `iotaGm_isDominant` bridge. The bridge docstring at L924–L930 honestly names the gating on Lane A's `gmScalingP1` body. **PASS** (modulo the minor iter-166 → iter-167 status-tag bumps on L1090 and L1156 noted below as **major**).

**Concern (4): "stale narrative blocks across fallback-route files".** VERIFIED: all six iter-166 majors remain in place unchanged:

| File:lines | Iter-166 status | Iter-167 status |
|------------|-----------------|-----------------|
| `Jacobian.lean:237–263` | stale 3-blocker narrative | **UNCHANGED — still stale** |
| `RigidityKbar.lean:9–89` | module-level "M2.a keystone" narrative | **UNCHANGED — still stale** |
| `Cotangent/GrpObj.lean:297–326` | "Piece (i.b)" narrative naming excised decls | **UNCHANGED — still stale** |
| `Cotangent/GrpObj.lean:465–525` | "iter-138 PARTIAL skeleton" narrative | **UNCHANGED — still stale** |
| `Cotangent/GrpObj.lean:552–560, 624–629` | "iter-145 EXCISE" stubs | **UNCHANGED — defensible historical** |
| `Cotangent/ChartAlgebra.lean:36–79` | iter-144 pivot docstring (now off-path) | **UNCHANGED — cosmetic stale narrative** |

Re-flagged below in **Major**. None are load-bearing wrong-definition findings: the declarations themselves are sound; the comments are misleading-about-purpose-only.

**No must-fix-this-iter findings.**

## Major

- `AbelianVarietyRigidity.lean:1090` — `morphism_P1_to_grpScheme_const` status line opens "**Status (iter-166):** body landed. Carries propagated `sorryAx` via the helper's residuals (three product-instance Mathlib bridges + dominance of the canonical `Gm → ℙ¹` map)." After this iter's refactor, the residuals are **not** three product-instance bridges + dominance — they are *Lane A's `gmScalingP1`/`gmScalingP1_collapse_at_zero` + dominance bridge*, since the three product-instance bridges were exported to Lane A and resolve by `inferInstance` here. The iter tag should be bumped to iter-167 and the residual-list updated.
- `AbelianVarietyRigidity.lean:1156` — `rigidity_genus0_curve_to_grpScheme` status line still says "**Status (iter-166):** body landed." Content (RR bridge + helper residuals) is still correct, but the iter tag should be bumped to iter-167 for consistency.
- `Jacobian.lean:237–263` (re-flag from iter-166) — 26-line stale narrative inside `genusZeroWitness.isAlbaneseFor` listing three "blockers" (IMPORT CYCLE, CHAR-`p` LOGICAL GAP, BASE-CHANGE FUNCTOR MISSING) for the abandoned route-(a) `rigidity_over_kbar` wire-up. Route (c) (`AbelianVarietyRigidity.rigidity_genus0_curve_to_grpScheme`) lives upstream of `Jacobian.lean` now and resolves all three blockers (no import cycle, no `[CharZero]`, no base-change descent). Rewrite or shorten to a one-liner pointing to `rigidity_genus0_curve_to_grpScheme` (still sorryAx-propagating, but now via the well-defined helper chain, not the dead route).
- `RigidityKbar.lean:9–89` (re-flag from iter-166) — module-level narrative + `rigidity_over_kbar` docstring still treat this as the "M2.a sub-step keystone" being actively pursued; project demoted to fallback artifact iter-156 onwards.
- `Cotangent/GrpObj.lean:297–326` (re-flag from iter-166) — multi-paragraph "Piece (i.b)" narrative naming declarations excised iter-145; misleading about the file's current shape.
- `Cotangent/GrpObj.lean:465–525` (re-flag from iter-166) — 60-line "iter-138 PARTIAL skeleton" describing now-excised declarations' planned-sub-goals; should be removed.
- `Cotangent/GrpObj.lean:552–560, 624–629` (re-flag from iter-166) — two "iter-145 EXCISE" stubs; defensible as historical markers but bloat the file.

## Minor

- `Genus0BaseObjects.lean:59` — `set_option linter.style.setOption false` without a subsequent `linter.*` option being set. Either unused leftover or guard against a future change. Cleanup candidate; not regressive.
- `Genus0BaseObjects.lean:6` — `import Mathlib` (broad). Same precedent as `Genus.lean:6`, `Cotangent/ChartAlgebra.lean:6`. Compile-time cost only.
- `Cotangent/ChartAlgebra.lean:36–79` (re-flag from iter-166) — module docstring describes iter-144 chart-algebra pivot; the route is now off-path post route-(c), but the surviving declarations are sound and reusable. Cosmetic stale narrative.

## Excuse-comments (always called out separately)

**ZERO excuse-comments in the iter-167 surface.** The 5 iter-166 TODOs in `AbelianVarietyRigidity.lean` (L943/947/952/1028/1034 of iter-166) have all been removed by the iter-167 helper refactor. No new excuse-comments were introduced by Lane A's three scaffold-sorry instances — each one's docstring names the actual Mathlib gap rather than offering an excuse.

The 4 `Cotangent/GrpObj.lean` stale narrative blocks and 1 `RigidityKbar.lean` stale narrative + 1 `Jacobian.lean` stale narrative + 1 `Cotangent/ChartAlgebra.lean` cosmetic stale narrative are **misleading-purpose narratives**, not excuse-comments; the underlying declarations are sound (or honestly-scaffolded), so they land under **Major** rather than excuse-comments.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 7 (2 iter-167 status-tag bumps on the AVR consumer docstrings + 5 re-flagged stale narrative blocks from iter-166 — none changed this iter)
- **minor**: 3 (1 lint-suppressor cleanup + 2 re-flagged minors from iter-166)
- **excuse-comments**: 0 (iter-166's 5 TODOs were successfully swept this iter; no new ones introduced)

Overall verdict: **Iter-167 lane edits are sound — the iter-166 TODO sweep landed cleanly (zero residual excuse-comments), the 3 new Lane A scaffold-sorry instances all carry honest Mathlib-gap docstrings, and the new `iotaGm_isDominant` named bridge cleanly hoists the dominance obligation out of `morphism_P1_to_grpScheme_const_aux` (whose body is now `sorry`-free). The only iter-167-specific majors are two status-tag bumps on AVR consumer docstrings (iter-166 → iter-167); the remaining 5 majors are stale narrative blocks re-flagged from iter-166 with no change this iter.**
