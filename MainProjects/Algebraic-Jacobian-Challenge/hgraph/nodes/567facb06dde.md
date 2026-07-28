---
author: sync
chapter: Flattening Stratification of a Coherent Sheaf
content_type: remark
created: '2026-07-16T21:14:30'
generated: blueprint
label: rem:coh_flat_pullback
lean_status: empty
order: 924
title: rem:coh_flat_pullback
type: tex
updated: '2026-07-28T14:04:00'
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
  whenever \(\F\) is \(S\)-flat.  Indeed, at each stalk the pullback is an
  extension of scalars of the original flat module, and extension of scalars
  preserves flatness. The converse fails in general.