---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:trivialisation_uiota_restrict_compat
lean_status: lean_ok
order: 812
title: 'S4c: global-unit comparison \(u_\iota\) commutes with further restriction'
type: tex
updated: '2026-07-24T04:02:11'
---
With \(j : V \hookrightarrow U\) as above, the global-unit comparison
  \[
    u_\iota(f) := \bigl(\mathtt{restrictFunctorIsoPullback}\,f\bigr).\mathrm{app}\,
      (\mathtt{SheafOfModules.unit}\,X) \mathbin{;} \mathtt{pullbackUnitIso}\,f
      : \mathtt{restrict}\,(\mathcal{O}_X)\,f \cong \mathcal{O}_U
  \]
  (\cref{lem:pullback_unit_iso}), whose inverse \(u_\iota(f)^{-1}\) is the final leg of the
  trivialisation chain, commutes with further restriction along \(j\): modulo the reindexing
  \(\varrho\),
  \[
    (\mathtt{restrict}\,j)\,u_\iota(\iota_U)^{-1} \;=\; u_\iota(\iota_V)^{-1}.
  \]