---
author: sync
content_type: lemma
created: '2026-07-27T01:04:30'
decl: CategoryTheory.Over.sigmaExtensionNat_app_fst
file: AlgebraicJacobian/Picard/Pic0AtlasFromDivRep.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Over.sigmaExtensionNat_app_fst
type: lean
updated: '2026-08-01T09:44:15'
---
lemma sigmaExtensionNat_app_fst (φ : F ⟶ G) (T : Cᵒᵖ) (x : (sigmaExtension S F).obj T) :
    ((sigmaExtensionNat φ).app T x).1 = x.1 :=
  rfl

end Over

namespace Functor.RepresentableBy

open Over

variable {C : Type u} [Category.{v} C] {S : C} {F : (Over S)ᵒᵖ ⥤ Type v}