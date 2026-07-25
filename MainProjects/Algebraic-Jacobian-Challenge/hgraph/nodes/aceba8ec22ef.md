---
author: sync
chapter: The Quot scheme
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:over_restrict_pullback_iso
lean_status: lean_ok
order: 1104
title: The slice-to-geometric isomorphism in pullback form (gap1, C, step 4')
type: tex
updated: '2026-07-26T00:08:22'
---
\textit{The pullback packaging of the slice-touching bridge; the form consumed by the P1 transport.}
  With \(X\) and \(U \subseteq X\) as above and \(M\) a sheaf of modules on \(X\), the transport of the
  abstract Grothendieck-slice restriction \(M.\mathrm{over}\,U\) under the step-3 equivalence functor
  (\cref{def:over_restrict_equiv}) is canonically isomorphic to the inverse-image (pullback) of \(M\)
  along the open immersion \(U.\iota\):
  \[
    (\mathrm{overRestrictEquiv}\,U).\mathrm{functor}.\mathrm{obj}\,(M.\mathrm{over}\,U)
      \;\cong\; (U.\iota^{*})\,M
  \]
  (\cref{lem:modules_pullback_mathlib}). This is the pullback packaging of the slice-touching bridge
  \cref{lem:over_restrict_iso}; it is exactly the form in which a presentation of
  \(M.\mathrm{over}\,U\) is transported into a presentation of the geometric pullback \(U.\iota^{*}M\),
  and it is the ingredient consumed by the per-element local-tilde transport
  \cref{lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent}.