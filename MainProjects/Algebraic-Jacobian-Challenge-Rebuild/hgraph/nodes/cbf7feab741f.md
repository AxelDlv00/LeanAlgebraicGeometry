---
author: sync
content_type: lemma
created: '2026-08-01T09:44:16'
decl: AlgebraicGeometry.pic0DescentHom_self
file: AlgebraicJacobian/Picard/Pic0RepresentabilityDescentData.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.pic0DescentHom_self
type: lean
updated: '2026-08-01T10:43:34'
---
lemma pic0DescentHom_self
    (rep : (pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J) :
    ∀ i, Pseudofunctor.DescentData'.pullHom'
        (F := Over.pullbackPseudofunctor (C := Scheme.{u}))
        (f := pic0DescentCoverMap (k := k) (L := L))
        (sq := pic0DescentPullback (k := k) (L := L))
        (pic0DescentHom (C := C) rep)
        (pic0DescentCoverMap (k := k) (L := L) i)
        (𝟙 (pic0DescentCoverObj (L := L) i))
        (𝟙 (pic0DescentCoverObj (L := L) i)) = 𝟙 _ := by
  rintro ⟨⟩
  apply eq_of_heq
  exact heq_of_eq (Pseudofunctor.pullHom'_hom_self_of_comp
    (F := Over.pullbackPseudofunctor (C := Scheme.{u}))
    (ι := Unit)
    (S := Spec (.of k))
    (X := pic0DescentCoverObj (L := L))
    (f := pic0DescentCoverMap (k := k) (L := L))
    (sq := pic0DescentPullback (k := k) (L := L))
    (sq₃ := pic0DescentPullback₃ (k := k) (L := L))
    (obj := fun _ ↦ J)
    (hom := pic0DescentHom (C := C) rep)
    (pic0DescentHom_isIso (C := C) rep)
    (fun i₁ i₂ i₃ => by
      cases i₁
      cases i₂
      cases i₃
      apply eq_of_heq
      exact heq_of_eq (pic0DescentHom_comp (C := C) rep)) ())