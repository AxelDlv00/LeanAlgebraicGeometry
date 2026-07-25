---
author: sync
chapter: 'Section graded ring infrastructure: tensor powers and graded sections'
content_type: definition
created: '2026-07-16T21:14:30'
generated: blueprint
label: def:moduleSectionsCast
lean_status: lean_ok
order: 1326
title: Index-equality transport of twisted-section components
type: tex
updated: '2026-07-25T20:41:02'
---
Let \(\mathcal{F}\) be a sheaf of \(\mathcal{O}_X\)-modules, \(\mathcal{L}\) a sheaf
  of \(\mathcal{O}_X\)-modules, and let \(h : i = j\) be an equality of natural
  numbers. Applying the global-sections functor \(\Gamma(X,-)\) to the canonical
  isomorphism
  \(\mathcal{F} \otimes_{\mathcal{O}_X} \mathcal{L}^{\otimes i}
    \xrightarrow{\sim}
    \mathcal{F} \otimes_{\mathcal{O}_X} \mathcal{L}^{\otimes j}\)
  induced by \(h\) under the twist functor
  \(m \mapsto \mathcal{F} \otimes_{\mathcal{O}_X} \mathcal{L}^{\otimes m}\)
  (\cref{def:moduleSectionDeg}) yields the \(\Gamma(X,\mathcal{O}_X)\)-linear
  isomorphism
  \[
    \mathrm{moduleSectionsCast}(h) :
    \Gamma(X, \mathcal{F} \otimes_{\mathcal{O}_X} \mathcal{L}^{\otimes i})
      \;\xrightarrow{\ \sim\ }\;
    \Gamma(X, \mathcal{F} \otimes_{\mathcal{O}_X} \mathcal{L}^{\otimes j}),
  \]
  the \emph{twisted-section-component transport} along \(h\). It is the
  twisted-module analogue of the pure section-component transport
  \cref{def:sectionsCast}. Because the isomorphism induced by the reflexive equality
  is the identity and \(\Gamma(X,-)\) preserves identities, the transport along a
  reflexive index equality is the identity map (the reflexivity simplification
  \(\mathrm{moduleSectionsCast\_refl}\), \cref{lem:moduleSectionsCast_refl}).