import AlgebraicJacobian.Picard.Pic0ChartRationalGraph

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open TopologicalSpace Opposite
open AlgebraicGeometry

universe u

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

noncomputable section

#check pullback.lift
#check Over.homMk
#check Over.fst
#check Over.snd
#check Over.isPullback_left

example : ∃ x : C.left, IsClosed ({x} : Set C.left) := by
  haveI : IsIntegral C.left := isIntegral_left_of_geometricallyReduced C
  obtain ⟨x, _, hx⟩ := nonempty_inter_closedPoints
    (Z := (Set.univ : Set C.left)) Set.univ_nonempty isOpen_univ.isLocallyClosed
  exact ⟨x, mem_closedPoints_iff.mp hx⟩

example (x : C.left) (hx : IsClosed ({x} : Set C.left)) :
    Module.Finite k (Over.testPointField x) := by
  haveI : LocallyOfFiniteType (C.left.fromSpecResidueField x) :=
    isClosed_singleton_iff_locallyOfFiniteType.mp hx
  haveI : LocallyOfFiniteType
      (C.left.fromSpecResidueField x ≫ C.hom) := inferInstance
  haveI : IsFinite (C.left.fromSpecResidueField x ≫ C.hom) :=
    isFinite_iff_locallyOfFiniteType_of_jacobsonSpace.mpr inferInstance
  rw [← RingHom.finite_algebraMap]
  apply IsFinite.SpecMap_iff.mp
  rw [Over.algebraMap_testPointField]
  exact inferInstance

example (x : C.left) : Algebra.IsSeparable k (Over.testPointField x) := by
  infer_instance

theorem exists_finiteSeparable_point_probe :
    ∃ (L : Type u) (_ : Field L) (_ : Algebra k L)
      (_ : Module.Finite k L) (_ : Algebra.IsSeparable k L),
      Nonempty (overSpec k L ⟶ C) := by
  haveI : IsIntegral C.left := isIntegral_left_of_geometricallyReduced C
  obtain ⟨x, _, hx⟩ := nonempty_inter_closedPoints
    (Z := (Set.univ : Set C.left)) Set.univ_nonempty isOpen_univ.isLocallyClosed
  have hxclosed : IsClosed ({x} : Set C.left) := mem_closedPoints_iff.mp hx
  let L := Over.testPointField x
  letI : Field L := inferInstance
  letI : Algebra k L := inferInstance
  haveI hfinite : Module.Finite k L := by
    haveI : LocallyOfFiniteType (C.left.fromSpecResidueField x) :=
      isClosed_singleton_iff_locallyOfFiniteType.mp hxclosed
    haveI : LocallyOfFiniteType
        (C.left.fromSpecResidueField x ≫ C.hom) := inferInstance
    haveI : IsFinite (C.left.fromSpecResidueField x ≫ C.hom) :=
      isFinite_iff_locallyOfFiniteType_of_jacobsonSpace.mpr inferInstance
    rw [← RingHom.finite_algebraMap]
    apply IsFinite.SpecMap_iff.mp
    rw [Over.algebraMap_testPointField]
    exact inferInstance
  haveI hseparable : Algebra.IsSeparable k L := inferInstance
  exact ⟨L, inferInstance, inferInstance, hfinite, hseparable, ⟨Over.testPoint x⟩⟩

noncomputable def baseChangePoint_probe {L : Type u} [Field L] [Algebra k L]
    (p : overSpec k L ⟶ C) : overSpec L L ⟶ baseChangeBundle C L :=
  Over.homMk
    (pullback.lift p.left (𝟙 _) (p.w.trans (Category.id_comp _).symm))
    (by
      change pullback.lift p.left (𝟙 _) _ ≫ (snd C (overSpec k L)).left =
        (overSpec L L).hom
      rw [pullback.lift_snd, overSpec_self_hom])

example (n : ℕ) :
    ∃ (L : Type u) (_ : Field L) (_ : Algebra k L)
      (_ : Module.Finite k L) (_ : Algebra.IsSeparable k L),
      ∃ (m : ℕ)
        (Z : ((baseChangeBundle C L) ⊗ overSpec L L).left.CurveDivisor),
        Scheme.CurveDivisor.deg L Z =
          (m : ℤ) * classDeg L (thetaCechClass (baseChangeBundle C L)) - (n : ℤ) := by
  obtain ⟨L, hLfield, hkL, hfinite, hseparable, ⟨p⟩⟩ :=
    exists_finiteSeparable_point_probe (C := C)
  letI : Field L := hLfield
  letI : Algebra k L := hkL
  letI : Module.Finite k L := hfinite
  letI : Algebra.IsSeparable k L := hseparable
  haveI : IsProper (baseChangeBundle C L).hom := instIsProperSndLeft C L
  haveI : SmoothOfRelativeDimension 1 (baseChangeBundle C L).hom :=
    instSmoothOfRelativeDimensionSndLeft C L
  haveI : GeometricallyIrreducible (baseChangeBundle C L).hom :=
    instGeometricallyIrreducibleSndLeft C L
  exact ⟨L, inferInstance, inferInstance, inferInstance, inferInstance,
    exists_chartIndex_of_point (baseChangeBundle C L) (baseChangePoint_probe p) n⟩

end
