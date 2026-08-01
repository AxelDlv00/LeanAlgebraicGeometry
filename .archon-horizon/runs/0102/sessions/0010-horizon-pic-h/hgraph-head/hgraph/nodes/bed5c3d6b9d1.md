---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:presentationDivisor
lean_status: lean_ok
order: 1003
title: The divisor of a presentation
type: tex
updated: '2026-07-17T18:01:33'
---
For a meromorphic presentation \(P\) on the curve, its \emph{divisor} is the Weil divisor
  \[
    \mathrm{presentationDivisor}(P) = \sum_x \mathrm{ord}_x(f_x)\, x \in \Div(X),
  \]
  whose coefficient at each closed point \(x\) is the order at \(x\) of the piece-indexed
  trivializing element \(f_x\).