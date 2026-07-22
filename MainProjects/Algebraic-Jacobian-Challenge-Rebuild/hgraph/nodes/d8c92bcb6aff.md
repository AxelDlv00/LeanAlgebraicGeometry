---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:module_descent_cocycle
lean_status: empty
order: 782
title: Descent \(1\)-cocycle
type: tex
updated: '2026-07-17T18:01:33'
---
A \emph{descent \(1\)-cocycle} relative to \(A \to B\) is a unit \(u \in (B \otimes_A
  B)^{\times}\) such that:
  \begin{enumerate}
    \item (normalization) \(\mu(u) = 1\);
    \item (cocycle identity) \(\partial_{23}(u) \cdot \partial_{12}(u) = \partial_{13}(u)\) in
      \(B \otimes_A (B \otimes_A B)\).
  \end{enumerate}
  When \(B = \prod_i A_{f_i}\) is a finite product of localizations covering \(\Spec A\), this
  is exactly a \v Cech \(1\)-cocycle of units on the cover by the basic opens \(D(f_i)\).