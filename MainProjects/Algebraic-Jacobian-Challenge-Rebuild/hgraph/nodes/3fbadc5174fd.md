---
author: sync
content_type: theorem
created: '2026-07-28T19:44:57'
decl: AlgebraicGeometry.isSplitWitness_of_presenting_witness_self
docstring: '**The TRIVIAL splitting `L := K`** — the variant the predecessor record
  singled out as

  "worth wanting" and reported as unelaborable.


  At a field where the class is *already* honest, no extension is needed: a witness
  divisor over

  `K` itself certifies `IsSplitWitness`.  The record (I-0564) noted specifically that
  this one

  "fails for elaboration reasons, NOT because the mathematics is wrong".  The mathematics
  was

  indeed fine and the elaboration is fine too, once the existentials are staged —
  this is a

  one-line corollary of the theorem above, at `L := K` with the identity instances.


  Why it matters beyond closing a record: this is the **reverse half of

  `IsChartDatumPresentation`**, the one residue CHART-U(b) still carries.  The forward
  half needs

  a presenting datum''s fibre predicate to imply the split predicate; that direction
  is the one

  this supplies, since a datum over the base gives an honest class at the fibre field
  with no

  extension to find.'
file: AlgebraicJacobian/Picard/Pic0ChartTwistSplit.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.isSplitWitness_of_presenting_witness_self
type: lean
updated: '2026-07-29T15:26:17'
---
theorem isSplitWitness_of_presenting_witness_self
    {K : Type u} [Field K] [Algebra k K] (ν : picEt C (overSpec k K))
    (M : (relCurve C K).CechPic)
    (hM : PicEtAff.map C K (picEtAffineEquiv C K ν)
      = PicEtAff.unit C K (relPicMk C (overSpec k K) M))
    (W : ((C ⊗ overSpec k K).left).CurveDivisor)
    (hW : Scheme.CurveDivisor.picClass K W = M)
    (hW1 : Subsingleton (Sheaf.HModule ((C ⊗ overSpec k K).left.divisorSheaf K W) 1)) :
    IsSplitWitness C ν :=
  isSplitWitness_of_presenting_witness C ν M hM W hW hW1

variable (C) in