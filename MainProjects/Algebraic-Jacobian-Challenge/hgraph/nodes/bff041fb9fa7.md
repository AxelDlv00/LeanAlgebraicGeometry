---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:isLocalizedModule_of_span_cover
lean_status: lean_ok
order: 295
title: \(\operatorname{IsLocalizedModule}\) is local on a finite spanning cover
type: tex
updated: '2026-07-24T11:03:43'
---
Let \(R\) be a commutative ring, let \(M\) and \(N\) be \(R\)-modules, let
  \(g : M \to N\) be an \(R\)-linear map, let \(f \in R\), and let
  \(s : \{1, \ldots, n\} \to R\) be a finite family with
  \(\operatorname{span}\{s_1, \ldots, s_n\} = R\) (the unit ideal). For each \(j\) write
  \(M_{s_j} = (\operatorname{powers} s_j)^{-1} M\) and \(N_{s_j} = (\operatorname{powers}
  s_j)^{-1} N\) for the localisations at the powers of \(s_j\), and let
  \(g_{s_j} : M_{s_j} \to N_{s_j}\) be the induced \(R\)-linear (equivalently
  \(R_{s_j}\)-linear) map. Suppose that for every \(j\) the localised map \(g_{s_j}\)
  exhibits \(N_{s_j}\) as the localisation of \(M_{s_j}\) at the powers of (the image of)
  \(f\), i.e.\ \(\operatorname{IsLocalizedModule}(\operatorname{powers} f)\, g_{s_j}\). Then
  \(g\) itself exhibits \(N\) as the localisation of \(M\) at the powers of \(f\):
  \(\operatorname{IsLocalizedModule}(\operatorname{powers} f)\, g\).