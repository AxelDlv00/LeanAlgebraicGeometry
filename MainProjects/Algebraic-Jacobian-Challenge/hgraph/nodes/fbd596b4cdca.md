---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.GradedModule.subquotient_hilbertSeries_rational
docstring: '**The ambient subquotient induction (Stacks 00K1).** The ambient Hilbert
  function of a

  length-`r` subquotient datum is a rational Hilbert function of order `r`

  (`lem:graded_subquotient_isRatHilb`). Induction on `r`: the base case is the eventually-zero

  function; the step feeds the kernel/cokernel data (`SubquotientDatum.ker`, `.coker`)
  and the

  degreewise difference identity into `IsRatHilb.ofDiffEq`.'
file: AlgebraicJacobian/Picard/GradedHilbertSerre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GradedModule.subquotient_hilbertSeries_rational
type: lean
updated: '2026-07-24T03:02:10'
---
lemma subquotient_hilbertSeries_rational :
    ∀ {r : ℕ} (D : SubquotientDatum ℳ r), IsRatHilb (SubquotientDatum.hilb ℳ D) r := by
  intro r
  induction r with
  | zero =>
      intro D
      obtain ⟨K, hK⟩ := subquotient_base_eventuallyZero ℳ D
      exact IsRatHilb.ofEventuallyZero K hK
  | succ r ih =>
      intro D
      have hx : RaisesDegree ℳ (D.t (Fin.last r)) := D.hraise _
      refine IsRatHilb.ofDiffEq (N := 0) (ih (SubquotientDatum.coker ℳ D))
        (ih (SubquotientDatum.ker ℳ D)) ?_
      intro n _
      change subquotientHilb ℳ D.N D.N' (n + 1) - subquotientHilb ℳ D.N D.N' n
        = subquotientHilb ℳ D.N (D.N' ⊔ D.N.map (D.t (Fin.last r))) (n + 1)
          - subquotientHilb ℳ (D.N ⊓ (D.N').comap (D.t (Fin.last r))) D.N' n
      exact subquotient_degreewise_diff ℳ hx D.hN D.hN' n