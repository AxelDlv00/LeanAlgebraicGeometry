---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.AffineCoverMVSquare.surjective_moduleSectionDiff_of_iso
docstring: '**Surjectivity of the Čech difference map transports across an

  isomorphism of module sheaves.**'
file: AlgebraicJacobian/Picard/RigidPushforwardTransfer.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.AffineCoverMVSquare.surjective_moduleSectionDiff_of_iso
type: lean
updated: '2026-07-24T03:02:11'
---
lemma AffineCoverMVSquare.surjective_moduleSectionDiff_of_iso {X : Scheme.{u}}
    (V : X.AffineCoverMVSquare) {G G' : X.Modules} (e : G ≅ G')
    (h : Function.Surjective ⇑(V.moduleSectionDiff G)) :
    Function.Surjective ⇑(V.moduleSectionDiff G') := by
  intro c
  obtain ⟨⟨a, b⟩, hab⟩ := h (e.inv.app (V.U₁ ⊓ V.U₂) c)
  refine ⟨(e.hom.app V.U₁ a, e.hom.app V.U₂ b), ?_⟩
  rw [V.moduleSectionDiff_naturality e.hom a b, hab]
  change ((e.inv ≫ e.hom).app (V.U₁ ⊓ V.U₂)).hom c = c
  rw [e.inv_hom_id]
  rfl

end Scheme

namespace Adelic

open Scheme

variable {k : Type u} [Field k]
variable (A : Type u) [CommRing A] [Algebra k A]
variable (C : Over (Spec (CommRingCat.of k)))