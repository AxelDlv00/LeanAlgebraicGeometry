/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivRepAffChallenge
import AlgebraicJacobian.Picard.Pic0AtlasFromDivRepAff
import AlgebraicJacobian.Picard.Pic0ChartAtlasCoupling

/-!
# The widened divisor representer at the Picard atlas seam

The widened divisor functor of a challenge curve is represented at the genus parameter.  This
module inserts that representation into the Abel construction and then into the Zariski-local
representability theorem for the degree-zero Picard functor.

The resulting chart family has no assumed divisor representation.  Its remaining inputs are the
two geometric conditions of the local-representability theorem: every restricted Abel map is a
representable open immersion, and the restricted maps cover the Picard sheaf pointwise.

## Main declarations

* `AlgebraicGeometry.abelSigmaChartAffGenus` is the widened Abel chart formed from the chosen
  genus-parameter divisor representer.
* `AlgebraicGeometry.universalDivFamAffGenus` is its universal widened divisor family.
* `AlgebraicGeometry.affineGenusChart` restricts a multi-index family of these maps to chosen
  source opens.
* `AlgebraicGeometry.pic0RepresentableByOfAffineGenusCharts` represents `pic0TypeFunctor C`
  once the restricted charts are open immersions and cover pointwise.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory Opposite

namespace AlgebraicGeometry

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

noncomputable section

/-- The universal widened divisor family carried by the chosen genus-parameter representer. -/
def universalDivFamAffGenus :
    divFamZarAff C (genus C) (divRepAffGenusScheme C) :=
  (divFunctorAff_genus_representableBy C).homEquiv (𝟙 _)

/-- Pulling back the chosen universal family gives the widened family classified by the
corresponding morphism into the genus representer. -/
theorem universalDivFamAffGenus_map {T : Over (Spec (.of k))}
    (q : T ⟶ divRepAffGenusScheme C) :
    divFamZarAff.map C (genus C) q (universalDivFamAffGenus C)
      = (divFunctorAff_genus_representableBy C).homEquiv q := by
  have h := (divFunctorAff_genus_representableBy C).homEquiv_comp q
    (𝟙 (divRepAffGenusScheme C))
  rw [Category.comp_id] at h
  exact h.symm

/-- The widened Abel chart at the genus parameter, using the challenge curve's chosen divisor
representer rather than accepting a representability witness as an argument. -/
def abelSigmaChartAffGenus
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (genus C : ℤ)) :
    yoneda.obj (divRepAffGenusScheme C).left ⟶ (pic0SigmaSheaf C).1 :=
  abelSigmaChartAff C (genus C) (divFunctorAff_genus_representableBy C) m Z hdeg

/-- The structure morphism read from a genus-parameter widened Abel chart is the structure
morphism of the chosen divisor representer. -/
lemma chartHom_abelSigmaChartAffGenus
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (genus C : ℤ))
    {ι : Type u} (i : ι) :
    chartHom C (fun _ : ι => abelSigmaChartAffGenus C m Z hdeg) i
      = (divRepAffGenusScheme C).hom :=
  chartHom_abelSigmaChartAff (divFunctorAff_genus_representableBy C) m Z hdeg i

/-- A multi-index family of genus-parameter widened Abel charts, restricted to source opens.
Different indices may use different twists and different opens, but they all use the same
unconditional divisor representer. -/
def affineGenusChart {ι : Type u}
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (genus C : ℤ))
    (V : ∀ _ : ι, (divRepAffGenusScheme C).left.Opens) (i : ι) :
    yoneda.obj (V i : Scheme) ⟶ (pic0SigmaSheaf C).1 :=
  restrictChart (abelSigmaChartAffGenus C (m i) (Z i) (hdeg i)) (V i)

/-- The structure morphism of a restricted genus chart is the inclusion of its source open
followed by the structure morphism of the chosen divisor representer. -/
lemma chartHom_affineGenusChart {ι : Type u}
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (genus C : ℤ))
    (V : ∀ _ : ι, (divRepAffGenusScheme C).left.Opens) (i : ι) :
    chartHom C (affineGenusChart C m Z hdeg V) i
      = (V i).ι ≫ (divRepAffGenusScheme C).hom := by
  change chartHom C (fun _ : ι => restrictChart
    (abelSigmaChartAffGenus C (m i) (Z i) (hdeg i)) (V i)) i = _
  exact (chartHom_restrictChart
    (abelSigmaChartAffGenus C (m i) (Z i) (hdeg i)) (V i) i).trans
      (congrArg ((V i).ι ≫ ·)
        (chartHom_abelSigmaChartAffGenus C (m i) (Z i) (hdeg i) i))

/-- The degree-zero Picard functor is represented by the glued object of any pointwise-covering
family of open genus-parameter widened Abel charts.

The divisor representation is construction data, not a hypothesis: it is supplied by
`divFunctorAff_genus_representableBy`.  The two hypotheses are exactly the geometric inputs of
Zariski local representability. -/
def pic0RepresentableByOfAffineGenusCharts {ι : Type u}
    (m : ι → ℕ) (Z : ι → (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : ∀ i, Scheme.CurveDivisor.deg k (Z i)
      = (m i : ℤ) * classDeg k (thetaCechClass C) - (genus C : ℤ))
    (V : ∀ _ : ι, (divRepAffGenusScheme C).left.Opens)
    (hf : ∀ i, IsOpenImmersion.presheaf (affineGenusChart C m Z hdeg V i))
    (hcov : PointwiseCoverage C (affineGenusChart C m Z hdeg V)) :
    Σ J : Over (Spec (.of k)), (pic0TypeFunctor C).RepresentableBy J := by
  letI : Presheaf.IsLocallySurjective Scheme.zariskiTopology
      (Sigma.desc (affineGenusChart C m Z hdeg V)) :=
    isLocallySurjective_sigmaDesc_of_pointwise C _ hcov
  exact ⟨_, pic0RepresentableByOfCharts C (affineGenusChart C m Z hdeg V) hf⟩

end

end AlgebraicGeometry
