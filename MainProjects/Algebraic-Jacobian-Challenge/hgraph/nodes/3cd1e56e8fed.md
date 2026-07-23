---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.universalQuotient
docstring: 'The **universal quotient sheaf** `U` on `Gr(d,r)` (`def:gr_universal_quotient_sheaf`):

  the rank-`d` locally free sheaf obtained by gluing the free rank-`d` chart sheaves

  `O_{U^I}^d` along the bundle transition cocycle `g_{I,J} = (X^I_J)⁻¹`, via the descent

  equalizer `Scheme.Modules.glue`. The (C1) self-identity is `bundleTransition_self`
  and the

  (C2) triple-overlap multiplicativity is `bundleTransition_cocycle`.'
file: AlgebraicJacobian/Picard/GrassmannianQuot.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.universalQuotient
type: lean
updated: '2026-07-24T03:02:11'
---
noncomputable def universalQuotient (d r : ℕ) : (scheme d r).Modules :=
  Scheme.Modules.glue (theGlueData d r)
    (fun I => SheafOfModules.free (R := ((theGlueData d r).U I).ringCatSheaf) (Fin d))
    (bundleTransitionData d r)
    (fun I => bundleTransition_self d r I.1 I.2)
    (fun I J K => bundleTransition_cocycle d r I J K)