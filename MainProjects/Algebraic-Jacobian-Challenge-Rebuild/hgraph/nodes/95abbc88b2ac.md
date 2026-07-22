---
author: sync
content_type: lemma
created: '2026-07-18T20:01:12'
decl: AlgebraicGeometry.Scheme.germAlgHom_apply
file: AlgebraicJacobian/RiemannRoch/StalkColength.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.germAlgHom_apply
type: lean
updated: '2026-07-18T20:01:12'
---
lemma Scheme.germAlgHom_apply {V : X.Opens} {z : X} (hz : z ∈ V) (s : Γ(X, V)) :
    Scheme.germAlgHom K hz s = (X.presheaf.germ V z hz).hom s :=
  rfl