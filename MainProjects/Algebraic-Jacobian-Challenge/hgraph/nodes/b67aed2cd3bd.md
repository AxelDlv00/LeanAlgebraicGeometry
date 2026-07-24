---
author: sync
chapter: The sheaf-of-modules over-equivalence (shared slice root)
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:linebundle_chart_over_iso
lean_status: lean_ok
order: 891
title: 'Engine bridge: line-bundle over--restrict trivialisation'
type: tex
updated: '2026-07-24T11:03:44'
---
The line-bundle engine's local over--restrict trivialisation bridge: given
  \(M \in \Scheme.\mathtt{Modules}\,X\), an open \(U \subseteq X\), and a
  trivialisation \(e : M|_\iota \xrightarrow{\sim}
  \mathtt{SheafOfModules.unit}\,(\widetilde{U}).\mathtt{ringCatSheaf}\), it produces
  the slice-level isomorphism \(M.\mathtt{over}\,U \xrightarrow{\sim}
  \mathtt{SheafOfModules.unit}\,(X.\mathtt{ringCatSheaf}.\mathtt{over}\,U)\). It is the
  consumer-facing alias used by the finite-presentation engine, defined to be
  precisely the general construction \cref{lem:chart_over_iso}.