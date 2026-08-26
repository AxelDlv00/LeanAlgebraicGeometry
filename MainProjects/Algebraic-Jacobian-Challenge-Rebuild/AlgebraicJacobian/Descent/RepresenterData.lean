/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import Mathlib.CategoryTheory.Yoneda

/-!
# Explicit representer data

Many construction files return a dependent sigma type
`Σ X, F.RepresentableBy X`.  Projecting that sigma repeatedly makes the chosen
object and the proof of representability disappear into elaboration.  This file
provides a named package and the small transport API needed by consumers.  The
package is intentionally proof-agnostic: it does not select a new object and it
does not install any instances.
-/

set_option autoImplicit false

universe u v w

open CategoryTheory

namespace AlgebraicJacobian

noncomputable section

/-- A chosen representing object together with its representation. -/
structure RepresenterData (C : Type u) [Category.{v} C]
    (F : Cᵒᵖ ⥤ Type w) where
  object : C
  representation : F.RepresentableBy object

namespace RepresenterData

variable {C : Type u} [Category.{v} C]
variable {F : Cᵒᵖ ⥤ Type w}

/-- Package a dependent-sigma representation without losing its two components. -/
def ofSigma (s : Σ X : C, F.RepresentableBy X) : RepresenterData C F :=
  ⟨s.1, s.2⟩

/-- Recover the dependent-sigma form when an API still expects it. -/
def toSigma (P : RepresenterData C F) : Σ X : C, F.RepresentableBy X :=
  ⟨P.object, P.representation⟩

@[simp]
theorem ofSigma_toSigma (s : Σ X : C, F.RepresentableBy X) :
    (ofSigma (C := C) s).toSigma = s := by
  cases s
  rfl

@[simp]
theorem toSigma_ofSigma (s : Σ X : C, F.RepresentableBy X) :
    (ofSigma (C := C) s).toSigma = s := by
  exact ofSigma_toSigma s

/-- The canonical comparison between two chosen representing objects. -/
noncomputable def uniqueIso (P Q : RepresenterData C F) : P.object ≅ Q.object :=
  P.representation.uniqueUpToIso Q.representation

/-- Transport a representation along a specified object isomorphism. -/
def transport (P : RepresenterData C F) {Y : C} (e : Y ≅ P.object) :
    F.RepresentableBy Y :=
  P.representation.ofIsoObj e

/-- A package-level transport operation, retaining the supplied object name. -/
def transportData (P : RepresenterData C F) {Y : C} (e : Y ≅ P.object) :
    RepresenterData C F :=
  ⟨Y, P.transport e⟩

@[simp]
theorem transportData_object (P : RepresenterData C F) {Y : C} (e : Y ≅ P.object) :
    (P.transportData e).object = Y :=
  rfl

end RepresenterData

end

end AlgebraicJacobian
