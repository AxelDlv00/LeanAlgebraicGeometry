---
author: sync
chapter: 'The Grassmannian over $\mathbb{Z}$: affine charts and gluing'
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:gr_transition_pre_unit
lean_status: lean_ok
order: 1361
title: The pre-hom sends \(P^J_I\) to a unit
type: tex
updated: '2026-07-28T00:40:21'
---
\textit{Source: [Nitsure], \S 1.}
  The pre-localisation hom \(\tilde\theta_{I,J}\) (\cref{def:gr_transition_pre})
  sends \(P^J_I\) (\cref{def:gr_minor_det}, the \(I\)-minor determinant of
  \(X^J\)) to a unit of \(R^I_J\). Indeed
  \[
    \tilde\theta_{I,J}(P^J_I) = \det\bigl((X^I_J)^{-1} X^I_I\bigr)
      = \det\bigl((X^I_J)^{-1}\bigr) = \det(X^I_J)^{-1} = 1/P^I_J,
  \]
  which is a unit.