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
  rw [← h, Category.assoc, ← Functor.map_comp, Iso.hom_inv_id_app,
    CategoryTheory.Functor.map_id, Category.comp_id]

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
  simp only [Scheme.Modules.Hom.comp_app, Scheme.Modules.pushforward_map_app,
    Scheme.Modules.restrictAdjunction_unit_app_app,
    Scheme.Modules.restrictFunctorComp_inv_app_app, Scheme.Modules.restrict_map]
  rw [← Functor.map_comp, ← Functor.map_comp, ← op_comp, ← op_comp]
  exact congrArg (fun t => F.presheaf.map t.op) (Subsingleton.elim _ _)

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
  -- both sides have head η^q_F ≫ q_*(η^c_{q^*F}); compute each tail to u_{c≫q}.app F.
  -- Side A:
  have hcomp := pushPull_unit_comp c q F
  rw [pushforwardComp_hom_app_id, Category.id_comp] at hcomp
  -- hcomp : η^{c≫q}_F = η^q_F ≫ q_*(η^c_{q^*F}) ≫ (c≫q)_*((pullbackComp c q).hom.app F)
  have hcast : ∀ {M N : C'.Modules} (ψ : M ⟶ N),
      (Scheme.Modules.pushforward (c ≫ q)).map ψ =
        (Scheme.Modules.pushforward q).map ((Scheme.Modules.pushforward c).map ψ) :=
    fun ψ => rfl
  have hA : (Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
      (Scheme.Modules.pushforward q).map
        ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
          ((Scheme.Modules.pullback q).obj F)) ≫
      (Scheme.Modules.pushforward c ⋙ Scheme.Modules.pushforward q).map
        ((Scheme.Modules.pullbackComp c q).hom.app F ≫
          (Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F) =
      (Scheme.Modules.restrictAdjunction (c ≫ q)).unit.app F := by
    rw [Functor.comp_map, Functor.map_comp, Functor.map_comp,
      ← hcast ((Scheme.Modules.pullbackComp c q).hom.app F),
      ← hcast ((Scheme.Modules.restrictFunctorIsoPullback (c ≫ q)).inv.app F)]
    rw [← Category.assoc, ← Category.assoc, ← hcomp, Category.assoc]
    exact unit_pushforward_rFIP_inv (c ≫ q) F
  -- Side B:
  have hB : (Scheme.Modules.pullbackPushforwardAdjunction q).unit.app F ≫
      (Scheme.Modules.pushforward q).map
        ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
          ((Scheme.Modules.pullback q).obj F)) ≫
      (Scheme.Modules.pushforward c ⋙ Scheme.Modules.pushforward q).map
        ((Scheme.Modules.pullback c).map
            ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F) ≫
          (Scheme.Modules.restrictFunctorIsoPullback c).inv.app (F.restrict q) ≫
          (Scheme.Modules.restrictFunctorComp c q).inv.app F) =
      (Scheme.Modules.restrictAdjunction (c ≫ q)).unit.app F := by
    rw [Functor.comp_map, Functor.map_comp, Functor.map_comp]
    -- naturality of η^c against (rFIP q).inv.app F, inside q_*
    have hnat := (Scheme.Modules.pullbackPushforwardAdjunction c).unit.naturality
      ((Scheme.Modules.restrictFunctorIsoPullback q).inv.app F)
    simp only [Functor.id_map, Functor.comp_map] at hnat
    -- hnat : (rFIPq.inv.app F) ≫ η^c.app (F.restrict q)
    --      = η^c.app (q^*F) ≫ c_*(c^*(rFIPq.inv.app F))
    have h0c := unit_pushforward_rFIP_inv c (F.restrict q)
    -- merge under q_*
    rw [← Functor.map_comp, ← Functor.map_comp, ← Category.assoc, ← Functor.map_comp]
    rw [← Category.assoc ((Scheme.Modules.pullbackPushforwardAdjunction c).unit.app
        ((Scheme.Modules.pullback q).obj F)), ← hnat]
    rw [Category.assoc, Category.assoc, reassoc_of% h0c]
    rw [Functor.map_comp, Functor.map_comp, ← Category.assoc]
    have h0q := unit_pushforward_rFIP_inv q F
    rw [h0q]
    exact restrict_unit_comp q c F
  exact hA.trans hB.symm

end AlgebraicGeometry
