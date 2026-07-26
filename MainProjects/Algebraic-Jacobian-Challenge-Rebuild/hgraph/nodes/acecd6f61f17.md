---
author: sync
chapter: 'The tangent space of the Picard functor: the truncated exponential'
content_type: theorem
created: '2026-07-17T08:59:08'
generated: blueprint
label: thm:truncExp_exact
lean_status: lean_ok
order: 1128
ref: kleiman-picard
title: Exactness in the middle
type: tex
updated: '2026-07-26T15:04:51'
---
The range of the truncated exponential is exactly the kernel of reduction mod
  \(\varepsilon\) on units: a unit \(u \in R[\varepsilon]^\times\) satisfies
  \(\mathrm{fst}^\times(u) = 1\) if and only if \(u = 1 + b\varepsilon\) for a (unique)
  \(b \in R\). Together with \ref{lem:unitsFst_split} this exhibits the split short
  exact sequence
  \[
    1 \longrightarrow (R, +) \xrightarrow{\ \mathrm{tExp}\ } R[\varepsilon]^\times
      \xrightarrow{\ \mathrm{fst}^\times\ } R^\times \longrightarrow 1 .
  \]