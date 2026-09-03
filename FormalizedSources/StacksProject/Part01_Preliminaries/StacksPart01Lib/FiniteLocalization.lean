/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import Mathlib.RingTheory.RingHom.Finite
import Mathlib.RingTheory.Unramified.LocalRing

/-!
# Finite ring maps and localization

This file packages finiteness results for the canonical maps obtained by
localizing a finite ring map.  It also records the local-ring specialization
when a prime is the unique prime above its contraction.
-/

namespace StacksPart01

universe u v

/-- Simultaneously localizing the source and target of a finite ring map at a
submonoid and its image gives another finite ring map. -/
theorem finite_localizationMap
    {R S : Type u} [CommRing R] [CommRing S]
    (f : R →+* S) (M : Submonoid R) (hf : f.Finite) :
    (IsLocalization.map (Localization (M.map f)) f
      (Submonoid.le_comap_map M) :
      Localization M →+* Localization (M.map f)).Finite := by
  exact RingHom.finite_localizationPreserves f M
    (Localization M) (Localization (M.map f)) hf

/-- Let `q` be the unique prime of a finite `R`-algebra `S` above `p`.
Then the canonical map of local rings `R_p → S_q` is finite. -/
theorem finite_localRingHom_of_unique_primesOver
    {R : Type u} {S : Type v} [CommRing R] [CommRing S] [Algebra R S]
    {p : Ideal R} [p.IsPrime] {q : Ideal S} [q.IsPrime] [q.LiesOver p]
    (hf : (algebraMap R S).Finite) (hq : p.primesOver S = {q}) :
    (Localization.localRingHom p q (algebraMap R S) (q.over_def p)).Finite := by
  letI : Module.Finite R S := RingHom.finite_algebraMap.mp hf
  letI := Localization.AtPrime.algebraOfLiesOver p q
  change Module.Finite (Localization.AtPrime p) (Localization.AtPrime q)
  exact Localization.finite_of_primesOver_eq_singleton hq

end StacksPart01
