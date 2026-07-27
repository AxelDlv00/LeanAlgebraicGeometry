---
author: sync
content_type: theorem
created: '2026-07-27T19:08:27'
decl: AlgebraicGeometry.Adelic.p1ChartRetraction_p1CoordSection
docstring: '**The retraction kills the chart coordinate to the variable.**  `p1CoordSection
  i j` is the

  image of the away fraction `Xⱼ/Xᵢ` under the `Proj`-leg of the pushout, which the
  chart-ring

  identification `p1AwayAlgEquiv` sends to `T`.'
file: AlgebraicJacobian/Picard/RigidPushforwardP1ChartSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.p1ChartRetraction_p1CoordSection
type: lean
updated: '2026-07-27T19:08:27'
---
theorem p1ChartRetraction_p1CoordSection {i j : ULift.{u} (Fin 2)} (hij : i ≠ j) :
    (p1ChartRetraction k hij).hom (p1CoordSection k i j) = Polynomial.X := by
  have hbridge : (toProjInt (ULift.{u} (Fin 2)) (Spec (CommRingCat.of k))).appLE
        (Proj.basicOpen (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ)) (X i))
        (p1Chart k i) (le_refl _)
      = (toProjInt (ULift.{u} (Fin 2)) (Spec (CommRingCat.of k))).app
          (Proj.basicOpen (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ)) (X i)) :=
    Scheme.Hom.appLE_eq_app _
  have hinl : (toProjInt (ULift.{u} (Fin 2)) (Spec (CommRingCat.of k))).appLE
        (Proj.basicOpen (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ)) (X i))
        (p1Chart k i) (le_refl _) ≫ p1ChartRetraction k hij
      = p1ProjLeg k hij :=
    (isPushout_p1ChartSections k i).inl_desc _ _ _
  have h1 : (p1ChartRetraction k hij).hom (p1CoordSection k i j)
      = (p1ProjLeg k hij).hom
          ((Proj.awayToSection (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
            (X i)).hom (p1CoordAway (ULift.{u} (Fin 2)) i j)) := by
    change (p1ChartRetraction k hij).hom
        (((toProjInt (ULift.{u} (Fin 2)) (Spec (CommRingCat.of k))).app
            (Proj.basicOpen (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ)) (X i))).hom
          ((Proj.awayToSection (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
            (X i)).hom (p1CoordAway (ULift.{u} (Fin 2)) i j))) = _
    rw [← hbridge, ← hinl]
    rfl
  have hiso : (Proj.basicOpenIsoAway (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
        (X i) (ProjTwist.X_mem_deg_one (ULift.{u} (Fin 2)) i) one_pos).inv.hom
        ((Proj.awayToSection (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
          (X i)).hom (p1CoordAway (ULift.{u} (Fin 2)) i j))
      = p1CoordAway (ULift.{u} (Fin 2)) i j := by
    rw [← Proj.basicOpenIsoAway_hom (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
      (X i) (ProjTwist.X_mem_deg_one (ULift.{u} (Fin 2)) i) one_pos]
    exact (Proj.basicOpenIsoAway (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
      (X i) (ProjTwist.X_mem_deg_one (ULift.{u} (Fin 2)) i) one_pos).hom_inv_id_apply _
  rw [h1]
  change (Polynomial.mapRingHom (uliftIntCast k))
      ((p1AwayAlgEquiv (ULift.{u} ℤ) hij)
        ((Proj.basicOpenIsoAway (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
          (X i) (ProjTwist.X_mem_deg_one (ULift.{u} (Fin 2)) i) one_pos).inv.hom
          ((Proj.awayToSection (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
            (X i)).hom (p1CoordAway (ULift.{u} (Fin 2)) i j)))) = Polynomial.X
  rw [hiso, p1AwayAlgEquiv_p1CoordAway hij]
  exact Polynomial.map_X _