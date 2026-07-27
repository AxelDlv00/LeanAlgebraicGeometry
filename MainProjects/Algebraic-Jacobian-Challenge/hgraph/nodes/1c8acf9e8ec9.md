---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:unit_dual_section_equiv
lean_status: lean_ok
order: 713
title: Section equivalence for the dual of the unit
type: tex
updated: '2026-07-27T17:01:07'
---
For a presheaf of modules over a base ring presheaf \(R_0\) and an object \(X\), the
  \(R_0(X)\)-linear equivalence
  \[
    \bigl(\mathtt{restr}_X\,\mathbf 1 \to \mathtt{restr}_X\,\mathbf 1\bigr)
      \;\simeq_{R_0(X)}\; R_0(X)
  \]
  identifying endomorphisms of the (restricted) monoidal unit with the ground ring, via
  evaluation at the global section \(1\); the inverse is multiplication by a global scalar
  (\cref{def:global_smul}).