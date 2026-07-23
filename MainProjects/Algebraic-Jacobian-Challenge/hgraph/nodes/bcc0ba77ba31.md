---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.overForgetIso
docstring: 'The forgetful functor `Over D(g) ⥤ Opens (Spec R)` agrees (via the open-immersion
  image–preimage

  identity `ι ''''ᵁ (ι ⁻¹ᵁ V) = V` for `V ≤ D(g)`) with the over-site equivalence
  followed by the

  open-immersion `opensFunctor`. In the thin `Opens` category naturality is automatic.
  Project-local:

  the geometric datum underlying the Route B restrict–over bridge (B3a).'
file: AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.overForgetIso
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def overForgetIso (g : R) :
    Over.forget (specBasicOpen g) ≅
      (Opens.overEquivalence (specBasicOpen g)).functor ⋙ (specBasicOpen g).ι.opensFunctor :=
  NatIso.ofComponents
    (fun V => eqToIso (specBasicOpen_ι_image_overEquivalence_functor g V).symm)
    (fun {_ _} _ => Subsingleton.elim _ _)