---
author: sync
content_type: definition
created: '2026-08-14T14:17:16'
decl: AlgebraicGeometry.sigmaExtensionIso
docstring: Sigma extension preserves natural isomorphisms of slice presheaves.
file: AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.sigmaExtensionIso
type: lean
updated: '2026-08-14T14:17:16'
---
noncomputable def sigmaExtensionIso {F G : (Over (Spec (.of k)))ᵒᵖ ⥤ Type u}
    (e : F ≅ G) :
    Over.sigmaExtension (Spec (.of k)) F ≅
      Over.sigmaExtension (Spec (.of k)) G where
  hom := Over.sigmaExtensionNat e.hom
  inv := Over.sigmaExtensionNat e.inv
  hom_inv_id := by
    ext T x
    rcases x with ⟨a, x⟩
    exact congrArg (Sigma.mk a) (e.hom_inv_id_app_apply _ x)
  inv_hom_id := by
    ext T x
    rcases x with ⟨a, x⟩
    exact congrArg (Sigma.mk a) (e.inv_hom_id_app_apply _ x)