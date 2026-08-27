/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter1Variety
import HartshorneLib.Chapter1Ideals
import Mathlib.RingTheory.Ideal.Prime
import Mathlib.RingTheory.Ideal.Operations

/-!
# Hartshorne I.1: irreducibility and prime vanishing ideals

An irreducible algebraic set has a prime vanishing ideal.  The proof uses only
the closed-cover characterization of topological irreducibility and the
product law for polynomial zero sets, so it is independent of the affine
Nullstellensatz.
-/

namespace Hartshorne

noncomputable section

section AffinePrime

variable (k : Type*) [Field k] (n : Nat)

/-- The vanishing ideal of an affine variety is prime. -/
theorem vanishingIdeal_isPrime_of_isAffineVariety
    {Y : Set (AffinePoint k n)} (hY : IsAffineVariety k n Y) :
    (vanishingIdeal k n Y).IsPrime := by
  rw [Ideal.isPrime_iff]
  constructor
  · intro htop
    rcases hY.nonempty with ⟨P, hP⟩
    have hone : (1 : AffinePolynomial k n) ∈ vanishingIdeal k n Y := by
      rw [htop]
      exact Submodule.mem_top
    have hzero := hone P hP
    simp [evaluate] at hzero
  · intro f g hfg
    have hcover : Y ⊆ zeroSet k n f ∪ zeroSet k n g := by
      have hcover0 : Y ⊆ zeroSet k n (f * g) := by
        intro P hP
        change evaluate k n (f * g) P = 0
        exact hfg P hP
      rw [zeroSet_mul] at hcover0
      exact hcover0
    have hsplit :
        Y ⊆ zeroSet k n f ∨ Y ⊆ zeroSet k n g :=
      (isPreirreducible_iff_isClosed_union_isClosed.mp hY.isIrreducible.isPreirreducible
        (zeroSet k n f) (zeroSet k n g)
        (isClosed_zeroSet k n f) (isClosed_zeroSet k n g) hcover)
    rcases hsplit with hf | hg
    · left
      intro P hP
      exact hf hP
    · right
      intro P hP
      exact hg hP

/-- The vanishing ideal of an affine variety is radical. -/
theorem vanishingIdeal_radical_of_isAffineVariety
    {Y : Set (AffinePoint k n)} (hY : IsAffineVariety k n Y) :
    (vanishingIdeal k n Y).radical = vanishingIdeal k n Y :=
  (vanishingIdeal_isPrime_of_isAffineVariety k n hY).radical

end AffinePrime

end

end Hartshorne
