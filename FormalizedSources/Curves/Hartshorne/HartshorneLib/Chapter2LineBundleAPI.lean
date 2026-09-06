/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter2LineBundles

/-!
# Basic line-bundle API

This file supplies elementary constructors for the Chapter II local-triviality
predicate on scheme modules.
-/

set_option autoImplicit false

open CategoryTheory TopologicalSpace

namespace Hartshorne

universe u

open AlgebraicGeometry

/-- Restriction of the structure sheaf along an open immersion is the
structure sheaf of the source. -/
noncomputable def restrictUnitIso {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] :
    (Scheme.Modules.restrictFunctor f).obj
        (SheafOfModules.unit X.ringCatSheaf) ≅
      SheafOfModules.unit Y.ringCatSheaf := by
  letI : (TopologicalSpace.Opens.map f.base).Final :=
    CategoryTheory.final_of_representablyFlat _
  exact (Scheme.Modules.restrictFunctorIsoPullback f).app _ ≪≫
    @asIso _ _ _ _ _ (inferInstance :
      IsIso (SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom))

/-- The structure sheaf, viewed as a module over itself, is a line bundle. -/
theorem isLineBundle_unit {X : Scheme.{u}} :
    IsLineBundle (SheafOfModules.unit X.ringCatSheaf) := by
  intro x
  let U : X.Opens := ⊤
  have hx : x ∈ U := by
    trivial
  refine ⟨U, hx, ?_⟩
  exact ⟨restrictUnitIso U.ι⟩

/-- Any module globally isomorphic to the structure sheaf is a line bundle. -/
theorem isLineBundle_of_iso_unit {X : Scheme.{u}} {M : X.Modules}
    (e : M ≅ SheafOfModules.unit X.ringCatSheaf) : IsLineBundle M := by
  exact isLineBundle_unit.of_iso e.symm

end Hartshorne
