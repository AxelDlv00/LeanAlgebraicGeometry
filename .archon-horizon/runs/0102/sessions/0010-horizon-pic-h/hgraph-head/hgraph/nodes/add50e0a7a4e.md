---
author: sync
chapter: The \'etale plus construction of the relative Picard functor
content_type: definition
created: '2026-07-16T21:33:29'
generated: blueprint
label: def:picEt
lean_status: lean_ok
order: 911
ref: kleiman-picard
title: The \'etale-sheafified relative Picard functor at a test object
type: tex
updated: '2026-07-20T12:01:18'
---
For a test object \(T\) of \(\Over(\Spec k)\), \(\mathrm{picEt}(C, T)\) is the group of
  \emph{compatible families}: an element assigns to each affine open \(V \subseteq T_{\mathrm{left}}\)
  a plus class \(s_V \in \mathrm{PicEtAff}(C, \Gamma(T, V))\) such that for affine opens
  \(U \subseteq V\), the value \(s_U\) is the restriction of \(s_V\) along the section-restriction
  homomorphism \(\Gamma(T, V) \to \Gamma(T, U)\) (Definition~\ref{def:PicEtAff_map}). Componentwise
  product makes \(\mathrm{picEt}(C, T)\) a commutative group, a subgroup of the product
  \(\prod_{V} \mathrm{PicEtAff}(C, \Gamma(T, V))\); evaluation at an affine open \(V\) is the
  homomorphism \(s \mapsto s_V\). On affine tests this is the plus itself (the affine comparison,
  Definition~\ref{def:picEtAffineEquiv}); on general tests it is the canonical Zariski-continuous
  extension --- the realization on all test objects of the \'etale sheafification
  \(\Pic_{(X/S)\mathrm{\acute et}}\) of the relative Picard functor.