/-
Copyright (c) 2026 Axel Delaval. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Axel Delaval
-/
import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence
import AlgebraicJacobian.Picard.PicEtQuotientHom

/-!
# The descent ASSEMBLY: a `k`-representation of `picEt C` from cover-compatible classes

`AJC.picrep.etale-rep.descent-assembly`.

WORK IN PROGRESS — bodies are `sorry` while the statements are measured.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry Limits Opposite

namespace AlgebraicGeometry

namespace Scheme

namespace PicScheme

variable {k : Type u} [Field k] {k' : Type u} [Field k'] [Algebra k k']

/-- The cover as an ENDOFUNCTOR of `k`-tests: `T ↦ T_{k'}`, read back as a `k`-test.
Mathlib's `Over.pullback` followed by `restrictTest = Over.map`. -/
noncomputable abbrev coverFunctor :
    Over (Spec (CommRingCat.of k)) ⥤ Over (Spec (CommRingCat.of k)) :=
  Over.pullback (specMapAlgebra k k') ⋙ restrictTest k k'

theorem coverFunctor_obj (T : Over (Spec (CommRingCat.of k))) :
    (coverFunctor (k := k) (k' := k')).obj T
      = (restrictTest k k').obj (baseTest (k' := k') T) := rfl

/-- `coverMap` is the COUNIT of `Over.map ⊣ Over.pullback`. -/
theorem coverMap_eq_counit (T : Over (Spec (CommRingCat.of k))) :
    coverMap (k' := k') T
      = (Over.mapPullbackAdj (specMapAlgebra k k')).counit.app T := by
  apply Over.OverMorphism.ext
  change pullback.fst T.hom (specMapAlgebra k k') = _
  simp

theorem coverFunctor_map_comp_coverMap {T T' : Over (Spec (CommRingCat.of k))}
    (f : T ⟶ T') :
    (coverFunctor (k := k) (k' := k')).map f ≫ coverMap (k' := k') T'
      = coverMap (k' := k') T ≫ f := by
  rw [coverMap_eq_counit, coverMap_eq_counit]
  exact (Over.mapPullbackAdj (specMapAlgebra k k')).counit.naturality f

/-- A class on `T_{k'}` whose two pullbacks to the self-intersection of the cover agree. -/
def IsCoverCompatible (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    (x : (picEt C).obj (op ((coverFunctor (k := k) (k' := k')).obj T))) : Prop :=
  (picEt C).map (pullback.fst (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)).op x
    = (picEt C).map (pullback.snd (coverMap (k := k) (k' := k') T)
        (coverMap (k := k) (k' := k') T)).op x

/-- The cover-compatible classes on `T_{k'}`. -/
def CoverCompatible (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k))) : Type (u + 1) :=
  {x : (picEt C).obj (op ((coverFunctor (k := k) (k' := k')).obj T)) //
    IsCoverCompatible (k' := k') C T x}

section Descend

variable [Algebra.IsSeparable k k'] [Module.Finite k k']

omit [Algebra.IsSeparable k k'] [Module.Finite k k'] in
theorem isCoverCompatible_restrict (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k))) (y : (picEt C).obj (op T)) :
    IsCoverCompatible (k' := k') C T ((picEt C).map (coverMap (k' := k') T).op y) := by
  change (picEt C).map _ ((picEt C).map _ y) = (picEt C).map _ ((picEt C).map _ y)
  rw [← CategoryTheory.comp_apply, ← CategoryTheory.comp_apply, ← Functor.map_comp,
    ← Functor.map_comp, ← op_comp, ← op_comp, pullback.condition]

/-- Restriction along the cover, as a map into the cover-compatible classes. -/
noncomputable def restrictCompat (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k))) (y : (picEt C).obj (op T)) :
    CoverCompatible (k' := k') C T :=
  ⟨(picEt C).map (coverMap (k' := k') T).op y, isCoverCompatible_restrict C T y⟩

theorem restrictCompat_bijective (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k))) :
    Function.Bijective (restrictCompat (k' := k') C T) := by
  constructor
  · intro a b hab
    exact picEt_injective_restrict_baseTest (k' := k') C T (congrArg Subtype.val hab)
  · rintro ⟨x, hx⟩
    obtain ⟨y, hy, -⟩ := exists_unique_descend_picEt_of_projections (k' := k') C T x hx
    exact ⟨y, Subtype.ext hy⟩

/-- **The descent equivalence**: classes on `T` are exactly the cover-compatible
classes on `T_{k'}`. -/
noncomputable def restrictCompatEquiv (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k))) :
    (picEt C).obj (op T) ≃ CoverCompatible (k' := k') C T :=
  Equiv.ofBijective _ (restrictCompat_bijective (k' := k') C T)

end Descend

end PicScheme

end Scheme

end AlgebraicGeometry
