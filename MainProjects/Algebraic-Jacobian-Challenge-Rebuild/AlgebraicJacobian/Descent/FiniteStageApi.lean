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
import AlgebraicJacobian.Picard.Pic0FiniteStageStableGluePackage
import AlgebraicJacobian.Picard.Pic0FiniteStageStableGlueProducer
import AlgebraicJacobian.Picard.Pic0FiniteStageStableGluedOver
import AlgebraicJacobian.Picard.Pic0FiniteStageStableRestrictionBaseChange

/-!
# Public finite-stage API

This import-light facade is the migration boundary for finite-stage consumers.  New
files should import it instead of rebuilding tensor, pullback, representer, and stage
infrastructure from local `letI` blocks.
-/
