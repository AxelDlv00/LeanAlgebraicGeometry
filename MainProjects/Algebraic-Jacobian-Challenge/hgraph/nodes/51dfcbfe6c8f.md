---
author: sync
content_type: theorem
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.uniformVanishing_of_uniform_base_of_genus_invariant
docstring: '**The reduction** (★): extension-uniform vanishing follows from a uniform
  base-divisor

  degree bound together with base-field invariance of the genus, and the uniform threshold
  is

  then simply `d + g`.


  Both hypotheses are needed and neither implies the other; see the module docstring
  for where

  each stands.  The proof is the monotonicity observation and nothing more: the explicit
  bound of

  `DegreeVanishing.subsingleton_hModule_one_of_deg_ge` at `C_κ` is

  `deg_κ D₀ + 1 − χ(𝒪_{C_κ}) = deg_κ D₀ + genus C_κ ≤ d + g`, so a `D` of degree `≥
  d + g`

  clears it.'
file: AlgebraicJacobian/RiemannRoch/Ledger/ExtensionUniformity.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.uniformVanishing_of_uniform_base_of_genus_invariant
type: lean
updated: '2026-07-29T06:43:23'
---
theorem uniformVanishing_of_uniform_base_of_genus_invariant {d : ℤ} {g : ℕ}
    (hbase : UniformBaseDivisor C d)
    (hgenus : ∀ (κ : Type u) [Field κ] [Algebra k κ],
      genus (Scheme.baseChangeField C κ) = g) :
    UniformVanishing C := by
  refine ⟨d + (g : ℤ), fun κ _ _ => ?_⟩
  letI : (Scheme.baseChangeField C κ).left.Over (Spec (CommRingCat.of κ)) :=
    .ofHom (Scheme.baseChangeField C κ).hom
  haveI : SmoothOfRelativeDimension 1
      ((Scheme.baseChangeField C κ).left ↘ Spec (CommRingCat.of κ)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 (Scheme.baseChangeField C κ).hom)
  intro D hD
  obtain ⟨D₀, hvan, hdeg⟩ := hbase κ
  have hchi : Sheaf.chi ((Scheme.baseChangeField C κ).left.moduleKSheaf κ) = 1 - (g : ℤ) := by
    rw [chi_moduleKSheaf_baseChangeField C κ, hgenus κ]
  refine subsingleton_hModule_one_of_deg_ge κ hvan D ?_
  rw [hchi]
  omega

/-! ### Non-vacuity: the degree half-space is never empty

A `∀ D, b ≤ deg D → …` statement is worth nothing if no divisor ever reaches degree `b`; it would
then be true for large `b` by having no instances, and `UniformVanishing` would be trivially
satisfiable.  This rules that out: one closed point of positive residue degree makes `deg`
unbounded above, so every degree half-space contains divisors.

The hypothesis is the honest one — `residueDeg` positivity at a single point — rather than a
claim that AJC witnesses it at the challenge curve, which is a separate question and is not
asserted here. -/