/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageStableGluePackage

/-!
# Stable finite-stage gluing producer compatibility import

The authoritative constructor is
`Pic0FiniteStageStableGluePackage.ofContext`.  Keeping that constructor beside the package
lets Lean infer the dependent affine presentation from the package field and avoids a second
producer API that restates its tensor carrier.  This module remains as a compatibility import
for downstream files that previously imported the producer directly.
-/
