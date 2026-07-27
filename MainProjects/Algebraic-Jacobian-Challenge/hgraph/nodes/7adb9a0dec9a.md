---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:slice_dual_transport
lean_status: lean_ok
order: 709
title: The per-section dual transport \(\mathtt{sliceDualTransport}\)
type: tex
updated: '2026-07-28T02:46:11'
---
Let \(f : Y \hookrightarrow X\) be an open immersion of schemes and let
  \(M \in \Scheme.\mathtt{Modules}\,X\). Write \(\alpha\) for the open-immersion
  structure-presheaf natural transformation with components
  \(\alpha_U = (f.\mathtt{appIso}\,U).\mathrm{inv}\), a \emph{\(\mathtt{CommRingCat}\)}-level
  ring isomorphism, and \(\beta = \mathtt{whiskerRight}\,\alpha\,
  (\mathtt{forget}_2\,\mathtt{CommRingCat}\,\mathtt{RingCat})\) for its
  \(\mathtt{RingCat}\)-level shadow, with component
  \(\beta_V \colon \mathcal{O}_Y(V) \xrightarrow{\sim} \mathcal{O}_X(fV)\)
  (\(fV := f.\mathtt{opensFunctor}(V)\)). Then for every open \(V \subseteq Y\) there is an
  \(\mathcal{O}_Y(V)\)-linear isomorphism
  \[
    \bigl((\mathtt{pushforward}\,\beta).\mathtt{obj}\,(\mathtt{dual}\,M.\mathtt{val})\bigr)(V)
      \;\xrightarrow{\ \sim\ }\;
    \bigl(\mathtt{dual}\,((\mathtt{pushforward}\,\beta).\mathtt{obj}\,M.\mathtt{val})\bigr)(V),
  \]
  realised as a single \(\mathtt{LinearEquiv.toModuleIso}\) that packages \emph{both} leg (A)
  --- the slice-Hom base-change reindexing across \(f.\mathtt{opensFunctor}\) --- and leg (B)
  --- the unit codomain ring-iso swap. The naturality of the section family in \(W\) has
  \emph{two} distinct parts: the underlying base-morphism uniqueness in
  \((\mathtt{Over}\,V.\mathrm{unop})^{\mathrm{op}}\) is \(\mathtt{Subsingleton.elim}\) (a thin
  poset has at most one inclusion between objects), but the accompanying equation of
  \(\mathcal{O}_Y(V)\)-module maps is a genuine, separate obligation: it is the
  \(\varepsilon\)-naturality of \(\mathtt{restrictScalars}\) along the structure-ring iso
  \(\beta_W\), which \(\mathtt{Subsingleton.elim}\) does \emph{not} discharge.