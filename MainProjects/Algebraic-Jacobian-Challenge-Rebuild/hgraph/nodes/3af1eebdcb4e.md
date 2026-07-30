---
author: sync
content_type: definition
created: '2026-07-29T05:13:20'
decl: AlgebraicGeometry.ChartsCoverLocally
docstring: '**The coverage hypothesis of DAT-B, stated per chart rather than on the
  coproduct.**


  For every test `T` and every degree-zero class `s` on it, the maps into `T` along
  which `s`

  becomes the value of *some* chart of the family form a Zariski covering sieve.


  This is dat-b row B-5 verbatim — "every `pic⁰` point is Zariski-locally a chart
  point" — with

  one deliberate design choice: the sieve is described through the individual `f i`,
  so a

  producer discharges it by exhibiting, for each point of `T`, one open neighbourhood
  and one

  index.  It never has to mention `Sigma.desc` or the coproduct of yoneda presheaves.  Turning

  that into the coproduct form is `isLocallySurjective_sigmaDesc` below.'
file: AlgebraicJacobian/Picard/Pic0ChartLocalSurjectivity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ChartsCoverLocally
type: lean
updated: '2026-07-30T15:46:05'
---
def ChartsCoverLocally {ι : Type u} {X : ι → Scheme.{u}}
    (f : ∀ i, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1) : Prop :=
  ∀ (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)),
    (⨆ i, Presheaf.imageSieve (f i) s) ∈ Scheme.zariskiTopology T