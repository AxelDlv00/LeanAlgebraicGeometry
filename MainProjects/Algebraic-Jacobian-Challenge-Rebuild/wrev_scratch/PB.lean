import AlgebraicJacobian.Picard.Pic0ChartCoverageSlice
open CategoryTheory Limits Opposite AlgebraicGeometry MonoidalCategory CartesianMonoidalCategory
universe u
namespace WRev
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
noncomputable section

-- THE CONVERSE OF chartsCoverLocally_of_slice's REDUCTION.
-- From the hypothesis chartsCoverLocally_of_affineLocal consumes at the ONE-CHART family
-- (a bare x plus the FULL pair equation), recover the SLICE hypothesis.
-- If this elaborates, the two hypotheses are INTERDERIVABLE: the slice form moved no gate.
example {ι : Type u} [Nonempty ι] {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (h : ∀ (Y : Scheme.{u}) [IsAffine Y] (s : (pic0SigmaSheaf C).1.obj (op Y)) (y : ↥Y),
      ∃ (W : Y.Opens) (_ : y ∈ W) (_ : ι) (x : (W : Scheme.{u}) ⟶ D.left),
        (abelSigmaChart C π n rep m Z hdeg).app (op (W : Scheme.{u})) x
          = (pic0SigmaSheaf C).1.map (W.ι).op s) :
    ∀ (Y : Scheme.{u}) [IsAffine Y] (s : (pic0SigmaSheaf C).1.obj (op Y)) (y : ↥Y),
      ∃ (W : Y.Opens) (_ : y ∈ W) (g : Over.mk (W.ι ≫ s.1) ⟶ D),
        (pic0TypeFunctor C).map (Over.mkCongr (Over.w g)).op
            ((pic0TypeFunctor C).map
              (Over.homMk W.ι rfl : Over.mk (W.ι ≫ s.1) ⟶ Over.mk s.1).op s.2)
          = ⟨chartValue C π n m Z (Over.mk (g.left ≫ D.hom))
              (rep.homEquiv (Over.homMk g.left rfl)),
            chartValue_mem_pic0Subgroup C π n m Z hdeg _ _⟩ := by
  intro Y _ s y
  obtain ⟨W, hyW, _, x, hpair⟩ := h Y s y
  -- the SIGMA-component falls straight out of the pair equation
  have hsig : x ≫ D.hom = W.ι ≫ s.1 := by
    rw [abelChartApp_eq] at hpair
    exact congrArg Sigma.fst hpair
  refine ⟨W, hyW, Over.homMk x hsig, ?_⟩
  rw [abelChartApp_eq] at hpair
  exact Over.sigmaExtension_snd_eq (pic0TypeFunctor C) hsig hpair

end
end WRev
