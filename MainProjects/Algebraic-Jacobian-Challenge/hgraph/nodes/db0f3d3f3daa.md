---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: carries
file: AlgebraicJacobian/Cohomology/CechTermAcyclic.lean
generated: lean
lean_status: lean_ok
title: carries
type: lean
updated: '2026-07-24T03:02:09'
---
lemma carries the corresponding hypothesis `hres` for the (finitely many) intersection opens. -/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

open Scheme.Modules

variable {X S : Scheme.{u}}

/-! ## Auxiliary: additivity of the right-derived functor

Mathlib defines `Functor.rightDerived` but registers no `Additive` instance for it (nor for
`injectiveResolutions`).  We supply both here: two descents of `f + g` between chosen injective
resolutions are homotopic, so in the homotopy category the descent of a sum is the sum of the
descents; additivity of the right-derived functor follows by composition. -/

section RightDerivedAdditive

variable {𝒜 ℬ : Type*} [Category 𝒜] [Abelian 𝒜] [HasInjectiveResolutions 𝒜]
  [Category ℬ] [Abelian ℬ]