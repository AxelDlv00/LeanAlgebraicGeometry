---
author: ajc-truth
created: '2026-07-28T07:35:10'
date: '2026-07-28T07:35:10'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '7'
  rounds: '8'
  run: '0054'
  session: 0016-horizon-ajc-truth
  task: ajc-truth
  task_title: Publish the true axiom frontier and align the Jacobian route
title: 'the whole remaining content is GeometricallyReduced: mathlib''s public smooth_of_grpObj
  does the translation argument'
updated: '2026-07-28T07:35:10'
---
MEASURED 2026-07-28 (task ajc-truth): the remaining content of this theorem is
`GeometricallyReduced (Pic0Scheme C).hom` and NOTHING ELSE. Mathlib's public
`AlgebraicGeometry.smooth_of_grpObj` already performs the translation argument this
docstring plans, in full generality over an arbitrary field.

    @smooth_of_grpObj : ∀ {K} [Field K] {G : Scheme} (f : G ⟶ Spec (CommRingCat.of K))
      [LocallyOfFiniteType f] [GrpObj (Over.mk f)] [GeometricallyReduced f], Smooth f

Of its three inputs, two are already landed in this file and elaborate at the
hypotheses of `Pic0.smooth` verbatim:

  * `LocallyOfFiniteType (Pic0Scheme C).hom` — `Pic0.locallyOfFiniteType C`;
  * `GrpObj (Over.mk (Pic0Scheme C).hom)` — from `Pic0.grpObj C` after `obtain ⟨i⟩`;
    `Over.mk (Pic0Scheme C).hom` accepts that instance directly, so there is no
    `Over`-repackaging obstruction (checked by elaboration, not by reading).

The third does not synthesize:

    example : GeometricallyReduced (Pic0Scheme C).hom := by infer_instance
    -- failed to synthesize instance of type class GeometricallyReduced (Pic0Scheme C).hom

and the only producer in the tree is `Smooth.geometricallyReduced`
(`[Smooth f] → GeometricallyReduced f`, priority 100), which would make the reduction
circular. So this is a genuine reduction of the obligation, not a discharge, and it
changes what the obligation IS:

  * the docstring plans smoothness at the identity, propagated by translation, with the
    identity case resting on Cartier in characteristic zero and on `H²(C, 𝒪_C) = 0` in
    characteristic p. The translation half of that is no longer work — mathlib does it,
    and via a faithfully-flat descent to `k̄` rather than by hand;
  * what remains is exactly geometric reducedness of `Pic⁰_{C/k}`, i.e. reducedness of
    `Pic⁰_{C/k̄}`. That is Cartier's theorem in characteristic zero (every group scheme
    of finite type over a field of characteristic 0 is reduced, hence smooth) and a real
    theorem in characteristic p, where non-reduced group schemes exist (μ_p, α_p) and the
    curve-specific input is needed to rule them out here.

Consequence for anyone proving this: do not build the translation machinery. Prove
`GeometricallyReduced (Pic0Scheme C).hom` and apply `smooth_of_grpObj`. Note also that
the sibling project has the translation lemmas standalone and sorry-free
(`AbelianVariety/Translation.lean`, `GrpObj.pointTranslationIso` and
`mem_smoothLocus_iff_of_comp_eq`), written because mathlib's own version of the argument
is `private` (`smooth_of_grpObj_of_isAlgClosed`) — but for THIS statement the public
wrapper suffices and the sibling's lemmas are not needed.

`Pic0.proper` is NOT reduced by any of this; its Chevalley–Rosenlicht route stands.
