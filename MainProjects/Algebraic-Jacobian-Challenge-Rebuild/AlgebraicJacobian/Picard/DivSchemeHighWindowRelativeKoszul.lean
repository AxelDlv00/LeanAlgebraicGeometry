/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/

import AlgebraicJacobian.Picard.DivSchemeHighWindowKoszul
import AlgebraicJacobian.Picard.DivSchemeHighWindowMulCompatibility

/-!
# A relative Koszul boundary for high-window relations

Multiplication by the fixed basis of the `S`-window carries a submodule in
high window `n` toward high window `n + 1`.  Given a target submodule which
contains these products, this file corestricts each basis multiplication to
a step between the two submodules and forms the finite rows-minus-columns
Koszul boundary.

The next high-window multiplication map kills this boundary.  This is the
relative `range <= kernel` half of the finite-stage relation theorem; the
reverse inclusion on residue-field fibres is the geometric pencil input.
-/

set_option autoImplicit false
set_option quotPrecheck false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 8
set_option maxRecDepth 8000
set_option linter.unusedSectionVars false

universe u

open CategoryTheory Limits TopologicalSpace Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

open Scheme Grassmannian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
  Scheme.functionFieldOverModule
attribute [local instance 10000] relCurve.instOver

section HighWindowRelativeKoszul

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {pi : C.left ⟶ P1 k} [IsFinite pi] [IsDominant pi]

noncomputable local instance instOverCleftHighWindowRelativeKoszul :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))]
  [QuasiCompact (C.left ↘ Spec (.of k))]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hpi : pi ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g r1 r2 : Nat)
variable (b1 : Module.Basis (Fin r1) k
  ↥(Scheme.divisorSections k (windowM_choice pi hpi g • fiberWeilDivisor pi) ⊤))
variable (b2 : Module.Basis (Fin r2) k
  ↥(Scheme.divisorSections k ((windowS_choice pi hpi g • fiberWeilDivisor pi)
    + (windowM_choice pi hpi g • fiberWeilDivisor pi)) ⊤))
variable (i : (glueData k g r1).J) (j : (glueData k g r2).J)

local notation "RZ" => DivCarveChartRing k
  (windowS_choice pi hpi g • fiberWeilDivisor pi)
  (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1 b2 i j
local notation "HS" => ↥(Scheme.divisorSections k
  (windowS_choice pi hpi g • fiberWeilDivisor pi) ⊤)
local notation "HI" => Fin (Module.finrank k HS)

/-- The basis multiplications from `K` land in the chosen successor
submodule `Knext`.  Keeping this as a hypothesis also covers the exceptional
seed transition, whose target is not definitionally the recursive range. -/
def DivUniversalHighWindowMulPreserves (n : Nat)
    (K : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) n))
    (Knext : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) (n + 1))) :
    Prop :=
  ∀ (t : HI) (z : K),
    LinearMap.baseChange RZ
        (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g n
          ((Module.finBasis k HS) t))
        (K.subtype z) ∈ Knext

/-- The canonical multiplication-span successor satisfies the preservation
condition by taking a vector supported at the chosen basis index. -/
theorem divUniversalHighWindowMulPreserves_mulSpan (n : Nat)
    (K : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) n)) :
    DivUniversalHighWindowMulPreserves (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j n K
      (divUniversalHighWindowMulSpan (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j n K) := by
  intro t z
  change LinearMap.baseChange RZ
      (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g n
        ((Module.finBasis k HS) t)) (K.subtype z) ∈
    LinearMap.range (divUniversalHighWindowMulMap (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j n K)
  refine ⟨LinearMap.single RZ (fun _ : HI => K) t z, ?_⟩
  classical
  simp only [divUniversalHighWindowMulMap, LinearMap.sum_apply,
    LinearMap.comp_apply, LinearMap.single_apply, LinearMap.proj_apply]
  rw [Finset.sum_eq_single t]
  · simp
  · intro b hb
    simp [hb]
  · simp

/-- Multiplication by one `S`-window basis vector, corestricted from `K` to
a successor submodule known to contain all such products. -/
noncomputable def divUniversalHighWindowBasisStep (n : Nat)
    (K : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) n))
    (Knext : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) (n + 1)))
    (hpres : DivUniversalHighWindowMulPreserves (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j n K Knext) (t : HI) : K →ₗ[RZ] Knext :=
  ((LinearMap.baseChange RZ
      (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g n
        ((Module.finBasis k HS) t))).comp K.subtype).codRestrict Knext (hpres t)

@[simp]
theorem coe_divUniversalHighWindowBasisStep (n : Nat)
    (K : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) n))
    (Knext : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) (n + 1)))
    (hpres : DivUniversalHighWindowMulPreserves (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j n K Knext) (t : HI) (z : K) :
    ((divUniversalHighWindowBasisStep (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j n K Knext hpres t z : Knext) :
      divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2)
        (i := i) (j := j) (n + 1)) =
      LinearMap.baseChange RZ
        (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g n
          ((Module.finBasis k HS) t)) (K.subtype z) :=
  rfl

/-- The relative finite Koszul boundary between consecutive high-window
submodules. -/
noncomputable def divUniversalHighWindowKoszulBoundary (n : Nat)
    (K : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) n))
    (Knext : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) (n + 1)))
    (hpres : DivUniversalHighWindowMulPreserves (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j n K Knext) :
    (HI × HI → K) →ₗ[RZ] (HI → Knext) :=
  finiteKoszulBoundary (fun t =>
    divUniversalHighWindowBasisStep (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j n K Knext hpres t)

/-- Consecutive high-window basis multiplications commute over the base
field. -/
theorem divUniversalHighWindowShiftMul_comp_comm (n : Nat) (a b : HS) :
    (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g (n + 1) a).comp
        (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g n b) =
      (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g (n + 1) b).comp
        (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g n a) := by
  ext z
  apply Subtype.ext
  simp only [LinearMap.comp_apply, coe_divUniversalHighWindowShiftMul]
  ring

/-- Consecutive high-window basis multiplications still commute after scalar
extension to the carve-chart ring. -/
theorem divUniversalHighWindowBaseChangeShiftMul_comm (n : Nat) (a b : HS)
    (z : divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
      (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) n) :
    LinearMap.baseChange RZ
        (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g (n + 1) a)
        (LinearMap.baseChange RZ
          (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g n b) z) =
      LinearMap.baseChange RZ
        (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g (n + 1) b)
        (LinearMap.baseChange RZ
          (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g n a) z) := by
  change
    ((LinearMap.baseChange RZ
      (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g (n + 1) a)).comp
        (LinearMap.baseChange RZ
          (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g n b))) z = _
  rw [← LinearMap.baseChange_comp,
    divUniversalHighWindowShiftMul_comp_comm (C := C) (pi := pi) hpi g n a b,
    LinearMap.baseChange_comp, LinearMap.comp_apply]

set_option maxHeartbeats 1600000 in
-- The dependent stages and their two consecutive multiplication maps are large.
/-- The multiplication map out of `Knext` kills the relative Koszul boundary
formed one stage earlier. -/
theorem divUniversalHighWindowMulMap_comp_koszulBoundary_eq_zero (n : Nat)
    (K : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) n))
    (Knext : Submodule RZ
      (divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2) (i := i) (j := j) (n + 1)))
    (hpres : DivUniversalHighWindowMulPreserves (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j n K Knext) :
    (divUniversalHighWindowMulMap (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j (n + 1) Knext).comp
      (divUniversalHighWindowKoszulBoundary (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j n K Knext hpres) = 0 := by
  let row : HI → Knext →ₗ[RZ]
      divUniversalHighWindowAmbient (C := C) (pi := pi) (hpi := hpi) (g := g)
        (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2)
        (i := i) (j := j) (n + 2) := fun t =>
    (LinearMap.baseChange RZ
      (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g (n + 1)
        ((Module.finBasis k HS) t))).comp Knext.subtype
  have hzero := finiteComponentSum_comp_finiteKoszulBoundary_eq_zero row
    (fun t => divUniversalHighWindowBasisStep (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j n K Knext hpres t) (by
        intro a b z
        change
          LinearMap.baseChange RZ
              (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g (n + 1)
                ((Module.finBasis k HS) a))
              (LinearMap.baseChange RZ
                (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g n
                  ((Module.finBasis k HS) b)) (K.subtype z)) =
            LinearMap.baseChange RZ
              (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g (n + 1)
                ((Module.finBasis k HS) b))
              (LinearMap.baseChange RZ
                (divUniversalHighWindowShiftMul (C := C) (pi := pi) hpi g n
                  ((Module.finBasis k HS) a)) (K.subtype z))
        exact divUniversalHighWindowBaseChangeShiftMul_comm
          (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j n
            ((Module.finBasis k HS) a) ((Module.finBasis k HS) b) (K.subtype z))
  simpa only [divUniversalHighWindowMulMap, divUniversalHighWindowKoszulBoundary,
    finiteComponentSum, row, LinearMap.comp_assoc] using hzero

end HighWindowRelativeKoszul

end AlgebraicGeometry
