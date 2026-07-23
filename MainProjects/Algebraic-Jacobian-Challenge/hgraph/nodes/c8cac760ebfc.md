---
author: sync
chapter: Weil divisors on a smooth proper curve (RR.1)
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:primeDivisor_ext
lean_status: lean_ok
order: 1762
title: Extensionality for prime divisors
type: tex
updated: '2026-07-16T21:14:30'
---
Two prime divisors \(Y, Y' : X.\texttt{PrimeDivisor}\)
  (\ref{def:prime_divisor}) on a scheme \(X\) are equal as soon as their
  underlying generic points agree: if \(Y.\texttt{point} = Y'.\texttt{point}\)
  then \(Y = Y'\). The codimension-one witness
  \(\texttt{Order.coheight}\,Y.\texttt{point} = 1\) is a \(\texttt{Prop}\)-valued
  field, hence proof-irrelevant, so it carries no data distinguishing two prime
  divisors that share the same underlying point. This is the
  \(\texttt{@[ext]}\)-generated extensionality lemma underlying the round-trip
  identities of the bijection \(\texttt{equivOpen}\)
  (\ref{lem:primeDivisor_equivOpen}).