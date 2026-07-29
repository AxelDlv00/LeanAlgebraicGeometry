import AlgebraicJacobian.Picard.Pic0ChartCoverageAffineTest
open CategoryTheory Limits Opposite AlgebraicGeometry
universe u
namespace WRev
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]
noncomputable section

-- D1. At ι = PEmpty the AFFINE hypothesis is NOT free: it demands `∃ i : PEmpty, _`,
-- which is False for any affine Y with a point.  So the reduction is non-vacuous the same
-- way the pointwise one is: the hypothesis carries the content, not the conclusion.
example (h : ∀ (Y : Scheme.{u}) [IsAffine Y] (s : (pic0SigmaSheaf C).1.obj (op Y)) (y : ↥Y),
      ∃ (W : Y.Opens) (_ : y ∈ W) (i : PEmpty.{u+1}) (x : (W : Scheme.{u}) ⟶ PEmpty.elim i),
        ((fun i : PEmpty.{u+1} => PEmpty.elim i :
            ∀ i : PEmpty.{u+1}, yoneda.obj (PEmpty.elim i) ⟶ (pic0SigmaSheaf C).1) i).app
              (op (W : Scheme.{u})) x
          = (pic0SigmaSheaf C).1.map (W.ι).op s)
    (Y : Scheme.{u}) [IsAffine Y] (s : (pic0SigmaSheaf C).1.obj (op Y)) (y : ↥Y) : False := by
  obtain ⟨W, hyW, i, _⟩ := h Y s y
  exact i.elim

-- D2. But the CONCLUSION at PEmpty is the bottom sieve, so covering forces an EMPTY test.
-- Confirms I-0861 probe5/6 and shows the reduction's conclusion is not free either.
example (h : ChartsCoverLocally C (fun i : PEmpty.{u+1} => PEmpty.elim i))
    (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)) (t : ↥T) : False := by
  have := Scheme.mem_grothendieckTopology_iff.mp (h T s)
  obtain ⟨𝒰, hle⟩ := this
  obtain ⟨j, _, _⟩ := 𝒰.exists_eq t
  have hj := hle (𝒰.X j) (𝒰.f j) (Presieve.ofArrows.mk j)
  rw [iSup, Sieve.sSup_apply] at hj
  obtain ⟨S, ⟨i, rfl⟩, _⟩ := hj
  exact i.elim

end
end WRev
