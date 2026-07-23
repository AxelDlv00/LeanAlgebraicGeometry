---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.cechFreeComplexAug_f_zero
docstring: 'The degree-`0` component of the augmentation chain map is the canonical
  map onto the image

  presheaf `O_𝒰`.'
file: AlgebraicJacobian/Cohomology/FreePresheafComplex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.cechFreeComplexAug_f_zero
type: lean
updated: '2026-07-16T21:14:26'
---
lemma cechFreeComplexAug_f_zero (𝒰 : X.OpenCover) [Finite 𝒰.I₀] :
    (cechFreeComplexAug 𝒰).f 0 = Limits.factorThruImage (cechFreeAug 𝒰) := by
  rw [cechFreeComplexAug, ChainComplex.toSingle₀Equiv_symm_apply_f_zero]

/-! ## Project-local Mathlib supplement — objectwise detection of quasi-isomorphisms

Homology in `PresheafOfModules R` is computed objectwise: the evaluation functors
`PresheafOfModules.evaluation R V` are jointly conservative and preserve homology, so a
morphism of complexes of presheaves of modules is a quasi-isomorphism as soon as each of its
evaluations is.  These three lemmas package that reduction.  Mathlib has the single-functor
statement `HomologicalComplex.quasiIso_map_iff_of_preservesHomology` (which needs the functor to
reflect isomorphisms — false for a single evaluation), but not the joint-conservativity version
needed to reduce a quasi-isomorphism of presheaf-of-module complexes to its sectionwise checks. -/

open HomologicalComplex in