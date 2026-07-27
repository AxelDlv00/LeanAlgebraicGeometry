---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:cech_augmented_complex
lean_status: lean_ok
order: 329
title: Augmented {\v C}ech complex
type: tex
updated: '2026-07-27T15:50:36'
---
\textit{Project-local.}
  The \emph{augmented {\v C}ech complex} is the cochain complex
  \[
    0 \to \mathcal{F} \to \mathcal{C}^0 \to \mathcal{C}^1 \to \cdots
  \]
  in \(X.\mathrm{Modules}\) obtained by prepending the coefficient sheaf \(\mathcal{F}\) in degree \(0\)
  to the complex of Definition~\ref{def:cech_complex_on_X} along the augmentation
  \(\varepsilon\) of Definition~\ref{def:cech_augmentation}, using the augmentation identity
  \(\varepsilon \cdot d^0 = 0\) of Lemma~\ref{lem:cech_augmentation_comp_d}. Concretely its degree-\(0\)
  term is \(\mathcal{F}\) and its degree-\((p+1)\) term is \(\mathcal{C}^p\). This is the object whose
  exactness is the content of Lemma~\ref{lem:cech_augmented_resolution}.