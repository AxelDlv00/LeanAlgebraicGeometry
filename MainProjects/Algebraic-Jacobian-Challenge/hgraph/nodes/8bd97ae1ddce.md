---
author: sync
chapter: 'Section graded ring infrastructure: tensor powers and graded sections'
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:tensorBraiding
lean_status: lean_ok
order: 1265
title: Braiding of the sheaf tensor product
type: tex
updated: '2026-07-24T10:32:51'
---
For sheaves of \(\mathcal{O}_X\)-modules \(F, G\), the \emph{braiding}
  \[
    F \otimes_{\mathcal{O}_X} G \;\xrightarrow{\ \sim\ }\;
      G \otimes_{\mathcal{O}_X} F
  \]
  is the image under the sheafification functor
  (\cref{def:schemeModuleSheafification}) of the symmetric braiding of the
  presheaf symmetric monoidal structure (\cref{lem:presheafModule_monoidal_mathlib})
  on the underlying presheaves of modules. As pure sheafification-functoriality of
  an isomorphism it is again an isomorphism, requiring no monoidal structure on
  \(X.\Modules\). It is the symmetry used in the inductive step of
  \cref{lem:sheafTensorPow_add}.