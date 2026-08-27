/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.Modules.Sheaf
import Mathlib.Topology.Sheaves.LocallySurjective

/-!
# Sheaf evaluation

For a morphism of schemes, the pullback--pushforward adjunction supplies the
canonical evaluation morphism on sheaves of modules.  We expose its counit at
the functor and object levels.
-/

open CategoryTheory
open AlgebraicGeometry

namespace MilneLib

/-- A morphism of sheaves of modules that is surjective on every stalk is an
epimorphism. -/
theorem schemeModule_epi_of_surjective_on_stalks {X : Scheme} {M N : X.Modules}
    (f : M ⟶ N)
    (hf : ∀ x : X, Function.Surjective
      ((TopCat.Presheaf.stalkFunctor AddCommGrpCat x).map f.mapPresheaf)) :
    Epi f := by
  let F := SheafOfModules.toSheaf X.ringCatSheaf
  have hlocal : TopCat.Presheaf.IsLocallySurjective (F.map f).hom :=
    (TopCat.Presheaf.locally_surjective_iff_surjective_on_stalks _).2 hf
  have : Epi (F.map f) := by
    letI : CategoryTheory.Sheaf.IsLocallySurjective (F.map f) := hlocal
    infer_instance
  exact F.epi_of_epi_map this

/-- The counit of the pullback--pushforward adjunction for a scheme morphism. -/
noncomputable def schemeSheafEvaluation {W V : Scheme} (f : W ⟶ V) :
    (Scheme.Modules.pushforward f ⋙ Scheme.Modules.pullback f) ⟶ 𝟭 W.Modules :=
  (Scheme.Modules.pullbackPushforwardAdjunction f).counit

/-- Evaluation on a particular sheaf of modules. -/
noncomputable def schemeSheafEvaluationAt {W V : Scheme} (f : W ⟶ V)
    (M : W.Modules) :
    (Scheme.Modules.pullback f).obj ((Scheme.Modules.pushforward f).obj M) ⟶ M :=
  (Scheme.Modules.pullbackPushforwardAdjunction f).counit.app M

@[simp]
theorem schemeSheafEvaluation_app {W V : Scheme} (f : W ⟶ V) (M : W.Modules) :
    (schemeSheafEvaluation f).app M = schemeSheafEvaluationAt f M := rfl

/-- Evaluation is natural in the sheaf of modules. -/
theorem schemeSheafEvaluationAt_naturality {W V : Scheme} (f : W ⟶ V)
    {M N : W.Modules} (g : M ⟶ N) :
    (Scheme.Modules.pullback f).map ((Scheme.Modules.pushforward f).map g) ≫
        schemeSheafEvaluationAt f N =
      schemeSheafEvaluationAt f M ≫ g := by
  exact (schemeSheafEvaluation f).naturality g

/-- The unit of the pullback--pushforward adjunction for a scheme morphism. -/
noncomputable def schemeSheafCoevaluation {W V : Scheme} (f : W ⟶ V) :
    Functor.id V.Modules ⟶
      (Scheme.Modules.pullback f ⋙ Scheme.Modules.pushforward f) :=
  (Scheme.Modules.pullbackPushforwardAdjunction f).unit

/-- Coevaluation on a particular sheaf of modules. -/
noncomputable def schemeSheafCoevaluationAt {W V : Scheme} (f : W ⟶ V)
    (M : V.Modules) :
    M ⟶ (Scheme.Modules.pushforward f).obj
      ((Scheme.Modules.pullback f).obj M) :=
  (Scheme.Modules.pullbackPushforwardAdjunction f).unit.app M

@[simp]
theorem schemeSheafCoevaluation_app {W V : Scheme} (f : W ⟶ V)
    (M : V.Modules) :
    (schemeSheafCoevaluation f).app M = schemeSheafCoevaluationAt f M := rfl

/-- Coevaluation is natural in the sheaf of modules. -/
theorem schemeSheafCoevaluationAt_naturality {W V : Scheme} (f : W ⟶ V)
    {M N : V.Modules} (g : M ⟶ N) :
    g ≫ schemeSheafCoevaluationAt f N =
      schemeSheafCoevaluationAt f M ≫
        (Scheme.Modules.pushforward f).map
          ((Scheme.Modules.pullback f).map g) := by
  exact (schemeSheafCoevaluation f).naturality g

/-- Pulling back coevaluation and then evaluating is the identity. -/
@[simp]
theorem schemeSheafCoevaluation_evaluation {W V : Scheme} (f : W ⟶ V)
    (M : V.Modules) :
    (Scheme.Modules.pullback f).map (schemeSheafCoevaluationAt f M) ≫
        schemeSheafEvaluationAt f ((Scheme.Modules.pullback f).obj M) =
      𝟙 ((Scheme.Modules.pullback f).obj M) := by
  exact (Scheme.Modules.pullbackPushforwardAdjunction f).left_triangle_components M

/-- Coevaluating a pushforward and then pushing forward evaluation is the identity. -/
@[simp]
theorem schemeSheafEvaluation_coevaluation {W V : Scheme} (f : W ⟶ V)
    (M : W.Modules) :
    schemeSheafCoevaluationAt f ((Scheme.Modules.pushforward f).obj M) ≫
        (Scheme.Modules.pushforward f).map (schemeSheafEvaluationAt f M) =
      𝟙 ((Scheme.Modules.pushforward f).obj M) := by
  exact (Scheme.Modules.pullbackPushforwardAdjunction f).right_triangle_components M

end MilneLib
