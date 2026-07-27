---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.GroupScheme.geometricallyConnected_of_connected_of_section
docstring: '**Stacks 04KV / EGA IV₂ 4.5.14**: a connected `k`-scheme with a `k`-rational

  section is geometrically connected.


  Given a morphism `f : X ⟶ Spec k` from a `ConnectedSpace`-typed scheme `X`

  admitting a section `s : Spec k ⟶ X` (i.e. `s ≫ f = 𝟙`), the morphism `f` is

  geometrically connected: for any field extension `K/k`, the pullback

  `X ×_{Spec k} Spec K` is connected.


  The Stacks 04KV/037Q descent substrate lives in the sibling module

  `Picard/GeometricallyConnectedSection.lean` (tensor products of field

  extensions over an algebraically closed field are domains, together with the

  open/closed/singleton-fibre clopen descent argument); this lemma is a direct

  application of it.'
file: AlgebraicJacobian/Picard/IdentityComponent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GroupScheme.geometricallyConnected_of_connected_of_section
type: lean
updated: '2026-07-27T12:33:55'
---
private theorem geometricallyConnected_of_connected_of_section
    {k : Type u} [Field k] {X : Scheme.{u}}
    (f : X ⟶ Spec (.of k))
    (s : Spec (.of k) ⟶ X) (hsf : s ≫ f = 𝟙 _)
    [ConnectedSpace X] :
    GeometricallyConnected f :=
  geometricallyConnected_of_connectedSpace_of_section f s hsf