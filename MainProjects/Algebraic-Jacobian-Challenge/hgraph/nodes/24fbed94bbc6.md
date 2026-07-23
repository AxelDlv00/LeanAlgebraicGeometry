---
author: sync
chapter: Weil divisors on a smooth proper curve (RR.1)
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:divisor_degree
lean_status: lean_ok
order: 1789
title: Degree of a divisor on a curve over \(\bar k\)
type: tex
updated: '2026-07-24T03:02:15'
---
\textit{Source: Hartshorne, II.6, p.~137 (definition of degree on a
  nonsingular curve).}
  Let \(C\) be a smooth proper curve over an algebraically closed field
  \(\bar k\). The \emph{degree} of a Weil divisor $D = \sum n_i [P_i] \in
  \mathrm{Div}(C)$ is the integer
  \[
    \deg(D) \;:=\; \sum_i n_i \;\in\; \mathbb Z.
  \]
  The definition uses that every closed point of \(C\) has residue field
  \(\bar k\) (so each prime divisor contributes degree one); over a general
  field \(k\) the same definition with the residue-field-degree weight
  \(\deg(D) := \sum_i n_i \, [\kappa(P_i) : k]\) recovers the
  \emph{geometric} degree, but the project's RR bridge needs only the
  \(\bar k\) specialisation.
  \paragraph{Lean signature scope.} The Lean definition
  \texttt{AlgebraicGeometry.Scheme.WeilDivisor.degree} is given for an
  arbitrary scheme \texttt{X : Scheme.\{u\}} as the literal sum of
  coefficients via \texttt{Finsupp.sum D (fun \_ n => n)}; the typeclass
  set ``smooth proper curve over \(\bar k\)'' is \emph{not} pinned on the
  base declaration. Mathematically this assigns to every Weil divisor
  \(D \in \mathrm{Div}(X)\) on any scheme \(X\) the integer-valued sum of its
  multiplicities; for a smooth proper curve over \(\bar k\) this coincides
  with the curve-theoretic degree of the prose (every closed point has
  residue field \(\bar k\), so the residue-field-degree weight is identically
  one). The chapter's prose pins the curve hypothesis for clarity and to
  flag that, on a scheme with non-trivial residue-field extensions, the
  bare-sum signature does \emph{not} compute the geometric degree; the
  curve hypothesis is threaded at the call sites that consume
  \texttt{degree} for arithmetic statements
  (\ref{thm:principal_deg_zero}, \texttt{RR.2}--\texttt{RR.4}).