---
author: sync
chapter: Flat base change for the pushforward of a quasi-coherent sheaf ($i=0$)
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:pushforwardPullbackBaseChange_natIso
lean_status: empty
order: 140
title: The global base-change natural isomorphism \(e\)
type: tex
updated: '2026-07-24T03:02:13'
---
The morphism \(e^{\mathrm{lin}}\) of
  Lemma~\ref{lem:pushforwardPullbackBaseChange_linHom} is an isomorphism, and the
  family over quasi-coherent \(\mathcal{F}\) assembles into a natural isomorphism of
  functors
  \[
    e : g^* \circ f_* \;\cong\; f'_* \circ (g')^* .
  \]
  This \(e\) is the active-route deliverable consumed downstream (it commutes with the
  restriction maps by construction); it is built without ever forming the canonical
  adjoint mate.