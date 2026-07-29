/-
Axiom probe for `Albanese/SymPowInvariantsAwayEquiv.lean` (run 0069 r8, lane ajc-albanese).

Every declaration of the new module is printed, plus two CONTROLS that must fire `sorryAx`.
A probe with no firing control measures nothing: it cannot distinguish "clean" from "the
probe never reached the kernel". Both controls below are `AlbaneseUP.lean` declarations whose
bodies are `sorry`, so a run in which they print without `sorryAx` is a broken probe, not a
clean tree.

Expected: the eight `AwayEquiv` lines report `[propext, Classical.choice, Quot.sound]` (no
`sorryAx`); the two control lines report `sorryAx`.
-/
-- NOTE: the controls were originally `AlbaneseUP.lean` declarations. That import is
-- unusable at present: `AlbaneseUP` reaches `Picard/` and the Picard cone does not build at
-- HEAD (`SheafOfModules.IsLocallyFreeOfRank` unknown — another lane's, inbox I-0812), so the
-- probe failed for a reason having nothing to do with this module. The controls below are
-- `sorry`-bearing declarations reachable inside this module's own import cone, which is what
-- a control has to be: something that must FIRE, on a path the probe can actually elaborate.
import AlgebraicJacobian.Albanese.SymPowInvariantsAwayEquiv

open AlgebraicGeometry

-- §1: the action on the localization
#print axioms AlgebraicGeometry.awayMap_comp_awayMap
#print axioms AlgebraicGeometry.awayMap_one
#print axioms AlgebraicGeometry.awayMapMulSemiringAction
#print axioms AlgebraicGeometry.fixedAway
#print axioms AlgebraicGeometry.mem_fixedAway

-- §2: the converse direction
#print axioms AlgebraicGeometry.algebraMap_mem_fixedAway
#print axioms AlgebraicGeometry.inv_mem_fixedAway

-- §3: the comparison
#print axioms AlgebraicGeometry.isUnit_algebraMap_fixedAway
#print axioms AlgebraicGeometry.exists_invariant_num_den
#print axioms AlgebraicGeometry.mem_fixedAway_iff_exists_invariant_num

-- The half this file builds on, for the record.
#print axioms AlgebraicGeometry.exists_invariant_numerator

/-!
CONTROLS. Nothing in this module's import cone carries a `sorry` — measured, not assumed —
so the controls are declared here. Each is a `sorry`-bodied restatement of a real theorem
above; each MUST report `sorryAx`. If a control prints clean, the probe is broken and none of
the lines above may be read as a measurement.
-/

section Controls

universe u
variable {G A : Type u} [Group G] [CommRing A] [MulSemiringAction G A]

/-- Control: the same statement as `algebraMap_mem_fixedAway`, proved by `sorry`. -/
theorem control_algebraMap_mem (b : A) (hb : ∀ g : G, g • b = b) {a : A}
    (_ha : ∀ g : G, g • a = a) :
    algebraMap A (Localization.Away b) a ∈ AlgebraicGeometry.fixedAway b hb :=
  sorry

/-- Control: the same statement as `mem_fixedAway_iff_exists_invariant_num`, by `sorry`. -/
theorem control_mem_fixedAway_iff [Finite G] (b : A) (hb : ∀ g : G, g • b = b)
    (x : Localization.Away b) :
    x ∈ AlgebraicGeometry.fixedAway b hb ↔
      ∃ (a : A) (n : ℕ), (∀ g : G, g • a = a) ∧
        x * algebraMap A (Localization.Away b) (b ^ n)
          = algebraMap A (Localization.Away b) a :=
  sorry

#print axioms control_algebraMap_mem
#print axioms control_mem_fixedAway_iff

end Controls
