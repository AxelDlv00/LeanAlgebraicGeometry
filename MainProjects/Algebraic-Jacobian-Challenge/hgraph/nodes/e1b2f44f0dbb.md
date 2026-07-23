---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:cech_complex
lean_status: lean_ok
order: 169
title: '{\v C}ech complex of a quasi-coherent sheaf'
type: tex
updated: '2026-07-24T03:02:14'
---
\textit{Source: Stacks Project, Cohomology of Schemes,
  \texttt{lemma-cech-cohomology-quasi-coherent-trivial} (standard-cover {\v C}ech
  vanishing).}
  Let \(\mathcal{F}\) be a quasi-coherent \(\mathcal{O}_X\)-module and let
  \(\mathcal{U} : X = \bigcup_{i \in I} U_i\) be a finite affine open cover with
  all intersections \(U_{i_0 \ldots i_p}\) affine (e.g.\ \(X\) separated). The
  \emph{{\v C}ech complex} \(\check{\mathcal{C}}^\bullet(\mathcal{U}, \mathcal{F})\)
  is the cochain complex obtained by applying the global-sections functor to the
  {\v C}ech nerve of Definition~\ref{def:cech_nerve} evaluated at \(\mathcal{F}\);
  in degree \(p\) it is
  \[
    \check{\mathcal{C}}^p(\mathcal{U}, \mathcal{F})
      = \prod_{(i_0, \ldots, i_p) \in I^{p+1}}
        \mathcal{F}\bigl(U_{i_0 \ldots i_p}\bigr),
  \]
  with differential \(d : \check{\mathcal{C}}^p \to \check{\mathcal{C}}^{p+1}\) the
  alternating sum \((d s)_{i_0 \ldots i_{p+1}} = \sum_{j=0}^{p+1} (-1)^j\,
  s_{i_0 \ldots \widehat{i_j} \ldots i_{p+1}}|_{U_{i_0 \ldots i_{p+1}}}\) of the
  restriction maps. Over an affine \(U = \operatorname{Spec}(A)\) with
  \(\mathcal{F}|_U = \widetilde{M}\) and a standard cover by the
  \(D(f_i)\), this is the complex
  \(\prod_{i_0} M_{f_{i_0}} \to \prod_{i_0 i_1} M_{f_{i_0} f_{i_1}} \to \cdots\) of
  localisations. The \emph{relative {\v C}ech complex} \(\check{\mathcal{C}}^\bullet
  (\mathfrak{U}, \mathcal{F})\) for \(f : X \to S\) is the analogous complex in
  \(\operatorname{QCoh}(S)\) obtained by applying \(f_*\) over each finite
  intersection instead of global sections; its terms are
  \(\prod_{i_0 \ldots i_p} (f|_{U_{i_0 \ldots i_p}})_*
  \bigl(\mathcal{F}|_{U_{i_0 \ldots i_p}}\bigr)\), and it is a complex in
  \(\operatorname{QCoh}(S)\) because each \(U_{i_0 \ldots i_p}\) is affine and the
  pushforward of a quasi-coherent sheaf along a quasi-compact quasi-separated
  morphism is quasi-coherent.