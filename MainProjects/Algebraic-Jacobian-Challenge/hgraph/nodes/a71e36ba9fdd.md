---
author: sync
chapter: 'Section graded ring infrastructure: tensor powers and graded sections'
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:tensorPowAdd_zero_left
lean_status: lean_ok
order: 1294
title: Left-unit constraint for the tensor-power comparison
type: tex
updated: '2026-07-27T17:01:07'
---
For a sheaf of modules \(\mathcal{L}\) and \(n \in \mathbb{N}\), the degree-\((0,n)\)
  comparison isomorphism \(\mu_{0,n}\) (\cref{lem:sheafTensorPow_add}) is the left
  unitor, reindexed along \(0 + n = n\):
  \[
    \mu_{0,n} \;=\;
      \mathrm{tensorObjUnitIso}_{\mathcal{L}^{\otimes n}}
      \;:\; \mathbf{1}_X \otimes_{\mathcal{O}_X} \mathcal{L}^{\otimes n}
      \;\xrightarrow{\ \sim\ }\; \mathcal{L}^{\otimes n}
  \]
  (\cref{def:tensorObjUnitIso}, transport of the left unitor \(\lambda\)). Unlike
  the right-unit case, this is \emph{not} the base clause of the second-index
  recursion, so it requires an induction on \(n\).