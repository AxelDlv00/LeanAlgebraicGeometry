---
author: sync
content_type: theorem
created: '2026-07-28T14:44:52'
decl: AlgebraicGeometry.exists_splitting_of_picEt
docstring: '**The splitting theorem in the `picEt` spelling** — the form every consumer
  of

  `IsSplitWitness` meets, since the split predicate is stated on

  `PicEtAff.map C L (picEtAffineEquiv C K μ)`.  Immediate from

  `exists_splitting_of_picEtAff` at `a := picEtAffineEquiv C K μ`; kept separate so
  that the

  heavy elaboration of the previous theorem is not re-run through the affine comparison.'
file: AlgebraicJacobian/Picard/Pic0ChartSplit.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.exists_splitting_of_picEt
type: lean
updated: '2026-07-30T15:28:04'
---
theorem exists_splitting_of_picEt {K : Type u} [Field K] [Algebra k K]
    (μ : picEt C (overSpec k K)) :
    ∃ (L : Type u) (_ : Field L) (_ : Algebra k L) (_ : Algebra K L)
        (_ : IsScalarTower k K L) (_ : Module.Finite K L) (_ : Algebra.IsSeparable K L)
        (M : ((C ⊗ overSpec k L).left).CechPic),
      PicEtAff.map C L (picEtAffineEquiv C K μ)
        = PicEtAff.unit C L (relPicMk C (overSpec k L) M) :=
  exists_splitting_of_picEtAff C (picEtAffineEquiv C K μ)

/-! ## The two readings of `IsSplitWitness` -/

variable (C) in