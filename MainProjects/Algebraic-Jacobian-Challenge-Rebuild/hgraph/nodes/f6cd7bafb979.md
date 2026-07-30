---
author: sync
content_type: lemma
created: '2026-07-24T17:02:48'
decl: AlgebraicGeometry.Over.faceA₁₃_algebraMap
docstring: Elementwise form of the Layer-I face compatibility `faceA₁₃_comp_tensorMap`.
file: AlgebraicJacobian/Picard/WitnessTransport.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.Over.faceA₁₃_algebraMap
type: lean
updated: '2026-07-30T15:28:06'
---
private lemma faceA₁₃_algebraMap (i j l : P.ι) (w : B ⊗[A] B) :
    letI := IsLocalization.Away.tensorAwayAlgebra A B B Γ(XB, (XB).basicOpen (P.r j))
      Γ(XB, (XB).basicOpen (P.r l))
    letI := IsLocalization.Away.tensorAwayAlgebra A B B Γ(XB, (XB).basicOpen (P.r i))
      Γ(XB, (XB).basicOpen (P.r l))
    letI := IsLocalization.Away.tensorAwayAlgebra A B (B ⊗[A] B) Γ(XB, (XB).basicOpen (P.r i))
      (Γ(XB, (XB).basicOpen (P.r j)) ⊗[A] Γ(XB, (XB).basicOpen (P.r l)))
    Algebra.TensorProduct.faceA₁₃ A (fun i' => Γ(XB, (XB).basicOpen (P.r i'))) i j l
        (algebraMap (B ⊗[A] B)
          (Γ(XB, (XB).basicOpen (P.r i)) ⊗[A] Γ(XB, (XB).basicOpen (P.r l))) w)
      = algebraMap (B ⊗[A] (B ⊗[A] B))
          (Γ(XB, (XB).basicOpen (P.r i))
            ⊗[A] (Γ(XB, (XB).basicOpen (P.r j)) ⊗[A] Γ(XB, (XB).basicOpen (P.r l))))
          (Module.descentFace₁₃ A B w) := by
  letI := IsLocalization.Away.tensorAwayAlgebra A B B Γ(XB, (XB).basicOpen (P.r j))
    Γ(XB, (XB).basicOpen (P.r l))
  exact DFunLike.congr_fun (IsLocalization.AwayCover.faceA₁₃_comp_tensorMap
    (A := A) B (fun i' => Γ(XB, (XB).basicOpen (P.r i'))) i j l) w