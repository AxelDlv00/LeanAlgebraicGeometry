---
author: sync
content_type: lemma
created: '2026-07-24T06:02:13'
decl: AlgebraicGeometry.pushPull_openOverHom_restrict
docstring: The push-pull comparison for an inclusion of opens, with its five-map target
  kept opaque.
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationLegTop.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushPull_openOverHom_restrict
type: lean
updated: '2026-07-24T06:32:13'
---
private lemma pushPull_openOverHom_restrict (F : X.Modules)
    {U W : TopologicalSpace.Opens X} (h : U ≤ W) :
    pushPullMap F (openOverHomOfLE h) ≫
        (Scheme.Modules.pushforward (Scheme.Opens.ι U)).map
          ((Scheme.Modules.restrictFunctorIsoPullback (Scheme.Opens.ι U)).inv.app F) =
      openRestrictChain F h := by
  rw [openOverHomOfLE_eq h, openRestrictChain_eq F h]
  exact @pushPull_toRestrict_comm X
    (Scheme.Opens.toScheme W) (Scheme.Opens.toScheme U)
    (Scheme.Opens.ι W) inferInstance (X.homOfLE h) inferInstance
    (Scheme.Opens.ι U) inferInstance (Scheme.homOfLE_ι X h) F