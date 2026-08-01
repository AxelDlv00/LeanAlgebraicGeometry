---
author: sync
chapter: Rational maps into group varieties
content_type: definition
created: '2026-07-17T10:19:50'
generated: blueprint
label: def:ratmap_precomp
lean_status: lean_ok
order: 1166
title: Precomposition of a rational map with an open morphism
type: tex
updated: '2026-07-31T19:57:34'
---
Let \(f : X \dashrightarrow Y\) be a rational map and \(p : W \to X\) a
  morphism whose underlying continuous map is \emph{open}. The composite
  \[
    f \circ p : W \dashrightarrow Y
  \]
  is the rational map represented by \((p^{-1}U,\ \varphi \circ p_U)\) for any
  representative \((U, \varphi)\) of \(f\), where \(p_U : p^{-1}U \to U\) is the
  restriction of \(p\).