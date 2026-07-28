---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:coverinter_baseChanged_module_iso_tensor
lean_status: lean_ok
order: 520
title: 'Base-change cancellation: the restricted corner module is the tensor base
  change of \(N\)'
type: tex
updated: '2026-07-29T06:43:23'
---
Let \(\varphi : R \to A_\sigma\), \(\rho : A_\sigma \to B\), \(\psi : R \to R'\),
  \(\sigma' : R' \to B\) be commutative-ring homomorphisms forming a pushout (cocartesian)
  square in \(\mathrm{CommRing}\), so that the corner ring is the tensor product
  \(B = A_\sigma \otimes_R R'\) of the two legs over the base \(R\)
  (\cref{lem:commRingCat_isPushout_iff_mathlib}). Let \(N\) be an arbitrary
  \(A_\sigma\)-module. Then there is a canonical isomorphism of \(R'\)-modules
  \[
    \operatorname{restr}_{\sigma'}\bigl(\operatorname{extendScalars}_\rho N\bigr)
      \;\cong\;
    \operatorname{extendScalars}_\psi\bigl(\operatorname{restr}_\varphi N\bigr),
    \qquad\text{i.e.}\qquad
    \operatorname{restr}_{\sigma'}\bigl(B \otimes_{A_\sigma} N\bigr)
      \;\cong\; R' \otimes_R N.
  \]
  This is the pure commutative-algebra cancellation that underlies the geometric corner
  identification of \cref{lem:coverinter_rhs_iso_tilde}; it carries no sheaf, pullback, or
  \(\Gamma\)-content.