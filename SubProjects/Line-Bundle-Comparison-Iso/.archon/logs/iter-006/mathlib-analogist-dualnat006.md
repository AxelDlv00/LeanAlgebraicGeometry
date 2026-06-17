# Mathlib-analogist directive — iter-006

## Mode: cross-domain-inspiration

## Structural problem
We must prove NATURALITY of a sectionwise family of module-morphisms indexed by the
thin poset `Opens Y` (Y a scheme), assembling into a `PresheafOfModules.isoMk`. The
family `sliceDualTransport f M V` is built as a composite of two legs:
- leg-A: a slice-Hom base-change along an opens-functor reindex (`Over.map`/`opensFunctor f`,
  a `.map` reindex of an internal-Hom / dual presheaf), and
- leg-B: the inverse of the lax-monoidal unit comparison `ε` of `restrictScalars g` at the
  `CommRingCat`/`RingCat` level (`PresheafOfModules.restrictScalarsLaxε`).
The naturality square (for `g : V ⟶ W` in `Opens Y`) must commute. Reducing via
`hom_ext`+`LinearMap.ext z` lands a pointwise ε-commutation equation that has resisted
closure for 30+ iterations; recent attempts either time out at `whnf` or misapply `ext`.

## Failed approaches
- `ext z; simp [pushforward/restrictScalars lemmas]; exact (φ.naturality …) z` — heartbeat
  timeout at whnf (the composite is too deep to reduce).
- `subsingleton` to kill the OUTER isoMk square — only valid when the connecting Hom-space
  is genuinely a subsingleton (dual-valued codomain); fails when codomain is a unit-restriction.
- Hand-pasting the four legs (eqToHom transport, ψ-reindex core, two ε-swaps) through the
  restriction `.map` via `erw` — never assembles; breaks the file.

## Search radius: wide
Find where Mathlib proves naturality of an analogous *sectionwise/pointwise* transport family
that factors through a lax-monoidal unit comparison `ε` and a reindexing functor — e.g.
naturality of a base-change/coherence iso for restriction-of-scalars, pushforward of internal
Hom, or a mate/conjugate of a monoidal-functor unitor. Return: the Mathlib citation, the
technique it uses to AVOID the deep whnf reduction (e.g. assembling from existing `_natural`
lemmas, `whiskerLeft/Right` + `MonoidalCategory` coherence, or `Adjunction`/`conjugateEquiv`
mate identities), and a concrete port suggestion for our `sliceDualTransport` family.
