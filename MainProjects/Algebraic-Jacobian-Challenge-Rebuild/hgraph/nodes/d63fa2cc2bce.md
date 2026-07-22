---
author: sync
chapter: Closed points, divisors and skyscraper cohomology
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:fiberCoordUnit
lean_status: sorry
order: 641
title: The fibre unit
type: tex
updated: '2026-07-17T16:57:16'
---
Let \(t_1 = \pi^{\sharp}(t_{10}) \in \Gamma(Y, V_1)\) be the pullback of the chart-\(1\) coordinate
  \(t_{10} = X_0/X_1\) (\ref{def:P1_chartCoord}), a regular section on \(V_1\). On the overlap the
  two coordinates are mutually inverse,
  \[
    t_0|_{\cap} \cdot t_1|_{\cap} \;=\; 1 \qquad \text{in } \Gamma(Y, V_0 \cap V_1).
  \]
  Consequently the germ \(u := \mathrm{germ}_{\eta}(t_0) \in K(Y)\) is a unit of the function field,
  the \emph{fibre unit}; its inverse is \(\mathrm{germ}_{\eta}(t_1)\).