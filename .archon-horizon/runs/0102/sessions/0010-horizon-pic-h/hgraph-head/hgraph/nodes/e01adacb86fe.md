---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:cechPicClass_affineOpen
lean_status: lean_ok
order: 965
title: The affine-open \v Cech--Picard class
type: tex
updated: '2026-07-24T17:02:48'
---
Let \(Z\) be a scheme and \(O \subseteq Z\) an affine open. Pullback along the open immersion \(O
  \hookrightarrow Z\) identifies the ambient sections \(\Gamma(Z, O)\) with the global sections
  \(\Gamma(O, \top)\) of the open subscheme; write \(\iota_O^{\top}\) for this ring isomorphism. The
  \emph{affine-open class} of a \v Cech Picard class \(L\) on \(Z\) is
  \[
    L\langle O\rangle \;:=\; \bigl(\iota_O^{\top}\bigr)^{-1}_{*}\,
      \mathrm{toPic}_O\bigl(\iota^{*}L\bigr) \;\in\; \operatorname{Pic}\bigl(\Gamma(Z, O)\bigr),
  \]
  the invertible \(\Gamma(Z, O)\)-module obtained by transporting, through the affine \v
  Cech--Picard dictionary \(\mathrm{toPic}\) (Definition~\ref{def:cechPic_toPic}), the restriction of
  \(L\) to \(O\). It is natural in the open: for affine opens \(O' \le O\) the class \(L\langle
  O'\rangle\) is the image of \(L\langle O\rangle\) under the restriction homomorphism
  \(\operatorname{Pic}(\Gamma(Z, O)) \to \operatorname{Pic}(\Gamma(Z, O'))\).