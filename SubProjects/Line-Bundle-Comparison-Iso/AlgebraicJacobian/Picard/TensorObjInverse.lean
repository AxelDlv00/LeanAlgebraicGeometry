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

/-! ## Cocycle-A helpers for `exists_tensorObj_inverse` (iter-028 stubs)

`trivialisation_restrict_compat` reduces the sectionwise overlap equation
(residual-A step 1) from the `(U i).ι⁻¹`-vs-`(U j).ι⁻¹` form to a single-open-`V`
equation, enabling `tensorObj_unit_self_duality_collapse` to close the `g·g⁻¹ = 1`
cancellation (step 2). -/

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
trivialising data, touching no tensor stalk. Two bridges remain before this sorry
closes (see body comment): the C-bridge `dual_isLocallyTrivial` and the A-bridge
`homOfLocalCompat` (SheafOfModules morphism descent). The B-bridge
`isIso_of_isIso_restrict` (local-iso ⇒ global iso, mirroring the CLOSED
`tensorObj_isLocallyTrivial` at L1912) is DONE (iter-226, above, axiom-clean). EXACT
decomposition: `informal/exists_tensorObj_inverse.md` and `analogies/ts226descent.md`.
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
      /- Planner strategy (iter-028):
         1. `simp only [hf_def, he, huι, heN, heM]` (already present above) exposes the two
            leg composites in the `eqToHom`-conjugated `presheaf.map ≫ app ≫ presheaf.map`
            form matching the domain of `trivialisation_restrict_compat`.
         2. Apply `trivialisation_restrict_compat hVi (eM i)` (rewrite LHS) and
            `trivialisation_restrict_compat hVj (eM j)` (rewrite RHS) to reduce both legs to the
            single-open-`V` form:
              LHS = fOver V (restrictIsoUnitOfLE hVi (eM i))
              RHS = fOver V (restrictIsoUnitOfLE hVj (eM j))
            (where `fOver V eM' = (tensorObj_restrict_iso V.ι L (dual L) ≪≫
            tensorObjIsoOfIso eM' (dual_restrict_iso V.ι L ≪≫ (dualIsoOfIso eM').symm ≪≫
            dual_unit_iso) ≪≫ tensorObj_unit_iso).hom ≫ ((restrictFunctorIsoPullback V.ι).app
            (SheafOfModules.unit X.ringCatSheaf) ≪≫ pullbackUnitIso V.ι).inv`, sectionwise
            at `op (V.ι ⁻¹ᵁ V)`).
         3. Set `t := (restrictIsoUnitOfLE hVi (eM i)).symm ≪≫ restrictIsoUnitOfLE hVj (eM j)`.
            Bifunctoriality (`tensorObjIsoOfIso_trans`) + `dualIsoOfIso_trans` make the M-leg
            discrepancy `t` and the N-leg discrepancy `dual_unit_iso.symm ≪≫ (dualIsoOfIso t).symm
            ≪≫ dual_unit_iso`; then `tensorObj_unit_self_duality_collapse t` cancels both.

         PRECISE iso-algebra bridge (derived iter-029, validated on paper; awaiting a build
         window — both sibling deps `TensorObjSubstrate.lean`/`DualInverse.lean` were mid-edit
         this session so the steps below could not be machine-checked yet):
         Write `eMi := restrictIsoUnitOfLE hVi (eM i)`, `eMj := restrictIsoUnitOfLE hVj (eM j)`,
         and `t := eMi.symm ≪≫ eMj`, so `eMi ≪≫ t = eMj` (via `Iso.self_symm_id`).
         The two legs differ ONLY in the middle `tensorObjIsoOfIso` factor (the
         `tensorObj_restrict_iso`, `tensorObj_unit_iso`, `uι V` legs are shared), so it reduces
         to the iso equation
           `tensorObjIsoOfIso eMi (dualLeg eMi) ≪≫ tensorObj_unit_iso
              = tensorObjIsoOfIso eMj (dualLeg eMj) ≪≫ tensorObj_unit_iso`,
         where `dualLeg e := dual_restrict_iso V.ι L ≪≫ (dualIsoOfIso e).symm ≪≫ dual_unit_iso`.
         KEY FACTORISATION: by `dualIsoOfIso_trans` (order flips) `(dualIsoOfIso eMj).symm
           = (dualIsoOfIso eMi).symm ≪≫ (dualIsoOfIso t).symm`, so inserting `dual_unit_iso ≪≫
           dual_unit_iso.symm = 𝟙` gives `dualLeg eMj = dualLeg eMi ≪≫ sConj` with
           `sConj := dual_unit_iso.symm ≪≫ (dualIsoOfIso t).symm ≪≫ dual_unit_iso`.
         Then `tensorObjIsoOfIso_trans` factors the RHS as
           `tensorObjIsoOfIso eMi (dualLeg eMi) ≪≫ tensorObjIsoOfIso t sConj`, and
           `tensorObjIsoOfIso t sConj ≪≫ tensorObj_unit_iso = tensorObj_unit_iso` is EXACTLY
           `tensorObj_unit_self_duality_collapse t` (now sorry-free — its B1 leg
           `dualUnitIso_dualIsoOfIso` was closed iter-029). So the RHS collapses to the LHS. ∎
         The sectionwise goal lifts to this iso equation by `congrArg` on the shared
         `(toPresheaf _).map (·).hom ≫ (uι V).inv).val` `.app`-and-eqToHom wrapper.
      -/
      -- iter-030 TYPED (paper-validated iter-029).  The body below is the full iso-algebra
      -- reduction; it is wrapped in `first | … | sorry` ONLY because this lane could not obtain a
      -- green build window this iter (the `DualInverse.lean` import is RED on disk at L219 — the
      -- one-token Objective-1 fix, owned by a sibling lane, had not landed; I may not edit that
      -- file).  As soon as `DualInverse` builds green the first branch should fire and the `sorry`
      -- fallback becomes dead code — the next prover should verify and strip the `first | … |`
      -- wrapper.  See `task_results/AlgebraicJacobian_Picard_TensorObjInverse.lean.md`.
      first
      | (-- Reduce BOTH overlap legs to the single-open-`V` form (`trivialisation_restrict_compat`
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
           rw [ht_def, ← Iso.trans_assoc, Iso.self_symm_id, Iso.refl_trans]
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
         rw [hchain])
      | sorry) with hεdef
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
