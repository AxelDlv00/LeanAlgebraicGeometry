/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian

/-!
# Axiom probe: the affine symmetric-power layer of the Albanese leg

Run with `lake env lean scripts/probe-albanese-symmetric.lean`. Seeded at the **root**
module, so it measures the rooted import cone rather than a hand-picked one (the failure mode
recorded as `I-0659`: four of these modules were outside the root cone until run 0069 r5, and
no probe through the root could name them).

## Two calibration rules this file obeys

**A probe needs a control that fires.** `#print axioms` on a page of clean declarations proves
nothing unless something in the same run reports `sorryAx`. The controls are at the bottom;
if they ever come back clean, the probe has lost calibration and its clean readings are
meaningless — do not read the top half without checking the bottom.

**Do not use a declaration stated over an interface as a control.** `symPowData_affineAlgebra`
looks like a natural control and is useless as one: it is axiom-clean, because it quantifies
over the interface rather than instantiating it. The controls below are `sorry`-*bodied*
definitions, which cannot be clean.
-/

open PiTensorProduct AlgebraicGeometry

/-! ## The `S_n`-action on a tensor power (`Albanese/SymPowTensorAction.lean`) -/

#print axioms PiTensorProduct.permAlgHom
#print axioms PiTensorProduct.permAlgHom_comp
#print axioms PiTensorProduct.permAlgEquiv
#print axioms PiTensorProduct.permMulSemiringAction
#print axioms PiTensorProduct.permSMulCommClass
#print axioms PiTensorProduct.symTensorPowSubalgebra
#print axioms PiTensorProduct.symTensorPowSubalgebra_toSubring

/-! ## The invariants as a limit, over `CommRingCat` and over the base -/

#print axioms AlgebraicGeometry.fixedConeIsLimit
#print axioms AlgebraicGeometry.hasColimit_actionDiagram_op
#print axioms AlgebraicGeometry.fixedConeUnderIsLimit
#print axioms AlgebraicGeometry.hasColimit_actionDiagramUnder_op
#print axioms AlgebraicGeometry.hasColimit_actionDiagramUnder_op_symTensorPow
#print axioms AlgebraicGeometry.hasColimit_singleObj_of_op

/-! ## The `G`-stable affine cover for a bare finite group -/

#print axioms AlgebraicGeometry.StableGroupAction.exists_stable_affineOpen_of_orbits

/-! ## The symmetric-power interface and its equivalence to a colimit -/

#print axioms CategoryTheory.hasColimit_permDiagram_iff
#print axioms CategoryTheory.symPowOfColimit_proj_perm

/-! ## CONTROLS — each MUST report `sorryAx`

`SymmetricPower` and `abelJacobi` are `sorry`-bodied definitions in `Albanese/AlbaneseUP.lean`;
`albanese_universal_property` inherits from them. If any of the three comes back clean, this
probe is miscalibrated and everything above should be re-measured. -/

#print axioms AlgebraicGeometry.Pic0.SymmetricPower
#print axioms AlgebraicGeometry.Pic0.abelJacobi
#print axioms AlgebraicGeometry.Pic0.albanese_universal_property
