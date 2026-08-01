---
author: sync
chapter: Cohomology of sheaves of modules
content_type: theorem
created: '2026-07-16T21:33:29'
generated: blueprint
label: thm:qcohOn_isLocalizedModule
lean_status: lean_ok
order: 324
title: The packaging axioms are the localisation axioms
type: tex
updated: '2026-07-24T17:02:48'
---
Let \(U\) be an affine open of a scheme \(X\), let \(F\) be a sheaf of \(k\)-modules with
  a quasi-coherence packaging on \(U\), and let \(g \in \Gamma(X, U)\) act invertibly on
  \(F(U \cap D(g))\) (for the module structure of \ref{def:qcohOn_module}). Then the
  restriction map \(F(U) \to F(U \cap D(g))\) exhibits \(F(U \cap D(g))\) as the
  localisation of the \(\Gamma(X, U)\)-module \(F(U)\) at the multiplicative set
  \(S = \{1, g, g^2, \dots\}\) of powers of \(g\); that is:
  \begin{enumerate}
    \item every element of \(S\) acts invertibly on \(F(U \cap D(g))\);
    \item every \(c \in F(U \cap D(g))\) is of the form \(g^{-N} \cdot (e|_{U \cap D(g)})\)
      for some \(N \ge 0\) and \(e \in F(U)\);
    \item any two sections of \(F(U)\) with equal restriction to \(U \cap D(g)\) differ by
      an element killed by a power of \(g\).
  \end{enumerate}
  These three properties characterise the localisation map \(M \to S^{-1}M\) up to unique
  isomorphism under \(F(U)\).