---
author: sync
content_type: lemma
created: '2026-07-17T10:20:05'
decl: AlgebraicGeometry.selfDiag_base_eq_rowFst_base
docstring: 'The image of the point of `p` under the diagonal equals its image under
  the

  `rowFst` through `p` — both are "the pair `(p, p)`".'
file: AlgebraicJacobian/Albanese/Milne33Rows.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.selfDiag_base_eq_rowFst_base
type: lean
updated: '2026-07-29T15:26:19'
---
lemma selfDiag_base_eq_rowFst_base (s : ↥(Spec (.of kbar))) :
    (selfDiag X).base (p.base s) = (rowFst p hp).base (p.base s) := by
  have h : p ≫ selfDiag X = p ≫ rowFst p hp := by
    rw [comp_selfDiag p, comp_rowFst p p hp hp]
  calc (selfDiag X).base (p.base s) = ((p ≫ selfDiag X).base) s := rfl
    _ = ((p ≫ rowFst p hp).base) s := by rw [h]
    _ = (rowFst p hp).base (p.base s) := rfl

end PointCollision

/-! ## §3. The explicit representative of the difference map, and agreement -/

namespace Scheme.RationalMap

variable {X} {G : Over (Spec (.of kbar))}
  [Smooth X.hom] [GrpObj G] [LocallyOfFiniteType G.hom]