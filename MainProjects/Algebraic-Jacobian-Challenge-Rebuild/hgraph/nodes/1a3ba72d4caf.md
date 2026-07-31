---
author: sync
content_type: theorem
created: '2026-07-29T22:53:22'
decl: AlgebraicGeometry.isLocallySurjective_of_slice
docstring: '**Antecedent 2 of `pic0RepresentableByOfCharts`, from slice data over
  affine tests.**


  The composite with B-6 (`isLocallySurjective_sigmaDesc`).  This is the honest endpoint
  of the

  reduction: the instance the DAT-glue seam consumes, from the cheapest form of the
  coverage

  datum the tree can currently state.


  **The class equation is still open**, and it is the whole of what is left here.  Its
  cost is a

  divisor family over a *neighbourhood* produced from data at a *point* — a spreading-out,
  absent

  from the tree for this carrier.'
file: AlgebraicJacobian/Picard/Pic0ChartCoverageSlice.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isLocallySurjective_of_slice
type: lean
updated: '2026-07-31T20:15:26'
---
theorem isLocallySurjective_of_slice {ι : Type u} [Nonempty ι] {D : Over (Spec (.of k))}
    (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ))
    (h : ∀ (Y : Scheme.{u}) [IsAffine Y] (s : (pic0SigmaSheaf C).1.obj (op Y)) (y : ↥Y),
      ∃ (W : Y.Opens) (_ : y ∈ W) (g : Over.mk (W.ι ≫ s.1) ⟶ D),
        (pic0TypeFunctor C).map (Over.mkCongr (Over.w g)).op
            ((pic0TypeFunctor C).map
              (Over.homMk W.ι rfl : Over.mk (W.ι ≫ s.1) ⟶ Over.mk s.1).op s.2)
          = ⟨chartValue C π n m Z (Over.mk (g.left ≫ D.hom))
              (rep.homEquiv (Over.homMk g.left rfl)),
            chartValue_mem_pic0Subgroup C π n m Z hdeg _ _⟩) :
    Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (fun _ : ι => abelSigmaChart C π n rep m Z hdeg)) :=
  isLocallySurjective_sigmaDesc _ (chartsCoverLocally_of_slice C π n rep m Z hdeg h)