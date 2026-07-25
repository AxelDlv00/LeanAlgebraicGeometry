---
author: sync
chapter: Weil divisors on a smooth proper curve (RR.1)
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:order_eq_order_restrict
lean_status: lean_ok
order: 1778
title: Order is invariant under restriction to an open chart
type: tex
updated: '2026-07-26T00:08:22'
---
Under \([\texttt{IsIntegral}\,X]\,[\texttt{IsLocallyNoetherian}\,X]\,
  [\texttt{IsRegularInCodimensionOne}\,X]\), for a nonempty integral
  open \(U\), a prime divisor \(Y\) with \(Y.\texttt{point} \in U\),
  and \(f \in U.\texttt{toScheme}.\texttt{functionField}\),
  \(\texttt{order}\,Y\,(\texttt{functionFieldIso}\,U\,f)
   = \texttt{order}\,(\texttt{restrictToOpen}\,U\,Y)\,f\).