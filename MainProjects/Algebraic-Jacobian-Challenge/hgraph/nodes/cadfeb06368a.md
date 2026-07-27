---
author: sync
chapter: Codimension-1 indeterminacy extension (A.4.a)
content_type: theorem
created: '2026-07-16T21:14:30'
generated: blueprint
label: thm:weil_divisor_obstruction
lean_status: empty
order: 1691
title: Weil-divisor criterion for codimension-one extension
type: tex
updated: '2026-07-27T17:01:08'
---
\textit{Source: Hartshorne, II.6, pp.~130--131 (valuation \(v_Y\) and the order map).}
  Let \(X\) be a nonsingular variety over \(\bar k\), let \(Y\) be a variety over \(\bar k\),
  let \(f \colon X \dashrightarrow Y\) be a rational map, and let \(W \subseteq X\) be a
  prime divisor with generic point \(\eta_W \in W\) (so
  \(\mathrm{codim}_X \overline{\{\eta_W\}} = 1\)). Let \((U, \varphi_U)\) be any representative of
  \(f\) with \(U \cap (X \smallsetminus W) \neq \emptyset\). The following are equivalent:
  \begin{enumerate}
    \item \(f\) is defined at \(\eta_W\) (i.e.\ \(\eta_W \in \mathrm{Dom}(f)\), equivalently
      \(W \not\subseteq Z(f)\)).
    \item For some (equivalently, every) affine open neighbourhood \(V \subseteq Y\) of
      the generic image of \(f\) near \(W\), every regular function \(g \in
      \mathcal O_Y(V)\) pulls back to a rational function \(\varphi_U^\ast(g) \in K(X)\)
      satisfying
      \[
        \ord_W\bigl(\varphi_U^\ast(g)\bigr) \;\geq\; 0.
      \]
  \end{enumerate}

  Consequently: \(f\) is codim-\(1\)-indeterminacy-free
  (\cref{def:codim_one_indeterminacy}) if and only if, for every prime divisor
  \(W \subseteq X\) and every affine open \(V \subseteq Y\) as above, the pullback
  \(\varphi_U^\ast(g)\) has \(\ord_W \geq 0\) for all \(g \in \mathcal O_Y(V)\).