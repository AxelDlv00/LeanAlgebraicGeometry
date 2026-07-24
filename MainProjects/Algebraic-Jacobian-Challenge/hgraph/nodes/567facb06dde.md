---
author: sync
chapter: Flattening Stratification of a Coherent Sheaf
content_type: remark
created: '2026-07-16T21:14:30'
generated: blueprint
label: rem:coh_flat_pullback
lean_status: empty
order: 902
title: rem:coh_flat_pullback
type: tex
updated: '2026-07-24T04:02:11'
---
The condition is stable under base change: for any morphism \(g : S' \to S\),
  pulling back along the cartesian square
  \[
    \begin{tikzcd}
      X' \ar[r, "g'"] \ar[d, "f'"'] & X \ar[d, "f"] \\
      S' \ar[r, "g"]                & S
    \end{tikzcd}
  \]
  yields a coherent \(\OO_{X'}\)-module \(\F' := (g')^* \F\) which is \(S'\)-flat
  whenever \(\F\) is \(S\)-flat.  This is the routine cancellation of tensor-product
  associativity at the level of stalks. The converse fails in general.