/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.Modules.Tilde

/-!
# Affine modules and global sections

On an affine scheme, a module and the global sections of its associated
quasi-coherent sheaf are canonically isomorphic.  These declarations expose
the affine instance used in Milne's module--sheaf discussion, together with
its functoriality and its finite-dimensional specialization over a field.
-/

open CategoryTheory
open AlgebraicGeometry
open Opposite

universe u

namespace MilneLib

/-- The quasi-coherent sheaf associated with a module on `Spec R`. -/
noncomputable def affineModuleSheaf
    (R : CommRingCat.{u}) (M : ModuleCat R) : (Spec R).Modules :=
  AlgebraicGeometry.tilde M

/-- The canonical identification of a module with the global sections of its
associated affine sheaf. -/
noncomputable def affineModuleGlobalSectionsIso
    (R : CommRingCat.{u}) (M : ModuleCat R) :
    M ≅ AlgebraicGeometry.moduleSpecΓFunctor.obj (affineModuleSheaf R M) :=
  AlgebraicGeometry.tilde.isoTop M

/-- The affine global-sections identification is natural in the module. -/
theorem affineModuleGlobalSectionsIso_naturality
    (R : CommRingCat.{u}) {M N : ModuleCat R} (f : M ⟶ N) :
    f ≫ (affineModuleGlobalSectionsIso R N).hom =
      (affineModuleGlobalSectionsIso R M).hom ≫
        AlgebraicGeometry.moduleSpecΓFunctor.map
          ((AlgebraicGeometry.tilde.functor R).map f) := by
  exact (AlgebraicGeometry.tilde.toTildeΓNatIso (R := R)).hom.naturality f

/-- Pushforward preserves the underlying global-sections module at the top open. -/
@[simp]
theorem pushforward_globalSections_top
    {X Y : Scheme.{u}} (f : X ⟶ Y) (M : X.Modules) :
    Γ((Scheme.Modules.pushforward f).obj M, (⊤ : Y.Opens)) =
      Γ(M, (⊤ : X.Opens)) := by
  rfl

/-- The preceding affine construction for a finite-dimensional vector space. -/
noncomputable def affineVectorSpaceSheaf
    {k : Type u} [Field k] (M : ModuleCat (CommRingCat.of k)) :
    (Spec (CommRingCat.of k)).Modules :=
  affineModuleSheaf (CommRingCat.of k) M

/-- A finite-dimensional vector space is recovered from the global sections of
its associated sheaf on the one-point affine scheme. -/
noncomputable def affineVectorSpaceGlobalSectionsIso
    {k : Type u} [Field k] (M : ModuleCat (CommRingCat.of k))
    [Module.Finite (CommRingCat.of k) M] :
    M ≅ AlgebraicGeometry.moduleSpecΓFunctor.obj (affineVectorSpaceSheaf M) :=
  affineModuleGlobalSectionsIso (CommRingCat.of k) M

end MilneLib
