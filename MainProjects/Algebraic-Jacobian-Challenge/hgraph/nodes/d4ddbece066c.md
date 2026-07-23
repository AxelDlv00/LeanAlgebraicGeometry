---
author: sync
chapter: Relative Spec
content_type: theorem
created: '2026-07-16T21:14:29'
generated: blueprint
label: thm:relative_spec_exists
lean_status: lean_ok
order: 575
title: Relative spectrum exists
type: tex
updated: '2026-07-16T21:14:29'
---
\textit{Source: [Stacks Project], tag 01LQ (lemma-glue-relative-spec);
  cf.\ [Hartshorne], II~Ex.~5.17(a).}
  Let \(X\) be a scheme and \(\mathcal{A}\) a quasi-coherent \(\mathcal{O}_X\)-algebra
  (\cref{def:qc_sheaf_of_algebras}). There exists a scheme
  \(\underline{\Spec}_X(\mathcal{A})\) together with an affine morphism
  \(\pi : \underline{\Spec}_X(\mathcal{A}) \to X\) such that
  \begin{enumerate}
    \item for every affine open \(U \subseteq X\), there is an isomorphism
      \(i_U : \pi^{-1}(U) \xrightarrow{\sim} \Spec(\mathcal{A}(U))\) over \(U\);
    \item for \(U \subseteq U' \subseteq X\) both affine open, the composite
      $\Spec(\mathcal{A}(U)) \xrightarrow{i_U^{-1}} \pi^{-1}(U) \hookrightarrow
      \pi^{-1}(U') \xrightarrow{i_{U'}} \Spec(\mathcal{A}(U'))$
      coincides with the open immersion induced by the restriction
      \(\mathcal{A}(U') \to \mathcal{A}(U)\).
  \end{enumerate}
  The pair \((\underline{\Spec}_X(\mathcal{A}), \pi)\) is unique up to unique isomorphism
  over \(X\).