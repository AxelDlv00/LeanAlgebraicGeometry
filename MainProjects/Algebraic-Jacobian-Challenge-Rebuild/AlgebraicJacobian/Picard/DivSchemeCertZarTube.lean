/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/

import AlgebraicJacobian.Picard.DivSchemeCertZarPointwise
import AlgebraicJacobian.Picard.SupportTubeFinite

/-!
# The support tube in `Away`-chart form

The pointwise certificate gate (`DivSchemeCertZarPointwise.lean`) asks, at each base prime
`p`, for an element `r ∉ p` such that the pulled system is certified over
`Localization.Away r`.  The support tube (`Scheme.LocalEquations.exists_supportTube`)
delivers piece isolation over an *abstract* Zariski neighbourhood `V` of `p`.  This file
refines that neighbourhood to a basic open — the shape `Localization.Away` needs — and
records the resulting statement.

The refinement is the standard fact that basic opens form a topological basis of
`Spec R` (`PrimeSpectrum.isBasis_basic_opens`); the content is only that the tube's
conclusion is monotone in the neighbourhood, so shrinking `V` to a basic open inside it
preserves support isolation.

## Main declarations

* `AlgebraicGeometry.Scheme.LocalEquations.exists_basicOpen_supportTube` — the tube with a
  basic-open neighbourhood: an `r ∉ p` whose basic open isolates the support inside `U`.
* `AlgebraicGeometry.exists_notMem_supportLocus_subset_of_fibre` — the same for the
  relative curve over a test ring, with the properness licence supplied.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits TopologicalSpace Opposite

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

namespace Scheme.LocalEquations

variable {X : Scheme.{u}} {R : Type u} [CommRing R] (d : X.LocalEquations)

/-- **The support tube with a basic-open neighbourhood.** If the support fibre over a base
prime `p` lies inside an open `U`, then some `r ∉ p` has its whole basic-open preimage's
support inside `U`.

The tube produces an abstract neighbourhood; basic opens are a basis of `Spec R`
(`PrimeSpectrum.isBasis_basic_opens`), so shrinking to a basic open inside it keeps the
conclusion by monotonicity of the preimage. This is the form the `Localization.Away`
charts of `IsLocallyCertified` consume. -/
theorem exists_basicOpen_supportTube (f : X ⟶ Spec (CommRingCat.of R))
    [UniversallyClosed f] {U : Set X} (hU : IsOpen U) {p : PrimeSpectrum R}
    (hfib : f.base ⁻¹' {(p : Spec (CommRingCat.of R))} ∩ d.supportLocus ⊆ U) :
    ∃ r : R, r ∉ p.asIdeal ∧
      f.base ⁻¹' (PrimeSpectrum.basicOpen r : Set (PrimeSpectrum R))
        ∩ d.supportLocus ⊆ U := by
  obtain ⟨V, hpV, hV⟩ := d.exists_supportTube f hU hfib
  -- refine `V` to a basic open around `p`
  obtain ⟨W, hWmem, hpW, hWV⟩ :=
    PrimeSpectrum.isTopologicalBasis_basic_opens.exists_subset_of_mem_open
      (a := p) hpV V.isOpen
  obtain ⟨r, rfl⟩ := hWmem
  exact ⟨r, (PrimeSpectrum.mem_basicOpen r p).mp hpW,
    fun x hx => hV ⟨hWV hx.1, hx.2⟩⟩

end Scheme.LocalEquations

/-! ## The relative-curve form -/

section RelCurve

variable {k : Type u} [Field k] (C : Over (Spec (.of k))) [IsProper C.hom]
variable (R : Type u) [CommRing R] [Algebra k R]

/-- **The relative-curve support tube, basic-open form.** For a local-equation system on
the relative curve over a test ring, fibrewise containment of the support in an open `U`
at a prime `p` gives an `r ∉ p` isolating the support over the basic open of `r`.

The properness licence is `instIsProperRelCurveHom`; `UniversallyClosed` fires by
resolution. -/
theorem exists_notMem_supportLocus_subset_of_fibre
    (d : (relCurve C R).LocalEquations) {U : Set (relCurve C R)} (hU : IsOpen U)
    {p : PrimeSpectrum R}
    (hfib : ((relCurve C R) ↘ Spec (CommRingCat.of R)).base ⁻¹'
        {(p : Spec (CommRingCat.of R))} ∩ d.supportLocus ⊆ U) :
    ∃ r : R, r ∉ p.asIdeal ∧
      ((relCurve C R) ↘ Spec (CommRingCat.of R)).base ⁻¹'
          (PrimeSpectrum.basicOpen r : Set (PrimeSpectrum R))
        ∩ d.supportLocus ⊆ U :=
  d.exists_basicOpen_supportTube _ hU hfib

end RelCurve

end AlgebraicGeometry
