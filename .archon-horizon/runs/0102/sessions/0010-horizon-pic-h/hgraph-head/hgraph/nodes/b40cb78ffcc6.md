---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: theorem
created: '2026-07-16T21:33:29'
generated: blueprint
label: thm:module_picClass_baseChange
lean_status: lean_ok
order: 788
ref: kleiman-picard
title: Naturality of the Picard class in the base ring
type: tex
updated: '2026-07-20T12:01:18'
---
Let \(A \to A'\) and \(A \to B\) be homomorphisms of commutative rings with \(B\) faithfully
  flat over \(A\) and \(A' \otimes_A B\) faithfully flat over \(A'\), and let \(u\) be a descent
  \(1\)-cocycle relative to \(A \to B\) with base change \(u'\) relative to \(A' \to A'
  \otimes_A B\) (Theorem~\ref{thm:module_descentCocycle_baseChange}). Then
  \[
    \mathrm{picClass}(u') = \bigl[A' \otimes_A \mathrm{descended}(u)\bigr] \quad \text{in }
    \operatorname{Pic}(A'),
  \]
  that is, the Picard class of the base-changed cocycle is the image of \(\mathrm{picClass}(u)\)
  under the base-change homomorphism \(\operatorname{Pic}(A) \to \operatorname{Pic}(A')\),
  \([N] \mapsto [A' \otimes_A N]\).