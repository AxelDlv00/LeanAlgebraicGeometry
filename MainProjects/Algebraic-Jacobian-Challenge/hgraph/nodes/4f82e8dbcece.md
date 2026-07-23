---
author: sync
chapter: Auslander--Buchsbaum
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:enat_ab_inductive_combine
lean_status: lean_ok
order: 1715
title: \(\mathbb N_\infty\) combine for the inductive step
type: tex
updated: '2026-07-16T21:14:30'
---
A purely arithmetic statement in \(\mathbb N_\infty\): given \(j + d_K = d\),
  \(\min(d, d_K - 1) \leq d_M\), \(\min(d, d_M + 1) \leq d_K\), and \(1 \leq j\), one
  concludes \((j + 1) + d_M = d\). This packages the inductive hypothesis
  \(j + \text{depth}(\ker f) = \text{depth}(R)\) with the two kernel-SES depth
  inequalities into the next instance of the Auslander--Buchsbaum equation.