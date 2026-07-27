---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:pushforwardcomp_lax_mu
lean_status: lean_ok
order: 884
title: Sq2b residual --- monoidality of the \(\mathtt{pushforward}\) composition cell
type: tex
updated: '2026-07-28T00:40:21'
---
The change-of-rings coherence ``\(\mathtt{pushforwardComp}\) is monoidal'': the lax
  tensorator \(\mu\) of the composite pushforward
  \(\mathtt{pushforward}\,\psi \cdot \mathtt{pushforward}\,\varphi\) (built by
  \(\mathtt{Functor.LaxMonoidal.comp}\)) agrees with the lax tensorator of the single
  pushforward \(\mathtt{pushforward}\,(\varphi \,;\, F^{\mathrm{op}} \!\lhd\! \psi)\). It is
  the sole genuine residual of the presheaf-level Sq2b lemma \cref{lem:pullbackcomp_delta}.