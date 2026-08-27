---
author: sync
content_type: theorem
created: '2026-08-28T04:39:22'
decl: StacksPart05Lib.categorical_quotient_epi
docstring: 'A categorical quotient map is an epimorphism: its universal property

  forces any two maps out of the quotient that agree after precomposition to

  coincide.'
file: StacksPart05Lib/Groupoids.lean
generated: lean
lean_status: lean_ok
title: StacksPart05Lib.categorical_quotient_epi
type: lean
updated: '2026-08-28T04:43:58'
---
theorem categorical_quotient_epi
    {C : Type u} [Category.{v} C] {R U X : C}
    {s t : R ⟶ U} {φ : U ⟶ X}
    (hφ : CategoricalQuotient s t φ) : Epi φ := by
  constructor
  intro Y f g hfg
  have hinvf : s ≫ (φ ≫ f) = t ≫ (φ ≫ f) := by
    simpa only [Category.assoc] using congrArg (fun k => k ≫ f) hφ.1
  obtain ⟨χ, hχ, hχ_unique⟩ := hφ.2 (φ ≫ f) hinvf
  exact (hχ_unique f rfl).trans (hχ_unique g hfg.symm).symm