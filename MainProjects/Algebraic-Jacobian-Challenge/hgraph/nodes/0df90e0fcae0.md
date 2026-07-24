---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:pushforwardPushforwardEquivalence_mathlib
lean_status: mathlib_ok
mathlib_name:
- SheafOfModules.pushforwardPushforwardEquivalence
order: 249
title: Site-equivalence transport of sheaves of modules
type: tex
updated: '2026-07-24T11:03:43'
---
\textit{Provided by Mathlib.}
  Let \(e : \mathcal{C} \simeq \mathcal{D}\) be an equivalence of sites whose functor and inverse
  are continuous.  If \(\mathcal{O}_{\mathcal{C}}\) and \(\mathcal{O}_{\mathcal{D}}\) are sheaves of
  rings related by mutually inverse comparison maps along the two pushforwards, then \(e\) induces
  an equivalence of categories of sheaves of modules
  \(\operatorname{SheafOfModules} \mathcal{O}_{\mathcal{C}} \simeq
  \operatorname{SheafOfModules} \mathcal{O}_{\mathcal{D}}\), compatible with those pushforwards.
  This is the engine that bridges two pictures of ``restriction to an open''.