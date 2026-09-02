/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Isogeny

/-!
# Descent of finite-flat isogeny certificates

This module isolates the faithfully-flat algebraic-closure step in the
finite-flat description of an isogeny.  The geometric certificate is kept
explicit: no unconditional flatness or projectivity statement is inferred.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj MorphismProperty
open AlgebraicGeometry

namespace MilneLib

open GroupVariety

/- A finite, flat, and surjective geometric base change descends all three
   properties to the original homomorphism. -/
theorem finite_flat_surjective_of_algebraicClosure_baseChange
    {K : Type u} [Field K]
    {A B : Over (Spec (.of K))} [GrpObj A] [GrpObj B]
    (hA : IsAbelianVariety A) (hB : IsAbelianVariety B)
    (f : A ⟶ B) [IsMonHom f]
    (hgeom :
      let F := Over.pullback
        (Spec.map (CommRingCat.ofHom <| algebraMap K (AlgebraicClosure K)))
      letI : GrpObj (F.obj A) := Functor.grpObjObj
      letI : GrpObj (F.obj B) := Functor.grpObjObj
      IsFinite (F.map f).left ∧ Flat (F.map f).left ∧
        Surjective (F.map f).left) :
    IsFinite f.left ∧ Flat f.left ∧ Surjective f.left := by
  let b : Spec (.of (AlgebraicClosure K)) ⟶ Spec (.of K) :=
    Spec.map (CommRingCat.ofHom <| algebraMap K (AlgebraicClosure K))
  let F := Over.pullback b
  letI : GrpObj (F.obj A) := Functor.grpObjObj
  letI : GrpObj (F.obj B) := Functor.grpObjObj
  have hgeom' :
      IsFinite (F.map f).left ∧ Flat (F.map f).left ∧
        Surjective (F.map f).left := by
    simpa [F, b] using hgeom
  letI : IsFinite (F.map f).left := hgeom'.1
  letI : Surjective (F.map f).left := hgeom'.2.2
  have hgeomIso : Isogeny (F.map f) :=
    Isogeny.of_surjective_of_finite (F.map f) hgeom'.2.2
  have hfin : IsFinite f.left := by
    apply finite_of_algebraicClosure_baseChange_isogeny hA hB f
    simpa [F, b] using hgeomIso
  have hflat : Flat f.left := by
    apply flat_of_algebraicClosure_baseChange f
    simpa [F, b] using hgeom'.2.1
  have hsurj : Surjective f.left := by
    apply surjective_of_algebraicClosure_baseChange_isogeny f
    simpa [F, b] using hgeomIso
  exact ⟨hfin, hflat, hsurj⟩

/- The descended finite-surjective certificate is exactly an isogeny. -/
theorem Isogeny.of_algebraicClosure_baseChange_finite_flat_surjective
    {K : Type u} [Field K]
    {A B : Over (Spec (.of K))} [GrpObj A] [GrpObj B]
    (hA : IsAbelianVariety A) (hB : IsAbelianVariety B)
    (f : A ⟶ B) [IsMonHom f]
    (hgeom :
      let F := Over.pullback
        (Spec.map (CommRingCat.ofHom <| algebraMap K (AlgebraicClosure K)))
      letI : GrpObj (F.obj A) := Functor.grpObjObj
      letI : GrpObj (F.obj B) := Functor.grpObjObj
      IsFinite (F.map f).left ∧ Flat (F.map f).left ∧
        Surjective (F.map f).left) :
    Isogeny f := by
  obtain ⟨hfin, _hflat, hsurj⟩ :=
    finite_flat_surjective_of_algebraicClosure_baseChange hA hB f hgeom
  letI : IsFinite f.left := hfin
  exact Isogeny.of_surjective_of_finite f hsurj

end MilneLib
