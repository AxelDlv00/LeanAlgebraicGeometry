---
author: sync
content_type: theorem
created: '2026-07-16T21:14:29'
decl: AlgebraicGeometry.snd_left_isClosedMap
docstring: '**Completeness of `X` makes the projection `X ⊗ Y ⟶ Y` a closed map.**
  When `X` is complete

  (proper) over `k̄`, the second monoidal projection `snd : X ⊗ Y ⟶ Y` has, on underlying
  schemes, a

  *closed* base map. This is Mumford''s "completeness of `X` makes `p₂` a closed map"
  (Abelian

  Varieties, Ch. II §4, p. 43).


  Proof: the underlying scheme morphism `(snd X Y).left` is the pullback projection

  `Limits.pullback.snd X.hom Y.hom` (`Over.snd_left`), i.e. the base change of `X.hom`
  along

  `Y.hom`. `IsProper X.hom ⟹ UniversallyClosed X.hom` (`IsProper.toUniversallyClosed`),
  and

  `UniversallyClosed` is stable under base change

  (`universallyClosed_isStableUnderBaseChange.of_isPullback` on the canonical pullback
  square), so

  `(snd X Y).left` is universally closed and hence its base map is closed

  (`Scheme.Hom.isClosedMap`). Valid in any characteristic; no theorem of the cube,
  no

  cohomology.'
file: AlgebraicJacobian/RigidityLemma.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.snd_left_isClosedMap
type: lean
updated: '2026-07-27T01:33:12'
---
theorem snd_left_isClosedMap
    {X Y : Over (Spec (.of kbar))} [IsProper X.hom] :
    IsClosedMap (snd X Y).left.base := by
  haveI hp : UniversallyClosed X.hom := IsProper.toUniversallyClosed
  haveI : UniversallyClosed (snd X Y).left := by
    rw [Over.snd_left]
    exact universallyClosed_isStableUnderBaseChange.of_isPullback
      (IsPullback.of_hasPullback X.hom Y.hom) hp
  exact Scheme.Hom.isClosedMap _