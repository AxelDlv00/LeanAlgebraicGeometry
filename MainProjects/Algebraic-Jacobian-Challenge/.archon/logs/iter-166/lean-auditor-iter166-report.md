# Lean Audit Report

## Slug

iter166

## Iteration

166

## Scope

- files audited: 16 (all project `.lean` under `AlgebraicJacobian/` plus root `AlgebraicJacobian.lean`)
- files skipped (per directive): 0

Project files (in audit order):

1. `AlgebraicJacobian.lean`
2. `AlgebraicJacobian/AbelianVarietyRigidity.lean` *(Lane 1 modified iter-166)*
3. `AlgebraicJacobian/Genus0BaseObjects.lean` *(Lane 2 modified iter-166)*
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

`.archon/logs/**`, `.archon/lanes/**`, `.archon/multilane/**`, and `.archon/snapshots/**` snapshots are loop state, not project source — excluded by the directive's "absolute paths" scope.

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import manifest, all 13 sub-modules listed. Order is consistent with the upstream-of-`Jacobian` placement of `Genus0BaseObjects` and `AbelianVarietyRigidity`.

### AlgebraicJacobian/AbelianVarietyRigidity.lean *(Lane 1, modified iter-166)*
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: 5 flagged (the 5 `TODO` comments attached to the new helper's sorries — see Must-fix discussion below)
- **notes**:
  - L77, L93, L115, L156, L203, L262, L431, L507, L679, L765, L814, L884: chain `rigidity_snd_lift` → `snd_left_isClosedMap` → `morphism_eq_of_eqAt_closedPoints` → `eq_comp_of_isAffine_of_properIntegral` → `isIntegral_of_retract` → `rigidity_eqAt_closedPoint_of_proper_into_affine` → `rigidity_eqOn_saturated_open_to_affine` → `rigidity_eqOn_dense_open` → `rigidity_core` → `rigidity_lemma` → `hom_additive_decomp_of_rigidity` → `av_regularMap_isHom_of_zero` all carry `sorry`-free bodies (axiom-clean per iter-162); the load-bearing `_hf` collapse hypothesis is threaded through (the iter-157 laundering footgun is closed).
  - L931 `morphism_P1_to_grpScheme_const_aux` (NEW iter-166, private helper): 5 internal sorries at L944, L949, L953, L1029, L1037. **All five are honest open math obligations** (see Concern (1) verification below). The proof structure threads the load-bearing hypothesis `hf0 : zeroPt ≫ f = η[A]` through `gmScalingP1_collapse_at_zero` → Cor 1.5 → density via `ext_of_isDominant_of_isSeparated'`. NOT laundering.
  - L1089 `morphism_P1_to_grpScheme_const`: body has no inline sorries; it invokes the helper, so `sorryAx` is propagated honestly via the helper's residuals.
  - L1131 `genusZero_curve_iso_P1`: full body `sorry` at L1137 — pinned to RR bridge, plan-allowed.
  - L1156 `rigidity_genus0_curve_to_grpScheme`: body is sorry-free; depends on `genusZero_curve_iso_P1` + `morphism_P1_to_grpScheme_const`, both of which propagate honest `sorryAx`.
  - L943, L947, L952, L1028, L1034: 5 inline `-- TODO:` comments accompanying the internal sorries. These name the actual obligation; **they admit the code is incomplete and trigger the excuse-comment rule**, but the corresponding `sorry`s give the kernel the same signal. Treated as a soft major finding (see Major below), not a must-fix, because the docstring (L924-930) already declares them and the obligations are themselves enumerated as legitimate scaffold sorries by the directive.
  - L1024-1029 inline comment "Local sorry, on the same propagation footing as the upstream Lane 2 scaffold sorries.": honest disclosure; acceptable.
  - The new `ProjectiveLineBar.zeroPt`/`onePt`/`inftyPt` references in `morphism_P1_to_grpScheme_const_aux` consume the L268-282 declarations from `Genus0BaseObjects.lean` — see soundness verification under that file's checklist.

### AlgebraicJacobian/Genus0BaseObjects.lean *(Lane 2, modified iter-166)*
- **outdated comments**: none
- **suspect definitions**: 1 flagged (see notes)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L94, L108: `ProjectiveLineBarScheme` / `ProjectiveLineBar` — concrete `Proj (MvPolynomial.homogeneousSubmodule (Fin 2) kbar)` realisation; clean.
  - L127-170 `projectiveLineBar_isProper`: full body, no sorry. The properness chain `Proj.toSpecZero ∘ Spec.map (algebraMap k̄ ↥(𝒜 0))` is closed by deriving the iso of `Spec`s from bijectivity of `algebraMap k̄ ↥(𝒜 0)` and properness of `Proj.toSpecZero`. The `MvPolynomial.homogeneousComponent_of_mem` argument is delicate but factually correct (the degree-0 piece of `k[X₀, X₁]` is `C(k)`).
  - L175 `projectiveLineBar_geomIrred`: scaffold `sorry`. Plan-allowed.
  - L182 `projectiveLineBar_smoothOfRelDim`: scaffold `sorry`. Plan-allowed.
  - **Soundness of `ProjectiveLineBar.{zeroPt, onePt, inftyPt}` (Concern (2) verification)**:
    * L268 `zeroPt`: `pointOfVec kbar (fun i => if i = 0 then 0 else 1) 1 (by simp)`. Evaluation `X₀ ↦ 0, X₁ ↦ 1`; unit-coordinate `i = 1`, `v 1 = 1` is a unit; gives `[0:1]` ≡ `0 ∈ ℙ¹`. **CORRECT.**
    * L274 `onePt`: `pointOfVec kbar (fun _ => 1) 0 (by simp)`. Evaluation `X₀ ↦ 1, X₁ ↦ 1`; unit-coordinate `i = 0`, `v 0 = 1` is a unit; gives `[1:1]` ≡ `1 ∈ ℙ¹`. **CORRECT.**
    * L280 `inftyPt`: `pointOfVec kbar (fun i => if i = 0 then 1 else 0) 0 (by simp)`. Evaluation `X₀ ↦ 1, X₁ ↦ 0`; unit-coordinate `i = 0`, `v 0 = 1` is a unit; gives `[1:0]` ≡ `∞ ∈ ℙ¹`. **CORRECT.**
    * `pointOfVec` (L234) sets up the `Proj.fromOfGlobalSections` via the irrelevant-ideal-maps-to-top hypothesis (L207, `irrelevant_map_eq_top`); the proof of the irrelevant-ideal condition factors through `IsUnit (v i)` of one coordinate — algebraically sufficient (any maximal ideal not containing `X_i` defines a point on the standard open `D₊(X_i)`).
  - L289 `GaScheme`, L300 `Ga`: clean concrete `AffineSpace (Fin 1) (Spec k̄)` encoding.
  - L335 `ga_grpObj`: bare `:= sorry`. Docstring discloses scaffold status; off-path for iter-166 (uses `W = Gm`).
  - L340-343 `ga_smooth`: invokes `ga_grpObj` ⟹ propagates `sorryAx` correctly. Not laundering.
  - L355 `GmScheme`, L365 `Gm`: clean concrete `Spec (Localization.Away X)` encoding.
  - L377-381 `gm_locallyOfFinitePresentation`: full body, no sorry.
  - L400 `gm_grpObj`: bare `:= sorry`. **This is the LIVE consumer** (the genus-0 path uses `W = Gm`); the docstring discloses this honestly. Propagates `sorryAx` to `morphism_P1_to_grpScheme_const_aux` consumers.
  - L411 `Gm.onePt := η[Gm kbar]`: defined as the group-object unit. Sound (and only typechecks once `gm_grpObj` resolves — currently via `sorryAx`).
  - L437-439 `gmScalingP1`: bare `:= sorry` def. The signature alone is the iter-165 land; the chartwise glue body is iter-166+ work per docstring.
  - L452-456 `gmScalingP1_collapse_at_zero`: full statement, body `sorry`. Plan-allowed scaffold.
  - File uses `import Mathlib` (broad) — same convention as the cotangent files in the project.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All three declarations (`ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`) project directly from `jacobianWitness C` fields — uniform pass-through; sorry-free locally (propagation comes from `nonempty_jacobianWitness` upstream).

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`. Honest definition matching the standard `dim_k H¹(C, O_C)`. Sorry-free.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 1 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L237-263 carry a long historical narrative inside `genusZeroWitness` enumerating 3 "blockers" (import cycle, char-p logical gap, base-change functor missing) for the `rigidity_over_kbar` route. **Iter-156 declared route (a) DEAD and committed to route (c)** (the `AbelianVarietyRigidity.lean` stack just landed in iter-166). The narrative is therefore **stale**: the import-cycle blocker no longer applies because the new headline `rigidity_genus0_curve_to_grpScheme` lives in a file that is upstream of `Jacobian.lean` (no cycle) — but `genusZeroWitness` still hard-imports nothing from `AbelianVarietyRigidity.lean` and still keeps the `sorry` body at L265 with that old narrative attached. **The narrative is misleading**, since the project has actively built the replacement path; it should be either rewritten or replaced with a one-liner pointing to `rigidity_genus0_curve_to_grpScheme`.
  - L265 `key : f = toUnit C ≫ η[A] := by sorry`: load-bearing scaffold sorry pending the route-(c) consumer wire-up.
  - L303 `positiveGenusWitness := sorry`: positive-genus arm; off-critical-path per docstring.
  - L329-334 `nonempty_jacobianWitness`: well-structured `by_cases` delegation to the two arms; no inline sorry.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen`: closed; the "Hypothesis history" block (L44-79) is honest design documentation, not stale narrative.

### AlgebraicJacobian/RigidityKbar.lean
- **outdated comments**: 1 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L75-88 `rigidity_over_kbar := sorry`. The docstring still names this as the "M2.a sub-step" keystone — but per iter-156 strategy decision + iter-164 STRATEGY refresh, this declaration is now the **fallback route (a) artifact**, superseded by `rigidity_genus0_curve_to_grpScheme` in `AbelianVarietyRigidity.lean`. The file CLAUDE.md context confirms it "remains in tree as the fallback". The L9-29 module docstring + the L20-29 "iter-126 scaffold" + L31-45 "Encoding choice" blocks are stale: they describe a closure plan ("gated on the shared cotangent-vanishing Mathlib pile, iter-129+") that the project has **abandoned**. The declaration itself is sound; the surrounding narrative is misleading.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `relativeDifferentialsPresheaf`, `kaehler_localization_subsingleton`, `kaehler_quotient_localization_iso`, `smooth_locally_free_omega`: all sorry-free, well-documented (including the L116-123 honest disclosure of the converse-direction counterexample).

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 2 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L162-201 `cotangentSpaceAtIdentity`: sorry-free body; depends on `smooth_locally_free_omega`; sound.
  - L211-232 `cotangentSpaceAtIdentity_eq_extendScalars`: closed.
  - L257-295 `cotangentSpaceAtIdentity_finrank_eq`: closed (rank = `n`).
  - L297-326 large narrative block "Piece (i.b)": describes 3 sub-pieces, names `relativeDifferentialsPresheaf_basechange_along_proj_two`, `mulRight_globalises_cotangent`. **Stale**: L552-560 and L624-629 EXCISE comments record that both `basechange_along_proj_two_inv*` (4 declarations) and `mulRight_globalises_cotangent` were excised in iter-145. The L298-326 narrative remains as if those declarations were still scheduled to land — it should be trimmed to just what survives (`shearMulRight` + `section_snd_eq_identity_struct` + `relativeDifferentialsPresheaf_restrict_along_identity_section` + `isIso_of_app_iso_module`).
  - L465-525 large stale narrative block "iter-138 PARTIAL skeleton": describes specific iter-137/138 sub-goals (1)/(2)/(3) for declarations that were excised iter-145. **Severely outdated**.
  - L552-560 and L624-629 "EXCISE" stub comments record dead-code removals — accurate historical markers but bloat the file.
  - `shearMulRight` (L350-384), `section_snd_eq_identity_struct` (L458-463), `relativeDifferentialsPresheaf_restrict_along_identity_section` (L579-622), `isIso_of_app_iso_module` (L544-550), `schemeHomRingCompatibility` (L424-426): all sorry-free, sound.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean
- **outdated comments**: 1 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations have full bodies, no sorries.
  - L36-79 module docstring describes the iter-144 chart-algebra pivot; route (c) supersedes piece (ii) of the M2.body-pile, making the chart-algebra route off-path. The remaining declarations are still sound and reusable (`algebra_isPushout_of_affine_product`, `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`, `df_zero_factors_through_constant_on_chart`, `constants_integral_over_base_field`, `Scheme.Over.ext_of_diff_zero`).
  - L417-453 `ext_of_diff_zero` is a thin renaming wrapper around `Scheme.Over.ext_of_eqOnOpen`; the docstring describes the iter-145 chart-algebra envelope which is now off-path. Not actively misleading but cosmetic stale narrative.

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
  - All declarations have full bodies, no sorries. Heavy iter-NNN narrative but accurate (mirrors the genuine multi-iter assembly history).
  - L463-486 historical note on the abandoned per-affine-open `IsHModuleHomFinite` variant is a useful and honest disclosure.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations have full bodies; iter-016 → iter-026 MV LES infrastructure plus iter-034 Mathlib gap-fill `chgUnivLinearEquiv` all sound.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All declarations closed; iter-028 → iter-053 2-affine cover MV + acyclicity carriers consistent.

## Must-fix-this-iter

**Critical re-check of directive Concern (1): "the 5 internal sorries propagate `sorryAx` into the consumer theorems".**

The directive asks to confirm the 5 sorries in `morphism_P1_to_grpScheme_const_aux` (L944/949/953/1029/1037) are *honest open math obligations* and not *propositions that should be already discharged elsewhere*. Per-sorry verification:

| Line | Obligation | Honest? |
|------|------------|---------|
| L944 | `GeometricallyIrreducible ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom` | YES — needs product-of-geom-irred Mathlib bridge over an alg-closed base; not packaged for these specific factors. |
| L949 | `LocallyOfFiniteType ((ProjectiveLineBar kbar) ⊗ Gm kbar).hom` | YES — needs LOFT-of-product; `ℙ¹` is LOFT via `Proj` of FT ring, `Gm` is LFP hence LOFT, product preserves LOFT. Mathlib bridge work. |
| L953 | `IsReduced ((ProjectiveLineBar kbar) ⊗ Gm kbar).left` | YES — needs reduced + perfect base ⟹ product reduced. Mathlib bridge work. |
| L1029 | `IsReduced (ProjectiveLineBar kbar).left` | YES — needs `Proj`-of-MvPolynomial integrality (Mathlib does not package this for the standard ℕ-grading). |
| L1037 | `IsDominant iotaGm.left` (for `iotaGm := lift (toUnit Gm ≫ onePt) (𝟙 Gm) ≫ gmScalingP1`) | YES — depends on the concrete `gmScalingP1` body (L437 sorry in Lane 2). Cannot be discharged before Lane 2 closes. |

All 5 are **legitimate sub-builds**, not propositions discharged elsewhere. No must-fix from Concern (1).

**Critical re-check of directive Concern (2): point-soundness of `zeroPt`/`onePt`/`inftyPt`.**

Verified above under the `Genus0BaseObjects.lean` checklist: all three vector/unit-index pairings are consistent with the claimed `[X₀:X₁]` projective coordinates. No must-fix.

**Critical re-check of directive Concern (3): iter-157-style laundering.**

Verified: every theorem with a sorry-free body in `AbelianVarietyRigidity.lean` either:
- threads the load-bearing hypothesis (`_hf`/`hf0`/`hα`/`_hgenus`) through every consumer call, OR
- propagates `sorryAx` via an honest helper sorry that **does** name the obligation (no signature stripping).

The `morphism_P1_to_grpScheme_const_aux` helper actually consumes `hf0 : zeroPt ≫ f = η[A]` substantively (it's passed to `hcorhyp` via `hcollapse`, fed to Cor 1.5 at L977). The downstream `morphism_P1_to_grpScheme_const` (L1089) consumes `f` only, and constructs its own pointed-form by translating in the group — sound shape (translate → apply helper → un-translate). The headline `rigidity_genus0_curve_to_grpScheme` (L1156) honestly uses `_hf : p ≫ f = η[A]`. **No laundering.**

**Critical re-check of directive Concern (4): stale narrative blocks across the project.**

Iter-164's flagged 5 stale narratives (`Cotangent/GrpObj.lean`, `Cotangent/ChartAlgebra.lean`, `RigidityKbar.lean`) **are still in place**:

| File:lines | Narrative status |
|------------|------------------|
| `Jacobian.lean:237-263` | Stale; route (a) abandoned but narrative still names the 3 blockers as if route (a) were active. |
| `RigidityKbar.lean:9-29, 31-45, 70-74` | Stale; file is now the fallback artifact but module docstring + scaffold note still describe an active closure plan. |
| `Cotangent/GrpObj.lean:297-326` | Stale; "Piece (i.b)" narrative names declarations excised iter-145. |
| `Cotangent/GrpObj.lean:465-525` | Severely stale "iter-138 PARTIAL skeleton" describing now-excised declarations. |
| `Cotangent/ChartAlgebra.lean:36-79` | Mildly stale; file's route is off-path post route-(c), but per-declaration documentation is accurate. |

None of these are *load-bearing wrong-definition* findings: the declarations themselves are sound, the comments are misleading-about-purpose-only. Listed in **Major** below, not Must-fix.

**No must-fix-this-iter findings.**

## Major

- `AbelianVarietyRigidity.lean:943,947,952,1028,1034` — 5 inline `-- TODO:` comments accompanying the L944/949/953/1029/1037 sorries. Strictly excuse-comments per the auditor rubric (they admit "we have not closed this; please close it later"). Mitigation: the kernel-level `sorry` already raises the same alarm at compile time, and the docstring at L924-930 explicitly enumerates them as known residuals. Suggested cleanup: drop the `-- TODO:` prose lines and let the docstring carry the disclosure.
- `Jacobian.lean:237-263` — 26-line stale narrative inside `genusZeroWitness` describing three route-(a) blockers that the iter-156 strategy decision rendered moot (the project has built the replacement route in `AbelianVarietyRigidity.lean`). Should be rewritten or shortened to one line pointing to `rigidity_genus0_curve_to_grpScheme`.
- `RigidityKbar.lean:9-89` — Module-level narrative still treats `rigidity_over_kbar` as the "M2.a sub-step keystone" being actively pursued; project has demoted it to a fallback artifact iter-156 onwards.
- `Cotangent/GrpObj.lean:297-326` — Multi-paragraph "Piece (i.b)" narrative naming declarations excised iter-145; misleading about the file's current shape.
- `Cotangent/GrpObj.lean:465-525` — 60-line "iter-138 PARTIAL skeleton" describing now-excised declarations' planned-sub-goals; should be removed.
- `Cotangent/GrpObj.lean:552-560,624-629` — Two "iter-145 EXCISE" stub comments; defensible as historical markers but bloat the file.

## Minor

- `Genus0BaseObjects.lean:6` — `import Mathlib` (broad) for a file that needs only `AlgebraicGeometry.Proj.*`, `AlgebraicGeometry.AffineSpace.*`, `RingTheory.Localization.Away`, `RingTheory.MvPolynomial.*`. Matches `Cotangent/ChartAlgebra.lean:6` and `Genus.lean:6` precedent; not regressive. Compile-time cost only.
- `AbelianVarietyRigidity.lean:1024-1029` — explanatory inline comment "Local sorry, on the same propagation footing as the upstream Lane 2 scaffold sorries." is acceptable disclosure; could be tightened to a single line.
- `Cotangent/ChartAlgebra.lean:36-79` — module docstring describes the iter-144 chart-algebra pivot; the route is now off-path post route-(c), but the surviving declarations (`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` et al.) are sound and reusable.

## Excuse-comments (always called out separately)

Five `-- TODO:` comments inside the new private helper `morphism_P1_to_grpScheme_const_aux`:

- `AlgebraicJacobian/AbelianVarietyRigidity.lean:943`: `-- TODO: derive from \`projectiveLineBar_geomIrred\` + Gm geom irred + alg-closed base.` (attached to product-`GeometricallyIrreducible` sorry at L944). Severity: **major** — the corresponding sorry already raises the alarm; the docstring at L924-930 already discloses; the TODO is a redundant excuse.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:947-948`: `-- TODO: ℙ¹ is LOFT (Proj of finite-type ring) and Gm is locally of finite presentation (hence LOFT); product is LOFT.` (attached to LOFT-of-product sorry at L949). Severity: **major** — same.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:952`: `-- TODO: both factors reduced + perfect (alg-closed) base ⟹ product reduced.` (attached to reduced-product sorry at L953). Severity: **major** — same.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:1028`: `-- TODO: derive from \`Proj\` integrality (\`projectiveLineBar_geomIrred\` over reduced base).` (attached to `IsReduced ProjectiveLineBar.left` sorry at L1029). Severity: **major**.
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:1034-1036`: `-- TODO (Lane 2 follow-up): once \`gmScalingP1\` is the concrete chartwise glue, ι becomes the standard open immersion \`Gm = Spec k̄[t, t⁻¹] ↪ ℙ¹\` (sending λ to [λ : 1]), which is dense in the irreducible ℙ¹.` (attached to `IsDominant iotaGm.left` sorry at L1037). Severity: **major**.

These TODOs are NOT the iter-157 laundering pattern (the helper does consume `hf0` substantively). They duplicate the kernel-level alarm raised by the adjacent `sorry`s and duplicate the helper's docstring disclosure (L924-930). Recommended: delete the `-- TODO:` lines; let the `sorry`s + docstring carry the alarm. The directive expressly authorised these sorries as "honest open math obligations", so the must-fix rubric does not fire — they land at **major**.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 11 (5 TODO/excuse-comments + 6 stale narrative blocks)
- **minor**: 3
- **excuse-comments**: 5 (all the L943/947/952/1028/1034 TODOs; also counted under major above)

Overall verdict: **Iter-166 modifications are sound — 5 honest helper sorries + correctly propagated `sorryAx` consumers; point-soundness verified for the new `zeroPt/onePt/inftyPt` defs; no laundering. The main hygiene debt is stale module/declaration-level narrative inherited from iter-156 (route-(a) demotion) and iter-145 (`Cotangent/GrpObj` excises), which iter-164 had already flagged and which remains carried over.**
