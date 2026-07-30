---
author: sync
content_type: theorem
created: '2026-07-30T12:49:24'
decl: AlgebraicGeometry.exists_crossing_or_not_injective_mixedParamChart
docstring: '**The dichotomy at `mixedParamChart`**, i.e. at the real atlas.


  `mixedParamChart` is `restrictChart` of `abelSigmaChart` applied pointwise, so the
  coverage

  hypothesis here is literally the `PointwiseCoverage` of the family the seam consumes.  The

  conclusion is the dichotomy of

  `exists_crossing_or_not_injective_of_pointwiseCoverage_of_ne_top`, read at the Abel
  charts.


  This is what makes the multi-index measurement bear on the campaign rather than
  on an

  abstraction: the tree''s `V`-interval refutations are all at `ι := PUnit`, and this
  says what

  survives at the `ι` the assembly quantifies over — a disjunction, with the crossing
  alternative

  live by `not_indexSeparated_duplicated`.'
file: AlgebraicJacobian/Picard/Pic0ChartMultiIndexInterval.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_crossing_or_not_injective_mixedParamChart
type: lean
updated: '2026-07-30T12:49:24'
---
theorem exists_crossing_or_not_injective_mixedParamChart {ι : Type u} (nn : ι → ℕ)
    (D : ι → Over (Spec (.of k)))
    (rep : ∀ i, (divFunctor C π (nn i)).RepresentableBy (D i))
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (nn i : ℤ))
    (V : ∀ i, (D i).left.Opens) (i₀ : ι) (hV : V i₀ ≠ ⊤)
    (hcov : PointwiseCoverage C (mixedParamChart C π nn D rep m Z hdeg V)) :
    ∃ (W : (D i₀).left.Opens) (i : ι) (x : (W : Scheme.{u}) ⟶ (D i).left),
      (abelSigmaChart C π (nn i) (rep i) (m i) (Z i) (hdeg i)).app
            (op (W : Scheme.{u})) x
          = (abelSigmaChart C π (nn i₀) (rep i₀) (m i₀) (Z i₀) (hdeg i₀)).app
            (op (W : Scheme.{u})) (W.ι) ∧
        (i ≠ i₀ ∨ ¬ Function.Injective
          ((abelSigmaChart C π (nn i₀) (rep i₀) (m i₀) (Z i₀) (hdeg i₀)).app
            (op (W : Scheme.{u})))) :=
  exists_crossing_or_not_injective_of_pointwiseCoverage_of_ne_top C
    (fun i => abelSigmaChart C π (nn i) (rep i) (m i) (Z i) (hdeg i)) V i₀ hV hcov

variable (C π) in