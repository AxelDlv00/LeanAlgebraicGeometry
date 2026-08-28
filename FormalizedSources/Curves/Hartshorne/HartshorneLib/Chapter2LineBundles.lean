/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import Mathlib.AlgebraicGeometry.Modules.Sheaf
import Mathlib.AlgebraicGeometry.Restrict

/-!
# Line bundles

This file records the local-triviality definition of an invertible sheaf used in
Chapter II and its basic invariance under isomorphism.
-/

set_option autoImplicit false

open CategoryTheory TopologicalSpace

namespace Hartshorne

universe u

open AlgebraicGeometry

/-- A scheme module is a line bundle if it is locally isomorphic to the structure sheaf. -/
def IsLineBundle {X : Scheme.{u}} (M : X.Modules) : Prop :=
  ∀ x : X, ∃ U : X.Opens, x ∈ U ∧
    Nonempty ((Scheme.Modules.restrictFunctor U.ι).obj M ≅
      SheafOfModules.unit U.toScheme.ringCatSheaf)

/-- Being a line bundle is preserved by isomorphism of scheme modules. -/
theorem IsLineBundle.of_iso {X : Scheme.{u}} {M N : X.Modules}
    (hM : IsLineBundle M) (e : M ≅ N) : IsLineBundle N := by
  intro x
  obtain ⟨U, hx, ⟨i⟩⟩ := hM x
  exact ⟨U, hx, ⟨(Scheme.Modules.restrictFunctor U.ι).mapIso e.symm ≪≫ i⟩⟩

/-- Isomorphic scheme modules are line bundles simultaneously. -/
theorem isLineBundle_iff_of_iso {X : Scheme.{u}} {M N : X.Modules}
    (e : M ≅ N) : IsLineBundle M ↔ IsLineBundle N :=
  ⟨fun hM ↦ hM.of_iso e, fun hN ↦ hN.of_iso e.symm⟩

end Hartshorne
