/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.Modules.Sheaf

/-!
# Sheaf evaluation

For a morphism of schemes, the pullback--pushforward adjunction supplies the
canonical evaluation morphism on sheaves of modules.  We expose its counit at
the functor and object levels.
-/

open CategoryTheory
open AlgebraicGeometry

namespace MilneLib

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

end MilneLib
