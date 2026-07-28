---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.p1Chart_inf_eq_basicOpen_coordSection
docstring: '**The overlap-as-basic-open identity (route step 3).**  The overlap of
  the two chart

  preimages `V_i ⊓ V_j = toProjInt ⁻¹ᵁ (D₊(Xᵢ) ⊓ D₊(Xⱼ))` is exactly the non-vanishing

  locus of the coordinate section `p1CoordSection i j` on `ℙ¹`; pull back the Proj-side

  identity `proj_basicOpen_awayToSection_coord` along `toProjInt`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/P1ChartData.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Adelic.p1Chart_inf_eq_basicOpen_coordSection
type: lean
updated: '2026-07-28T13:22:17'
---
private lemma p1Chart_inf_eq_basicOpen_coordSection (k : Type u) [Field k]
    (i j : ULift.{u} (Fin 2)) :
    p1Chart k i ⊓ p1Chart k j
      = Scheme.basicOpen (ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)))
          (((ProjectiveSpace.toProjInt (ULift.{u} (Fin 2)) (Spec (CommRingCat.of k))).app
              (Proj.basicOpen (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
                (X i))).hom
            ((Proj.awayToSection (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ))
                (X i)).hom
              (p1CoordAway (ULift.{u} (Fin 2)) i j))) := by
  rw [← Scheme.preimage_basicOpen
        (ProjectiveSpace.toProjInt (ULift.{u} (Fin 2)) (Spec (CommRingCat.of k)))
        ((Proj.awayToSection (homogeneousSubmodule (ULift.{u} (Fin 2)) (ULift.{u} ℤ)) (X i)).hom
          (p1CoordAway (ULift.{u} (Fin 2)) i j)),
      proj_basicOpen_awayToSection_coord i j, Scheme.Hom.preimage_inf]
  rfl