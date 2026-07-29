---
author: sync
content_type: theorem
created: '2026-07-29T23:31:11'
decl: AlgebraicGeometry.Scheme.Pic0Et.geometricallyReduced_of_isReduced_algebraicClosureBaseChange
docstring: '**Geometric reducedness of `Pic⁰_{C/k}` from reducedness of the single
  scheme

  `Pic⁰ ×_{Spec k} Spec k̄`.**


  This is the étale counterpart of

  `Scheme.Pic0.geometricallyReduced_of_isReduced_algebraicClosureBaseChange`, and
  it

  discharges the *statement* of `Pic0Et.geometricallyReduced` from a hypothesis about

  one scheme, with no quantifier over field extensions.


  The route, and why it needs this project''s own converse: mathlib''s

  `smooth_of_grpObj` wants the full `GeometricallyReduced` class, and

  `GeometricallyReduced` has no `MorphismProperty.DescendsAlong` instance at v4.31,
  so

  the general-to-`k̄` reduction is not available from mathlib. What *is* available
  is

  `smooth_of_grpObj_of_isReduced_algebraicClosureBaseChange` (this project, taking

  reducedness over `k̄` alone) composed with this project''s

  `Smooth.geometricallyReduced` — which is why the single-scheme form is legitimate

  here even though it is not derivable in mathlib alone. Both of `Pic0Et`''s inputs
  to

  that engine are unconditional (`locallyOfFiniteType`, `grpObj`).'
file: AlgebraicJacobian/Picard/Pic0EtStructure.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0Et.geometricallyReduced_of_isReduced_algebraicClosureBaseChange
type: lean
updated: '2026-07-29T23:31:11'
---
theorem geometricallyReduced_of_isReduced_algebraicClosureBaseChange
    (h : IsReduced (Limits.pullback (Pic0SchemeEt C).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k)))))) :
    GeometricallyReduced (Pic0SchemeEt C).hom := by
  haveI : LocallyOfFiniteType (Pic0SchemeEt C).hom := locallyOfFiniteType C
  letI : GrpObj (Over.mk (Pic0SchemeEt C).hom) := (grpObj C).some
  haveI : Smooth (Pic0SchemeEt C).hom :=
    smooth_of_grpObj_of_isReduced_algebraicClosureBaseChange _ h
  infer_instance