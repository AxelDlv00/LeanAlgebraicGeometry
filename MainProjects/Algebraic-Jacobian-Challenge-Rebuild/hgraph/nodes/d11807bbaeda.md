---
author: sync
content_type: definition
created: '2026-07-25T16:02:28'
decl: AlgebraicGeometry.DivRepChartFamilyZar.IsCompatible
docstring: 'The F5 overlap obligation at the `Zar` level: two chart points inducing
  the same

  morphism to `DivScheme` pull the supplied classes to the same class.'
file: AlgebraicJacobian/Picard/DivRepAffKitZar.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivRepChartFamilyZar.IsCompatible
type: lean
updated: '2026-07-25T16:02:28'
---
def IsCompatible
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZar C (ChartRing i j) pi g) : Prop :=
  ∀ {S : Type u} [CommRing S] [Algebra k S]
    (i : (glueData k g r1).J) (j : (glueData k g r2).J)
    (i' : (glueData k g r1).J) (j' : (glueData k g r2).J)
    (omega : ChartRing i j →ₐ[k] S) (omega' : ChartRing i' j' →ₐ[k] S),
    Spec.map (CommRingCat.ofHom omega.toRingHom) ≫ ChartMap i j
        = Spec.map (CommRingCat.ofHom omega'.toRingHom) ≫ ChartMap i' j' →
      divRepPullAtZar (hpi := hpi) g r1 r2 b1 b2 U i j omega
        = divRepPullAtZar (hpi := hpi) g r1 r2 b1 b2 U i' j' omega'

set_option linter.unusedSectionVars false in