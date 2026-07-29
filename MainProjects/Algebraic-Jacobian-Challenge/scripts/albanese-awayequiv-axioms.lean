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
import AlgebraicJacobian.Albanese.SymPowInvariantsAwayEquiv
import AlgebraicJacobian.Albanese.AlbaneseUP

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

-- CONTROLS: these MUST report `sorryAx`.
#print axioms AlgebraicGeometry.Pic0.abelJacobi
#print axioms AlgebraicGeometry.Pic0.albanese_universal_property
