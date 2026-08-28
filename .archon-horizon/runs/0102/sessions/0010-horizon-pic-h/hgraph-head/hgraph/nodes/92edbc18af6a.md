---
author: sync
content_type: theorem
created: '2026-07-30T09:57:51'
decl: AlgebraicGeometry.mem_chartLocus_of_ledgerIndex_of_isDegree_genus
docstring: '**THE ENDPOINT: coverage at the ledger parameter from the GENUS alone.**


  `mem_chartLocus_of_ledgerIndex_of_isDegree` asks for `IsDivisorDegree C (M·δ + g)`,
  a condition

  mentioning two ledger constants.  `isDegree_ledger_add_iff` says that is the same
  condition as

  `IsDivisorDegree C g`, so the ledger constants can be dropped from the interface
  entirely.


  This is the honest headline of the whole `param-admissible` line of work: **coverage''s
  locus

  membership at the ledger parameter follows from one arithmetic fact about the curve
  — that its

  genus is a divisor degree — plus the splitting data coverage already has.**  Nothing
  about charts,

  certificates, θ-classes or representability remains in the hypothesis.


  It does **not** discharge antecedent 2, and none of the three seam antecedents moves:
  this is

  locus membership at a point, and `Pic0ChartCoverageSlice.lean` records that the
  pointwise datum

  coverage needs also wants a chart *point over a neighbourhood* — a spreading-out
  absent for this

  carrier.  Nor is `IsDivisorDegree C g` known to hold; see the module docstring.'
file: AlgebraicJacobian/Picard/Pic0ChartIndexLedgerFeed.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.mem_chartLocus_of_ledgerIndex_of_isDegree_genus
type: lean
updated: '2026-08-01T09:44:15'
---
theorem mem_chartLocus_of_ledgerIndex_of_isDegree_genus
    {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k)) (g : ℕ)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (hg : IsDivisorDegree C (g : ℤ))
    {T : Over (Spec (.of k))} (lam : picEt C T) (t : T.left)
    (hlam : degAt lam (Over.testPoint t) = 0)
    {L : Type u} [Field L] [Algebra k L] [Algebra (Over.testPointField t) L]
    [IsScalarTower k (Over.testPointField t) L]
    [Module.Finite (Over.testPointField t) L]
    [Algebra.IsSeparable (Over.testPointField t) L]
    (M₀ : (C ⊗ overSpec k L).left.CechPic)
    (hM₀ : PicEtAff.map C L
        (picEtAffineEquiv C (Over.testPointField t) (picEtMap C (Over.testPoint t) lam))
      = PicEtAff.unit C L (relPicMk C (overSpec k L) M₀))
    [IsIntegral (relCurve C L)]
    [SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L))]
    [QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L))]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0)]
    [Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1)] :
    ∃ (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor), t ∈ chartLocus C m Z lam :=
  mem_chartLocus_of_ledgerIndex_of_isDegree hπ g hχ
    ((isDegree_ledger_add_iff (windowM_choice π hπ g) (g : ℤ)).mpr hg) lam t hlam M₀ hM₀