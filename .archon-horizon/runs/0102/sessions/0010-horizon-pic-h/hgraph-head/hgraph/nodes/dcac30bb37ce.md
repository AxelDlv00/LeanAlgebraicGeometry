---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:divisorClass
lean_status: lean_ok
order: 992
title: The class of a Weil divisor
type: tex
updated: '2026-07-17T18:01:33'
---
For a Weil divisor \(D \in \Div(X)\) (\ref{def:curveDivisor}), its \emph{Picard class} is the
  finite product
  \[
    \struct X(D) = \prod_{x} \struct X(x)^{D_x} \in \Pic(X),
  \]
  over the finite support of \(D\), where \(\struct X(x) := \mathrm{picClass}(1 \cdot x) \in
  \Pic(X)\) is the class of the point divisor (\ref{def:pointDivisor}, \ref{def:localEquations_picClass}).
  A negative coefficient \(D_x\) contributes the inverse class, so the exponent is an integer power
  in the abelian group \(\Pic(X)\); the assignment is defined on all of \(\Div(X)\), with no
  effective/anti-effective case split. The product is finite because \(D\) is finitely supported
  and \(\struct X(x)^0 = 1\).