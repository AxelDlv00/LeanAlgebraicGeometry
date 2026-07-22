---
author: sync
chapter: Cohomology of sheaves of modules
content_type: theorem
created: '2026-07-17T16:57:15'
generated: blueprint
label: thm:over_isPullback_crossBase
lean_status: lean_ok
order: 396
title: The cross-base pasted square
type: tex
updated: '2026-07-17T16:57:15'
---
Let \(f : S' \to S\) be a morphism of schemes, \(X \in \Over(S)\), and
  \(T \in \Over(S')\). The square
  \[
    \begin{array}{ccc}
      (f^{*}X \otimes T)_{\mathrm{left}} &
        \xrightarrow{\ \mathrm{pr}_1 \circ\, \mathrm{fst}\ } & X_{\mathrm{left}} \\
      \downarrow \mathrm{snd} & & \downarrow X.\mathrm{hom} \\
      T_{\mathrm{left}} & \xrightarrow{\ f \circ T.\mathrm{hom}\ } & S
    \end{array}
  \]
  is a pullback of schemes; here the top edge is the first slice projection
  \(\mathrm{fst} : (f^{*}X \otimes T)_{\mathrm{left}} \to (f^{*}X)_{\mathrm{left}}
  = X_{\mathrm{left}} \times_S S'\) followed by the first projection of the fibre
  product, and the bottom edge \(f \circ T.\mathrm{hom}\) is the structure morphism of
  \(f_{!}T\). Thus the slice product \(f^{*}X \otimes T\), formed over \(S'\), is at the
  same time a pullback of the \emph{cross-base} cospan
  \(X_{\mathrm{left}} \to S \leftarrow T_{\mathrm{left}}\).