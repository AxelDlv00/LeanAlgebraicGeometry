---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.tildePreservesFiniteLimits_of_toPresheaf
docstring: '**Reduction of `tildePreservesFiniteLimits` to the presheaf level.**  The
  forgetful functor

  `Scheme.Modules.toPresheaf` from `𝒪_{Spec R}`-modules to presheaves of abelian groups
  is faithful,

  preserves limits, and reflects isomorphisms; hence (since `(Spec R).Modules` has
  finite limits) it

  reflects finite limits.  Therefore, to show `~` preserves finite limits it suffices
  to show the

  composite `~ ⋙ toPresheaf` does.  This isolates the remaining obligation of

  `lem:tilde_preserves_kernels` to a statement about the abelian-presheaf-valued composite,
  whose

  stalks are computed by `tilde_stalkFunctor_map_toStalk`.  Project-local categorical
  glue (it refutes

  the earlier-feared "no right-exact + mono ⟹ left-exact" obstruction: the reduction
  is purely

  `preservesFiniteLimits_of_reflects_of_preserves`).'
file: AlgebraicJacobian/Cohomology/TildeExactness.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.tildePreservesFiniteLimits_of_toPresheaf
type: lean
updated: '2026-07-16T21:14:26'
---
theorem tildePreservesFiniteLimits_of_toPresheaf
    (H : PreservesFiniteLimits
      (tilde.functor R ⋙ Scheme.Modules.toPresheaf (Spec (.of R)))) :
    PreservesFiniteLimits (tilde.functor R) :=
  haveI := H
  Limits.preservesFiniteLimits_of_reflects_of_preserves (tilde.functor R)
    (Scheme.Modules.toPresheaf (Spec (.of R)))

/-! ## Project-local Mathlib supplement — R-linear packaging of the Ab-stalk map -/