/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/

import AlgebraicJacobian.Picard.DivSchemeHighWindowDirectLimit
import AlgebraicJacobian.Picard.DivSchemeHighWindowMulCompatibility

/-!
# Side-preserving transitions between high theta windows

The canonical sections `(1,t₁^s)` and `(t₀^s,1)` give transitions between
successive relative theta windows.  Their selected pinned-chart component is
`1`, so the corresponding chart readings are unchanged.  This file records
the linear maps and their directed-system identities; relation-submodule
compatibility is intentionally kept as a separate hypothesis.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 8
set_option maxRecDepth 8000

universe u

open CategoryTheory Limits TopologicalSpace Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

open Scheme Grassmannian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
  Scheme.functionFieldOverModule
attribute [local instance 10000] relCurve.instOver

section RelativeTransition

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable (R : Type u) [CommRing R] [Algebra k R]
variable (pi : C.left ⟶ P1 k) [IsFinite pi]

noncomputable local instance instOverCleftHighWindowTransitions :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

/-- Multiplication on the left by a fixed relative theta section is linear in
the second factor. -/
noncomputable def relThetaSectionsMulLeft (a b : Nat)
    (s : relThetaSections C R pi a) :
    relThetaSections C R pi b →ₗ[R] relThetaSections C R pi (a + b) :=
  { toFun := fun t => relThetaSectionsMul C R pi a b s t
    map_add' := by
      intro x y
      apply Subtype.ext
      ext <;> simp [relThetaSectionsMul] <;> ring
    map_smul' := by
      intro r x
      apply Subtype.ext
      ext <;> simp [relThetaSectionsMul, Scheme.overModule_smul_def] <;> ring }

@[simp]
theorem relThetaSectionsMulLeft_apply (a b : Nat)
    (s : relThetaSections C R pi a)
    (x : relThetaSections C R pi b) :
    relThetaSectionsMulLeft C R pi a b s x =
      relThetaSectionsMul C R pi a b s x := rfl

/-- The canonical theta section whose component on the selected pinned chart is
`1`: `(1,t₁^a)` on chart `0`, and `(t₀^a,1)` on chart `1`. -/
noncomputable def relThetaSideUnitSection (side : Bool) (a : Nat) :
    relThetaSections C R pi a :=
  match side with
  | false => relThetaSectionSnd C R pi a
  | true => relThetaSectionFst C R pi a

@[simp]
theorem relThetaResSide_relThetaSideUnit (side : Bool) (a : Nat) :
    relThetaResSide a side le_rfl (relThetaSideUnitSection C R pi side a) = 1 := by
  cases side
  · change relThetaResFst a (le_inf le_top le_rfl)
      (relThetaSectionSnd C R pi a) = 1
    exact relThetaResFst_relThetaSectionSnd C R pi a
  · change relThetaResSnd a (le_inf le_top le_rfl)
      (relThetaSectionFst C R pi a) = 1
    exact relThetaResSnd_relThetaSectionFst C R pi a

/-- Multiply a theta section by the selected-side unit section. -/
noncomputable def relThetaSideTransition (side : Bool) (p s : Nat) :
    relThetaSections C R pi p →ₗ[R] relThetaSections C R pi (s + p) :=
  relThetaSectionsMulLeft C R pi s p (relThetaSideUnitSection C R pi side s)

@[simp]
theorem relThetaResSide_relThetaSideTransition (side : Bool) (p s : Nat)
    (x : relThetaSections C R pi p) :
    relThetaResSide (s + p) side le_rfl
        (relThetaSideTransition C R pi side p s x) =
      relThetaResSide p side le_rfl x := by
  rw [relThetaSideTransition, relThetaSectionsMulLeft_apply,
    relThetaResSide_relThetaSectionsMul]
  rw [relThetaResSide_relThetaSideUnit]
  simp

end RelativeTransition

section HighWindowTransition

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [hSmoothC : SmoothOfRelativeDimension 1 C.hom] [hProperC : IsProper C.hom]
  [hGeometricallyIrreducibleC : GeometricallyIrreducible C.hom]
variable {pi : C.left ⟶ P1 k} [IsFinite pi] [IsDominant pi]

noncomputable local instance instOverCleftHighWindowTransition :
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
local notation "E" n => divUniversalHighWindowExponent (C := C) (pi := pi) hpi g n
local notation "G" n => divUniversalHighWindowAmbient (C := C) (pi := pi)
  (hpi := hpi) (g := g) (r1 := r1) (r2 := r2) (b1 := b1) (b2 := b2)
  (i := i) (j := j) n

/-- Reindex a relative theta section from exponent `s + Eₙ` to `Eₙ₊₁`. -/
noncomputable def divUniversalHighWindowRelativeSuccEquiv (n : Nat) :
    relThetaSections C RZ pi
        (windowS_choice pi hpi g + E n) ≃ₗ[RZ]
      relThetaSections C RZ pi (E (n + 1)) :=
  LinearEquiv.ofEq _ _ (congrArg (relThetaSections C RZ pi)
    (divUniversalHighWindowExponent_succ (C := C) (pi := pi) hpi g n))

/-- The side-dependent relative transition, given by multiplication by the
canonical section with selected-side reading `1`. -/
noncomputable def divUniversalHighWindowRelativeTransition (side : Bool) (n : Nat) :
    relThetaSections C RZ pi (E n) →ₗ[RZ]
      relThetaSections C RZ pi (E (n + 1)) :=
  (divUniversalHighWindowRelativeSuccEquiv (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j n).toLinearMap.comp
    (relThetaSideTransition C RZ pi side (E n)
      (windowS_choice pi hpi g))

@[simp]
theorem divUniversalHighWindowRelativeTransition_read (side : Bool) (n : Nat)
    (x : relThetaSections C RZ pi (E n)) :
    relThetaResSide (E (n + 1)) side le_rfl
      (divUniversalHighWindowRelativeTransition (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j side n x) =
      relThetaResSide (E n) side le_rfl x := by
  rw [divUniversalHighWindowRelativeTransition, LinearMap.comp_apply,
    LinearEquiv.coe_coe, LinearEquiv.coe_ofEq_apply]
  simpa only [divUniversalHighWindowExponent_succ] using
    (relThetaResSide_relThetaSideTransition C RZ pi side (E n)
      (windowS_choice pi hpi g) x)

/-- The ambient transition obtained by conjugating the relative transition by
the high-window theta equivalences. -/
noncomputable def divUniversalHighWindowTransition (side : Bool) (n : Nat) :
    G n →ₗ[RZ] G (n + 1) :=
  (divUniversalHighWindowThetaEquiv (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j (n + 1)).symm.toLinearMap.comp
    ((divUniversalHighWindowRelativeTransition (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j side n).comp
      (divUniversalHighWindowThetaEquiv (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j n).toLinearMap)

@[simp]
theorem divUniversalHighWindowChartRead_transition (side : Bool) (n : Nat)
    (x : G n) :
    divUniversalHighWindowChartRead (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j (n + 1) side
      (divUniversalHighWindowTransition (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j side n x) =
      divUniversalHighWindowChartRead (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j n side x := by
  change relThetaResSide (E (n + 1)) side le_rfl
      ((divUniversalHighWindowThetaEquiv (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j (n + 1))
        ((divUniversalHighWindowThetaEquiv (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j (n + 1)).symm
          ((divUniversalHighWindowRelativeTransition (C := C) (pi := pi)
            hpi g r1 r2 b1 b2 i j side n)
            ((divUniversalHighWindowThetaEquiv (C := C) (pi := pi)
              hpi g r1 r2 b1 b2 i j n) x))) = _
  rw [LinearEquiv.apply_symm_apply]
  exact divUniversalHighWindowRelativeTransition_read
    (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j side n
    ((divUniversalHighWindowThetaEquiv (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j n) x)

@[simp]
theorem divUniversalHighWindowChartRead_transition_two (side : Bool) (n : Nat)
    (x : G n) :
    divUniversalHighWindowChartRead (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j (n + 1 + 1) side
      (divUniversalHighWindowTransition (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j side (n + 1)
        (divUniversalHighWindowTransition (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j side n x)) =
      divUniversalHighWindowChartRead (C := C) (pi := pi)
        hpi g r1 r2 b1 b2 i j n side x := by
  rw [divUniversalHighWindowChartRead_transition,
    divUniversalHighWindowChartRead_transition]

/-- A successor quotient map is available as soon as the chosen side transition
preserves the relation submodules.  The latter inclusion is the explicit
relative-saturation obligation, so it is kept as an input rather than hidden
behind an instance. -/
noncomputable def divUniversalHighWindowSuccessorQuotientMap
    (K : Nat → Submodule RZ (G ·)) (side : Bool) (n : Nat)
    (hK : Submodule.map
        (divUniversalHighWindowTransition (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j side n)
        (K n) ≤ K (n + 1)) :
    (G n ⧸ K n) →ₗ[RZ] (G (n + 1) ⧸ K (n + 1)) :=
  (K n).mapQ (K (n + 1))
    (divUniversalHighWindowTransition (C := C) (pi := pi)
      hpi g r1 r2 b1 b2 i j side n) hK

@[simp]
theorem divUniversalHighWindowSuccessorQuotientMap_mk
    (K : Nat → Submodule RZ (G ·)) (side : Bool) (n : Nat)
    (hK : Submodule.map
        (divUniversalHighWindowTransition (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j side n)
        (K n) ≤ K (n + 1)) (x : G n) :
    divUniversalHighWindowSuccessorQuotientMap
        (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j K side n hK
      (Submodule.Quotient.mk x) =
      Submodule.Quotient.mk
        (divUniversalHighWindowTransition (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j side n x) := by
  rw [divUniversalHighWindowSuccessorQuotientMap, Submodule.mapQ_apply]

end HighWindowTransition

end AlgebraicGeometry
