---
author: sync
chapter: Coheight--Krull dim bridge for scheme points
content_type: theorem
created: '2026-07-16T21:14:30'
generated: blueprint
label: thm:ringKrullDim_stalk_eq_coheight
lean_status: lean_ok
order: 1697
title: Coheight-to-Krull-dim bridge for a scheme point
type: tex
updated: '2026-07-27T17:01:08'
---
Let \(X\) be a scheme and let \(z \in X\) be any point. Then
  \[
    \operatorname{ringKrullDim}(\mathcal{O}_{X,z}) \;=\; \operatorname{coheight}_{X}(z),
  \]
  i.e.\ the Krull dimension of the stalk at \(z\) equals the coheight of \(z\) in
  the underlying topological space of \(X\) (with respect to the specialisation
  preorder).