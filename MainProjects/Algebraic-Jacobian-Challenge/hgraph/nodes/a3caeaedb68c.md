---
author: sync
chapter: The rigidity lemma and its Milne \S I.1--I.3 corollaries
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:rigidity_eqOn_dense_open
lean_status: lean_ok
order: 539
title: 'Dense-open agreement: the geometric heart of the Rigidity Lemma'
type: tex
updated: '2026-07-24T04:02:11'
---
\textit{Source: Mumford, Abelian Varieties, Ch.~II \S4, Rigidity Lemma (Form~I), p.~43 (the
  dense-open construction is the body of that proof).}
  Let \(X\) be a complete variety and \(Y\), \(Z\) any varieties over \(\bar k\). Let
  \(f \colon X \times Y \to Z\) be a morphism, fix a point \(x_0 \in X\), and suppose given
  \(y_0 \in Y\), \(z_0 \in Z\) with the \emph{collapse hypothesis}
  \[ f(X \times \{y_0\}) = \{z_0\} \qquad
     \text{(in Lean: } \mathtt{lift}\,(\mathbf 1_X)\,(\mathtt{toUnit}\,X \fatsemi y_0) \fatsemi f
     = \mathtt{toUnit}\,X \fatsemi z_0\text{).} \]
  Then there is a non-empty open subset \(U \subseteq X \times Y\) on which \(f\) agrees, as a
  scheme morphism, with the collapsed map \(\mathtt{retract} \fatsemi f\), where
  \(\mathtt{retract} := \mathtt{lift}\,(\mathtt{toUnit}\,(X \times Y) \fatsemi x_0)\,
  (p_2 \colon X \times Y \to Y)\) is the ``\((x, y) \mapsto (x_0, y)\)'' endomorphism. Concretely
  \(U = X \times V\) with \(V := Y - G\), \(G = p_2(f^{-1}(Z - U_0))\) for an affine open
  neighbourhood \(U_0\) of \(z_0\), and on \(U\) one has \(f(x, y) = f(x_0, y)\).
  \medskip
  \noindent\textbf{The collapse hypothesis is load-bearing.} The non-emptiness of \(V\) is exactly
  the assertion \(y_0 \notin G\), and this holds \emph{because} \(f(X \times \{y_0\}) = \{z_0\}
  \subseteq U_0\) keeps the slice over \(y_0\) inside the affine \(U_0\), away from \(F = Z - U_0\). A
  version of this lemma \emph{without} the collapse hypothesis is false: for \(X = Y = Z\) and
  \(f = p_1\) the first projection, \(f\) and \(\mathtt{retract} \fatsemi f \colon (x, y) \mapsto x_0\)
  agree on no non-empty open (the agreement locus is contained in \(\{x = x_0\}\), which has empty
  interior in the irreducible \(X \times Y\)). Therefore the formal target \emph{must} carry the
  collapse hypothesis as an explicit antecedent; dropping it (as an earlier decomposition
  silently did) makes the deferred goal unsatisfiable.
  \medskip
  \noindent\textbf{Formalization note: algebraically closed base, and locally-of-finite-type
  source.} The prose already takes \(\bar k\) algebraically closed, but the formal statement must
  \emph{encode} two properties. First, the cohomology-free proof of the slice-constancy bridge
  (below) needs each per-closed-point residue field \(\kappa(y)\) to be \(\bar k\) itself, so that a
  proper integral slice has global sections \(\Gamma = \bar k\) and maps to a single \(\bar k\)-point of
  the affine \(U_0\); this requires \([\mathtt{IsAlgClosed}\ \bar k]\). Second, the globalisation of the
  per-slice agreement (Step~2 of the bridge, \cref{lem:morphism_eq_of_eqAt_closedPoints}) needs the
  closed points of the saturated open \(U\) to be \emph{dense} --- i.e.\ \(U\) to be a Jacobson space.
  Over the algebraically closed \(\bar k\) this holds precisely because \(X \times Y\) is \emph{locally of
  finite type} over \(\bar k\) (\texttt{LocallyOfFiniteType.jacobsonSpace} transports the Jacobson
  property of \(\Spec \bar k\), and \texttt{closure\_closedPoints} then gives density); this requires
  \([\mathtt{LocallyOfFiniteType}\ (X \otimes Y).\mathrm{hom}]\). Accordingly the formalization carries
  \emph{both} \([\mathtt{IsAlgClosed}\ \bar k]\) and
  \([\mathtt{LocallyOfFiniteType}\ (X \otimes Y).\mathrm{hom}]\) on this lemma (in addition to
  \([\mathtt{Field}\ \bar k]\)), and propagates the same two instances to \cref{thm:rigidity_lemma},
  its core helper \texttt{rigidity\_core}, and the bridge sub-lemmas
  \cref{lem:rigidity_eqOn_saturated_open_to_affine} and
  \cref{lem:rigidity_eqAt_closedPoint_of_proper_into_affine}. Both cost nothing downstream: the
  abelian-variety consumers of the rigidity corollaries work over an algebraically closed field
  and \emph{already} assume \([\mathtt{IsAlgClosed}\ \bar k]\) --- the base-field variable is
  literally named \(\mathtt{kbar}\) --- and curves and abelian varieties are of finite type over
  \(\bar k\), so the locally-of-finite-type instance is automatic there.