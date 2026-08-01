---
author: sync
chapter: Lattice finiteness over the Laurent ring
content_type: theorem
created: '2026-07-17T08:59:07'
generated: blueprint
label: thm:depth_ext
lean_status: lean_ok
order: 261
ref: stacks-project
title: Depth via \(\Ext\)
type: tex
updated: '2026-07-20T12:01:18'
---
Let \((R, \mathfrak m)\) be a Noetherian local ring with residue field
  \(\kappa = R/\mathfrak m\) and let \(M\) be a nonzero finite \(R\)-module. For every
  \(n \in \mathbb{N}\),
  \[
    n \leq \mathrm{depth}(M)
    \iff
    \Ext^i_R(\kappa, M) = 0 \text{ for all } i < n.
  \]
  Equivalently, \(\mathrm{depth}(M)\) is the smallest \(i\) such that
  \(\Ext^i_R(\kappa, M) \neq 0\).