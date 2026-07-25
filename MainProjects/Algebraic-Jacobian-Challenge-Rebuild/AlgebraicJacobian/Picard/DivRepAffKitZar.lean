/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivRepAffKit

/-!
# The F5 kit at the `Zar` level: the forward map needs no global chart certificate

`DivRepAffKit.lean` states the F5 forward machinery with a supplied *globally certified*
family on each carve chart (`divRepPullAt` takes
`CertifiedDivisorFamily C (ChartRing i j) pi g`).  But that family is used only through
`(DivFam.mk (U i j)).toZar` — its certificate is consumed nowhere; the forward map is a
`DivFamZar.mapAlgHom` of a *class*.

This file restates the kit with the input weakened to a `DivFamZar` class on each chart.
That matters for the DD-R endgame: the certificate lane's output is Zariski-local
(`IsLocallyCertified`, see `DivSchemeCertZarSeed.lean` / `DivSchemeCertZarPointwise.lean`),
so a forward map demanding a global chart-ring certificate would have re-imposed exactly
the gate that was just removed.  With `divRepPullAtZar` it does not.

The globally certified version is recovered by `divRepPullAtZar_toZar`, so this is a
weakening of the interface, not a second track.

## Main declarations

* `AlgebraicGeometry.divRepPullAtZar` — pull a supplied chart *class* to a test algebra.
* `AlgebraicGeometry.divRepPullAtZar_toZar` — agreement with `divRepPullAt` on a globally
  certified chart family.
* `AlgebraicGeometry.DivRepChartFamilyZar.IsCompatible` — the choice-independence clause at
  the `Zar` level.
-/

set_option autoImplicit false
set_option quotPrecheck false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory

namespace AlgebraicGeometry

open Grassmannian Scheme

section Curve

variable {k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))}
variable {pi : C.left ⟶ P1 k} [IsFinite pi]

noncomputable local instance instOverCleftDivRepAffKitZar :
    C.left.Over (Spec (CommRingCat.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k))]
  [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (CommRingCat.of k))]
  [QuasiCompact (C.left ↘ Spec (CommRingCat.of k))]
  [IsDominant pi]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hpi : pi ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g : ℕ)
variable (r1 r2 : ℕ)
variable (b1 : Module.Basis (Fin r1) k
  ↥(divisorSections k (windowM_choice pi hpi g • fiberWeilDivisor pi) ⊤))
variable (b2 : Module.Basis (Fin r2) k
  ↥(divisorSections k
    ((windowM_choice pi hpi g + windowS_choice pi hpi g) • fiberWeilDivisor pi) ⊤))

local notation "ChartRing" => fun i j =>
  DivCarveChartRing k (windowS_choice pi hpi g • fiberWeilDivisor pi)
    (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1
    (b2.map (windowShiftEquiv hpi g).symm) i j

local notation "ChartMap" => fun i j =>
  divCarveChartToDivScheme k (windowS_choice pi hpi g • fiberWeilDivisor pi)
    (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1
    (b2.map (windowShiftEquiv hpi g).symm) i j

/-! ## F5 at the `Zar` level -/

/-- Pull a supplied locally certified **class** on one carve chart to a test algebra.
This is `divRepPullAt` with the global chart certificate removed: the forward map only
ever transported a class, so a `DivFamZar` input suffices. -/
noncomputable def divRepPullAtZar
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZar C (ChartRing i j) pi g)
    {S : Type u} [CommRing S] [Algebra k S]
    (i : (glueData k g r1).J) (j : (glueData k g r2).J)
    (omega : ChartRing i j →ₐ[k] S) : DivFamZar C S pi g :=
  DivFamZar.mapAlgHom omega (U i j)

set_option linter.unusedSectionVars false in
@[simp]
theorem divRepPullAtZar_id
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZar C (ChartRing i j) pi g)
    (i : (glueData k g r1).J) (j : (glueData k g r2).J) :
    divRepPullAtZar (hpi := hpi) g r1 r2 b1 b2 U i j (AlgHom.id k (ChartRing i j))
      = U i j :=
  DivFamZar.mapAlgHom_id _

set_option linter.unusedSectionVars false in
/-- Pulling a chart class through two algebra maps is pulling through the composite. -/
theorem divRepPullAtZar_comp
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZar C (ChartRing i j) pi g)
    {S T : Type u} [CommRing S] [Algebra k S] [CommRing T] [Algebra k T]
    (i : (glueData k g r1).J) (j : (glueData k g r2).J)
    (omega : ChartRing i j →ₐ[k] S) (phi : S →ₐ[k] T) :
    DivFamZar.mapAlgHom phi (divRepPullAtZar (hpi := hpi) g r1 r2 b1 b2 U i j omega)
      = divRepPullAtZar (hpi := hpi) g r1 r2 b1 b2 U i j (phi.comp omega) :=
  (DivFamZar.mapAlgHom_comp omega phi (U i j)).symm

set_option linter.unusedSectionVars false in
/-- **The interfaces agree.** On a globally certified chart family, the `Zar`-level
forward map is the old one — so this file weakens `DivRepAffKit`'s input rather than
introducing a parallel construction. -/
theorem divRepPullAtZar_toZar
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      CertifiedDivisorFamily C (ChartRing i j) pi g)
    {S : Type u} [CommRing S] [Algebra k S]
    (i : (glueData k g r1).J) (j : (glueData k g r2).J)
    (omega : ChartRing i j →ₐ[k] S) :
    divRepPullAtZar (hpi := hpi) g r1 r2 b1 b2
        (fun i j => (DivFam.mk (U i j)).toZar) i j omega
      = divRepPullAt (hpi := hpi) g r1 r2 b1 b2 U i j omega :=
  rfl

namespace DivRepChartFamilyZar

/-- The F5 overlap obligation at the `Zar` level: two chart points inducing the same
morphism to `DivScheme` pull the supplied classes to the same class. -/
def IsCompatible
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZar C (ChartRing i j) pi g) : Prop :=
  ∀ {S : Type u} [CommRing S] [Algebra k S]
    (i : (glueData k g r1).J) (j : (glueData k g r2).J)
    (i' : (glueData k g r1).J) (j' : (glueData k g r2).J)
    (omega : ChartRing i j →ₐ[k] S) (omega' : ChartRing i' j' →ₐ[k] S),
    Spec.map (CommRingCat.ofHom omega.toRingHom) ≫ ChartMap i j
        = Spec.map (CommRingCat.ofHom omega'.toRingHom) ≫ ChartMap i' j' →
      divRepPullAtZar (hpi := hpi) g r1 r2 b1 b2 U i j omega
        = divRepPullAtZar (hpi := hpi) g r1 r2 b1 b2 U i' j' omega'

set_option linter.unusedSectionVars false in
/-- Compatibility read at a morphism to `DivScheme`, the form the gluing consumes. -/
theorem eq_of_isCompatible
    {U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZar C (ChartRing i j) pi g}
    (hU : IsCompatible (hpi := hpi) g r1 r2 b1 b2 U)
    {S : Type u} [CommRing S] [Algebra k S]
    (i : (glueData k g r1).J) (j : (glueData k g r2).J)
    (i' : (glueData k g r1).J) (j' : (glueData k g r2).J)
    (omega : ChartRing i j →ₐ[k] S) (omega' : ChartRing i' j' →ₐ[k] S)
    (q : Spec (CommRingCat.of S) ⟶
      DivScheme k (windowS_choice pi hpi g • fiberWeilDivisor pi)
        (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1
        (b2.map (windowShiftEquiv hpi g).symm))
    (homega : Spec.map (CommRingCat.ofHom omega.toRingHom) ≫ ChartMap i j = q)
    (homega' : Spec.map (CommRingCat.ofHom omega'.toRingHom) ≫ ChartMap i' j' = q) :
    divRepPullAtZar (hpi := hpi) g r1 r2 b1 b2 U i j omega
      = divRepPullAtZar (hpi := hpi) g r1 r2 b1 b2 U i' j' omega' :=
  hU i j i' j' omega omega' (homega.trans homega'.symm)

end DivRepChartFamilyZar

end Curve

end AlgebraicGeometry
