---
author: sync
chapter: 'Adelic Riemann--Roch: the repartition cokernel (RR.A)'
content_type: theorem
created: '2026-07-16T21:14:30'
generated: blueprint
label: thm:adelic_chi_eq_chi_zero_add_degree
lean_status: empty
order: 1863
ref: papaioannou-algebraic-rr, cff-curves-function-fields
title: '\(\chi\)-KEYSTONE: \(\chi(D) = \deg D + 1 - g\)'
type: tex
updated: '2026-07-24T03:02:15'
---
The Euler characteristic \(\chi(D) = \ell(D) - i(D)\) is additive in the
  degree:
  \[
    \chi(D') - \chi(D) = \deg(D' - D)
    \quad\text{for } D \le D',
    \qquad\text{hence}\qquad
    \chi(D) = \deg D + 1 - g .
  \]
  \emph{Status:} the single-step case is
  \Cref{thm:adelic_chi_additivity}; the telescoping induction extending
  it along an arbitrary divisor (summing one-point bumps and their
  negatives) and the base value \(\chi(0) = 1 - g\) below are not yet
  assembled into one Lean theorem.