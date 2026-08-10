/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Cohomology.ModulesPushforwardBaseChange
import Mathlib.AlgebraicGeometry.AffineScheme
import Mathlib.AlgebraicGeometry.Modules.Tilde
import Mathlib.Topology.Sheaves.Stalks

/-!
# Affine locality for native pushforward base change

This file supplies two generic reductions used when proving that a canonical base-change mate is
an isomorphism.

* `Scheme.Modules.isIso_of_isIso_app_affine` upgrades isomorphisms on every affine open to an
  isomorphism of sheaves of modules.  It uses the affine-open basis and stalks, and does not impose
  quasi-coherence or finiteness hypotheses.
* The two `of_fromTildeΓ` lemmas upgrade an isomorphism, or a bijection, on global sections of
  `Spec R` once the source and target affine presentations `fromTildeΓ` are already known to be
  isomorphisms.

The latter hypothesis is deliberately explicit.  The pinned Mathlib does not provide the general
affine equivalence between quasi-coherent modules on `Spec R` and `R`-modules, so these lemmas do
not assert that quasi-coherence alone constructs the two affine presentations.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace

namespace AlgebraicGeometry

open Scheme Scheme.Modules

-- The composite defining `e.hom` unfolds only below reducible transparency.
set_option backward.isDefEq.respectTransparency false in
/-- A morphism between two modules on `Spec R` with known affine presentations is an isomorphism
as soon as its map on the corresponding global-sections modules is an isomorphism. -/
theorem Scheme.Modules.isIso_of_isIso_moduleSpecGammaFunctor_map_of_fromTildeGamma
    {R : CommRingCat.{u}} {M N : (Spec R).Modules}
    [IsIso M.fromTildeΓ] [IsIso N.fromTildeΓ] (φ : M ⟶ N)
    (h : IsIso ((moduleSpecΓFunctor (R := R)).map φ)) : IsIso φ := by
  have key : M.fromTildeΓ ≫ φ =
      (tilde.functor R).map ((moduleSpecΓFunctor (R := R)).map φ) ≫ N.fromTildeΓ :=
    ((Scheme.Modules.fromTildeΓNatTrans (R := R)).naturality φ).symm
  let iM := asIso M.fromTildeΓ
  let iN := asIso N.fromTildeΓ
  let iG := @asIso _ _ _ _ ((moduleSpecΓFunctor (R := R)).map φ) h
  let e : M ≅ N := iM.symm ≪≫ (tilde.functor R).mapIso iG ≪≫ iN
  have he : e.hom = φ :=
    calc e.hom
        = iM.inv ≫ ((tilde.functor R).map ((moduleSpecΓFunctor (R := R)).map φ) ≫
            N.fromTildeΓ) := rfl
      _ = iM.inv ≫ (M.fromTildeΓ ≫ φ) := by rw [key]
      _ = φ := Iso.inv_hom_id_assoc iM φ
  rw [← he]
  exact e.isIso_hom

-- The functor map and `Hom.app` are definitionally equal only after unfolding a non-reducible
-- functor field.
set_option backward.isDefEq.respectTransparency false in
/-- Global-section form of
`Scheme.Modules.isIso_of_isIso_moduleSpecGammaFunctor_map_of_fromTildeGamma`. -/
theorem Scheme.Modules.isIso_of_bijective_appTop_of_fromTildeGamma
    {R : CommRingCat.{u}} {M N : (Spec R).Modules}
    [IsIso M.fromTildeΓ] [IsIso N.fromTildeΓ] (φ : M ⟶ N)
    (h : Function.Bijective (Scheme.Modules.Hom.app φ (⊤ : (Spec R).Opens))) :
    IsIso φ := by
  refine Scheme.Modules.isIso_of_isIso_moduleSpecGammaFunctor_map_of_fromTildeGamma φ ?_
  rw [ConcreteCategory.isIso_iff_bijective]
  have hfun : ⇑(ConcreteCategory.hom ((moduleSpecΓFunctor (R := R)).map φ)) =
      ⇑(ConcreteCategory.hom (Scheme.Modules.Hom.app φ (⊤ : (Spec R).Opens))) := rfl
  rw [hfun]
  exact h

/-- A morphism of scheme modules is an isomorphism if its section map is an isomorphism on every
affine open.  The proof computes stalks on the affine-open basis, then reflects the resulting
isomorphism of underlying abelian sheaves. -/
theorem Scheme.Modules.isIso_of_isIso_app_affine
    {X : Scheme.{u}} {M N : X.Modules} (φ : M ⟶ N)
    (h : ∀ (U : X.Opens), IsAffineOpen U → IsIso (φ.app U)) :
    IsIso φ := by
  let f := (SheafOfModules.toSheaf.{u} X.ringCatSheaf).map φ
  have happ (U : X.Opens) (hU : U ∈ X.affineOpens) :
      IsIso (f.hom.app (.op U)) := by
    dsimp [f]
    exact h U hU
  have hstalk (x : X) :
      IsIso ((TopCat.Presheaf.stalkFunctor Ab x).map f.hom) := by
    rw [ConcreteCategory.isIso_iff_bijective]
    constructor
    · apply TopCat.Presheaf.stalkFunctor_map_injective_of_isBasis X.isBasis_affineOpens
      intro U hU
      exact (ConcreteCategory.isIso_iff_bijective (f.hom.app (.op U))).mp
        (happ U hU) |>.1
    · intro t
      obtain ⟨U, hxU, hU, s, rfl⟩ :=
        TopCat.Presheaf.exists_mem_germ_eq_of_isBasis X.isBasis_affineOpens
          (TopCat.Sheaf.presheaf ((SheafOfModules.toSheaf.{u} X.ringCatSheaf).obj N)) x t
      letI : IsIso (f.hom.app (.op U)) := happ U hU
      refine ⟨(TopCat.Sheaf.presheaf
          ((SheafOfModules.toSheaf.{u} X.ringCatSheaf).obj M)).germ U x hxU
        (inv (f.hom.app (.op U)) s), ?_⟩
      rw [TopCat.Presheaf.stalkFunctor_map_germ_apply]
      simp
  letI (x : X) := hstalk x
  haveI : IsIso f := TopCat.Presheaf.isIso_of_stalkFunctor_map_iso f
  haveI : IsIso ((Scheme.Modules.toPresheaf X).map φ) := by
    change IsIso f.hom
    infer_instance
  exact isIso_of_reflects_iso φ (Scheme.Modules.toPresheaf X)

/-- Direct consumer for the Beck--Chevalley mate: it is enough to verify its module component on
every affine open of the target scheme `S'`. -/
theorem isIso_canonicalBaseChangeMap_app_of_affine
    {X X' S S' : Scheme.{u}}
    {f : X ⟶ S} {g : S' ⟶ S} {g' : X' ⟶ X} {f' : X' ⟶ S'}
    (sq : IsPullback g' f' f g) (M : X.Modules)
    (h : ∀ (U : S'.Opens), IsAffineOpen U →
      IsIso (((canonicalBaseChangeMap sq).app M).app U)) :
    IsIso ((canonicalBaseChangeMap sq).app M) := by
  exact Scheme.Modules.isIso_of_isIso_app_affine _ h

end AlgebraicGeometry
