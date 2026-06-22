/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse

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

/-! ## Cocycle-A helpers for `exists_tensorObj_inverse`

`trivialisation_restrict_compat` reduces the sectionwise overlap equation
(residual-A step 1) from the `(U i).ι⁻¹`-vs-`(U j).ι⁻¹` form to a single-open-`V`
equation, enabling `tensorObj_unit_self_duality_collapse` to close the `g·g⁻¹ = 1`
cancellation (step 2). -/

/-- **Reindexing iso `ρ_A` (the keystone identification).** For the chart `j : V ⟶ U` with
`j ≫ U.ι = V.ι`, the `V`-restriction of an `X`-module `A` is canonically the `j`-restriction of its
`U`-restriction: `A.restrict V.ι ≅ (A.restrict U.ι).restrict j`.  Built from the keystone
`restrictFunctorComp j U.ι` (`Mathlib`) post-composed with the `j ≫ U.ι = V.ι` congruence
`restrictFunctorCongr`.  This is the `ρ` of the blueprint S2–S4c squares, on both flanks of each. -/
private noncomputable def restrictCompReindex {X : Scheme.{u}} {U V : X.Opens}
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (hjι : j ≫ U.ι = V.ι) (A : X.Modules) :
    A.restrict V.ι ≅ (A.restrict U.ι).restrict j :=
  (restrictFunctorCongr hjι).symm.app A ≪≫ (restrictFunctorComp j U.ι).app A

/-! ### Step A — atomic per-leg conjugate computations for the B2 telescope

The natural-transformation identity `hNat` of `restrictFunctorIsoPullback_comp_compat_hom`
is proved by conjugating both sides onto the common right adjoint `pushforward V.ι` and
distributing leg-by-leg via `conjugateEquiv_comp`.  Each per-leg conjugate value is one of
the following atomic claims (blueprint `lem:conjugateequiv_*`). -/

/-- **c₅ (blueprint `lem:conjugateequiv_pullbackcomp_hom`): conjugate of the pullback-composition
hom.** Mirror of Mathlib's `conjugateEquiv_pullbackComp_inv`: applying `conjugateEquiv` (in the
swapped adjunction order, so it accepts `.hom : L₁ ⟶ L₂`) to `(pullbackComp f g).hom` gives the
*inverse* of the pushforward-composition iso.  Obtained from `conjugateEquiv_pullbackComp_inv` by
the `conjugateEquiv_comm` cancellation `hom ; inv = 𝟙`. -/
lemma conjugateEquiv_pullbackComp_hom {X Y Z : Scheme.{u}} (f : X ⟶ Y) (g : Y ⟶ Z)
    [IsOpenImmersion f] [IsOpenImmersion g] :
    conjugateEquiv (pullbackPushforwardAdjunction (f ≫ g))
        ((pullbackPushforwardAdjunction g).comp (pullbackPushforwardAdjunction f))
        (pullbackComp f g).hom
      = (pushforwardComp f g).inv := by
  have hcomm := conjugateEquiv_comm
    ((pullbackPushforwardAdjunction g).comp (pullbackPushforwardAdjunction f))
    (pullbackPushforwardAdjunction (f ≫ g))
    (α := (pullbackComp f g).inv) (β := (pullbackComp f g).hom)
    (Iso.hom_inv_id _)
  rw [conjugateEquiv_pullbackComp_inv] at hcomm
  -- hcomm : (pushforwardComp f g).hom ≫ conjugateEquiv … (pullbackComp f g).hom = 𝟙
  rw [← cancel_epi (pushforwardComp f g).hom, hcomm, Iso.hom_inv_id]

/-- **LHS of the B2 telescope: the conjugate of `restrictFunctorIsoPullback f` is the identity.**
`restrictFunctorIsoPullback f = leftAdjointUniq (restrictAdjunction f) (pullbackPushforwardAdjunction f)`,
both adjoint to the common `pushforward f`; the conjugate of a `leftAdjointUniq` hom onto the shared
right adjoint is the identity. -/
lemma conjugateEquiv_restrictFunctorIsoPullback_hom {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] :
    conjugateEquiv (pullbackPushforwardAdjunction f) (restrictAdjunction f)
        (restrictFunctorIsoPullback f).hom
      = 𝟙 (pushforward f) := by
  rw [Equiv.apply_eq_iff_eq_symm_apply]
  simp only [restrictFunctorIsoPullback, Adjunction.leftAdjointUniq, Iso.symm_hom,
    conjugateIsoEquiv_symm_apply_inv, Iso.refl_inv]

/-- **c₃ (blueprint `lem:conjugateequiv_restrictfunctorisopullback_whiskerright`): conjugate of the
`f`-comparison whiskered by `restrict j`.** The leg `whiskerRight (restrictFunctorIsoPullback f).hom
(restrictFunctor j)`, conjugated through the composite adjunctions `(pPA f).comp (rA j) →
(rA f).comp (rA j)`, is the identity: by `conjugateEquiv_whiskerRight` it becomes
`whiskerLeft (pushforward j)` of the (identity) conjugate of `restrictFunctorIsoPullback f`. -/
lemma conjugateEquiv_restrictFunctorIsoPullback_whiskerRight {X Y Z : Scheme.{u}}
    (f : Y ⟶ X) (j : Z ⟶ Y) [IsOpenImmersion f] [IsOpenImmersion j] :
    conjugateEquiv ((pullbackPushforwardAdjunction f).comp (restrictAdjunction j))
        ((restrictAdjunction f).comp (restrictAdjunction j))
        (Functor.whiskerRight (restrictFunctorIsoPullback f).hom (restrictFunctor j))
      = 𝟙 _ := by
  rw [conjugateEquiv_whiskerRight, conjugateEquiv_restrictFunctorIsoPullback_hom,
    Functor.whiskerLeft_id']

/-- **c₄ (blueprint `lem:conjugateequiv_restrictfunctorisopullback_whiskerleft`): conjugate of the
`j`-comparison whiskered into `pullback f`.** The leg `whiskerLeft (pullback f)
(restrictFunctorIsoPullback j).hom`, conjugated through `(pPA f).comp (pPA j) → (pPA f).comp (rA j)`,
is the identity: by `conjugateEquiv_whiskerLeft` it becomes `whiskerRight` of the (identity)
conjugate of `restrictFunctorIsoPullback j`. -/
lemma conjugateEquiv_restrictFunctorIsoPullback_whiskerLeft {X Y Z : Scheme.{u}}
    (f : Y ⟶ X) (j : Z ⟶ Y) [IsOpenImmersion f] [IsOpenImmersion j] :
    conjugateEquiv ((pullbackPushforwardAdjunction f).comp (pullbackPushforwardAdjunction j))
        ((pullbackPushforwardAdjunction f).comp (restrictAdjunction j))
        (Functor.whiskerLeft (pullback f) (restrictFunctorIsoPullback j).hom)
      = 𝟙 _ := by
  rw [conjugateEquiv_whiskerLeft, conjugateEquiv_restrictFunctorIsoPullback_hom,
    Functor.whiskerRight_id']

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
  simp

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
    -- Both sides are NatTrans `restrictFunctor V.ι ⟶ pullback V.ι`, between left adjoints of the
    -- common right adjoint `pushforward V.ι`.  Apply `conjugateEquiv` injectivity onto `pushforward V.ι`
    -- (every intermediate functor in the RHS chain is `X.Modules ⥤ V.Modules`, so the whole chain lives
    -- over the FIXED `(C,D) = (X.Modules, V.Modules)` and `conjugateEquiv_comp` distributes leg-by-leg
    -- — `mateEquiv_hcomp` is NOT needed once the per-leg intermediate adjunctions are supplied).
    apply (conjugateEquiv (pullbackPushforwardAdjunction V.ι) (restrictAdjunction V.ι)).injective
    -- LHS collapses to `𝟙 (pushforward V.ι)` by `conjugateEquiv_restrictFunctorIsoPullback_hom`.
    rw [conjugateEquiv_restrictFunctorIsoPullback_hom]
    -- Goal: `𝟙 (pushforward V.ι)
    --          = conjugateEquiv (pPA V.ι) (rA V.ι) (c₁ ≫ c₂ ≫ c₃ ≫ c₄ ≫ c₅ ≫ c₆)`.
    -- RHS distributes by `← conjugateEquiv_comp` through the intermediate adjunctions
    --   G₀=`rA V.ι`  G₁=`rA (j≫U.ι)`  G₂=`(rA U.ι).comp (rA j)`  G₃=`(pPA U.ι).comp (rA j)`
    --   G₄=`(pPA U.ι).comp (pPA j)`  G₅=`pPA (j≫U.ι)`  G₆=`pPA V.ι`
    -- giving the reversed product of per-leg conjugates, each a KNOWN map:
    --   • c₂ (`restrictFunctorComp j U.ι).hom`) ↦ `(pushforwardComp j U.ι).hom` — the now-public root
    --       keystone `conjugateEquiv_restrictFunctorComp_inv j U.ι` (matches G₁↦G₂ EXACTLY);
    --   • c₅ (`pullbackComp j U.ι).hom`) ↦ `(pushforwardComp j U.ι).inv` — inverse of the Mathlib
    --       `conjugateEquiv_pullbackComp_inv j U.ι` (which gives the conjugate of `.inv`);
    --   • c₃,c₄ (whisker of `restrictFunctorIsoPullback U.ι`/`j`) ↦ `pushforwardComp`-whiskered units via
    --       `unit_leftAdjointUniq_hom_app` at `U.ι`/`j`;
    --   • c₁,c₆ (`restrictFunctorCongr`/`pullbackCongr` from `hjι`) ↦ `pushforwardCongr`/eqToHom.
    -- The product telescopes (the `(pushforwardComp j U.ι).hom ≫ (pushforwardComp j U.ι).inv` from c₂,c₅
    -- cancels; the `pushforwardCongr` from c₁,c₆ cancel against the `j≫U.ι` reindex) to `𝟙`.
    -- Distribute the conjugation leg-by-leg via `← conjugateEquiv_comp` through G₀..G₆.
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
    -- c₂ ↦ (pushforwardComp).hom (keystone), c₅ ↦ (pushforwardComp).inv (c₅ lemma),
    -- c₃,c₄ ↦ whiskered conjugates of `restrictFunctorIsoPullback` = 𝟙.
    rw [conjugateEquiv_restrictFunctorComp_inv, conjugateEquiv_pullbackComp_hom,
        conjugateEquiv_restrictFunctorIsoPullback_whiskerRight,
        conjugateEquiv_restrictFunctorIsoPullback_whiskerLeft]
    simp only [Category.id_comp, Category.comp_id]
    -- Cancel the `(pushforwardComp).inv ≫ (pushforwardComp).hom` pair, leaving the two reindex
    -- congruences conj(c₆) ≫ conj(c₁), which telescope to `𝟙` by `conjugateEquiv_reindexCongr`.
    simp only [Category.assoc, Iso.inv_hom_id_assoc]
    rw [conjugateEquiv_reindexCongr (j ≫ U.ι) V.ι hjι]
  have happ := congr_app hNat A
  simpa only [NatTrans.comp_app, Functor.whiskerRight_app, Functor.whiskerLeft_app] using happ

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
      { app := fun U => (f.appIso U.unop).inv }
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
  -- `H1.inv` is `(pullbackPPAdj.leftAdjointUniq hadj).hom` (`leftAdjointUniq_inv_app`).  Both sides
  -- are maps `pullback.obj M.val ⟶ pushforward β.obj M.val`; `pullbackPPAdj` is an adjunction onto
  -- `pushforward φ'`, so by `homEquiv`-injectivity it suffices to compare their `homEquiv`-images.
  -- The LHS image is `hadj.unit.app M.val` (defining triangle `unit_leftAdjointUniq_hom_app`); the
  -- RHS image expands by `homEquiv_unit`.  This reduces the per-leg to the CRUX unit identity below.
  apply (PresheafOfModules.pullbackPushforwardAdjunction (Hom.toRingCatSheafHom f).hom).homEquiv _ _
    |>.injective
  rw [Adjunction.leftAdjointUniq_inv_app]
  simp only [Adjunction.homEquiv_unit]
  refine Eq.trans (Adjunction.unit_leftAdjointUniq_hom_app _ hadj M.val) ?_
  -- CRUX unit identity (the genuine geometric content, all other B1 steps now discharged):
  --   `hadj.unit.app M.val`
  --     `= pullbackPPAdj.unit.app M.val`
  --       `≫ pushforward φ'.map (η_P ≫ forget (pullbackValIso f M).hom ≫ forget ρ_M.inv)`
  -- connecting the presheaf restriction unit `hadj.unit` (LHS) with the presheaf pullback unit
  -- `pullbackPPAdj.unit` composed with the sheafification unit `η`, the `sheafificationCompPullback`
  -- device (= `pullbackValIso`) and the sheaf-level `restrictFunctorIsoPullback` (= `ρ`).  Both
  -- `restrictFunctorIsoPullback f` and the (sheaf) `restrictAdjunction f` are `pushforwardPushforwardAdj`
  -- /`leftAdjointUniq` over `pushforward f`, so this is the "sheafification intertwines the presheaf and
  -- sheaf adjoint-uniqueness comparisons" coherence: unfold `pullbackValIso` (=
  -- `sheafificationCompPullback.symm ≫ pullback.mapIso counit`, with `sheafificationCompPullback_eq_leftAdjointUniq`)
  -- and `restrictFunctorIsoPullback` (= `restrictAdjunction.leftAdjointUniq pullbackPushforwardAdjunction`),
  -- then push `hadj.unit`/`pullbackPPAdj.unit` through the sheafification adjunction triangle
  -- (`sheafificationAdjunction`) against `restrictAdjunction.unit`.
  --
  -- VERIFIED REDUCTION (iter-045, via `lean_multi_attempt`): after
  --   `rw [pullbackValIso, restrictFunctorIsoPullback]; simp only [Iso.trans_hom, Iso.symm_hom,`
  --   `  Functor.mapIso_hom, Functor.map_comp]; rw [sheafificationCompPullback_eq_leftAdjointUniq]`
  -- the goal is a pure `leftAdjointUniq`/composite-adjunction coherence: `pullbackValIso.inv` becomes
  -- the `leftAdjointUniq` of `(sheafification.comp pullbackPPAdj_sheaf)` vs
  -- `(pullbackPPAdj_pre.comp sheafification)`, and `restrictFunctorIsoPullback` the `leftAdjointUniq`
  -- of `restrictAdjunction` vs `pullbackPushforwardAdjunction`.  Closing it is the SAME mate-calculus
  -- family as B2 (`analogies/b2mate045.md`): `conjugateEquiv_comp` / `mateEquiv_hcomp` /
  -- `iterated_mateEquiv_conjugateEquiv` + `leftAdjointUniq_trans`, plus `leftAdjointUniqUnitEta`
  -- (root L1531) for the `sheafificationCompPullback` unit leg.  ~80–120 LOC mate-calculus; the
  -- surrounding B1 machinery (δ-conjugation, per-leg merge, `tensorHom_comp3` distribution) is now
  -- ALL discharged, so this unit coherence is the sole remaining content of the B1 keystone.
  --
  -- ASSEMBLY (iter-051): the crux is the `forget`-transport of the *sheaf*-level
  -- `unit_leftAdjointUniq` identity for `restrictFunctorIsoPullback`, with the pullback-unit leg
  -- replaced by its sheafification factorisation `sheafPullbackUnit_forget_eq` (Part III).
  --   (I)  `hadj.unit.app M.val = forget (restrictAdjunction f).unit.app M`           [rfl]
  --   (II) sheaf `unit_leftAdjointUniq_hom_app` ⇒ `restrictAdj.unit = pullbackAdj.unit ≫ ρ⁻¹`
  --   (III) `sheafPullbackUnit_forget_eq` : `forget (pullback-sheaf unit) = pre-unit ≫ η ≫ pbv`
  --   (IV) `forget (pushforward f).map = (pushforward φ').map ∘ forget`               [rfl]
  -- The trailing `ρ⁻¹` leg matches the crux's `forget ρ.inv` leg; the rest telescopes.
  -- NB: `X.Modules`/`Y.Modules` are `SheafOfModules`, whose `≫` is defeq-but-not-syntactic, so
  -- `rw [Category.assoc]`/`rw [Functor.map_comp]` MISS at this level; every category-lemma step is
  -- applied in TERM mode (via `:=` / `Eq.trans`), which unifies up to defeq.
  have hII : (restrictAdjunction f).unit.app M
        ≫ (pushforward f).map ((restrictFunctorIsoPullback f).hom.app M)
      = (pullbackPushforwardAdjunction f).unit.app M :=
    Adjunction.unit_leftAdjointUniq_hom_app _ _ M
  -- `(pushforward f).map ρ.hom ≫ (pushforward f).map ρ.inv = 𝟙` (term mode).
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
  -- The B1 crux (`forget`-transport of the sheaf `unit_leftAdjointUniq`).  The only `rw`s are the
  -- two atom-subterm rewrites (Part I `rfl`-show, Part II `hII2`); every category-lemma step
  -- (`map_comp`, `assoc`) — which `rw` MISSES on the `SheafOfModules` `≫` seam — is applied in TERM
  -- mode (unifies up to defeq), as is Part IV (`forget ∘ pushforward = pushforward φ' ∘ forget`).
  rw [show hadj.unit.app M.val
        = (SheafOfModules.forget X.ringCatSheaf).map ((restrictAdjunction f).unit.app M) from rfl,
    hII2]
  -- Goal: `forget (u_p ≫ pushforward.map ρ.inv) = RHS`.
  -- (a) split `forget` over `≫` (Part IV folds `forget ∘ pushforward` into `pushforward φ' ∘ forget`):
  refine Eq.trans (CategoryTheory.Functor.map_comp (SheafOfModules.forget X.ringCatSheaf)
    ((pullbackPushforwardAdjunction f).unit.app M)
    ((pushforward f).map ((restrictFunctorIsoPullback f).inv.app M))) ?_
  -- Goal: `forget u_p ≫ (pushforward φ').map (forget ρ.inv) = RHS`.
  -- (b) Part III rewrites the first leg `forget u_p`:
  refine Eq.trans (congrArg (fun t => t
      ≫ (PresheafOfModules.pushforward (f.toRingCatSheafHom).hom).map
          ((SheafOfModules.forget Y.ringCatSheaf).map ((restrictFunctorIsoPullback f).inv.app M)))
    (sheafPullbackUnit_forget_eq f M)) ?_
  -- Goal: `(u_pre ≫ Q.map (η ≫ forget pbv)) ≫ Q.map (forget ρ.inv) = u_pre ≫ Q.map (η ≫ forget pbv ≫ forget ρ.inv)`.
  -- (c) assoc, then merge the two `Q.map` legs and re-associate inside:
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
  -- Both privacy gates are now CLEARED (iter-045): `sheafifyTensorUnitIso` + `_hom_eq'` are public.
  -- STEP 1 (mechanical): collapse the `sheafifyTensorUnitIso.hom` factor and merge the three
  -- `a_Y.map` legs into ONE, reducing the goal to the per-leg presheaf identity
  --   `H1.inv.app A = η_{pullback A} ≫ forget (pullbackValIso f ⟨A⟩).hom ≫ forget ρ_⟨A⟩.inv`.
  rw [sheafifyTensorUnitIso_hom_eq']
  -- STEP 2: rewrite each `H1.inv` leg by the per-leg helper `H1inv_app_eq_pullbackVal_restrict`
  -- (`erw`: the `leftAdjointUniq` carrier matches only up to defeq instance/proof terms).
  erw [H1inv_app_eq_pullbackVal_restrict f M, H1inv_app_eq_pullbackVal_restrict f N]
  -- LHS = `a_Y.map ((η ≫ pbv_M ≫ ρM⁻¹) ⊗ (η ≫ pbv_N ≫ ρN⁻¹))`.  Distribute the per-leg composites
  -- across the tensor and split the `a_Y.map` via the bundled `map_tensorHom_comp3`, giving exactly
  -- the RHS three-factor form.  Applied by `exact` so the functor-carrier defeq (`(𝟙 _.obj)` vs
  -- `(𝟙 _.val)`) and the per-leg intermediate-object diamonds are absorbed definitionally.
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
  rw [pullbackTensorMap_pullbackCongr_assoc hjι M N,
    pullbackTensorMap_restrict_cancel_assoc j U.ι M N, Functor.map_comp]
  simp only [Category.assoc]
  congr 1
  -- Carry the per-leg `RFIP U.ι`-comparisons past `pullbackTensorMap j` (D1′ naturality).
  simp only [tensorObjIsoOfIso_hom]
  rw [reassoc_of% (pullbackTensorMap_natural j
    ((restrictFunctorIsoPullback U.ι).app M).symm.hom
    ((restrictFunctorIsoPullback U.ι).app N).symm.hom)]
  congr 1
  -- Pure `tensorObj_functoriality` identity; merge the LHS pair (`refine Eq.trans` of the generic
  -- `tensorObj_functoriality_comp`, applied so the `SheafOfModules ≫` seam binds by unification
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
  rfl

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
  -- `dual_restrict_iso` is the image of the internal-hom restriction structural iso under the
  -- 4-step `restrict`/`pullback`/`sheafification` chart-chase (`DualInverse.lean:166`); its
  -- immersion-naturality is the same depth of residual as S2.  RESIDUAL.
  sorry

/-- **Unit-restriction identification.** For an open immersion `f : Y ⟶ X`, the restriction of the
global unit `𝒪_X` to `Y` is `𝒪_Y`: `(𝒪_X).restrict f ≅ 𝒪_Y`.  This is `uι(f)` of the blueprint
(`(restrictFunctorIsoPullback f).app 𝒪_X ≪≫ pullbackUnitIso f`); also the unit identification used
on the chart-scheme side of S4a/S4b. -/
private noncomputable def unitRestrictIso {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] :
    restrict (SheafOfModules.unit X.ringCatSheaf) f ≅ SheafOfModules.unit Y.ringCatSheaf :=
  (restrictFunctorIsoPullback f).app (SheafOfModules.unit X.ringCatSheaf) ≪≫ pullbackUnitIso f

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
  -- `dual_unit_iso = sheafification.mapIso presheafDualUnitIso ≪≫ counit`; immersion-naturality
  -- of `presheafDualUnitIso` against `j` (cf. the proved `presheafDualUnitIso_naturality` against a
  -- unit automorphism) plus `dual_restrict_iso` naturality.  RESIDUAL.
  sorry

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
      ≫ (λ_ (M'.val : _root_.PresheafOfModules (W.presheaf ⋙ forget₂ CommRingCat RingCat))).hom
      = (λ_ (M.val : _root_.PresheafOfModules (W.presheaf ⋙ forget₂ CommRingCat RingCat))).hom
        ≫ (SheafOfModules.forget W.ringCatSheaf).map g.hom := by
    rw [MonoidalCategory.id_tensorHom]
    exact MonoidalCategory.leftUnitor_naturality
      ((SheafOfModules.forget W.ringCatSheaf).map g.hom)
  simp only [tensorObjIsoOfIso, tensorObj_left_unitor, Iso.trans_hom, Functor.mapIso_hom,
    MonoidalCategory.tensorIso_hom, Functor.mapIso_refl, Iso.refl_hom, Category.assoc]
  -- Combine the two sheafification legs, rewrite by the inner seam `hpre`, split, then close with
  -- sheafification-counit naturality at `g.hom` (same idiom as `dualUnitIso_dualIsoOfIso`).
  rw [← Category.assoc]
  erw [← Functor.map_comp, hpre, Functor.map_comp, Category.assoc]
  erw [(PresheafOfModules.sheafificationAdjunction (𝟙 W.ringCatSheaf.val)).counit.naturality g.hom]
  rfl

/-- **Inner seam (S4b): the restriction of the unit-contraction over `U` factors as the
tensor-restriction comparison, the unit identification on the left leg, and the left unitor over
`V`.**  This is the unit analogue of Bridge B1's content: pushing the presheaf left unitor `λ_ 𝟙_`
past the restriction functor along the factorisation `j ; ι_U = ι_V`, instantiated by hand at the
project's tensorator (`tensorObj_restrict_iso`/`pullbackTensorMap`) and unit comparison
(`unitRestrictIso`/`pullbackUnitIso`).  The shape mirrors the monoidal-functor coherence
`F(λ_X) = δ ≫ (η ▷ FX) ≫ λ_`, but the restriction functor carries no registered
`Functor.Monoidal` instance, so it is established directly. -/
private lemma tensorObj_unit_iso_restrict_compat_inner {X : Scheme.{u}} {U V : X.Opens}
    (j : (V : Scheme) ⟶ (U : Scheme)) [IsOpenImmersion j] (hjι : j ≫ U.ι = V.ι) :
    (restrictFunctor j).mapIso (tensorObj_unit_iso (X := (U : Scheme)))
      = tensorObj_restrict_iso j (SheafOfModules.unit (U : Scheme).ringCatSheaf)
            (SheafOfModules.unit (U : Scheme).ringCatSheaf)
          ≪≫ tensorObjIsoOfIso (unitRestrictIso j)
              (Iso.refl (restrict (SheafOfModules.unit (U : Scheme).ringCatSheaf) j))
          ≪≫ tensorObj_left_unitor (restrict (SheafOfModules.unit (U : Scheme).ringCatSheaf) j) := by
  -- ROUTE: promote `tensorObj_restrict_iso j 𝒪 𝒪` to the pullback world (Bridge B1,
  -- `tensorObj_restrict_iso_eq_pullbackTensorMap`), express `restrictFunctor j` on the sheafified
  -- presheaf unitor via `restrictFunctorIsoPullback` + `sheafificationCompPullback`, and reconcile
  -- with the pullback unit comparison `pullbackUnitIso`/`pullbackObjUnitToUnit`.  RESIDUAL: the
  -- pullback-world presheaf left-unitor coherence (no `Functor.Monoidal (pullback φ)` instance
  -- exists in Mathlib — see `analogies/s4b-unitor.md`); the δ/η components are all built
  -- (`pullbackTensorMap`, `pullbackUnitIso`) but their unitor interaction is not yet assembled.
  sorry

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
  rw [← Category.assoc, hL2, Category.assoc, Iso.inv_hom_id, Category.comp_id]

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
  -- (the eval-at-`1` semantics of `dualUnitIsoGen`, sectionwise:
  --  `evalLin (pushforward₀.map ŝ.hom ≫ φ) 1 = ŝ.app · (evalLin φ 1)`), transported under
  -- `sheafification.mapIso` and composed with the sheafification-counit naturality
  --   `sheafification.mapIso (forget.mapIso s) ≪≫ counit = counit ≪≫ s`.
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
    simpa using hB1
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
  -- coincide.  Mathematically this is the `g_{ij}·g_{ij}⁻¹ = 1` cancellation of the
  -- transition units (the dual leg `eN` carries the inverse transition), so both
  -- contractions are the canonical evaluation and agree.  Formalising it is the
  -- bounded-but-real overlap check the planner flagged as the residual.
  set ε : tensorObj L (dual L) ⟶ SheafOfModules.unit X.ringCatSheaf :=
    homOfLocalCompat U (fun x => ⟨x, hxU x⟩) f (by
      intro i j V hVi hVj
      -- GOAL (cocycle): the `eqToHom`-conjugated section maps of `f i` and `f j` agree
      -- on the overlap open `V`.  `f i = (e i).hom ≫ (uι i).inv`, `f j` likewise; both
      -- the tensor-restriction contraction `e` and the unit identification `uι` are
      -- canonical, and `eN` is built from `eM` so the transition units cancel.
      -- These section-hom types are GENUINE abelian-group maps (NOT thin-poset
      -- subsingletons — `subsingleton` does not apply); the equation is real and needs
      -- the `g_{ij}·g_{ij}⁻¹ = 1` transition-unit cancellation pushed through
      -- `tensorObj_restrict_iso`, `tensorObjIsoOfIso` and `dualIsoOfIso`.
      --
      -- REDUCTION STEP (compiling): unfold `f`, `e`, `uι`, `eN`, `eM` to expose the
      -- explicit canonical iso-chain on each leg.  After this the goal is the
      -- sectionwise equation of the two composites
      --   `(tensorObj_restrict_iso ≫ tensorObjIsoOfIso (eM ·) (eN ·) ≫ tensorObj_unit_iso).hom`
      --   `≫ ((restrictFunctorIsoPullback ·).app _ ≫ pullbackUnitIso ·).inv`
      -- evaluated `.val.app` at the overlap open, conjugated by the `eqToHom`s.
      -- NB: we deliberately do NOT unfold `heM` here, so that `eM i` / `eM j` stay folded
      -- and the goal's two legs match the `eM`-argument of `trivialisation_restrict_compat`
      -- syntactically (the `erw` below relies on this).
      simp only [hf_def, he, huι, heN]
      -- REMAINING OBSTACLE (the genuine `g·g⁻¹ = 1` cancellation).  iter-026 probe
      -- (`lean_multi_attempt` at this goal) confirmed the precise state:
      --   * `rfl` FAILS — the two sides carry the *distinct opaque trivialisations*
      --     `eM i.some` / `eM j.some`; they are equal only through the eval-cancellation,
      --     never definitionally.
      --   * `simp only [tensorObjIsoOfIso_trans, tensorObjIsoOfIso_refl, dualIsoOfIso_trans,
      --     dualIsoOfIso_refl]` (the functoriality lemmas proved at the TOP of this file,
      --     iter-025) makes NO PROGRESS: those are ISO-level equations, but this goal is the
      --     `.val.app`-SECTION form, so they cannot fire here without first lifting the goal
      --     to a morphism/iso equation.
      -- TWO genuine missing ingredients (both verified absent in the codebase), exactly the
      -- mechanism of `rem:dual_discharges_inverse`:
      --   (A) FURTHER-RESTRICTION COMPATIBILITY of the iso-chain `tensorObj_restrict_iso`,
      --       `restrictFunctorIsoPullback`, `pullbackUnitIso` — to rewrite this sectionwise
      --       goal over the overlap `V` into an equation of restricted SHEAF morphisms, so
      --       the iso-level functoriality lemmas become applicable.  Then the M-leg transition
      --       `t : 𝒪_V ≅ 𝒪_V` (the `eM i|_V`-vs-`eM j|_V` discrepancy) pairs, via
      --       `tensorObjIsoOfIso_trans`/`dualIsoOfIso_trans`, with the N-leg `dualIsoOfIso t`.
      --   (B) The UNIT SELF-DUALITY EVAL COLLAPSE
      --       `tensorObjIsoOfIso t (dualIsoOfIso t)⁻¹ ≫ tensorObj_unit_iso = tensorObj_unit_iso`
      --       (the `g·g⁻¹ = 1` cancellation, via `dual_unit_iso` / `presheafDualUnitIso`
      --       evaluation-at-`1`).  This needs the sectionwise eval semantics of
      --       `tensorObj_unit_iso` and `dualIsoOfIso` — NOT present.
      -- Pushing both legs to a pure tensor `a ⊗ b`, (A) makes the `eM i`/`eM j` discrepancy a
      -- single transition `t`, and (B) cancels it, leaving the canonical contraction on both
      -- legs — hence equal on the overlap.  ESCALATED (iter-026, one-genuine-attempt rule):
      -- flagged for a mathlib-analogist consult on building (A)+(B); see task_results.
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
  -- (**B-bridge** `isIso_of_isIso_restrict`).  The restriction-agreement
  -- `(restrictFunctor (U x).ι).map ε = f x` is the defining gluing property of
  -- `homOfLocalCompat` (its internal `IsGluing`/`hconn` datum); extracting it as a
  -- usable equation needs a `homOfLocalCompat_restrict` connector not yet exported.
  have hεiso : IsIso ε := by
    refine isIso_of_isIso_restrict ε U hxU ?_
    intro x
    -- `(restrictFunctor (U x).ι).map ε` agrees with the iso `f x` by the gluing
    -- property of `homOfLocalCompat`; hence it is an iso.  The restriction-agreement
    -- is the defining gluing property of `homOfLocalCompat` (its internal
    -- `IsGluing`/`hconn` datum), packaged as the connector lemma
    -- `homOfLocalCompat_restrictFunctor_map` co-assigned to the `DualInverse.lean`
    -- lane this iter.  We isolate it here as `key`; once the connector lands the
    -- body of `key` is exactly `homOfLocalCompat_restrictFunctor_map U _ f _ x`.
    have key : (restrictFunctor (U x).ι).map ε = f x := by
      rw [hεdef]
      -- The restriction-agreement is the defining gluing property of `homOfLocalCompat`,
      -- now exported as the connector lemma `homOfLocalCompat_restrictFunctor_map`
      -- (DualInverse.lean).  `_` slots unify with the specific cover-witness/cocycle used in `ε`.
      exact homOfLocalCompat_restrictFunctor_map U _ f _ x
    rw [key]; exact hfiso x
  exact ⟨asIso ε⟩

end Modules

end Scheme

end AlgebraicGeometry
