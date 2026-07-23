---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushPull_unit_mate
docstring: '**Base-change unit (mate) identity for the push–pull head.**

  For composable scheme morphisms `f : A ⟶ B`, `p : B ⟶ Z` and `N : Z.Modules`, the

  adjunction unit at `N` for `p` followed by the *head* of `pushPullMap` (the

  pushforward of the unit for `f`, then the pushforward comparison) equals the unit

  for the composite `f ≫ p` followed by the pushforward of the inverse pullback

  comparison. This is the mate-calculus core that converts the single-morphism unit

  `η^{f≫p}` into the iterated units `η^p`, `η^f`; it is the reusable ingredient that

  the functoriality (pentagon) law of `pushPullMap` repeatedly consumes when

  splitting a composite unit. Project-local supplement.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushPull_unit_mate
type: lean
updated: '2026-07-24T03:02:09'
---
lemma pushPull_unit_mate {A B Z : Scheme.{u}} (f : A ⟶ B) (p : B ⟶ Z)
    (N : Z.Modules) :
    (Scheme.Modules.pullbackPushforwardAdjunction p).unit.app N ≫
        (Scheme.Modules.pushforward p).map
          ((Scheme.Modules.pullbackPushforwardAdjunction f).unit.app
            ((Scheme.Modules.pullback p).obj N)) ≫
        (Scheme.Modules.pushforwardComp f p).hom.app
          ((Scheme.Modules.pullback f).obj ((Scheme.Modules.pullback p).obj N)) =
      (Scheme.Modules.pullbackPushforwardAdjunction (f ≫ p)).unit.app N ≫
        (Scheme.Modules.pushforward (f ≫ p)).map
          ((Scheme.Modules.pullbackComp f p).inv.app N) := by
  have key := unit_conjugateEquiv
    ((Scheme.Modules.pullbackPushforwardAdjunction p).comp
      (Scheme.Modules.pullbackPushforwardAdjunction f))
    (Scheme.Modules.pullbackPushforwardAdjunction (f ≫ p))
    (Scheme.Modules.pullbackComp f p).inv N
  rw [Scheme.Modules.conjugateEquiv_pullbackComp_inv, Adjunction.comp_unit_app] at key
  exact key