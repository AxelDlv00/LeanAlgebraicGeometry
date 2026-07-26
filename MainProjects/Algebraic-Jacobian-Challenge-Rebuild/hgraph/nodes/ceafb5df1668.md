---
author: sync
content_type: definition
created: '2026-07-27T01:04:30'
decl: CategoryTheory.Over.sigmaExtensionNat
docstring: '**The Σ-extension is functorial in the extended presheaf**: a natural
  transformation of

  presheaves on the slice induces one of their Σ-extensions, acting as the identity
  on the

  structure-morphism component.'
file: AlgebraicJacobian/Picard/Pic0AtlasFromDivRep.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Over.sigmaExtensionNat
type: lean
updated: '2026-07-27T01:04:30'
---
def sigmaExtensionNat (φ : F ⟶ G) : sigmaExtension S F ⟶ sigmaExtension S G where
  app T := TypeCat.ofHom fun x => ⟨x.1, φ.app _ x.2⟩
  naturality T T' g := by
    refine ConcreteCategory.hom_ext _ _ fun x => ?_
    obtain ⟨a, ξ⟩ := x
    exact congrArg (Sigma.mk (g.unop ≫ a))
      (ConcreteCategory.congr_hom (φ.naturality (Over.homMk g.unop rfl :
        Over.mk (g.unop ≫ a) ⟶ Over.mk a).op) ξ)

@[simp]