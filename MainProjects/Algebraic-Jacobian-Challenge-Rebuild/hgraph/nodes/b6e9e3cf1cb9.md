---
author: sync
content_type: lemma
created: '2026-07-19T14:01:14'
decl: AlgebraicGeometry.thetaFieldRead_eq_germ_snd
docstring: '**The reading is a germ at `η`, chart-1 case** (mirror).'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivAssemble.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.thetaFieldRead_eq_germ_snd
type: lean
updated: '2026-07-31T20:15:22'
---
lemma thetaFieldRead_eq_germ_snd
    (hη : genericPoint (relCurve C K) ∉ (relCover C K (fiberTwoCover π)).V₀)
    (s : relThetaSections C K π a) :
    thetaFieldRead C K π a s
      = ((relCurve C K).presheaf.germ (⊤ ⊓ (relCover C K (fiberTwoCover π)).V₁)
          (genericPoint (relCurve C K))
          ⟨trivial, mem_V₁_of_notMem_V₀ C K π hη⟩).hom s.val.2 := by
  rw [thetaFieldRead_apply,
    Scheme.MeromorphicPresentation.gluedVal_eq_elem_inv_mul K
      (thetaFieldPresentation C K π a) (genericPoint (relCurve C K)) (W := ⊤) trivial
      (thetaFieldGluedEquiv C K π a s),
    thetaFieldPresentation_elem_genericPoint, inv_one, Units.val_one, one_mul]
  exact germ_thetaFieldGluedEquiv_snd C K π a s hη
    ⟨trivial, (thetaFieldPointedCover C K π).mem_opens _⟩
    ⟨trivial, mem_V₁_of_notMem_V₀ C K π hη⟩

end Reading

/-! ## The read multiplicativity across the ledger exponents -/

section ReadMul

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable (K : Type u) [Field K] [Algebra k K]
variable (π : C.left ⟶ P1 k) [IsFinite π]

noncomputable local instance instOverCleftAssemble : C.left.Over (Spec (.of k)) :=
  ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))] [QuasiCompact (C.left ↘ Spec (.of k))]
  [IsDominant π]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)) (g : ℕ)
variable [IsIntegral (relCurve C K)]
  [SmoothOfRelativeDimension 1 (relCurve C K ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (relCurve C K ↘ Spec (CommRingCat.of K))]