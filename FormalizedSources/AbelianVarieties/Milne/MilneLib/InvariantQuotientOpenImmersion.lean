/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.AffineScheme
import Mathlib.AlgebraicGeometry.OpenImmersion
import Mathlib.AlgebraicGeometry.Morphisms.IsIso
import Mathlib.AlgebraicGeometry.Restrict

/-!
# Open immersions on principal affine charts

This file records the scheme-theoretic producer used by the invariant quotient
charts.  A bijective localization-away map identifies the restricted spectrum
map with an isomorphism, hence gives an open immersion.  The localization
hypothesis is explicit; no quotient-existence or global invariant-theory
assumption is hidden in the statement.
-/

set_option autoImplicit false

open CategoryTheory AlgebraicGeometry

namespace MilneLib
namespace InvariantLocalization

/-- A spectrum map restricts to an open immersion on a principal chart whenever
the corresponding localization-away ring map is bijective. -/
theorem isOpenImmersion_restrictBasicOpen_of_bijective
    {R S : CommRingCat} (f : R ⟶ S) (r : R)
    (h : Function.Bijective (Localization.awayMap f.hom r)) :
    IsOpenImmersion (Spec.map f ∣_ (PrimeSpectrum.basicOpen r)) := by
  rw [MorphismProperty.arrow_mk_iso_iff @IsOpenImmersion
    (SpecMapRestrictBasicOpenIso f r)]
  haveI : IsIso (Spec.map (CommRingCat.ofHom
      (Localization.awayMap f.hom r))) :=
    (isIso_SpecMap_iff.mpr h)
  infer_instance

end InvariantLocalization
end MilneLib
