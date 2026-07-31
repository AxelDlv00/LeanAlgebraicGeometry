---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.overSpecMap_comp
file: AlgebraicJacobian/Picard/RelPicAlgebra.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.overSpecMap_comp
type: lean
updated: '2026-07-31T20:14:47'
---
lemma Over.overSpecMap_comp (f : A →ₐ[k] B) (g : B →ₐ[k] C') :
    Over.overSpecMap (g.comp f) = Over.overSpecMap g ≫ Over.overSpecMap f := by
  ext : 1
  exact spec_map_comp_alg f g

end OverSpecMap

section RelPicAlgMap

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable {A B C' : Type u} [CommRing A] [Algebra k A] [CommRing B] [Algebra k B]
  [CommRing C'] [Algebra k C']