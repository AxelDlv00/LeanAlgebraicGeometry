---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.GradedModule.SubquotientDatum.coker
docstring: '**Cokernel constructor.** From a length-`(r+1)` subquotient datum, the
  cokernel subquotient

  `(N, N'' ⊔ x·N)` of multiplication by `x = t (last)`, as a length-`r` datum on `t
  ∘ castSucc`.'
file: AlgebraicJacobian/Picard/GradedHilbertSerre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GradedModule.SubquotientDatum.coker
type: lean
updated: '2026-07-27T12:05:12'
---
noncomputable def SubquotientDatum.coker {r : ℕ} (D : SubquotientDatum ℳ (r + 1)) :
    SubquotientDatum ℳ r where
  N := D.N
  N' := D.N' ⊔ D.N.map (D.t (Fin.last r))
  hle := coker_le D.hle (D.hpresN (Fin.last r))
  hN := D.hN
  hN' := coker_isHomogeneous ℳ (D.hraise (Fin.last r)) D.hN D.hN'
  t := fun i => D.t (Fin.castSucc i)
  hcomm := fun _ _ => D.hcomm _ _
  hraise := fun _ => D.hraise _
  hpresN := fun _ => D.hpresN _
  hpresN' := fun i => coker_stable_full ℳ D (Fin.castSucc i)
  hfin :=
    subquotient_finite_transfer D.t D.hcomm D.hpresN (coker_stable_full ℳ D)
      coker_annihilate
      (polyQuot_finite_of_le_denominator D.t D.hcomm D.hpresN D.hpresN' (coker_stable_full ℳ D)
        le_sup_left D.hfin)