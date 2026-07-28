---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.GroupScheme.identityComponentFactor_range
docstring: Range hypothesis for the `IsOpenImmersion.lift` factorisation below.
file: AlgebraicJacobian/Picard/IdentityComponent.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.GroupScheme.identityComponentFactor_range
type: lean
updated: '2026-07-28T13:22:16'
---
private lemma identityComponentFactor_range {T : Over (Spec (.of k))} (f : T ⟶ G)
    (hf : Set.range ⇑f.left ⊆ (identityComponentCarrier G : Set G.left)) :
    Set.range ⇑f.left ⊆ Set.range ⇑(identityComponentCarrier G).ι := by
  rw [Scheme.Opens.range_ι]; exact hf