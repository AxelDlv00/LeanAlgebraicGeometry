import AlgebraicJacobian.Picard.Pic0ChartCoverageSlice
open CategoryTheory Limits Opposite AlgebraicGeometry MonoidalCategory CartesianMonoidalCategory
universe u
namespace WRev
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
noncomputable section

-- A1. A slice morphism into D over `Over.mk (W.ι ≫ s.1)` IS a bare x together with the
-- Sigma-equation; and its `.left` is that x DEFINITIONALLY.
example {D : Over (Spec (.of k))} (Y : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op Y))
    (W : Y.Opens) (x : (W : Scheme.{u}) ⟶ D.left) (hx : x ≫ D.hom = W.ι ≫ s.1) :
    (Over.homMk x hx : Over.mk (W.ι ≫ s.1) ⟶ D).left = x := rfl

-- A2. `Over.w` of that constructed g is the supplied Sigma-equation.
example {D : Over (Spec (.of k))} (Y : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op Y))
    (W : Y.Opens) (x : (W : Scheme.{u}) ⟶ D.left) (hx : x ≫ D.hom = W.ι ≫ s.1) :
    Over.w (Over.homMk x hx : Over.mk (W.ι ≫ s.1) ⟶ D) = hx := rfl

-- A3. CONVERSE of datum_of_slice: the pair equation gives hcl back.  So hcl <-> datum.
example {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (Y : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op Y)) (W : Y.Opens)
    (g : Over.mk (W.ι ≫ s.1) ⟶ D)
    (hpair : (abelSigmaChart C π n rep m Z hdeg).app (op (W : Scheme.{u})) g.left
      = (pic0SigmaSheaf C).1.map (W.ι).op s) :
    (pic0TypeFunctor C).map (Over.mkCongr (Over.w g)).op
        ((pic0TypeFunctor C).map
          (Over.homMk W.ι rfl : Over.mk (W.ι ≫ s.1) ⟶ Over.mk s.1).op s.2)
      = ⟨chartValue C π n m Z (Over.mk (g.left ≫ D.hom))
          (rep.homEquiv (Over.homMk g.left rfl)),
        chartValue_mem_pic0Subgroup C π n m Z hdeg _ _⟩ := by
  rw [abelChartApp_eq] at hpair
  exact Over.sigmaExtension_snd_eq (pic0TypeFunctor C) (Over.w g) hpair

end
end WRev
