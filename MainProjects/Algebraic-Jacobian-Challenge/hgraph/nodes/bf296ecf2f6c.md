---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.sectionRestrict
docstring: 'The restriction `k`-linear map `Γ(V, F) →ₗ[k] Γ(U, F)` for an inclusion
  of opens

  `U ≤ V`, extracted from the underlying presheaf of the sheaf of `k`-modules `F`.'
file: AlgebraicJacobian/RiemannRoch/Adelic/Cokernel.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.sectionRestrict
type: lean
updated: '2026-07-16T21:14:28'
---
noncomputable def sectionRestrict {U V : TopologicalSpace.Opens X.toTopCat} (h : U ≤ V) :
    F.obj.obj (Opposite.op V) →ₗ[k] F.obj.obj (Opposite.op U) :=
  (F.obj.map (homOfLE h).op).hom