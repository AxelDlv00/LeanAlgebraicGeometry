import StacksPart01Lib.Spectrum

/-!
# Zariski standard opens

This file exposes the basic-open API in the set-theoretic notation used for
the Stacks Project's Zariski topology.  Mathlib represents `D(f)` as the open
set `PrimeSpectrum.basicOpen f`; the statements below simply record its
underlying set and the principal identities needed for calculations.
-/

namespace StacksPart01

open Set

namespace Zariski

/-- The standard open `D(f)` is the complement of `V(f)` (Stacks, Tag 00E0). -/
theorem standardOpen_eq_compl_zeroLocus {R : Type*} [CommSemiring R] (f : R) :
    (PrimeSpectrum.basicOpen f : Set (PrimeSpectrum R)) =
      (PrimeSpectrum.zeroLocus ({f} : Set R))ᶜ := by
  exact PrimeSpectrum.basicOpen_eq_zeroLocus_compl f

/-- The standard open of a product is the intersection of the standard opens.
(Stacks, Tag 00E0, part (15).) -/
theorem standardOpen_mul_set {R : Type*} [CommSemiring R] (f g : R) :
    (PrimeSpectrum.basicOpen (f * g) : Set (PrimeSpectrum R)) =
      (PrimeSpectrum.basicOpen f : Set (PrimeSpectrum R)) ∩
        (PrimeSpectrum.basicOpen g : Set (PrimeSpectrum R)) := by
  have h := PrimeSpectrum.basicOpen_mul f g
  exact congrArg (fun U : TopologicalSpace.Opens (PrimeSpectrum R) =>
    (U : Set (PrimeSpectrum R))) h

/-- Taking a positive power does not change a standard open. -/
theorem standardOpen_pow_set {R : Type*} [CommSemiring R] (f : R) (n : ℕ)
    (hn : 0 < n) :
    (PrimeSpectrum.basicOpen (f ^ n) : Set (PrimeSpectrum R)) =
      (PrimeSpectrum.basicOpen f : Set (PrimeSpectrum R)) := by
  have h := PrimeSpectrum.basicOpen_pow f n hn
  exact congrArg (fun U : TopologicalSpace.Opens (PrimeSpectrum R) =>
    (U : Set (PrimeSpectrum R))) h

/-- Principal opens form a basis for the Zariski topology. -/
theorem standardOpen_isTopologicalBasis {R : Type*} [CommSemiring R] :
    TopologicalSpace.IsTopologicalBasis
      (Set.range fun f : R =>
        (PrimeSpectrum.basicOpen f : Set (PrimeSpectrum R))) :=
  PrimeSpectrum.isTopologicalBasis_basic_opens

/-- A family of standard opens covers `Spec(R)` exactly when its elements
generate the unit ideal (Stacks, Tag 00E0, parts (16)--(17)). -/
theorem standardOpen_iSup_eq_top_iff {R : Type*} [CommSemiring R] {ι : Type*}
    (f : ι → R) :
    (⨆ i : ι, PrimeSpectrum.basicOpen (f i)) = ⊤ ↔
      Ideal.span (Set.range f) = ⊤ := by
  exact PrimeSpectrum.iSup_basicOpen_eq_top_iff

end Zariski

end StacksPart01
