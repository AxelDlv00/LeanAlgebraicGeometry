---
author: sync
chapter: Weil divisors on a smooth proper curve (RR.1)
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:codim1_cycles
lean_status: lean_ok
order: 1758
title: Codim-\(1\) cycle group / Weil divisor group of a scheme
type: tex
updated: '2026-07-16T21:14:30'
---
\textit{Source: Hartshorne, II.6, p.~130 (Weil divisor group).}
  Let \(X\) be a Noetherian integral separated scheme that is regular in
  codimension one (i.e.\ \(X\) satisfies \((*)\)). The \emph{Weil divisor group}
  \[
    \mathrm{Div}(X) \;=\; \bigoplus_{\substack{Y \subset X \\ \text{prime divisor}}}
    \mathbb Z \cdot Y
  \]
  is the free abelian group on the set of prime divisors of \(X\)
  (\ref{def:codim1_cycles}); an element \(D = \sum n_i Y_i\) with finitely
  many nonzero coefficients \(n_i \in \mathbb Z\) is called a \emph{Weil
  divisor}, and is \emph{effective} when all \(n_i \geq 0\).
  \paragraph{Lean signature scope.} The Lean definition
  \texttt{AlgebraicGeometry.Scheme.WeilDivisor X} is given for an arbitrary
  scheme \texttt{X : Scheme} as the formal-sum data type
  \texttt{X.PrimeDivisor \(\to_0\) \(\mathbb Z\)}; integrality of \(X\) is
  \emph{not} required to form the additive group \(\mathrm{Div}(X)\) (it becomes
  necessary only at the order/principal-divisor layer where the function
  field appears). Hartshorne's \((*)\) is the standing convention in the
  prose but is not threaded into the typeclass arguments of this base
  declaration. See ``Standing hypothesis \((*)\) in the Lean encoding'' above
  for the per-layer typeclass discipline.