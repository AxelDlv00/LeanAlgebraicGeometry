---
author: sync
chapter: 'Adelic Riemann--Roch: the repartition cokernel (RR.A)'
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: thm:adelic_residuePairing
lean_status: empty
order: 1868
ref: vater-weil-differentials, papaioannou-algebraic-rr
title: Residue pairing on the cover cohomology
type: tex
updated: '2026-07-26T00:08:22'
---
Let \(\Omega_K\) be the space of Weil differentials of \(K/k\)
  (\(k\)-linear forms on the adeles vanishing on some
  \(\mathbb{A}_K(D) + K\); locally the Kähler differentials
  \(\Omega_{K/k}\), a one-dimensional \(K\)-vector space). There is a
  perfect \(k\)-bilinear residue pairing
  \[
    \langle\,\cdot\,,\,\cdot\,\rangle \colon
      \mathbb{A}_K \times \Omega_K \to k,
    \qquad
    (\alpha, \omega) \mapsto \sum_P \operatorname{Res}_P(\alpha_P\, \omega),
  \]
  where \(\operatorname{Res}_P\) is the local residue at \(P\). It
  satisfies the residue theorem \(\sum_P \operatorname{Res}_P(f\omega) = 0\)
  for \(f \in K\), and therefore descends to a pairing
  \[
    \check{H}^1(D) \times \Omega_K(K_C - D) \longrightarrow k,
  \]
  where \(\Omega_K(E) = \{\omega : \operatorname{div}\omega \ge E\}\) and
  \(K_C\) is a canonical divisor.