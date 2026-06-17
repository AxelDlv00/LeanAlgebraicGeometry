/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.HigherDirectImage
import AlgebraicJacobian.Cohomology.CechHigherDirectImage

/-!
# Presheaf description of the higher direct images `Rⁱ f_*` (Stacks 01XJ)

This file builds project-local infrastructure towards
`lem:higher_direct_image_presheaf`: `Rⁱ f_* F` is the sheafification of the
presheaf `V ↦ Hⁱ(f⁻¹(V), F)`.

See `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

end AlgebraicGeometry
