---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:restrict_iso_unit_of_le_eq_restrict
lean_status: lean_ok
order: 825
title: 'Seam 1 keystone: the unit-of-\(\le\) restriction iso is the chart restriction
  of \(e^M\)'
type: tex
updated: '2026-07-28T00:40:21'
---
\textit{Source: internal categorical construction; no external reference.}
  Let \(j : V \hookrightarrow U\) be the chart morphism (\(j \mathbin{;} \iota_U = \iota_V\)) and
  \(e^M : M|_{\iota_U} \cong \mathcal{O}_U\) a trivialisation. Then the unit-of-\(\le\) restriction
  isomorphism factors through the chart restriction of \(e^M\):
  \[
    \mathtt{restrictIsoUnitOfLE}\,h_{VU}\,e^M
      \;=\; \mathtt{restrictCompReindex}\,j\,M
        \mathbin{;} (\mathtt{restrictFunctor}\,j).\mathrm{mapIso}\,e^M
        \mathbin{;} \mathtt{unitRestrictIso}\,j,
  \]
  where \(\mathtt{restrictCompReindex}\,j\,M\) is the restriction-composite reindexing \(\varrho_M\)
  (\cref{def:restrictcompreindex}) and \(\mathtt{unitRestrictIso}\,j\) the unit-restriction
  identification \(u_\iota(j)\) (\cref{def:unitrestrictiso}).