---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:key_morph
lean_status: lean_ok
order: 270
title: $\Gamma$--$\Spec$ naturality of the localisation immersion, section form
type: tex
updated: '2026-07-24T03:02:14'
---
Let \(g \in R\), write \(R_g = R[g^{-1}]\), let \(\lambda : R \to R_g\) be the localisation map, and let
  \(\iota = \Spec(\lambda) : \Spec R_g \to \Spec R\) be the induced affine morphism (it is the open
  immersion identifying \(\Spec R_g\) with \(D(g) = \iota(\top)\)). Then the restriction to the image
  open \(D(g)\) of the global-sections identification
  \(\theta_R : R \xrightarrow{\sim} \Gamma(\Spec R, \mathcal{O})\) factors as the localisation map
  followed by the global-sections identification of \(\Spec R_g\) and the (inverse) section isomorphism
  of \(\iota\):
  \[
    \rho^{D(g)} \circ \theta_R
    \;=\;
    \beta_\iota^{-1} \circ \theta_{R_g} \circ \lambda,
  \]
  where \(\theta_{R_g} : R_g \xrightarrow{\sim} \Gamma(\Spec R_g, \mathcal{O})\) is the global-sections
  identification of \(\Spec R_g\) and \(\beta_\iota\) is the open-immersion section isomorphism of
  \(\iota\) at \(\top\).