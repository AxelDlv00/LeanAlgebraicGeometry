/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexLieFlowParameter

/-!
# Real regularity of complex-parameterized flows

The complex parameter is used only as a real parameter here.  For a fixed
tangent vector, scalar multiplication is a real-smooth map, so the existing
real time-one regularity theorem gives a genuine `C¹` parameterized flow.
-/

set_option autoImplicit false

noncomputable section

open Function Set
open scoped Manifold ContDiff

namespace Mumford
namespace Analytic

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [Group G]
  [LieGroup I ω G]

/-- For a fixed tangent vector, the complex-parameterized flow is `C¹` as a
real map from the underlying real complex line to the realified Lie group.
This makes no holomorphicity claim. -/
theorem canonicalComplexFlow_contMDiff_of_vector
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] (v : E) :
    ContMDiff 𝓘(ℝ, ℂ) (complexToRealModel I) 1
      (fun z : ℂ => canonicalComplexFlow (G := G) I v z) := by
  have hsmul : ContDiff ℝ 1 (fun z : ℂ => z • v) :=
    contDiff_smul_const v
  have hsmul' : ContMDiff 𝓘(ℝ, ℂ) 𝓘(ℝ, E) 1
      (fun z : ℂ => z • v) :=
    hsmul.contMDiff
  have hflow := canonicalRealFlow_time_one_contMDiff (G := G) I
  have hcomp := hflow.comp hsmul'
  change ContMDiff 𝓘(ℝ, ℂ) (complexToRealModel I) 1
    (fun z : ℂ => canonicalRealFlow (G := G) I (z • v) 1) at hcomp
  simpa [canonicalComplexFlow, complexToRealLieAlgebraMap] using hcomp

end Analytic
end Mumford
