---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:cech_nerve_point_iso
lean_status: lean_ok
order: 326
title: Augmentation point isomorphism
type: tex
updated: '2026-07-16T21:14:29'
---
\textit{Project-local.}
  The augmentation point of the {\v C}ech nerve of Definition~\ref{def:cech_nerve} is the value of the
  nerve at the initial augmentation object, namely \((\mathrm{id}_X)_* (\mathrm{id}_X)^* \mathcal{F}\).
  The \emph{augmentation point isomorphism} is the canonical isomorphism
  \[
    (\mathrm{CechNerve}\ \mathcal{U}\ \mathcal{F}).\mathrm{left} \;\cong\; \mathcal{F}
  \]
  obtained by composing the pullback unitor \((\mathrm{id}_X)^* \mathcal{F} \cong \mathcal{F}\) with the
  pushforward unitor \((\mathrm{id}_X)_* \mathcal{G} \cong \mathcal{G}\) of the push--pull adjunction.