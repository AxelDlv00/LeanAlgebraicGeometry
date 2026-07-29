---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:basis_cov_system
lean_status: lean_ok
order: 315
title: Cover system on a basis
type: tex
updated: '2026-07-29T13:44:21'
---
\textit{Project-bespoke encoding of the hypotheses of Stacks 01EO.}
  A \emph{cover system on a basis} for a scheme \(X\) is a record with five fields. A
  \emph{covering datum} (the helper \(\mathrm{CovDatum}\)) is a pair \((\iota, U)\) of an index type
  \(\iota\) together with an index family \(U : \iota \to \mathrm{Opens}(X)\); it is the raw shape
  \(\Sigma\,\iota,\ \iota \to \mathrm{Opens}(X)\) over which the section {\v C}ech complex is built.
  The cover system bundles:
  \begin{enumerate}
  \item a basis \(\mathcal{B} \subseteq \mathrm{Opens}(X)\) for the topology;
  \item a set \(\mathrm{Cov}\) of admissible coverings, each a \(\mathrm{CovDatum}\);
  \item \emph{faces-in-basis} (\(\mathrm{faces\_mem}\)): for every covering in \(\mathrm{Cov}\) every
    finite intersection \(U_{i_0 \ldots i_p}\) of its opens lies in \(\mathcal{B}\) (condition (1) of
    Lemma~\ref{lem:cech_to_cohomology_on_basis});
  \item \emph{section surjectivity} (\(\mathrm{surj\_of\_vanishing}\)): for every \(V \in \mathcal{B}\)
    and every short exact sequence \(S : 0 \to S_1 \to S_2 \to S_3 \to 0\) of \(\mathcal{O}_X\)-modules
    whose left term \(S_1\) has vanishing positive {\v C}ech cohomology over the coverings of \(V\) in
    \(\mathrm{Cov}\), the section map \(S_2(V) \to S_3(V)\) is surjective;
  \item \emph{injective acyclicity} (\(\mathrm{injective\_acyclic}\)): for every injective
    \(\mathcal{O}_X\)-module \(\mathcal{I}\) and every covering \(\mathcal{U} \in \mathrm{Cov}\) the
    positive-degree {\v C}ech cohomology vanishes, \(\check{H}^p(\mathcal{U}, \mathcal{I}) = 0\) for
    all \(p > 0\).
  \end{enumerate}
  Unlike a bare combinatorial record, the structure carries two sheaf-theoretic ({\v C}ech-cohomology)
  fields. The field \(\mathrm{surj\_of\_vanishing}\) is \emph{not} the raw cofinality datum: it is the
  section-surjectivity \emph{output} that cofinality together with Lemma~\ref{lem:ses_cech_h1}
  produces, packaged directly as the consequence the 01EO chain consumes. The field
  \(\mathrm{injective\_acyclic}\) is the injective {\v C}ech-acyclicity of
  Lemma~\ref{lem:injective_cech_acyclic} for the system's own coverings. These are exactly the data
  that the dimension-shift induction Lemma~\ref{lem:absolute_cohomology_pos_vanishing} consumes.