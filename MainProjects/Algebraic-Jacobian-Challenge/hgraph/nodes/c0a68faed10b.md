---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:isLocalizedModule_baseChange_away
lean_status: lean_ok
order: 422
title: Localised base change is a localisation away
type: tex
updated: '2026-07-24T03:02:14'
---
\textit{Project-local infrastructure, assembled from Mathlib base-change primitives.}
  Let \(\varphi : R \to S\) be a ring map, \(M\) an \(R\)-module, and \(g \in R\) with image
  \(\bar g = \varphi(g) \in S\). The base change \(M \otimes_R S\), further localised at the powers of
  \(\bar g\), is a localisation of \(M\): the composite
  \[
    M \;\longrightarrow\; M \otimes_R S \;\longrightarrow\; (M \otimes_R S)_{\bar g}
  \]
  exhibits \((M \otimes_R S)_{\bar g}\) as the base change of \(M\) along the composite
  \(R \to S \to S_{\bar g}\). In particular, whenever the localised ring \(S_{\bar g}\) is identified
  with the localisation \(R_g\) --- as happens when \(D_S(\bar g)\) and \(D_R(g)\) name the same basic
  open --- the composite presents \((M \otimes_R S)_{\bar g}\) as the away localisation \(M_g\).