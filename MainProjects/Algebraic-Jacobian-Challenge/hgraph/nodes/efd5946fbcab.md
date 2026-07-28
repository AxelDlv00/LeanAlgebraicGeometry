---
author: sync
chapter: 'Section graded ring infrastructure: tensor powers and graded sections'
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:tensorPowAdd_zero_right
lean_status: lean_ok
order: 1307
title: Right-unit constraint for the tensor-power comparison
type: tex
updated: '2026-07-28T14:04:00'
---
For a sheaf of modules \(\mathcal{L}\) and \(n \in \mathbb{N}\), the degree-\((n,0)\)
  comparison isomorphism \(\mu_{n,0}\) (\cref{lem:sheafTensorPow_add}) is the right
  unitor:
  \[
    \mu_{n,0} \;=\;
      \mathrm{tensorObjRightUnitor}_{\mathcal{L}^{\otimes n}}
    \;:\; \mathcal{L}^{\otimes n} \otimes_{\mathcal{O}_X} \mathbf{1}_X
    \;\xrightarrow{\ \sim\ }\; \mathcal{L}^{\otimes n}
  \]
  (\cref{def:tensorObjRightUnitor}). Here \(\mathcal{L}^{\otimes 0} = \mathbf{1}_X\)
  and \(n + 0 = n\) hold on the nose, so the two sides inhabit a common type.