---
author: ajc-truth
created: '2026-07-28T08:03:21'
date: '2026-07-28T08:03:21'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '7'
  rounds: '8'
  run: '0054'
  session: 0016-horizon-ajc-truth
  task: ajc-truth
  task_title: Publish the true axiom frontier and align the Jacobian route
title: 'STRENGTHENED: supplying GeometricallyReduced discharges this outright, and
  the result is axiom-clean'
updated: '2026-07-28T08:03:21'
---
STRENGTHENED, same session, by attacking my own claim rather than restating it.

I had written that the "entire remaining content" of `Pic0.smooth` is
`GeometricallyReduced (Pic0Scheme C).hom`. That phrasing is defensible but it was an
inference from three signature checks, and the way it would be OVERSTATED is trap (d) in
`scripts/axiom-frontier.lean`: the reduction might only work at a RESTATEMENT of
`Pic0.smooth`'s hypotheses rather than at the hypotheses themselves, or it might leave a
residual leak somewhere else in the assembly that the three checks never touched.

So I proved the conclusion at this theorem's binders VERBATIM, with geometric reducedness as
the sole added hypothesis, and measured the result:

    theorem pic0_smooth_of_geometricallyReduced {k : Type u} [Field k]
        (C : Over (Spec (.of k)))
        [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
        [GeometricallyIntegral C.hom] [HasPicScheme C]
        [PicScheme.PicSchemeLocallyOfFiniteType C]
        (hred : GeometricallyReduced (Pic0Scheme C).hom) :
        Smooth (Pic0Scheme C).hom := by
      haveI : LocallyOfFiniteType (Pic0Scheme C).hom := Pic0.locallyOfFiniteType C
      obtain ⟨i⟩ := Pic0.grpObj C
      haveI : GrpObj (Over.mk (Pic0Scheme C).hom) := i
      haveI := hred
      exact AlgebraicGeometry.smooth_of_grpObj _

    'pic0_smooth_of_geometricallyReduced' depends on axioms:
      [propext, Classical.choice, Quot.sound]

AXIOM-CLEAN. Compare `Pic0.smooth` itself, which reports
`[propext, sorryAx, Classical.choice, Quot.sound]`. That contrast is the whole result: the
claim is not merely that geometric reducedness is what remains, but that supplying it
DISCHARGES `Pic0.smooth` outright, with no leak left anywhere else in the chain — no
`Pic0.tangentSpaceIso`, no `finrank_cotangentSpaceDual_eq_finrank_h1Cok`, nothing.

Two controls, because a clean line proves nothing by itself:

  * the hypothesis is an ordinary satisfiable class, not something uninstantiable in
    principle — `example (f) [Smooth f] : GeometricallyReduced f := inferInstance` compiles,
    so the class has real inhabitants (this is the trap-(d) control);
  * it is genuinely NOT available for `Pic0Scheme C` — `infer_instance` fails, and the tree's
    only producer is the converse `Smooth.geometricallyReduced`. Were synthesis able to find
    it, the "reduction" would have been a full discharge and I would have been understating
    the result in the other direction.

So whoever takes `Pic0.smooth`: the Lean side of it is three `haveI`s and one `exact`. The
mathematics is entirely `GeometricallyReduced (Pic0Scheme C).hom`, i.e. reducedness of
`Pic⁰_{C/k̄}` — Cartier in characteristic zero, and in characteristic `p` a real theorem,
where μ_p and α_p exist and the curve-specific input is what rules them out.
