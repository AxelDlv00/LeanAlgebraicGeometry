---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:modules_over_basicOpen_equivalence
lean_status: sorry
order: 259
title: 'B3b engine: module equivalence over a basic open'
type: tex
updated: '2026-07-16T21:14:29'
---
For \(g \in R\), the engine equivalence of step B3b is the equivalence of categories of sheaves of
  modules
  \[
    \widehat{D(g)}.\operatorname{toScheme}.\mathrm{Modules} \;\simeq\;
    \operatorname{SheafOfModules}\bigl((\operatorname{Spec} R).\operatorname{ringCatSheaf}.\operatorname{over} D(g)\bigr)
  \]
  obtained by feeding the structure-sheaf comparison data
  \(\varphi = \operatorname{overBasicOpenRingHom} g\),
  \(\psi = \operatorname{overBasicOpenRingInvHom} g\) and their coherence witnesses into
  Lemma~\ref{lem:pushforwardPushforwardEquivalence_mathlib} along the now-continuous site equivalence
  of Lemma~\ref{lem:overEquivalence_isContinuous}. The comparison morphisms \(\varphi, \psi\) are built
  by whiskering the structure sheaf along the functor isomorphism
  \(\operatorname{overForgetIso} g : \operatorname{Over.forget} D(g) \cong
  \operatorname{overEquivalence}.\operatorname{functor} \circ \iota.\operatorname{opensFunctor}\)
  (whose object component is the image--preimage identity
  \(\iota(\iota^{-1} V) = V\) for opens \(V \le D(g)\)) and its definitional inverse
  \(\operatorname{overForgetInvIso} g\). This engine is the load-bearing half of step B3; the
  assembled bridge isomorphism \(\operatorname{overBasicOpenIsoRestrict}\) of
  Lemma~\ref{lem:restrict_over_compat} is its object-level corollary.