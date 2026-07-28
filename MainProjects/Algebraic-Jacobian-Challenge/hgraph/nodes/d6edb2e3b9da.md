---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:coverinter_ring_pushout
lean_status: lean_ok
order: 522
title: The restricted square carves into a ring pushout
type: tex
updated: '2026-07-28T18:12:21'
---
In the setting of \cref{lem:pushpullobj_coverinter_basechange}, write
  \(V = \operatorname{Spec} A_\sigma\) for the affine intersection open
  (\cref{lem:cech_interopen_isaffine}), \(\varphi : R \to A_\sigma\) for the ring map
  presenting \(f \circ j_\sigma\), \(\gamma : R \to R'\) for the ring map presenting \(g\),
  \(\rho : A_\sigma \to B\) for the corner ring map obtained by applying global sections to
  the top map \(V' \to V\) of the restricted square, and \(\psi : R' \to B\) for the ring map
  presenting \(f' \circ j'_\sigma\), where \(B = \Gamma(X', V'_\sigma)\). Then the square
  \[
    \begin{array}{ccc}
      R & \xrightarrow{\ \varphi\ } & A_\sigma\\
      {\scriptstyle \gamma}\big\downarrow & & \big\downarrow{\scriptstyle \rho}\\
      R' & \xrightarrow{\ \psi\ } & B
    \end{array}
  \]
  is a pushout of commutative rings; in particular \(B \cong A_\sigma \otimes_R R'\).