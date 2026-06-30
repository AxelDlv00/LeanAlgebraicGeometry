/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse
import AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse.PresheafDualPullback
import AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse.PresheafDualUnitPullback
import AlgebraicJacobian.Picard.TensorObjSubstrate.PullbackTensorMapIso
import AlgebraicJacobian.Picard.TensorObjSubstrate.TrivialisationRestrict

/-!
# Tensor-inverse for locally trivial modules

This file holds `exists_tensorObj_inverse`, moved from `TensorObjSubstrate.lean`
to break the import cycle `RelPicFunctor → TensorObjSubstrate`.
-/

open CategoryTheory Limits MonoidalCategory

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

/-! ## Functoriality helpers for the iso-chain (cocycle infrastructure)

The overlap cocycle of `exists_tensorObj_inverse` (residual A) is closed via the
*abstract* route "the contraction `f x` is independent of the trivialisation
`eM x`".  That route needs `tensorObjIsoOfIso` to be bifunctorial and
`dualIsoOfIso` to be contravariantly functorial — both follow mechanically from
`Functor.mapIso` functoriality of the sheafification functor composed with the
underlying presheaf-level functoriality.  These reusable lemmas are proved here.
-/

/-- **`tensorObjIsoOfIso` is bifunctorial (composition).** -/
lemma tensorObjIsoOfIso_trans {X : Scheme.{u}} {M M' M'' N N' N'' : X.Modules}
    (e₁ : M ≅ M') (e₂ : M' ≅ M'') (e'₁ : N ≅ N') (e'₂ : N' ≅ N'') :
    tensorObjIsoOfIso (e₁ ≪≫ e₂) (e'₁ ≪≫ e'₂)
      = tensorObjIsoOfIso e₁ e'₁ ≪≫ tensorObjIsoOfIso e₂ e'₂ := by
  apply Iso.ext
  -- Reduce both `.hom`s to `sheafification.map (forget.map _ ⊗ₘ forget.map _)`; the carrier
  -- `X.ringCatSheaf.val = X.presheaf ⋙ forget₂` is only defeq, so the functoriality
  -- rewrites need `erw` (and a final defeq `rfl`).
  simp only [tensorObjIsoOfIso, Functor.mapIso_hom, Iso.trans_hom,
    MonoidalCategory.tensorIso_hom]
  erw [Functor.map_comp, Functor.map_comp, ← MonoidalCategory.tensorHom_comp_tensorHom,
    Functor.map_comp]
  rfl

/-- **`tensorObjIsoOfIso` of identities is the identity.** -/
lemma tensorObjIsoOfIso_refl {X : Scheme.{u}} (M N : X.Modules) :
    tensorObjIsoOfIso (Iso.refl M) (Iso.refl N) = Iso.refl _ := by
  apply Iso.ext
  simp only [tensorObjIsoOfIso, Functor.mapIso_refl, Functor.mapIso_hom, Iso.refl_hom,
    MonoidalCategory.tensorIso_hom]
  erw [CategoryTheory.Functor.map_id, CategoryTheory.Functor.map_id,
    MonoidalCategory.id_tensorHom_id, CategoryTheory.Functor.map_id]
  rfl

/-- **Generic 3-fold tensor/composition interchange.** In any monoidal category, the tensor of two
3-step composites distributes as the 3-step composite of tensors.  Stated explicitly (with the
three-fold `≫` shape) so a single `rw` matches the per-leg `(η ≫ pbv ≫ ρ⁻¹) ⊗ₘ (…)` form that the
bare `tensorHom_comp_tensorHom` rewrite fails to key on under a sheafification `Functor.map`. -/
lemma tensorHom_comp3 {C : Type*} [Category C] [MonoidalCategory C]
    {a₀ a₁ a₂ a₃ b₀ b₁ b₂ b₃ : C} (a : a₀ ⟶ a₁) (b : a₁ ⟶ a₂) (c : a₂ ⟶ a₃)
    (d : b₀ ⟶ b₁) (e : b₁ ⟶ b₂) (g : b₂ ⟶ b₃) :
    MonoidalCategory.tensorHom (a ≫ b ≫ c) (d ≫ e ≫ g)
      = MonoidalCategory.tensorHom a d ≫ MonoidalCategory.tensorHom b e
        ≫ MonoidalCategory.tensorHom c g := by
  rw [MonoidalCategory.tensorHom_comp_tensorHom, MonoidalCategory.tensorHom_comp_tensorHom]

/-- **`F.map` of a 3-fold tensor/composition interchange.** The image under any functor of a tensor
of two 3-step composites is the 3-step composite of the `F.map`-images of the per-step tensors.
Bundles `tensorHom_comp3` with `Functor.map_comp`; applied via `exact` so the functor-carrier
defeq (`(𝟙 _.obj)` vs `(𝟙 _.val)`) and the per-leg intermediate-object diamonds are absorbed
definitionally rather than fought with `rw`/`erw`. -/
lemma map_tensorHom_comp3 {C D : Type*} [Category C] [MonoidalCategory C] [Category D] (F : C ⥤ D)
    {a₀ a₁ a₂ a₃ b₀ b₁ b₂ b₃ : C} (a : a₀ ⟶ a₁) (b : a₁ ⟶ a₂) (c : a₂ ⟶ a₃)
    (d : b₀ ⟶ b₁) (e : b₁ ⟶ b₂) (g : b₂ ⟶ b₃) :
    F.map (MonoidalCategory.tensorHom (a ≫ b ≫ c) (d ≫ e ≫ g))
      = F.map (MonoidalCategory.tensorHom a d) ≫ F.map (MonoidalCategory.tensorHom b e)
        ≫ F.map (MonoidalCategory.tensorHom c g) := by
  rw [tensorHom_comp3, F.map_comp, F.map_comp]

/-- **Presheaf-level: `dualIsoOfIso` is contravariantly functorial (composition).**
Sectionwise, `dualIsoOfIso e` is precomposition by `pushforward₀.map e.hom`, and
precomposition is contravariant: `precomp (a ≫ b) = precomp b ∘ precomp a` (so the
order flips). -/
lemma presheaf_dualIsoOfIso_trans {D : Type u} [Category.{u, u} D]
    {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}
    {M M' M'' : _root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)}
    (e₁ : M ≅ M') (e₂ : M' ≅ M'') :
    PresheafOfModules.dualIsoOfIso (R₀ := R₀) (e₁ ≪≫ e₂)
      = PresheafOfModules.dualIsoOfIso e₂ ≪≫ PresheafOfModules.dualIsoOfIso e₁ := by
  apply Iso.ext
  apply PresheafOfModules.hom_ext
  intro U
  apply ModuleCat.hom_ext
  apply LinearMap.ext
  intro φ
  -- Both sides are precomposition by a `pushforward₀`-map of `e.hom`; the displayed
  -- applied form is definitionally `pushforward₀.map e.hom ≫ φ`, so we prove the
  -- underlying composite identity and discharge the goal by defeq.
  have key : (PresheafOfModules.pushforward₀ (Over.forget (Opposite.unop U))
        (R₀ ⋙ forget₂ CommRingCat RingCat)).map (e₁ ≪≫ e₂).hom ≫ φ
      = (PresheafOfModules.pushforward₀ (Over.forget (Opposite.unop U))
          (R₀ ⋙ forget₂ CommRingCat RingCat)).map e₁.hom
        ≫ ((PresheafOfModules.pushforward₀ (Over.forget (Opposite.unop U))
          (R₀ ⋙ forget₂ CommRingCat RingCat)).map e₂.hom ≫ φ) := by
    rw [Iso.trans_hom, Functor.map_comp, Category.assoc]
  exact key

/-- **Presheaf-level: `dualIsoOfIso` sends the identity to the identity.** -/
lemma presheaf_dualIsoOfIso_refl {D : Type u} [Category.{u, u} D]
    {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}
    {M : _root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)} :
    PresheafOfModules.dualIsoOfIso (R₀ := R₀) (Iso.refl M) = Iso.refl _ := by
  apply Iso.ext
  apply PresheafOfModules.hom_ext
  intro U
  apply ModuleCat.hom_ext
  apply LinearMap.ext
  intro φ
  have key : (PresheafOfModules.pushforward₀ (Over.forget (Opposite.unop U))
        (R₀ ⋙ forget₂ CommRingCat RingCat)).map (Iso.refl M).hom ≫ φ = φ := by
    rw [Iso.refl_hom, CategoryTheory.Functor.map_id, Category.id_comp]
  exact key

/-- **The sheaf-level dual is contravariantly functorial (composition).**
`dualIsoOfIso e = sheafification.mapIso (PresheafOfModules.dualIsoOfIso (forget.mapIso e))`,
so this reduces to `Functor.mapIso` functoriality and the presheaf-level
`presheaf_dualIsoOfIso_trans`. -/
lemma dualIsoOfIso_trans {X : Scheme.{u}} {M M' M'' : X.Modules}
    (e₁ : M ≅ M') (e₂ : M' ≅ M'') :
    dualIsoOfIso (e₁ ≪≫ e₂) = dualIsoOfIso e₂ ≪≫ dualIsoOfIso e₁ := by
  unfold dualIsoOfIso
  -- `forget.mapIso` lands in the defeq carrier `X.presheaf ⋙ forget₂`, so the functoriality
  -- rewrites need `erw`; the final `rfl` discharges the carrier defeq.
  erw [Functor.mapIso_trans, presheaf_dualIsoOfIso_trans, Functor.mapIso_trans]
  rfl

/-- **The sheaf-level dual sends the identity to the identity.** -/
lemma dualIsoOfIso_refl {X : Scheme.{u}} (M : X.Modules) :
    dualIsoOfIso (Iso.refl M) = Iso.refl _ := by
  unfold dualIsoOfIso
  rw [show (SheafOfModules.forget X.ringCatSheaf).mapIso (Iso.refl M) = Iso.refl _ from
      Functor.mapIso_refl _ _]
  erw [presheaf_dualIsoOfIso_refl, Functor.mapIso_refl]
  rfl

/-- **General monoidal coherence: `t ⊗ t⁻¹` contracts to the identity under the left
unitor at the unit.** In any monoidal category, if `s ≫ s' = 𝟙` are mutually-inverse
endomorphisms of the unit, then `(s ⊗ s') ≫ λ_(𝟙_) = λ_(𝟙_)`.  Proof: factor the tensor
via `tensorHom_def`, slide the right factor past `λ` by `leftUnitor_naturality`, slide the
left factor past `ρ = λ` (`unitors_equal`) by `rightUnitor_naturality`, then cancel. -/
lemma tensorHom_inv_comp_leftUnitor {C : Type*} [Category C] [MonoidalCategory C]
    {s s' : 𝟙_ C ⟶ 𝟙_ C} (h : s ≫ s' = 𝟙 _) :
    MonoidalCategory.tensorHom s s' ≫ (λ_ (𝟙_ C)).hom = (λ_ (𝟙_ C)).hom := by
  rw [MonoidalCategory.tensorHom_def, Category.assoc,
    MonoidalCategory.leftUnitor_naturality, ← Category.assoc,
    MonoidalCategory.unitors_equal, MonoidalCategory.rightUnitor_naturality,
    Category.assoc, h, Category.comp_id, ← MonoidalCategory.unitors_equal]

/-- **Sheaf-level B2: pairing mutually-inverse unit autos through `tensorObjIsoOfIso`
and contracting via `tensorObj_unit_iso` cancels.** If `t.hom ≫ s.hom = 𝟙` then
`tensorObjIsoOfIso t s ≪≫ tensorObj_unit_iso = tensorObj_unit_iso`.  Reduces to the
presheaf-level monoidal coherence `tensorHom_inv_comp_leftUnitor` under the sheafification
functor (the `tensorObjIsoOfIso`/`tensorObj_unit_iso` carriers are both
`sheafification.mapIso` of presheaf-level constructions). -/
lemma tensorObjIsoOfIso_comp_unit_iso {X : Scheme.{u}}
    (t s : SheafOfModules.unit X.ringCatSheaf ≅ SheafOfModules.unit X.ringCatSheaf)
    (h : t.hom ≫ s.hom = 𝟙 _) :
    tensorObjIsoOfIso t s ≪≫ tensorObj_unit_iso = tensorObj_unit_iso := by
  apply Iso.ext
  -- The presheaf-level coherence: `(forget t ⊗ forget s) ≫ λ_(𝟙_) = λ_(𝟙_)`.
  have hpre : MonoidalCategory.tensorHom
        (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))
        ((SheafOfModules.forget X.ringCatSheaf).map t.hom)
        ((SheafOfModules.forget X.ringCatSheaf).map s.hom) ≫
      (λ_ (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)))).hom
      = (λ_ (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)))).hom := by
    apply tensorHom_inv_comp_leftUnitor
    have hcomp := congrArg (SheafOfModules.forget X.ringCatSheaf).map h
    rw [CategoryTheory.Functor.map_comp, CategoryTheory.Functor.map_id] at hcomp
    exact hcomp
  -- Push `hpre` through the sheafification functor and collapse the two legs.
  have hmap := congrArg
    (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).map hpre
  erw [CategoryTheory.Functor.map_comp] at hmap
  simp only [tensorObjIsoOfIso, tensorObj_unit_iso, Iso.trans_hom, Functor.mapIso_hom,
    MonoidalCategory.tensorIso_hom]
  rw [← Category.assoc]
  exact congrArg (· ≫ _) hmap

/-- **c₁/c₆ (blueprint `lem:conjugateequiv_reindexcongr`): the two flanking reindex congruences
cancel.** The conjugate of the `pullbackCongr` leg (c₆, pullback world) composed with the conjugate
of the `restrictFunctorCongr` leg (c₁, restrict world) — both transports along the single equality
`f = f'` — telescopes to the identity on `pushforward f'`.  Proved by `subst` on the equality, after
which both congruences are identities. -/
lemma conjugateEquiv_reindexCongr {X Yv : Scheme.{u}} (f f' : Yv ⟶ X)
    [IsOpenImmersion f] [IsOpenImmersion f'] (h : f = f') :
    conjugateEquiv (pullbackPushforwardAdjunction f') (pullbackPushforwardAdjunction f)
          (pullbackCongr h).hom ≫
        conjugateEquiv (restrictAdjunction f) (restrictAdjunction f')
          (restrictFunctorCongr h).symm.hom
      = 𝟙 (pushforward f') := by
  subst h
  simp only [pullbackCongr, eqToIso_refl, Iso.refl_hom, conjugateEquiv_id, Category.id_comp,
    Iso.symm_hom]
  convert conjugateEquiv_id (restrictAdjunction f)
  ext M U
  simp <;> rfl

/-- **B2 `.hom`-level content (`restrictFunctorIsoPullback` pseudonaturality, `.hom.app A` form).**
The single `restrictFunctorIsoPullback V.ι` comparison map factors, through the chart composite
`j ≫ U.ι = V.ι`, as the two-step restrict→pullback comparison reindexed by `restrictFunctorComp` on
the restrict side and `pullbackComp`/`pullbackCongr` on the pullback side.  This is the genuine
mate-calculus content of B2 (the iso version reduces to this by the `restrictAdjunction V.ι` unit
triangle).  Both sides are maps `(restrictFunctor V.ι).obj A ⟶ (pullback V.ι).obj A`. -/
private lemma restrictFunctorIsoPullback_comp_compat_hom {X : Scheme.{u}} {U V : X.Opens}
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (hjι : j ≫ U.ι = V.ι) (A : X.Modules) :
    (restrictFunctorIsoPullback V.ι).hom.app A
      = (restrictFunctorCongr hjι).symm.hom.app A
          ≫ (restrictFunctorComp j U.ι).hom.app A
          ≫ (restrictFunctor j).map ((restrictFunctorIsoPullback U.ι).hom.app A)
          ≫ (restrictFunctorIsoPullback j).hom.app ((pullback U.ι).obj A)
          ≫ (pullbackComp j U.ι).hom.app A
          ≫ (pullbackCongr hjι).hom.app A := by
  -- Reduce the `.app A` statement to the underlying NatTrans equality (the per-leg `mapIso`/whisker
  -- bookkeeping `c₃ = whiskerRight`, `c₄ = whiskerLeft` is discharged here by `NatTrans.comp_app`);
  -- the genuine mate-calculus content is the NatTrans identity `hNat`.
  have hNat : (restrictFunctorIsoPullback V.ι).hom
      = (restrictFunctorCongr hjι).symm.hom
          ≫ (restrictFunctorComp j U.ι).hom
          ≫ Functor.whiskerRight (restrictFunctorIsoPullback U.ι).hom (restrictFunctor j)
          ≫ Functor.whiskerLeft (pullback U.ι) (restrictFunctorIsoPullback j).hom
          ≫ (pullbackComp j U.ι).hom
          ≫ (pullbackCongr hjι).hom := by
    apply (conjugateEquiv (pullbackPushforwardAdjunction V.ι) (restrictAdjunction V.ι)).injective
    rw [conjugateEquiv_restrictFunctorIsoPullback_hom]
    rw [← conjugateEquiv_comp (pullbackPushforwardAdjunction V.ι)
          (restrictAdjunction (j ≫ U.ι)) (restrictAdjunction V.ι),
        ← conjugateEquiv_comp (pullbackPushforwardAdjunction V.ι)
          ((restrictAdjunction U.ι).comp (restrictAdjunction j)) (restrictAdjunction (j ≫ U.ι)),
        ← conjugateEquiv_comp (pullbackPushforwardAdjunction V.ι)
          ((pullbackPushforwardAdjunction U.ι).comp (restrictAdjunction j))
          ((restrictAdjunction U.ι).comp (restrictAdjunction j)),
        ← conjugateEquiv_comp (pullbackPushforwardAdjunction V.ι)
          ((pullbackPushforwardAdjunction U.ι).comp (pullbackPushforwardAdjunction j))
          ((pullbackPushforwardAdjunction U.ι).comp (restrictAdjunction j)),
        ← conjugateEquiv_comp (pullbackPushforwardAdjunction V.ι)
          (pullbackPushforwardAdjunction (j ≫ U.ι))
          ((pullbackPushforwardAdjunction U.ι).comp (pullbackPushforwardAdjunction j))]
    rw [conjugateEquiv_restrictFunctorComp_inv, conjugateEquiv_pullbackComp_hom,
        conjugateEquiv_restrictFunctorIsoPullback_whiskerRight,
        conjugateEquiv_restrictFunctorIsoPullback_whiskerLeft]
    simp only [Category.id_comp, Category.comp_id]
    simp only [Category.assoc, Iso.inv_hom_id_assoc]
    rw [conjugateEquiv_reindexCongr (j ≫ U.ι) V.ι hjι]
  have happ := congr_app hNat A
  -- v4.31: `simpa using` runs at reducible transparency and fails the final unify; normalise `happ`
  -- in place then close with `exact` (default transparency bridges the instance defeq).
  simp only [NatTrans.comp_app, Functor.whiskerRight_app, Functor.whiskerLeft_app] at happ
  exact happ

/-- **B2 (blueprint `lem:restrictfunctorisopullback_comp_compat`): the `restrictFunctorIsoPullback`
NatIso is pseudonatural across the chart composite `j ≫ U.ι = V.ι`.**

The `V`-restriction-to-pullback comparison factors, through the reindex `ρ = restrictCompReindex j hjι`
on the `restrict` side and `pullbackComp`/`pullbackCongr` on the `pullback` side, as the two-step
comparison (first restrict-to-pullback along `U.ι`, transported by `restrict j`, then along `j`).
This is the shared reindex bridge for all of S2/S4c: it converts the `restrict`-world reindex
`restrictCompReindex` (= `restrictFunctorComp`) used to state the squares into the `pullback`-world
reindex `pullbackComp` in which the proven composition laws (`pullbackTensorMap_restrict`,
`pullbackObjUnitToUnit_comp`) live. Both sides are isos `restrictFunctor V.ι ≅ pullback V.ι`; the
identity is the `leftAdjointUniq`-coherence of `restrictFunctorIsoPullback` across composition. -/
private lemma restrictFunctorIsoPullback_comp_compat {X : Scheme.{u}} {U V : X.Opens}
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (hjι : j ≫ U.ι = V.ι) (A : X.Modules) :
    (restrictFunctorIsoPullback V.ι).app A
      = restrictCompReindex j hjι A
          ≪≫ (restrictFunctor j).mapIso ((restrictFunctorIsoPullback U.ι).app A)
          ≪≫ (restrictFunctorIsoPullback j).app ((pullback U.ι).obj A)
          ≪≫ (pullbackComp j U.ι).app A
          ≪≫ (pullbackCongr hjι).app A := by
  -- Both sides are isos `(restrictFunctor V.ι).obj A ≅ (pullback V.ι).obj A`.  Since
  -- `restrictFunctor V.ι` and `pullback V.ι` are both left adjoint to `pushforward V.ι`, an iso
  -- between them is pinned down by the `leftAdjointUniq` characterisation
  -- `homEquiv_leftAdjointUniq_hom_app`: it suffices to check both `.hom`s have the same image under
  -- `(restrictAdjunction V.ι).homEquiv`, namely `(pullbackPushforwardAdjunction V.ι).unit.app A`.
  -- CLOSED (iter-050): the LHS discharges to `(pullbackPushforwardAdjunction V.ι).unit.app A` via
  -- `homEquiv_leftAdjointUniq_hom_app`; the residual `.hom`-level naturality identity is exactly the
  -- now-proved `restrictFunctorIsoPullback_comp_compat_hom` (the leg-by-leg conjugate telescope).
  apply Iso.ext
  apply (restrictAdjunction V.ι).homEquiv _ _ |>.injective
  conv_lhs => rw [show ((restrictFunctorIsoPullback V.ι).app A).hom
    = ((restrictAdjunction V.ι).leftAdjointUniq (pullbackPushforwardAdjunction V.ι)).hom.app A
    from rfl, Adjunction.homEquiv_leftAdjointUniq_hom_app]
  rw [Adjunction.homEquiv_unit]
  simp only [Iso.trans_hom, Functor.mapIso_hom, Functor.map_comp, Category.assoc,
    restrictCompReindex, Iso.app_hom]
  -- LHS = `(pullbackPushforwardAdjunction V.ι).unit.app A`.  Replace it by the `restrictFunctorIsoPullback
  -- V.ι` unit-triangle so both sides become `restrictAdj.unit.app A ≫ (pushforward V.ι).map (-)`; cancel
  -- the shared prefix and merge the RHS legs back into a single `(pushforward V.ι).map`.  The residual is
  -- the genuine `.hom`-level naturality identity, discharged by `restrictFunctorIsoPullback_comp_compat_hom`.
  rw [show (pullbackPushforwardAdjunction V.ι).unit.app A
      = (restrictAdjunction V.ι).unit.app A
          ≫ (pushforward V.ι).map ((restrictFunctorIsoPullback V.ι).hom.app A)
      from (Adjunction.unit_leftAdjointUniq_hom_app (restrictAdjunction V.ι)
        (pullbackPushforwardAdjunction V.ι) A).symm]
  congr 1
  rw [restrictFunctorIsoPullback_comp_compat_hom j hjι A, Functor.map_comp, Functor.map_comp,
    Functor.map_comp, Functor.map_comp, Functor.map_comp]
  rfl

-- The `homEquiv`/`leftAdjointUniq` unfolding over the heavy sheafification-laden adjunctions is
-- heartbeat-heavy; the iter-053 telescope adds two more `whnf`-defeq `rfl`s on the composite
-- sheaf-pullback units (`hAcomp`, `hFINAL`), so the cumulative budget is bumped well past default.
set_option maxHeartbeats 4000000 in
/-- **Part III of the B1-crux: the sheaf pullback unit, transported by `forget`, factors as the
presheaf pullback unit followed by sheafification and the `pullbackValIso` comparison.**

For an open immersion `f`, the unit of the *sheaf*-level adjunction `pullback f ⊣ pushforward f`
(`SheafOfModules`), pushed through the forgetful functor to presheaves, equals the *presheaf*-level
pullback–pushforward unit composed with the sheafification unit `η` and the sheaf comparison
`pullbackValIso f M` (transported through `forget`).  This is the genuine sheafification-boundary
content of the B1 crux `H1inv_app_eq_pullbackVal_restrict`; the remaining legs of that crux
(restriction-side `unit_leftAdjointUniq`, the `forget`/`pushforward` functoriality) are formal.

Proof route: both sides are maps `M.val ⟶ (pushforward φ').obj (forget ((pullback f).obj M))`.
The RHS is `unit ≫ (pushforward φ').map (η ≫ forget pbv) = homEquiv (η ≫ forget pbv)` for the
presheaf pullback adjunction, so by `homEquiv`-injectivity it suffices to show
`homEquiv.symm (forget (sheaf-unit)) = η ≫ forget pbv`, a presheaf-level counit/unit identity in
the sheafification–pullback square. -/
private lemma sheafPullbackUnit_forget_eq {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (M : X.Modules) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    (SheafOfModules.forget X.ringCatSheaf).map ((pullbackPushforwardAdjunction f).unit.app M)
      = (PresheafOfModules.pullbackPushforwardAdjunction φ').unit.app M.val
        ≫ (PresheafOfModules.pushforward φ').map
            ((PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
                (𝟙 Y.ringCatSheaf.val)).unit.app ((PresheafOfModules.pullback φ').obj M.val)
              ≫ (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom) := by
  -- iter-052 RESTRUCTURE.  The genuine content is to compute the *opaque* sheaf pullback unit
  -- `(pullbackPushforwardAdjunction f).unit.app M` (built by `Adjunction.ofIsRightAdjoint`).
  -- Mathlib's `pullbackIso φ = leftAdjointUniq (pullbackPushforwardAdjunction φ)
  -- (PullbackConstruction.adjunction φ)` relates it to the CONCRETE
  -- `PullbackConstruction.adjunction φ` (same right adjoint `pushforward φ`), whose unit is
  -- computable from its explicit `homEquiv`.  The unit triangle gives
  --   `u_sheaf = PC.unit ≫ pushforward.map (pullbackIso.inv.app M)`;
  -- transporting through `forget` and reading off `PC.unit` lands the LHS on the presheaf composite
  --   `u_pre ≫ pushforward.map (η ≫ forget (pullbackIso.inv.app M))`.
  -- The residual `hKEY` identifies `pullbackIso.inv.app M` with `(pullbackValIso f M).hom`.
  set φ := Hom.toRingCatSheafHom f with hφ
  -- Step A: the `pullbackIso` unit triangle, solved for the opaque sheaf unit.
  have htri : (SheafOfModules.pullbackPushforwardAdjunction φ).unit.app M
        ≫ (SheafOfModules.pushforward φ).map ((SheafOfModules.pullbackIso φ).hom.app M)
      = (SheafOfModules.PullbackConstruction.adjunction φ).unit.app M :=
    Adjunction.unit_leftAdjointUniq_hom_app _ _ M
  -- `pushforward.map ρ.hom ≫ pushforward.map ρ.inv = 𝟙` (term mode: the `SheafOfModules` `≫` is
  -- defeq-but-not-syntactic, so every category-lemma step is applied via `:=`/`Eq.trans`).
  have hcancel : (SheafOfModules.pushforward φ).map ((SheafOfModules.pullbackIso φ).hom.app M)
        ≫ (SheafOfModules.pushforward φ).map ((SheafOfModules.pullbackIso φ).inv.app M) = 𝟙 _ :=
    (CategoryTheory.Functor.map_comp (SheafOfModules.pushforward φ) _ _).symm.trans
      ((congrArg (SheafOfModules.pushforward φ).map
        (Iso.hom_inv_id_app (SheafOfModules.pullbackIso φ) M)).trans
        (CategoryTheory.Functor.map_id (SheafOfModules.pushforward φ) _))
  have hA : (pullbackPushforwardAdjunction f).unit.app M
      = (SheafOfModules.PullbackConstruction.adjunction φ).unit.app M
        ≫ (SheafOfModules.pushforward φ).map ((SheafOfModules.pullbackIso φ).inv.app M) := by
    rw [← htri]
    exact (Eq.trans (Category.assoc _ _ _)
      (Eq.trans (congrArg (fun t => (SheafOfModules.pullbackPushforwardAdjunction φ).unit.app M ≫ t)
        hcancel) (Category.comp_id _))).symm
  -- Step B/C: compute `forget (PC.unit.app M)` from the explicit `PullbackConstruction.homEquiv`
  -- (`= sheafAdj_Y.homEquiv ∘ pullbackPPAdj_pre.homEquiv ∘ forget.homEquiv.symm`).  Reading off the
  -- two `homEquiv_unit`s and `forget ∘ forget.homEquiv.symm = id` yields the presheaf-level
  -- `u_pre ≫ pushforward.map η_Y`.
  have hUNIT : (SheafOfModules.forget X.ringCatSheaf).map
        ((SheafOfModules.PullbackConstruction.adjunction φ).unit.app M)
      = (PresheafOfModules.pullbackPushforwardAdjunction φ.hom).unit.app M.val
        ≫ (PresheafOfModules.pushforward φ.hom).map
            ((PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
                (𝟙 Y.ringCatSheaf.val)).unit.app
              ((PresheafOfModules.pullback φ.hom).obj M.val)) := by
    simp only [SheafOfModules.PullbackConstruction.adjunction, Adjunction.mkOfHomEquiv_unit_app]
    -- The `Equiv.trans` coercion only matches up to defeq, so drive the unfold with `erw`:
    -- two `Equiv.trans_apply`, then the two `homEquiv_unit`s (inner sheafification unit, outer
    -- presheaf pullback unit), collapse `map (𝟙)`, and `forget ∘ forget.preimage = id`.
    erw [Equiv.trans_apply, Equiv.trans_apply, Adjunction.homEquiv_unit, Adjunction.homEquiv_unit,
      CategoryTheory.Functor.map_id, Category.comp_id,
      (SheafOfModules.fullyFaithfulForget X.ringCatSheaf).map_preimage]
    rfl
  -- RESIDUAL `hKEY` (the sole content of the B1 crux still open): the Mathlib `pullbackIso φ` and
  -- the project `pullbackValIso f M` (built from `sheafificationCompPullback` + the X-side
  -- sheafification counit) are the SAME iso `a_Y (pullback φ' M.val) ≅ pullback f M`.  Both are
  -- `leftAdjointUniq`-comparisons onto `pushforward φ`; the identity is the compatibility of
  -- `pullbackIso` with `sheafificationCompPullback` across the X-counit `c_aX.app M`.
  have hKEY : (SheafOfModules.pullbackIso φ).inv.app M = (pullbackValIso f M).hom := by
    -- Transpose along the CONCRETE `PullbackConstruction` adjunction (`homEquiv` injective):
    -- `pullbackIso.inv.app M = (leftAdjointUniq PC pullbackPPAdj_sheaf).hom.app M`
    -- (`leftAdjointUniq_inv_app`), and `homEquiv_leftAdjointUniq_hom_app` sends its `PC.homEquiv`
    -- image to the opaque sheaf unit `pullbackPPAdj_sheaf.unit.app M`.  This reduces `hKEY` to the
    -- unit-comparison `hA2`.
    rw [show (SheafOfModules.pullbackIso φ).inv.app M
          = ((SheafOfModules.PullbackConstruction.adjunction φ).leftAdjointUniq
              (SheafOfModules.pullbackPushforwardAdjunction φ)).hom.app M
        from Adjunction.leftAdjointUniq_inv_app _ _ M]
    apply (SheafOfModules.PullbackConstruction.adjunction φ).homEquiv M
      ((SheafOfModules.pullback φ).obj M) |>.injective
    rw [Adjunction.homEquiv_leftAdjointUniq_hom_app, Adjunction.homEquiv_unit]
    -- GOAL `hA2`: `pullbackPPAdj_sheaf.unit.app M
    --                = PC.unit.app M ≫ (pushforward φ).map (pullbackValIso f M).hom`.
    -- This is the genuine sheafification-intertwining content of the B1 crux.  It is NOT provable by
    -- further transposition (every `homEquiv` route is circular — `hKEY`/`hA2`/the parent `G0` are
    -- all logically equivalent).  The sole non-circular input is the DEFINITION of
    -- `sheafificationCompPullback` as `leftAdjointUniq A B` (root
    -- `sheafificationCompPullback_eq_leftAdjointUniq`), with
    --   A = sheafAdj_X.comp pullbackPPAdj_sheaf,   B = pullbackPPAdj_pre.comp sheafAdj_Y.
    -- Route (mate calculus, ~80–150 LOC, the planner's flagged residual):
    --  (1) naturality of `η_s := pullbackPPAdj_sheaf.unit` along the X-counit iso
    --      `ε := sheafAdj_X.counit.app M : a_X M.val ⟶ M` rewrites `η_s.app M` as
    --      `ε⁻¹ ≫ η_s.app (a_X M.val) ≫ (pushforward).map (pullback_sheaf.map ε)`.
    --  (2) `Adjunction.unit_leftAdjointUniq_hom_app A B M.val` + `Adjunction.comp_unit_app` pin
    --      `forget (η_s.app (a_X M.val))` against `sheafCompPullback.hom.app M.val` and
    --      `B.unit.app M.val = u_pre ≫ (pushforward).map η_Y` (which is `forget (PC.unit.app M)`,
    --      i.e. the already-proven `hUNIT`).
    --  (3) `pullbackValIso.hom = sheafCompPullback.inv.app M.val ≫ pullback_sheaf.map ε`; the two
    --      `ε`/`pullback_sheaf.map ε` legs cancel, leaving exactly the `sheafCompPullback` unit
    --      identity from (2).  ESCALATION (per PROGRESS iter-052): mathlib-analogist cross-domain on
    --      `ofIsRightAdjoint`-unit transparency / the `pullbackIso ↔ sheafificationCompPullback`
    --      coherence (NO Mathlib API relates these two un-lemma'd `leftAdjointUniq` defs).
    -- Scaffolding for the route (both genuine non-circular inputs typecheck):
    --   `hnat` — naturality of the sheaf unit along the X-counit `ε`.
    --   `hpin` — the `sheafificationCompPullback` definition as `unit_leftAdjointUniq` of A vs B.
    have hnat := (SheafOfModules.pullbackPushforwardAdjunction φ).unit.naturality
      ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
        (𝟙 X.ringCatSheaf.val)).counit.app M)
    have hpin := Adjunction.unit_leftAdjointUniq_hom_app
      ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
          (𝟙 X.ringCatSheaf.val)).comp (SheafOfModules.pullbackPushforwardAdjunction φ))
      ((PresheafOfModules.pullbackPushforwardAdjunction φ.hom).comp
        (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)))
      M.val
    -- Telescope (analogist Analogue 1, ported): transpose to the presheaf world via forget
    -- faithfulness, then chase the opaque sheaf unit `η_s.app M` through the X-counit `ε` (hnat),
    -- the `A`-unit comp formula (`comp_unit_app`), `hpin` (= sheafCompPullback unit triangle), and
    -- the `B`-unit comp formula, landing on the presheaf composite `u_pre ≫ pushforward.map η_Y`.
    apply (SheafOfModules.fullyFaithfulForget X.ringCatSheaf).map_injective
    -- RHS: split forget over the sheaf composite (erw past the SheafOfModules ≫ seam), insert hUNIT.
    erw [CategoryTheory.Functor.map_comp]
    rw [hUNIT]
    -- LHS telescope (P1): forget(hnat) split + the X-sheafification triangle.
    have hfn := congrArg (SheafOfModules.forget X.ringCatSheaf).map hnat
    erw [CategoryTheory.Functor.map_comp, CategoryTheory.Functor.map_comp] at hfn
    have htri2 := (PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
      (𝟙 X.ringCatSheaf.val)).right_triangle_components (Y := M)
    simp only [Functor.id_obj, Functor.id_map, Functor.comp_map, restrictScalarsId_map] at hfn htri2
    -- Cleanly-typed sheafification triangle (`(forget⋙restrict).obj M` is defeq `M.val`).
    have htri2' : (PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
            (𝟙 X.ringCatSheaf.val)).unit.app M.val
          ≫ (SheafOfModules.forget X.ringCatSheaf).map
              ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                (𝟙 X.ringCatSheaf.val)).counit.app M)
        = 𝟙 M.val := htri2
    -- ε-cancelled LHS: solve `forget(hnat)` for `forget(η_s M)` via the triangle.
    have hLHS : (SheafOfModules.forget X.ringCatSheaf).map
          ((SheafOfModules.pullbackPushforwardAdjunction φ).unit.app M)
        = (PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
              (𝟙 X.ringCatSheaf.val)).unit.app M.val
          ≫ (SheafOfModules.forget X.ringCatSheaf).map
              ((SheafOfModules.pullbackPushforwardAdjunction φ).unit.app
                (((SheafOfModules.forget X.ringCatSheaf ⋙
                      PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.val)) ⋙
                    PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)).obj M))
          ≫ (SheafOfModules.forget X.ringCatSheaf).map
              ((SheafOfModules.pushforward φ).map
                ((SheafOfModules.pullback φ).map
                  ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                    (𝟙 X.ringCatSheaf.val)).counit.app M))) := by
      rw [show (SheafOfModules.forget X.ringCatSheaf).map
              ((SheafOfModules.pullbackPushforwardAdjunction φ).unit.app M)
            = 𝟙 M.val ≫ (SheafOfModules.forget X.ringCatSheaf).map
                ((SheafOfModules.pullbackPushforwardAdjunction φ).unit.app M)
          from (Category.id_comp _).symm, ← htri2']
      exact (Category.assoc _ _ _).trans
        (congrArg (fun t => (PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
          (𝟙 X.ringCatSheaf.val)).unit.app M.val ≫ t) hfn)
    rw [hLHS]
    -- `η ≫ (forget η_s)` is, on the nose, the composite-adjunction unit `A.unit` (proved before
    -- the `set` so the bare `rfl` can still zeta-unfold the `Adjunction.comp`).
    have hAcomp : (PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
            (𝟙 X.ringCatSheaf.val)).unit.app M.val
          ≫ (SheafOfModules.forget X.ringCatSheaf).map
              ((SheafOfModules.pullbackPushforwardAdjunction φ).unit.app
                (((SheafOfModules.forget X.ringCatSheaf ⋙
                      PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.val)) ⋙
                    PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)).obj M))
        = ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
              (𝟙 X.ringCatSheaf.val)).comp
            (SheafOfModules.pullbackPushforwardAdjunction φ)).unit.app M.val := rfl
    -- `A.unit` solved by the inverse `leftAdjointUniq` unit triangle (`B.leftAdjointUniq A`):
    -- `A.unit = B.unit ≫ R.map((A.leftAdjointUniq B)⁻¹)`.
    have hAcancel : ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
            (𝟙 X.ringCatSheaf.val)).comp
          (SheafOfModules.pullbackPushforwardAdjunction φ)).unit.app M.val
        = ((PresheafOfModules.pullbackPushforwardAdjunction φ.hom).comp
              (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
                (𝟙 Y.ringCatSheaf.val))).unit.app M.val
          ≫ (SheafOfModules.pushforward φ ⋙ SheafOfModules.forget X.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.val)).map
              ((((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                    (𝟙 X.ringCatSheaf.val)).comp
                  (SheafOfModules.pullbackPushforwardAdjunction φ)).leftAdjointUniq
                ((PresheafOfModules.pullbackPushforwardAdjunction φ.hom).comp
                  (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
                    (𝟙 Y.ringCatSheaf.val)))).inv.app M.val) := by
      rw [Adjunction.leftAdjointUniq_inv_app]
      exact (Adjunction.unit_leftAdjointUniq_hom_app _ _ M.val).symm
    -- `pullbackValIso.hom = sheafCompPullback⁻¹ ≫ pullback.map (X-counit)`.
    have hpbv : (pullbackValIso f M).hom
        = (SheafOfModules.sheafificationCompPullback φ).inv.app M.val
          ≫ (SheafOfModules.pullback φ).map
              ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                (𝟙 X.ringCatSheaf.val)).counit.app M) := by
      rw [pullbackValIso, Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom]
      rfl
    -- The `scp⁻¹`/`pullbackValIso` reconciliation (last leg).
    have hFINAL : (SheafOfModules.pushforward φ ⋙ SheafOfModules.forget X.ringCatSheaf ⋙
            PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.val)).map
            ((((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                  (𝟙 X.ringCatSheaf.val)).comp
                (SheafOfModules.pullbackPushforwardAdjunction φ)).leftAdjointUniq
              ((PresheafOfModules.pullbackPushforwardAdjunction φ.hom).comp
                (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
                  (𝟙 Y.ringCatSheaf.val)))).inv.app M.val)
          ≫ (SheafOfModules.forget X.ringCatSheaf).map
              ((SheafOfModules.pushforward φ).map
                ((SheafOfModules.pullback φ).map
                  ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                    (𝟙 X.ringCatSheaf.val)).counit.app M)))
        = (SheafOfModules.forget X.ringCatSheaf).map
            ((SheafOfModules.pushforward φ).map (pullbackValIso f M).hom) := by
      -- Bridge the explicit `leftAdjointUniq` back to `sheafificationCompPullback` (defeq through the
      -- `set φ := Hom.toRingCatSheafHom f`, so a `rw` of the lemma at `f` would miss).
      have hscp_eq : (((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
              (𝟙 X.ringCatSheaf.val)).comp
            (SheafOfModules.pullbackPushforwardAdjunction φ)).leftAdjointUniq
          ((PresheafOfModules.pullbackPushforwardAdjunction φ.hom).comp
            (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
              (𝟙 Y.ringCatSheaf.val))))
          = SheafOfModules.sheafificationCompPullback φ :=
        (sheafificationCompPullback_eq_leftAdjointUniq f).symm
      rw [hpbv, hscp_eq]
      erw [CategoryTheory.Functor.map_comp, CategoryTheory.Functor.map_comp]
      rfl
    -- Assemble: reassociate, recognise `A.unit`, cancel via the inverse triangle, merge the last leg.
    refine Eq.trans (Category.assoc _ _ _).symm ?_
    rw [hAcomp, hAcancel]
    -- `(B.unit ≫ R.map scp⁻¹) ≫ last`; reassociate and merge the last leg via `hFINAL` (term mode,
    -- so the final `B.unit = ppP.unit ≫ pushforward.map η_Y` step is discharged by defeq).
    exact Eq.trans (Category.assoc _ _ _)
      (congrArg (fun t => ((PresheafOfModules.pullbackPushforwardAdjunction φ.hom).comp
        (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
          (𝟙 Y.ringCatSheaf.val))).unit.app M.val ≫ t) hFINAL)
  -- Assemble: rewrite the opaque unit, split `forget` over `≫` (term mode for the `SheafOfModules`
  -- seam), insert `hUNIT`/`hKEY`, then merge the two presheaf `pushforward.map` legs.
  rw [hA]
  refine Eq.trans (CategoryTheory.Functor.map_comp (SheafOfModules.forget X.ringCatSheaf)
    ((SheafOfModules.PullbackConstruction.adjunction φ).unit.app M)
    ((SheafOfModules.pushforward φ).map ((SheafOfModules.pullbackIso φ).inv.app M))) ?_
  rw [hUNIT, hKEY]
  refine Eq.trans (Category.assoc _ _ _) ?_
  exact (congrArg (fun t => (PresheafOfModules.pullbackPushforwardAdjunction φ.hom).unit.app M.val ≫ t)
    (CategoryTheory.Functor.map_comp (PresheafOfModules.pushforward φ.hom)
        ((PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.val)).unit.app ((PresheafOfModules.pullback φ.hom).obj M.val))
        ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom))).symm

-- The `homEquiv`/`leftAdjointUniq` unfolding over the heavy sheafification-laden adjunctions is
-- heartbeat-heavy; bump past the default.
set_option maxHeartbeats 1600000 in
/-- **Per-leg sheafification of the presheaf adjoint-uniqueness comparison `H1.inv` (B1 residual).**
For an open immersion `f`, the presheaf-level `leftAdjointUniq` comparison `H1.inv.app M.val`
(`pushforward β ≅ pullback φ'`, the linchpin `H1` of `tensorObj_restrict_iso` Step 4) factors, after
the sheafification unit `η`, as the sheaf-level per-leg reindex
`pullbackValIso ≫ (restrictFunctorIsoPullback)⁻¹` (transported through `forget`).  This is the
leg-wise sheafification bookkeeping that B1's residual reduces to once the δ-conjugation content is
discharged (it is the per-factor identity behind the `M`/`N` legs of the residual `tensorHom`).

Proof strategy (`homEquiv`-injective on `pullbackPushforwardAdjunction φ'`): `H1.inv` is the
`leftAdjointUniq` whose defining unit-triangle is `pullbackPPAdj.unit ≫ pushforward.map H1.inv =
hadj.unit`; it suffices to verify the RHS satisfies the same triangle, reducing to the interplay of
the sheafification unit with the `sheafificationCompPullback` device (= `pullbackValIso`) and the
restriction adjunction (= `restrictFunctorIsoPullback`). -/
private lemma H1inv_app_eq_pullbackVal_restrict {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (M : X.Modules) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
      { app := fun U => (f.appIso U.unop).inv, naturality := fun _ _ i => f.appIso_inv_naturality i }
    let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
      Functor.whiskerRight α (forget₂ CommRingCat RingCat)
    let hadj : PresheafOfModules.pushforward β ⊣ PresheafOfModules.pushforward φ' :=
      PresheafOfModules.pushforwardPushforwardAdj f.isOpenEmbedding.isOpenMap.adjunction β φ'
        (by ext U x; exact congr($((f.app_appIso_inv _).symm).hom x))
        (by ext U x; exact congr($(f.appIso_inv_app_presheafMap U.unop) x))
    (hadj.leftAdjointUniq (PresheafOfModules.pullbackPushforwardAdjunction φ')).inv.app M.val
      = (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.val)).unit.app ((PresheafOfModules.pullback φ').obj M.val) ≫
        (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom ≫
        (SheafOfModules.forget Y.ringCatSheaf).map ((restrictFunctorIsoPullback f).app M).inv := by
  intro α β hadj
  apply (PresheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom f).hom).homEquiv _ _
    |>.injective
  rw [Adjunction.leftAdjointUniq_inv_app]
  simp only [Adjunction.homEquiv_unit]
  refine Eq.trans (Adjunction.unit_leftAdjointUniq_hom_app _ hadj M.val) ?_
  have hII : (restrictAdjunction f).unit.app M
        ≫ (pushforward f).map ((restrictFunctorIsoPullback f).hom.app M)
      = (pullbackPushforwardAdjunction f).unit.app M :=
    Adjunction.unit_leftAdjointUniq_hom_app _ _ M
  have key : (pushforward f).map ((restrictFunctorIsoPullback f).hom.app M)
        ≫ (pushforward f).map ((restrictFunctorIsoPullback f).inv.app M) = 𝟙 _ :=
    (CategoryTheory.Functor.map_comp (pushforward f) _ _).symm.trans
      ((congrArg (pushforward f).map (Iso.hom_inv_id_app (restrictFunctorIsoPullback f) M)).trans
        (CategoryTheory.Functor.map_id (pushforward f) _))
  have hII2 : (restrictAdjunction f).unit.app M
      = (pullbackPushforwardAdjunction f).unit.app M
        ≫ (pushforward f).map ((restrictFunctorIsoPullback f).inv.app M) := by
    rw [← hII]
    exact (Eq.trans (Category.assoc _ _ _)
      (Eq.trans (congrArg (fun t => (restrictAdjunction f).unit.app M ≫ t) key)
        (Category.comp_id _))).symm
  rw [show hadj.unit.app M.val
        = (SheafOfModules.forget X.ringCatSheaf).map ((restrictAdjunction f).unit.app M) from rfl,
    hII2]
  refine Eq.trans (CategoryTheory.Functor.map_comp (SheafOfModules.forget X.ringCatSheaf)
    ((pullbackPushforwardAdjunction f).unit.app M)
    ((pushforward f).map ((restrictFunctorIsoPullback f).inv.app M))) ?_
  refine Eq.trans (congrArg (fun t => t
      ≫ (PresheafOfModules.pushforward (f.toRingCatSheafHom).hom).map
          ((SheafOfModules.forget Y.ringCatSheaf).map ((restrictFunctorIsoPullback f).inv.app M)))
    (sheafPullbackUnit_forget_eq f M)) ?_
  exact Eq.trans (Category.assoc _ _ _)
    (congrArg (fun t => (PresheafOfModules.pullbackPushforwardAdjunction
        (f.toRingCatSheafHom).hom).unit.app M.val ≫ t)
      ((CategoryTheory.Functor.map_comp _ _ _).symm.trans
        (congrArg (PresheafOfModules.pushforward (f.toRingCatSheafHom).hom).map
          (Category.assoc _ _ _))))

-- The `erw` per-leg rewrite + `pushforward_mu_appIso_collapse` over the sheafification-laden
-- `leftAdjointUniq` carriers is heartbeat-heavy; bump past the default.
set_option maxHeartbeats 1600000 in
/-- **B1 (blueprint `lem:tensorobj_restrict_iso_eq_pullback_tensor_map`): the tensor-restriction
iso is the `restrictFunctorIsoPullback`-conjugate of the pullback-tensor comparison map.**

For an open immersion `f` the comparison `pullbackTensorMap f M N` is invertible by the **public**
witness `pullbackTensorMap_isIso_of_isOpenImmersion` (root `TensorObjSubstrate.lean`, L4770), cited
here directly as the `asIso` proof — the stale explicit `hiso` hypothesis is therefore dropped
(signature now matches the blueprint).  The structural iso `tensorObj_restrict_iso` decomposes as the
`restrictFunctorIsoPullback`-app on `M⊗N`, then `asIso (pullbackTensorMap f M N)`, then the per-leg
reindex by `(restrictFunctorIsoPullback f).app` on each tensor factor.  This promotes the *iso* world
(`tensorObj_restrict_iso`) to the *map* world (`pullbackTensorMap`) in which the proven composition law
`pullbackTensorMap_restrict` lives.

**STATUS (iter-044): δ-conjugation DISCHARGED; reduced to a per-leg sheafification residual.**
The δ-conjugation lemmas (`pushforward_mu_appIso_collapse`, `deltaConjOfMuComparison`,
`isIso_oplaxδ_of_conj`) were de-privatized iter-044, so the genuine geometric content of B1 is now
proved here in-line: cancel the shared `restrictFunctorIsoPullback`-prefix, read `(μIso Gβ).inv = δ Gβ`,
apply the public `pushforward_mu_appIso_collapse`, cancel `H1.inv ≫ H1.hom`, and cancel the shared
`sheafCompPb ; a_Y.map δ` prefix against the unfolded `pullbackTensorMap`.  What remains is a SINGLE,
well-isolated per-leg reconciliation (see the residual comment in the body).

**STATUS (iter-051): CLOSED at this level.** The `sheafifyTensorUnitIso` collapse uses the public
`sheafifyTensorUnitIso_hom_eq'`, and the per-leg helper `H1inv_app_eq_pullbackVal_restrict` is now
itself proven; this lemma's body is sorry-free at this level (it rides transitively only the single
reduced residual `sheafPullbackUnit_forget_eq`, the sheafification-pullback-unit mate identity). -/
private lemma tensorObj_restrict_iso_eq_pullbackTensorMap {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M N : X.Modules) :
    tensorObj_restrict_iso f M N
      = (restrictFunctorIsoPullback f).app (tensorObj M N)
          ≪≫ @asIso _ _ _ _ (pullbackTensorMap f M N)
              (pullbackTensorMap_isIso_of_isOpenImmersion f M N)
          ≪≫ tensorObjIsoOfIso ((restrictFunctorIsoPullback f).app M).symm
              ((restrictFunctorIsoPullback f).app N).symm := by
  -- Witness instance for `asIso` (public).
  haveI : IsIso (pullbackTensorMap f M N) := pullbackTensorMap_isIso_of_isOpenImmersion f M N
  simp only [tensorObj_restrict_iso]
  apply Iso.ext
  simp only [Iso.trans_hom, Category.assoc]
  congr 1
  -- After cancelling the shared `restrictFunctorIsoPullback`-prefix, the goal is the tail identity
  --   `(sheafCompPb).hom ≫ sheafification.map((H1.app).symm.hom ≫ (μIso Gβ).symm.hom)`
  --     `= pullbackTensorMap f M N ≫ tensorObjIsoOfIso ρM.symm ρN.symm`.
  -- Expose the `.hom`s of the mapIso/tensorObjIsoOfIso and read `(μIso Gβ).inv = δ Gβ`.
  simp only [Functor.mapIso_hom, Iso.trans_hom, Iso.symm_hom, asIso_hom,
    Functor.Monoidal.μIso_inv, tensorObjIsoOfIso, MonoidalCategory.tensorIso_hom]
  -- Apply the (now public) δ-conjugation `pushforward_mu_appIso_collapse`:
  --   `δ Gβ A B = H1.hom.app(A⊗B) ≫ δ(pullback φ') A B ≫ (H1.inv.app A ⊗ₘ H1.inv.app B)`,
  -- then cancel `H1.inv.app(M⊗N) ≫ H1.hom.app(M⊗N) = 𝟙` inside the sheafification.map.
  rw [pushforward_mu_appIso_collapse f M.val N.val, Iso.app_inv]
  erw [Iso.inv_hom_id_app_assoc]
  -- LHS = `sheafCompPb.hom ≫ a_Y.map (δ(pullback φ') ≫ (H1.inv.app M.val ⊗ₘ H1.inv.app N.val))`.
  erw [Functor.map_comp]
  -- Expand the RHS `pullbackTensorMap` into its 4-fold composite, then cancel the shared prefix
  --   `sheafCompPb.hom ≫ a_Y.map (δ(pullback φ'))`.
  simp only [pullbackTensorMap, Category.assoc]
  congr 1
  congr 1
  -- RESIDUAL (per-leg reconciliation).  Goal:
  --   `a_Y.map (H1.inv.app M.val ⊗ₘ H1.inv.app N.val)`
  --     `= sheafifyTensorUnitIso.hom`
  --       `≫ a_Y.map (forget (pullbackValIso f M).hom ⊗ₘ forget (pullbackValIso f N).hom)`
  --       `≫ a_Y.map (forget ρM.inv ⊗ₘ forget ρN.inv)`.
  rw [sheafifyTensorUnitIso_hom_eq']
  -- STEP 2: rewrite each `H1.inv` leg by the per-leg helper `H1inv_app_eq_pullbackVal_restrict`
  -- (`erw`: the `leftAdjointUniq` carrier matches only up to defeq instance/proof terms).
  erw [H1inv_app_eq_pullbackVal_restrict f M, H1inv_app_eq_pullbackVal_restrict f N]
  -- LHS = `a_Y.map ((η ≫ pbv_M ≫ ρM⁻¹) ⊗ (η ≫ pbv_N ≫ ρN⁻¹))`.  Distribute the per-leg composites
  -- across the tensor and split the `a_Y.map` via the bundled `map_tensorHom_comp3`.
  exact map_tensorHom_comp3
    (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) _ _ _ _ _ _ _

/-- **`tensorObj_functoriality` of identities is the identity.** -/
private lemma tensorObj_functoriality_id {X : Scheme.{u}} (M N : X.Modules) :
    tensorObj_functoriality (𝟙 M) (𝟙 N) = 𝟙 (tensorObj M N) := by
  simp only [tensorObj_functoriality]
  erw [MonoidalCategory.id_tensorHom_id, CategoryTheory.Functor.map_id]
  rfl

/-- `.hom` of `tensorObjIsoOfIso` is the `tensorObj_functoriality` of the component homs
(definitional: both are `sheafification.map (forget e.hom ⊗ₘ forget e'.hom)`). -/
private lemma tensorObjIsoOfIso_hom {X : Scheme.{u}} {M M' N N' : X.Modules}
    (e : M ≅ M') (e' : N ≅ N') :
    (tensorObjIsoOfIso e e').hom = tensorObj_functoriality e.hom e'.hom := rfl

/-- **`F.map` of a 2-fold tensor/composition interchange** (generic; mirrors `map_tensorHom_comp3`).
Used with `exact` so the concrete `MonoidalCategory` instance binds as a parameter (a direct
`rw [tensorHom_comp_tensorHom]` fails to unify the explicit PresheafOfModules monoidal instance). -/
private lemma map_tensorHom_comp2 {C D : Type*} [Category C] [MonoidalCategory C] [Category D]
    (F : C ⥤ D) {a₀ a₁ a₂ b₀ b₁ b₂ : C} (a : a₀ ⟶ a₁) (b : a₁ ⟶ a₂) (d : b₀ ⟶ b₁) (e : b₁ ⟶ b₂) :
    F.map (MonoidalCategory.tensorHom a d) ≫ F.map (MonoidalCategory.tensorHom b e)
      = F.map (MonoidalCategory.tensorHom (a ≫ b) (d ≫ e)) := by
  rw [← F.map_comp, MonoidalCategory.tensorHom_comp_tensorHom]

/-- **`tensorObj_functoriality` composes.** `TF a b ≫ TF a' b' = TF (a ≫ a') (b ≫ b')`. -/
private lemma tensorObj_functoriality_comp {X : Scheme.{u}} {M M' M'' N N' N'' : X.Modules}
    (a : M ⟶ M') (a' : M' ⟶ M'') (b : N ⟶ N') (b' : N' ⟶ N'') :
    tensorObj_functoriality a b ≫ tensorObj_functoriality a' b'
      = tensorObj_functoriality (a ≫ a') (b ≫ b') := by
  simp only [tensorObj_functoriality]
  exact map_tensorHom_comp2
    (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))
    _ a.val a'.val b.val b'.val

/-- **`tensorObj_functoriality` composes (3-fold).** Mirrors `map_tensorHom_comp3`; used via `exact`
with explicit morphism arguments so the `SheafOfModules ≫` seam binds by unification rather than an
`erw`/`refine _ _ _` whnf-bomb. -/
private lemma tensorObj_functoriality_comp3 {X : Scheme.{u}}
    {M₀ M₁ M₂ M₃ N₀ N₁ N₂ N₃ : X.Modules}
    (a : M₀ ⟶ M₁) (a' : M₁ ⟶ M₂) (a'' : M₂ ⟶ M₃)
    (b : N₀ ⟶ N₁) (b' : N₁ ⟶ N₂) (b'' : N₂ ⟶ N₃) :
    tensorObj_functoriality a b ≫ tensorObj_functoriality a' b'
        ≫ tensorObj_functoriality a'' b''
      = tensorObj_functoriality (a ≫ a' ≫ a'') (b ≫ b' ≫ b'') := by
  simp only [tensorObj_functoriality]
  exact (map_tensorHom_comp3
    (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))
    _ a.val a'.val a''.val b.val b'.val b''.val).symm

/-- **Naturality of `pullbackTensorMap` along the `pullbackCongr` transport.**  For an equality of
morphisms `hf : f = g`, the pullback-tensor comparison commutes with the `pullbackCongr hf` reindex,
modulo its `tensorObj_functoriality` image on the two tensor factors.  (Proved by `subst hf`, after
which `pullbackCongr rfl = Iso.refl` and `tensorObj_functoriality (𝟙) (𝟙) = 𝟙`.) -/
@[reassoc]
private lemma pullbackTensorMap_pullbackCongr {X Y : Scheme.{u}} {f g : Y ⟶ X} (hf : f = g)
    (M N : X.Modules) :
    (pullbackCongr hf).hom.app (tensorObj M N) ≫ pullbackTensorMap g M N
      = pullbackTensorMap f M N
        ≫ tensorObj_functoriality ((pullbackCongr hf).hom.app M)
            ((pullbackCongr hf).hom.app N) := by
  subst hf
  simp only [pullbackCongr, eqToIso_refl, Iso.refl_hom, NatTrans.id_app, Category.id_comp,
    tensorObj_functoriality_id, Category.comp_id]

/-- **Generic natural-iso cancellation, `≫`-tail form.** `α.hom.app X ≫ α.inv.app X ≫ f = f`.
Stated generically so it can be discharged by `exact` across the defeq-but-not-syntactic
`SheafOfModules ≫` seam (a direct `rw`/`erw [Iso.hom_inv_id_app_assoc]` either misses the seam or
whnf-bombs on the surrounding sheafification-laden term). -/
private lemma natIso_hom_inv_id_app_assoc {C D : Type*} [Category C] [Category D] {F G : C ⥤ D}
    (α : F ≅ G) (X : C) {Z : D} (f : F.obj X ⟶ Z) :
    α.hom.app X ≫ α.inv.app X ≫ f = f := by
  rw [← Category.assoc, Iso.hom_inv_id_app, Category.id_comp]

/-- **Pre-cancelled composition law `pullbackTensorMap_restrict`.** Folding the leading
`pullbackComp` pseudofunctoriality iso into `pullbackTensorMap (h ≫ f)` cancels the `pullbackComp.inv`
that `pullbackTensorMap_restrict` introduces.  Stated separately (and `@[reassoc]`) so the
`pullbackComp.hom ≫ pullbackComp.inv` cancellation happens on this small isolated term via `exact`
(see `natIso_hom_inv_id_app_assoc`) rather than as an `erw` on the full S2 goal (which whnf-bombs). -/
@[reassoc]
private lemma pullbackTensorMap_restrict_cancel {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    (M N : X.Modules) :
    (Scheme.Modules.pullbackComp h f).hom.app (tensorObj M N) ≫ pullbackTensorMap (h ≫ f) M N
      = (Scheme.Modules.pullback h).map (pullbackTensorMap f M N)
        ≫ pullbackTensorMap h ((Scheme.Modules.pullback f).obj M)
            ((Scheme.Modules.pullback f).obj N)
        ≫ (tensorObjIsoOfIso ((Scheme.Modules.pullbackComp h f).app M)
            ((Scheme.Modules.pullbackComp h f).app N)).hom := by
  rw [pullbackTensorMap_restrict h f M N]
  exact natIso_hom_inv_id_app_assoc (Scheme.Modules.pullbackComp h f) (tensorObj M N) _

/-- **S2 per-leg identity (`(*)` of the blueprint S2 reduction).** This is the single-module
coherence that the tensor-flank square S2 reduces to once Bridge B1 promotes every
`tensorObj_restrict_iso` to a `restrictFunctorIsoPullback`-conjugate of `pullbackTensorMap`, the
shared prefixes cancel (`pullbackTensorMap_restrict` + `pullbackTensorMap_natural`), and the two
sides are merged into a single `tensorObj_functoriality`.  It is exactly the inverse form of Bridge
B2 (`restrictFunctorIsoPullback_comp_compat`) transported through `restrictFunctorIsoPullback j`'s
naturality at the comparison map `(restrictFunctorIsoPullback U.ι).inv`. -/
private lemma restrictFunctorIsoPullback_comp_compat_leg {X : Scheme.{u}} {U V : X.Opens}
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (hjι : j ≫ U.ι = V.ι) (M : X.Modules) :
    ((pullbackComp j U.ι).app M).hom ≫ (pullbackCongr hjι).hom.app M
        ≫ ((restrictFunctorIsoPullback V.ι).app M).symm.hom
      = (pullback j).map ((restrictFunctorIsoPullback U.ι).app M).symm.hom
        ≫ ((restrictFunctorIsoPullback j).app (M.restrict U.ι)).symm.hom
        ≫ (restrictCompReindex j hjι M).symm.hom := by
  -- Both sides are `pb_j(pb_U M) ⟶ M|V`.  Expand `(RFIP V.ι).app M` by Bridge B2, invert the
  -- composite, and cancel the shared `pullbackComp`/`pullbackCongr` prefix; the residual is
  -- `RFIP j` naturality at `(RFIP U.ι).inv`.
  rw [restrictFunctorIsoPullback_comp_compat j hjι M]
  simp only [Iso.trans_symm, Iso.trans_hom, Iso.symm_hom, Iso.app_hom, Iso.app_inv,
    Functor.mapIso_inv, Category.assoc]
  -- Cancel the `pullbackCongr` and `pullbackComp` hom-inv pairs (`erw` past the `SheafOfModules ≫`
  -- defeq seam), then discharge the residual by inverse naturality of `restrictFunctorIsoPullback j`
  -- at the comparison map `(restrictFunctorIsoPullback U.ι).inv.app M`.
  erw [Iso.hom_inv_id_app_assoc, Iso.hom_inv_id_app_assoc]
  rw [(restrictFunctorIsoPullback j).inv.naturality_assoc]

-- The B1→B2→`pullbackTensorMap_restrict`/`_natural` telescope over the sheafification-laden
-- `leftAdjointUniq` carriers is heartbeat-heavy; bump well past the default.
-- v4.31 fix: `pullbackComp`/`pullbackTensorMap` mix the COMPOSED (`pullback U.ι ⋙ pullback j`) and
-- NESTED (`pullback j ∘ pullback U.ι`) object spellings, which are defeq but leave intermediate
-- goals only type-correct up to default (not `instances`) transparency; relax the defeq check so
-- `simp`/`congr` can traverse them (mirrors the sibling 6.4M-HB recoveries in TensorObjSubstrate).
set_option backward.isDefEq.respectTransparency false in
set_option maxHeartbeats 6400000 in
/-- **S2 (blueprint `lem:tensorobj_restrict_iso_restrict_compat`): the tensor-restriction
comparison commutes with further restriction along the chart `j : V ⟶ U` (`j ≫ U.ι = V.ι`).**

Modulo the reindexing iso `ρ = restrictCompReindex j hjι`, the `V`-built tensor-restriction iso
equals the `restrict j`-image of the `U`-built one.  This is the "pullback commutes with `⊗`
functorially" Stacks lemma, specialised to the immersion composite `j ≫ U.ι = V.ι`.

**Proof (the proven Bridge B1-route).**  Substitute Bridge B1
(`tensorObj_restrict_iso_eq_pullbackTensorMap`) on each `tensorObj_restrict_iso`; expand the leading
`restrictFunctorIsoPullback V.ι` factor by Bridge B2 (`restrictFunctorIsoPullback_comp_compat`) and
cancel the shared `ρ`/`restrictFunctor j`-prefixes; move `restrictFunctorIsoPullback j` to the front
by naturality; rewrite `pullbackTensorMap V.ι = pullbackTensorMap (j ≫ U.ι)` (`pullbackCongr`) and
apply the composition law `pullbackTensorMap_restrict`, cancelling `pullbackComp`; finally use
`pullbackTensorMap_natural` to carry the per-leg `restrictFunctorIsoPullback U.ι`-comparisons past
`pullbackTensorMap j`.  What remains is a pure `tensorObj_functoriality` identity whose two tensor
legs are each the per-module coherence `restrictFunctorIsoPullback_comp_compat_leg`. -/
private lemma tensorObj_restrict_iso_restrict_compat {X : Scheme.{u}} {U V : X.Opens}
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (hjι : j ≫ U.ι = V.ι)
    (M N : X.Modules) :
    tensorObj_restrict_iso V.ι M N
      = restrictCompReindex j hjι (tensorObj M N)
          ≪≫ (restrictFunctor j).mapIso (tensorObj_restrict_iso U.ι M N)
          ≪≫ tensorObj_restrict_iso j (M.restrict U.ι) (N.restrict U.ι)
          ≪≫ tensorObjIsoOfIso (restrictCompReindex j hjι M).symm
              (restrictCompReindex j hjι N).symm := by
  -- Promote every `tensorObj_restrict_iso` to the pullback world (Bridge B1) and expand the
  -- `restrictFunctorIsoPullback V.ι` leading factor (Bridge B2) at the `M⊗N` argument.
  simp only [tensorObj_restrict_iso_eq_pullbackTensorMap]
  rw [restrictFunctorIsoPullback_comp_compat j hjι (tensorObj M N)]
  simp only [Functor.mapIso_trans, Iso.trans_assoc]
  -- Cancel the shared `ρ_{M⊗N}` and `restrictFunctor j`-image of `RFIP U.ι` prefixes.
  congr 1; congr 1
  apply Iso.ext
  simp only [Iso.trans_hom, Functor.mapIso_hom, asIso_hom, Iso.app_hom]
  -- Move `RFIP j` to the front by naturality, cancelling the leading factor.
  rw [← Functor.map_comp_assoc, (restrictFunctorIsoPullback j).hom.naturality_assoc]
  congr 1
  -- Rewrite `pullbackTensorMap V.ι = pullbackTensorMap (j ≫ U.ι)` and apply the composition law,
  -- cancelling `pullbackComp`.
  rw [pullbackTensorMap_pullbackCongr_assoc hjι M N]
  -- v4.31 fix: the cancel rewrite's motive is ill-typed under `instances` transparency because the
  -- leading domain object is spelled `(pullback U.ι ⋙ pullback j).obj (M⊗N)` while the cancel
  -- lemma's RHS uses the nested spelling `(pullback j).obj ((pullback U.ι).obj (M⊗N))`.  Cross the
  -- seam by unification (`refine`/`Eq.trans`) instead of `rw`'s motive abstraction.
  refine Eq.trans (pullbackTensorMap_restrict_cancel_assoc j U.ι M N _) ?_
  rw [Functor.map_comp]
  -- v4.31 fix: the `@[reassoc]` cancel lemma left the LHS head left-bracketed
  -- `((pullback j).map ptm ≫ ptm_j ≫ tOIO) ≫ tail`, which `simp only [Category.assoc]` does not
  -- flatten here; an explicit `rw [Category.assoc]` exposes the shared leading
  -- `(pullback j).map (pullbackTensorMap U.ι M N)` on both sides so `congr 1` cancels it cleanly
  -- (otherwise `congr 1` matches the big left group vs the single map → spurious HEq subgoals).
  rw [Category.assoc]
  simp only [Category.assoc]
  congr 1
  -- Carry the per-leg `RFIP U.ι`-comparisons past `pullbackTensorMap j` (D1′ naturality).
  -- v4.31 fix: `(pullbackComp j U.ι).app` carries the COMPOSED spelling `(pullback U.ι ⋙ pullback j).obj`
  -- in its (implicit) tensor objects, while `pullbackTensorMap j` yields the NESTED
  -- `(pullback j).obj ((pullback U.ι).obj …)`.  These are defeq but not syntactic, so the goal is
  -- ill-typed at `instances` transparency and `simp [tensorObjIsoOfIso_hom]` makes no progress.
  -- Normalise the composed objects to nested with `Functor.comp_obj` first.
  simp only [Functor.comp_obj, tensorObjIsoOfIso_hom]
  rw [reassoc_of% (pullbackTensorMap_natural j
    ((restrictFunctorIsoPullback U.ι).app M).symm.hom
    ((restrictFunctorIsoPullback U.ι).app N).symm.hom)]
  congr 1
  -- Pure `tensorObj_functoriality` identity; merge the LHS pair (`refine Eq.trans` of the generic
  -- `tensorObj_functoriality_comp3`, applied so the `SheafOfModules ≫` seam binds by unification
  -- rather than an `erw` whnf-bomb) and discharge each tensor leg by the per-module coherence.
  refine Eq.trans (tensorObj_functoriality_comp3
    (((pullbackComp j U.ι).app M).hom) ((pullbackCongr hjι).hom.app M)
      (((restrictFunctorIsoPullback V.ι).app M).symm.hom)
    (((pullbackComp j U.ι).app N).hom) ((pullbackCongr hjι).hom.app N)
      (((restrictFunctorIsoPullback V.ι).app N).symm.hom)) ?_
  refine Eq.trans ?_ (tensorObj_functoriality_comp3
    ((pullback j).map ((restrictFunctorIsoPullback U.ι).app M).symm.hom)
      (((restrictFunctorIsoPullback j).app (M.restrict U.ι)).symm.hom)
      ((restrictCompReindex j hjι M).symm.hom)
    ((pullback j).map ((restrictFunctorIsoPullback U.ι).app N).symm.hom)
      (((restrictFunctorIsoPullback j).app (N.restrict U.ι)).symm.hom)
      ((restrictCompReindex j hjι N).symm.hom)).symm
  rw [restrictFunctorIsoPullback_comp_compat_leg j hjι M,
    restrictFunctorIsoPullback_comp_compat_leg j hjι N]

/-- **Decomposition of `dual_restrict_iso` into its sheaf-level conjugators and the presheaf
comparison `θ` (`presheafDualPullbackComparison`).**  By construction (`DualInverse.lean:166`),
`dual_restrict_iso f` is `restrictFunctorIsoPullback f` (Step 1) followed by
`sheafificationCompPullback` (Step 2) followed by the sheafification of the presheaf dual
base-change comparison `θ_{f,M}` (Steps 3–4, = `presheafDualPullbackComparison f M`). -/
private lemma dual_restrict_iso_eq_comparison {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules) :
    dual_restrict_iso f M
      = (restrictFunctorIsoPullback f).app (dual M)
        ≪≫ (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).app
              (PresheafOfModules.dual (R₀ := X.presheaf) M.val)
        ≪≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
              (𝟙 Y.ringCatSheaf.obj)).mapIso (presheafDualPullbackComparison f M) :=
  rfl

/-- **Bridge dual-(b) (blueprint `lem:sheafificationcomppullback_restrict`): composition law of
`sheafificationCompPullback` over the immersion factorisation `j ≫ U.ι = V.ι`.**  Stated generically
over an arbitrary presheaf `P` over `X` (instantiated at `P = M.val.dual` in S3).  By construction
this is the immersion-factorisation specialisation of the proven Sq1 coherence
`sheafificationCompPullback_comp` (`TensorObjSubstrate.lean`) at `h := j`, `f := U.ι` — its RHS is
Sq1's RHS verbatim. -/
private lemma sheafificationCompPullback_restrict {X : Scheme.{u}} {U V : X.Opens}
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (_hjι : j ≫ U.ι = V.ι)
    (P : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) :
    ((SheafOfModules.sheafificationCompPullback
        (Hom.toRingCatSheafHom (j ≫ U.ι))).app P).hom =
      (SheafOfModules.pullbackComp (Hom.toRingCatSheafHom U.ι) (Hom.toRingCatSheafHom j)).inv.app
          ((PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj P) ≫
        (SheafOfModules.pullback (Hom.toRingCatSheafHom j)).map
          ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom U.ι)).app P).hom ≫
        ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom j)).app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom U.ι).hom).obj P)).hom ≫
        (PresheafOfModules.sheafification (𝟙 (V : Scheme).ringCatSheaf.obj)).map
          ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom U.ι).hom
            (Hom.toRingCatSheafHom j).hom).hom.app P) := by
  -- Sq1 specialised at `h := j`, `f := U.ι` (its RHS is verbatim this goal's RHS).
  exact sheafificationCompPullback_comp j U.ι P

/-- **Iso-level naturality of `Functor.mapIso` against a natural iso `r : F ≅ G`.**  Generic
single-`[Category]` coherence: for an iso `e : A ≅ B` in the source, `F.mapIso e ≪≫ r.app B
= r.app A ≪≫ G.mapIso e`.  Applied (with ATOMIC iso arguments, never a `≪≫`-composite) by `rw` so it
fires syntactically WITHOUT touching the `restrictFunctor j` SOURCE-category instance diamond that
defeats every `Functor.map_comp`/`mapIso_trans` of a composite there (diagnosed iter-080). -/
private lemma mapIso_naturality {C D : Type*} [Category C] [Category D] {F G : C ⥤ D}
    (r : F ≅ G) {A B : C} (e : A ≅ B) :
    F.mapIso e ≪≫ r.app B = r.app A ≪≫ G.mapIso e := by
  apply Iso.ext
  simp only [Iso.trans_hom, Functor.mapIso_hom, Iso.app_hom]
  exact r.hom.naturality e.hom

/-- **`≫`-tail form of `mapIso_naturality`** so it fires on a right-associated `≪≫`-chain. -/
private lemma mapIso_naturality_assoc {C D : Type*} [Category C] [Category D] {F G : C ⥤ D}
    (r : F ≅ G) {A B : C} (e : A ≅ B) {Z : D} (k : G.obj B ≅ Z) :
    F.mapIso e ≪≫ r.app B ≪≫ k = r.app A ≪≫ G.mapIso e ≪≫ k := by
  rw [← Iso.trans_assoc, mapIso_naturality, Iso.trans_assoc]

/-- **Generic left-cancellation across a (defeq-but-not-syntactic) seam.**  Reduces
`a ≪≫ f = (a ≪≫ g) ≪≫ h` to `f = g ≪≫ h`.  The internal `Iso.trans_assoc` runs in this ABSTRACT
single-`[Category C]` (no instance seam), so it is `refine`-applied to the concrete goal — where
`Iso.trans_assoc` itself MISSES because the middle object crosses the c.1 pushforward/restrict defeq
seam — and the `a`-prefix cancels by unification + defeq, leaving the residual `H`. -/
private lemma iso_cancel_left {C : Type*} [Category C] {W X Y Z : C}
    (a : W ≅ X) (f : X ≅ Z) (g : X ≅ Y) (h : Y ≅ Z) (H : f = g ≪≫ h) :
    a ≪≫ f = (a ≪≫ g) ≪≫ h := by rw [H, Iso.trans_assoc]

/-- **Generic `symm`-cancellation through a trailing leg.**  Collapses
`a.symm ≪≫ ((a ≪≫ g) ≪≫ h)` to `g ≪≫ h`.  Like `iso_cancel_left`, the internal
`Iso.trans_assoc`/`Iso.symm_self_id_assoc` run in this ABSTRACT `[Category C]`, so the lemma is
`rw`/`exact`-applied to the concrete goal where those keyed rewrites MISS the c.1 defeq seam. -/
private lemma iso_symm_trans_cancel {C : Type*} [Category C] {W X Y Z : C}
    (a : W ≅ X) (g : X ≅ Y) (h : Y ≅ Z) :
    a.symm ≪≫ ((a ≪≫ g) ≪≫ h) = g ≪≫ h := by
  rw [Iso.trans_assoc, Iso.symm_self_id_assoc]

/-- **`symm`-cancellation through a trailing leg with the middle factor kept FOLDED.**  Collapses
`a.symm ≪≫ D ≪≫ h` to `g ≪≫ h`, where `D` is a folded iso whose head is `a` (`hD : D = a ≪≫ g`).
Stated with `D` as an explicit (folded) argument so the cancellation `rw`/`exact` fires WITHOUT ever
spelling out the second occurrence of `a` in the concrete goal — that second occurrence is what
crosses the c.1 pushforward/restrict defeq seam and defeats the plain `iso_symm_trans_cancel` (the
keyed `rw` cannot unify the two syntactically-different-but-defeq `a`s; verified iter-082).  The
`subst hD` discharges the abstract `[Category C]` form before any seam is in play. -/
private lemma iso_symm_fold_cancel {C : Type*} [Category C] {W X Y Z : C}
    (a : W ≅ X) (D : W ≅ Y) (g : X ≅ Y) (hD : D = a ≪≫ g) (h : Y ≅ Z) :
    a.symm ≪≫ D ≪≫ h = g ≪≫ h := by
  subst hD; rw [Iso.trans_assoc, Iso.symm_self_id_assoc]

/- **DESIGN NOTE (iter-082) — the `pullbackCongr` coherence for the collapsed `(★pb-iso)` and why a
typed Scheme-`dualIsoOfIso`-transport version is IMPOSSIBLE.**

The collapsed `(★pb-iso)` (see the `dual_restrict_iso_restrict_compat` sorry below) needs the dual
mirror of `pullbackTensorMap_pullbackCongr` (L947): with `C_f M := SCP_f(M.val.dual) ≪≫
sheafify(θ_{f,M})` the post-`RFIP` comparison (`θ := presheafDualPullbackComparison`),
  `(pullbackCongr hf).app M.dual ≪≫ C_g M = C_f M ≪≫ T_{hf}`,   `hf : f = g`,
where `T_{hf}` is a contravariant dual transport `dual(M.restrict f) ≅ dual(M.restrict g)`.  The
MATHEMATICS is a one-line `subst hf` (then `pullbackCongr rfl = Iso.refl`, and the refl-collapse of
the transport — `restrictFunctorCongr rfl |>.app M = Iso.refl` is provable by `ext U : 3 <;> simp`
via the `rfl`-valued `restrictFunctorCongr_hom_app_app`, and `dualIsoOfIso (Iso.refl) = Iso.refl`).

OBSTRUCTION (lake-verified iter-082, NOT an LSP artefact): writing `T_{hf}` as the Scheme-level
`dualIsoOfIso ((restrictFunctorCongr hf).app M).symm` makes the lemma STATEMENT (even with a `sorry`
body) `whnf`-bomb — `12 800 000` heartbeats + `backward.isDefEq.respectTransparency false` BOTH
fail.  Reason: the codomain of `C_f M` is `sheafify (PresheafOfModules.dual ((pushforward β_f).obj
M.val))` (presheaf-pushforward-dual, then sheafified — see `presheafDualPullbackComparison` codomain),
which is defeq to the Scheme-level `dual ((restrictFunctor f).obj M)` ONLY through c.1
(`pushforwardObjValRestrictIso = Iso.refl`).  The `≪≫` junction forces the elaborator to unify two
`sheafify(…)` terms, i.e. to `whnf` INTO the sheafification colimit — which has no normal form, so it
is an INFINITE whnf, not merely a slow one (no heartbeat bump can pass it).  This is the same colimit
seam that bans `rw`/`simp` of category lemmas across the `SheafOfModules ≫` seam elsewhere in this file.

CONSEQUENCE / next route (effort-break for next iter): `T_{hf}` MUST be spelled in the
presheaf-sheafified-dual form so its domain is SYNTACTICALLY `C_f M`'s codomain (no junction whnf) —
i.e. `(sheafification (𝟙 _)).mapIso (PresheafOfModules.dualIsoOfIso (κ_{hf} M))` for a presheaf iso
`κ_{hf} M : (pushforward β_g).obj M.val ≅ (pushforward β_f).obj M.val` (a presheaf-pushforward-congr,
identity at `hf = rfl`).  Then a SEPARATE iso-equation (provable, NOT a junction) identifies that
sheafified-presheaf transport with the Scheme `dualIsoOfIso (restrictCompReindex …)` leg of `dρ` using
the `dualIsoOfIso` definition (`= sheafification.mapIso (PresheafOfModules.dualIsoOfIso (forget.mapIso …))`
— see `dualIsoOfIso_trans`) + c.1.  Equivalently, prove the whole cocycle at the FOLDED
`dual_restrict_iso` level (Scheme-dual codomain = syntactic, seam-free statement) and only unfold to
the `SCP/θ` bridges INSIDE the proof, where the seam is handled exactly as in `(b)`/`(c)`/the S2 route. -/

/-- **FOLDED `pullbackCongr`/`restrictFunctorCongr` coherence for `dual_restrict_iso` (seam-free).**
The dual mirror of `pullbackTensorMap_pullbackCongr`, stated at the FOLDED `dual_restrict_iso` level so
BOTH junctions are Scheme-`dual` ↔ Scheme-`dual` (syntactic — NO `sheafify`-colimit whnf, unlike the
unfolded `C_f`-level statement which is provably impossible to type; see the DESIGN NOTE above).  For
`hf : f = g`,
`(restrictFunctorCongr hf).app M.dual ≪≫ dual_restrict_iso g M
  = dual_restrict_iso f M ≪≫ dualIsoOfIso ((restrictFunctorCongr hf).app M).symm`.
Proved by `subst hf` (then `restrictFunctorCongr rfl = Iso.refl` at the section level, and
`dualIsoOfIso (Iso.refl) = Iso.refl`).  This is the verified brick for the `(★pb-iso)` `V.ι → j ≫ U.ι`
conversion; the remaining S3 work is to thread it WITHOUT collapsing `dual_restrict_iso` to the
`SCP/θ` bridges prematurely (the collapse exposes the un-typable seam). -/
private lemma dual_restrict_iso_pullbackCongr {X Y : Scheme.{u}} {f g : Y ⟶ X}
    (hf : f = g) [IsOpenImmersion f] [IsOpenImmersion g] (M : X.Modules) :
    (restrictFunctorCongr hf).app M.dual ≪≫ dual_restrict_iso g M
      = dual_restrict_iso f M ≪≫ dualIsoOfIso ((restrictFunctorCongr hf).app M).symm := by
  subst hf
  -- `restrictFunctorCongr rfl` is sectionwise `M.presheaf.map (eqToHom rfl).op = 𝟙`, i.e. `Iso.refl`.
  have hc : restrictFunctorCongr (rfl : f = f) = Iso.refl (restrictFunctor f) := by
    ext M U <;> simp <;> rfl
  have hcD : (restrictFunctorCongr (rfl : f = f)).app M.dual = Iso.refl _ := by rw [hc]; rfl
  have hcM : (restrictFunctorCongr (rfl : f = f)).app M = Iso.refl _ := by rw [hc]; rfl
  rw [hcD, hcM, Iso.refl_symm, dualIsoOfIso_refl, Iso.refl_trans, Iso.trans_refl]

/-- **Generic `.hom`-level SCP-cocycle assembly (single `[Category C]`, seam-free).**  Packages the
pure-`≫` bookkeeping of `dual_restrict_iso_comp` STEP-B: the leading inverse pair `a1 ≫ r0 = 𝟙`
(`pullbackComp f g` vs the sheaf `pullbackComp`), the mid inverse pair `rd ≫ c1 = 𝟙` (the
`PresheafOfModules.pullbackComp` under `sheafify`), and the residual naturality `r5 ≫ c2 = b2 ≫ b3`
(of `sheafificationCompPullback φ_f` at `θ_g.hom`) collapse the bridge-(b) (`ha2`) / distributed
bridge-(c) (`haZc`) composite to the two-step `restrictFunctorComp`-reindexed RHS.  Applied by `exact`
to the concrete (seam-laden) goal — its conclusion unifies up to the Scheme/Sheaf-`pullback` and c.1
pushforward/restrict defeqs.  Pure category algebra, so no `sheafify`-colimit whnf is ever triggered. -/
private lemma dual_scp_assemble {C : Type*} [Category C]
    {o0 o1 o3 o4 o5 o7 o8 o9 oR : C}
    {a1 : o0 ⟶ o1} {a2 : o1 ⟶ o5} {aZc : o5 ⟶ o9}
    {r0 : o1 ⟶ o0} {r1 : o0 ⟶ o3} {r5 : o3 ⟶ o4} {rd : o4 ⟶ o5}
    {c1 : o5 ⟶ o4} {c2 : o4 ⟶ o7} {c3 : o7 ⟶ o8} {c4 : o8 ⟶ o9}
    {b2 : o3 ⟶ oR} {b3 : oR ⟶ o7}
    (ha2 : a2 = r0 ≫ r1 ≫ r5 ≫ rd)
    (haZc : aZc = c1 ≫ c2 ≫ c3 ≫ c4)
    (hcancel1 : a1 ≫ r0 = 𝟙 _)
    (hcancelrd : rd ≫ c1 = 𝟙 _)
    (hnat : r5 ≫ c2 = b2 ≫ b3) :
    a1 ≫ a2 ≫ aZc = (r1 ≫ b2) ≫ (b3 ≫ c3) ≫ c4 := by
  subst ha2 haZc
  simp only [Category.assoc, Category.id_comp, reassoc_of% hcancel1, reassoc_of% hcancelrd,
    reassoc_of% hnat]

set_option maxHeartbeats 6400000 in
/-- **L1 (blueprint `lem:dual_restrict_iso_comp`): folded composition cocycle for
`dual_restrict_iso` along a composite of open immersions.**

For composable open immersions `f : Z ⟶ Y`, `g : Y ⟶ X` and `M : X.Modules`, the dual-restriction
comparison along the composite `f ≫ g` factors — entirely at the folded Scheme-`dual` level (every
junction Scheme-`dual` ↔ Scheme-`dual`, NO `sheafification`-colimit seam in the statement) — as the
`restrictFunctorComp`-reindexed two-step comparison, with the contravariant `dualIsoOfIso`-image of
`restrictFunctorComp f g` on the dual flank.  The seam between the Scheme-`dual` world and the
sheafified presheaf-dual world is crossed INSIDE this proof exactly as bridges (b)/(c)/S2 do — never
across the stated junction.  This is the dual mirror of the tensor-flank composition law
`tensorObj_restrict_iso_restrict_compat`. -/
lemma dual_restrict_iso_comp {X Y Z : Scheme.{u}} (f : Z ⟶ Y) (g : Y ⟶ X)
    [IsOpenImmersion f] [IsOpenImmersion g] (M : X.Modules) :
    dual_restrict_iso (f ≫ g) M
      = (restrictFunctorComp f g).app (dual M)
          ≪≫ (restrictFunctor f).mapIso (dual_restrict_iso g M)
          ≪≫ dual_restrict_iso f (M.restrict g)
          ≪≫ dualIsoOfIso ((restrictFunctorComp f g).app M) := by
  -- Mirror of the (now-deleted) chart S3 reduction, for the LITERAL composite `f ≫ g` (no
  -- `pullbackCongr`/`restrictFunctorCongr` legs).  Unfold the LHS `D(f≫g)` to its
  -- `RFIP ≪≫ SCP ≪≫ sheafify θ` decomposition (dual B1) and expand the leading `RFIP_{f≫g}` by the
  -- general B2 `restrictFunctorIsoPullback_comp_general` at `M.dual`; keep `D(g)`, `D(f)(M|g)` FOLDED.
  rw [dual_restrict_iso_eq_comparison (f ≫ g) M,
    restrictFunctorIsoPullback_comp_general f g M.dual]
  simp only [Iso.trans_assoc]
  -- Cancel the shared leading `(restrictFunctorComp f g).app M.dual` (B2's first leg = the RHS head).
  congr 1
  -- Bring `RFIP_f` to the front on the LHS by iso-level naturality at the ATOMIC `RFIP_g M.dual`.
  -- `erw` (not `rw`): the `r.app ((pullback g).obj M.dual)` factor crosses a `Functor.comp_obj`
  -- defeq that defeats the keyed `rw`.
  erw [mapIso_naturality_assoc (restrictFunctorIsoPullback f)
        ((restrictFunctorIsoPullback g).app M.dual)]
  -- On the RHS, expose `RFIP_f` at the front of `(restrictFunctor f).mapIso (D g) ≪≫ D f (M|g)` in
  -- ISOLATION (no trailing `dualIsoOfIso (rfc)` leg), keeping `D f (M|g)` FOLDED.
  have hR : (restrictFunctor f).mapIso (dual_restrict_iso g M)
        ≪≫ dual_restrict_iso f (M.restrict g)
      = (restrictFunctorIsoPullback f).app ((dual M).restrict g)
          ≪≫ (pullback f).mapIso (dual_restrict_iso g M)
          ≪≫ ((restrictFunctorIsoPullback f).app ((M.restrict g).dual)).symm
          ≪≫ dual_restrict_iso f (M.restrict g) := by
    apply Iso.ext
    simp only [Iso.trans_hom, Functor.mapIso_hom, Iso.symm_hom, Iso.app_hom, Iso.app_inv,
      Category.assoc]
    rw [← (restrictFunctorIsoPullback f).hom.naturality_assoc (dual_restrict_iso g M).hom]
    simp only [Iso.hom_inv_id_app_assoc]
  erw [← Iso.trans_assoc ((restrictFunctor f).mapIso (dual_restrict_iso g M))
        (dual_restrict_iso f (M.restrict g)), hR]
  simp only [Iso.trans_assoc]
  -- Cancel the shared `RFIP_f((dual M).restrict g)` prefix (now in `pullback f`-world).
  congr 1
  -- Split `(pullback f).mapIso (D g)` into its `RFIP_g` / pure-comparison legs by `Functor.mapIso_trans`.
  have hsplit : (pullback f).mapIso (dual_restrict_iso g M)
      = (pullback f).mapIso ((restrictFunctorIsoPullback g).app M.dual)
        ≪≫ (pullback f).mapIso
            ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom g)).app M.val.dual
            ≪≫ (PresheafOfModules.sheafification (𝟙 Y.ringCatSheaf.obj)).mapIso
                  (presheafDualPullbackComparison g M)) :=
    Functor.mapIso_trans (pullback f) _ _
  rw [hsplit]
  -- Cancel the shared `(pullback f).mapIso (RFIP_g M.dual)` prefix via `iso_cancel_left`.
  refine iso_cancel_left _ _ _ _ ?_
  -- Collapse the leading `RFIP_f((M|g).dual).symm ≪≫ D f (M|g)` on the RHS to the pure f-comparison
  -- `SCP_f ≪≫ sheafify θ_f`, keeping `D f (M|g)` FOLDED via `iso_symm_fold_cancel`.
  rw [iso_symm_fold_cancel _ _ _ (dual_restrict_iso_eq_comparison f (M.restrict g))
        (dualIsoOfIso ((restrictFunctorComp f g).app M))]
  -- ★pb-iso (pure pullback-world dual cocycle, all in `Z.Modules`):
  --   (pullbackComp f g).app dM ≪≫ SCP_{f≫g}(dM.val) ≪≫ sheafify θ_{f≫g}
  --     = (pullback f).mapIso (SCP_g ≪≫ sheafify θ_g) ≪≫ (SCP_f ≪≫ sheafify θ_f)
  --         ≪≫ dualIsoOfIso ((restrictFunctorComp f g).app M)
  -- Closed by bridge (b) `sheafificationCompPullback_comp f g` (SCP cocycle) + bridge (c)
  -- `presheafDualPullbackComparison_restrict f g` (θ cocycle), with c.1 `pushforwardObjValRestrictIso`
  -- chaining the middle θ — NO `pullbackCongr` conversion needed (literal composite).
  -- NB: this residual CANNOT be extracted to a standalone lemma — its STATEMENT (the
  -- `dualIsoOfIso (restrictFunctorComp f g)` factor adjacent to the sheafified `θ_f` leg) re-triggers
  -- the durable infinite-whnf junction (sheafification colimit); it is typable only here, in context,
  -- where the `rw`-produced goal already has its object indices unified.
  -- STEP A (DONE): expand the sheafified `θ_{f≫g}` by bridge (c).  The goal LHS becomes
  --   (pullbackComp f g).app dM ≪≫ SCP_{f≫g}(dM.val)
  --     ≪≫ sheafify( Ppc(g,f).symm.app(dM.val) ≪≫ (pullback φ_f).mapIso θ_g ≪≫ θ_f(M|g)
  --                  ≪≫ PresheafOfModules.dualIsoOfIso (forget.mapIso rfc) )
  -- against the RHS `(pullback f).mapIso(SCP_g ≪≫ sheafify θ_g) ≪≫ (SCP_f ≪≫ sheafify θ_f)
  --   ≪≫ dualIsoOfIso rfc`.
  rw [presheafDualPullbackComparison_restrict f g M]
  -- STEP B (REMAINING residual): distribute the outer `sheafification.mapIso` over the bridge-(c)
  -- composite (precise term-mode `Functor.mapIso_trans`, NOT `erw` — `erw` over-reaches and unfolds
  -- `θ_g`'s `H1 ≪≫ isoMk sliceDualTransport` internals through the inner `(pullback φ_f).mapIso`).
  -- The last sheafified factor `sheafify(PresheafOfModules.dualIsoOfIso (forget.mapIso rfc))` is DEFEQ
  -- to the Scheme `dualIsoOfIso (rfc.app M)` (the def of `dualIsoOfIso`), matching the RHS tail; the
  -- `sheafify θ_f` legs match; the head `pullbackComp f g ≪≫ SCP_{f≫g}` reduces against
  -- `(pullback f).mapIso SCP_g ≪≫ SCP_f` by bridge (b) `sheafificationCompPullback_comp f g` (the SCP
  -- composition law, `.hom`-level — needs `Iso.ext`).  This is the pure SCP-cocycle core; no
  -- `pullbackCongr` appears (literal composite), so it is the dual mirror of the proven tensor
  -- `pullbackTensorMap_restrict` SCP step.
  -- Drop to the `.hom` level: `apply Iso.ext` and flatten every `≪≫`/`.mapIso` into a single
  -- right-associated `≫`-chain (the seam-safe normalisation — `simp` here is syntactic, so it
  -- never unfolds `θ_g`'s `sliceDualTransport` internals, unlike the over-reaching
  -- `erw [Functor.mapIso_trans]`).
  apply Iso.ext
  simp only [Iso.trans_hom, Functor.mapIso_hom, Functor.map_comp, Iso.symm_hom, Iso.app_hom]
  -- The flat goal reduces, after the two inverse-pair cancellations (`pullbackComp`-head and the
  -- `PresheafOfModules.pullbackComp` mid), to ONE naturality of `SheafOfModules.sheafificationCompPullback`
  -- at `θ_g.hom`.  Package the pure-`≫` bookkeeping into the abstract `dual_scp_assemble` (no seam),
  -- supplying its five hypotheses as concrete `have`s (each crossing the seam by `:=`/defeq).
  -- ha2 := bridge (b) (the SCP cocycle), in `.hom.app` form (defeq to the `.app … .hom` lemma).
  have ha2 :
      (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom (f ≫ g))).hom.app M.val.dual
        = (SheafOfModules.pullbackComp (Hom.toRingCatSheafHom g) (Hom.toRingCatSheafHom f)).inv.app
              ((PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj M.val.dual)
          ≫ (SheafOfModules.pullback (Hom.toRingCatSheafHom f)).map
              ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom g)).hom.app M.val.dual)
          ≫ (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).hom.app
              ((PresheafOfModules.pullback (Hom.toRingCatSheafHom g).hom).obj M.val.dual)
          ≫ (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)).map
              ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom g).hom
                (Hom.toRingCatSheafHom f).hom).hom.app M.val.dual) :=
    sheafificationCompPullback_comp f g M.val.dual
  -- haZc := distribute the outer `sheafify` over the bridge-(c) composite (`← Functor.map_comp`,
  -- syntactic — never touches `θ_g`).
  have haZc :
      (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)).map
          ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom g).hom
                (Hom.toRingCatSheafHom f).hom).inv.app M.val.dual
            ≫ (PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).map
                (presheafDualPullbackComparison g M).hom
            ≫ (presheafDualPullbackComparison f (M.restrict g)).hom
            ≫ (PresheafOfModules.dualIsoOfIso ((SheafOfModules.forget Z.ringCatSheaf).mapIso
                ((restrictFunctorComp f g).app M))).hom)
        = (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)).map
            ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom g).hom
              (Hom.toRingCatSheafHom f).hom).inv.app M.val.dual)
          ≫ (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)).map
              ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).map
                (presheafDualPullbackComparison g M).hom)
          ≫ (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)).map
              (presheafDualPullbackComparison f (M.restrict g)).hom
          ≫ (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)).map
              (PresheafOfModules.dualIsoOfIso ((SheafOfModules.forget Z.ringCatSheaf).mapIso
                ((restrictFunctorComp f g).app M))).hom := by
    rw [← Functor.map_comp, ← Functor.map_comp, ← Functor.map_comp]
  -- hcancel1 := the leading `pullbackComp f g` ⋄ `pullbackComp`-inverse pair (Scheme/Sheaf defeq).
  have hcancel1 :
      (pullbackComp f g).hom.app M.dual
        ≫ (SheafOfModules.pullbackComp (Hom.toRingCatSheafHom g) (Hom.toRingCatSheafHom f)).inv.app
            ((PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj M.val.dual) = 𝟙 _ :=
    Iso.hom_inv_id_app _ _
  -- hcancelrd := the mid `PresheafOfModules.pullbackComp` ⋄ its inverse, under `sheafify`.
  have hcancelrd :
      (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)).map
          ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom g).hom
            (Hom.toRingCatSheafHom f).hom).hom.app M.val.dual)
        ≫ (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)).map
            ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom g).hom
              (Hom.toRingCatSheafHom f).hom).inv.app M.val.dual) = 𝟙 _ :=
    (CategoryTheory.Functor.map_comp
        (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)) _ _).symm.trans
      ((congrArg (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)).map
          (Iso.hom_inv_id_app (PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom g).hom
            (Hom.toRingCatSheafHom f).hom) M.val.dual)).trans
        (CategoryTheory.Functor.map_id
          (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)) _))
  -- hnat := the residual SCP-naturality of `sheafificationCompPullback φ_f` at `θ_g.hom`.
  have hnat :
      (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).hom.app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom g).hom).obj M.val.dual)
        ≫ (PresheafOfModules.sheafification (𝟙 Z.ringCatSheaf.obj)).map
            ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).map
              (presheafDualPullbackComparison g M).hom)
        = (SheafOfModules.pullback (Hom.toRingCatSheafHom f)).map
            ((PresheafOfModules.sheafification (𝟙 Y.ringCatSheaf.obj)).map
              (presheafDualPullbackComparison g M).hom)
          ≫ (SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).hom.app
              (M.restrict g).val.dual :=
    ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).hom.naturality
      (presheafDualPullbackComparison g M).hom).symm
  exact dual_scp_assemble ha2 haZc hcancel1 hcancelrd hnat

set_option maxHeartbeats 6400000 in
/-- **S3-core (blueprint `lem:dual_restrict_iso_dualisoofiso_restrict_compat`, dual-restriction
leg): `dual_restrict_iso` commutes with further restriction along the chart `j`.**

Modulo the reindexing iso `ρ = restrictCompReindex j hjι` (and its `dualIsoOfIso`-image on the dual
side, contravariant), the `V`-built dual-restriction iso equals the `restrict j`-image of the
`U`-built one.  The full blueprint S3 (which bundles the `(dualIsoOfIso e^M)⁻¹` transport and the
refinement `e^M ↦ restrictIsoUnitOfLE hVU e^M`) follows from this core plus contravariant
functoriality `dualIsoOfIso_trans` and the identity `restrictIsoUnitOfLE hVU e^M = (restrict j) e^M`
(both already available), threaded in the telescope. -/
private lemma dual_restrict_iso_restrict_compat {X : Scheme.{u}} {U V : X.Opens}
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (hjι : j ≫ U.ι = V.ι)
    (M : X.Modules) :
    dual_restrict_iso V.ι M
      = restrictCompReindex j hjι (dual M)
          ≪≫ (restrictFunctor j).mapIso (dual_restrict_iso U.ι M)
          ≪≫ dual_restrict_iso j (M.restrict U.ι)
          ≪≫ dualIsoOfIso (restrictCompReindex j hjι M) := by
  -- S3 assembly (iter-083 folded chain): the `V.ι`-leg is converted to the composite `j ≫ U.ι`
  -- across the restriction congruence (`dual_restrict_iso_pullbackCongr`, L2), then expanded by the
  -- folded composition cocycle `dual_restrict_iso_comp` (L1) at `(f,g) = (j, U.ι)`, and finally the
  -- two `dualIsoOfIso` transports are fused by `dualIsoOfIso_trans`.  Every step is pure Scheme-`dual`
  -- iso algebra — the `SCP/θ` seam is crossed only INSIDE L1's proof, never here.
  -- Step 0.  Solve L2 for `dual_restrict_iso V.ι M` (the `κ := restrictFunctorCongr hjι` head and the
  -- contravariant `dualIsoOfIso κ` tail).
  have hL2 := dual_restrict_iso_pullbackCongr (f := j ≫ U.ι) (g := V.ι) hjι M
  have hVeq : dual_restrict_iso V.ι M
      = ((restrictFunctorCongr hjι).app M.dual).symm
          ≪≫ dual_restrict_iso (j ≫ U.ι) M
          ≪≫ dualIsoOfIso ((restrictFunctorCongr hjι).app M).symm := by
    rw [← hL2, ← Iso.trans_assoc, Iso.symm_self_id, Iso.refl_trans]
  -- Step 1.  Expand the composite via L1 and unfold the reindex `ρ` / its dual image.
  rw [hVeq, dual_restrict_iso_comp j U.ι M]
  unfold restrictCompReindex
  rw [dualIsoOfIso_trans]
  -- Step 2.  Reassociate: both sides are the same right-associated chain.  The head
  -- (`(κ.app (dual M)).symm` vs `κ.symm.app (dual M)`) and the tail (`dualIsoOfIso (κ.app M).symm`
  -- vs `dualIsoOfIso (κ.symm.app M)`) differ only by the `Iso.app`/`symm` defeq (`α.symm.app X` is
  -- definitionally `(α.app X).symm`), so `rfl` closes after `Iso.trans_assoc` aligns the bracketing.
  simp only [Iso.trans_assoc]
  rfl

/-- **Generic outer-assembly (abstract `[Category C]`).**  Discharges the right-associated
`≫`-bookkeeping of the dual-unit naturality square once the two seam-crossing facts — the
`restrictFunctorIsoPullback`-naturality `hnat` and the core `hcore` — are supplied.  Pure category
algebra, run in an abstract category (no `SheafOfModules ≫` seam), so it is applied to the concrete
goal by defeq-unification (`refine`), never by a keyed `rw`/`simp` of a category lemma. -/
private lemma unit_assemble {C : Type*} [Category C] {A B P1 PD S U : C}
    {a : A ⟶ B} {r1 : B ⟶ P1} {pbu : P1 ⟶ U} {rD : A ⟶ PD} (b : PD ⟶ P1)
    {X : PD ⟶ S} {Y : S ⟶ U}
    (hnat : a ≫ r1 = rD ≫ b) (hcore : b ≫ pbu = X ≫ Y) :
    a ≫ r1 ≫ pbu = (rD ≫ X) ≫ Y := by
  rw [← Category.assoc a, hnat, Category.assoc, hcore, ← Category.assoc]

/-- **Generic core-assembly (abstract `[Category C]`).**  Reduces the `hcore` obligation
`m ≫ pbu = (scp_d ≫ syθ) ≫ syDu ≫ syPdY ≫ cuY` to four seam facts: `hsplit` (functoriality of the
sheaf pullback on the contracted unit), `hflank` (the sheafified L1′ dual-flank fold), `hscp` (the
`sheafificationCompPullback` naturality at the presheaf dual-unit map) and `hstar` (the genuine
unit-only reconciliation `(*)`).  All `≫`-bookkeeping is run abstractly; the concrete seam facts are
fed as hypotheses. -/
private lemma hcore_assemble {C : Type*} [Category C]
    {A B M S V T₁ T₂ T₃ W : C}
    {m : A ⟶ B} {pbu : B ⟶ W}
    {scp_d : A ⟶ S} {syθ : S ⟶ T₁} {syDu : T₁ ⟶ T₂} {syPdY : T₂ ⟶ T₃} {cuY : T₃ ⟶ W}
    {mp : A ⟶ M} {mc : M ⟶ B}
    {spp : S ⟶ V} {syp : V ⟶ T₃} {scp_v : M ⟶ V}
    (hsplit : m = mp ≫ mc)
    (hflank : syθ ≫ syDu ≫ syPdY = spp ≫ syp)
    (hscp : scp_d ≫ spp = mp ≫ scp_v)
    (hstar : mc ≫ pbu = scp_v ≫ syp ≫ cuY) :
    m ≫ pbu = (scp_d ≫ syθ) ≫ syDu ≫ syPdY ≫ cuY := by
  have e1 : m ≫ pbu = scp_d ≫ spp ≫ syp ≫ cuY := by
    rw [hsplit, Category.assoc, hstar, ← Category.assoc mp scp_v, ← hscp]
    simp only [Category.assoc]
  rw [e1, show (scp_d ≫ syθ) ≫ syDu ≫ syPdY ≫ cuY
      = scp_d ≫ (syθ ≫ syDu ≫ syPdY) ≫ cuY from by simp only [Category.assoc], hflank]
  simp only [Category.assoc]

/-- **Generic adjunction-uniqueness slide.**  Sliding the left-adjoint-uniqueness comparison
`leftAdjointUniq adj1 adj2 : F ≅ F'` (at `x`) through the inverse transpose of `adj2` collapses to
the inverse transpose of `adj1`.  Pure category algebra: `homEquiv_counit` on both sides, naturality
of the comparison along `g`, then the `leftAdjointUniq` counit-triangle. -/
private lemma leftAdjointUniq_hom_app_homEquiv_symm {C D : Type*} [Category C] [Category D]
    {F F' : C ⥤ D} {G : D ⥤ C} (adj1 : F ⊣ G) (adj2 : F' ⊣ G) {x : C} {e : D}
    (g : x ⟶ G.obj e) :
    (adj1.leftAdjointUniq adj2).hom.app x ≫ (adj2.homEquiv x e).symm g
      = (adj1.homEquiv x e).symm g := by
  rw [Adjunction.homEquiv_counit, Adjunction.homEquiv_counit, ← Category.assoc,
    ← (adj1.leftAdjointUniq adj2).hom.naturality g, Category.assoc]
  exact congrArg (F.map g ≫ ·) (Adjunction.leftAdjointUniq_hom_app_counit adj1 adj2 e)

/-- **RES1 (dual flank reconciliation): the forgotten sheaf-level unit identification equals the
presheaf-level pushforward unit comparator `q`.**  The chart-scheme unit identification
`unitRestrictIso f = restrictFunctorIsoPullback f ≪≫ pullbackUnitIso f`, viewed at the presheaf
level through `SheafOfModules.forget` (where `(restrict 𝟙_X f).val = (pushforward β).obj 𝟙_X` on the
nose), coincides with `presheafPushforwardUnitIso f` — the inverse lax-monoidal unit `ε (pushforward β)`.
This is the H1 pullback↔pushforward identification at the structure-sheaf unit. -/
private lemma forgetUnitRestrict_eq_pushforwardUnit {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] :
    (SheafOfModules.forget Y.ringCatSheaf).mapIso
        ((restrictFunctorIsoPullback f).app (SheafOfModules.unit X.ringCatSheaf)
          ≪≫ pullbackUnitIso f)
      = presheafPushforwardUnitIso f := by
  -- STEP 1 (morphism level).  Collapse the forgotten sheaf composite
  -- `RFIP.app 𝟙_X ≫ pullbackObjUnitToUnit φ` to the `restrictAdjunction`-unit transpose of
  -- `unitToPushforwardObjUnit φ`.  `RFIP = leftAdjointUniq (restrictAdjunction f)
  -- (pullbackPushforwardAdjunction f)` and `pullbackObjUnitToUnit φ = (pullbackPushforwardAdjunction
  -- f).homEquiv.symm (unitToPushforwardObjUnit φ)`, so the generic slide fires.  Doing this BEFORE
  -- sectioning is essential: the abstract left-adjoint `pullback` has no sectionwise value, but the
  -- `restrictFunctor = pushforward β` transpose does.
  have hcollapse :
      ((restrictFunctorIsoPullback f).app (SheafOfModules.unit X.ringCatSheaf)).hom
          ≫ (pullbackUnitIso f).hom
        = ((restrictAdjunction f).homEquiv _ _).symm
            (SheafOfModules.unitToPushforwardObjUnit f.toRingCatSheafHom) := by
    rw [show (pullbackUnitIso f).hom
          = SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom from rfl,
      ← SheafOfModules.pullbackPushforwardAdjunction_homEquiv_symm_unitToPushforwardObjUnit,
      show ((restrictFunctorIsoPullback f).app (SheafOfModules.unit X.ringCatSheaf)).hom
          = ((restrictAdjunction f).leftAdjointUniq
              (pullbackPushforwardAdjunction f)).hom.app
              (SheafOfModules.unit X.ringCatSheaf) from rfl]
    exact leftAdjointUniq_hom_app_homEquiv_symm (restrictAdjunction f)
      (pullbackPushforwardAdjunction f) _
  -- Expose the restrictAdjunction transpose as `restrictFunctor.map (unit→pushforward unit) ≫ counit`
  -- at the bare morphism level (no `forget` wrapper, so `rw` does not choke on the seam).
  have hmor :
      ((restrictFunctorIsoPullback f).app (SheafOfModules.unit X.ringCatSheaf)).hom
          ≫ (pullbackUnitIso f).hom
        = (restrictFunctor f).map
              (SheafOfModules.unitToPushforwardObjUnit f.toRingCatSheafHom)
            ≫ (restrictAdjunction f).counit.app (SheafOfModules.unit Y.ringCatSheaf) :=
    hcollapse.trans (Adjunction.homEquiv_counit (restrictAdjunction f) _ _
      (SheafOfModules.unitToPushforwardObjUnit f.toRingCatSheafHom))
  apply Iso.ext
  simp only [Functor.mapIso_hom, Iso.trans_hom]
  refine Eq.trans (congrArg (SheafOfModules.forget Y.ringCatSheaf).map hmor) ?_
  -- Split `forget` over the composite at the (more tractable) presheaf level (term mode: the
  -- `SheafOfModules ≫` seam makes a keyed `rw [map_comp]` fail to form the motive).
  refine Eq.trans ((SheafOfModules.forget Y.ringCatSheaf).map_comp _ _) ?_
  -- STEP 2 (section value).  The goal is now
  --   `forget ((restrictFunctor f).map (unitToPushforwardObjUnit φ) ≫
  --       (restrictAdjunction f).counit.app 𝟙_Y) = q.hom`.
  -- Reduce sectionwise at `(V, y)` and identify the carrier with `(f.appIso V).hom` (= RHS by the
  -- linchpin).  `restrictFunctor f = pushforward β` (same β as the linchpin), so its map on
  -- `unitToPushforwardObjUnit` reindexes the structure ring map across `f.opensFunctor`, and the
  -- restrictAdjunction counit is an `eqToHom` structure restriction; together they reconstruct
  -- `(f.appIso V).hom`, exactly mirroring `presheafDualUnitIso_naturality`.
  apply PresheafOfModules.hom_ext
  intro V
  apply ModuleCat.hom_ext
  apply LinearMap.ext
  intro y
  refine Eq.trans ?_ (pushforwardBetaUnitEpsAppOne f V y).symm
  simp only [SheafOfModules.forget_map, PresheafOfModules.comp_app,
    ModuleCat.hom_comp, LinearMap.comp_apply]
  -- Leg 1 (`restrictFunctor.map = pushforward β .map`): reindex the unit-comparator across
  -- `f.opensFunctor` and read its structure-ring value `φ.hom.app (f ''ᵁ V)`.
  erw [PresheafOfModules.pushforward_map_app_apply,
    SheafOfModules.unitToPushforwardObjUnit_val_app_apply]
  -- Leg 2: the restrictAdjunction counit at the unit is (definitionally) the structure restriction
  -- along the topological-adjunction unit `f⁻¹ᵁ(f ''ᵁ V) = V`.
  erw [SheafOfModules.pushforwardPushforwardAdj_counit_app_val_app]
  -- Pure structure-sheaf identity.  `appIso_hom` expands the RHS as `f.app (f ''ᵁ V) ≫ restriction`;
  -- the LHS ring map `φ.hom.app (f ''ᵁ V)` is `f.app (f ''ᵁ V)`, and the two restriction maps (the
  -- topological-adjunction unit vs the `preimage_image_eq` `eqToHom`) agree (Opens homs are unique).
  rw [Scheme.Hom.appIso_hom]
  -- The two restriction maps `V → f⁻¹ᵁ(f ''ᵁ V)` agree (Opens homs are unique); the structure ring
  -- map `φ.hom.app` is `f.app` and `(unit Y).val.map` is `Y.presheaf.map`, both definitionally.
  have hops : (f.isOpenEmbedding.isOpenMap.adjunction).unit.app (Opposite.unop V)
      = eqToHom (f.preimage_image_eq (Opposite.unop V)).symm := Subsingleton.elim _ _
  rw [hops, CommRingCat.comp_apply]
  rfl

/-- **Generic adjunction unit/counit collapse.**  For `adj : L ⊣ R` and `g : L.obj P ⟶ B`,
sheafifying the composite of the unit at `P` with `R.map g` and post-composing the counit at `B`
recovers `g`: `L.map (adj.unit.app P ≫ R.map g) ≫ adj.counit.app B = g`.  Pure category algebra
(`map_comp` → counit naturality → left triangle).  Stated abstractly so it crosses the
`SheafOfModules` seam by `exact` (defeq) rather than a keyed `rw`. -/
private lemma adj_unit_counit_collapse {C D : Type*} [Category C] [Category D]
    {L : C ⥤ D} {R : D ⥤ C} (adj : L ⊣ R) {P : C} {B : D} (g : L.obj P ⟶ B) :
    L.map (adj.unit.app P ≫ R.map g) ≫ adj.counit.app B = g := by
  rw [show adj.unit.app P ≫ R.map g = adj.homEquiv P B g from (adj.homEquiv_unit P B g).symm]
  exact (adj.homEquiv_counit P B (adj.homEquiv P B g)).symm.trans
    (Equiv.symm_apply_apply (adj.homEquiv P B) g)

/-- **RES2 L1 (blueprint `lem:pullback_val_iso_unit_factor`)**: the unit pullback identification
`pullbackValIso f 𝟙_X` factors, on the nose, as the inverse `sheafificationCompPullback` comparison
at the unit presheaf followed by the sheaf pullback of the `X`-sheafification counit at the unit.
This is the unit instance of the template factorisation `hpbv` of `sheafPullbackUnit_forget_eq`
(L647–653). -/
private lemma pullbackValIso_unit_factor {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] :
    (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).hom
      = (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).inv.app
            (SheafOfModules.unit X.ringCatSheaf).val
        ≫ (Scheme.Modules.pullback f).map
            ((asIso (PresheafOfModules.sheafificationAdjunction
              (𝟙 X.ringCatSheaf.val)).counit).hom.app (SheafOfModules.unit X.ringCatSheaf)) := by
  rw [pullbackValIso, Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom]
  rfl

set_option backward.isDefEq.respectTransparency false in
/-- **RES2 L2 (blueprint `lem:presheaf_pullback_unit_iso_sheafify_reconcile`, the concentrated
mate-calculus)**: sheafifying the presheaf pullback-unit comparator `p = presheafPullbackUnitIso f`
and cancelling the `Y`-sheafification counit reproduces the sheaf pullback identification
`pullbackValIso f 𝟙_X` followed by the sheaf pullback-unit iso `pullbackUnitIso f`.

Proven WITHOUT a transpose.  The presheaf comparator factors, on the nose,
```
p.hom = η_Y ≫ forget (pullbackValIso f 𝟙_X ≫ pullbackUnitIso f)    -- (†)
```
SEAM: the `simp only [presheafPullbackUnitIso]` unfold of the comparator def leaves the goal
ill-typed under `instances` transparency, so the `Category.assoc`/`map_comp` bookkeeping is run with
`backward.isDefEq.respectTransparency false`.

via the H1-reconciliation `H1inv_app_eq_pullbackVal_restrict` (which writes `H1.inv` as the
sheafification unit, the forgotten `pullbackValIso`, and the forgotten inverse `restrictFunctorIsoPullback`)
together with RES1 `forgetUnitRestrict_eq_pushforwardUnit` (which writes `q = presheafPushforwardUnitIso f`
as the forgotten `restrictFunctorIsoPullback ≫ pullbackUnitIso`); the two `restrictFunctorIsoPullback`
legs cancel.  Sheafifying (†) and applying the sheafification-counit naturality at the forgotten sheaf
composite followed by the left-triangle identity collapses the whole left-hand side. -/
private lemma presheafPullbackUnitIso_sheafify_reconcile {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] :
    (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
        (presheafPullbackUnitIso f).hom
      ≫ (asIso (PresheafOfModules.sheafificationAdjunction
          (𝟙 Y.ringCatSheaf.val)).counit).hom.app (SheafOfModules.unit Y.ringCatSheaf)
      = (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).hom ≫ (pullbackUnitIso f).hom := by
  -- (†) presheaf-level factorisation of `p.hom`.
  have hp : (presheafPullbackUnitIso f).hom
      = (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.val)).unit.app
          ((PresheafOfModules.pullback f.toRingCatSheafHom.hom).obj
            (SheafOfModules.unit X.ringCatSheaf).val)
        ≫ (SheafOfModules.forget Y.ringCatSheaf).map
            ((pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).hom
              ≫ (pullbackUnitIso f).hom) := by
    simp only [presheafPullbackUnitIso, Iso.trans_hom, Iso.symm_hom, Iso.app_inv]
    erw [H1inv_app_eq_pullbackVal_restrict f (SheafOfModules.unit X.ringCatSheaf)]
    -- `forget(RFIP⁻¹) ≫ q.hom = forget(pbU)` (RES1: `q = forget(RFIP ≪≫ pbU)`, the `RFIP` legs cancel).
    have hqid : (SheafOfModules.forget Y.ringCatSheaf).map
          ((restrictFunctorIsoPullback f).app (SheafOfModules.unit X.ringCatSheaf)).inv
        ≫ (presheafPushforwardUnitIso f).hom
      = (SheafOfModules.forget Y.ringCatSheaf).map (pullbackUnitIso f).hom := by
      have hq : (presheafPushforwardUnitIso f).hom
          = (SheafOfModules.forget Y.ringCatSheaf).map
              ((restrictFunctorIsoPullback f).app (SheafOfModules.unit X.ringCatSheaf)).hom
            ≫ (SheafOfModules.forget Y.ringCatSheaf).map (pullbackUnitIso f).hom := by
        rw [← forgetUnitRestrict_eq_pushforwardUnit f, Functor.mapIso_hom, Iso.trans_hom,
          Functor.map_comp]
      rw [hq, ← Category.assoc, ← Functor.mapIso_inv, ← Functor.mapIso_hom, Iso.inv_hom_id,
        Category.id_comp]
    rw [Category.assoc, Category.assoc, hqid, Functor.map_comp]
  -- Sheafify (†); the generic collapse (counit naturality + left triangle) finishes.
  rw [hp, asIso_hom]
  exact adj_unit_counit_collapse (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
    (𝟙 Y.ringCatSheaf.val)) ((pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).hom
      ≫ (pullbackUnitIso f).hom)

set_option backward.isDefEq.respectTransparency false in
/-- **RES2 / the unit-only core `(*)`: the sheaf pullback-unit comparator sheafifies the presheaf
pullback-unit comparator `p`.**  Threading the sheafification counit `cuX` over `X`, the sheaf-level
pullback unit iso `pullbackUnitIso f` reconciles with `sheafificationCompPullback`,
`presheafPullbackUnitIso f` and the counit `cuY` over `Y`.  This is the genuine unit-side
reconciliation of the dual-unit naturality square (no dual factor remains).

iter-102: REWRITTEN via the effort-breaker decomposition — `presheafPullbackUnitIso_sheafify_reconcile`
(L2) rewrites the right-hand comparator leg, `pullbackValIso_unit_factor` (L1) expands the
`pullbackValIso`, and the leading `sheafificationCompPullback` hom/inv legs cancel.  All seam-crossing
mate-calculus is confined to L2. -/
private lemma pullbackUnit_sheafify_reconcile {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] :
    (pullback f).map
        ((asIso (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.val)).counit).hom.app
          (SheafOfModules.unit X.ringCatSheaf))
        ≫ (pullbackUnitIso f).hom
      = (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.app
            (SheafOfModules.unit X.ringCatSheaf).val
        ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
            (presheafPullbackUnitIso f).hom
        ≫ (asIso (PresheafOfModules.sheafificationAdjunction (𝟙 Y.ringCatSheaf.val)).counit).hom.app
            (SheafOfModules.unit Y.ringCatSheaf) := by
  -- L2 rewrites the right-hand comparator leg `SY.map p.hom ≫ cuY.app 𝟙_Y` to
  -- `pullbackValIso ≫ pullbackUnitIso` (term-mode `congrArg`, the composite `≫` does not match a
  -- keyed `rw` across the `SheafOfModules` seam); L1 then expands the `pullbackValIso`; the leading
  -- `sheafificationCompPullback` hom/inv legs cancel by `Iso.hom_inv_id_app`, leaving the LHS.
  refine Eq.trans ?_ (congrArg
    ((SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.app
      (SheafOfModules.unit X.ringCatSheaf).val ≫ ·) (presheafPullbackUnitIso_sheafify_reconcile f)).symm
  rw [pullbackValIso_unit_factor f, Category.assoc, Iso.hom_inv_id_app_assoc]

/-- **L2′ (blueprint `lem:dual_unit_iso_restrict_assemble`): SCP/sheafify assembly of the
dual-unit naturality square along an open immersion `f : Y ⟶ X`.**

The bare dual-restriction comparison `dual_restrict_iso f (𝒪_X)` intertwines the two
dual-unit contractions with the unit-restriction iso `unitRestrictIso f`:
```
(restrict f) dual_unit_iso_X ≪≫ unitRestrictIso f
  = dual_restrict_iso f 𝒪_X ≪≫ (dualIsoOfIso (unitRestrictIso f)).symm ≪≫ dual_unit_iso_Y
```
Proof plan (per effort-breaker `s4a-thetaunit`): dual-B1 factorisation
(`dual_restrict_iso_eq_comparison`) exposes `RFIP_f ; SCP_f ; sheafify θ_{f,𝒪_X}`; the θ-leg is
identified at the structure-sheaf unit by **L1′** (`presheafDualUnitIso_pullback_natural`); the
`RFIP;SCP` prefix is matched by bridge (b) (same SCP seam as S3); counit naturality +
`dualIsoOfIso` functoriality fold the rest. -/
private lemma dual_unit_iso_restrict_assemble {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] :
    (restrictFunctor f).mapIso (dual_unit_iso (Y := X))
        ≪≫ unitRestrictIso f
      = dual_restrict_iso f (SheafOfModules.unit X.ringCatSheaf)
          ≪≫ (dualIsoOfIso (unitRestrictIso f)).symm
          ≪≫ dual_unit_iso (Y := Y) := by
  -- STEP-B idiom (as in `dual_restrict_iso_comp`/S3): drop to the `.hom` level and flatten every
  -- `≪≫`/`.mapIso`/`.symm` into a single right-associated `≫`-chain.  The `simp only` is purely
  -- syntactic (`Iso.trans_hom`, `Functor.mapIso_hom`, `Iso.symm_hom`, `Iso.app_hom`) plus the three
  -- definitional unfolds `dual_unit_iso`, `unitRestrictIso`, `dual_restrict_iso_eq_comparison`.
  apply Iso.ext
  simp only [Iso.trans_hom, Functor.mapIso_hom, Iso.symm_hom, Iso.app_hom, dual_unit_iso,
    unitRestrictIso, dual_restrict_iso_eq_comparison]
  -- EXPOSED RESIDUAL (`.hom`-level, verified via LSP `lean_goal`), abbreviating
  --   SX/SY  = `sheafification (𝟙 _)` over X resp. Y,   pdX/pdY = `presheafDualUnitIso` over X/Y,
  --   cuX/cuY = sheafification counit at the unit,        RF = `restrictFunctor f` (= sheaf pushforward),
  --   RFIP   = `restrictFunctorIsoPullback f`,            SCP = `sheafificationCompPullback f`,
  --   θ      = `presheafDualPullbackComparison f 𝒪_X`,    u = `unitRestrictIso f`,  pbU = `pullbackUnitIso f`:
  --
  --   LHS  RF.map (SX.map pdX.hom ≫ cuX.app 𝒪_X) ≫ RFIP.app 𝒪_X ≫ pbU.hom
  --   RHS  (RFIP.app (dual 𝒪_X) ≫ SCP.app 𝒪_X.val.dual ≫ SY.map θ.hom)
  --          ≫ (dualIsoOfIso u).inv ≫ SY.map pdY.hom ≫ cuY.app 𝒪_Y.
  --
  -- This is the dual-unit naturality square along `f`.  Closing it follows the STEP-B route: build
  -- the seam-crossing facts as term-mode `have`s and discharge the pure `≫`-bookkeeping by `exact`
  -- on a generic single-`[Category]` assemble lemma (no `sheafify`-colimit whnf).  The constituent
  -- seam facts are:
  --   (b)  bridge-(b) SCP at the structure presheaf 𝒪_X.val.dual — same seam as S3's `ha2`;
  --   (ct) counit naturality `SX.map (·) ≫ cu = cu ≫ (·)` slid through RF and at 𝒪_Y;
  --   (du) `(dualIsoOfIso u).inv = SY.map (PresheafOfModules.dualIsoOfIso (forget.mapIso u)).inv`
  --        (def of `dualIsoOfIso`), grouping it with `SY.map θ.hom` and `SY.map pdY.hom` under one
  --        `SY.map (…)` via `← Functor.map_comp`;
  --   (★)  **L1′ — the genuine new presheaf core**: under `SY.map`, the composite
  --          `θ.hom ≫ (PresheafOfModules.dualIsoOfIso (forget.mapIso u)).inv ≫ pdY.hom`
  --        equals the `f`-pullback of `pdX.hom` post-composed with the *presheaf* pullback-unit
  --        comparison.  This is the unit-evaluation of the proven θ-naturality
  --        `presheafDual_pullback_restrict_natural` + `presheafDualUnitIso_naturality`, read through
  --        `internalHomEval`/`evalLin` at `1`.
  --
  -- iter-099 UPDATE: the iter-085 BLOCKER above is RESOLVED.  The presheaf pullback-unit comparison
  -- `p = presheafPullbackUnitIso f` and the pushforward comparator `q = presheafPushforwardUnitIso f`
  -- now exist (`PresheafDualUnitPullback.lean`), and L1′ (★) is PROVEN sorry-free as
  -- `presheafDualUnitIso_pullback_natural f`.  We bring it into scope at hom level and sheafify it.
  have hL1'h := congrArg Iso.hom (presheafDualUnitIso_pullback_natural f)
  simp only [Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom] at hL1'h
  -- `hL1'h : θ.hom ≫ (PresheafOfModules.dualIsoOfIso q).inv ≫ pdY.hom
  --            = (pullback φR).map pdX.hom ≫ p.hom`  (presheaf level).
  -- Unfold the sheaf-level `dualIsoOfIso u` to its presheaf core under `SY`
  -- (`(dualIsoOfIso u).inv = SY.map (PresheafOfModules.dualIsoOfIso (forget.mapIso u)).inv`):
  -- this lands the dual flank `SY.map θ.hom ≫ SY.map (dualIsoOfIso (forget u)).inv ≫ SY.map pdY.hom`.
  simp only [dualIsoOfIso, Functor.mapIso_inv]
  -- OUTER ASSEMBLY.  The square is `a ≫ r1 ≫ pbu = (rD ≫ X) ≫ Y` with the seam-crossing facts
  -- `hnat` (`restrictFunctorIsoPullback`-naturality at the contracted unit) and `hcore`.
  refine unit_assemble ((pullback f).map (dual_unit_iso (Y := X)).hom) ?hnat ?hcore
  · -- `hnat`: naturality of `RFIP : restrictFunctor f ≅ pullback f` at `dual_unit_iso_X.hom`.
    exact (restrictFunctorIsoPullback f).hom.naturality (dual_unit_iso (Y := X)).hom
  · -- `hcore`: reduce via the four seam facts to the unit-only reconciliation `(*)`.
    -- `hsplit`: functoriality of the sheaf pullback on the contracted unit (`SX.map pdX ≫ cuX`).
    have hsplit : (pullback f).map (dual_unit_iso (Y := X)).hom
        = (pullback f).map ((PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)).map
              (presheafDualUnitIso (Y := X)).hom)
          ≫ (pullback f).map ((asIso (PresheafOfModules.sheafificationAdjunction
              (𝟙 X.ringCatSheaf.val)).counit).hom.app (SheafOfModules.unit X.ringCatSheaf)) :=
      Functor.map_comp (pullback f) _ _
    -- `hflank`: the sheafified L1′ dual-flank fold (RES1 turns `dualIsoOfIso (forget u)` into
    -- `dualIsoOfIso q`, then `hL1'h` collapses the presheaf composite).
    have hflank : (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
            (presheafDualPullbackComparison f (SheafOfModules.unit X.ringCatSheaf)).hom
          ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
              (PresheafOfModules.dualIsoOfIso ((SheafOfModules.forget Y.ringCatSheaf).mapIso
                ((restrictFunctorIsoPullback f).app (SheafOfModules.unit X.ringCatSheaf)
                  ≪≫ pullbackUnitIso f))).inv
          ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
              (presheafDualUnitIso (Y := Y)).hom
        = (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
              ((PresheafOfModules.pullback f.toRingCatSheafHom.hom).map
                (presheafDualUnitIso (Y := X)).hom)
          ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
              (presheafPullbackUnitIso f).hom := by
      rw [forgetUnitRestrict_eq_pushforwardUnit f, ← Functor.map_comp, ← Functor.map_comp]
      -- `rw [hL1'h]` under `SY.map` chokes on the v4.31 `Sheaf.val` instances-transparency seam, so
      -- apply `hL1'h` in TERM mode (`congrArg`) and unfold the resulting `SY.map` of a composite.
      exact (congrArg (fun m => (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
        (𝟙 Y.ringCatSheaf.val)).map m) hL1'h).trans (Functor.map_comp _ _ _)
    -- `hscp`: `sheafificationCompPullback` naturality at the presheaf dual-unit map `pdX`.
    have hscp := ((SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.naturality
      (presheafDualUnitIso (Y := X)).hom).symm
    exact hcore_assemble hsplit hflank hscp (pullbackUnit_sheafify_reconcile f)

/-- **S4a (blueprint `lem:dual_unit_iso_restrict_compat`): `dual_unit_iso` commutes with further
restriction along the chart `j`.** Modulo the unit-restriction identification `unitRestrictIso j`
and its `dualIsoOfIso`-image, the `V`-built dual-unit contraction equals the `restrict j`-image of
the `U`-built one.  Template: `presheafDualUnitIso_naturality` (the unit-side naturality core). -/
private lemma dual_unit_iso_restrict_compat {X : Scheme.{u}} {U V : X.Opens}
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (_hjι : j ≫ U.ι = V.ι) :
    dual_unit_iso (Y := (V : Scheme))
      = dualIsoOfIso (unitRestrictIso j)
          ≪≫ (dual_restrict_iso j (SheafOfModules.unit (U : Scheme).ringCatSheaf)).symm
          ≪≫ (restrictFunctor j).mapIso (dual_unit_iso (Y := (U : Scheme)))
          ≪≫ unitRestrictIso j := by
  -- Pure folded iso-algebra from the L2′ assembly square (`dual_unit_iso_restrict_assemble`):
  -- rewriting the trailing `(restrict j) dual_unit_iso_U ≪≫ unitRestrictIso j` by L2′ exposes the
  -- adjacent inverse pairs `(dual_restrict_iso j 𝒪_U).symm ≪≫ dual_restrict_iso j 𝒪_U` and
  -- `dualIsoOfIso(unitRestrictIso j) ≪≫ (dualIsoOfIso(unitRestrictIso j)).symm`, both of which
  -- telescope away, leaving `dual_unit_iso_V` on each side.
  rw [dual_unit_iso_restrict_assemble j, Iso.symm_self_id_assoc, Iso.self_symm_id_assoc]

/-- **Bridge: the unit self-tensor contraction is the left unitor at the unit.**
`tensorObj_unit_iso` and `tensorObj_left_unitor 𝒪` are both
`sheafification.mapIso (presheaf left unitor at 𝟙_) ≪≫ counit`, with the presheaf left unitor
`λ_ 𝟙_` of `tensorObj_unit_iso` definitionally the `monoidalCategoryStruct.leftUnitor 𝒪.val`
of `tensorObj_left_unitor` (since `𝒪.val = 𝟙_`). -/
private lemma tensorObj_unit_iso_eq_left_unitor {X : Scheme.{u}} :
    tensorObj_unit_iso (X := X)
      = tensorObj_left_unitor (SheafOfModules.unit X.ringCatSheaf) := by
  unfold tensorObj_unit_iso tensorObj_left_unitor
  rfl

/-- **Naturality of the substrate left unitor `𝒪_W ⊗ (-) ≅ (-)`.**  For `g : M ≅ M'` in
`W.Modules`, tensoring `g` on the right of the unit and contracting equals contracting then `g`:
`tensorObjIsoOfIso (𝟙 𝒪_W) g ≪≫ left_unitor M' = left_unitor M ≪≫ g`.  Both contractions are
`sheafification.mapIso (presheaf λ) ≪≫ counit`; the inner seam is the presheaf left-unitor
naturality `(𝟙_ ◁ ĝ) ≫ λ_ M' = λ_ M ≫ ĝ` and the outer seam is sheafification-counit naturality
(same idiom as `dualUnitIso_dualIsoOfIso`). -/
private lemma tensorObj_left_unitor_naturality {W : Scheme.{u}} {M M' : W.Modules} (g : M ≅ M') :
    tensorObjIsoOfIso (Iso.refl (SheafOfModules.unit W.ringCatSheaf)) g
        ≪≫ tensorObj_left_unitor M'
      = tensorObj_left_unitor M ≪≫ g := by
  apply Iso.ext
  -- Inner presheaf left-unitor naturality, stated in the syntactic monoidal carrier
  -- `PresheafOfModules (W.presheaf ⋙ forget₂)` (mirrors `tensorObjIsoOfIso_comp_unit_iso`'s `hpre`),
  -- proved by `leftUnitor_naturality` modulo `id_tensorHom` and the `𝟙_ = 𝒪.val` defeq.
  have hpre : MonoidalCategory.tensorHom
        (C := _root_.PresheafOfModules (W.presheaf ⋙ forget₂ CommRingCat RingCat))
        (𝟙 ((SheafOfModules.forget W.ringCatSheaf).obj (SheafOfModules.unit W.ringCatSheaf)))
        ((SheafOfModules.forget W.ringCatSheaf).map g.hom)
      ≫ ((PresheafOfModules.monoidalCategoryStruct (R := W.presheaf)).leftUnitor M'.val).hom
      = ((PresheafOfModules.monoidalCategoryStruct (R := W.presheaf)).leftUnitor M.val).hom
        ≫ (SheafOfModules.forget W.ringCatSheaf).map g.hom := by
    exact MonoidalCategory.leftUnitor_naturality _
  simp only [tensorObjIsoOfIso, tensorObj_left_unitor, Iso.trans_hom, Functor.mapIso_hom,
    MonoidalCategory.tensorIso_hom, Functor.mapIso_refl, Iso.refl_hom, Category.assoc]
  -- Combine the two sheafification legs, rewrite by the inner seam `hpre`, split, then close with
  -- sheafification-counit naturality at `g.hom` (same idiom as `dualUnitIso_dualIsoOfIso`).
  rw [← Category.assoc]
  erw [← Functor.map_comp, hpre, Functor.map_comp, Category.assoc]
  erw [(PresheafOfModules.sheafificationAdjunction (𝟙 W.ringCatSheaf.val)).counit.naturality g.hom]
  rfl

/-- **Cone A bridge 1 (η mate-identification).** The sheaf-level unit comparison `pullbackUnitIso f`
is the sheafification of the presheaf-level oplax unit `η (pullback φ')`, conjugated by `pullbackValIso`
on the source and `sheafifyUnitIso` on the target.  This is the proven `pullbackEtaUnitSquare f`
rearranged: `(pullbackUnitIso f).hom` is definitionally `pullbackObjUnitToUnit f.toRingCatSheafHom`. -/
private lemma pullbackUnitIso_eq_sheafify_eta {X Y : Scheme.{u}} (f : Y ⟶ X) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    (pullbackUnitIso f).hom
      = (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).inv ≫
          (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
            (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')) ≫ sheafifyUnitIso.hom := by
  exact (pullbackEtaUnitSquare f).symm

/-- **Cone A bridge 2 (δ mate-identification).** Definitional unfolding of `pullbackTensorMap`: it is
the sheafification of the presheaf-level oplax cotensorator `δ (pullback φ')`, conjugated by the
`sheafificationCompPullback` device, `sheafifyTensorUnitIso`, and the two `pullbackValIso`s. -/
private lemma pullbackTensorMap_eq_sheafify_delta {X Y : Scheme.{u}} (f : Y ⟶ X) (M N : X.Modules) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    pullbackTensorMap f M N
      = (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.app
            (PresheafOfModules.Monoidal.tensorObj M.val N.val)
          ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
              (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ') M.val N.val)
          ≫ (sheafifyTensorUnitIso (X := Y)
              ((PresheafOfModules.pullback φ').obj M.val)
              ((PresheafOfModules.pullback φ').obj N.val)).hom
          ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
              (MonoidalCategory.tensorHom
                (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
                ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
                ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom)) :=
  rfl

/-- **Naturality of `pullbackValIso f` against a sheaf morphism.**  `pullbackValIso f`, as `M`
varies, is the natural isomorphism `(forget ⋙ F ⋙ a_Y) ≅ pullback f` (`F = pullback φ'`); hence for
any `g : M ⟶ N` in `X.Modules` the square
`(pbv M).hom ≫ f^*g = a_Y.map (F.map g.val) ≫ (pbv N).hom` commutes.  Proved by unfolding
`pullbackValIso` into its two natural legs (`sheafificationCompPullback` and the sheafification
counit) and chaining their naturalities (counit naturality at `g`, `sheafificationCompPullback`
inverse naturality at `g.val`).  The reusable atom underlying the RHS reconciliation
`pullbackValIso_naturality_leftUnitor` (Cone A sub-lemma 1). -/
private lemma pullbackValIso_naturality {X Y : Scheme.{u}} (f : Y ⟶ X) {M N : X.Modules}
    (g : M ⟶ N) :
    (pullbackValIso f M).hom ≫ (pullback f).map g
      = (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
          ((PresheafOfModules.pullback (f.toRingCatSheafHom).hom).map
            ((SheafOfModules.forget X.ringCatSheaf).map g))
        ≫ (pullbackValIso f N).hom := by
  rw [pullbackValIso, pullbackValIso]
  simp only [Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom, Category.assoc]
  -- LHS = scp.inv.app M.val ≫ f^*(counit.app M) ≫ f^*g ; merge the two f^* legs (`erw` over the
  -- `SheafOfModules ≫` seam), push the counit past `g` by counit naturality, re-split.
  erw [← Functor.map_comp,
    ← (PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
      (𝟙 X.ringCatSheaf.val)).counit.naturality g,
    Functor.map_comp]
  -- Now LHS = scp.inv.app M.val ≫ f^*(a_X.map g.val) ≫ f^*(counit.app N); slide scp.inv past
  -- `a_X.map g.val` by inverse naturality of `sheafificationCompPullback`.  `hkey` is that
  -- naturality square stated in the goal's exact syntax (the `≫`-seam/`Iso.app`/`restrictScalars 𝟙`
  -- defeqs are absorbed by the term-mode `exact`).
  have hkey :
      ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app M.val).inv ≫
        (pullback f).map
          (((SheafOfModules.forget X.ringCatSheaf ⋙
                PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.val)) ⋙
              PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)).map g)
        = (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
            ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).map
              ((SheafOfModules.forget X.ringCatSheaf).map g)) ≫
          ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app N.val).inv :=
    ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).inv.naturality
      ((SheafOfModules.forget X.ringCatSheaf).map g)).symm
  -- Reassociate term-mode (the messy middle object has two non-syntactic forms, so `rw`-reassoc
  -- and `reassoc_of%` both miss; `congrArg`/`Category.assoc` as terms absorb the defeq).
  exact (Category.assoc _ _ _).symm.trans ((congrArg (· ≫ _) hkey).trans (Category.assoc _ _ _))

/-- **Cone A sub-lemma 1 (`lem:pullback_val_iso_naturality_left_unitor`): RHS reconciliation.**
The naturality of `pullbackValIso f` against the sheaf left-unitor morphism
`(tensorObj_left_unitor M).hom : 𝒪_X ⊗ M ⟶ M`, i.e. the blueprint identity
`(pbv_{𝒪⊗M}).hom ≫ f^*(λ^sheaf_M) = a_Y.map (F.map (λ^sheaf_M).val) ≫ (pbv_M).hom`
(the blueprint's `F.map λ_{M.val}` is, at the Lean level, `F.map` of the *sheaf* unitor's underlying
presheaf morphism — the inner sheafification is already folded into `(tensorObj_left_unitor M).hom`).
A direct specialisation of the reusable atom `pullbackValIso_naturality`. -/
private lemma pullbackValIso_naturality_leftUnitor {X Y : Scheme.{u}} (f : Y ⟶ X) (M : X.Modules) :
    (pullbackValIso f (tensorObj (SheafOfModules.unit X.ringCatSheaf) M)).hom
        ≫ (pullback f).map (tensorObj_left_unitor M).hom
      = (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
          ((PresheafOfModules.pullback (f.toRingCatSheafHom).hom).map
            ((SheafOfModules.forget X.ringCatSheaf).map (tensorObj_left_unitor M).hom))
        ≫ (pullbackValIso f M).hom :=
  pullbackValIso_naturality f (tensorObj_left_unitor M).hom

/-- **Cone A sub-lemma 1′ (RHS reconciliation, assembly form).**  The `f^*`-image of the sheaf
left unitor at `M`, expressed through the `sheafificationCompPullback` comparison and the sheafified
*presheaf* left unitor `λ_{M.val}`:
`f^*(λ^sheaf_M) = scp.hom.app(𝟙_⊗M.val) ≫ a_Y.map (F.map λ_{M.val}) ≫ (pbv_M).hom`.
This is the form the bridge-3 assembly consumes (the `scp.hom` head matches the leading
`sheafificationCompPullback` factor of `pullbackTensorMap`); proved by unfolding
`tensorObj_left_unitor`, replacing `f^*(counit)` by `scp.hom ≫ pbv_M` and sliding `scp.hom` past
`a_X.map λ` by `sheafificationCompPullback` naturality. -/
private lemma pullback_map_tensorObj_left_unitor_eq {X Y : Scheme.{u}} (f : Y ⟶ X) (M : X.Modules) :
    (pullback f).map (tensorObj_left_unitor M).hom
      = (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.app
            (PresheafOfModules.Monoidal.tensorObj (SheafOfModules.unit X.ringCatSheaf).val M.val)
        ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
            ((PresheafOfModules.pullback (f.toRingCatSheafHom).hom).map
              ((PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).leftUnitor M.val).hom)
        ≫ (pullbackValIso f M).hom := by
  rw [tensorObj_left_unitor]
  simp only [Iso.trans_hom, Functor.mapIso_hom, asIso_hom, Iso.app_hom, Category.assoc]
  -- `f^*(λ^sheaf) = f^*(a_X.map λ) ≫ f^*(counit)`.
  erw [Functor.map_comp]
  -- `f^*(counit_M) = scp.hom.app M.val ≫ (pbv_M).hom`  (cancel `scp.hom ≫ scp.inv`).
  have hc : (pullback f).map
        ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
          (𝟙 X.ringCatSheaf.val)).counit.app M)
      = (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.app M.val
          ≫ (pullbackValIso f M).hom := by
    rw [pullbackValIso, Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom]
    exact Eq.symm (Iso.hom_inv_id_app_assoc _ _ _)
  -- `scp.hom.app M.val` slides past `f^*(a_X.map λ)` by `sheafificationCompPullback` naturality.
  have hnat := (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom.naturality
    ((PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).leftUnitor M.val).hom
  erw [hc]
  exact (Category.assoc _ _ _).symm.trans
    ((congrArg (· ≫ (pullbackValIso f M).hom) hnat).trans (Category.assoc _ _ _))

/-- **Split a `tensorObjIsoOfIso` into its two single-leg factors.**
`tensorObjIsoOfIso e e' = tensorObjIsoOfIso e (𝟙) ≪≫ tensorObjIsoOfIso (𝟙) e'`. -/
private lemma tensorObjIsoOfIso_eq_comp {X : Scheme.{u}} {M M' N N' : X.Modules}
    (e : M ≅ M') (e' : N ≅ N') :
    tensorObjIsoOfIso e e'
      = tensorObjIsoOfIso e (Iso.refl N) ≪≫ tensorObjIsoOfIso (Iso.refl M') e' := by
  rw [← tensorObjIsoOfIso_trans, Iso.trans_refl, Iso.refl_trans]

set_option maxHeartbeats 1600000 in
/-- **STU-collapse: the sheaf left unitor at an image object (`lem:tensorobj_left_unitor_image_collapse`).**
At the sheafification `a.obj P` of a presheaf of modules `P`, the sheaf-level left unitor collapses,
modulo the tensor comparison `μ = sheafifyTensorUnitIso` and the unit comparison
`ε = sheafifyUnitIso`, to the sheafified presheaf left unitor `a.map λ_P`:
`μ_{𝟙,P} ≫ (ε ▷ a.obj P) ≫ (tensorObj_left_unitor (a.obj P)) = a.map λ_P`.
This is the shared structural residual of `tensorObj_left_unitor_pullback_eq_sheafify` (L2) and the
central-leg step of `pullbackUnitIso_whisker_eq_sheafify_eta_whisker` (L3-3a).  Proved by reducing to
the presheaf-level identity `(η_𝟙 ⊗ η_P) ≫ (ε ⊗ 𝟙) ≫ λ_{a P} = λ_P ≫ η_P` (bifunctoriality + the
adjunction right-triangle `η_𝟙 ≫ ε = 𝟙` + presheaf left-unitor naturality), then cancelling the
counit by the adjunction left-triangle. -/
private lemma tensorObj_left_unitor_image_collapse {Y : Scheme.{u}}
    (P : _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) :
    (sheafifyTensorUnitIso (X := Y)
          (𝟙_ (_root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))) P).hom
        ≫ (tensorObjIsoOfIso (sheafifyUnitIso (Y := Y))
            (Iso.refl ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
              (𝟙 Y.ringCatSheaf.val)).obj P))).hom
        ≫ (tensorObj_left_unitor ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.val)).obj P)).hom
      = (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
          ((PresheafOfModules.monoidalCategoryStruct (R := Y.presheaf)).leftUnitor P).hom := by
  rw [sheafifyTensorUnitIso_hom_eq', tensorObjIsoOfIso_hom, tensorObj_functoriality,
    tensorObj_left_unitor]
  simp only [Iso.trans_hom, Functor.mapIso_hom, asIso_hom, Iso.app_hom]
  -- Presheaf-level collapse identity (★★): `(A ≫ B) ≫ C = D ≫ η_P`.
  have hpre :
      (MonoidalCategory.tensorHom
          (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
          ((PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.val)).unit.app
            (𝟙_ (_root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))))
          ((PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.val)).unit.app P)
        ≫ MonoidalCategory.tensorHom
            (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
            ((sheafifyUnitIso (Y := Y)).hom.val)
            ((Iso.refl ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
              (𝟙 Y.ringCatSheaf.val)).obj P)).hom.val))
        ≫ ((PresheafOfModules.monoidalCategoryStruct (R := Y.presheaf)).leftUnitor
            ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
              (𝟙 Y.ringCatSheaf.val)).obj P).val).hom
      = ((PresheafOfModules.monoidalCategoryStruct (R := Y.presheaf)).leftUnitor P).hom
        ≫ (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.val)).unit.app P := by
    have htri : (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.val)).unit.app
            (𝟙_ (_root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)))
          ≫ (sheafifyUnitIso (Y := Y)).hom.val
        = 𝟙 _ := by
      rw [sheafifyUnitIso]
      -- axis-9: `simpa … using` closes with reducible-transparency isDefEq, which fails on the
      -- v4.31 `(forget ⋙ restrictScalars 𝟙).obj (unit) ≡ 𝟙_` unit-object spelling; split into
      -- `have … ; simp only … at h ; exact h` so the bare `exact` uses default-transparency defeq.
      have h := (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
          (𝟙 Y.ringCatSheaf.val)).right_triangle_components (SheafOfModules.unit Y.ringCatSheaf)
      simp only [Iso.app_hom, asIso_hom] at h ⊢
      exact h
    simp only [Iso.refl_hom, SheafOfModules.id_val]
    rw [MonoidalCategory.tensorHom_comp_tensorHom, ← MonoidalCategory.leftUnitor_naturality]
    congr 1
    exact congrArg₂ (fun a b => MonoidalCategory.tensorHom
      (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) a b)
      htri (Category.comp_id _)
  erw [← Functor.map_comp_assoc, ← Functor.map_comp_assoc]
  -- Apply the presheaf collapse `hpre` term-mode (the `≫`-middle objects carry a `restrictScalars 𝟙`
  -- defeq seam that blocks `rw [hpre]`), then cancel the counit by the adjunction left-triangle.
  refine Eq.trans (congrArg (fun m => (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
      (𝟙 Y.ringCatSheaf.val)).map m ≫ (PresheafOfModules.sheafificationAdjunction
      (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).counit.app
      ((PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).obj P)) hpre) ?_
  beta_reduce
  erw [Functor.map_comp_assoc]
  -- The counit codomain carries a `𝟭.obj` wrapper (defeq, not syntactic) so the left-triangle is
  -- applied term-mode (`rw`/`simp` of it miss / `erw` whnf-bombs).
  have htr := (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
    (𝟙 Y.ringCatSheaf.val)).left_triangle_components P
  exact (congrArg (fun z => (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
    (𝟙 Y.ringCatSheaf.val)).map ((PresheafOfModules.monoidalCategoryStruct
    (R := Y.presheaf)).leftUnitor P).hom ≫ z) htr).trans (Category.comp_id _)

set_option maxHeartbeats 1600000 in
/-- **Cone A sub-lemma 2 (`lem:tensorobj_left_unitor_pullback_eq_sheafify`): the λ-leg.**
The `(𝟙_Y, f^*M)`-reconciliation wrapper
`Wλ = sheafifyTensorUnitIso 𝟙ₚY (F M.val) ≫ a_Y.map (sheafifyUnitIso ⊗ pbv_M)`,
post-composed with the sheaf-level left unitor at `f^*M`, equals the sheafified presheaf left unitor
`a_Y.map λ_{F M.val}` conjugated by `pullbackValIso` on the target:
`Wλ ≫ (tensorObj_left_unitor (f^*M)).hom = a_Y.map λ_{F M.val} ≫ (pbv_M).hom`.
This is the cleanest leg: only presheaf-`λ` naturality (against the `sheafifyUnitIso`/`pbv` legs) and
sheafification-counit naturality are used; no new monoidal structure. -/
private lemma tensorObj_left_unitor_pullback_eq_sheafify {X Y : Scheme.{u}} (f : Y ⟶ X)
    (M : X.Modules) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    (sheafifyTensorUnitIso (X := Y)
          (𝟙_ (_root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)))
          ((PresheafOfModules.pullback φ').obj M.val)).hom
        ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
            (MonoidalCategory.tensorHom
              (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
              ((SheafOfModules.forget Y.ringCatSheaf).map (sheafifyUnitIso (Y := Y)).hom)
              ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom))
        ≫ (tensorObj_left_unitor ((pullback f).obj M)).hom
      = (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
          ((PresheafOfModules.monoidalCategoryStruct (R := Y.presheaf)).leftUnitor
            ((PresheafOfModules.pullback (f.toRingCatSheafHom).hom).obj M.val)).hom
        ≫ (pullbackValIso f M).hom := by
  -- Step 1: the reconciliation wrapper's tensor leg is *defeq* `(tensorObjIsoOfIso sheafifyUnitIso
  -- pbv_M).hom` (`hw` is `rfl`); fold it in via `erw` (`rw` misses on the monoidal-instance seam).
  have hw : (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
        (MonoidalCategory.tensorHom
          (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
          ((SheafOfModules.forget Y.ringCatSheaf).map (sheafifyUnitIso (Y := Y)).hom)
          ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom))
      = (tensorObjIsoOfIso (sheafifyUnitIso (Y := Y)) (pullbackValIso f M)).hom := rfl
  -- Step 2: left-unitor naturality on the `pbv_M`-leg, in `.hom` form (the `Iso.refl 𝒪_Y` whisker).
  have hnat : (tensorObjIsoOfIso (Iso.refl (SheafOfModules.unit Y.ringCatSheaf))
            (pullbackValIso f M)).hom
        ≫ (tensorObj_left_unitor ((pullback f).obj M)).hom
      = (tensorObj_left_unitor ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.val)).obj
            ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val))).hom
          ≫ (pullbackValIso f M).hom := by
    have h := tensorObj_left_unitor_naturality (W := Y) (pullbackValIso f M)
    rw [← Iso.trans_hom, h, Iso.trans_hom]
  -- Step 3: combine the split (`tensorObjIsoOfIso_eq_comp`) with `hnat` in one isolated, STU-free
  -- `have` (so `Iso.trans_hom`/`Category.assoc` reassoc the clean term without the STU seam), then
  -- fold the wrapper (`hw`) and this combined identity into the main goal via `erw`.
  have hcomb : (tensorObjIsoOfIso (sheafifyUnitIso (Y := Y)) (pullbackValIso f M)).hom
        ≫ (tensorObj_left_unitor ((pullback f).obj M)).hom
      = (tensorObjIsoOfIso (sheafifyUnitIso (Y := Y))
            (Iso.refl ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
              (𝟙 Y.ringCatSheaf.val)).obj
              ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val)))).hom
        ≫ (tensorObj_left_unitor ((PresheafOfModules.sheafification (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.val)).obj
            ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val))).hom
        ≫ (pullbackValIso f M).hom := by
    rw [tensorObjIsoOfIso_eq_comp, Iso.trans_hom, Category.assoc]
    -- the residual `≫` is the SheafOfModules defeq seam, so close `hnat` term-mode (`rw` misses).
    exact congrArg (_ ≫ ·) hnat
  erw [hw, hcomb]
  -- REDUCED.  The `pbv_M`-leg has been split off and slid past the unitor (`hcomb`); both sides now
  -- carry a trailing `(pullbackValIso f M).hom`.  RESIDUAL (cancelling that trailing leg) is the
  -- genuine structural coherence
  --   `STU.hom ≫ (tensorObjIsoOfIso sheafifyUnitIso 𝟙).hom ≫ (tensorObj_left_unitor (a_Y (F M.val))).hom
  --      = a_Y.map λ_{F M.val}`,
  -- i.e. the `sheafifyTensorUnitIso` reconciliation `STU` and the `sheafifyUnitIso`-whisker collapse,
  -- against the sheaf left unitor at `a_Y (F M.val)`, to the bare sheafified presheaf left unitor.
  -- This is exactly `tensorObj_left_unitor_image_collapse` at `P = F M.val`, post-composed with the
  -- trailing `pbv_M`.
  -- axis-9: `simpa using` closes at reducible transparency, failing on the
  -- `λ_ ≡ monoidalCategoryStruct.leftUnitor` spelling seam; split so `exact` uses default transparency.
  have h := congrArg (· ≫ (pullbackValIso f M).hom)
    (tensorObj_left_unitor_image_collapse (Y := Y)
      ((PresheafOfModules.pullback (f.toRingCatSheafHom).hom).obj M.val))
  simp only [Category.assoc] at h ⊢
  exact h

set_option maxHeartbeats 1600000 in
/-- **Cone A sub-lemma 3 (`lem:pullback_unit_iso_whisker_eq_sheafify_eta_whisker`): the η-whisker
leg.**  The `δ`-identification right wrapper `W = sheafifyTensorUnitIso (F 𝟙)(F M.val) ≫
a_Y.map (pbv_𝟙 ⊗ pbv_M)`, post-composed with the unit comparison whiskered into the left factor
`(tensorObjIsoOfIso (pullbackUnitIso f) 𝟙).hom`, equals the sheafified presheaf `η`-whisker
`a_Y.map (η F ▷ F M.val)` followed by the `(𝟙_Y, f^*M)`-wrapper
`Wλ = sheafifyTensorUnitIso 𝟙ₚY (F M.val) ≫ a_Y.map (sheafifyUnitIso ⊗ pbv_M)`:
`W ≫ whisk = a_Y.map (η F ▷ F M.val) ≫ Wλ`.
Decomposed (sub-lemma 3 = 3a + 3b) into the bridge-1 substitution + whisker expansion (3a) and the
left-factor `pbv_𝟙`/`sheafifyUnitIso` device cancellation against the right wrapper (3b). -/
private lemma pullbackUnitIso_whisker_eq_sheafify_eta_whisker {X Y : Scheme.{u}} (f : Y ⟶ X)
    (M : X.Modules) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    (sheafifyTensorUnitIso (X := Y)
          ((PresheafOfModules.pullback φ').obj (SheafOfModules.unit X.ringCatSheaf).val)
          ((PresheafOfModules.pullback φ').obj M.val)).hom
        ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
            (MonoidalCategory.tensorHom
              (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
              ((SheafOfModules.forget Y.ringCatSheaf).map
                (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).hom)
              ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom))
        ≫ (tensorObjIsoOfIso (pullbackUnitIso f) (Iso.refl ((pullback f).obj M))).hom
      = (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
            (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')
              ▷ (PresheafOfModules.pullback φ').obj M.val)
        ≫ (sheafifyTensorUnitIso (X := Y)
              (𝟙_ (_root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)))
              ((PresheafOfModules.pullback φ').obj M.val)).hom
        ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
            (MonoidalCategory.tensorHom
              (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
              ((SheafOfModules.forget Y.ringCatSheaf).map (sheafifyUnitIso (Y := Y)).hom)
              ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)) := by
  -- 3a (step 1, DONE): unfold the whisker `(tensorObjIsoOfIso (pullbackUnitIso f) 𝟙).hom` to
  -- `tensorObj_functoriality (pullbackUnitIso f).hom 𝟙` and substitute bridge 1
  -- `(pullbackUnitIso f).hom = (pbv 𝟙).inv ≫ a_Y.map η ≫ sheafifyUnitIso.hom`.
  rw [tensorObjIsoOfIso_hom, pullbackUnitIso_eq_sheafify_eta f, Iso.refl_hom]
  -- RESIDUAL (3a step 2 + 3b).  The LHS whisker is now
  --   `tensorObj_functoriality ((pbv 𝟙).inv ≫ a_Y.map η ≫ sheafifyUnitIso.hom) (𝟙_{f^*M})`.
  -- 3a (step 2): split it by bifunctoriality (`tensorObj_functoriality_comp3`, applied in an
  --   isolated STU-free `have` since the per-leg `≫` is on the `SheafOfModules` defeq seam, then
  --   folded back term-mode — cf. the `hcomb` pattern in `tensorObj_left_unitor_pullback_eq_sheafify`)
  --   into `TF (pbv 𝟙).inv 𝟙 ≫ TF (a_Y.map η) 𝟙 ≫ TF sheafifyUnitIso.hom 𝟙`, and identify the central
  --   leg `TF (a_Y.map η) 𝟙`, through the `sheafifyTensorUnitIso` reconciliation, with
  --   `a_Y.map (η F ▷ F M.val)` (the genuinely-hard STU coherence, same family as the
  --   `tensorObj_left_unitor_pullback_eq_sheafify` residual).
  -- 3b: cancel the flanking `TF (pbv 𝟙).inv 𝟙` / `TF sheafifyUnitIso.hom 𝟙` legs against the
  --   `δ`-identification right wrapper `STU(F𝟙',FM) ≫ a_Y.map(pbv 𝟙 ⊗ pbv M)` via
  --   `Iso.hom_inv_id`/`inv_hom_id`, leaving `a_Y.map(η▷FM) ≫ Wλ` (RHS).
  letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
      (Hom.toRingCatSheafHom f).hom
  -- Merge the wrapper's `a_Y.map` leg with the (unfolded) whisker into a single sheafified presheaf
  -- composite `STU(O1,OM) ≫ a_Y.map Wpre`.
  rw [tensorObj_functoriality]
  erw [← Functor.map_comp]
  -- On the RHS, use `sheafifyTensorUnitIso_hom_natural` (arg-1 = η, arg-2 = 𝟙) in reassoc form to
  -- slide `STU(𝟙ₚ,OM)` left past `a_Y.map (η ▷ OM)`, turning the RHS into
  -- `STU(O1,OM) ≫ a_Y.map (forget(a_Y η) ⊗ 𝟙) ≫ a_Y.map Wλ`.
  conv_rhs => erw [reassoc_of% (sheafifyTensorUnitIso_hom_natural (X := Y)
    (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ'))
    (𝟙 ((PresheafOfModules.pullback φ').obj M.val)))]
  -- Both sides are now `STU(O1,OM) ≫ a_Y.map (presheaf composite)`; cancel `STU` (defeq) and `a_Y.map`,
  -- reducing to the presheaf-level interchange identity `Wpre = (forget(a_Y η) ⊗ 𝟙) ≫ (forget ε ⊗ forget pbv_M)`.
  refine (congrArg₂ (· ≫ ·) rfl
      ((congrArg (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
          ?hpre).trans (Functor.map_comp _ _ _))).trans (Category.assoc _ _ _).symm
  case hpre =>
    -- Presheaf interchange: split the `.val`-composites, apply tensor bifunctoriality term-mode
    -- (explicit `C` so the monoidal instance binds across the `Sheaf.val`-vs-`⋙forget₂` carrier seam),
    -- then cancel the `pbv 𝟙` hom/inv pair (left factor) and the `𝟙`s (right factor).
    simp only [SheafOfModules.comp_val, SheafOfModules.forget_map]
    have hc : (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).hom.val
          ≫ (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).inv.val = 𝟙 _ := by
      have h0 := congrArg (SheafOfModules.forget Y.ringCatSheaf).map
        (Iso.hom_inv_id (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)))
      -- axis-9: `simpa using` closes at reducible transparency, failing on the `forget.obj P ≡ P.val`
      -- seam; split so the bare `exact` uses default-transparency defeq.
      simp only [SheafOfModules.comp_val, SheafOfModules.forget_map, SheafOfModules.id_val,
        CategoryTheory.Functor.map_id] at h0
      exact h0
    refine (MonoidalCategory.tensorHom_comp_tensorHom
          (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) _ _ _ _).trans
        (Eq.trans ?_ (MonoidalCategory.tensorHom_comp_tensorHom
          (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) _ _ _ _).symm)
    congr 1
    · exact (Category.assoc _ _ _).symm.trans ((congrArg (· ≫ _) hc).trans (Category.id_comp _))
    · erw [CategoryTheory.Functor.map_id]
      aesop_cat

set_option maxHeartbeats 4000000 in
/-- **Cone A bridge 3 (sheaf-level left unitality of the pullback tensorator).** The sheaf-level
left-unitality coherence of the "oplax monoidal" structure (`δ = pullbackTensorMap`,
`η = pullbackUnitIso`) of the abstract module pullback `pullback f`:
`δ_{𝒪,M} ≫ (η ▷ -) ≫ λ_{f^*M} = f^*(λ_M)`.  This is the sheaf-level transport of the presheaf-level
`Functor.OplaxMonoidal.left_unitality_hom (pullback φ') M.val` (free from the registered oplax
instance `presheafPullbackOplaxMonoidal`), reconciled across the sheafification boundary by
`pullbackUnitIso_eq_sheafify_eta` (η), `pullbackTensorMap_eq_sheafify_delta` (δ), and the
`pullbackValIso`/`sheafifyUnitIso`/counit devices (the same B1 toolkit). -/
private lemma pullbackTensorMap_left_unitality {X Y : Scheme.{u}} (f : Y ⟶ X) (M : X.Modules) :
    pullbackTensorMap f (SheafOfModules.unit X.ringCatSheaf) M
        ≫ (tensorObjIsoOfIso (pullbackUnitIso f)
            (Iso.refl ((pullback f).obj M))).hom
        ≫ (tensorObj_left_unitor ((pullback f).obj M)).hom
      = (pullback f).map (tensorObj_left_unitor M).hom := by
  -- GEOMETRIC CRUX of Cone A.  Reduce to the presheaf-level `left_unitality_hom (pullback φ') M.val`
  -- (the free oplax coherence) by sheafifying it and reconciling the three legs:
  --   • `pullbackTensorMap` = `a_Y.map δ` conjugated by `sheafificationCompPullback`/`pullbackValIso`
  --     (`pullbackTensorMap_eq_sheafify_delta`),
  --   • `pullbackUnitIso` = `a_Y.map η` conjugated by `pullbackValIso`/`sheafifyUnitIso`
  --     (`pullbackUnitIso_eq_sheafify_eta`),
  --   • `tensorObj_left_unitor` = `a_Y.map (λ_)` ≫ counit, and the RHS `f^*(λ_M)` reconciled through
  --     `pullbackValIso` naturality with `a_Y.map (F.map (λ_ M.val))`.
  letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
      (f.toRingCatSheafHom).hom
  -- Expand the sheaf-level tensorator to its sheafified-δ form (bridge 2).  (The unit comparison
  -- `pullbackUnitIso f` is reconciled to `a_Y.map (η F)` by `pullbackUnitIso_eq_sheafify_eta` once
  -- `tensorObjIsoOfIso`/`tensorObj_left_unitor` are unfolded; bridge 1 + the presheaf coherence
  -- `hlu` below are the two seeds of the reconciliation.)
  -- Expand δ (bridge 2) on the LHS and reconcile the RHS `f^*(λ^sheaf_M)` to the
  -- `scp.hom ≫ a_Y.map(F.map λ_{M.val}) ≫ pbv_M` form (sub-lemma 1′).
  rw [pullbackTensorMap_eq_sheafify_delta f (SheafOfModules.unit X.ringCatSheaf) M,
    pullback_map_tensorObj_left_unitor_eq f M]
  -- The presheaf-level left-unitality coherence, free from the registered oplax instance
  -- `presheafPullbackOplaxMonoidal`.
  have hlu := Functor.OplaxMonoidal.left_unitality_hom
    (PresheafOfModules.pullback φ') M.val
  -- Sheafify it: `a_Y.map δ ≫ a_Y.map (η ▷ FM) ≫ a_Y.map λ_{FM} = a_Y.map (F.map λ_{M.val})`.
  have hHLU : (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
        (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ')
          (SheafOfModules.unit X.ringCatSheaf).val M.val)
        ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
            (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')
              ▷ (PresheafOfModules.pullback φ').obj M.val)
        ≫ (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
            (λ_ ((PresheafOfModules.pullback φ').obj M.val)).hom
      = (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
          ((PresheafOfModules.pullback φ').map
            ((PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).leftUnitor M.val).hom) := by
    rw [← Functor.map_comp, ← Functor.map_comp]
    exact congrArg _ hlu
  -- Expose the sheafified presheaf δ/η/λ legs on the RHS via `hHLU` (so both sides share the leading
  -- `scp.hom ≫ a_Y.map δ` once reassociated).  `erw` to cross the `φ'` let-binding vs
  -- `(Hom.toRingCatSheafHom f).hom` defeq seam.
  erw [← hHLU]
  -- RESIDUAL — ASSEMBLY ONLY (route fully worked out + verified on the goal shape; gated purely on the
  -- two open sub-lemmas L3/L2).  Current goal (after `erw [← hHLU]`):
  --   LHS `(scp ≫ a_Yδ ≫ STU ≫ a_Y(pbv 𝟙⊗pbv M)) ≫ whisk ≫ tensorObj_left_unitor(f^*M)`
  --   RHS `scp ≫ (a_Yδ ≫ a_Y(η▷FM) ≫ a_Yλ_{FM}) ≫ pbv M`,
  -- where `whisk = (tensorObjIsoOfIso (pullbackUnitIso f) 𝟙).hom`.
  -- Route: cancel the common leading `scp ≫ a_Yδ` (epi), then
  --   (i) by sub-lemma 3 `pullbackUnitIso_whisker_eq_sheafify_eta_whisker f M`:
  --       `STU ≫ a_Y(pbv 𝟙⊗pbv M) ≫ whisk = a_Y(η▷FM) ≫ Wλ`, where
  --       `Wλ = STU(𝟙ₚ,FM).hom ≫ a_Y(sheafifyUnitIso ⊗ pbv M)`;
  --   (ii) by sub-lemma 2 `tensorObj_left_unitor_pullback_eq_sheafify f M`:
  --       `Wλ ≫ tensorObj_left_unitor(f^*M) = a_Yλ_{FM} ≫ pbv M`.
  --   Chaining: LHS = `a_Y(η▷FM) ≫ (Wλ ≫ tensorObj_left_unitor(f^*M))` = `a_Y(η▷FM) ≫ a_Yλ ≫ pbv M` = RHS.
  -- BLOCKER for executing now: exposing `STU ≫ a_Y(pbv⊗pbv) ≫ whisk` as a contiguous subterm needs a
  -- reassoc across the `SheafOfModules ≫` seam (`simp [Category.assoc]` makes no progress there);
  -- the working idiom is the isolated STU-free `have` + term-mode `congrArg`/`Eq.trans` fold used in
  -- `tensorObj_left_unitor_pullback_eq_sheafify` (`hcomb`).  Both L3 and L2 are in place (with their own
  -- residual sorries); once either closes, this assembly is mechanical.
  -- EXECUTED (iter-066): the `SheafOfModules ≫` seam blocks every `rw`/`simp` of `Category.assoc`,
  -- `Functor.map_comp`, `comp_val` (and `forget`-injective distribution), so reassociation is done
  -- TERM-MODE via `refine (Category.assoc _ _ _).trans ?_` (its `isDefEq` bridges the seam) + `congr 1`
  -- to peel the common `scp`/`a_Yδ` prefix; the core closes by `reassoc_of% hL3` chained with `hL2`.
  have hL3 := pullbackUnitIso_whisker_eq_sheafify_eta_whisker f M
  have hL2 := tensorObj_left_unitor_pullback_eq_sheafify f M
  refine (Category.assoc _ _ _).trans ?_
  congr 1
  refine (Category.assoc _ _ _).trans (Eq.trans ?_ (Category.assoc _ _ _).symm)
  congr 1
  refine (Category.assoc _ _ _).trans ?_
  -- LHS = `STU ≫ a_Y(pbv⊗pbv) ≫ whisk ≫ ulit` (4 legs, right-assoc).  Collapse the first three legs
  -- by `reassoc_of% hL3` (k := ulit), then the unitor tail by `hL2`; the residual is `assoc.symm`.
  -- The `k` (= ulit) and the `a_Y(η ▷ FM)` prefix are PINNED explicitly: `rw` cannot match the
  -- `reassoc`/`hL2` patterns across the `SheafOfModules ≫` defeq-not-syntactic seam, but the term-mode
  -- `.trans`/`congrArg` bridge it via `isDefEq` (the original chain failed only because the bare `_`
  -- placeholders mis-unified — hL3's RHS carries no trailing `ulit`, so `reassoc_of%`'s appended leg
  -- was assigned ambiguously).
  exact (((reassoc_of% hL3) (((pullback f).obj M).tensorObj_left_unitor.hom)).trans
      (congrArg (fun t => (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
          (𝟙 Y.ringCatSheaf.val)).map (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ') ▷
            (PresheafOfModules.pullback φ').obj M.val) ≫ t) hL2)).trans
    (Category.assoc _ _ _).symm

/-- **Inner seam (S4b): the restriction of the unit-contraction over `U` factors as the
tensor-restriction comparison, the unit identification on the left leg, and the left unitor over
`V`.**  This is the unit analogue of Bridge B1's content: pushing the presheaf left unitor `λ_ 𝟙_`
past the restriction functor along the factorisation `j ; ι_U = ι_V`, instantiated by hand at the
project's tensorator (`tensorObj_restrict_iso`/`pullbackTensorMap`) and unit comparison
(`unitRestrictIso`/`pullbackUnitIso`).  The shape mirrors the monoidal-functor coherence
`F(λ_X) = δ ≫ (η ▷ FX) ≫ λ_`, but the restriction functor carries no registered
`Functor.Monoidal` instance, so it is established directly. -/
private lemma tensorObj_unit_iso_restrict_compat_inner {X : Scheme.{u}} {U V : X.Opens}
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (_hjι : j ≫ U.ι = V.ι) :
    (restrictFunctor j).mapIso (tensorObj_unit_iso (X := (U : Scheme)))
      = tensorObj_restrict_iso j (SheafOfModules.unit (U : Scheme).ringCatSheaf)
            (SheafOfModules.unit (U : Scheme).ringCatSheaf)
          ≪≫ tensorObjIsoOfIso (unitRestrictIso j)
              (Iso.refl (restrict (SheafOfModules.unit (U : Scheme).ringCatSheaf) j))
          ≪≫ tensorObj_left_unitor (restrict (SheafOfModules.unit (U : Scheme).ringCatSheaf) j) := by
  rw [tensorObj_unit_iso_eq_left_unitor (X := (U : Scheme)),
    tensorObj_restrict_iso_eq_pullbackTensorMap j (SheafOfModules.unit (U : Scheme).ringCatSheaf)
      (SheafOfModules.unit (U : Scheme).ringCatSheaf)]
  -- Bridge 3 (sheaf-level left unitality at the unit) packaged as an iso equality.
  have hbr :
      @asIso _ _ _ _ (pullbackTensorMap j (SheafOfModules.unit (U : Scheme).ringCatSheaf)
            (SheafOfModules.unit (U : Scheme).ringCatSheaf))
          (pullbackTensorMap_isIso_of_isOpenImmersion j _ _)
          ≪≫ tensorObjIsoOfIso (pullbackUnitIso j)
              (Iso.refl ((pullback j).obj (SheafOfModules.unit (U : Scheme).ringCatSheaf)))
          ≪≫ tensorObj_left_unitor
              ((pullback j).obj (SheafOfModules.unit (U : Scheme).ringCatSheaf))
        = (pullback j).mapIso
            (tensorObj_left_unitor (SheafOfModules.unit (U : Scheme).ringCatSheaf)) := by
    apply Iso.ext
    simp only [Iso.trans_hom, asIso_hom, Functor.mapIso_hom]
    exact pullbackTensorMap_left_unitality j (SheafOfModules.unit (U : Scheme).ringCatSheaf)
  -- `restrictFunctorIsoPullback j`-naturality, conjugation form, on the left unitor.
  have hconj :
      (restrictFunctor j).mapIso
          (tensorObj_left_unitor (SheafOfModules.unit (U : Scheme).ringCatSheaf))
        = (restrictFunctorIsoPullback j).app
              (tensorObj (SheafOfModules.unit (U : Scheme).ringCatSheaf)
                (SheafOfModules.unit (U : Scheme).ringCatSheaf))
            ≪≫ (pullback j).mapIso
                (tensorObj_left_unitor (SheafOfModules.unit (U : Scheme).ringCatSheaf))
            ≪≫ ((restrictFunctorIsoPullback j).app
                (SheafOfModules.unit (U : Scheme).ringCatSheaf)).symm := by
    apply Iso.ext
    simp only [Iso.trans_hom, Functor.mapIso_hom, Iso.symm_hom, Iso.app_inv, Iso.app_hom]
    rw [← (restrictFunctorIsoPullback j).hom.naturality_assoc,
      Iso.hom_inv_id_app, Category.comp_id]
  rw [hconj, ← hbr]
  simp only [Iso.trans_assoc]
  -- strip the common `RFIP.app (𝒪⊗𝒪) ≪≫ asIso δ` prefix
  congr 1
  congr 1
  -- hcore: combine the two `tensorObjIsoOfIso` legs, cancel the `restrictFunctorIsoPullback` pair
  -- inside `unitRestrictIso`, then slide through left-unitor naturality.
  symm
  rw [← Iso.trans_assoc, ← tensorObjIsoOfIso_trans, unitRestrictIso]
  rw [← Iso.trans_assoc ((restrictFunctorIsoPullback j).app
        (SheafOfModules.unit (U : Scheme).ringCatSheaf)).symm
      ((restrictFunctorIsoPullback j).app (SheafOfModules.unit (U : Scheme).ringCatSheaf))
      (pullbackUnitIso j),
    Iso.symm_self_id, Iso.refl_trans, Iso.trans_refl]
  rw [tensorObjIsoOfIso_eq_comp, Iso.trans_assoc]
  erw [tensorObj_left_unitor_naturality ((restrictFunctorIsoPullback j).app
      (SheafOfModules.unit (U : Scheme).ringCatSheaf)).symm]

/-- **S4b (blueprint `lem:tensorobj_unit_iso_restrict_compat`): the unit self-tensor (left unitor)
commutes with further restriction along the chart `j`.** Modulo `unitRestrictIso j` and the
tensor-restriction comparison (S2), the `V`-built unit contraction equals the `restrict j`-image of
the `U`-built one. -/
private lemma tensorObj_unit_iso_restrict_compat {X : Scheme.{u}} {U V : X.Opens}
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (_hjι : j ≫ U.ι = V.ι) :
    tensorObj_unit_iso (X := (V : Scheme))
      = tensorObjIsoOfIso (unitRestrictIso j).symm (unitRestrictIso j).symm
          ≪≫ (tensorObj_restrict_iso j (SheafOfModules.unit (U : Scheme).ringCatSheaf)
                (SheafOfModules.unit (U : Scheme).ringCatSheaf)).symm
          ≪≫ (restrictFunctor j).mapIso (tensorObj_unit_iso (X := (U : Scheme)))
          ≪≫ unitRestrictIso j := by
  -- Bridge both unit-contractions to the left unitor at `𝒪` (V-side on the goal LHS, U-side via the
  -- inner-seam lemma), then close by pure iso-algebra: cancel the `tensorObj_restrict_iso` pair,
  -- combine the two `tensorObjIsoOfIso` legs by bifunctoriality (`tensorObjIsoOfIso_trans`), slide
  -- through the left-unitor naturality, and cancel the `unitRestrictIso` pair.
  rw [tensorObj_unit_iso_eq_left_unitor (X := (V : Scheme)),
    tensorObj_unit_iso_restrict_compat_inner j _hjι]
  simp only [Iso.trans_assoc]
  rw [← Iso.trans_assoc
        (tensorObj_restrict_iso j (SheafOfModules.unit (U : Scheme).ringCatSheaf)
          (SheafOfModules.unit (U : Scheme).ringCatSheaf)).symm
        (tensorObj_restrict_iso j (SheafOfModules.unit (U : Scheme).ringCatSheaf)
          (SheafOfModules.unit (U : Scheme).ringCatSheaf)),
    Iso.symm_self_id, Iso.refl_trans,
    ← Iso.trans_assoc
        (tensorObjIsoOfIso (unitRestrictIso j).symm (unitRestrictIso j).symm)
        (tensorObjIsoOfIso (unitRestrictIso j)
          (Iso.refl (restrict (SheafOfModules.unit (U : Scheme).ringCatSheaf) j))),
    ← tensorObjIsoOfIso_trans, Iso.symm_self_id, Iso.trans_refl]
  -- Goal: `tensorObj_left_unitor 𝒪_V = tensorObjIsoOfIso (𝟙 𝒪_V) uR.symm ≪≫
  --          tensorObj_left_unitor (restrict 𝒪_U j) ≪≫ uR`.  Finish at the hom level with the
  -- (reassociated) left-unitor naturality and the `uR` cancellation.
  apply Iso.ext
  have hL2 := congrArg Iso.hom (tensorObj_left_unitor_naturality (unitRestrictIso j).symm)
  simp only [Iso.trans_hom, Iso.symm_hom] at hL2
  simp only [Iso.trans_hom]
  -- `rw [hL2]` would miss the defeq-not-syntactic `SheafOfModules ≫` seam; substitute it term-mode.
  rw [← Category.assoc]
  refine Eq.trans ?_ (congrArg (· ≫ (unitRestrictIso j).hom) hL2).symm
  rw [Category.assoc, Iso.inv_hom_id, Category.comp_id]

/-- **S4c (blueprint `lem:trivialisation_uiota_restrict_compat`): the global-unit comparison
`uι = unitRestrictIso` commutes with further restriction along the chart `j`.** Modulo
`ρ = restrictCompReindex j hjι` on the source and `unitRestrictIso j` on the target,
`unitRestrictIso V.ι = ρ ≪≫ (restrict j)(unitRestrictIso U.ι) ≪≫ unitRestrictIso j`. This is the
`pullbackComp`/`restrictFunctorComp` coherence of `pullbackUnitIso`. -/
private lemma trivialisation_uIota_restrict_compat {X : Scheme.{u}} {U V : X.Opens}
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (hjι : j ≫ U.ι = V.ι) :
    unitRestrictIso V.ι
      = restrictCompReindex j hjι (SheafOfModules.unit X.ringCatSheaf)
          ≪≫ (restrictFunctor j).mapIso (unitRestrictIso U.ι)
          ≪≫ unitRestrictIso j := by
  -- **Reframe (iter-041):** route through the `pullback` world via B2
  -- (`restrictFunctorIsoPullback_comp_compat`).  After unfolding `unitRestrictIso` and rewriting the
  -- `V.ι`-comparison by B2, the shared `restrict`-prefix cancels and the goal reduces to:
  --   (i) `hslideH` — naturality of `restrictFunctorIsoPullback j` against `pullbackUnitIso U.ι`
  --       (closes outright), and
  --   (ii) `hunitH` — the pullback-side unit composition law, which is the PROVEN
  --       `pullbackObjUnitToUnit_comp j U.ι` (`(pullbackUnitIso f).hom = pullbackObjUnitToUnit f`
  --       definitionally) transported by the `pullbackCongr hjι` eqToHom (the `V.ι = j ≫ U.ι` shim).
  simp only [unitRestrictIso, Functor.mapIso_trans]
  rw [restrictFunctorIsoPullback_comp_compat j hjι (SheafOfModules.unit X.ringCatSheaf)]
  -- (i) the `restrictFunctorIsoPullback j` naturality slide (proven outright).
  have hslideH := (restrictFunctorIsoPullback j).hom.naturality (pullbackUnitIso U.ι).hom
  -- (ii) the pullback-side unit composition law (= `pullbackObjUnitToUnit_comp` + eqToHom transport).
  -- RESIDUAL: the only un-discharged step.  `(pullbackUnitIso f).hom` is defeq
  -- `pullbackObjUnitToUnit f.toRingCatSheafHom`, so this is exactly `pullbackObjUnitToUnit_comp j U.ι`
  -- after cancelling the `pullbackComp` prefix; the residual is the `pullbackCongr hjι` eqToHom shim
  -- identifying `pullbackUnitIso V.ι` with `pullbackUnitIso (j ≫ U.ι)`.
  have hunitH : (pullbackComp j U.ι).hom.app (SheafOfModules.unit X.ringCatSheaf) ≫
        (pullbackCongr hjι).hom.app (SheafOfModules.unit X.ringCatSheaf) ≫
        (pullbackUnitIso V.ι).hom
      = (pullback j).map (pullbackUnitIso U.ι).hom ≫ (pullbackUnitIso j).hom := by
    -- The `pullbackCongr hjι` eqToHom transport: `(pullbackUnitIso V.ι)` pulled back across
    -- `V.ι = j ≫ U.ι` is `(pullbackUnitIso (j ≫ U.ι))` (proved by `subst` once the morphisms are
    -- genuine variables).
    have transport : ∀ {Yv : Scheme.{u}} (f₁ f₂ : Yv ⟶ X) (h : f₁ = f₂),
        (pullbackCongr h).hom.app (SheafOfModules.unit X.ringCatSheaf) ≫ (pullbackUnitIso f₂).hom
          = (pullbackUnitIso f₁).hom := by
      intro Yv f₁ f₂ h; subst h; simp [pullbackCongr]
    rw [transport (j ≫ U.ι) V.ι hjι]
    -- `(pullbackUnitIso f).hom = pullbackObjUnitToUnit f` definitionally, so this is the PROVEN
    -- composition law `pullbackObjUnitToUnit_comp j U.ι` after cancelling the `pullbackComp` prefix.
    have hc := pullbackObjUnitToUnit_comp j U.ι
    rw [show (pullbackUnitIso (j ≫ U.ι)).hom
          = SheafOfModules.pullbackObjUnitToUnit (j ≫ U.ι).toRingCatSheafHom from rfl, hc]
    rw [← Category.assoc, Iso.hom_inv_id_app, Category.id_comp]
    rfl
  apply Iso.ext
  simp only [Iso.trans_hom, Functor.mapIso_hom, Category.assoc, Iso.app_hom]
  rw [reassoc_of% hslideH]
  rw [← hunitH]; rfl

/-- Naturality of the contraction chain in the open (residual-A step 1).

The `eqToHom`-conjugated section map of the contraction morphism over `U`, evaluated at
the preimage open `U.ι ⁻¹ᵁ V`, equals the direct contraction morphism over `V` (built
from `restrictIsoUnitOfLE hVU eM`) evaluated at `V.ι ⁻¹ᵁ V`.  Applied to `i` and `j`
in `exists_tensorObj_inverse`, this collapses both legs of the overlap cocycle to the same
single-open-`V` shape, killing the `(U i).ι⁻¹` vs `(U j).ι⁻¹` reindexing.
Per blueprint `lem:trivialisation_restrict_compat`. -/
private lemma trivialisation_restrict_compat {X : Scheme.{u}} {L : X.Modules}
    {U V : X.Opens} (hVU : V ≤ U)
    (eM : L.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    (tensorObj L (dual L)).val.presheaf.map
        (eqToHom (congrArg Opposite.op (image_preimage_of_le U hVU).symm)) ≫
      ((PresheafOfModules.toPresheaf _).map
          ((tensorObj_restrict_iso U.ι L (dual L) ≪≫
              tensorObjIsoOfIso eM
                (dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eM).symm ≪≫ dual_unit_iso) ≪≫
            tensorObj_unit_iso).hom ≫
          ((restrictFunctorIsoPullback U.ι).app (SheafOfModules.unit X.ringCatSheaf) ≪≫
              pullbackUnitIso U.ι).inv).val).app
        (Opposite.op (U.ι ⁻¹ᵁ V)) ≫
      (SheafOfModules.unit X.ringCatSheaf).val.presheaf.map
        (eqToHom (congrArg Opposite.op (image_preimage_of_le U hVU))) =
    (tensorObj L (dual L)).val.presheaf.map
        (eqToHom (congrArg Opposite.op (image_preimage_of_le V le_rfl).symm)) ≫
      ((PresheafOfModules.toPresheaf _).map
          ((tensorObj_restrict_iso V.ι L (dual L) ≪≫
              tensorObjIsoOfIso (restrictIsoUnitOfLE hVU eM)
                (dual_restrict_iso V.ι L ≪≫
                  (dualIsoOfIso (restrictIsoUnitOfLE hVU eM)).symm ≪≫ dual_unit_iso) ≪≫
            tensorObj_unit_iso).hom ≫
          ((restrictFunctorIsoPullback V.ι).app (SheafOfModules.unit X.ringCatSheaf) ≪≫
              pullbackUnitIso V.ι).inv).val).app
        (Opposite.op (V.ι ⁻¹ᵁ V)) ≫
      (SheafOfModules.unit X.ringCatSheaf).val.presheaf.map
        (eqToHom (congrArg Opposite.op (image_preimage_of_le V le_rfl))) := by
  -- **The chart morphism (the object every naturality square is taken against).**
  -- `j : V ⟶ U` is the open immersion of the sub-open, with `j ≫ U.ι = V.ι`.  By construction
  -- `restrictIsoUnitOfLE hVU eM = (restrict j) eM` up to the unit identifications (see its def in
  -- `TensorObjSubstrate.lean`), so the whole V-chain is the `restrict j`-image of the U-chain.
  have hVU' : V ≤ (𝟙 X) ⁻¹ᵁ U := hVU
  set j : (V : Scheme) ⟶ (U : Scheme) := Scheme.Hom.resLE (𝟙 X) U V hVU' with hj
  have hjι : j ≫ U.ι = V.ι := by rw [hj, Scheme.Hom.resLE_comp_ι, Category.comp_id]
  -- `j` is an open immersion (it is `X.homOfLE hVU` up to the identity-preimage identification),
  -- so the keystone restriction-composition NatIso `restrictFunctorComp j U.ι` applies.
  haveI hji : IsOpenImmersion j := by rw [hj, Scheme.Hom.resLE_id]; infer_instance
  -- **The reindexing obstacle (blueprint ¶1).** The two a-priori-distinct opens `U.ι ⁻¹ᵁ V` and
  -- `V.ι ⁻¹ᵁ V` both name "V seen as a chart"; their direct images coincide as `V` only up to the
  -- equality-of-opens `image_preimage_of_le`, which sits on both flanks of every constituent and
  -- must be threaded telescopically.  These are the two endpoints the outer `eqToHom`s transport.
  have hobjU : U.ι ''ᵁ (U.ι ⁻¹ᵁ V) = V := image_preimage_of_le U hVU
  have hobjV : V.ι ''ᵁ (V.ι ⁻¹ᵁ V) = V := image_preimage_of_le V le_rfl
  -- **The genuine residual (blueprint ¶2–3): the five-constituent restriction-naturality.**
  -- The trivialisation chain `(L ⊗ L⁻¹)|_U ≅ 𝒪_U`, then `(uι U).inv`, is — in order — the five
  -- constituents, each NOW scaffolded ABOVE as a named, typechecked square-lemma (the blueprint
  -- S2–S4c targets), each parametrised by the chart `j` (`j ≫ U.ι = V.ι`) and proved "modulo ρ"
  -- with `ρ = restrictCompReindex j hjι` / `unitRestrictIso`:
  --   S2 `tensorObj_restrict_iso_restrict_compat`     (commute `⊗` past `(-)|_U`),
  --   S3 `dual_restrict_iso_restrict_compat`          (dual restriction; eM/dualIsoOfIso telescoped),
  --   S4a `dual_unit_iso_restrict_compat`             (identify `ℋom(𝒪_U,𝒪_U)` with `𝒪_U`),
  --   S4b `tensorObj_unit_iso_restrict_compat`        (the left unitor),
  --   S4c `trivialisation_uIota_restrict_compat`      (the global-unit comparison `uι`).
  -- TELESCOPE PLAN (once the five squares close): rewrite the V-chain by S2/S3/S4a/S4b/S4c so each
  -- becomes `restrict j`(U-constituent) conjugated by ρ; bifunctoriality `tensorObjIsoOfIso_trans`
  -- splits the `tensorObjIsoOfIso eM (…)` into the eM-leg (whose V-refinement IS
  -- `restrictIsoUnitOfLE hVU eM = (restrict j) eM`) and the dual-chain leg; adjacent ρ's cancel
  -- telescopically (target ρ of each square = source ρ of the next), leaving only the outer
  -- `eqToHom`s `hobjU`/`hobjV`; evaluate `.val.app` over the preimage open `U.ι ⁻¹ᵁ V`.
  --
  -- BLOCKER (iter-040 finding, corrects the analogist's "free" premise): each square is a *genuine*
  -- residual, NOT free from `restrictFunctorComp.hom.naturality`.  That naturality is in a MORPHISM
  -- of X-modules; the squares need naturality in the IMMERSION `j` of composite
  -- `pullback`+`sheafification` chart-chases (verified: `apply Iso.ext; simp [tensorObj_restrict_iso]`
  -- on S2 explodes into the full `restrictFunctorIsoPullback ≫ sheafificationCompPullback ≫
  -- leftAdjointUniq ≫ restrictScalars-δ` comparison; S4c into a `pushforwardComp`/
  -- `pullbackObjUnitToUnit` coherence).  The keystone `restrictFunctorComp j U.ι` (now applicable —
  -- `IsOpenImmersion j` installed above) supplies only the reindex `ρ`, not the per-leg naturality.
  sorry

/-- **Commutativity of `S`-linear endomorphisms of the regular module of a commutative ring,
applied at `1`.**  Re-ported local copy of the (private, hence inaccessible) `DualInverse`
helper of the same name, dropped during the v4.31 recovery.  Used by
`presheafDualUnitIso_naturality` below. -/
private lemma linearEndo_apply_comm {S : Type u} [CommRing S] (a b : S →ₗ[S] S) :
    a (b 1) = b (a 1) := by
  have key : ∀ (g : S →ₗ[S] S) (x : S), g x = x * g 1 := fun g x => by
    rw [← smul_eq_mul, ← LinearMap.map_smul, smul_eq_mul, mul_one]
  rw [key a (b 1), key b (a 1), mul_comm]

/-- **Naturality of the presheaf dual-unit iso w.r.t. a unit automorphism (the V-side
automorphism core ★').**  Re-ported local copy of the `DualInverse` lemma
`presheafDualUnitIso_naturality`, dropped during the v4.31 recovery; needed by B1
(`dualUnitIso_dualIsoOfIso`).  For a unit automorphism `ŝ`, `dualIsoOfIso ŝ` (contravariant)
intertwines with `presheafDualUnitIso` on the eval-at-`1` core. -/
private lemma presheafDualUnitIso_naturality {Y : Scheme.{u}}
    (ŝ : 𝟙_ (_root_.PresheafOfModules.{u} (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) ≅
         𝟙_ (_root_.PresheafOfModules.{u} (Y.presheaf ⋙ forget₂ CommRingCat RingCat))) :
    PresheafOfModules.dualIsoOfIso ŝ ≪≫ presheafDualUnitIso (Y := Y)
      = presheafDualUnitIso (Y := Y) ≪≫ ŝ := by
  apply Iso.ext
  apply PresheafOfModules.hom_ext
  intro X
  apply ModuleCat.hom_ext
  ext φ
  simp only [Iso.trans_hom, PresheafOfModules.comp_app, ModuleCat.hom_comp, LinearMap.comp_apply]
  change PresheafOfModules.evalLin _ X
      ((PresheafOfModules.pushforward₀ (Over.forget (Opposite.unop X))
        (Y.presheaf ⋙ forget₂ CommRingCat RingCat)).map ŝ.hom ≫ φ)
        (1 : ((Y.presheaf ⋙ forget₂ CommRingCat RingCat).obj X : Type u))
    = (ŝ.hom.app X).hom (PresheafOfModules.evalLin _ X φ
        (1 : ((Y.presheaf ⋙ forget₂ CommRingCat RingCat).obj X : Type u)))
  change PresheafOfModules.evalLin _ X φ
      ((ŝ.hom.app X).hom (1 : ((Y.presheaf ⋙ forget₂ CommRingCat RingCat).obj X : Type u)))
    = (ŝ.hom.app X).hom (PresheafOfModules.evalLin _ X φ
        (1 : ((Y.presheaf ⋙ forget₂ CommRingCat RingCat).obj X : Type u)))
  exact linearEndo_apply_comm
    (PresheafOfModules.evalLin _ X φ) (ModuleCat.Hom.hom (ŝ.hom.app X))

open Opposite TopologicalSpace in
/-- **Restriction of a glued local-compatible morphism recovers the local datum.**  Re-ported
local copy of the `DualInverse` connector lemma `homOfLocalCompat_restrictFunctor_map`, dropped
during the v4.31 recovery; the defining gluing property of `homOfLocalCompat`.  Needed by the
terminal `exists_tensorObj_inverse` (B-bridge `isIso_of_isIso_restrict` consumes it). -/
private lemma homOfLocalCompat_restrictFunctor_map {X : Scheme.{u}} {M N : X.Modules}
    {ι : Type*} (U : ι → X.Opens) (hU : ∀ x : X, ∃ i, x ∈ U i)
    (f : ∀ i, M.restrict (U i).ι ⟶ N.restrict (U i).ι)
    (hf : ∀ (i j : ι) (V : X.Opens) (hVi : V ≤ U i) (hVj : V ≤ U j),
        M.val.presheaf.map (eqToHom (congrArg op (image_preimage_of_le (U i) hVi).symm)) ≫
          ((PresheafOfModules.toPresheaf _).map (f i).val).app (op ((U i).ι ⁻¹ᵁ V)) ≫
            N.val.presheaf.map (eqToHom (congrArg op (image_preimage_of_le (U i) hVi)))
          = M.val.presheaf.map (eqToHom (congrArg op (image_preimage_of_le (U j) hVj).symm)) ≫
              ((PresheafOfModules.toPresheaf _).map (f j).val).app (op ((U j).ι ⁻¹ᵁ V)) ≫
                N.val.presheaf.map (eqToHom (congrArg op (image_preimage_of_le (U j) hVj))))
    (i : ι) :
    (Scheme.Modules.restrictFunctor (U i).ι).map (homOfLocalCompat U hU f hf) = f i := by
  -- Reconstruct the gluing internals of `homOfLocalCompat` (identical to its body), so that the
  -- underlying ab-presheaf morphism `g` of `homOfLocalCompat` is `topSectionToHom (glued section)`.
  let H : TopCat.Sheaf (Type u) (X : TopCat) :=
    ⟨CategoryTheory.presheafHom M.val.presheaf N.val.presheaf,
      Presheaf.IsSheaf.hom M.val.presheaf N.val.presheaf N.isSheaf⟩
  have hsup : iSup U = ⊤ := by
    rw [eq_top_iff]
    intro x _
    obtain ⟨i, hi⟩ := hU x
    exact TopologicalSpace.Opens.mem_iSup.mpr ⟨i, hi⟩
  have hglue := H.existsUnique_gluing U (fun i => homLocalSection U f i)
  have hcompat : TopCat.Presheaf.IsCompatible
      (CategoryTheory.presheafHom M.val.presheaf N.val.presheaf) U
      (fun i => homLocalSection U f i) := by
    intro i j
    refine NatTrans.ext (funext fun Z => ?_)
    obtain ⟨W⟩ := Z
    erw [presheafHom_map_app W.hom (TopologicalSpace.Opens.infLELeft (U i) (U j)) _ rfl,
        presheafHom_map_app W.hom (TopologicalSpace.Opens.infLERight (U i) (U j)) _ rfl]
    simp only [homLocalSection]
    exact hf i j W.left (W.hom.le.trans inf_le_left) (W.hom.le.trans inf_le_right)
  -- The glued underlying ab-presheaf morphism `g` (defeq to `(homOfLocalCompat …).val`'s presheaf).
  set g : M.val.presheaf ⟶ N.val.presheaf :=
    topSectionToHom (hsup ▸ (hglue hcompat).choose) with hg
  have _hs := (hglue hcompat).choose_spec.1
  -- **Connection lemma** (identical to `homOfLocalCompat` body): on every `W' ≤ U i`,
  -- `g` agrees with the local section manufactured from `f i`.
  have hconn : ∀ (i : ι) (W' : X.Opens) (hWi : W' ≤ U i),
      g.app (op W') = (homLocalSection U f i).app (op (Over.mk (homOfLE hWi))) := by
    intro i W' hWi
    have htr : ∀ {a : X.Opens} (h : a = ⊤) (y : H.obj.obj (op a)),
        (h ▸ y : H.obj.obj (op ⊤)) = H.obj.map (eqToHom (congrArg op h)) y := by
      intro a h y; subst h; simp
    rw [hg, topSectionToHom_app, htr hsup]
    have hop : eqToHom (congrArg op hsup) = (eqToHom hsup.symm).op := Subsingleton.elim _ _
    have hgl : TopCat.Presheaf.IsGluing H.obj U (fun i => homLocalSection U f i)
        (hglue hcompat).choose := _hs
    have hsi : (ConcreteCategory.hom (H.obj.map (Opens.leSupr U i).op)) (hglue hcompat).choose
        = homLocalSection U f i := hgl i
    rw [hop, presheafHom_map_app (homOfLE le_top) (eqToHom hsup.symm)
        (homOfLE le_top ≫ eqToHom hsup.symm) rfl, ← hsi,
      presheafHom_map_app (homOfLE hWi) (Opens.leSupr U i)
        (homOfLE hWi ≫ Opens.leSupr U i) rfl]
    rw [show (homOfLE le_top ≫ eqToHom hsup.symm : W' ⟶ iSup U)
        = (homOfLE hWi ≫ Opens.leSupr U i) from Subsingleton.elim _ _]
  -- Sectionwise reduction.
  apply SheafOfModules.Hom.ext
  refine PresheafOfModules.hom_ext (fun P => ?_)
  obtain ⟨P⟩ := P
  apply ModuleCat.hom_ext
  ext m
  -- The LHS section value is (defeq) the glued morphism `g` at the open `(U i).ι ''ᵁ P`.
  have hWi : (U i).ι ''ᵁ P ≤ U i := (U i).ι_image_le P
  -- **Local-section value at an image open** recovers `f i`: the eqToHom-conjugation collapses to
  -- the identity, since `(U i).ι ⁻¹ᵁ ((U i).ι ''ᵁ P) = P` for the open immersion `(U i).ι`.
  have key : (homLocalSection U f i).app (op (Over.mk (homOfLE hWi)))
      = ((PresheafOfModules.toPresheaf (U i).toScheme.ringCatSheaf.obj).map (f i).val).app
          (op P) := by
    -- v4.31.0: `Over.mk_left` no longer fires and `rw [eqToHom_comp_iff]` chokes on the
    -- `(Over.forget).op ⋙ M.val.presheaf` ↔ `restrict` defeq at `instances` transparency; build
    -- `hnat` with the UNREDUCED `.left` spelling so its `T.app` index matches the goal, then apply
    -- `eqToHom_comp_iff` in TERM mode (`.mpr`, defeq-tolerant) instead of as a syntactic `rw`.
    have hh : (op ((U i).ι ⁻¹ᵁ (Over.mk (homOfLE hWi)).left) :
          (TopologicalSpace.Opens ↥(U i).toScheme)ᵒᵖ)
        = op P := congrArg op ((U i).ι.preimage_image_eq P)
    have hnat := ((PresheafOfModules.toPresheaf (U i).toScheme.ringCatSheaf.obj).map
      (f i).val).naturality (eqToHom hh)
    simp only [eqToHom_map] at hnat
    simp only [homLocalSection, homOfLE_leOfHom, eqToHom_map]
    exact (eqToHom_comp_iff _ _ _).mpr hnat.symm
  change (ConcreteCategory.hom (g.app (op ((U i).ι ''ᵁ P)))) m
    = (ModuleCat.Hom.hom ((f i).val.app (op P))) m
  rw [hconn i ((U i).ι ''ᵁ P) hWi, key]
  rfl

/-- **B1: conjugating `dualIsoOfIso s` by `dual_unit_iso` recovers `s`** (the degenerate
`rightAdjointMate_id`-style identity).  For a unit automorphism `s : 𝒪_V ≅ 𝒪_V`,
`dual_unit_iso.symm ≪≫ dualIsoOfIso s ≪≫ dual_unit_iso = s`.

`dual_unit_iso = sheafification.mapIso presheafDualUnitIso ≪≫ counit`, and
`dualIsoOfIso s = sheafification.mapIso (PresheafOfModules.dualIsoOfIso (forget s))`, so the
three `mapIso` legs compose to `sheafification.mapIso (presheafDualUnitIso.symm ≪≫
PresheafOfModules.dualIsoOfIso (forget s) ≪≫ presheafDualUnitIso)`.  The presheaf core
(★) `presheafDualUnitIso.symm ≪≫ PresheafOfModules.dualIsoOfIso ŝ ≪≫ presheafDualUnitIso = ŝ`
is the eval-at-`1` semantics of `dualUnitIsoGen`; the residual is the counit-naturality
conjugation, which returns `s`. -/
lemma dualUnitIso_dualIsoOfIso {V : Scheme.{u}}
    (s : SheafOfModules.unit V.ringCatSheaf ≅ SheafOfModules.unit V.ringCatSheaf) :
    dual_unit_iso.symm ≪≫ dualIsoOfIso s ≪≫ dual_unit_iso = s := by
  -- B1 follows by pure iso-algebra from the single naturality square (N):
  --   `dualIsoOfIso s ≪≫ dual_unit_iso = dual_unit_iso ≪≫ s`.
  -- (N) is the naturality of `dual_unit_iso : dual 𝒪_V ≅ 𝒪_V` with respect to the unit
  -- automorphism `s`, acting contravariantly via `dualIsoOfIso s` on the source.  It
  -- decomposes as the presheaf eval-core naturality (★')
  --   `PresheafOfModules.dualIsoOfIso ŝ ≪≫ presheafDualUnitIso = presheafDualUnitIso ≪≫ ŝ`
  -- transported under `sheafification.mapIso` and composed with the sheafification-counit
  -- naturality `sheafification.mapIso (forget.mapIso s) ≪≫ counit = counit ≪≫ s`.
  have hN : dualIsoOfIso s ≪≫ dual_unit_iso = dual_unit_iso ≪≫ s := by
    apply Iso.ext
    unfold dualIsoOfIso dual_unit_iso
    simp only [Iso.trans_hom, Functor.mapIso_hom, Category.assoc]
    -- The presheaf eval-core (★') at hom level: `dŝ.hom ≫ p.hom = p.hom ≫ ŝ.hom`.
    have hcore := congrArg Iso.hom (presheafDualUnitIso_naturality (Y := V)
      ((SheafOfModules.forget V.ringCatSheaf).mapIso s))
    simp only [Iso.trans_hom] at hcore
    -- Push `hcore` through `sheafification` (the two `S.map` legs differ only by defeq
    -- instances, so the combine/split must use `erw`), then close with the
    -- sheafification-counit naturality at `s`.
    rw [← Category.assoc]
    erw [← Functor.map_comp, hcore, Functor.map_comp, Category.assoc]
    erw [(PresheafOfModules.sheafificationAdjunction
      (𝟙 V.ringCatSheaf.val)).counit.naturality s.hom]
    rfl
  rw [hN, ← Iso.trans_assoc, Iso.symm_self_id, Iso.refl_trans]

/-- Unit self-duality evaluation collapse (residual-A step 2, type-correct fused form).

A unit automorphism `t : 𝒪_V ≅ 𝒪_V` tensored with its dual-conjugate
`dual_unit_iso.symm ≪≫ (dualIsoOfIso t).symm ≪≫ dual_unit_iso` (which represents the
`t⁻¹` automorphism at the `𝒪_V`-level after conjugating through `dual_unit_iso`)
gives back the standard unit multiplication `tensorObj_unit_iso`.  This is the
`g ⊗ g⁻¹ = 1` cancellation for the tensor structure.
Per blueprint `lem:tensorobj_unit_self_duality_collapse`. -/
private lemma tensorObj_unit_self_duality_collapse {V : Scheme.{u}}
    (t : SheafOfModules.unit V.ringCatSheaf ≅ SheafOfModules.unit V.ringCatSheaf) :
    tensorObjIsoOfIso t
        (dual_unit_iso.symm ≪≫ (dualIsoOfIso t).symm ≪≫ dual_unit_iso) ≪≫
      tensorObj_unit_iso = tensorObj_unit_iso := by
  -- The N-leg is `t.symm`: take `.symm` of B1 (`dualUnitIso_dualIsoOfIso t`) and expand,
  -- using `(a ≪≫ b ≪≫ c).symm = c.symm ≪≫ b.symm ≪≫ a.symm` and `dual_unit_iso.symm.symm = _`.
  have hNleg : dual_unit_iso.symm ≪≫ (dualIsoOfIso t).symm ≪≫ dual_unit_iso = t.symm := by
    have hB1 := congrArg Iso.symm (dualUnitIso_dualIsoOfIso t)
    -- v4.31: `simpa` is reducible-transparency and leaves a syntactic mismatch; rewrite `hB1`
    -- explicitly into the goal shape via `Iso.trans_symm`/`Iso.symm_symm` then close by `exact`.
    simp only [Iso.trans_symm, Iso.symm_symm_eq] at hB1
    exact hB1
  rw [hNleg]
  -- B2: `t ⊗ t⁻¹` contracts via the unit comparison.
  exact tensorObjIsoOfIso_comp_unit_iso t t.symm t.hom_inv_id

/-- **Inverse of an invertible module.**

Every line bundle `L : X.Modules` has a two-sided tensor inverse: there is a
locally-trivial `Linv : X.Modules` (the dual `L⁻¹ = Hom(L, O_X)`) together with
a tensor isomorphism `L ⊗_X Linv ≅ 𝒪_X`. Per blueprint
`lem:tensorobj_inverse_invertible`. iter-206 flat-pivot: the designated unit is
`SheafOfModules.unit X.ringCatSheaf = 𝒪_X` (the `MonoidalCategory` unit `𝟙_` is
no longer available — the full monoidal instance is off the critical path, see
§2).

**iter-226+ d.2-free descent re-route (current state).** `Linv := Scheme.Modules.dual L`
IS nameable: the sheaf-level dual `dual` (this file) landed iter-225, so the FIRST
step is no longer blocked and the iter-218 "infrastructure-missing" gate is retired.
The closure is now assembled WITHOUT the categorical "invertible object ⇒ inverse"
escape (still unavailable — no `MonoidalCategory (X.Modules)` for the varying
structure sheaf, §2) and WITHOUT the forbidden sheafify-the-presheaf-evaluation
shortcut (it re-hits the `M ◁ η` whiskering = the abandoned tensor-stalk "d.2"
gap, a DEAD END — analogist `ts226descent.md`, verdict D). Instead it glues local
trivialising data, touching no tensor stalk. The C-bridge `dual_isLocallyTrivial`,
A-bridge `homOfLocalCompat`, and B-bridge `isIso_of_isIso_restrict` are all
implemented; the remaining blocker is `trivialisation_restrict_compat` (the per-chart
restrict naturality telescope, see body comment). EXACT decomposition:
`informal/exists_tensorObj_inverse.md` and `analogies/ts226descent.md`.
-/
lemma exists_tensorObj_inverse {X : Scheme.{u}} {L : X.Modules}
    (hL : LineBundle.IsLocallyTrivial L) :
    ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧
      Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf) :=
  by
  classical
  -- `Linv := dual L`; locally trivial by the **C-bridge** `dual_isLocallyTrivial`.
  refine ⟨dual L, dual_isLocallyTrivial hL, ?_⟩
  -- Choose, for each point, a trivialising affine open of `L` together with the
  -- trivialisation `eM x : L|_{U x} ≅ 𝒪_{U x}`.
  choose U hxU _hUaff hLt using hL
  -- The dual trivialises on the SAME open `U x`, derived FROM the `L`-trivialisation
  -- `eM x` (the chain of `dual_isLocallyTrivial`), so both legs descend from one datum
  -- — this is what makes the overlap cocycle a `g · g⁻¹ = 1` cancellation.
  set eM : ∀ x, L.restrict (U x).ι ≅ SheafOfModules.unit (U x : Scheme).ringCatSheaf :=
    fun x => (hLt x).some with heM
  set eN : ∀ x, (dual L).restrict (U x).ι ≅ SheafOfModules.unit (U x : Scheme).ringCatSheaf :=
    fun x => dual_restrict_iso (U x).ι L ≪≫ (dualIsoOfIso (eM x)).symm ≪≫ dual_unit_iso with heN
  -- Local contraction iso `(L ⊗ dual L)|_{U x} ≅ 𝒪_{U x}` — the exact chain of
  -- `tensorObj_isLocallyTrivial`: restrict-commutes-with-⊗, bifunctoriality, unit.
  set e : ∀ x, (tensorObj L (dual L)).restrict (U x).ι ≅
      SheafOfModules.unit (U x : Scheme).ringCatSheaf :=
    fun x => tensorObj_restrict_iso (U x).ι L (dual L) ≪≫
      tensorObjIsoOfIso (eM x) (eN x) ≪≫ tensorObj_unit_iso with he
  -- Identify the restricted global unit `𝒪_X|_{U x}` with the local unit `𝒪_{U x}`
  -- (`restrictFunctorIsoPullback` ≫ `pullbackUnitIso`).
  set uι : ∀ x, restrict (SheafOfModules.unit X.ringCatSheaf) (U x).ι ≅
      SheafOfModules.unit (U x : Scheme).ringCatSheaf :=
    fun x => (Scheme.Modules.restrictFunctorIsoPullback (U x).ι).app
        (SheafOfModules.unit X.ringCatSheaf) ≪≫ pullbackUnitIso (U x).ι with huι
  -- Local morphisms `f x : (L ⊗ dual L)|_{U x} ⟶ 𝒪_X|_{U x}` (the contraction, landed
  -- in the restricted GLOBAL unit so `homOfLocalCompat` can consume them); each is an iso.
  set f : ∀ x, (tensorObj L (dual L)).restrict (U x).ι ⟶
      restrict (SheafOfModules.unit X.ringCatSheaf) (U x).ι :=
    fun x => (e x).hom ≫ (uι x).inv with hf_def
  have hfiso : ∀ x, IsIso (f x) := by
    intro x; rw [hf_def]; infer_instance
  -- Glue the `f x` to a single global morphism `ε : L ⊗ dual L ⟶ 𝒪_X` via the
  -- **A-bridge** `homOfLocalCompat`.  Its hypothesis is the sectionwise overlap
  -- agreement (cocycle):  on `V ≤ U i ⊓ U j` the conjugated components of `f i`, `f j`
  -- coincide — the `g_{ij}·g_{ij}⁻¹ = 1` cancellation of the transition units.
  set ε : tensorObj L (dual L) ⟶ SheafOfModules.unit X.ringCatSheaf :=
    homOfLocalCompat U (fun x => ⟨x, hxU x⟩) f (by
      intro i j V hVi hVj
      simp only [hf_def, he, huι, heN]
      -- Reduce BOTH overlap legs to the single-open-`V` form (`trivialisation_restrict_compat`
      -- applied to `i` and `j`), killing the `(U i).ι⁻¹` vs `(U j).ι⁻¹` reindexing.
      erw [trivialisation_restrict_compat hVi (eM i),
         trivialisation_restrict_compat hVj (eM j)]
      -- The two legs now differ only in the trivialisation refined to `V`.
      set eMi := restrictIsoUnitOfLE hVi (eM i) with hMi
      set eMj := restrictIsoUnitOfLE hVj (eM j) with hMj
      -- Transition unit `t : 𝒪_V ≅ 𝒪_V` with `eMi ≪≫ t = eMj`.
      set t : SheafOfModules.unit (V : Scheme).ringCatSheaf ≅
          SheafOfModules.unit (V : Scheme).ringCatSheaf := eMi.symm ≪≫ eMj with ht_def
      have ht : eMi ≪≫ t = eMj := by
        apply Iso.ext
        rw [ht_def]
        simp only [Iso.trans_hom, Iso.symm_hom]
        -- `≫` in `SheafOfModules` is defeq-but-not-syntactic, so `rw`/`simp` of category
        -- lemmas fail to pattern-match; term-mode `exact` discharges via unification.
        exact Iso.hom_inv_id_assoc eMi eMj.hom
      -- Factor the dual leg of `eMj` as `dualLeg eMi ≪≫ sConj` by inserting `du ≪≫ du.symm = 𝟙`.
      have hfact :
          dual_restrict_iso V.ι L ≪≫
              ((dualIsoOfIso eMi).symm ≪≫ (dualIsoOfIso t).symm) ≪≫ dual_unit_iso
            = (dual_restrict_iso V.ι L ≪≫ (dualIsoOfIso eMi).symm ≪≫ dual_unit_iso) ≪≫
              (dual_unit_iso.symm ≪≫ (dualIsoOfIso t).symm ≪≫ dual_unit_iso) := by
        apply Iso.ext
        simp only [Iso.trans_hom, Iso.symm_hom, Category.assoc]
        rw [Iso.hom_inv_id_assoc]
      -- Core iso equation: the two `tensorObjIsoOfIso ≪≫ tensorObj_unit_iso` middles agree.
      -- RHS collapses to LHS via `dualIsoOfIso_trans` (order flips) + `tensorObjIsoOfIso_trans`
      -- + `tensorObj_unit_self_duality_collapse t` (the `g·g⁻¹ = 1` cancellation).
      have hiso :
          tensorObjIsoOfIso eMi
              (dual_restrict_iso V.ι L ≪≫ (dualIsoOfIso eMi).symm ≪≫ dual_unit_iso) ≪≫
            tensorObj_unit_iso
          = tensorObjIsoOfIso eMj
              (dual_restrict_iso V.ι L ≪≫ (dualIsoOfIso eMj).symm ≪≫ dual_unit_iso) ≪≫
            tensorObj_unit_iso := by
        rw [← ht, dualIsoOfIso_trans, Iso.trans_symm, hfact, tensorObjIsoOfIso_trans,
          Iso.trans_assoc, tensorObj_unit_self_duality_collapse t]
      -- Lift to the shared `tensorObj_restrict_iso ≪≫ … ≪≫ tensorObj_unit_iso` wrapper.
      have hchain :
          tensorObj_restrict_iso V.ι L (dual L) ≪≫
              tensorObjIsoOfIso eMi
                (dual_restrict_iso V.ι L ≪≫ (dualIsoOfIso eMi).symm ≪≫ dual_unit_iso) ≪≫
              tensorObj_unit_iso
            = tensorObj_restrict_iso V.ι L (dual L) ≪≫
              tensorObjIsoOfIso eMj
                (dual_restrict_iso V.ι L ≪≫ (dualIsoOfIso eMj).symm ≪≫ dual_unit_iso) ≪≫
              tensorObj_unit_iso :=
        congrArg (fun w => tensorObj_restrict_iso V.ι L (dual L) ≪≫ w) hiso
      -- Both legs are now `((wrapper).hom ≫ (uι V).inv).val.app _` conjugated by the SAME
      -- `eqToHom`s; rewriting the wrapper iso makes them syntactically identical.
      rw [hchain]) with hεdef
  -- `ε` is a global iso since it restricts to the iso `f x` on each cover member `U x`
  -- (**B-bridge** `isIso_of_isIso_restrict`).
  have hεiso : IsIso ε := by
    refine isIso_of_isIso_restrict ε U hxU ?_
    intro x
    have key : (restrictFunctor (U x).ι).map ε = f x := by
      rw [hεdef]
      exact homOfLocalCompat_restrictFunctor_map U _ f _ x
    rw [key]; exact hfiso x
  exact ⟨asIso ε⟩

end Modules

end Scheme

end AlgebraicGeometry
