---
author: sync
chapter: The Quot scheme
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:quot_pullback_app_isoTensor_unitAtV
lean_status: lean_ok
order: 1262
title: Adjunction-unit base linear map at a section
type: tex
updated: '2026-07-30T11:51:47'
---
Given a morphism \(g : Y \to X\) of schemes, a sheaf of
  \(\mathcal{O}_X\)-modules \(\mathcal{N}\), and an open \(V \subseteq X\),
  the unit of the pullback--pushforward adjunction yields a morphism of
  \(\mathcal{O}_X\)-modules \(\mathcal{N} \to g_*(g^* \mathcal{N})\).
  Evaluating its \(V\)-component gives the \(\Gamma(X, V)\)-linear
  \emph{unit-at-section} map
  \[
    \Gamma(\mathcal{N}, V)
    \;\longrightarrow\;
    \Gamma\bigl(g_*(g^* \mathcal{N}),\ V\bigr).
  \]
  This is the adjunction-unit map underlying the tensor-presentation
  isomorphism of \cref{def:quot_pullback_app_isoTensor}.