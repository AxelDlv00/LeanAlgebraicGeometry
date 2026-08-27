---
author: sync
content_type: theorem
created: '2026-08-28T04:39:22'
decl: StacksPart05Lib.categorical_quotient_epi
docstring: "Two categorical quotients of the same parallel pair are uniquely\nisomorphic\
  \ over the quotient map. -/\ntheorem categorical_quotient_unique_up_to_unique_iso\n\
  \    {C : Type u} [Category.{v} C] {R U X Y : C}\n    {s t : R ⟶ U} {φ : U ⟶ X}\
  \ {ψ : U ⟶ Y}\n    (hφ : CategoricalQuotient s t φ)\n    (hψ : CategoricalQuotient\
  \ s t ψ) :\n    ∃ e : X ≅ Y, φ ≫ e.hom = ψ ∧\n      ∀ e' : X ≅ Y, φ ≫ e'.hom = ψ\
  \ → e' = e := by\n  obtain ⟨e, he, he_unique⟩ := hφ.2 ψ hψ.1\n  obtain ⟨d, hd, hd_unique⟩\
  \ := hψ.2 φ hφ.1\n  obtain ⟨a, ha, ha_unique⟩ := hφ.2 φ hφ.1\n  obtain ⟨b, hb, hb_unique⟩\
  \ := hψ.2 ψ hψ.1\n  have hed : e ≫ d = \U0001D7D9 X := by\n    have hcomp : φ ≫\
  \ (e ≫ d) = φ := by rw [← Category.assoc, he, hd]\n    have hident : φ ≫ \U0001D7D9\
  \ X = φ := Category.comp_id φ\n    exact (ha_unique (e ≫ d) hcomp).trans (ha_unique\
  \ (\U0001D7D9 X) hident).symm\n  have hde : d ≫ e = \U0001D7D9 Y := by\n    have\
  \ hcomp : ψ ≫ (d ≫ e) = ψ := by rw [← Category.assoc, hd, he]\n    have hident :\
  \ ψ ≫ \U0001D7D9 Y = ψ := Category.comp_id ψ\n    exact (hb_unique (d ≫ e) hcomp).trans\
  \ (hb_unique (\U0001D7D9 Y) hident).symm\n  let i : X ≅ Y := { hom := e, inv :=\
  \ d, hom_inv_id := hed, inv_hom_id := hde }\n  refine ⟨i, he, ?_⟩\n  intro e' he'\n\
  \  apply Iso.ext\n  exact he_unique e'.hom he'\n\n/-! A categorical quotient map\
  \ is an epimorphism: its universal property\nforces any two maps out of the quotient\
  \ that agree after precomposition to\ncoincide."
file: StacksPart05Lib/Groupoids.lean
generated: lean
lean_status: lean_ok
title: StacksPart05Lib.categorical_quotient_epi
type: lean
updated: '2026-08-28T04:39:22'
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