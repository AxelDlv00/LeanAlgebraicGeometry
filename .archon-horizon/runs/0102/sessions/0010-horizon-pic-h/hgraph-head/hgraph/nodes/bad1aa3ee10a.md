---
author: sync
content_type: lemma
created: '2026-08-01T10:43:32'
decl: AlgebraicGeometry.pic0DescentHom_comp_all
docstring: 'The tensor-overlap comparison satisfies the chosen-pullback cocycle for

  the whole singleton cover family.'
file: AlgebraicJacobian/Picard/Pic0RepresentabilityDescentData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0DescentHom_comp_all
type: lean
updated: '2026-08-01T10:43:32'
---
lemma pic0DescentHom_comp_all
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J) :
    ∀ i₁ i₂ i₃,
      Pseudofunctor.DescentData'.pullHom'
          (F := Over.pullbackPseudofunctor (C := Scheme.{u}))
          (f := pic0DescentCoverMap (k := k) (L := L))
          (sq := pic0DescentPullback (k := k) (L := L))
          (pic0DescentHom (C := C) rep)
          (pic0DescentPullback₃ (k := k) (L := L) i₁ i₂ i₃).p
          (pic0DescentPullback₃ (k := k) (L := L) i₁ i₂ i₃).p₁
          (pic0DescentPullback₃ (k := k) (L := L) i₁ i₂ i₃).p₂
          (by
            rw [pic0DescentPullback₃_p]
            exact tensorTripleCoord1_comp_base) (by
            rw [pic0DescentPullback₃_p]
            exact tensorTripleCoord2_comp_base) ≫
        Pseudofunctor.DescentData'.pullHom'
          (F := Over.pullbackPseudofunctor (C := Scheme.{u}))
          (f := pic0DescentCoverMap (k := k) (L := L))
          (sq := pic0DescentPullback (k := k) (L := L))
          (pic0DescentHom (C := C) rep)
          (pic0DescentPullback₃ (k := k) (L := L) i₁ i₂ i₃).p
          (pic0DescentPullback₃ (k := k) (L := L) i₁ i₂ i₃).p₂
          (pic0DescentPullback₃ (k := k) (L := L) i₁ i₂ i₃).p₃
          (by
            rw [pic0DescentPullback₃_p]
            exact tensorTripleCoord2_comp_base) (by
            rw [pic0DescentPullback₃_p]
            exact tensorTripleCoord3_comp_base) =
        Pseudofunctor.DescentData'.pullHom'
          (F := Over.pullbackPseudofunctor (C := Scheme.{u}))
          (f := pic0DescentCoverMap (k := k) (L := L))
          (sq := pic0DescentPullback (k := k) (L := L))
          (pic0DescentHom (C := C) rep)
          (pic0DescentPullback₃ (k := k) (L := L) i₁ i₂ i₃).p
          (pic0DescentPullback₃ (k := k) (L := L) i₁ i₂ i₃).p₁
          (pic0DescentPullback₃ (k := k) (L := L) i₁ i₂ i₃).p₃
          (by
            rw [pic0DescentPullback₃_p]
            exact tensorTripleCoord1_comp_base) (by
            rw [pic0DescentPullback₃_p]
            exact tensorTripleCoord3_comp_base) := by
  rintro ⟨⟩ ⟨⟩ ⟨⟩
  apply eq_of_heq
  exact heq_of_eq (pic0DescentHom_comp (C := C) rep)