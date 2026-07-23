---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.AffineCoverMVSquare.ker_cechD12_
docstring: '**Cocycles satisfy `r = −q`** (the `x = (0,1,0)` component of the cocycle

  condition, after canonicalising the three coface restrictions and using the vanishing

  of the `(0,0)`-component).'
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineCoverMVSquare.ker_cechD12_
type: lean
updated: '2026-07-23T23:40:42'
---
lemma AffineCoverMVSquare.ker_cechD12_π_off_diag
    (h10 : (∏ᶜ ((FormalCoproduct.mk _ S.coverFamily).obj ∘ ![⟨0⟩, ⟨1⟩, ⟨0⟩])
        : TopologicalSpace.Opens C.left.toTopCat)
      ≤ ∏ᶜ ((FormalCoproduct.mk _ S.coverFamily).obj ∘ ![⟨1⟩, ⟨0⟩]))
    (h01 : (∏ᶜ ((FormalCoproduct.mk _ S.coverFamily).obj ∘ ![⟨0⟩, ⟨1⟩, ⟨0⟩])
        : TopologicalSpace.Opens C.left.toTopCat)
      ≤ ∏ᶜ ((FormalCoproduct.mk _ S.coverFamily).obj ∘ ![⟨0⟩, ⟨1⟩])) :
    ModuleCat.ofHom (LinearMap.ker (cechD12 S.coverFamily F).hom).subtype
        ≫ Pi.π (cechTerm S.coverFamily F 2) ![⟨1⟩, ⟨0⟩] ≫ F.obj.map (homOfLE h10).op
      = -(ModuleCat.ofHom (LinearMap.ker (cechD12 S.coverFamily F).hom).subtype
        ≫ Pi.π (cechTerm S.coverFamily F 2) ![⟨0⟩, ⟨1⟩] ≫ F.obj.map (homOfLE h01).op) := by
  have hcan00 : (∏ᶜ ((FormalCoproduct.mk _ S.coverFamily).obj ∘ ![⟨0⟩, ⟨1⟩, ⟨0⟩])
        : TopologicalSpace.Opens C.left.toTopCat)
      ≤ ∏ᶜ ((FormalCoproduct.mk _ S.coverFamily).obj ∘ ![⟨0⟩, ⟨0⟩]) :=
    prodOpens_le_of_forall_exists (j := ![⟨0⟩, ⟨0⟩]) (x := ![⟨0⟩, ⟨1⟩, ⟨0⟩])
      S.coverFamily (by decide)
  have h := congrArg (· ≫ Pi.π (cechTerm S.coverFamily F 3) ![⟨0⟩, ⟨1⟩, ⟨0⟩])
    (S.kerSubtype_comp_cechD12 F)
  simp only [Category.assoc, cechD12_π, zero_comp, Preadditive.comp_add,
    Preadditive.comp_sub] at h
  rw [pi_π_restrict_congr S.coverFamily F
      (show (![⟨0⟩, ⟨1⟩, ⟨0⟩] ∘ ⇑(Fin.succAboveOrderEmb 0) : Fin 2 → ULift.{u} (Fin 2))
          = ![⟨1⟩, ⟨0⟩] from by funext i; fin_cases i <;> rfl) _ h10,
    pi_π_restrict_congr S.coverFamily F
      (show (![⟨0⟩, ⟨1⟩, ⟨0⟩] ∘ ⇑(Fin.succAboveOrderEmb 1) : Fin 2 → ULift.{u} (Fin 2))
          = ![⟨0⟩, ⟨0⟩] from by funext i; fin_cases i <;> rfl) _ hcan00,
    pi_π_restrict_congr S.coverFamily F
      (show (![⟨0⟩, ⟨1⟩, ⟨0⟩] ∘ ⇑(Fin.succAboveOrderEmb 2) : Fin 2 → ULift.{u} (Fin 2))
          = ![⟨0⟩, ⟨1⟩] from by funext i; fin_cases i <;> rfl) _ h01] at h
  have hz : ModuleCat.ofHom (LinearMap.ker (cechD12 S.coverFamily F).hom).subtype
      ≫ Pi.π (cechTerm S.coverFamily F 2) ![⟨0⟩, ⟨0⟩] ≫ F.obj.map (homOfLE hcan00).op
      = 0 := by
    rw [← Category.assoc, S.ker_cechD12_π_diag_zero₀ F, zero_comp]
  rw [hz, sub_zero] at h
  exact eq_neg_of_add_eq_zero_left h