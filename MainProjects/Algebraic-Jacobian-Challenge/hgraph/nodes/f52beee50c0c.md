---
author: sync
content_type: theorem
created: '2026-07-28T13:22:16'
decl: AlgebraicGeometry.pullback_preservesFiniteLimits_of_preservesMonomorphisms
docstring: '**Reduction of flat left-exactness to mono-preservation.**  For any `g`,
  if the module

  pullback `g^*` preserves monomorphisms then it preserves finite limits: it is additive
  and

  right exact (a left adjoint), so `preservesFiniteLimits_of_preservesMonomorphisms`
  applies.

  This is the *whole* categorical content of `pullback_preservesFiniteLimits`; the
  residual

  mathematics is the single statement `Mono (g^* ι)` for a mono `ι`, i.e. that flat
  pullback

  does not destroy injections (Stacks 00HL / 01BG stalkwise).  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pullback_preservesFiniteLimits_of_preservesMonomorphisms
type: lean
updated: '2026-07-28T13:22:16'
---
theorem pullback_preservesFiniteLimits_of_preservesMonomorphisms (g : S' ⟶ S)
    (h : (Scheme.Modules.pullback g).PreservesMonomorphisms) :
    Limits.PreservesFiniteLimits (Scheme.Modules.pullback g) :=
  haveI := h
  preservesFiniteLimits_of_preservesMonomorphisms (Scheme.Modules.pullback g)