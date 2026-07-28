import Mathlib

set_option autoImplicit false

universe u

open CategoryTheory

namespace ScratchTest

variable {K : Type u} [Field K] {G : Scheme.{u}} (f : G ⟶ Spec (.of K))
    [AlgebraicGeometry.LocallyOfFiniteType f] [GrpObj (Over.mk f)]

open AlgebraicGeometry

set_option backward.defeqAttrib.useBackward true in
set_option backward.isDefEq.respectTransparency false in
open MonObj MonoidalCategory CartesianMonoidalCategory in
theorem smooth_of_grpObj_of_isAlgClosed' [IsReduced G] [IsAlgClosed K] : Smooth f := by
  have := LocallyOfFiniteType.jacobsonSpace f
  have : Nonempty G := ⟨η[Over.mk f].1 (IsLocalRing.closedPoint _)⟩
  rw [← Scheme.Hom.smoothLocus_eq_top_iff, ← TopologicalSpace.Opens.coe_eq_univ,
    ← not_ne_iff, ← Set.nonempty_compl]
  intro H
  obtain ⟨x, hx, hxc⟩ :=
    nonempty_inter_closedPoints H f.smoothLocus.2.isClosed_compl.isLocallyClosed
  obtain ⟨y, hy : y ∈ f.smoothLocus, hyc⟩ := nonempty_inter_closedPoints
    f.dense_smoothLocus_of_perfectField.nonempty f.smoothLocus.2.isLocallyClosed
  let x' : 𝟙_ _ ⟶ Over.mk f := Over.homMk _ ((pointEquivClosedPoint f).symm ⟨x, hxc⟩).2
  let y' : 𝟙_ _ ⟶ Over.mk f := Over.homMk _ ((pointEquivClosedPoint f).symm ⟨y, hyc⟩).2
  let α := (GrpObj.mulRight (A := Over.mk f) x').symm ≪≫
    (GrpObj.mulRight (A := Over.mk f) y')
  have hα : x' ≫ α.hom = y' := by
    dsimp only [Iso.trans_hom, Iso.symm_hom, α]
    rw [← Category.assoc, ← Iso.eq_comp_inv]
    simp [comp_lift_assoc]
  have hα' : α.hom.left x = y := by
    simpa [x', y', pointEquivClosedPoint] using congr(($hα).left (IsLocalRing.closedPoint K))
  rw! [← hα', ← α.hom.left.mem_preimage, Scheme.Hom.preimage_smoothLocus_eq,
    show α.hom.left ≫ f = f from α.hom.w] at hy
  exact hx hy

end ScratchTest
