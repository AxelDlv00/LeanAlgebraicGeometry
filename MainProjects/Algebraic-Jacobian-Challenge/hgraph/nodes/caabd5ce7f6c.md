---
author: sync
content_type: theorem
created: '2026-07-28T19:06:12'
decl: AlgebraicGeometry.Scheme.Pic0.geometricallyReduced_of_isReduced_algebraicClosureBaseChange
docstring: '**The `k̄` hypothesis discharges `geometricallyReduced` too** — the corollary
  the first

  version of this section missed, found by fresh-context review (run 0067).


  `geometricallyReduced` above is an open `sorry` of this file, and it is *implied*
  by the very

  hypothesis `smooth_of_isReduced_algebraicClosureBaseChange` consumes: reducedness
  over `k̄`

  gives smoothness (that theorem), and smoothness gives the class

  (`Smooth.geometricallyReduced`, `Curve/GeometricallyReduced.lean`). So one statement
  discharges

  **both** the smoothness leg and the reducedness sorry.


  That is also why the "strictly weaker hypothesis" claim above had to be withdrawn:
  the same

  in-tree instance that makes this corollary work makes the two hypotheses interprovable.
  The

  corollary is the useful half of that correction — a reviewer''s negative finding
  turning into a

  positive one.


  Note this does **not** close `geometricallyReduced`: that theorem is stated with
  no hypothesis,

  and what is proved here is the implication from the `k̄` statement. What it does
  is collapse two

  apparently independent obligations into one, so a consumer supplying reducedness
  over `k̄` owes

  nothing further on either. Verified axiom-clean at the *root* import (not inside
  this file''s

  cone, where `Smooth.geometricallyReduced` is invisible — see the correction above).'
file: AlgebraicJacobian/Picard/Pic0AbelianVariety.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0.geometricallyReduced_of_isReduced_algebraicClosureBaseChange
type: lean
updated: '2026-07-28T19:06:12'
---
theorem geometricallyReduced_of_isReduced_algebraicClosureBaseChange {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (h : IsReduced (Limits.pullback (Pic0Scheme C).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k)))))) :
    GeometricallyReduced (Pic0Scheme C).hom :=
  haveI := smooth_of_isReduced_algebraicClosureBaseChange C h
  inferInstance