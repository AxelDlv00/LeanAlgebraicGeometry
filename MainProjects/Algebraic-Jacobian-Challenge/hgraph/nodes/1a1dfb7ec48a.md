---
author: sync
chapter: The rigidity lemma and its Milne \S I.1--I.3 corollaries
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:rigidity_eqOn_saturated_open_to_affine
lean_status: sorry
order: 540
title: 'Bridge~2: slice-constancy on a saturated open mapping into an affine'
type: tex
updated: '2026-07-24T04:02:11'
---
\textit{Source: Mumford, Abelian Varieties, Ch.~II \S4, Rigidity Lemma (Form~I), p.~43 (the
  ``for each \(y \in V\), the complete slice maps into the affine, hence to a single point'' step).}
  Let \(\bar k\) be algebraically closed and let \(X\), \(Y\), \(Z\) be objects of
  \(\mathrm{Over}\,(\Spec \bar k)\) with \(X\) proper, \(X \times Y\) geometrically irreducible, reduced,
  and \emph{locally of finite type} over \(\bar k\) (the formalization carries
  \([\mathtt{LocallyOfFiniteType}\ (X \otimes Y).\mathrm{hom}]\), which makes the saturated open \(U\)
  below a Jacobson space, so its closed points are dense --- the hypothesis Step~2 of the proof
  consumes), and \(Z\) separated. Let \(f \colon X \times Y \to Z\) be a morphism, fix a \(\bar k\)-point
  \(x_0 \colon \mathbf 1 \to X\), and write \(\mathtt{retract} := \mathtt{lift}\,
  (\mathtt{toUnit}\,(X \times Y) \fatsemi x_0)\,(p_2)\) for the ``\((x, y) \mapsto (x_0, y)\)''
  endomorphism. Suppose:
  \begin{itemize}
    \item \(U \subseteq X \times Y\) is a \(p_2\)-\emph{saturated} open, i.e.\ \(U = p_2^{-1}(V_{\mathrm{set}})\)
      for a set \(V_{\mathrm{set}} \subseteq Y\) (so \(U\) contains the whole fibre \(X_y\) over each of
      its points);
    \item \(U_0 \subseteq Z\) is an \emph{affine} open;
    \item \(f(U) \subseteq U_0\), i.e.\ \(f\) maps \(U\) into the affine \(U_0\).
  \end{itemize}
  Then \(f\) and \(\mathtt{retract} \fatsemi f\) agree on \(U\) as scheme morphisms:
  \(U.\iota \fatsemi f = U.\iota \fatsemi (\mathtt{retract} \fatsemi f)\).