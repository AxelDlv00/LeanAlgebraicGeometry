---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: remark
created: '2026-07-28T14:03:59'
generated: blueprint
label: rem:pullback_pfl_three_factor_route
lean_status: empty
order: 499
title: The older three-factor route, and why it is not the one taken
type: tex
updated: '2026-07-29T06:43:23'
---
By Lemma~\ref{lem:sheafOfModules_pullbackIso}, on the genuine scheme site \(g^*\)
  factors as the composite
  \(\operatorname{forget} \circ
  (\texttt{PresheafOfModules.pullback}\,\varphi_{\mathrm{hom}}) \circ
  \texttt{PresheafOfModules.sheafification}\). The outer two factors preserve finite
  limits unconditionally (Lemmas~\ref{lem:forget_sheafOfModules_pfl_mathlib}
  and~\ref{lem:sheafification_pfl_mathlib}, both supplied by Mathlib on the scheme
  site). The middle factor preserves finite limits because \(g\) is flat
  (Lemma~\ref{lem:presheaf_pullback_pfl_flat}). A composite of
  finite-limit-preserving functors preserves finite limits, so \(g^*\) does.

  This is a correct argument and it is not the one used, because its middle input is no easier
  than the conclusion: presheaf-level pullback is characterised as a left adjoint with no
  pointwise description, so Lemma~\ref{lem:presheaf_pullback_pfl_flat} needs the same stalk
  model that Remark~\ref{rem:pullback_mono_missing_stalk_model} records as missing, while
  additionally carrying two sheafification hypotheses. The mono route reaches the same place
  through one statement instead of four.