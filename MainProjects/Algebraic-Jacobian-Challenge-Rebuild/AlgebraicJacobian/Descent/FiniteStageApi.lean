/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Descent.FiniteStagePullbackData
import AlgebraicJacobian.Descent.GluedMapData
import AlgebraicJacobian.Descent.RepresenterData
import AlgebraicJacobian.Descent.TensorProductPushoutData
import AlgebraicJacobian.Descent.AffineRingGlueData
import AlgebraicJacobian.Picard.FiniteStageData
import AlgebraicJacobian.Picard.Pic0FiniteStageGluePackage
import AlgebraicJacobian.Picard.Pic0FiniteStageGluedOver
import AlgebraicJacobian.Picard.Pic0FiniteStageRestrictionBaseChange

/-!
# Public finite-stage API

This import-light facade exports the canonical finite-stage glue package together with its
glued-over and restriction-base-change interfaces.  Consumers can use the package directly
without rebuilding tensor, pullback, representer, or stage infrastructure from local `letI`
blocks.

The final-stage comparison has the same dependent tensor boundary and is exposed through
`AlgebraicJacobian.Picard.Pic0FiniteStageFinalBaseChangeApi`; keeping that import separate
lets clients opt into the pinned comparison functions without widening this lightweight
facade.
-/
