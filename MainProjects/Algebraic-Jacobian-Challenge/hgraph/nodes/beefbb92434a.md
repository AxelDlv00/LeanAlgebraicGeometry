---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:cech_resolution_bicomplex
lean_status: empty
order: 470
title: '{\v C}ech bicomplex of an injective resolution'
type: tex
updated: '2026-07-24T11:03:43'
---
\textit{Source: Stacks Project, Cohomology, Tag 03OW
  (\texttt{lemma-cech-spectral-sequence}); the bicomplex is the explicit model of the
  Grothendieck spectral sequence used in its proof.}
  Choose an injective resolution \(\mathcal{F} \to \mathcal{I}^\bullet\) in the
  category of \(\mathcal{O}_X\)-modules (it exists by
  \cref{lem:enoughInjectives_of_hasInjectiveResolutions}). Applying the relative
  {\v C}ech-complex construction \cref{def:relative_cech_complex_of_nerve} of the cover
  \(\mathfrak{U}\) to each \(\mathcal{I}^q\) yields a double complex
  \[
    C^{p,q} \;=\; \check{\mathcal{C}}^p\bigl(\mathfrak{U}, \mathcal{I}^q\bigr)
    \in \operatorname{QCoh}(S),
  \]
  with horizontal differential the {\v C}ech (alternating-coface) differential and
  vertical differential induced by \(\mathcal{I}^\bullet\). Each row \(C^{\bullet,q}\)
  is the relative {\v C}ech complex of \(\mathcal{I}^q\); each column \(C^{p,\bullet}\)
  is \(f_*\) of the push--pull nerve term at level \(p\) applied to the resolution
  \(\mathcal{I}^\bullet\).