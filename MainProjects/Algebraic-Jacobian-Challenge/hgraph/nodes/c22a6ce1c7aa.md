---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.DivFamily.isLocallyTrivial_fiber_kernel
docstring: '**The kernel ideal restricts to an invertible ideal on every fibre**

  (Kleiman §3, note after Def. `df:div`, specialised to the fibre inclusion):

  the kernel of the fibre restriction `q_t` of the quotient map is locally

  trivial of rank one.  Instantiation of the divisor base-change theorem

  `Modules.pullback_kernel_isLocallyTrivial`

  (`lem:relative_divisor_base_change`) at Mathlib''s fibre square.'
file: AlgebraicJacobian/Picard/DivDegree.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.isLocallyTrivial_fiber_kernel
type: lean
updated: '2026-07-16T21:14:26'
---
theorem isLocallyTrivial_fiber_kernel {T : Over S} (x : DivFamily π T)
    (t : (T.left : Scheme.{u})) :
    LineBundle.IsLocallyTrivial (Limits.kernel
      ((Scheme.Modules.pullback ((pullback.snd π T.hom).fiberι t)).map x.q)) :=
  Modules.pullback_kernel_isLocallyTrivial
    (IsPullback.of_hasPullback (pullback.snd π T.hom)
      (T.left.fromSpecResidueField t)) x.q x.epi
    (pullback_isQuasicoherent_hom (pullback.fst π T.hom)
      (SheafOfModules.unit X.ringCatSheaf) inferInstance)
    x.isFinitePresentation x.flat x.kerLocallyTrivial