---
author: sync
content_type: theorem
created: '2026-07-28T13:22:16'
decl: AlgebraicGeometry.preservesFiniteLimits_of_preservesMonomorphisms
docstring: '**Right exact + mono-preserving ⟹ left exact**, for an additive functor
  between abelian

  categories.  Project-local categorical supplement: mathlib has the TFAE

  `Functor.preservesFiniteLimits_tfae` characterising left exactness by "short exact
  sequences

  map to left-exact ones", and the right-exactness transport

  `ShortComplex.Exact.map_of_epi_of_preservesCokernel`, but not this packaged criterion.

  It is what reduces `pullback_preservesFiniteLimits` to mono-preservation.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.preservesFiniteLimits_of_preservesMonomorphisms
type: lean
updated: '2026-07-28T14:03:57'
---
theorem preservesFiniteLimits_of_preservesMonomorphisms (F : C ⥤ D) [F.Additive]
    [Limits.PreservesFiniteColimits F] [F.PreservesMonomorphisms] :
    Limits.PreservesFiniteLimits F := by
  rw [F.preservesFiniteLimits_iff_forall_exact_map_and_mono]
  intro T hT
  have := hT.mono_f
  exact ⟨hT.exact.map_of_epi_of_preservesCokernel F hT.epi_g inferInstance, inferInstance⟩

end RightExactMono

/-! ### Monomorphisms of `𝒪_X`-modules are sectionwise

The mono half of flat left-exactness is checked on sections, so both directions of
"mono ⟺ injective on sections" are needed.  The `⟸` direction (over a basis) is
`Modules.mono_of_injective_app_of_isBasis` in `Picard/FlatKernelBase.lean`; the `⟹`
direction is below.  Together they make mono-preservation of a *sectionwise* functor
mechanical, which discharges the open-immersion case of `pullback_preservesMonomorphisms`
outright. -/

set_option backward.isDefEq.respectTransparency false in