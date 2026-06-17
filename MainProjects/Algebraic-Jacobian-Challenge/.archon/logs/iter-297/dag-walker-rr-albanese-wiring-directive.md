# DAG Walker Directive

## Slug
rr-albanese-wiring

## Seed
thm:pic0_isAbelianVariety (Pic⁰ is an abelian variety) and
thm:pic_zero_dimension_equals_genus (dim Pic⁰ = g). Walk UP their cones across the
Riemann–Roch, identity-component, Albanese, and rigidity chapters.

## The problem you are fixing (read carefully)
Every blueprint declaration in these chapters already has a statement and a finite
informal proof (NO ∞ blueprint nodes). The defect is **missing `\uses{}` edges**:
the directed dependency graph has the Riemann–Roch chain, the identity-component /
Pic⁰-abelian-variety theorems, the Albanese-extension machinery, and the
rigidity chain sitting in connected components **not reachable** from the goal.
Many apex theorems below are used by nothing, and internal `\uses{}` lists
under-declare what the Lean proof invokes. Your job is **edge transcription**:
read each consumer's Lean source and add the missing `\uses{}` edges so each apex
is wired to its real consumer and the subsystem flows upward toward
`thm:pic0_isAbelianVariety` (the Jacobian's defining property — dim g, smooth,
proper, geometrically irreducible group scheme).

You are NOT rewriting proofs or content. You ADD `\uses{}` edges (and, only if a
genuinely-needed dependency lemma has no block, a minimal block for it).

## Strategy context
`Jac(C) = Pic⁰_{C/k}`. The properties making it an abelian variety:
- **dimension = g**: via Riemann–Roch in genus 0 (Weil divisors → O_C(D), O_C(P) →
  RR Euler-characteristic formula → rational-curve iso C ≅ ℙ¹ → H¹ vanishing →
  Pic⁰ k-points ↔ degree-0 → `pic_zero_dimension_equals_genus`).
- **smooth/proper/geom-irreducible group scheme** and **rigidity** (morphisms from
  a genus-0 curve to an abelian variety are constant): via the rigidity chain
  (Rigidity → RigidityKbar → AbelianVarietyRigidity) and the Albanese extension
  (Auslander–Buchsbaum depth → codimension-1 indeterminacy extension →
  Thm 3.2 rational-map extension → Albanese universal property).
These all feed `pic0_isAbelianVariety`, which the (mathematician-owned) goal
chapter consumes.

## Depth / scope — WRITE-DOMAIN (these chapters ONLY)
- blueprint/src/chapters/RiemannRoch_WeilDivisor.tex
- blueprint/src/chapters/RiemannRoch_OcOfD.tex
- blueprint/src/chapters/RiemannRoch_OCofP.tex
- blueprint/src/chapters/RiemannRoch_RRFormula.tex
- blueprint/src/chapters/RiemannRoch_H1Vanishing.tex
- blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex
- blueprint/src/chapters/Picard_IdentityComponent.tex
- blueprint/src/chapters/Picard_Pic0AbelianVariety.tex
- blueprint/src/chapters/Albanese_AlbaneseUP.tex
- blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex
- blueprint/src/chapters/Albanese_CodimOneExtension.tex
- blueprint/src/chapters/Albanese_CoheightBridge.tex
- blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex
- blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- blueprint/src/chapters/Differentials.tex
- blueprint/src/chapters/Rigidity.tex
- blueprint/src/chapters/RigidityKbar.tex
- blueprint/src/chapters/AbelianVarietyRigidity.tex
- blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex

You may `\uses{}` labels defined in OTHER chapters (FGA representability, RelPicFunctor,
TensorObjSubstrate, etc.) — referencing is fine; you just may not EDIT those.

## Apex nodes that currently have no consumer (wire each to its real user)
- IdentityComponent: thm:pic_zero_dimension_equals_genus, thm:pic_zero_k_points_iff_degree_zero
- Pic0AbelianVariety: thm:pic0_isAbelianVariety
- RRFormula: lem:euler_char_sheafOf_zero, lem:euler_char_sheafOf_single_add
- H1Vanishing: lem:skyscraperSheaf_eq_pushforward, lem:alpha_beta_eq_toSheafify
- RationalCurveIso: thm:poleDivisor_degree_eq_finrank
- OCofP: lem:lineBundleAtClosedPoint_functionField_localUnit_of_orderZero_at_primeDivisor,
  thm:lineBundleAtClosedPoint_h0_sub_h1_eq_two
- OcOfD: lem:sheafOf_singlePoint
- WeilDivisor: lem:primeDivisor_ext, lem:primeDivisor_equivOpen,
  thm:isRegularInCodimensionOne_open, lem:order_eq_order_restrict, lem:primeDivisor_ofOpen_point,
  lem:primeDivisor_restrictToOpen_point (+ the other WeilDivisor apexes you find)
- AbelianVarietyRigidity: lem:av_regular_map_is_hom, def:p1bar_infty, def:gm_one,
  lem:projectiveLineBar_smoothOfRelDim, lem:proj_chart_ring_iso_aux_left,
  lem:hom_Ga_to_av_trivial, def:projlinebar_affine_cover (+ others you find)
- RigidityKbar: thm:rigidity_over_kbar, lem:GrpObj_cotangentSpace_extendScalars_witness,
  lem:GrpObj_cotangent_bridge, lem:KaehlerDifferential_constants_in_chart_of_proper_curve,
  lem:S3_sep_1_smooth_geometrically_reduced_Gamma
- AuslanderBuchsbaum: lem:auslander_buchsbaum_formula_succ_pd,
  lem:exists_minimalSurjection_finite_localRing, lem:depth_ker_ge_min_of_surjection_finite_localRing,
  lem:ext_vanish_of_natCast_lt_depth, lem:depth_eq_of_linearEquiv,
  lem:exists_isSMulRegular_of_one_le_depth (+ the projective-dimension cluster)
- CodimOneExtension: lem:isClosed_indeterminacy_locus,
  lem:finrank_residue_kaehler_of_standardSmooth_reldim,
  lem:ringKrullDim_quotient_localization_mvPolynomial_regular,
  lem:exists_submersivePresentation_of_standardSmoothReldim,
  lem:matsumura_isRegular_of_linearIndependent_cotangent (+ the mvPolynomial/krull-dim cluster)
- CoheightBridge: lem:ringKrullDimLE_of_coheight_eq_one
- Cotangent_GrpObj: lem:shearMulRight_hom_fst, lem:shearMulRight_hom_snd,
  lem:GrpObj_omega_basechange_proj_inv_derivation
- Differentials / Cross01Substrate: any apexes you find by `archon dag-query`.

## How to wire (the method)
1. `archon dag-query node --node <label> --json`, read the matched `.lean` decl,
   add the `\uses{}` edges its proof actually invokes.
2. Bottom-up: WeilDivisor → OcOfD → OCofP → RRFormula → RationalCurveIso /
   H1Vanishing → pic_zero_k_points → pic_zero_dimension_equals_genus →
   pic0_isAbelianVariety. Auslander–Buchsbaum → CodimOneExtension → Thm3.2 →
   AlbaneseUP. Rigidity → RigidityKbar → AbelianVarietyRigidity → pic0_isAbelianVariety.
3. For an apex with no consumer in your chapters whose only honest consumer is the
   mathematician-owned goal chapter (Jacobian.tex / AbelJacobi.tex / Genus.tex),
   record that edge under "Notes for dispatcher" — do NOT edit those chapters.
4. Do NOT invent edges; every `\uses{}` must reflect a real Lean dependency.

## Out of scope
- Do NOT edit chapters outside the write-domain.
- Do NOT touch Jacobian.tex / AbelJacobi.tex / Genus.tex.
- Do NOT add `\leanok`. `\mathlibok` only on genuine Mathlib anchors.

## References
- references/abelian-varieties.md (Milne: rigidity Thm 1.1, Thm 3.2/Prop 3.10, Albanese Prop 6.1/6.4)
- references/stacks-varieties.md, references/stacks-algebra.md (smoothness / standard-smooth Ω free)
- references/stacks-coherent.md (cohomology, base change)
Only cite a reference on a block you actually add; pure edge additions need no new citation.
