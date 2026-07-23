---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.GenericFreeness.GenericallyFree
docstring: 'The **generic-freeness property** of an `A`-module `M`: some localization

  `M_f` at a single non-zero `f ∈ A` is a free module over `A_f`. This is the

  conclusion shared by every statement of this section.'
file: AlgebraicJacobian/Picard/FlatteningStratification.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GenericFreeness.GenericallyFree
type: lean
updated: '2026-07-16T21:14:26'
---
def GenericallyFree (A : Type*) (M : Type*) [CommRing A] [AddCommGroup M]
    [Module A M] : Prop :=
  ∃ f : A, f ≠ 0 ∧
    Module.Free (Localization.Away f) (LocalizedModule (Submonoid.powers f) M)