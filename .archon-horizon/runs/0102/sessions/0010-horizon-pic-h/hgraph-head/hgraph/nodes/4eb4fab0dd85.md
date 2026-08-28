---
author: sync
chapter: Cohomology of sheaves of modules
content_type: theorem
created: '2026-07-17T16:57:15'
generated: blueprint
label: thm:crossBaseAffineIso_naturality
lean_status: lean_ok
order: 403
title: Naturality of the same-carrier comparison in the algebra
type: tex
updated: '2026-07-17T16:57:15'
---
Let \(A, B\) be algebras in scalar towers \(k \to L \to A\), \(k \to L \to B\) and
  \(f : A \to B\) a homomorphism of \(L\)-algebras; through the towers, \(f\) is then
  also a homomorphism of \(k\)-algebras. Writing \(c_A, c_B\) for the same-carrier
  comparisons (\ref{def:crossBaseAffineIso}) and \(\Spec_L f : \Spec B/\Spec L \to
  \Spec A/\Spec L\), \(\Spec_k f : \Spec B/\Spec k \to \Spec A/\Spec k\) for the
  morphisms of affine tests induced by \(f\) over the two bases (\ref{def:overSpecMap}),
  the square
  \[
    \begin{array}{ccc}
      \bigl(\sigma^{*}C \otimes (\Spec B/\Spec L)\bigr)_{\mathrm{left}} &
        \xrightarrow{\ c_B\ } &
        \bigl(C \otimes (\Spec B/\Spec k)\bigr)_{\mathrm{left}} \\
      \downarrow (\sigma^{*}C \lhd \Spec_L f)_{\mathrm{left}} & &
        \downarrow (C \lhd \Spec_k f)_{\mathrm{left}} \\
      \bigl(\sigma^{*}C \otimes (\Spec A/\Spec L)\bigr)_{\mathrm{left}} &
        \xrightarrow{\ c_A\ } &
        \bigl(C \otimes (\Spec A/\Spec k)\bigr)_{\mathrm{left}}
    \end{array}
  \]
  commutes.