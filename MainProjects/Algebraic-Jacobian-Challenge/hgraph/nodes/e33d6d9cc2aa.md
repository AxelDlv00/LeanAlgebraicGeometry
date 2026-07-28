---
author: sync
content_type: theorem
created: '2026-07-28T22:30:24'
decl: AlgebraicGeometry.leakProbe_isIso_app_pi
file: scripts/axiom-frontier.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.leakProbe_isIso_app_pi
type: lean
updated: '2026-07-28T22:30:24'
---
theorem leakProbe_isIso_app_pi {C D : Type*} [Category C] [Category D]
    {P Q : C ⥤ D} (α : P ⟶ Q) {J : Type*} [Finite J] (A : J → C)
    [Limits.HasProduct A] [Limits.HasProduct (fun j => P.obj (A j))]
    [Limits.HasProduct (fun j => Q.obj (A j))]
    [Limits.PreservesLimit (Discrete.functor A) P]
    [Limits.PreservesLimit (Discrete.functor A) Q]
    (h : ∀ j, IsIso (α.app (A j))) : IsIso (α.app (∏ᶜ A)) :=
  isIso_app_pi_of_isIso_app α A h