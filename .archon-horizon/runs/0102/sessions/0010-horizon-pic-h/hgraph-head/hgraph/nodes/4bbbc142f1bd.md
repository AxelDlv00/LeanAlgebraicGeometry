---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:pointEquations
lean_status: lean_ok
order: 1011
title: The local equations of the point divisor
type: tex
updated: '2026-07-17T18:01:33'
---
From a tracked point-uniformizer \(d\) at \(x\) (\ref{lem:pointUniformizerData}), the
  \emph{point equations} of \(1 \cdot x\) are the local-equation system on the pointed cover
  \[
    \mathcal U(z) = \begin{cases} V & z = x, \\ X \setminus \{x\} & z \neq x, \end{cases}
  \]
  whose equation on the member at \(x\) is the tracked section \(s\) and whose equation on every
  other member is the constant \(1\); the germ at \(\eta\) of the equation at \(x\) is the chosen
  uniformizer.