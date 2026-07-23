---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.CechLocalized.cech_hcomm
docstring: '**Coface commutation** `hcomm` (the `d² = 0` swap identity) for the concrete

  localised {\v C}ech maps.  Both bracketings of the double coface are away-comparison

  maps from the (swap-invariant) double-deletion localisation to `A_σ`, hence equal.'
file: AlgebraicJacobian/Cohomology/CechAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.CechLocalized.cech_hcomm
type: lean
updated: '2026-07-24T03:02:09'
---
lemma cech_hcomm {m : ℕ} (σ : Fin (m + 2) → ι) (j : Fin (m + 2)) (i : Fin (m + 1))
    (z : cechCoeff s M r ((σ ∘ j.succAbove) ∘ i.succAbove)) :
    cechCoface s M r (m + 1) σ j (cechCoface s M r m (σ ∘ j.succAbove) i z)
      = cechCoface s M r (m + 1) σ (j.succAbove i)
          (cechCoface s M r m (σ ∘ (j.succAbove i).succAbove) (i.predAbove j)
            ((CombinatorialCech.comp_succAbove_swap σ j i).symm ▸ z)) := by
  have heqc : (σ ∘ j.succAbove) ∘ i.succAbove
      = (σ ∘ (j.succAbove i).succAbove) ∘ (i.predAbove j).succAbove :=
    (CombinatorialCech.comp_succAbove_swap σ j i).symm
  have hinvc : AwayComparison.Inverts (s r * sprod s ((σ ∘ j.succAbove) ∘ i.succAbove))
      (cechCoeff s M r ((σ ∘ (j.succAbove i).succAbove) ∘ (i.predAbove j).succAbove)) :=
    AwayComparison.Inverts.of_dvd (dvd_of_eq (by rw [heqc])) (LocalizedModule.mkLinearMap _ M)
  have key : AwayComparison.Inverts (s r * sprod s ((σ ∘ j.succAbove) ∘ i.succAbove))
      (cechCoeff s M r σ) :=
    AwayComparison.Inverts.of_dvd
      (mul_dvd_mul_left (s r)
        (dvd_trans (sprod_succAbove_dvd s (σ ∘ j.succAbove) i) (sprod_succAbove_dvd s σ j)))
      (LocalizedModule.mkLinearMap _ M)
  simp only [cechCoface, LinearMap.toAddMonoidHom_coe]
  rw [cechCoeff_transport_eq_comparison s M r heqc hinvc,
    AwayComparison.comparison_comp_apply, AwayComparison.comparison_comp_apply,
    AwayComparison.comparison_comp_apply]
  · exact key
  · rw [CombinatorialCech.comp_succAbove_swap]; exact key