---
author: sync
chapter: The Quot scheme
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:pushforwardPushforwardEquivalence_mathlib
lean_status: mathlib_ok
mathlib_name:
- SheafOfModules.pushforwardPushforwardEquivalence
order: 1095
title: Module sheaves transport across an equivalence of ringed sites
type: tex
updated: '2026-07-23T18:01:59'
---
\textit{Provided by Mathlib
  (\texttt{Mathlib.Algebra.Category.ModuleCat.Sheaf.PushforwardContinuous}).}
  Let \(e : C \simeq D\) be an equivalence of sites with both \(e.\mathrm{functor}\) and
  \(e.\mathrm{inverse}\) continuous, and let \(S\) (a sheaf of rings on \(J\)) and \(R\) (a sheaf
  of rings on \(K\)) be related by mutually inverse comparison maps across the continuous
  pushforwards. Then the categories of sheaves of modules are equivalent,
  \(\mathrm{SheafOfModules}\,R \simeq \mathrm{SheafOfModules}\,S\), compatibly with the
  underlying ring-sheaf identification. This is the module-level lift used in step~3 of
  \cref{lem:over_restrict_iso}.