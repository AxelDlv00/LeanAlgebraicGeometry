# Blueprint Review Report

## Slug
iter139

## Iteration
139

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex` / `lem:GrpObj_omega_basechange_proj` (proof block, L489–L639): the iter-138 prover lane decomposed the lemma into three concrete sub-sorries (d_app, d_map, IsIso), but the blueprint proof prose still describes the closure at the strategic Routes (a)/(b) level only. The two derivation sub-goals (d_app — algebraic-coherence factorisation through `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom`; d_map — cross-open naturality chase of `Scheme.Hom.c.naturality` + `KaehlerDifferential.map_d`) are spelled out only in the Lean docstring at `Cotangent/GrpObj.lean:489–501`. A prover hitting the iter-139 lane on the d_app + d_map sub-sorries has no blueprint-side recipe to consult; iter-138's NOTE block (L492–L631) documents Routes (a) vs (b) at the iso-construction level, not the per-sub-goal derivation closure.
- `RigidityKbar.tex` / `AlgebraicJacobian_Cotangent_GrpObj.tex`: the iter-138 Lean helpers `AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_derivation` (the pointwise inverse-direction derivation) and `AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv` (the inverse map) ship in `Cotangent/GrpObj.lean:547–610` as first-class top-level declarations carrying load-bearing project content (the three iter-139 sub-sorries all live inside these two helpers), but neither chapter pins them with a dedicated `\lean{...}` block. Suggested labels: `lem:GrpObj_omega_basechange_proj_inv_derivation` and `lem:GrpObj_omega_basechange_proj_inv`. The chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` § "Lean declarations in this file" enumerates 8 declarations but is missing these 2 (plus the private helper `section_snd_eq_identity_struct`, which is private and need not be pinned).

### Proofs lacking detail

- `RigidityKbar.tex` / `lem:GrpObj_omega_basechange_proj` proof: the chart-by-chart prose at L632–L638 is preserved as informal motivation only (per the iter-137 NOTE block at L492–L500); the live Route (b) inverse-direction-via-adjunction-transpose is then described at L577–L620, but stops at "constructing the derivation $D$" without specifying the d_app or d_map laws. The two specific iter-139 closure recipes given in the Lean docstring at `Cotangent/GrpObj.lean:491–501` are NOT mirrored in the blueprint prose:
  - d_app: factorisation of `(ψ.app X) ∘ (φ_G.app X)` through the source-presheaf morphism `φ_LHS.app (snd⁻¹ X)`, mediated by the over-`Spec k` commutativity `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom` of the product projections.
  - d_map: pointwise-derivation naturality across opens, chasing `Scheme.Hom.c.naturality` of `(snd G G).left` against `KaehlerDifferential.map_d`.
- `RigidityKbar.tex` / `lem:GrpObj_omega_basechange_proj` proof: the third concrete sorry (IsIso of `basechange_along_proj_two_inv`) is documented at the Lean docstring level (Route (a) chart-unfolding-helper vs Route (b'2) local-iso check on `PresheafOfModules.toPresheaf`-reflecting-isos), but the blueprint prose only carries Route (a) in detail (L530–L575); Route (b'2) is not present at the blueprint level. The iter-139 mathlib-analogist consult on the two IsIso closure routes therefore has thin blueprint scaffolding to cross-reference for Route (b'2).

### Lean difficulty quality

- `RigidityKbar.tex` / `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}`: the stated signature in the iter-134 stub (L443–L468) is correct vs. the Lean target, but the named-helper structure inside (the inverse map + IsIso path) has drifted into the Lean tree without a blueprint pin. A prover newly assigned to the d_app or d_map sub-sorry would have to read the Lean docstring to learn that the work lives inside `basechange_along_proj_two_inv_derivation`, not inside the main declaration — a fragile attractor.

### Multi-route coverage

This directive does not enumerate Routes for the reviewer. The strategic routes implicit in this iter are the two iter-138 closure paths for the IsIso sorry (Route (a) chart-unfolding-helper vs Route (b'2) local-iso check); see "Proofs lacking detail" above for the partial blueprint coverage.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All three named declarations (`def:ofCurve`, `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`) match the Lean targets and carry `\leanok`. Classical-description remarks are well-scoped to remarks only.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Pointer chapter; lists the 8 Lean declarations in `Cotangent/GrpObj.lean`, but the iter-138 helpers `basechange_along_proj_two_inv_derivation` and `basechange_along_proj_two_inv` (both noncomputable `def`s at top level, not private) are MISSING from the enumeration. Confirms the iter-138 lean-vs-blueprint-checker recommendation: a blueprint-writer should add bullets for them this iter, with dedicated `\lean{...}` blocks home-chapter'd in `RigidityKbar.tex`.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All declared targets present and carry `\leanok`. No drift visible. Long (947 lines) but internally consistent.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:relative_kaehler_presheaf`, `lem:relative_kaehler_presheaf_obj`, `thm:smooth_locally_free_omega`, `lem:kaehler_localization_subsingleton`, `lem:kaehler_quotient_localization_iso` all present and `\leanok`. M1 excise documented cleanly (§ bridge / § converse-out-of-scope). No must-fix.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `def:genusZeroWitness` carries `\notready` consistent with the gating on rigidity (L412 "Earliest realistic body-closure iteration: iter-138+"); current iter is 139, status remains accurate (iter-139 is the iter staging the iter-138 partial in). `def:positiveGenusWitness` carries `\notready` consistent with M3 off-critical-path.
  - The iter-135 body-restructure of `thm:nonempty_jacobianWitness` (case-split into the two arms) is documented at L376–L377 and L437–L439.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:GrpObj_eq_of_eqOnOpen` matches the iter-125-refactored Lean target `AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen`; proof sketch and Mathlib-ingredient list are adequate for a prover.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - `lem:GrpObj_omega_basechange_proj` (proof block, L489–L639): does NOT document the d_app + d_map sub-goal closure paths that iter-139 needs to dispatch on. The iter-138 NOTE block at L492–L500 says "Future iter-138+ provers SHOULD consult both the blueprint prose AND the Lean docstring before attempting closure: the docstring is more recent than the surrounding chart-by-chart prose"; the Lean docstring at `Cotangent/GrpObj.lean:489–501` carries the specific recipes (d_app = factorisation through `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom`; d_map = chase of `Scheme.Hom.c.naturality` + `KaehlerDifferential.map_d`). Blueprint prose for the lemma should be expanded to mirror these recipes so the iter-139 prover does not need to cross-read the Lean source for them.
  - `lem:GrpObj_omega_basechange_proj` (proof block, L491): carries `\leanok` while the corresponding Lean target `relativeDifferentialsPresheaf_basechange_along_proj_two` has `letI : IsIso ... := sorry` at `Cotangent/GrpObj.lean:624`. This is a probable `sync_leanok` mis-mark on a `letI ... := sorry`-bearing body (the outer expression is `(asIso (… inv …)).symm`, structurally `noncomputable def` but with the IsIso side-condition sorry-bodied). Flagging per directive instruction; not for review-agent to fix; the iter-139 plan-agent has been instructed to consult `doctor` on `sync_leanok`'s handling of `letI ... := sorry`.
  - The Lean helpers `AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_derivation` (`GrpObj.lean:547`) and `AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv` (`GrpObj.lean:596`) are first-class top-level `noncomputable def`s that carry the load-bearing project content for the iter-139 prover lane (d_app, d_map sit inside the former; the inverse map of the iso is the latter) but are NOT pinned anywhere in the blueprint with `\lean{...}` blocks. Confirms the iter-138 lean-vs-blueprint-checker MINOR 2 recommendation: add `lem:GrpObj_omega_basechange_proj_inv_derivation` and `lem:GrpObj_omega_basechange_proj_inv` (or analogously named) sub-lemmas in `RigidityKbar.tex` between `lem:GrpObj_omega_basechange_proj` (L442) and `lem:GrpObj_omega_restrict_to_identity_section` (L642), then update the pointer-chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` enumeration accordingly.
  - Route (b'2) (local-iso check on a `PresheafOfModules` generator via `PresheafOfModules.toPresheaf` reflecting isos + `NatTrans.isIso_iff_isIso_app`) is named in the Lean docstring at `Cotangent/GrpObj.lean:506–510` but does NOT appear in the blueprint prose; only Route (a) is documented in the blueprint (L530–L575). The iter-139 mathlib-analogist consult on the two IsIso routes will have blueprint scaffolding for only Route (a), not for Route (b'2). Recommend the blueprint-writer dispatch also extend the lemma's NOTE block with a Route (b'2) sub-paragraph.
  - All declared targets are present in Lean and signatures match: `thm:rigidity_over_kbar`, `lem:GrpObj_cotangentSpace`, `lem:GrpObj_cotangentSpace_extendScalars_witness`, `lem:GrpObj_cotangent_bridge` (notready, vestigial), `lem:GrpObj_lieAlgebra_finrank`, `lem:GrpObj_shearMulRight`, `lem:GrpObj_mulRight_globalises` (notready), `def:GrpObj_schemeHomRingCompatibility`, `lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_omega_restrict_to_identity_section`, `lem:GrpObj_omega_free` (notready), `lem:GrpObj_omega_rank_eq_dim` (notready). No `\lean{...}` signature drift detected.

## Cross-chapter notes

- The two iter-138 helpers (`basechange_along_proj_two_inv_derivation`, `basechange_along_proj_two_inv`) are referenced in `AlgebraicJacobian_Cotangent_GrpObj.tex`'s scope (it claims to enumerate every declaration in `Cotangent/GrpObj.lean`) but absent from both `AlgebraicJacobian_Cotangent_GrpObj.tex` (the per-file pointer chapter) and `RigidityKbar.tex` (the mathematics-bearing chapter). They should be added to BOTH chapters in one blueprint-writer dispatch — the `\lean{...}` block lives in `RigidityKbar.tex` (where the mathematical content sits), the cross-reference bullet lives in `AlgebraicJacobian_Cotangent_GrpObj.tex`.
- `RigidityKbar.tex` § "Iter-127 over-k commitment" and the related framing remarks in `Rigidity.tex`, `Jacobian.tex` § C.2 are mutually consistent. No cross-chapter contradictions found.
- No broken `\uses{}` / `\ref{}` / `\cref{}` targets across the 11-chapter blueprint (programmatic check passed; all referenced labels exist).

## Strategy-modifying findings (if any)

None this iter. The Route (b'2) local-iso-check alternative for the IsIso sorry is a closure-tactic alternative, not a strategy-modifying finding; STRATEGY.md does not need an update.

## Severity summary

- **must-fix-this-iter**:
  - `RigidityKbar.tex` is `complete: partial` (the d_app + d_map closure paths inside `lem:GrpObj_omega_basechange_proj` are under-specified in blueprint prose and the iter-138 helpers `basechange_along_proj_two_inv_derivation` + `basechange_along_proj_two_inv` have no dedicated `\lean{...}` blocks). The iter-139 prover lane on the two derivation sub-sorries (d_app + d_map at `Cotangent/GrpObj.lean:581` and `:585`) and the mathlib-analogist consult on the two IsIso routes both require this chapter to land complete:true first. **Per the HARD GATE rule: drop `AlgebraicJacobian/Cotangent/GrpObj.lean` from `## Current Objectives` this iter, dispatch a `blueprint-writer` for `RigidityKbar.tex` AND `AlgebraicJacobian_Cotangent_GrpObj.tex` this iter with the must-fix items above.**
  - `AlgebraicJacobian_Cotangent_GrpObj.tex` is `complete: partial` (pointer chapter missing the two iter-138 helpers in its enumeration). Same gate fires; blueprint-writer dispatch covers both chapters jointly.
  - `RigidityKbar.tex:491` `\leanok` on a sorry-bearing body (the IsIso `letI` inside `relativeDifferentialsPresheaf_basechange_along_proj_two`) is flagged as a probable `sync_leanok` mis-mark for the plan-agent's `doctor`-skill consult; not for the review-agent to fix.

- **soon**:
  - Add a Route (b'2) sub-paragraph to the `lem:GrpObj_omega_basechange_proj` NOTE block, so a future mathlib-analogist consult (this iter or next) has blueprint coverage for both IsIso closure paths. May land in the same blueprint-writer dispatch as the must-fix items.

- **informational**:
  - No drift in `Jacobian.lean` blueprint chapter beyond the "earliest realistic body-closure iteration: iter-138+" line at `Jacobian.tex:412`, which is still consistent with current iter (iter-139 is staging the iter-138 partial into a closed iter-140+ form via the d_app + d_map + IsIso sub-lanes). The Lean-side stale docstring drift flagged in the directive (`RigidityKbar.lean:87`, `Jacobian.lean:186`, `Cohomology/MayerVietorisCover.lean:667–668`) is not mirrored in any blueprint chapter and is correctly out of scope for this report.

Overall verdict: HARD GATE FIRES on `AlgebraicJacobian/Cotangent/GrpObj.lean` — `RigidityKbar.tex` and `AlgebraicJacobian_Cotangent_GrpObj.tex` are both `complete: partial`, so the iter-139 prover lane on the two derivation sub-sorries must defer one iter behind a blueprint-writer dispatch this iter.
