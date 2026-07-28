---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:conjugate_equiv_restrictfunctorcomp_inv
lean_status: lean_ok
order: 776
title: Restrict-side conjugate of the restriction-composition isomorphism
type: tex
updated: '2026-07-28T22:30:27'
---
Let \(f : X \hookrightarrow Y\) and \(g : Y \hookrightarrow Z\) be open immersions. Under the
  conjugation equivalence between the composite restriction adjunction
  \((\mathtt{restrictAdjunction}\,g) \circ (\mathtt{restrictAdjunction}\,f)\) and the restriction
  adjunction of the composite \(\mathtt{restrictAdjunction}\,(f \mathbin{;} g)\), the hom of the
  restriction-composition isomorphism corresponds to the hom of the pushforward-composition
  isomorphism:
  \[
    \mathtt{conjugateEquiv}\;
      \bigl((\mathtt{restrictAdjunction}\,g).\mathrm{comp}\,(\mathtt{restrictAdjunction}\,f)\bigr)\;
      (\mathtt{restrictAdjunction}\,(f \mathbin{;} g))\;
      (\mathtt{restrictFunctorComp}\,f\,g).\mathrm{hom}
    = (\mathtt{pushforwardComp}\,f\,g).\mathrm{hom}.
  \]
  This is the restriction-world mirror of Mathlib's
  \(\mathtt{conjugateEquiv\_pullbackComp\_inv}\) (which is available for the pullback world only
  because \(\mathtt{pullbackComp}\) is \emph{definitionally equal} to \(\mathtt{leftAdjointCompIso}\),
  so the pullback identity is immediate from the definition). It is the foundational lemma on which
  both Bridge B2 (\cref{lem:restrictfunctorisopullback_comp_compat}) and the Bridge B1 crux
  \(\mathtt{H1inv\_app\_eq\_pullbackVal\_restrict}\) depend.