---
author: sync
chapter: Weil divisors on a smooth proper curve (RR.1)
content_type: theorem
created: '2026-07-16T21:14:30'
generated: blueprint
label: thm:isRegularInCodimensionOne_open
lean_status: lean_ok
order: 1768
title: \(\texttt{IsRegularInCodimensionOne}\) descends along open immersion
type: tex
updated: '2026-07-24T10:32:51'
---
Let \(X\) be a scheme satisfying \(\texttt{IsRegularInCodimensionOne}\)
  and \(U \hookrightarrow X\) an open subscheme with
  \(\texttt{IsIntegral}\,U.\texttt{toScheme}\) (the latter is \emph{not}
  automatic from integrality of \(X\); it is threaded explicitly).
  Then \(U.\texttt{toScheme}\) also satisfies
  \(\texttt{IsRegularInCodimensionOne}\); the DVR-of-stalk property at a
  codim-1 point \(Y : U.\texttt{toScheme}.\texttt{PrimeDivisor}\) is
  transported from the corresponding point
  \(\texttt{ofOpen}\,U\,Y : X.\texttt{PrimeDivisor}\) on the ambient
  scheme via the stalk isomorphism (\ref{lem:primeDivisor_stalkIso})
  together with
  \(\texttt{IsDiscreteValuationRing.RingEquivClass.isDiscreteValuationRing}\)
  on the ring-equiv image.