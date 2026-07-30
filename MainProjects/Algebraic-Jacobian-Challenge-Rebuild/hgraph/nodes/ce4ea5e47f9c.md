---
author: sync
content_type: definition
created: '2026-07-28T22:23:02'
decl: AlgebraicGeometry.Scheme.LocalEquations.PullRegular
docstring: '**The `hreg` side-condition of `Scheme.LocalEquations.pullback`**, named.


  Naming it is what makes the widened overlap compatibility *statable at all*: that
  hypothesis

  must quantify over one `hreg` per index of the away cover, and the anonymous `∀
  y z hz, …`

  spelling cannot be so quantified.  `pullback` does not depend on WHICH proof is
  supplied (the

  `regular` field is a `Prop`), so introducing the abbreviation costs nothing and
  changes no

  existing statement.


  The compatibility that consumes it is `AwayCompatPullDivEq` below.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffGlueZarKit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.LocalEquations.PullRegular
type: lean
updated: '2026-07-30T15:46:03'
---
def PullRegular {X Y : Scheme.{u}} (f : Y ⟶ X) (d : X.LocalEquations) : Prop :=
  ∀ (y z : Y) (hz : z ∈ (d.cover.pullback f).opens y),
    (Y.presheaf.germ ((d.cover.pullback f).opens y) z hz).hom (pullbackEqn f d y)
      ∈ nonZeroDivisors (Y.presheaf.stalk z)