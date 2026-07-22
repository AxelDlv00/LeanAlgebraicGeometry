---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:DescentClassRep
lean_status: empty
order: 882
title: The \v Cech representative of a descended class
type: tex
updated: '2026-07-17T18:01:33'
---
Let \(w\) be a global unit of \(\Spec(B \otimes_A B)\) whose avatar is a descent
  \(1\)-cocycle.  A \emph{\v Cech representative} of the descended class consists of a pointed
  cover \(\mathcal C\) of \(\Spec A\), a unit \v Cech cocycle \(d\) on \(\mathcal C\), and a
  family of trivializing units \(\mu_a \in \Gamma(\Spec B, \mathrm{gS}^{-1}\mathcal
  C(a))^{\times}\) of the \(\mathrm{gS}\)-pullback, subject to:
  \begin{enumerate}
    \item (\emph{ratio}) the two coprojection pullbacks of each \(\mu_a\) differ by \(w\):
      \(q_2^{*}\mu_a = w \cdot q_1^{*}\mu_a\) on any sub-open of the double preimage of
      \(\mathcal C(a)\);
    \item (\emph{transition}) on overlaps the \(\mu\)'s differ by the \(\mathrm{gS}\)-pullback
      of the cocycle value: \(\mu_a = \mathrm{gS}^{*} d_{ab} \cdot \mu_b\) on \(\mathrm{gS}^{-1}
      (\mathcal C(a) \cap \mathcal C(b))\).
  \end{enumerate}