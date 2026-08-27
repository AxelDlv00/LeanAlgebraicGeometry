/-
Copyright (c) 2026 The StacksPart05Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart05Lib Contributors
-/

import Mathlib.AlgebraicGeometry.Morphisms.UnderlyingMap
import Mathlib.AlgebraicGeometry.PullbackCarrier
import Mathlib.CategoryTheory.MorphismProperty.Limits

/-!
# StacksPart05Lib.Surjectivity

The scheme-model closure properties for the surjective morphisms appearing in
the formal algebraic space chapter.
-/

namespace StacksPart05Lib

open CategoryTheory
open CategoryTheory.Limits
open AlgebraicGeometry

/-- The surjectivity property in the representable scheme model. -/
def schemeSurjective : MorphismProperty Scheme :=
  @AlgebraicGeometry.Surjective

@[simp]
theorem schemeSurjective_iff {X Y : Scheme} (f : X ⟶ Y) :
    schemeSurjective f ↔ AlgebraicGeometry.Surjective f := Iff.rfl

/-- Surjectivity is preserved by composition of scheme morphisms. -/
theorem scheme_surjective_comp {X Y Z : Scheme} (f : X ⟶ Y) (g : Y ⟶ Z)
    [AlgebraicGeometry.Surjective f] [AlgebraicGeometry.Surjective g] :
    schemeSurjective (f ≫ g) := by
  exact ⟨g.surjective.comp f.surjective⟩

/-- Surjectivity of a composite implies surjectivity of its second leg. -/
theorem scheme_surjective_of_comp {X Y Z : Scheme} (f : X ⟶ Y) (g : Y ⟶ Z)
    [AlgebraicGeometry.Surjective (f ≫ g)] :
    schemeSurjective g := by
  exact AlgebraicGeometry.Surjective.of_comp f g

/-- Surjectivity is preserved by pullback on the second leg. -/
theorem scheme_surjective_baseChange {X Y S : Scheme} (f : X ⟶ S)
    (g : Y ⟶ S) [AlgebraicGeometry.Surjective f] :
    schemeSurjective (pullback.snd f g) := by
  change AlgebraicGeometry.Surjective (pullback.snd f g)
  infer_instance

/-- Surjectivity is preserved by pullback on the first leg. -/
theorem scheme_surjective_baseChange_fst {X Y S : Scheme} (f : X ⟶ S)
    (g : Y ⟶ S) [AlgebraicGeometry.Surjective g] :
    schemeSurjective (pullback.fst f g) := by
  change AlgebraicGeometry.Surjective (pullback.fst f g)
  infer_instance

instance schemeSurjective_isStableUnderComposition :
    MorphismProperty.IsStableUnderComposition schemeSurjective where
  comp_mem f g hf hg := by
    change AlgebraicGeometry.Surjective (f ≫ g)
    exact ⟨hg.surj.comp hf.surj⟩

instance schemeSurjective_isStableUnderBaseChange :
    MorphismProperty.IsStableUnderBaseChange schemeSurjective where
  of_isPullback sq hg := by
    change AlgebraicGeometry.Surjective _
    exact MorphismProperty.of_isPullback sq hg

end StacksPart05Lib
