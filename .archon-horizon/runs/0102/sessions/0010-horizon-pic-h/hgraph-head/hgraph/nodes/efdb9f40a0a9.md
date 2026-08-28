---
author: sync
chapter: Cohomology of sheaves of modules
content_type: theorem
created: '2026-07-16T21:33:29'
generated: blueprint
label: thm:affine_open_cech_cobounding
lean_status: lean_ok
order: 308
ref: stacks-project
title: Degree-one \v{C}ech cobounding on an affine open
type: tex
updated: '2026-07-20T12:01:18'
---
Let \(X\) be a scheme and \(U\) an affine open of \(X\). Let \(f_1, \dots, f_n \in
  \Gamma(X, U)\) with \(D(f_1) \cup \dots \cup D(f_n) = U\). Let
  \(a_{ij} \in \Gamma\bigl(X, D(f_i) \cap D(f_j)\bigr)\) be a \v{C}ech \(1\)-cocycle: for all
  \(i, j, l\),
  \[
    a_{il} \;=\; a_{ij} + a_{jl}
    \qquad \text{on } D(f_i) \cap D(f_j) \cap D(f_l).
  \]
  Then there are sections \(b_i \in \Gamma\bigl(X, D(f_i)\bigr)\) with
  \[
    a_{ij} \;=\; b_i - b_j \qquad \text{on } D(f_i) \cap D(f_j)
  \]
  for all \(i, j\).