---
author: sync
chapter: The divisor scheme and the representability of \(\mathrm{Pic}^0\)
content_type: theorem
created: '2026-07-26T15:04:51'
generated: blueprint
label: thm:isCertified_chart_obstruction
lean_status: lean_ok
order: 1107
title: The chart obstruction to a global certificate
type: tex
updated: '2026-07-26T15:04:51'
---
Write \(\operatorname{Supp}(d) \subseteq C_R\) for the support of \(d\), the closed set
  of points at which the equation of \(d\) is not a unit.
  \begin{enumerate}
    \item At a single piece \(P_j\), the chart colength module \(Q_j\) is a finite
      \(R\)-module if and only if \(\operatorname{Supp}(d) \cap P_j\) is closed in \(C_R\)
      --- that is, iff the support does not \emph{leak} out of the piece.
    \item Consequently, if \(A\) is a certified adaptation of \(d\) in any degree, then both
      pinned-chart traces \(\operatorname{Supp}(d) \cap V_0^R\) and
      \(\operatorname{Supp}(d) \cap V_1^R\) are closed in \(C_R\).
    \item In particular a divisor one of whose chart traces is not closed admits no
      certified adaptation in any degree; and if some representative of a divisor class has
      preconnected support containing a point outside \(V_0^R\) and a point outside
      \(V_1^R\), then \emph{no} representative of that class admits one.
  \end{enumerate}