---
author: sync
content_type: def
created: '2026-08-28T04:39:22'
decl: StacksPart05Lib.CategoricalQuotient
docstring: 'A categorical quotient equalizes a parallel pair and has the expected

  universal factorization property.  This is the abstract categorical core of

  the quotient definition in the source.'
file: StacksPart05Lib/Groupoids.lean
generated: lean
lean_status: lean_ok
title: StacksPart05Lib.CategoricalQuotient
type: lean
updated: '2026-08-28T04:39:22'
---
def CategoricalQuotient {C : Type u} [Category.{v} C]
    {R U X : C} (s t : R ⟶ U) (φ : U ⟶ X) : Prop :=
  s ≫ φ = t ≫ φ ∧
    ∀ {Y : C} (ψ : U ⟶ Y), s ≫ ψ = t ≫ ψ →
      ∃ χ : X ⟶ Y, φ ≫ χ = ψ ∧
        ∀ χ' : X ⟶ Y, φ ≫ χ' = ψ → χ' = χ