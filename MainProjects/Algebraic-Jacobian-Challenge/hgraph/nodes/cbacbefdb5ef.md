---
author: sync
chapter: 'Adelic Riemann--Roch: the repartition cokernel (RR.A)'
content_type: proposition
created: '2026-07-16T21:14:30'
generated: blueprint
label: thm:adelic_residuePairing
lean_status: empty
order: 1899
ref: "papaioannou-algebraic-rr:page-0011,\n    papaioannou-algebraic-rr:page-0012"
title: The Weil-differential pairing
type: tex
updated: '2026-07-26T03:52:38'
---
Let \(\Omega_K\) be the space of Weil differentials: the \(k\)-linear
  forms on \(\mathbb A_K\) that vanish on \(\mathbb A_K(E)+K\) for some
  divisor \(E\).  Put
  \[
    \Omega_K(D)=\{\eta\in\Omega_K:\eta(\mathbb A_K(D)+K)=0\}.
  \]
  Equivalently,
  \(\Omega_K(D)=\{0\}\cup\{\eta:\operatorname{div}\eta\ge D\}\).
  Evaluation induces a canonical isomorphism
  \[
    \Omega_K(D)\simeq_k H^1_{\mathbb A}(D)^*,
  \]
  and hence a perfect pairing
  \[
    \check H^1_{\mathrm{ff}}(D)\times\Omega_K(D)\longrightarrow k.
  \]