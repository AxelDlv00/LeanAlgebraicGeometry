---
author: sync
chapter: The tautological quotient and the universal property of $\mathrm{Gr}(r,d)$
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:gr_matrixEndRect_pullback
lean_status: lean_ok
order: 1494
title: Rectangular matrix homomorphism is natural under pullback
type: tex
updated: '2026-07-26T00:08:22'
---
Let \(p : T \to S\) be a morphism of schemes and
  \(M \in \operatorname{Mat}_{d\times r}(\Gamma(S,\mathcal{O}_S))\), with entrywise
  base-changed matrix \(p^{\sharp}M \in \operatorname{Mat}_{d\times r}(\Gamma(T,\mathcal{O}_T))\).
  Write \(Q_r : p^{*}\mathcal{O}_S^{\,r} \xrightarrow{\sim} \mathcal{O}_T^{\,r}\) and
  \(Q_d : p^{*}\mathcal{O}_S^{\,d} \xrightarrow{\sim} \mathcal{O}_T^{\,d}\) for the
  free-pullback comparisons (\cref{lem:gr_pullbackFreeIso}) at the index sets
  \(\{1,\dots,r\}\) and \(\{1,\dots,d\}\). Then the pullback of
  \(\mathrm{matrixEndRect}(M)\) is conjugate, through \(Q_r\) and \(Q_d\), to the
  rectangular homomorphism of the base-changed matrix:
  \[
    p^{*}\bigl(\mathrm{matrixEndRect}(M)\bigr)
      \;=\; Q_d^{-1} \,\circ\, \mathrm{matrixEndRect}(p^{\sharp}M) \,\circ\, Q_r .
  \]