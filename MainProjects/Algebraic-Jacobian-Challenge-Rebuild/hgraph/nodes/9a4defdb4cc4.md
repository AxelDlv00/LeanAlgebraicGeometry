---
author: sync
content_type: definition
created: '2026-07-29T05:13:21'
decl: AlgebraicGeometry.IsChartLocusFibre
docstring: "**The residue of C9b, named**: for every test point of the Σ-sheaf, the\
  \ chart point over\nits chart locus together with the two properties the criterion\
  \ needs.\n\nThis is `ChartFibrePresented` with its `W` field already discharged\
  \ — it is `chartLocus`,\nopen unconditionally — so what a lane owes is precisely:\n\
  \n* `r`: the divisor family over the locus whose class is the given one.  This is\
  \ the\n  classifier `divRepClassifyZar` applied to the canonical-section family,\
  \ i.e. CHART-U(c)'s\n  construction;\n* `sq`: that its chart value *is* the given\
  \ class, which is the classifier's characterising\n  property;\n* `exists_factor`:\
  \ that two points with the same class agree, i.e. the **relative form of\n  DAT-C\
  \ GAP-2** (`Scheme.CurveDivisor.eq_of_picClass_eq_of_h0_one` in families).\n\nStated\
  \ as a `Prop` over an arbitrary presenting datum rather than as a structure carrying\
  \ the\nfamily, because the family is the classifier's output and this lane must\
  \ not guess its shape:\nthe existential is over morphisms of schemes only."
file: AlgebraicJacobian/Picard/Pic0ChartUnivReduce.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.IsChartLocusFibre
type: lean
updated: '2026-07-29T15:31:47'
---
def IsChartLocusFibre {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ)) : Prop :=
  ∀ (T : Scheme.{u}) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1),
    Nonempty (ChartFibrePresented C (abelSigmaChart C π n rep m Z hdeg) g)