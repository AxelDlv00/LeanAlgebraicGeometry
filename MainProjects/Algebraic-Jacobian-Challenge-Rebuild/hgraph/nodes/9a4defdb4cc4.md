---
author: sync
content_type: definition
created: '2026-07-29T05:13:21'
decl: AlgebraicGeometry.IsChartLocusFibre
docstring: "**The residue of C9b, named**: for every test point of the Σ-sheaf, the\
  \ chart point over\nits chart locus together with the two properties the criterion\
  \ needs.\n\n**THE NEXT SENTENCE WAS FALSE AND IS RETRACTED (2026-07-29,\n`Picard/Pic0ChartLocusFibreGuard.lean`).**\
  \  It read: \"This is `ChartFibrePresented` with its\n`W` field already discharged\
  \ — it is `chartLocus`, open unconditionally\".  The `W` field is\n**free**: it\
  \ is a field of the structure, quantified inside the `Nonempty` below, and\n`chartLocus`\
  \ occurs nowhere in this definition — nor does `chartLocus` or `V` enter the proof\n\
  of `isChartUniv_of_isChartLocusFibre`.  The criterion consumes the datum for the\n\
  **unrestricted** chart, so this statement implies\n`IsOpenImmersion.presheaf (abelSigmaChart\
  \ …)` at `V = ⊤`, hence `Mono`, hence injectivity on\nevery test — which `Pic0AtlasFromDivRep.lean:54`,\
  \ `Pic0ChartPair.lean:14` and\n`Pic0ChartOpenImmersionCriterion.lean:214` all cite\
  \ as FALSE for the Abel chart (its fibres\nare the linear systems `|D|`).  If those\
  \ headers are right this definition is\n**unsatisfiable** and `isChartUniv_of_isChartLocusFibre`,\
  \ though sorry-free, can never fire.\nSee `not_isChartLocusFibre_of_not_injective`\
  \ for the guard instantiated here, and inbox\n`I-0874`.  A lane must decide that\
  \ fork before attacking `exists_factor`.\n\nModulo that retraction, what a lane\
  \ owes is:\n\n* `r`: the divisor family over the locus whose class is the given\
  \ one.  This is the\n  classifier `divRepClassifyZar` applied to the canonical-section\
  \ family, i.e. CHART-U(c)'s\n  construction;\n* `sq`: that its chart value *is*\
  \ the given class, which is the classifier's characterising\n  property;\n* `exists_factor`:\
  \ that two points with the same class agree, i.e. the **relative form of\n  DAT-C\
  \ GAP-2** (`Scheme.CurveDivisor.eq_of_picClass_eq_of_h0_one` in families).\n\nStated\
  \ as a `Prop` over an arbitrary presenting datum rather than as a structure carrying\
  \ the\nfamily, because the family is the classifier's output and this lane must\
  \ not guess its shape:\nthe existential is over morphisms of schemes only."
file: AlgebraicJacobian/Picard/Pic0ChartUnivReduce.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.IsChartLocusFibre
type: lean
updated: '2026-07-30T15:28:02'
---
def IsChartLocusFibre {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ)) : Prop :=
  ∀ (T : Scheme.{u}) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1),
    Nonempty (ChartFibrePresented C (abelSigmaChart C π n rep m Z hdeg) g)