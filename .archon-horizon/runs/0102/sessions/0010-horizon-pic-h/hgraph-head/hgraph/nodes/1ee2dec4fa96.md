---
author: sync
chapter: Cohomology of sheaves of modules
content_type: theorem
created: '2026-07-16T21:33:29'
generated: blueprint
label: thm:twoCoverH0LinearEquiv
lean_status: lean_ok
order: 448
title: The two-cover \(H^0\) kernel bridge
type: tex
updated: '2026-07-17T16:57:16'
---
Let \(X\) be a scheme, \(U_0 \cup U_1 = X\) a two-cover by opens, and \(F\) \emph{any}
  sheaf of \(R\)-modules on the small Zariski site. Then degree-zero cohomology of the
  site is the kernel of the two-cover restriction-difference map: an \(R\)-linear
  equivalence
  \[
    H^0(X, F) \;\cong\;
      \ker\Bigl(F(U_0) \times F(U_1) \longrightarrow F(U_0 \cap U_1)\Bigr).
  \]
  No affineness is needed: degree-zero exactness is the sheaf condition alone.