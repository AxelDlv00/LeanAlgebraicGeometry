---
author: sync
content_type: theorem
created: '2026-07-28T17:25:27'
decl: AlgebraicGeometry.exists_datum_cechPicClass_twist
docstring: "**The engine input, assembled**: for any plus class over any affine base\
  \ `A` and any chart\nindex `(m, Z)`, once the class is read honestly over a base\
  \ `B` above `A` by a Čech class `c`,\na `BasicOpenCocycleDatum` over `B` presenting\
  \ `c` twisted by the chart index exists.\n\nThis composes the two halves that were\
  \ previously recorded as separate gates:\n\n* honesty over `B := E.Carrier` — `exists_honest_of_picEtAff`\
  \ above, which needs no field;\n* presentation of the twisted class by a datum —\
  \ `exists_cechPicClass_eq`, applied at the\n  *product* class, which is why no `BasicOpenCocycleDatum.mul`\
  \ is needed\n  (`Picard/Pic0ChartTwistCollapse.lean`).\n\nThe conclusion is exactly\
  \ the input of\n`BasicOpenCocycleDatum.isOpen_setOf_exists_witness_h1_vanishing`,\
  \ so the openness of the witness\nlocus over `Spec B` is available for every plus\
  \ class and every chart index.  What is *not* here\nis the identification of that\
  \ locus with `chartLocus` — that is `IsChartDatumPresentation`, the\none genuine\
  \ remaining obligation of CHART-U(b).\n\nStated with `c` as a hypothesis rather\
  \ than bundled into the existential: bundling it forces the\nelaborator to unify\
  \ the tower instances on `B` while `B` is still a metavariable, which is the\nhazard\
  \ recorded at `Picard/Pic0ChartSplit.lean`'s closing note.  A consumer obtains `B`\
  \ and `c`\nfrom `exists_honest_of_picEtAff` plus `relPicMk_surjective`, then applies\
  \ this."
file: AlgebraicJacobian/Picard/Pic0ChartHonest.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.exists_datum_cechPicClass_twist
type: lean
updated: '2026-07-31T20:14:42'
---
theorem exists_datum_cechPicClass_twist {B : Type u} [CommRing B] [Algebra k B]
    (c : (relCurve C B).CechPic) (m : ℕ)
    (Z : (C ⊗ overSpec k k).left.CurveDivisor) :
    ∃ D : BasicOpenCocycleDatum C B π,
      D.cechPicClass
        = c * Scheme.CechPic.map (relCurveMap C k B) (chartTwistClass C m Z) :=
  exists_datum_cechPicClass_chartTwistClass c m Z