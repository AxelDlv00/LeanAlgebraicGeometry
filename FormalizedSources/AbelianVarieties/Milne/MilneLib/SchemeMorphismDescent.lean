/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.Scheme

/-!
# Locality of descended scheme morphisms

A factor of a scheme morphism in presheafed spaces is a scheme morphism
whenever its first leg is surjective. Locality on stalks descends by testing
after the stalk map of a point above the given target point.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry

namespace MilneLib

variable {X Y Z : Scheme.{u}}

set_option backward.isDefEq.respectTransparency false in
/-- A presheafed-space factor of a scheme morphism through a surjective scheme
morphism is local on every stalk. -/
theorem presheafedSpaceFactor_stalkMap_isLocalHom
    (q : X ⟶ Y) (hq : Function.Surjective q) (f : X ⟶ Z)
    (g : Y.toPresheafedSpace ⟶ Z.toPresheafedSpace)
    (h : q.toLRSHom.toHom ≫ g = f.toLRSHom.toHom) (y : Y) :
    IsLocalHom (g.stalkMap y).hom := by
  obtain ⟨x, rfl⟩ := hq y
  suffices IsLocalHom ((q.toLRSHom.toHom.stalkMap x).hom.comp
      (g.stalkMap (q x)).hom) from
    isLocalHom_of_comp _ (q.toLRSHom.toHom.stalkMap x).hom
  rw [← CommRingCat.hom_comp, ← PresheafedSpace.stalkMap.comp]
  rw [PresheafedSpace.stalkMap.congr_hom _ _ h x, CommRingCat.hom_comp]
  infer_instance

/-- Lift a presheafed-space factor through a surjective scheme morphism to a
scheme morphism using the descended locality on stalks. -/
def schemeMorphismOfPresheafedSpaceFactor
    (q : X ⟶ Y) (hq : Function.Surjective q) (f : X ⟶ Z)
    (g : Y.toPresheafedSpace ⟶ Z.toPresheafedSpace)
    (h : q.toLRSHom.toHom ≫ g = f.toLRSHom.toHom) : Y ⟶ Z :=
  ⟨⟨g, presheafedSpaceFactor_stalkMap_isLocalHom q hq f g h⟩⟩

@[simp]
theorem schemeMorphismOfPresheafedSpaceFactor_toHom
    (q : X ⟶ Y) (hq : Function.Surjective q) (f : X ⟶ Z)
    (g : Y.toPresheafedSpace ⟶ Z.toPresheafedSpace)
    (h : q.toLRSHom.toHom ≫ g = f.toLRSHom.toHom) :
    (schemeMorphismOfPresheafedSpaceFactor q hq f g h).toLRSHom.toHom = g :=
  rfl

@[reassoc (attr := simp)]
theorem comp_schemeMorphismOfPresheafedSpaceFactor
    (q : X ⟶ Y) (hq : Function.Surjective q) (f : X ⟶ Z)
    (g : Y.toPresheafedSpace ⟶ Z.toPresheafedSpace)
    (h : q.toLRSHom.toHom ≫ g = f.toLRSHom.toHom) :
    q ≫ schemeMorphismOfPresheafedSpaceFactor q hq f g h = f := by
  apply Scheme.forgetToLocallyRingedSpace.map_injective
  exact LocallyRingedSpace.Hom.ext' h

end MilneLib
