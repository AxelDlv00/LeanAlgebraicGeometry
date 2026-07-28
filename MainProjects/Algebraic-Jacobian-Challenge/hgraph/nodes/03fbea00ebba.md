---
author: sync
chapter: The tautological quotient and the universal property of $\mathrm{Gr}(r,d)$
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:gr_matrixEndRect
lean_status: lean_ok
order: 1520
title: Rectangular matrix homomorphism of free sheaves
type: tex
updated: '2026-07-29T06:43:24'
---
Let \(S\) be a scheme, \(d, r \in \mathbb{N}\), and
  \(M \in \operatorname{Mat}_{d \times r}(\Gamma(S, \mathcal{O}_S))\) a rectangular matrix
  of global functions. The \emph{rectangular matrix homomorphism}
  \(\mathrm{matrixEndRect}(M)\) is the morphism of free sheaves
  \[
    \mathrm{matrixEndRect}(M) \;:\; \mathcal{O}_S^{\,r}
      \;\longrightarrow\; \mathcal{O}_S^{\,d}
  \]
  whose \((k,\ell)\)-component -- \(k \in \{1,\dots,d\}\) an output index,
  \(\ell \in \{1,\dots,r\}\) an input index -- under the presentation of
  \(\mathcal{O}_S^{\,r}\) and \(\mathcal{O}_S^{\,d}\) as finite biproducts of copies of the
  unit module \(\mathbf 1\), is the scalar endomorphism \(\mathrm{scalarEnd}(M_{k,\ell})\)
  (\cref{def:gr_scalarEnd}). It is assembled from these components by the universal property
  of the two biproducts, exactly as the square \(\mathrm{matrixEnd}\)
  (\cref{def:gr_matrixEnd}) and the chart quotient (\cref{def:gr_chart_quotient}). When
  \(r = d\) it specialises to \(\mathrm{matrixEnd}\); and the chart quotient \(u^I\)
  (\cref{def:gr_chart_quotient}) is by construction \(\mathrm{matrixEndRect}(X^I)\) of the
  universal \(d \times r\) matrix \(X^I\) (\cref{def:gr_universal_matrix}).