import AlgebraicJacobian.Cohomology.CechSectionIdentificationBase

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

open Scheme.Modules

variable {X : Scheme.{u}}

/-- Step 0: the pullback-pushforward adjunction unit, post-composed with the pushforward of
the `restrictFunctorIsoPullback` inverse component, is the restriction-adjunction unit. -/
lemma unit_pushforward_rFIP_inv {W₁ W₂ : Scheme.{u}} (j : W₁ ⟶ W₂) [IsOpenImmersion j]
    (N : W₂.Modules) :
    (Scheme.Modules.pullbackPushforwardAdjunction j).unit.app N ≫
        (Scheme.Modules.pushforward j).map
          ((Scheme.Modules.restrictFunctorIsoPullback j).inv.app N) =
      (Scheme.Modules.restrictAdjunction j).unit.app N := by
  have h : (Scheme.Modules.restrictAdjunction j).unit.app N ≫
      (Scheme.Modules.pushforward j).map
        ((Scheme.Modules.restrictFunctorIsoPullback j).hom.app N) =
      (Scheme.Modules.pullbackPushforwardAdjunction j).unit.app N :=
    Adjunction.unit_leftAdjointUniq_hom_app _ _ N
  have h2 : (Scheme.Modules.pushforward j).map
        ((Scheme.Modules.restrictFunctorIsoPullback j).hom.app N) ≫
      (Scheme.Modules.pushforward j).map
        ((Scheme.Modules.restrictFunctorIsoPullback j).inv.app N) =
      𝟙 ((Scheme.Modules.pushforward j).obj
        ((Scheme.Modules.restrictFunctor j).obj N)) :=
    ((Functor.map_comp _ _ _).symm.trans
      (congrArg (Scheme.Modules.pushforward j).map (Iso.hom_inv_id_app _ _))).trans
      (CategoryTheory.Functor.map_id _ _)
  calc (Scheme.Modules.pullbackPushforwardAdjunction j).unit.app N ≫
        (Scheme.Modules.pushforward j).map
          ((Scheme.Modules.restrictFunctorIsoPullback j).inv.app N)
      = ((Scheme.Modules.restrictAdjunction j).unit.app N ≫
          (Scheme.Modules.pushforward j).map
            ((Scheme.Modules.restrictFunctorIsoPullback j).hom.app N)) ≫
          (Scheme.Modules.pushforward j).map
            ((Scheme.Modules.restrictFunctorIsoPullback j).inv.app N) :=
        congrArg (fun w => w ≫ (Scheme.Modules.pushforward j).map
          ((Scheme.Modules.restrictFunctorIsoPullback j).inv.app N)) h.symm
    _ = (Scheme.Modules.restrictAdjunction j).unit.app N ≫
          ((Scheme.Modules.pushforward j).map
            ((Scheme.Modules.restrictFunctorIsoPullback j).hom.app N) ≫
           (Scheme.Modules.pushforward j).map
            ((Scheme.Modules.restrictFunctorIsoPullback j).inv.app N)) :=
        Category.assoc _ _ _
    _ = (Scheme.Modules.restrictAdjunction j).unit.app N :=
        (congrArg (fun w => (Scheme.Modules.restrictAdjunction j).unit.app N ≫ w) h2).trans
          (Category.comp_id _)

/-- Step 1 (K5): the iterated restriction-adjunction units compose, through the
`restrictFunctorComp` identification, to the unit of the composite open immersion. -/
lemma restrict_unit_comp {A C' : Scheme.{u}} (q : A ⟶ X) [IsOpenImmersion q]
    (c : C' ⟶ A) [IsOpenImmersion c] (F : X.Modules) :
    (Scheme.Modules.restrictAdjunction q).unit.app F ≫
        (Scheme.Modules.pushforward q).map
          ((Scheme.Modules.restrictAdjunction c).unit.app (F.restrict q)) ≫
        (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorComp c q).inv.app F)) =
      (Scheme.Modules.restrictAdjunction (c ≫ q)).unit.app F := by
  apply Scheme.Modules.hom_ext
  intro U
  have key : F.presheaf.map (homOfLE (q.image_preimage_le U)).op ≫
      F.presheaf.map ((Scheme.Hom.opensFunctor q).map
        (homOfLE (c.image_preimage_le (q ⁻¹ᵁ U)))).op ≫
      F.presheaf.map (eqToHom
        (show (c ≫ q) ''ᵁ (c ⁻¹ᵁ (q ⁻¹ᵁ U)) = q ''ᵁ (c ''ᵁ (c ⁻¹ᵁ (q ⁻¹ᵁ U))) by simp)).op =
      F.presheaf.map (homOfLE ((c ≫ q).image_preimage_le U)).op := by
    rw [← Functor.map_comp, ← Functor.map_comp, ← op_comp, ← op_comp]
    exact congrArg
      (fun t : ((c ≫ q) ''ᵁ (c ⁻¹ᵁ (q ⁻¹ᵁ U))) ⟶ U => F.presheaf.map t.op)
      (Subsingleton.elim _ _)
  exact key

/-- The β-chain collapse in the middle scheme: the pullback-pushforward unit followed by the
pushforward of the restrict-world conjugates is the restriction unit (with the
`restrictFunctorComp` tail kept). -/
lemma inner_beta_chain {A C' : Scheme.{u}} (q : A ⟶ X) [IsOpenImmersion q]
    (c : C' ⟶ A) [IsOpenImmersion c] (F : X.Modules) :
    (Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
        ((Scheme.Modules.pullback q).obj F) ≫
      (Scheme.Modules.pushforward c).map
        ((Scheme.Modules.pullback c).map
            ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
          (Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q) ≫
          (Scheme.Modules.restrictFunctorComp c q).inv.app F) =
      (Scheme.Modules.restrictFunctorIsoPullback q).inv.app F ≫
        (Scheme.Modules.restrictAdjunction c).unit.app (F.restrict q) ≫
        (Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorComp c q).inv.app F) := by
  -- naturality of the `c`-unit against `(rFIP q).inv.app F`
  have hnat : (Scheme.Modules.restrictFunctorIsoPullback q).inv.app F ≫
      (Scheme.Modules.pullbackPushforwardAdjunction c).unit.app (F.restrict q) =
      (Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
        ((Scheme.Modules.pullback q).obj F) ≫
      (Scheme.Modules.pushforward c).map ((Scheme.Modules.pullback c).map
        ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F)) :=
    (Scheme.Modules.pullbackPushforwardAdjunction c).unit.naturality
      ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F)
  have h0c := unit_pushforward_rFIP_inv c (F.restrict q)
  calc (Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
          ((Scheme.Modules.pullback q).obj F) ≫
        (Scheme.Modules.pushforward c).map
          ((Scheme.Modules.pullback c).map
              ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
            (Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q) ≫
            (Scheme.Modules.restrictFunctorComp c q).inv.app F)
      = (Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
          ((Scheme.Modules.pullback q).obj F) ≫
        (Scheme.Modules.pushforward c).map ((Scheme.Modules.pullback c).map
          ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F)) ≫
        (Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q)) ≫
        (Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorComp c q).inv.app F) :=
        congrArg (fun w => (Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
            ((Scheme.Modules.pullback q).obj F) ≫ w)
          ((Functor.map_comp _ _ _).trans
            (congrArg (fun w => (Scheme.Modules.pushforward c).map
                ((Scheme.Modules.pullback c).map
                  ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F)) ≫ w)
              (Functor.map_comp _ _ _)))
    _ = ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
          ((Scheme.Modules.pullback q).obj F) ≫
        (Scheme.Modules.pushforward c).map ((Scheme.Modules.pullback c).map
          ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F))) ≫
        (Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q)) ≫
        (Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorComp c q).inv.app F) :=
        (Category.assoc _ _ _).symm
    _ = ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F ≫
        (Scheme.Modules.pullbackPushforwardAdjunction c).unit.app (F.restrict q)) ≫
        (Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q)) ≫
        (Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorComp c q).inv.app F) :=
        congrArg (fun w => w ≫ (Scheme.Modules.pushforward c).map
            ((Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q)) ≫
          (Scheme.Modules.pushforward c).map
            ((Scheme.Modules.restrictFunctorComp c q).inv.app F)) hnat.symm
    _ = (Scheme.Modules.restrictFunctorIsoPullback q).inv.app F ≫
        (Scheme.Modules.pullbackPushforwardAdjunction c).unit.app (F.restrict q) ≫
        (Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q)) ≫
        (Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorComp c q).inv.app F) :=
        Category.assoc _ _ _
    _ = (Scheme.Modules.restrictFunctorIsoPullback q).inv.app F ≫
        ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app (F.restrict q) ≫
        (Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q))) ≫
        (Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorComp c q).inv.app F) :=
        congrArg (fun w => (Scheme.Modules.restrictFunctorIsoPullback q).inv.app F ≫ w)
          (Category.assoc _ _ _).symm
    _ = (Scheme.Modules.restrictFunctorIsoPullback q).inv.app F ≫
        (Scheme.Modules.restrictAdjunction c).unit.app (F.restrict q) ≫
        (Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorComp c q).inv.app F) :=
        congrArg (fun w => (Scheme.Modules.restrictFunctorIsoPullback q).inv.app F ≫
          w ≫ (Scheme.Modules.pushforward c).map
            ((Scheme.Modules.restrictFunctorComp c q).inv.app F)) h0c

/-- Step 2 (K4): the `pullbackComp` comparison, conjugated to restrict-world through
`restrictFunctorIsoPullback`, is the `restrictFunctorComp` identification. -/
lemma pullbackComp_rFIP_compat {A C' : Scheme.{u}} (q : A ⟶ X) [IsOpenImmersion q]
    (c : C' ⟶ A) [IsOpenImmersion c] (F : X.Modules) :
    (Scheme.Modules.pullbackComp c q).hom.app F ≫
        (Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F =
      (Scheme.Modules.pullback c).map
          ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
        (Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q) ≫
        (Scheme.Modules.restrictFunctorComp c q).inv.app F := by
  refine (((Scheme.Modules.pullbackPushforwardAdjunction q).comp
      (Scheme.Modules.pullbackPushforwardAdjunction c)).homEquiv F
      ((Scheme.Modules.restrictFunctor (c ≫ q)).obj F)).injective ?_
  rw [Adjunction.homEquiv_unit, Adjunction.homEquiv_unit, Adjunction.comp_unit_app]
  -- Side A: the composite unit absorbs the pullback comparison (`pushPull_unit_comp`),
  -- and the `rFIP (c≫q)` leg collapses by Step 0.
  have hcomp := pushPull_unit_comp c q F
  have e1 : (Scheme.Modules.pushforwardComp c q).hom.app
        ((Scheme.Modules.pullback c).obj ((Scheme.Modules.pullback q).obj F)) ≫
        (Scheme.Modules.pushforward (c ≫ q)).map
          ((Scheme.Modules.pullbackComp c q).hom.app F) =
      (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
        ((Scheme.Modules.pullbackComp c q).hom.app F)) :=
    (congrArg (fun w => w ≫ (Scheme.Modules.pushforward (c ≫ q)).map
        ((Scheme.Modules.pullbackComp c q).hom.app F))
      (pushforwardComp_hom_app_id c q _)).trans (Category.id_comp _)
  have hA0 : (Scheme.Modules.pullbackPushforwardAdjunction (c ≫ q)).unit.app F =
      (Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
        (Scheme.Modules.pushforward q).map
          ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
            ((Scheme.Modules.pullback q).obj F)) ≫
        (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
          ((Scheme.Modules.pullbackComp c q).hom.app F)) :=
    hcomp.trans (congrArg (fun w =>
      (Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
        (Scheme.Modules.pushforward q).map
          ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
            ((Scheme.Modules.pullback q).obj F)) ≫ w) e1)
  have hA : ((Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
      (Scheme.Modules.pushforward q).map
        ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
          ((Scheme.Modules.pullback q).obj F))) ≫
      (Scheme.Modules.pushforward c ⋙ Scheme.Modules.pushforward q).map
        ((Scheme.Modules.pullbackComp c q).hom.app F ≫
          (Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F) =
      (Scheme.Modules.restrictAdjunction (c ≫ q)).unit.app F := by
    have hsplit : (Scheme.Modules.pushforward c ⋙ Scheme.Modules.pushforward q).map
        ((Scheme.Modules.pullbackComp c q).hom.app F ≫
          (Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F) =
        (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
          ((Scheme.Modules.pullbackComp c q).hom.app F)) ≫
        (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F)) :=
      Functor.map_comp _ _ _
    calc ((Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
        (Scheme.Modules.pushforward q).map
          ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
            ((Scheme.Modules.pullback q).obj F))) ≫
        (Scheme.Modules.pushforward c ⋙ Scheme.Modules.pushforward q).map
          ((Scheme.Modules.pullbackComp c q).hom.app F ≫
            (Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F)
        = ((Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
          (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
              ((Scheme.Modules.pullback q).obj F))) ≫
          ((Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
            ((Scheme.Modules.pullbackComp c q).hom.app F)) ≫
          (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
            ((Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F))) :=
          congrArg (fun w => ((Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
            (Scheme.Modules.pushforward q).map
              ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
                ((Scheme.Modules.pullback q).obj F))) ≫ w) hsplit
      _ = (((Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
          (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
              ((Scheme.Modules.pullback q).obj F))) ≫
          (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
            ((Scheme.Modules.pullbackComp c q).hom.app F))) ≫
          (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
            ((Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F)) :=
          (Category.assoc _ _ _).symm
      _ = (Scheme.Modules.pullbackPushforwardAdjunction (c ≫ q)).unit.app F ≫
          (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
            ((Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F)) :=
          congrArg (fun w => w ≫ (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.pushforward c).map
              ((Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F)))
            ((Category.assoc _ _ _).trans hA0.symm)
      _ = (Scheme.Modules.restrictAdjunction (c ≫ q)).unit.app F :=
          unit_pushforward_rFIP_inv (c ≫ q) F
  -- Side B: unit naturality + Step 0 + Step 1.
  have hB : ((Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
      (Scheme.Modules.pushforward q).map
        ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
          ((Scheme.Modules.pullback q).obj F))) ≫
      (Scheme.Modules.pushforward c ⋙ Scheme.Modules.pushforward q).map
        ((Scheme.Modules.pullback c).map
            ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
          (Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q) ≫
          (Scheme.Modules.restrictFunctorComp c q).inv.app F) =
      (Scheme.Modules.restrictAdjunction (c ≫ q)).unit.app F := by
    have hmerge : (Scheme.Modules.pushforward q).map
        ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
          ((Scheme.Modules.pullback q).obj F)) ≫
        (Scheme.Modules.pushforward c ⋙ Scheme.Modules.pushforward q).map
          ((Scheme.Modules.pullback c).map
              ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
            (Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q) ≫
            (Scheme.Modules.restrictFunctorComp c q).inv.app F) =
        (Scheme.Modules.pushforward q).map
          ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
        (Scheme.Modules.pushforward q).map
          ((Scheme.Modules.restrictAdjunction c).unit.app (F.restrict q)) ≫
        (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorComp c q).inv.app F)) := by
      refine ((Functor.map_comp (Scheme.Modules.pushforward q) _ _).symm.trans ?_).trans
        ((Functor.map_comp (Scheme.Modules.pushforward q) _ _).trans
          (congrArg (fun w => (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫ w)
            (Functor.map_comp (Scheme.Modules.pushforward q) _ _)))
      refine congrArg (Scheme.Modules.pushforward q).map ?_
      exact (inner_beta_chain q c F).trans (Category.assoc _ _ _).symm
    calc ((Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
        (Scheme.Modules.pushforward q).map
          ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
            ((Scheme.Modules.pullback q).obj F))) ≫
        (Scheme.Modules.pushforward c ⋙ Scheme.Modules.pushforward q).map
          ((Scheme.Modules.pullback c).map
              ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
            (Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q) ≫
            (Scheme.Modules.restrictFunctorComp c q).inv.app F)
        = (Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
          ((Scheme.Modules.pushforward q).map
            ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
              ((Scheme.Modules.pullback q).obj F)) ≫
          (Scheme.Modules.pushforward c ⋙ Scheme.Modules.pushforward q).map
            ((Scheme.Modules.pullback c).map
                ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
              (Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q) ≫
              (Scheme.Modules.restrictFunctorComp c q).inv.app F)) :=
          Category.assoc _ _ _
      _ = (Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
          ((Scheme.Modules.pushforward q).map
            ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
          (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.restrictAdjunction c).unit.app (F.restrict q)) ≫
          (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
            ((Scheme.Modules.restrictFunctorComp c q).inv.app F))) :=
          congrArg (fun w =>
            (Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫ w) hmerge
      _ = ((Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
          (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F)) ≫
          (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.restrictAdjunction c).unit.app (F.restrict q)) ≫
          (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
            ((Scheme.Modules.restrictFunctorComp c q).inv.app F)) :=
          (Category.assoc _ _ _).symm
      _ = (Scheme.Modules.restrictAdjunction q).unit.app F ≫
          (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.restrictAdjunction c).unit.app (F.restrict q)) ≫
          (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
            ((Scheme.Modules.restrictFunctorComp c q).inv.app F)) :=
          congrArg (fun w => w ≫
            (Scheme.Modules.pushforward q).map
              ((Scheme.Modules.restrictAdjunction c).unit.app (F.restrict q)) ≫
            (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
              ((Scheme.Modules.restrictFunctorComp c q).inv.app F)))
            (unit_pushforward_rFIP_inv q F)
      _ = (Scheme.Modules.restrictAdjunction (c ≫ q)).unit.app F :=
          restrict_unit_comp q c F
  exact hA.trans hB.symm

/-- Step 3: the push–pull map of a slice-level open inclusion, conjugated to restrict-world,
is the restriction unit followed by the `restrictFunctorComp` identification (and the
over-triangle transport). -/
lemma pushPull_toRestrict_comm {A C' : Scheme.{u}} (q : A ⟶ X) [IsOpenImmersion q]
    (c : C' ⟶ A) [IsOpenImmersion c] (pC : C' ⟶ X) [IsOpenImmersion pC]
    (wC : c ≫ q = pC) (F : X.Modules) :
    pushPullMap F (Over.homMk c wC : Over.mk pC ⟶ Over.mk q) ≫
        (Scheme.Modules.pushforward pC).map
          ((Scheme.Modules.restrictFunctorIsoPullback pC).inv.app F) =
      (Scheme.Modules.pushforward q).map
          ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
        (Scheme.Modules.pushforward q).map
          ((Scheme.Modules.restrictAdjunction c).unit.app (F.restrict q)) ≫
        (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
          ((Scheme.Modules.restrictFunctorComp c q).inv.app F)) ≫
        eqToHom (by subst wC; rfl) := by
  subst wC
  have main : pushPullMap F (Over.homMk c rfl : Over.mk (c ≫ q) ⟶ Over.mk q) ≫
      (Scheme.Modules.pushforward (c ≫ q)).map
        ((Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F) =
      (Scheme.Modules.pushforward q).map
        ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
      (Scheme.Modules.pushforward q).map
        ((Scheme.Modules.restrictAdjunction c).unit.app (F.restrict q)) ≫
      (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
        ((Scheme.Modules.restrictFunctorComp c q).inv.app F)) := by
    have hraw : pushPullMap F (Over.homMk c rfl : Over.mk (c ≫ q) ⟶ Over.mk q) =
        rawPushPullMap c q (c ≫ q) rfl F := rfl
    have hself := rawPushPullMap_self c q F
    calc pushPullMap F (Over.homMk c rfl : Over.mk (c ≫ q) ⟶ Over.mk q) ≫
        (Scheme.Modules.pushforward (c ≫ q)).map
          ((Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F)
        = (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
                ((Scheme.Modules.pullback q).obj F) ≫
              (Scheme.Modules.pushforward c).map
                ((Scheme.Modules.pullbackComp c q).hom.app F)) ≫
          (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
            ((Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F)) :=
          congrArg (fun w => w ≫ (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.pushforward c).map
              ((Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F)))
            (hraw.trans hself)
      _ = (Scheme.Modules.pushforward q).map
            (((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
                ((Scheme.Modules.pullback q).obj F) ≫
              (Scheme.Modules.pushforward c).map
                ((Scheme.Modules.pullbackComp c q).hom.app F)) ≫
             (Scheme.Modules.pushforward c).map
                ((Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F)) :=
          (Functor.map_comp _ _ _).symm
      _ = (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
                ((Scheme.Modules.pullback q).obj F) ≫
              (Scheme.Modules.pushforward c).map
                ((Scheme.Modules.pullbackComp c q).hom.app F ≫
                  (Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F)) :=
          congrArg (Scheme.Modules.pushforward q).map
            ((Category.assoc _ _ _).trans
              (congrArg (fun w => (Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
                  ((Scheme.Modules.pullback q).obj F) ≫ w)
                (Functor.map_comp _ _ _).symm))
      _ = (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
                ((Scheme.Modules.pullback q).obj F) ≫
              (Scheme.Modules.pushforward c).map
                ((Scheme.Modules.pullback c).map
                    ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
                  (Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q) ≫
                  (Scheme.Modules.restrictFunctorComp c q).inv.app F)) :=
          congrArg (Scheme.Modules.pushforward q).map
            (congrArg (fun w => (Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
                ((Scheme.Modules.pullback q).obj F) ≫
                (Scheme.Modules.pushforward c).map w)
              (pullbackComp_rFIP_compat q c F))
      _ = (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F ≫
              (Scheme.Modules.restrictAdjunction c).unit.app (F.restrict q) ≫
              (Scheme.Modules.pushforward c).map
                ((Scheme.Modules.restrictFunctorComp c q).inv.app F)) :=
          congrArg (Scheme.Modules.pushforward q).map (inner_beta_chain q c F)
      _ = (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
          (Scheme.Modules.pushforward q).map
            ((Scheme.Modules.restrictAdjunction c).unit.app (F.restrict q)) ≫
          (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map
            ((Scheme.Modules.restrictFunctorComp c q).inv.app F)) :=
          (Functor.map_comp _ _ _).trans
            (congrArg (fun w => (Scheme.Modules.pushforward q).map
              ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫ w)
              (Functor.map_comp _ _ _))
  refine main.trans ?_
  exact congrArg (fun w => (Scheme.Modules.pushforward q).map
      ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
    (Scheme.Modules.pushforward q).map
      ((Scheme.Modules.restrictAdjunction c).unit.app (F.restrict q)) ≫ w)
    (Category.comp_id _).symm

end AlgebraicGeometry
