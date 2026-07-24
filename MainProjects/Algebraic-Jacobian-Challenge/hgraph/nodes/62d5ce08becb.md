---
author: sync
chapter: 'Section graded ring infrastructure: tensor powers and graded sections'
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:braiding_eq_id_of_invertible
lean_status: lean_ok
order: 1289
title: Trivial self-braiding of an invertible sheaf
type: tex
updated: '2026-07-24T04:02:11'
---
Let \(\mathcal{L}\) be an invertible sheaf (\cref{def:isInvertible}) on a scheme
  \(X\). Then the braiding of \(\mathcal{L}\) with itself is the identity:
  \[
    \beta_{\mathcal{L},\mathcal{L}} \;=\;
      \mathrm{id}_{\mathcal{L} \otimes_{\mathcal{O}_X} \mathcal{L}}
    \qquad(\cref{def:tensorBraiding}).
  \]
  More generally each tensor power \(\mathcal{L}^{\otimes m}\) is again invertible
  (\cref{def:sheafTensorPow}, \cref{def:isInvertible}), so its self-braiding is
  trivial as well, \(\beta_{\mathcal{L}^{\otimes m},\mathcal{L}^{\otimes m}} =
  \mathrm{id}\). This is the single arithmetic input distinguishing the invertible
  case: it holds precisely because \(\mathcal{L}\) is locally free of rank one, and
  fails for a general sheaf of modules --- already for
  \(\mathcal{O}_X^{\oplus 2}\) over a point, where
  \(e_1 \otimes e_2 \neq e_2 \otimes e_1\).