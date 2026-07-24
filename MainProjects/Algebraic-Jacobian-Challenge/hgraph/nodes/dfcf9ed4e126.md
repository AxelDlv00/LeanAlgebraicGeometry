---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:isiso_pullbacktensormap_of_sheafifydelta
lean_status: lean_ok
order: 648
title: Reduction of $\mathtt{pullbackTensorMap}$ iso-ness to the sheafified presheaf
  $\delta$
type: tex
updated: '2026-07-24T04:02:11'
---
Let \(f : Y \to X\) be a morphism of schemes and let
  \(M, N \in \Scheme.\mathtt{Modules}\,X\). Write
  \[
    \varphi' :
      (X.\mathtt{presheaf} \circ \mathtt{forget}_2)
      \;\longrightarrow\;
      (\mathtt{Opens.map}\,f.\mathtt{base})^{\mathrm{op}}
        \circ (Y.\mathtt{presheaf} \circ \mathtt{forget}_2)
  \]
  for the induced presheaf-of-modules map presenting \(f\), and let
  \(a_Y = \mathtt{PresheafOfModules.sheafification}\,(\mathbf{1}_{Y.\mathtt{ringCatSheaf}})\)
  denote sheafification on \(Y\). If the sheafified presheaf-level oplax comparison
  \[
    a_Y.\mathrm{map}\bigl(
      \delta\,(\mathtt{PresheafOfModules.pullback}\,\varphi')\,M.\mathtt{val}\,N.\mathtt{val}
    \bigr)
  \]
  is an isomorphism, then the sheaf-level comparison
  \(\mathtt{pullbackTensorMap}\,f\,M\,N : f^*(M \otimes_X N) \to f^*M \otimes_Y f^*N\)
  of \cref{lem:pullback_tensor_map} is an isomorphism.