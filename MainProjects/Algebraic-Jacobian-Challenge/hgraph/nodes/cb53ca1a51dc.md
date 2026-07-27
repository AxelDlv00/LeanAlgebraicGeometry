---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:coprodToProdMap
lean_status: lean_ok
order: 363
title: Canonical coproduct-to-product comparison of push--pull objects
type: tex
updated: '2026-07-27T15:50:36'
---
In the setting of Definition~\ref{def:coprodOverIncl}, assume in addition that the product
  \(\prod_i \operatorname{pushPullObj}\mathcal{F}\,(\mathrm{legs}\,i)\) exists. The \emph{canonical
  comparison map}
  \[
    \operatorname{coprodToProdMap}\mathcal{F}\,\mathrm{legs} :
      \operatorname{pushPullObj}\mathcal{F}\,\bigl(\operatorname{Over.mk}(\operatorname{Sigma.desc}
        (i \mapsto (\mathrm{legs}\,i).\mathrm{hom}))\bigr) \longrightarrow
      \prod_i \operatorname{pushPullObj}\mathcal{F}\,(\mathrm{legs}\,i)
  \]
  is the \(\operatorname{Pi.lift}\) whose \(i\)-th component is the push--pull map
  \(\operatorname{pushPullMap}\mathcal{F}\,\overline{\iota_i}\) (Definition~\ref{def:push_pull_map}) of
  the \(i\)-th coproduct inclusion (Definition~\ref{def:coprodOverIncl}). Equivalently, it is the unique
  map whose composite with the \(i\)-th product projection equals
  \(\operatorname{pushPullMap}\mathcal{F}\,\overline{\iota_i}\) for every \(i\). This is the canonical
  framing kept invariant throughout the finite induction of
  Lemma~\ref{lem:pushPull_coprod_prod}.