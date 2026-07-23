---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.ProjTwist.pushforward_map_scalarEnd_appTop
docstring: 'The pushforward of a scalar automorphism `scalarEnd a` acts on global
  sections

  (through the definitional `Γ(E_* 𝒪, ⊤) = Γ(𝒪, ⊤)`) as multiplication by `a`.'
file: AlgebraicJacobian/Picard/SerreTwistSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjTwist.pushforward_map_scalarEnd_appTop
type: lean
updated: '2026-07-16T21:14:28'
---
lemma pushforward_map_scalarEnd_appTop {W V : Scheme.{0}} (E : W ⟶ V) (a w : Γ(W, ⊤)) :
    ((Scheme.Modules.pushforward E).map (scalarEnd a)).app ⊤ w = w * a := by
  rw [Scheme.Modules.pushforward_map_app]
  change (scalarEnd a).val.app (Opposite.op (E ⁻¹ᵁ ⊤)) w = _
  rw [scalarEnd_val_app]
  congr 1
  rw [show (homOfLE (le_top : (E ⁻¹ᵁ ⊤) ≤ ⊤)).op = 𝟙 (Opposite.op (⊤ : W.Opens)) from
      Subsingleton.elim _ _]
  exact ConcreteCategory.congr_hom (W.ringCatSheaf.obj.map_id _) a