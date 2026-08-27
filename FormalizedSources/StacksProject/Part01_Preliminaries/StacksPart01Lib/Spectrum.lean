import Mathlib.RingTheory.Spectrum.Prime.Basic
import Mathlib.RingTheory.Spectrum.Prime.Topology

/-!
# Basic opens in the spectrum

The Stacks Project's Zariski-topology chapter denotes the complement of the
vanishing locus of an element by `D(f)`.  Mathlib packages this open subset as
`PrimeSpectrum.basicOpen f`; this file records the basic identities used in
that description.
-/

namespace StacksPart01

open Set

/-- Membership in the standard open `D(f)` means that `f` is not in the prime
ideal represented by the point (Stacks, Tag 00E1). -/
theorem mem_standardOpen_iff {R : Type*} [CommSemiring R]
    (f : R) (x : PrimeSpectrum R) :
    x ∈ (PrimeSpectrum.basicOpen f : Set (PrimeSpectrum R)) ↔
      f ∉ x.asIdeal := by
  exact PrimeSpectrum.mem_basicOpen f x

/-- The standard open of a product is the intersection of the standard opens
(Stacks, Tag 00E0, part (14)). -/
theorem standardOpen_mul {R : Type*} [CommSemiring R] (f g : R) :
    PrimeSpectrum.basicOpen (f * g) =
      PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen g := by
  exact PrimeSpectrum.basicOpen_mul f g

/-- `D(1)` is the whole spectrum. -/
theorem standardOpen_one {R : Type*} [CommSemiring R] :
    PrimeSpectrum.basicOpen (1 : R) = ⊤ := by
  exact PrimeSpectrum.basicOpen_one

/-- `D(0)` is empty. -/
theorem standardOpen_zero {R : Type*} [CommSemiring R] :
    PrimeSpectrum.basicOpen (0 : R) = ⊥ := by
  exact PrimeSpectrum.basicOpen_zero

/-- Standard opens are open in the Zariski topology. -/
theorem isOpen_standardOpen {R : Type*} [CommSemiring R] (f : R) :
    IsOpen (PrimeSpectrum.basicOpen f : Set (PrimeSpectrum R)) := by
  exact PrimeSpectrum.isOpen_basicOpen

/-- The map on spectra induced by a ring homomorphism is continuous
(Stacks, Tag 00E2). -/
theorem continuous_spectrum_comap {R S : Type*} [CommSemiring R] [CommSemiring S]
    (f : R →+* S) : Continuous (PrimeSpectrum.comap f) := by
  exact PrimeSpectrum.continuous_comap f

/-- Pulling a standard open back along `Spec(f)` gives the standard open of
the image of its defining element (Stacks, Tag 00E2). -/
theorem spectrum_comap_preimage_standardOpen {R S : Type*}
    [CommSemiring R] [CommSemiring S] (f : R →+* S) (x : R) :
    (PrimeSpectrum.comap f) ⁻¹' (PrimeSpectrum.basicOpen x : Set (PrimeSpectrum R)) =
      (PrimeSpectrum.basicOpen (f x) : Set (PrimeSpectrum S)) := by
  have h := PrimeSpectrum.comap_basicOpen f x
  have h' := congrArg
    (fun U : TopologicalSpace.Opens (PrimeSpectrum S) => (U : Set (PrimeSpectrum S))) h
  simpa only [TopologicalSpace.Opens.coe_comap, ContinuousMap.coe_mk] using h'

end StacksPart01
