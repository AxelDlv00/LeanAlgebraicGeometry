---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.glueChartComponent_overlap_collapse
docstring: '**Pair-overlap collapse of the chart component** (the triangle step of
  the

  conjugated cocycle): the chart pullback `f_ij^*` of the `j`-th candidate-inverse

  component, fed through the pair cast chain of the glue square and the pulled-back

  counit at `ι_j`, collapses to the transition isomorphism `g_ij`. The mate

  `glueOverlapFactor_mate` at the identity identifies the cast chain with the transpose

  of `γ_ij`, which cancels `γ_ij⁻¹` inside the component; the remaining unit/counit
  pair

  at `f_ij` cancels by the left triangle identity. Project-local.'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.glueChartComponent_overlap_collapse
type: lean
updated: '2026-07-24T03:02:10'
---
lemma glueChartComponent_overlap_collapse (i j : D.J) :
    (Scheme.Modules.pullback (D.f i j)).map (glueChartComponent D M g i j) ≫
        (Scheme.Modules.pullbackComp (D.f i j) (D.ι i)).hom.app
          ((Scheme.Modules.pushforward (D.ι j)).obj (M j)) ≫
        (Scheme.Modules.pullbackCongr
          (show (D.t i j ≫ D.f j i) ≫ D.ι j = D.f i j ≫ D.ι i by
            rw [Category.assoc]; exact D.glue_condition i j)).inv.app
          ((Scheme.Modules.pushforward (D.ι j)).obj (M j)) ≫
        (Scheme.Modules.pullbackComp (D.t i j ≫ D.f j i) (D.ι j)).inv.app
          ((Scheme.Modules.pushforward (D.ι j)).obj (M j)) ≫
        (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).map
          ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι j)).counit.app (M j))
      = (g i j).hom := by
  -- transpose of the identity is the counit
  have hid : ((Scheme.Modules.pullbackPushforwardAdjunction (D.ι j)).homEquiv
        ((Scheme.Modules.pushforward (D.ι j)).obj (M j)) (M j)).symm
        (𝟙 ((Scheme.Modules.pushforward (D.ι j)).obj (M j)))
      = (Scheme.Modules.pullbackPushforwardAdjunction (D.ι j)).counit.app (M j) :=
    (Adjunction.homEquiv_counit _ _ _ _).trans
      ((eq_whisker ((Scheme.Modules.pullback (D.ι j)).map_id _) _).trans
        (Category.id_comp _))
  -- the mate at the identity: the pair cast chain is the transpose of `γ_ij`
  have hmate := glueOverlapFactor_mate D M i j
    (m := 𝟙 ((Scheme.Modules.pushforward (D.ι j)).obj (M j)))
  -- absorb the pulled-back identity in front of `γ_ij`
  have hγ : (Scheme.Modules.pullback (D.ι i)).map
        (𝟙 ((Scheme.Modules.pushforward (D.ι j)).obj (M j))) ≫
        (glueOverlapFactorIso D M i j).hom
      = (glueOverlapFactorIso D M i j).hom :=
    (eq_whisker ((Scheme.Modules.pullback (D.ι i)).map_id _) _).trans (Category.id_comp _)
  -- the transpose of `γ_ij` in counit form
  have hγt : ((Scheme.Modules.pullbackPushforwardAdjunction (D.f i j)).homEquiv
        ((Scheme.Modules.pullback (D.ι i)).obj
          ((Scheme.Modules.pushforward (D.ι j)).obj (M j)))
        ((Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j))).symm
        ((glueOverlapFactorIso D M i j).hom)
      = (Scheme.Modules.pullback (D.f i j)).map ((glueOverlapFactorIso D M i j).hom) ≫
        (Scheme.Modules.pullbackPushforwardAdjunction (D.f i j)).counit.app
          ((Scheme.Modules.pullback (D.t i j ≫ D.f j i)).obj (M j)) :=
    Adjunction.homEquiv_counit _ _ _ _
  -- the cast chain with the counit decoration equals `f_ij^*(γ_ij) ≫ ε_{f_ij}`
  have hchain := ((whisker_eq
      ((Scheme.Modules.pullbackComp (D.f i j) (D.ι i)).hom.app
        ((Scheme.Modules.pushforward (D.ι j)).obj (M j)))
      (whisker_eq _ (whisker_eq _ (congrArg
        (Scheme.Modules.pullback (D.t i j ≫ D.f j i)).map hid.symm)))).trans
    hmate).trans
    ((congrArg ((Scheme.Modules.pullbackPushforwardAdjunction (D.f i j)).homEquiv _ _).symm
      hγ).trans hγt)
  -- the component composed with `γ_ij` is the bare unit/transition pair
  have hsγ : glueChartComponent D M g i j ≫ (glueOverlapFactorIso D M i j).hom
      = (Scheme.Modules.pullbackPushforwardAdjunction (D.f i j)).unit.app (M i) ≫
        (Scheme.Modules.pushforward (D.f i j)).map (g i j).hom := by
    dsimp only [glueChartComponent]
    simp only [Category.assoc, Iso.inv_hom_id, Category.comp_id]
    rfl
  -- gather `f_ij^*`, cancel `γ`, and finish with counit naturality + the left triangle
  have hAB : (Scheme.Modules.pullback (D.f i j)).map (glueChartComponent D M g i j) ≫
        (Scheme.Modules.pullback (D.f i j)).map ((glueOverlapFactorIso D M i j).hom)
      = (Scheme.Modules.pullback (D.f i j)).map
          ((Scheme.Modules.pullbackPushforwardAdjunction (D.f i j)).unit.app (M i)) ≫
        (Scheme.Modules.pullback (D.f i j)).map
          ((Scheme.Modules.pushforward (D.f i j)).map (g i j).hom) :=
    (((Scheme.Modules.pullback (D.f i j)).map_comp _ _).symm.trans
      (congrArg (Scheme.Modules.pullback (D.f i j)).map hsγ)).trans
      ((Scheme.Modules.pullback (D.f i j)).map_comp _ _)
  refine (whisker_eq _ hchain).trans ?_
  refine (Category.assoc _ _ _).symm.trans ?_
  refine (eq_whisker hAB _).trans ?_
  refine (Category.assoc _ _ _).trans ?_
  refine (whisker_eq _
    ((Scheme.Modules.pullbackPushforwardAdjunction (D.f i j)).counit.naturality
      (g i j).hom)).trans ?_
  refine (Category.assoc _ _ _).symm.trans ?_
  exact (eq_whisker
      ((Scheme.Modules.pullbackPushforwardAdjunction (D.f i j)).left_triangle_components
        (M i)) _).trans
    (Category.id_comp _)

variable (hC1 : ∀ i, g i i = eqToIso (congrArg (fun φ => (Scheme.Modules.pullback φ).obj (M i))
      (show D.f i i = D.t i i ≫ D.f i i by rw [D.t_id i, Category.id_comp])))
  (hC2 : ∀ i j k,
      pullbackBaseChangeTransport (pullback.fst (D.f i j) (D.f i k))
          (D.f i j) (D.t i j ≫ D.f j i) (g i j) ≪≫
        (Scheme.Modules.pullbackCongr (glueData_bridge_mid D i j k)).app (M j) ≪≫
        pullbackBaseChangeTransport (D.t' i j k ≫ pullback.fst (D.f j k) (D.f j i))
          (D.f j k) (D.t j k ≫ D.f k j) (g j k) ≪≫
        (Scheme.Modules.pullbackCongr (glueData_bridge_tgt D i j k)).app (M k)
      = (Scheme.Modules.pullbackCongr (glueData_bridge_src D i j k)).app (M i) ≪≫
        pullbackBaseChangeTransport (pullback.snd (D.f i j) (D.f i k))
          (D.f i k) (D.t i k ≫ D.f k i) (g i k))

/-- The candidate-inverse family followed by the restricted `j`-th product projection
recovers the `j`-th component: the product-preservation comparison cancels against the
lift. Project-local. -/
@[reassoc]