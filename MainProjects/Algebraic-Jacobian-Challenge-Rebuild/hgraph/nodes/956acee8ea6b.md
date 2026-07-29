---
author: sync
content_type: theorem
created: '2026-07-29T05:13:20'
decl: AlgebraicGeometry.isOpenImmersion_presheaf_of_chartFibrePresented
docstring: "**THE CRITERION** — `IsOpenImmersion.presheaf` from elementwise data,\
  \ discharging BOTH\nclauses of `MorphismProperty.relative` at once.\n\nGiven, for\
  \ every test point of the target sheaf, a `ChartFibrePresented` datum, the chart\
  \ map\nis an open immersion of presheaves.  Certificate-free, divRep-free, and with\
  \ no reference to\ndivisors: the input is a family of opens of tests together with\
  \ the coverage statement on\neach.\n\nThis is the honest shape of `IsChartUniv`'s\
  \ obligation.  Reading `IsOpenImmersion.presheaf`\nas a single \"relative GAP-2\"\
  \ statement conflates:\n\n* **relative representability** — that the fibre product\
  \ is a scheme at all.  Supplied here\n  by `W`, an open subscheme of the test, and\
  \ proved by `ChartFibrePresented.isPullback`;\n* **the property clause** — that\
  \ each represented pullback is an open immersion.  Supplied\n  here by `W.ι` being\
  \ an open immersion, which is free.\n\nWhat is *not* free, and is the whole mathematical\
  \ content, is `exists_factor`: a class that\nagrees with a chart value must come\
  \ from the locus.  For the Abel chart that is the relative\nform of DAT-C GAP-2\
  \ (uniqueness of the normalized effective representative) fed through the\nclassifier\
  \ — so the CERT-Σ gate is real, but it gates ONE field of ONE structure rather than\n\
  the whole certificate."
file: AlgebraicJacobian/Picard/Pic0ChartOpenImmersionCriterion.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.isOpenImmersion_presheaf_of_chartFibrePresented
type: lean
updated: '2026-07-29T15:26:29'
---
theorem isOpenImmersion_presheaf_of_chartFibrePresented {X : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (D : ∀ (T : Scheme.{u}) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1),
      ChartFibrePresented C f g) :
    IsOpenImmersion.presheaf f := by
  refine MorphismProperty.relative.of_exists fun T g => ?_
  exact ⟨(D T g).W, yoneda.map (D T g).r, (D T g).W.ι, (D T g).isPullback,
    inferInstance⟩

/-! ## The criterion is not vacuous

A structure whose hard field is an existential can be inhabited for trivial reasons, and a
criterion built on one is then worthless.  This section rules that out **by proof** rather
than by inspection: the datum is unconstructible exactly when it must be. -/