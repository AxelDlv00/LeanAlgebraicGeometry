---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Hom.fiberSectionsModule
docstring: 'The `κ(s)`-module structure on the global sections of a sheaf of modules

  `G` on the fibre `X_s = π.fiber s`: restriction of scalars along the

  structural ring homomorphism `κ(s) →+* Γ(X_s, 𝒪)`

  (`Scheme.Hom.fiberResidueMap`).  Not an instance (the fibre presentation of

  the scheme is not canonical); brought into scope with `letI` at use sites.'
file: AlgebraicJacobian/Picard/HilbertPolynomial.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Hom.fiberSectionsModule
type: lean
updated: '2026-07-24T03:02:11'
---
@[reducible] noncomputable def Hom.fiberSectionsModule (π : X ⟶ S) (s : S)
    (G : (π.fiber s).Modules) :
    Module (S.residueField s) Γ(G, ⊤) :=
  Module.compHom Γ(G, ⊤) (π.fiberResidueMap s).hom