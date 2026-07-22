---
author: sync
chapter: Closed points, divisors and skyscraper cohomology
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:fiberWeilDivisor
lean_status: sorry
order: 643
title: The fibre Weil divisor
type: tex
updated: '2026-07-17T16:57:16'
---
The \emph{fibre Weil divisor} \(F\) is the effective part of \(\mathrm{div}(u)\): the Weil divisor
  (\ref{def:curveDivisor}) with coefficient \(F_x = \max(\mathrm{ord}_x(u), 0)\) at each closed point
  \(x\). It is effective (\(F \ge 0\)); it vanishes on \(V_1\) (\(F_x = 0\) for \(x \in V_1\)); it
  agrees with \(\mathrm{div}(u)\) on \(V_0\) (\(F_x = \mathrm{ord}_x(u)\) for \(x \in V_0\)); and its
  degree is nonnegative. If moreover some closed point \(x_0 \in V_0\) lies outside \(V_1\) --- a
  point of the fibre over \([1 : 0]\) --- then \(F\) is nonzero and has strictly positive degree.