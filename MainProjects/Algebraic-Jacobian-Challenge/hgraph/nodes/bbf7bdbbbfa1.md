---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:sectionCechAugV
lean_status: lean_ok
order: 384
title: Augmentation of the section {\v C}ech complex over \(V\)
type: tex
updated: '2026-07-26T00:08:21'
---
Fix an open \(V \subseteq X\). The augmentation of the concrete section {\v C}ech complex for
  the restricted family \(U'_i=U_i\cap V\) is the product of the restriction maps
  \[
    \varepsilon_V : \Gamma(V, \mathcal{F}) \longrightarrow
      \prod_{\sigma:\operatorname{Fin}1\to I}
        \Gamma\!\left(\bigcap_k(U_{\sigma(k)}\cap V),\mathcal{F}\right),
    \qquad
    t\longmapsto
      \left(t\big|_{\cap_k(U_{\sigma(k)}\cap V)}\right)_{\sigma}.
  \]